// SPDX-License-Identifier: UNLICENSED
// ** Vas a construir un tablón de tareas público, como un "mini Trello en blockchain".
// ** Cualquiera puede publicar una tarea y, si quiere, ponerle una recompensa en ether. 
// ** Cualquier otra persona puede completarla y, al hacerlo, se lleva la recompensa automáticamente.
// ** Este ejercicio junta TODO lo que hemos visto en clase y añade tres piezas nuevas que ya hemos
// ** nombrado: payable (recibir y enviar ether), mapping (indexar datos por dirección) y 
// ** recorrer arrays con bucles.
/*
   ** Tu solución debe demostrar que sabes:
    ** payable para recibir → crearTarea acepta ether (msg.value) y lo guarda como recompensa.
    ** payable para enviar → al completar, el ether sale del contrato hacia quien completa la tarea.
    ** mapping → tareasPorCreador (dirección → lista de índices) y recompensaGanada (dirección → total).
    ** Recorrer arrays → contarPendientes() y recompensaEnJuego() obligan a usar un bucle for.
    ** require → validar índices y evitar completar una tarea ya completada.
    ** Visibilidad correcta → nada public que pueda ser private/internal; lecturas como view.
*/

pragma solidity ^0.8.0; // Compiler version

contract TaskBoard {
    address public immutable owner;
    bool public paused;

    // enum State { Pending, InProgress, Completed } // Could be implemented...
    struct Task {
        string  description;   // qué hay que hacer
        bool    completed;     // false al crearse
        address created_by;    // quién la publicó
        uint256 reward;        // en wei (puede ser 0)
        address completed_by;  // quién la completó (address(0) si nadie aún)
        bool canceled;
    }


    Task[] private taskList;
    mapping(address => uint256[]) private taskIndexPerCreator;
    mapping(address => uint256) public rewardsPerAddress;
    uint256 private totalRewards;
   
    constructor() {
        owner = msg.sender;
    }

    // Custom errors:
    error InvalidIndex(uint256 index);
    error YouArentTheCreator();
    error UnavailableTask(); // When completed or canceled
    error NoReward();

    // Events:
    event TaskCompleted(uint256 indexed id, address indexed completedBy, uint256 reward);
    event TaskCanceled(uint256 indexed id, address indexed createdBy, uint256 returnedReward);
    event PausedContract(bool paused);


    // Modifiers:
    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }
    modifier validIndex(uint256 _index){
        if(taskList.length < _index) revert InvalidIndex(_index);
        _;
    }
    modifier onlyCreator(uint256 _index){
        if(msg.sender != getTask(_index).created_by) revert YouArentTheCreator();
        _;
    }
    modifier notPaused(){
        require(!paused, "The contract is currently paused");
        _;
    }
    // (pausar)
    function pause() public onlyOwner {
        paused = true;
        emit PausedContract(paused);
    }
    // (reanudar)
    function resume() public onlyOwner {
        paused = false;
        emit PausedContract(paused);
    }

    // cancelarTarea(uint256 _i) public indiceValido(_i), soloCreador(_i)
    // removed modifier indiceValido [validIndex(_i)]: in my case, it doesn't make sense to add this validation because the onlyCreator validates the task existence
    function cancelTask(uint256 _index) public onlyCreator(_index) { 
        taskList[_index].canceled = true;
        if(taskList[_index].reward > 0) {
            totalRewards -= taskList[_index].reward;
            rewardsPerAddress[taskList[_index].created_by] -= taskList[_index].reward;
            (bool success, ) = payable(taskList[_index].created_by).call{value: taskList[_index].reward}("");
            require(success, "Reward couldn't be returned.");
        }
        emit TaskCanceled(_index, taskList[_index].created_by, taskList[_index].reward);
    }

    // (crearTarea) Crea una tarea nueva: completada = false, creador = msg.sender, recompensa = msg.value, completadaPor = address(0).
    // La añade al array y guarda su índice en tareasPorCreador[msg.sender].
    function createTask(string memory _description) public payable notPaused {
        require(bytes(_description).length > 0, "Description is requierd.");
        taskList.push(
            Task({
                description: _description
                , completed: false
                , created_by: msg.sender
                , reward: msg.value
                , completed_by: address(0)
                , canceled: false
            })
        );
        if(msg.value > 0) {
            rewardsPerAddress[msg.sender] += msg.value;
            totalRewards += msg.value;
        }
        taskIndexPerCreator[msg.sender].push(taskList.length-1);
    }
    // (completar) Valida el índice con require (usando _valido). Marca la tarea como completada, guarda quién la completó.
    // Si tiene recompensa > 0, envía ese ether a quien completa y suma la cantidad en recompensaGanada. No se puede completar dos veces.
    function complete(uint256 _index) public validIndex(_index) notPaused {
        // require(taskList[_index].completed == false, "Task is already completed");
        if (taskList[_index].completed || taskList[_index].canceled) revert UnavailableTask();


        taskList[_index].completed = true;
        taskList[_index].completed_by = msg.sender;
        if(taskList[_index].reward > 0) {
            totalRewards -= taskList[_index].reward;
            rewardsPerAddress[taskList[_index].created_by] -= taskList[_index].reward;
            (bool success, ) = payable(msg.sender).call{value: taskList[_index].reward}("");
            require(success, "Reward couldn't be transfered.");
        }
        emit TaskCompleted(_index, msg.sender, taskList[_index].reward);
    }
    // (verTarea) Devuelve los 5 campos de la tarea: descripción, completada, creador, recompensa, completadaPor.
    function getTask(uint256 _index) public view validIndex(_index) returns(Task memory) {
        return taskList[_index];
    }
    // (totalTareas) Devuelve cuántas tareas hay en total.
    function getTotalTasks() public view returns(uint256){
        return taskList.length;
    }
    // (tareasDe) Devuelve el array uint256[] con los índices de las tareas creadas por esa dirección (léelo del mapping).
    function getTasksByOwner(address _address) public view returns(Task[] memory){
        uint256[] memory ownerList = taskIndexPerCreator[_address];


        Task[] memory filteredList = new Task[](ownerList.length);


        for (uint256 i = 0; i < ownerList.length; i++){
            filteredList[i] = taskList[ownerList[i]];
        }
        return filteredList;
    }
    // (contarPendientes) Recorre el array y devuelve cuántas tareas siguen sin completar.
    function countPendingTasks() public view returns(uint256){
        // ADVERTENCIA: Este bucle podría fallar si la 'taskList' crece demasiado.
        // * Alternativa: sería mejor usar un contador global ('uint256 public pendingCount')
        // * que sume al crear y reste al completar, eliminando el bucle por completo.


        uint256 pendingCount = 0;


        for (uint256 i = 0; i < taskList.length; i++){
            if(!taskList[i].completed) {
                pendingCount++;
            }
        }


        return pendingCount;
    }
    // (recompensaEnJuego) Recorre el array y devuelve la suma de las recompensas de todas las tareas aún no completadas (el ether que sigue "en el bote").
    function totalPendingRewards() public view returns(uint256){
        /*
            uint256 totalRewards = 0;
            for (uint256 i = 0; i < taskList.length; i++){
                if(!taskList[i].completed) {
                    totalRewards += taskList[i].reward;
                }
            }
            return totalRewards;


        */
        return totalRewards; // Used other approach to reduce gas
    }

}

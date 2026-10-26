// SPDX-License-Identifier: UNLICENSED
// **Contrato de "Hola Mundo" en Soladity

pragma solidity ^0.8.0; // Elegir la versión del compilador

contract HolaMundo {
    string private mensaje = "Hola, mundo";
    address private owner;
    enum State { Inactive, Active, Pending }
    struct ToDo {
        string text;
        bool completed;
    }

    State public currentState;
    ToDo[] public taskList;

    mapping(address => uint256) private balances;

    constructor() {
        owner = msg.sender;
        currentState = State.Inactive;
    }

    function establecerMensaje(string calldata _texto) public {
        require(owner==msg.sender, "Solo el 'Owner' puede modificar este valor");
        mensaje = _texto;
    }
    function establecerMensajePagando(string calldata _texto) public payable {
        require(msg.value == 1 ether, "Se requiere 1 ether para cambiar el mensaje"); // Requiere que sea de 1 ether
        mensaje = _texto;
    }
    function obtenerMensaje() public view returns (string memory) {
        return mensaje;
    }
    function obtenerOwner() public view returns (address) {
        return owner;
    }
    function moreThanOneEther() private view returns (bool) {
            if (msg.sender.balance >= 1 ether) {
                return true;
            }
            return false;
    }
    function generateHash(string memory _msg) public pure returns(bytes32){
        bytes32 hash = keccak256(abi.encodePacked(_msg));
        return hash;
    }
    function getState() public pure returns(State){
        return State.Active;
    }
    function switchState() public {
        if(currentState == State.Active){
            currentState = State.Inactive;
        }
        else {
            currentState = State.Inactive;
        }
        
    }

    function createTask(string calldata _text, bool state) public  {
        taskList.push(ToDo({text: _text, completed: state}));
        // ToDo memory lista;
        // lista.text = _text;
        // lista.completed = state;

        // taskList.push(lista);
    }

    function getTaskSize() public view returns(uint256) {
        return taskList.length;
    }

    function addBalance(address _address, uint256 _amount) public {
        balances[_address] = _amount;
    }

}
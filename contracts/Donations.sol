// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ContratoDonaciones {
    address public organizacionBeneficiaria;
    // uint256 public totalDonado;
    event DonacionRecibida(address indexed donante, uint256 donacion);
    event FondosRetirados(uint256 donacion);

    constructor(address _organizacion) {
        organizacionBeneficiaria = _organizacion;
    }

    receive() external payable {
        emit DonacionRecibida(msg.sender, msg.value);
    }

    function hacerDonacion() public payable {
        require(msg.value > 0, "La donacion debe ser mayor que cero");
        emit DonacionRecibida(msg.sender, msg.value);
    }

    function retirarFondos() public {
        require(msg.sender == organizacionBeneficiaria, "Solo la organizacion puede retirar fondos");
        // Realiza la transferencia de fondos a la organización
        // payable(organizacionBeneficiaria).transfer(address(this).balance); // DEPRECATED
        // TODO: retirar fondos
        emit FondosRetirados(address(this).balance);
    }

}
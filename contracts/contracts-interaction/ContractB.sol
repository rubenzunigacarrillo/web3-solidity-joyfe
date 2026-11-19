// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ContractA.sol";

contract ContractB {
    ContractA public contractA;

    // Constructor que inicializa la dirección de ContractA
    constructor(address _contractAAddress) {
        contractA = ContractA(_contractAAddress);
    }

    // Función para interactuar con setValue en ContractA
    function callSetValue(uint256 _value) external {
        contractA.setValue(_value);
    }

    // Función para interactuar con getValue en ContractA
    function callGetValue() external view returns (uint256) {
        return contractA.getValue();
    }
}
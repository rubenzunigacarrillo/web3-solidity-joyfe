// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IContractA.sol";

contract ContractA {
    uint256 public value;

    // Función para establecer un valor
    function setValue(uint256 _value) external {
        value = _value;
    }

    // Función para obtener el valor
    function getValue() external view returns (uint256) {
        return value;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ICalculadora.sol";

contract ClienteCalculadora {
    function calcularTotal(address direccionCalculadora, uint256 x, uint256 y) external pure returns (uint256) {
        return ICalculadora(direccionCalculadora).sumar(x, y);
    }
}
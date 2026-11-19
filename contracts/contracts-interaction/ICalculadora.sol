// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ICalculadora
 * @dev Interfaz para interactuar con el contrato Calculadora desde otros smart contracts.
 */
interface ICalculadora {
    function sumar(uint256 a, uint256 b) external pure returns (uint256);
    // function restar(uint256 a, uint256 b) external pure returns (uint256);
    // function multiplicar(uint256 a, uint256 b) external pure returns (uint256);
    // function dividir(uint256 a, uint256 b) external pure returns (uint256);
    // function modulo(uint256 a, uint256 b) external pure returns (uint256);
    // function potencia(uint256 base, uint256 exponente) external pure returns (uint256);
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CalculadoraSinEstado
 * @dev Smart contract que realiza operaciones matemáticas básicas sin almacenar estado.
 * Todas las funciones son 'pure' para garantizar que no leen ni modifican la blockchain.
 */
contract Calculadora {

    // Suma dos números enteros sin signo
    function sumar(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    // Resta b de a (revierte automáticamente si b > a por underflow en Solidity ^0.8.0)
    function restar(uint256 a, uint256 b) public pure returns (uint256) {
        require(a >= b, "Error: El resultado no puede ser negativo");
        return a - b;
    }

    // Multiplica dos números
    function multiplicar(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    // Divide a entre b (división entera)
    function dividir(uint256 a, uint256 b) public pure returns (uint256) {
        require(b > 0, "Error: Division por cero no permitida");
        return a / b;
    }

    // Devuelve el residuo (módulo) de dividir a entre b
    function modulo(uint256 a, uint256 b) public pure returns (uint256) {
        require(b > 0, "Error: Modulo por cero no permitido");
        return a % b;
    }

    // Calcula la potencia (base^exponente)
    function potencia(uint256 base, uint256 exponente) public pure returns (uint256) {
        return base ** exponente;
    }
}

// SPDX-License-Identifier: UNLICENSED
/*
    CALCULADORA
*/

pragma solidity ^0.8.0;

contract Calculadora {
    uint256 private lastResult = 0;

    function sum(uint256 a, uint256 b) public pure returns (uint256) {
        // lastResult = a+b;
        // return lastResult;
        return a+b;
    }
    function substract(uint256 a, uint256 b) public pure returns (uint256) {
        // lastResult = a-b;
        // return lastResult;
        return a-b;
    }
    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        // lastResult = a*b;
        // return lastResult;
        return a*b;
    }
    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        // if(b==0) return 0;
        require(b!=0, "No puedes dividir entre 0.");
        return a/b;
    }
    
}
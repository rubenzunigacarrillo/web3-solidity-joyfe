// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;

    // Constructor que inicializa la dirección de ContractA
    constructor(address _contractAAddress) {
        contractAAddress = _contractAAddress;
    }

    // Ejemplo de uso de una ABI codificada manualmente para llamar a setValue (Application Binary Interface)
    function callSetValue(uint256 _value) external {
        (bool success, ) = contractAAddress.call(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        require(success, "Call failed");
    }

    // Ejemplo de uso de una ABI codificada manualmente para llamar a getValue
    function callGetValue() external view returns (uint256) {
        (bool success, bytes memory data) = contractAAddress.staticcall(
            abi.encodeWithSignature("getValue()")
        );
        require(success, "Call failed");
        return abi.decode(data, (uint256));
    }

    
    function calcularTotal(address calculatorDir, uint256 x, uint256 y) external view returns (uint256) {
        (bool success, bytes memory data) = calculatorDir.staticcall(
            abi.encodeWithSignature("sumar(uint2456, uint256)", x, y)
        );
        require(success, "Call failed");
        return abi.decode(data, (uint256));
    }
}

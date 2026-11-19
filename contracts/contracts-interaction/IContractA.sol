// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IContractA {
    function setValue(uint256 _value) external;
    function getValue() external view returns (uint256);
}
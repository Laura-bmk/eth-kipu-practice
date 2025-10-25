// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

interface IOracle {
    function latestAnswer() external view returns(int256); // 0x694AA1769357215DE4FAC081bf1f309aDC325306 => sepolia
}
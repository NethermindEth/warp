pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for Contracts
import { parent } from './importfrom.sol';

contract child is parent{
    function getValue() external view returns(uint) {
        return sum; 
    } 
}

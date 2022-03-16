// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WARP {   
    bool public flag = true;

    function boolean(bool input) pure public returns (bool){
        bool x = input;
        delete x;
        return x;
    }

    function deleteFlag() public {
        delete flag;
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WARP {   
    bool flag = true;

    function boolean() public returns (bool){
        bool x = true;
        delete flag;
        return x && flag;
    }
}

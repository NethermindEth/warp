pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

contract A {
    event Transfer(address indexed a, address b, uint256 indexed c);
    
    function transfer() public {
        emit Transfer(address(0x776), address(0x777), 256);
    }
}

contract B {
    event Transfer(address a, address indexed b, uint256 indexed c);
    
    function transfer() public {
        emit Transfer(address(0x777), address(0x776), 256);
    }
}

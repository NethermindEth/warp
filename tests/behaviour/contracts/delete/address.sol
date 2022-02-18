// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WARP {

    mapping(address => uint256) public _balances;

    function f() public returns (uint256) {
        address zeroAddr = address(0);
        _balances[zeroAddr] = 10;

        address payable x = payable(address(0x123));
        address myAddress = address(0x25);
        delete x;
        delete myAddress;

        _balances[x] += 12;
        _balances[myAddress] += 1;
        return _balances[zeroAddr];
    }
}

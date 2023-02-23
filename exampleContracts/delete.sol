// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract DeleteExample {
    uint data;
    uint[] dataArray;
    mapping(address => uint256) public _balances;

    struct Point{
        uint x;
        uint y;
    };

    function f() public {
        uint x = data;
        _balances[0] = 1;
        delete x; // sets x to 0, does not affect data
        delete data; // sets data to 0, does not affect x
        delete _balances;
        delete _balances[0];
        uint[] storage y = dataArray;
        delete dataArray;
        assert(y.length == 0);
    }
}
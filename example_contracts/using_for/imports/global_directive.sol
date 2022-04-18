// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

import "./user_defined.sol" as Library;

contract B{
    Library.BB  public a;
    function foo(uint256) public view returns (uint256) {
        return a.foog();
    }
}

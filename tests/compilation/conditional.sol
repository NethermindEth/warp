// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract Warp {
    bool globalStatus = false;

    function test(bool x, bool y) public view  returns (bool) {
        return x ? (x && y) : (y ? aux() : !aux());
    }

    function aux() public view returns (bool) {
        return globalStatus;
    }
}

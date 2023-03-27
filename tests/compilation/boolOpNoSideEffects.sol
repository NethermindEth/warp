// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract Warp {
    bool globalStatus = false;

    function test(bool x, bool y) public view  returns (bool) {
        bool v1 = x || y;
        bool v2 = x && y;
        bool v3 = (x && y) || (v1 && v2);

        if (v1 && v2 && v3 || aux()) {
            return v1;
        }

        return v3;
    }

    function aux() public view returns (bool) {
        return globalStatus;
    }
}

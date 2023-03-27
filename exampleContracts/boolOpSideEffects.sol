 // SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract Warp {
    bool globalStatus = false;

    function test() public returns (bool) {
        bool v1 = true;
        bool v2 = false;

        bool result = v1 && (v2 && aux());

        return result;
    }

    function aux() public returns (bool) {
        globalStatus = !globalStatus;
        return globalStatus;
    }
}

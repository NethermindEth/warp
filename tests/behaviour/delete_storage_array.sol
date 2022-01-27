// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
    uint256[] data;

    function len() public returns (uint256 ret) {
        data.push(234);
        data.push(123);
        delete data;
        assembly {
            ret := sload(data.slot)
        }
    }

    function val() public returns (uint256 ret) {
        assembly {
            sstore(0, 2)
            mstore(0, 0)
            sstore(pedersen(0, 32), 234)
            sstore(add(pedersen(0, 32), 1), 123)
        }

        assert(data[0] == 234);
        assert(data[1] == 123);

        delete data;

        uint256 size = 999;

        assembly {
            size := sload(0)
            mstore(0, 0)
            ret := sload(pedersen(0, 32))
        }
    }
}

// ====
// compileViaYul: also
// ----
// len() -> 0
// val() -> 0

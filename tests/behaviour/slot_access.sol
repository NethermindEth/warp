// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
    struct S {
        uint256 a;
        uint256 b;
    }

    mapping(uint256 => S) public mappingAccess;

    function data() internal view returns (S storage _data) {
        // We need to assign it from somewhere, otherwise we would
        // get an "uninitialized access" error.
        _data = mappingAccess[20];

        assembly {
            mstore(0, 1)
            mstore(32, 0)
            let slot := pedersen(0, 64)
            _data.slot := slot
        }
    }

    function set(uint256 x) public {
        data().a = x;
    }

    function get() public view returns (uint256) {
        return data().a;
    }
}
// ====
// compileViaYul: also
// ----
// get() -> 0
// mappingAccess(uint256): 1 -> 0, 0
// set(uint256): 4
// get() -> 4
// mappingAccess(uint256): 1 -> 4, 0

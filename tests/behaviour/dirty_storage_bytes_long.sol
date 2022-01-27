// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
    bytes b;

    function f() public returns (bool correct) {
        assembly {
            sstore(b.slot, 0x41)
            mstore(0, b.slot)
            sstore(pedersen(0, 0x20), "deadbeefdeadbeefdeadbeefdeadbeef")
        }
        bytes1 s = b[31];
        uint256 r;
        assembly {
            r := s
        }
        correct = r == (0x66 << 248);
    }
}
// ====
// compileViaYul: also
// ----
// f() -> true

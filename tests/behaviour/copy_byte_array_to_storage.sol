pragma solidity ^0.8.6;

function dataslot() pure returns (bytes32 r) {
    assembly {
        mstore(0, 1)
        r := pedersen(0, 4)
    }
    return r;
}

function readDataSlot(uint256 offset) view returns (bytes32 r) {
    bytes32 s = dataslot();
    assembly {
        r := sload(add(s, offset))
    }
}

function readDataSlot() view returns (bytes32) {
    return readDataSlot(0);
}

function readHead() view returns (bytes32 r) {
    assembly {
        r := sload(1)
    }
}

contract WARP {
    uint256 padding;
    bytes data;

    function f() public returns (uint256) {
        bytes32 zero;
        if (!(readDataSlot() == zero)) return 1;
        data = "abc";
        if (!(readDataSlot() == zero)) return 2;
        data = "1234567890123456789012345678901234567890123456789012345678901234567890";
        if (!(readDataSlot() != zero)) return 3;
        if (!(readDataSlot(1) != zero)) return 4;
        if (!(readDataSlot(2) != zero)) return 5;
        if (!(readDataSlot(3) == zero)) return 6;
        if (!(readDataSlot(4) == zero)) return 7;
        data = "abc";
        if (!(readDataSlot() == zero)) return 8;
        if (!(readDataSlot(1) == zero)) return 9;
        if (!(readDataSlot(2) == zero)) return 10;
        if (!(readDataSlot(3) == zero)) return 11;
        data = "1234567890123456789012345678901234567890123456789012345678901234567890";
        data = "123456789012345678901234567890123456";
        if (!(readDataSlot() != zero)) return 12;
        if (!(readDataSlot(1) != zero)) return 13;
        if (!(readDataSlot(2) == zero)) return 14;
        if (!(readDataSlot(3) == zero)) return 15;
        return 0xff;
    }
}
// ====
// compileViaYul: also
// ----
// f() -> 0xff
// gas irOptimized: 122009
// gas legacy: 126745
// gas legacyOptimized: 123476

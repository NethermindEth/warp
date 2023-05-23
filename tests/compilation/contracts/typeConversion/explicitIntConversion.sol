pragma solidity ^0.7.6;

contract WARP {

    function conversions() public pure {
        uint8   x1 = 1;
        uint16  x2 = uint16(x1);
        int32   x3 = int32(x2);
        int64   x4 = int64(x3);
        uint128 x5 = uint128(x4);
        uint64  x6 = uint64(x5);
        int32   x7 = int32(x6);
        int16   x8 = int16(x7);
        uint8   x9 = uint8(x8);
    }
}

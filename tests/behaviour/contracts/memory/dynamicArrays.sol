pragma solidity ^0.8.6;

//SPDX-License-Identifier

contract WARP {
    function uint8writes() pure public returns (uint8) {
        uint8[] memory arr = new uint8[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        uint8 copy1 = arr[0];
        uint8 copy2 = arr[4];
        uint8 copy3 = arr[2];
        arr[0] = 6;
        arr[2] = 7;
        arr[4] = 8;
        assert(arr[0] == 6);
        assert(arr[1] == 2);
        assert(arr[2] == 7);
        assert(arr[3] == 4);
        assert(arr[4] == 8);
        assert(copy1 == 1);
        assert(copy2 == 5);
        assert(copy3 == 3);
        // //Should be 6+2+7+4+8+ 2(1+3+5) = 45
        return arr[0] + arr[1] + arr[2] + arr[3] + arr[4] + 2 * (copy1 + copy2 + copy3);
    }

    function uint256writes() pure public returns (uint256) {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        uint256 copy1 = arr[0];
        uint256 copy2 = arr[4];
        uint256 copy3 = arr[2];
        arr[0] = 6;
        arr[2] = 7;
        arr[4] = 8;
        assert(arr[0] == 6);
        assert(arr[1] == 2);
        assert(arr[2] == 7);
        assert(arr[3] == 4);
        assert(arr[4] == 8);
        assert(copy1 == 1);
        assert(copy2 == 5);
        assert(copy3 == 3);
        // //Should be 6+2+7+4+8+ 2(1+3+5) = 45
        return arr[0] + arr[1] + arr[2] + arr[3] + arr[4] + 2 * (copy1 + copy2 + copy3);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    function staticSimple() public pure returns (bytes memory) {
        uint8[3] memory a = [2, 3, 5];
        return abi.encode(a);
    }

    function staticNested() public pure returns (bytes memory) {
       uint8[2][2] memory a = [[2, 3], [4, 5]];
        return abi.encode(a);
    }

    function staticDynamicNested() public pure returns (bytes memory) {
        uint8[][2] memory a = [new uint8[](2), new uint8[](1)];
        a[0][0] = 2;
        a[0][1] = 3;
        a[1][0] = 11;
        return abi.encode(a);
    }
}

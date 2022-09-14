// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    function getSimpleDynamicArray() private pure returns (uint8[] memory) {
        uint8[] memory a = new uint8[](3);
        a[0] = 2;
        a[1] = 3;
        a[2] = 5;
        return a;
    }

    function getNestedDynamicArray() private pure returns (uint256[][] memory) {
        uint256[][] memory a = new uint256[][](2);
        a[0] = new uint256[](3);
        a[0][0] = 2;
        a[0][1] = 3;
        a[0][2] = 5;
        a[1] = new uint256[](2);
        a[1][0] = 7;
        a[1][1] = 11;
        return a;
    }

    function simpleDynamic() public pure returns (bytes memory) {
        uint8[] memory a = getSimpleDynamicArray();
        return abi.encode(a);
    }

    function nestedDynamic() public pure returns (bytes memory) {
        uint256[][] memory a = getNestedDynamicArray();
        return abi.encode(a);
    }

    function mixDynamic() public pure returns (bytes memory) {
        uint256[][] memory a = getNestedDynamicArray();
        uint8[] memory b = getSimpleDynamicArray();
        return abi.encode(a, b);
    }
}

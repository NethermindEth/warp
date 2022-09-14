// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    function stringEncoding() public pure returns (bytes memory) {
        string memory s = "hola";
        return abi.encode(s);
    }

    function emptyString() public pure returns (bytes memory) {
        return abi.encode("");
    }

    function docsExample() public pure returns (bytes memory) {
        uint256[][] memory m = new uint256[][](2);
        m[0] = new uint256[](2);
        m[0][0] = 1;
        m[0][1] = 2;
        m[1] = new uint256[](1);
        m[1][0] = 3;

        string[] memory s = new string[](3);
        s[0] = "one";
        s[1] = "two";
        s[2] = "three";

        return abi.encode(m, s);
    }
}

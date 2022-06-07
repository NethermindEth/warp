pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

contract WARP {
    function f(string memory x) private pure returns (string memory) {
        return x;
    }

    function varDecl() public pure returns (string memory) {
        string memory x = "WARP";
        return x;
    }

    function tupleRet() public pure returns (string memory, string memory) {
        return ("WA", "RP");
    }

    function funcCall() public pure returns (string memory) {
        return varDecl();
    }

    function funcCallWithArg() public pure returns (string memory) {
        return f("WARP");
    }

    function nestedFuncCallWithArg() public pure returns (string memory) {
        return f(f("WARP"));
    }
}
pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

contract WARP {
    function f(string memory x) private pure returns (string memory) {
        return x;
    }

    function plainLiteral() public pure {
        "WARP";
    } 

    function returnLiteral() public pure returns (string memory) {
        return "WARP";
    }

    function varDecl() public pure returns (string memory) {
        string memory x = "WARP";
        return x;
    }

    function literalAssignmentToMemoryFromParams(string memory x) public pure returns (string memory) {
        x = "WARP";
        return x;
    }

    function tupleRet() public pure returns (string memory, string memory) {
        return ("WA", "RP");
    }

    function funcCallWithArg() public pure returns (string memory) {
        return f("WARP");
    }

    function nestedFuncCallWithArg() public pure returns (string memory) {
        return f(f("WARP"));
    }
}
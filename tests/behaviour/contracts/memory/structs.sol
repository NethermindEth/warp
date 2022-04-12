pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
    struct S {
        uint8 a;
        uint256 b;
    }

    function createDefault() pure public returns (uint8, uint256) {
        S memory s;
        return (s.a, s.b);
    }

    function createManual(uint8 a, uint256 b) pure public returns (uint8, uint256) {
        S memory s = S(a,b);
        return (s.a, s.b);
    }

    function writeMembers(uint8 a, uint256 b) pure public returns (uint8, uint256) {
        S memory s;
        s.a = a;
        s.b = b;
        return (s.a, s.b);
    }

    function references(uint8 a, uint256 b) pure public returns (uint8, uint256) {
        S memory s1;
        S memory s2 = s1;
        s2.a = a;
        s2.b = b;
        return (s1.a, s1.b);
    }

    function input(S memory s) pure public returns (uint8, uint256) {
      s.a += 1;
      s.b += 1;
      return (s.a, s.b);
    }

    function ouptut(uint8 a, uint256 b) pure public returns (S memory) {
      return S(a,b);
    }
}

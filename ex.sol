pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  struct T {
    uint a;
  }
  struct S {
    uint a;
    T t;
    uint[] arr;
    T[] Tarr;
  }

  S s;
  mapping(uint => T) map;

  function test(uint a, S storage s1, S memory s2, S calldata s3, T storage t1, T memory t2, T calldata T3, uint[] memory arr) internal {
  }

  function calls(T calldata t, S calldata s1) external {
    S storage localS = s;
    map[0] = T(4);
    // map[1] = T({a: 5});
    // T memory memT = T(6);
    // test(0, s, S(0, map[1], new uint[](0), new T[](0)), s1, map[0], T(2), t, new uint[](3));
  }
}
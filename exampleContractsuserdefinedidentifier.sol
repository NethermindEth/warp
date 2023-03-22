pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT
contract WARP {
  type T is uint8;
  function first() pure public {
    T t = T.wrap(3);
    second(t);
    third(3);
  }
  function second(T t) pure internal {
    //...
  }
  function third(uint8 t) pure internal {
    //...
  }
}
pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function forLoop(uint8 bound) public pure returns (uint8) {
    uint8 x = 1;
    for (uint8 i = 0; i < bound; ++i) {
      x *= 2;
    }

    return x;
  }

  function whileLoop(uint8 target) public pure returns (uint8) {
    uint8 x = 0;
    while (x != target) {
      x++;
    }
    return x;
  }

  function innerReturn(uint8 target) public pure {
    uint8 x = 0;
    while (x != target) {
      return;
    }
    revert();
  }

  function breaks(uint8 target) public pure returns (uint8) {
    uint8 x = 0;
    while (x != target * 2) {
      if (x == target) break;
      ++x;
    }
    return x;
  }

  function continues(uint8 count) public pure returns (uint8) {
    uint8 x = 3;
    for (uint8 i = 0; i < count; ++i) {
      if (i == 2) continue;
      x *= 2;
    }
    return x;
  }

  function doWhile(uint8 init, uint8 target) public pure returns (uint8) {
    do {
      init++;
    } while (init <= target);

    return init;
  }

  function doWhile_break(uint8 init, uint8 target) public pure returns (uint8) {
    do {
      if (init == target) break;
      init++;
    } while (init <= target * 2);

    return init;
  }

  function doWhile_continue(uint8 target) public pure returns (uint8) {
    uint8 x = 0;

    do {
      x++;
      if (x == target) continue;
    } while (x != target);

    return x;
  }

  function doWhile_return(uint8 target) public pure returns (uint8) {
    uint8 x = 0;

    do {
      x++;
      if (x == 2) {
        return x;
      }
    } while (x <= target);

    return x;
  }
}

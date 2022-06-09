pragma solidity ^0.8.14;

contract WARP {
    modifier m() {
      _;
      return;
    }

    function returnFiveThroughModifiers() m m public returns (uint8) {
      return 5;
    }
}

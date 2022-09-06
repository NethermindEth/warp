pragma solidity ^0.8.10;

library SafeCast {
  function toUint160(uint256 y) internal pure returns (uint160 z) {
    require((z = uint160(y)) == y);
  }
}

library lib1 {
  using SafeCast for uint256;

  function f(uint256 x) external pure {
    uint160 f0 = x.toUint160();
  }
}

library lib2 {
  function g(uint256 x) external pure {
    lib1.f(x);
  }
}

contract C {
  function fCaller() external pure {
    lib2.g(5);
  }
}

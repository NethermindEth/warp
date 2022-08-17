pragma solidity ^0.8.6;

contract WARP {
  function f(uint256 value) public pure returns (uint256[] memory) {
    uint256 x = g(value);
    (uint256 a, uint256 b, uint256 c) = h(x + 3, x * 2, x - 5);
    uint256[] memory y = new uint256[](3);
    y[0] = a;
    y[1] = b;
    y[2] = c;
    return y;
  }

  function g(uint256 val) private pure returns (uint256) {
    return val;
  }

  function h(
    uint256 a,
    uint256 b,
    uint256 c
  )
    internal
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    return (b, c, a);
  }
}

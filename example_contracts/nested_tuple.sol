pragma solidity ^0.8.10;

contract WARP {
  function f()
    public
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    bytes memory a;
    bytes memory b;
    bytes memory c;
    (a, (b, c)) = ('0', ('1', '2'));
    return (uint8(a[0]), uint8(b[0]), uint8(c[0]));
  }
}

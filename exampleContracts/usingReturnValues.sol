pragma solidity ^0.8.6;

//SPDX-Licence-Identifier: MIT

contract WARP {
  int x;

  function scalarReturn() pure public returns (int8) {
    return 3;
  }

  function tupleReturn() pure public returns (int32, int16) {
    return (4,5);
  }

  function useReturns() public {
    (int32 a, int16 b) = tupleReturn();
    int8 c = scalarReturn();
    x = (a*c) + (b*scalarReturn());
  }
}

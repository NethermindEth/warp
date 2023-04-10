pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract Warp {
  function literalOperations() pure public {
    int8 x = (-1/3)*3;
    int256 y = (2e800 ether/3e799)*6;
    int256 z = x + y;

    uint8 a = (5 ** 2) / 10 - .5;
    uint32 b = ((5/7) % (2/3))*21;
    int32 c = ((-5/7) % (2/3))*21;
    int32 d = ((5/7) % (-2/3))*21;
    int32 e = ((-5/7) % (-2/3))*21;

    int256 f = (2e800)/(2e800);

    assert ( 3 < 3 + 1);
    assert ( 3 >= 4 != 4>3);
    assert ( true );
    assert ( !false );
    assert ( x == -1);
    assert ( y == 4e17);
    assert ( z == 4e17 - 1);
  }
}
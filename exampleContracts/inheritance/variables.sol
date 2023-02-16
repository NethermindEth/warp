pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract Base1 {
  uint8 x;
}

contract Base2 {
  uint8 y;
}

contract Mid1 is Base1 {
  uint8 z;
}

contract Mid2 is Base1 {
  uint8 a;
}

contract Derived is Mid1, Mid2, Base2 {
  uint8 b;

  function test() view public {
    a;
    b;
    x;
    y;
    z;
    Mid1.z;
    Mid2.a;
    Base2.y;
    Base1.x;
  }
}

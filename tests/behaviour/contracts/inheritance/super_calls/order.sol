// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract A {
  constructor() {
    val = 1000;
  }

  uint256 public val;
}

contract B is A {
  function f() public virtual returns (uint256) {
    val = 1;
    return val;
  }
}

contract Base1 is B {
  function f() public virtual override returns (uint256) {
    val = 2;
    return val;
  }
}

contract Base2 is B {
  function f() public virtual override returns (uint256) {
    val = 3;
    return val;
  }
}

contract Base3 is Base2 {}

contract Final is Base2, Base1, Base3 {
  function f() public override(Base1, Base2) returns (uint256) {
    return super.f();
  }
}

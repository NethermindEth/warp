// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract A {
  constructor() {
    val = 1000;
  }

  uint256 public val;
}

contract B is A {
  function g() public virtual returns (uint256) {
    val = 100;
    return val;
  }
}

contract Base1 is B {
  function g() public virtual override returns (uint256) {
    val = 50;
    return val;
  }
}

contract Base2 is B {
  function g() public virtual override returns (uint256) {
    val = 75;
    return val;
  }
}

contract Base3 is Base2 {}

contract Final is Base2, Base1, Base3 {
  modifier m(uint256 v) {
    uint256 y = super.g();
    require(v >= y);
    _;
  }

  function f(uint256 a) public m(a) returns (uint256) {
    return val;
  }

  function g() public override(Base1, Base2) returns (uint256) {
    val = 350;
    return val;
  }
}

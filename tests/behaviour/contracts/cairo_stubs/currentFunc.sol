pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract Base {
  ///warp-cairo
  ///DECORATOR(external)
  ///func CURRENTFUNC()() -> (res: felt):
  ///    return (1)
  ///end
  function externalDefinedInBase() virtual pure external returns (uint8) {
    return 0;
  }

  ///warp-cairo
  ///func CURRENTFUNC()() -> (res: felt):
  ///    return (2)
  ///end
  function internalDefinedInBase() virtual pure internal returns (uint8) {
    return 0;
  }
}

contract WARP is Base {
  function testExternalDefinedInBase() view public returns (uint8) {
    return this.externalDefinedInBase();
  }

  function testInternalDefinedInBase() pure public returns (uint8) {
    return internalDefinedInBase();
  }

  ///warp-cairo
  ///DECORATOR(external)
  ///func CURRENTFUNC()() -> (res: felt):
  ///    return (1)
  ///end
  function simpleCase() pure external returns (uint8) {
    return 0;
  }

  ///warp-cairo
  ///DECORATOR(external)
  ///func CURRENTFUNC()(lhs : felt, rhs : felt) -> (res : felt):
  ///    if lhs == 0:
  ///        return (rhs)
  ///    else:
  ///        return CURRENTFUNC()(lhs - 1, rhs + 1)
  ///    end
  ///end
  function recursiveAdd(uint8 lhs, uint8 rhs) pure external returns (uint8) {
    return 0;
  }
}

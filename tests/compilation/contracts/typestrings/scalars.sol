pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

contract Other {
}
enum Enum {
  A
}

type udvt is uint16;

contract WARP {
  bool stateBool;
  int stateInt;
  address stateAddress;
  address payable stateAddressPayable;
  Other stateContract;
  bytes8 stateFixedBytes;
  Enum stateEnum;
  udvt stateUdvt;

  function scalars() external {
    bool localBool;
    int localInt;
    address localAddress;
    address payable localAddressPayable;
    bytes8 localFixedBytes;
    Enum localEnum;
    udvt localUdvt;

    stateBool;
    localBool;

    stateInt;
    localInt;

    stateAddress;
    localAddress;

    stateAddressPayable;
    localAddressPayable;

    stateContract;
    Other localContract;
    localContract;

    stateFixedBytes;
    localFixedBytes;

    stateEnum;
    localEnum;

    stateUdvt;
    localUdvt;
  }
}

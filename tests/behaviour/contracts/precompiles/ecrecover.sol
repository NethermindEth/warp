pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT
contract WARP {

  function test() external pure returns (bool) {
    // See https://web.archive.org/web/20210304133142/https://ethereum.stackexchange.com/questions/15364/ecrecover-from-geth-and-web3-eth-sign/30445
    // for these magic numbers
    bytes32 hash = 0x456e9aea5e197a1f1af7a3e85a3212fa4049a3ba34c2289b4c860fc0b0c64ef3;
    uint8 v = 28;
    bytes32 r = 0x9242685bf161793cc25603c231bc2f568eb630ea16aa137d2664ac8038825608;
    bytes32 s = 0x4f8ae3bd7535248d0bd448298cc2e2071e56992d0774dc340c368ae950852ada;
    require(ecrecover(hash, v, r, s) ==
            address(0x7156526fbd7a3c72969b54f64e42c10fbb768c8a));

    return true;
  }
}

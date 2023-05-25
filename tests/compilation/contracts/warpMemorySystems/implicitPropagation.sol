pragma solidity ^0.8.6;

contract WARP {
  function internalUsesMemory() internal pure returns (uint8[] memory) {
    uint8[] memory y = new uint8[](3);
    return y;
  }

  function callD() external pure {
    internalUsesMemory();
  }
}

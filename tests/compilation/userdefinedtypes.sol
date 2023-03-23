pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

// Represent a 18 decimal, 256 bit wide fixed point type using a user defined value type.
type UFixed256x18 is uint256;

/// A minimal library to do fixed point operations on UFixed256x18.
contract FixedMath {
  uint256 constant multiplier = 10**18;

  UFixed256x18[] arr;

  /// Adds two UFixed256x18 numbers. Reverts on overflow, relying on checked
  /// arithmetic on uint256.
  function add(UFixed256x18 a, UFixed256x18 b) internal pure returns (UFixed256x18) {
    return UFixed256x18.wrap(UFixed256x18.unwrap(a) + UFixed256x18.unwrap(b));
  }
  /// Multiplies UFixed256x18 and uint256. Reverts on overflow, relying on checked
  /// arithmetic on uint256.
  function mul(UFixed256x18 a, uint256 b) internal pure returns (UFixed256x18) {
      return UFixed256x18.wrap(UFixed256x18.unwrap(a) * b);
  }
  /// Take the floor of a UFixed256x18 number.
  /// @return the largest integer that does not exceed `a`.
  function floor(UFixed256x18 a) internal pure returns (uint256) {
      return UFixed256x18.unwrap(a) / multiplier;
  }
  /// Turns a uint256 into a UFixed256x18 of the same value.
  /// Reverts if the integer is too large.
  function toUFixed256x18(uint256 a) internal pure returns (UFixed256x18) {
      return UFixed256x18.wrap(a * multiplier);
  }
}

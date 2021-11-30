// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
  address public owner;
  uint256 public ownerAge;
  uint256 public ownerCellNumber;

  function validate_constructor(
    address _ownerCheck,
    uint256 _ownerAgeCheck,
    uint256 _ownerCellNumberCheck
  ) public view returns (bool) {
    return (_ownerCheck == owner &&
      _ownerAgeCheck == ownerAge &&
      _ownerCellNumberCheck == ownerCellNumber);
  }

  constructor(
    address _owner,
    uint256 _ownerAge,
    uint256 _ownerCellNumber
  ) {
    owner = _owner;
    ownerAge = _ownerAge;
    ownerCellNumber = _ownerCellNumber;
  }
}

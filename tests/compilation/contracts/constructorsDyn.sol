// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
  address public owner;
  uint256 public ownerAge;
  uint256 public ownerCellNumber;
  struct Person {
    uint256 age;
    uint256 height;
  }

  function validate_constructor(
    address _ownerCheck,
    Person calldata _person,
    uint256 _ownerCellNumberCheck
  ) public view returns (bool) {
    return (owner == _ownerCheck &&
      ownerAge == _person.age &&
      ownerCellNumber == _ownerCellNumberCheck);
  }

  constructor(
    address _owner,
    Person memory _person,
    uint256 _ownerCellNumber
  ) {
    owner = _owner;
    ownerAge = _person.age;
    ownerCellNumber = _ownerCellNumber;
  }
}

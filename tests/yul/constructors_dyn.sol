// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
    address public owner;
    uint public ownerAge;
    uint public ownerCellNumber;
    struct Person {
        uint age;
        uint height;
    }
    function validate_constructor(address _ownerCheck, Person calldata _person, uint _ownerCellNumberCheck) public view returns (bool) {
        return (owner == _ownerCheck && ownerAge == _person.age && ownerCellNumber == _ownerCellNumberCheck);
    }
    constructor(address _owner, Person memory _person, uint _ownerCellNumber) {
        owner = _owner;
        ownerAge = _person.age;
        ownerCellNumber = _ownerCellNumber;
    }

}
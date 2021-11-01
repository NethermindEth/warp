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
    constructor(address _owner, Person memory _ownerAge, uint _ownerCellNumber, uint[3] memory rando) {
        owner = _owner;
        ownerAge = _ownerAge.age + rando[0];
        ownerCellNumber = _ownerCellNumber;
    }

}
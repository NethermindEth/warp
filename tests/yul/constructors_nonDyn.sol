// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.6;

contract WARP {
    address public owner;
    uint public ownerAge;
    uint public ownerCellNumber;
    constructor(address _owner, uint _ownerAge, uint _ownerCellNumber) {
        owner = _owner;
        ownerAge = _ownerAge;
        ownerCellNumber = _ownerCellNumber;
    }
}
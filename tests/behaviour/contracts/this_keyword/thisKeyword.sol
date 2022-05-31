// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
    function simpleThis() public view returns (WARP) {
        return this;
    }

    function getAddress () public view returns (address) {
        return address(this);
    }

    function getAddressAssignment () public view returns (address) {
        address x = address(this);
        return x;
    }
}
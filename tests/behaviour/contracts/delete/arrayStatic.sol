// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WARP {

    uint[4] arr;

    function set(uint i, uint v) public returns (uint) {
        return arr[i] = v;
    }

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function clearAt(uint index) public {
        delete arr[index];
    }

    function clear() public {
        return delete arr;
    }
}

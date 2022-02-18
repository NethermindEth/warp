pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT
contract WARP {
    uint8[] arr = new uint8[](3);

    function initialize() public {
        arr[0] = 8;
        arr[1] = 10;
        arr[2] = 9;
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



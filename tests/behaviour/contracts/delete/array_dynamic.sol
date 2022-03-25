pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT
contract WARP {
    uint8[] arr;

    function initialize() public {
        arr.push(8);
        arr.push(9);
        arr.push(10);
    }
    
    function get(uint i) public view returns (uint8) {
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



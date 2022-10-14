// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP {
    function decodeSimpleDynamic(bytes memory data) public pure returns (uint[] memory){
       return abi.decode(data, (uint[])); 
    }

    function decodeNestedDynamic(bytes memory data) public pure returns (uint8[] memory, uint8[] memory) {
       uint8[][] memory v =  abi.decode(data, (uint8[][])); 
       require(v.length == 2);
       return (v[0], v[1]);
    }

    function decodeDynamicStaticNested(bytes memory data) public pure returns (uint8[2] memory, uint8[2] memory){
        uint8[2][] memory v = abi.decode(data, (uint8[2][]));
        assert(v.length == 2);
        return (v[0], v[1]);
    }
}


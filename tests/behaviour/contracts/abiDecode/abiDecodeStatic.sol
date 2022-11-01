// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP {
    function decodeSimpleStatic(bytes memory data) public pure returns (uint[3] memory){
       return abi.decode(data, (uint[3])); 
    }

    function decodeNestedStatic(bytes memory data) public pure returns (uint[3] memory, uint[3] memory) {
       uint[3][2] memory v =  abi.decode(data, (uint[3][2])); 
       return (v[0], v[1]);
    }

    function decodeStaticDynamicNested(bytes memory data) public pure returns (uint8[] memory, uint8[] memory){
        uint8[][2] memory v = abi.decode(data, (uint8[][2]));
        return (v[0], v[1]);
    }
}


pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {

struct StrucDef {
    uint8 x;
    uint256 y;
}

    function testIntExternal(int16[3] memory listA) pure external returns (int16) {
         return listA[2];
    }

    function testIntPublic(int16[3] memory listA) pure public returns (int16) {
        return listA[2];
    }
    
    function testStructExternal(StrucDef[3] memory listA) pure external returns (uint8, uint256) {
        return (listA[2].x, listA[2].y);
    }

    function testStructPublic(StrucDef[3] memory listA) pure public returns (uint8) {
         return listA[2].x;
    }

    function testMultiplePublic(StrucDef[3] memory listA, uint8 z, uint8[3] memory listB) pure public returns (uint8) {
        return listA[0].x + listB[2];
    } 

}


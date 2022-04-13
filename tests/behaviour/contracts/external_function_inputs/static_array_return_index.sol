pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {

struct StrucDef {
    uint8 x;
    uint256 y;
}

    function testA(int16[3] memory listA) pure external returns (int16) {
         return listA[2];
    }

    function testB(int16[3] memory listA) pure public returns (int16) {
        return listA[2];
    }
    // Would return y but warp at this stage does not return whole structs.
    function testC(StrucDef[3] memory listA) pure external returns (uint8) {
        return listA[2].x;
    }

    function testD(StrucDef[3] memory listA) pure public returns (uint8) {
         return listA[2].x;
    }

    function testE(StrucDef[3] memory listA, uint8 z, uint8[3] memory listB) pure public returns (uint8) {
        return listA[0].x + listB[2];
    } 

}

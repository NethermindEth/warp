pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {

struct structDef {
    uint8 member1;
    uint8 member2;
}


    // function testReturnStruct(structDef memory structA) pure external returns (structDef memory) {
    //     return structA;
    // }
    
    // function testReturnStructPublic(structDef memory structA) pure public returns (structDef memory) {
    //     return structA;
    // }

    function testReturnMember(structDef memory structA) pure external returns (uint8) {
        return structA.member1;
    }

    //function testMultipleStructsMembers(structDef memory structA, uint8 b, structDef memory structC) pure external returns (uint8) {
    //    return structA.member1 + structC.member2;
    //}

    // function testPublicFunctionReturnStruct(structDef memory structA) pure external returns (structDef memory) {
    //     return structA;
    // }
    
    //function testMultipleStructsPublicFunctionMember(structDef memory structA, uint8 b, structDef memory structC) pure public returns (uint8) {
    //    return structA.member1 + structC.member2;
    //}


}
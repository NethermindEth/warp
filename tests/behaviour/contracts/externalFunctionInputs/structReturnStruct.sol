pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

        struct structDef {
        uint8 member1;
        uint8 member2;
    }

contract WARP {

    function testReturnStruct(structDef memory structA) pure external returns (structDef memory) {
        return structA;
    }
    
    function testReturnStructPublic(structDef memory structA) pure public returns (structDef memory) {
        return structA;
    }
}

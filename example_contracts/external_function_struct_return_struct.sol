pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {

struct structDef {
    uint8 member1;
    uint8 member2;
}
    // TODO: This should compile once Dom has finished his memory refactor.
    // These test cases should be moved to tests/behavior/contracts/external_function_inputs/
    function testReturnStruct(structDef memory structA) pure external returns (structDef memory) {
        return structA;
    }
    
    function testReturnStructPublic(structDef memory structA) pure public returns (structDef memory) {
        return structA;
    }


    function testPublicFunctionReturnStruct(structDef memory structA) pure external returns (structDef memory) {
        return structA;
    }
    
}
pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {

    struct structDef2 {
        uint member1;
        uint16 member2;
    }

    struct structDef1 {
        uint member1;
        structDef2 member2;
        uint member3;
    }

    function returnFelt() pure external returns (uint8[] memory) {
         uint8[] memory y = new uint8[](3);
         y[0] = 1;
         y[1] = 2;
         y[2] = 3;
         return y;
    }
    function returnUint256() pure external returns (uint256[] memory) {
        uint256[] memory y = new uint256[](3);
        y[0] = 10;
        y[1] = 100;
        y[2] = 1000;
        return y;
    }

    function returnStruct() pure external returns (structDef2[] memory) {
        structDef2[] memory y = new structDef2[](3);
        y[0] = structDef2(1,10);
        y[1] = structDef2(2,20);
        y[2] = structDef2(3,30);

        return y;
    }

    function returnNestedStruct() pure external returns (structDef1[] memory) {
        structDef1[] memory y = new structDef1[](3);
        y[0] = structDef1(1,structDef2(10, 100), 1000);
        y[1] = structDef1(2,structDef2(20, 200), 2000);
        y[2] = structDef1(3,structDef2(30, 300), 3000);
        
        return y;
    }
}
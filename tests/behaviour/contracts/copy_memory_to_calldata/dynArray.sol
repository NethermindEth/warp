pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

struct structDef2 {
    uint member1;
    uint16 member2;
}

// struct structDef1 {
//     uint member1;
//     structDef2 member2;
//     uint member3;
// }

struct structDef3 {
    uint256[] member1;
}

function returnFelt() pure external returns (uint8[] memory) {
     uint8[] memory y = new uint8[](3);
     y[0] = 10;
     y[1] = 20;
     y[2] = 30;
     return y;
}

function returnUint256() pure external returns (uint256[] memory) {
    uint256[] memory y = new uint256[](3);
    y[0] = 10;
    y[1] = 100;
    y[2] = 1000;
    return y;
}


// These test will come online when the known nested Reference Types writing bug is sorted.

// function returnStruct() pure external returns (structDef2[] memory) {
//     structDef2[] memory y = new structDef2[](3);
//     y[0] = structDef2(1,10);
//     y[1] = structDef2(2,20);
//     y[2] = structDef2(3,30);

//     return y;
// }

// function returnNestedStruct() pure external returns (structDef1[] memory) {
//     structDef1[] memory y = new structDef1[](3);
//     y[0] = structDef1(1,structDef2(10, 100), 1000);
//     y[1] = structDef1(2,structDef2(20, 200), 2000);
//     y[2] = structDef1(3,structDef2(30, 300), 3000);

//     return y;
// }

// function returnMultipleFeltDynArray() pure external returns (uint8[] memory, uint8[] memory) {
//      uint8[] memory x = new uint8[](4);
//      x[0] = 5;
//      x[1] = 6;
//      x[2] = 7;
//      x[3] = 8;

//      uint8[] memory y = new uint8[](3);
//      y[0] = 1;
//      y[1] = 2;
//      y[2] = 3;

//      return (y, x);
// }

// function returnDynArrayAsMemberAccess() pure external returns (uint[] memory){
//     uint256[] memory y = new uint256[](2);
//     y[0] = 10;
//     y[1] = 100;
//    // y[2] = 1000;

//     structDef3 memory z = structDef3(y);
//     return z.member1;
// }

// function returnDynArrayAsIndexAccess() pure external returns (uint[] memory){
//     uint256[][1] memory y;
//     y[0] = new uint256[](2);
//     y[0][0] = 10;
//     y[0][1] = 100;

//     return y[0];
// }

// function returnDynArrayFromDynArray() pure external returns (uint[] memory){
//     uint256[][] memory y;
//     y = new uint256[][](3);
//     y[0] = new uint256[](3);
//     y[0][0] = 10;
//     y[0][1] = 100;
//     y[0][2] = 1000;

//     return y[0];
// }

function createDynArray() pure internal returns (uint8[] memory) {
     uint8[] memory y = new uint8[](3);
     y[0] = 100;
     y[1] = 200;
     y[2] = 252;
     return y;
}
function returnDynArrayFromFunctionCall() pure external returns (uint8[] memory) {
    return createDynArray();
}
}

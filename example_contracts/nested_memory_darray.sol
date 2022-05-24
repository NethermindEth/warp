pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

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

struct structDef3 {
    uint256[] member1;
}



function returnStruct() pure external {
    structDef2[] memory y = new structDef2[](3);
    y[0] = structDef2(1,10);
    y[1] = structDef2(2,20);
    y[2] = structDef2(3,30);
}

function returnNestedStruct() pure external {
    structDef1[] memory y = new structDef1[](3);
    y[0] = structDef1(1,structDef2(10, 100), 1000);
    y[1] = structDef1(2,structDef2(20, 200), 2000);
    y[2] = structDef1(3,structDef2(30, 300), 3000);

}


function returnDynArrayAsMemberAccess() pure external {
    uint256[] memory y = new uint256[](2);
    y[0] = 10;
    y[1] = 100;
    y[2] = 1000;
    structDef3 memory z = structDef3(y);
}

function returnDynArrayAsIndexAccess() pure external {
    uint256[][1] memory y;
    y[0] = new uint256[](2);
    y[0][0] = 10;
    y[0][1] = 100;

}

function returnDynArrayFromDynArray() pure external {
    uint256[][] memory y;
    y = new uint256[][](3);
    y[0] = new uint256[](3);
    y[0][0] = 10;
    y[0][1] = 100;
    y[0][2] = 1000;

}


}

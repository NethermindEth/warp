// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {

    function externReturnIndexAccess(uint8[] calldata x) pure external returns (uint8, uint8, uint8) {
        (uint8 a, uint8 b, uint8 c) = returnIndexAccess(x);(x);
        return (a, b, c);
    }

    function returnIndexAccess(uint8[] calldata x) pure internal returns (uint8, uint8, uint8){
        return (x[0], x[1], x[2]);
    }

    function externReturnDarray(uint8[] calldata x) pure external returns (uint8[] memory) {
        uint8[] calldata y = returnDArray(x);
        return (y);
    }

    function returnDArray(uint8[] calldata x) pure internal returns (uint8[] calldata){
        return (x);
    }
    
    function returnFirstIndex(uint8[] calldata x) pure public returns (uint8) {
        return x[0];
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {

    // function externFunc(uint8[] calldata x) pure external returns (uint8, uint8, uint8) {
    //     (uint8 a, uint8 b, uint8 c) = internFunc(x);
    //     return (a, b, c);
    // }

    // function internFunc(uint8[] calldata x) pure internal returns (uint8, uint8, uint8){
    //     return (x[0], x[1], x[3]);
    // }

        function externFunc2(uint8[] calldata x) pure external returns (uint8[] memory) {
        uint8[] memory y = internFunc2(x);
        return (y);
    }

    function internFunc2(uint8[] calldata x) pure internal returns (uint8[] calldata){
        return (x);
    }

 
}
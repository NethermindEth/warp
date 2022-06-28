pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

import "libSol.sol";
// library M {

//    function multiply(int8 y, int8 x) pure external returns (int8) {
//        return x*y;
//     }
// }

contract WARP {

    function f() pure external {
       M.multiply(10, 5);
    }
}

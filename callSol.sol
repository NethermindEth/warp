pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

import "libSol.sol";
// import "ribSol.sol";

//    function multiply(int8 y, int8 x) pure external returns (int8) {
//        return x*y;
//     }
// }

contract M {
    function multiply(a, b) pure external {
        a+b;
    }
}

contract WARP {

    function f() pure external {
       M.multiply(10, 5);
    }
}

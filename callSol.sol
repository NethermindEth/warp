pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

import "libSol.sol";


// contract M {
//     function multiply(a, b) pure external {
//         a+b;
//     }
// }

contract WARP {

    function f(address addr, int8 x, int8 y) pure external returns (int8) {
        M m = M(addr);
        return m.multiply(x, y);
    }
// contract WARP {

//     function f(int8 x, int8 y) pure external returns (int8) {
//         return M.multiply(x, y);
//     }
}

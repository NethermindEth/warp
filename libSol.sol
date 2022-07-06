pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

library B {

   function multiply(int8 y, int8 x) pure external returns (int8) {
       return x*y;
    }
}

library A {
   function multiply(int8 y, int8 x) pure external returns (int8) {
       return x*y;
    }
}

contract M {

   function multiply(int8 y, int8 x) pure external returns (int8) {
       return B.multiply(y, x);
    }
}
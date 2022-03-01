// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract C {
    // The data location of x is storage.
    // This is the only place where the
    // data location can be omitted.
    uint[] x;

    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // works, copies the whole array to storage
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        y[7]; // fine, returns the 8th element
        y.pop(); // fine, modifies x through y
        //delete x; // fine, clears the array, also modifies y
        x.push(3);
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // This does not work either, since it would "reset" the pointer, but there
        // is no sensible location it could point to.
        // delete y;
        g(x); // calls g, handing over a reference to x
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}

    function memoryTest(uint8 a) public pure returns (uint){
      uint[] memory arr = new uint[](4);
      uint[] memory arr2 = new uint[](3);
      uint[] memory arr3;
      if (a > 3) {
        arr3 = arr;
      } else {
        arr3 = arr2;
      }

      if (a > 5) {
        arr3[2] = 5;
      }

      return arr3[2];
    }
}

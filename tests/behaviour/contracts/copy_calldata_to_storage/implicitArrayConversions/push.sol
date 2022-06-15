pragma solidity ^0.8.14;

contract WARP {

    int[][] public arr;

    function passInt8ToInt256(int8[] calldata y) external {
       arr.push(y);
    }
}

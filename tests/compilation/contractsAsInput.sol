// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8;


contract Yarp {}

contract Warp {
    function f(Yarp y) external pure returns (Yarp) {
        return y;
    }

    function g(Yarp[] memory y) external pure returns (Yarp[] memory) {
        return y;
    }
}


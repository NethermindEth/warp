// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    function encodeWithSelector() public pure returns (bytes memory){
        return abi.encodeWithSelector(0x01020304, [3]);
    }

    function encodeWithSignature() public pure returns (bytes memory) {
        return abi.encodeWithSignature('I am hungry', [15]);
    }
}

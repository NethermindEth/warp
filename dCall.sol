pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

contract D {
    uint8 public x;

    constructor() {
        x = 0;
    }
    function increaseX(uint8 y) external {
        x = x + y;
    }

    function retX() view external returns (uint8) {
        return x; 
    }
}

contract C {
 
    uint8 public z;

    constructor() {
        z = 0;
    }

    function callDel() external returns (bool) {
        address contractDAddress = address(uint256(0xddaAd340b0f1Ef));
        (bool result, bytes memory retData) = contractDAddress.delegatecall(
            abi.encodeCall(D.increaseX, 8)
        );
        return result;
    }
    
}
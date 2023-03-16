// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

// Learn more about Contract Factory here: 
// https://nethermindeth.github.io/warp/docs/features/contract_factories

contract DeployedContract {
    uint8 input1;
    uint8 input2;
    constructor(uint8 input1_, uint8 input2_) {
        input1 = input1_;
        input2 = input2_;
    }
}

contract ContractFactory {
    address public deployedContract;

    function deploy() external {
        deployedContract =  address(new DeployedContract(1, 2));
    }
}
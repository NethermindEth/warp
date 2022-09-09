// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../bridges/L1_Bridge.sol";

contract Mock_L1_Bridge is L1_Bridge {

    constructor (IBonderRegistry registry, address token) public L1_Bridge(registry, token) {}

    function getChainId() public override view returns (uint256) {
        return 1;
    }
}

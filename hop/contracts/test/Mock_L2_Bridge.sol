// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../bridges/L2_Bridge.sol";

contract Mock_L2_Bridge is L2_Bridge {
    uint256 private chainId;

    constructor (
        uint256 _chainId,
        HopBridgeToken hToken,
        uint256[] memory activeChainIds,
        IBonderRegistry registry
    )
        public
        L2_Bridge(
            hToken,
            activeChainIds,
            registry
        )
    {
        chainId = _chainId;
    }

    function getChainId() public override view returns (uint256) {
        return chainId;
    }
}
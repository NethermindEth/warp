// SPDX-License-Identifier: MIT

pragma solidity ^0.6.11;

interface IEthERC20Bridge {
    function depositAsERC20(
        address erc20,
        address destination,
        uint256 amount,
        uint256 maxSubmissionCost,
        uint256 maxGas,
        uint256 gasPriceBid,
        bytes calldata callHookData
    ) external;
}
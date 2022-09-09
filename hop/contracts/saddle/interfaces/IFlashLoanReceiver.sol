// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.6.12;

/**
 * @title IFlashLoanReceiver interface
 * @notice Interface for the Saddle fee IFlashLoanReceiver. Modified from Aave's IFlashLoanReceiver interface.
 * https://github.com/aave/aave-protocol/blob/4b4545fb583fd4f400507b10f3c3114f45b8a037/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 * @author Aave
 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 **/
interface IFlashLoanReceiver {
    function executeOperation(
        address pool,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata params
    ) external;
}

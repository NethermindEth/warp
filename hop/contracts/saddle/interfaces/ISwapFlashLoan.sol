// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./ISwap.sol";

interface ISwapFlashLoan is ISwap {
    function flashLoan(
        address receiver,
        IERC20 token,
        uint256 amount,
        bytes memory params
    ) external;
}

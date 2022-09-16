// SPDX-License-Identifier: MIT

import "./SwapDataConsumer.sol";

pragma solidity 0.8;

interface Interface_L2_Bridge {

    function send(
        uint256 chainId,
        address recipient,
        uint256 amount,
        uint256 bonderFee,
        SwapDataConsumer.SwapData calldata swapData,
        address bonder
    )
        external;
}

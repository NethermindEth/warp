// SPDX-License-Identifier: MIT

pragma solidity 0.8;
pragma experimental ABIEncoderV2;

contract SwapDataConsumer {
    struct SwapData {
        uint8 tokenIndex;
        uint256 amountOutMin;
        uint256 deadline;
    }
}

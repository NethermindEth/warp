// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
pragma experimental ABIEncoderV2;

import "../openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../saddle/Swap.sol";
import "./L2_Bridge.sol";
import "../interfaces/IWETH.sol";
import "./SwapDataConsumer.sol";

contract L2_AmmWrapper is SwapDataConsumer {

    L2_Bridge public immutable bridge;
    IERC20 public immutable l2CanonicalToken;
    bool public immutable l2CanonicalTokenIsEth;
    IERC20 public immutable hToken;
    Swap public immutable exchangeAddress;

    /// @notice When l2CanonicalTokenIsEth is true, l2CanonicalToken should be set to the WETH address
    constructor(
        L2_Bridge _bridge,
        IERC20 _l2CanonicalToken,
        bool _l2CanonicalTokenIsEth,
        IERC20 _hToken,
        Swap _exchangeAddress
    )
    {
        bridge = _bridge;
        l2CanonicalToken = _l2CanonicalToken;
        l2CanonicalTokenIsEth = _l2CanonicalTokenIsEth;
        hToken = _hToken;
        exchangeAddress = _exchangeAddress;
    }

    // receive() external payable {}

    /// @notice amount is the amount the user wants to send plus the Bonder fee
    function swapAndSend(
        uint256 chainId,
        address recipient,
        uint256 amount,
        uint256 bonderFee,
        SwapData memory swapData,
        SwapData memory destinationSwapData,
        address bonder
    )
        public
        payable
    {
        require(amount >= bonderFee, "L2_AMM_W: Bonder fee cannot exceed amount");


        /*
        if (l2CanonicalTokenIsEth) {
             require(msg.value == amount, "L2_AMM_W: Value does not match amount");
             IWETH(address(l2CanonicalToken)).deposit{value: amount}();
        } else {
            require(l2CanonicalToken.transferFrom(msg.sender, address(this), amount), "L2_AMM_W: TransferFrom failed");
        }*/
        require(l2CanonicalToken.transferFrom(msg.sender, address(this), amount), "L2_AMM_W: TransferFrom failed");

        require(l2CanonicalToken.approve(address(exchangeAddress), amount), "L2_AMM_W: Approve failed");
        uint256 swapAmount = Swap(exchangeAddress).swap(
            swapData.tokenIndex,
            0,
            amount,
            swapData.amountOutMin,
            swapData.deadline
        );

        bridge.send(
            chainId,
            recipient,
            swapAmount,
            bonderFee,
            destinationSwapData,
            bonder
        );
    }

    function attemptSwap(
        address recipient,
        uint256 amount,
        SwapData calldata swapData
    )
        external
    {
        require(hToken.transferFrom(msg.sender, address(this), amount), "L2_AMM_W: TransferFrom failed");
        require(hToken.approve(address(exchangeAddress), amount), "L2_AMM_W: Approve failed");

        uint256 amountOut = Swap(exchangeAddress).swap(
            0,
            swapData.tokenIndex,
            amount,
            swapData.amountOutMin,
            swapData.deadline
        );
        /*
        try Swap(exchangeAddress).swap(
            0,
            swapData.tokenIndex,
            amount,
            swapData.amountOutMin,
            swapData.deadline
        ) returns (uint256 _amountOut) {
            amountOut = _amountOut;
        } catch {}
         */

        if (amountOut == 0) {
            // Transfer hToken to recipient if swap fails
            require(hToken.transfer(recipient, amount), "L2_AMM_W: Transfer failed");
            return;
        }

        /*
        if (l2CanonicalTokenIsEth) {
            IWETH(address(l2CanonicalToken)).withdraw(amountOut);
            (bool success, ) = recipient.call{value: amountOut}(new bytes(0));
            require(success, 'L2_AMM_W: ETH transfer failed');
        } else {
            require(l2CanonicalToken.transfer(recipient, amountOut), "L2_AMM_W: Transfer failed");
        }
         */
            require(l2CanonicalToken.transfer(recipient, amountOut), "L2_AMM_W: Transfer failed");
    }
}

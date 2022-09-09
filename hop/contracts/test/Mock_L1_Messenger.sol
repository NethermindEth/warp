// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./MockMessenger.sol";
import "./Mock_L2_Messenger.sol";

contract Mock_L1_Messenger is MockMessenger {

    Mock_L2_Messenger public targetMessenger;

    constructor (IERC20 _canonicalToken) public MockMessenger(_canonicalToken) {}

    function setTargetMessenger(address _targetMessenger) public {
        targetMessenger = Mock_L2_Messenger(_targetMessenger);
    }

    /* ========== Arbitrum ========== */

    function createRetryableTicket(
        address _destAddr,
        uint256 /* _arbTxCallValue */,
        uint256 /* _maxSubmissionCost */,
        address /* _submissionRefundAddress */,
        address /* _valueRefundAddress */,
        uint256 /* _maxGas */,
        uint256 /* _gasPriceBid */,
        bytes calldata _data
    )
        external
        payable
        returns (uint256)
    {
        targetMessenger.receiveMessage(
            _destAddr,
            _data,
            msg.sender
        );
    }

    /* ========== Optimism ========== */

    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 /* _gasLimit */
    )
        public
    {
        targetMessenger.receiveMessage(
            _target,
            _message,
            msg.sender
        );
    }

    /* ========== xDai ========== */

    function requireToPassMessage(
        address _target,
        bytes calldata _message,
        uint256 /* _gasLimit */
    )
        public
        returns (bytes32)
    {
        targetMessenger.receiveMessage(
            _target,
            _message,
            msg.sender
        );

        return bytes32('0');
    }

    /* ========== Polygon ========== */

    function syncState(
        address _fxChild,
        bytes memory _message
    )
        external
    {
        targetMessenger.receiveMessage(
            _fxChild,
            _message,
            address(1)
        );
    }

    function syncStateCanonicalToken(
        address _target,
        bytes memory _message
    )
        public
    {
        targetMessenger.receiveMessage(
            _target,
            _message,
            msg.sender
        );
    }
}

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

/**
 * @title OVM_BaseCrossDomainMessenger
 */
contract OVM_BaseCrossDomainMessenger {

    /**********************
     * Contract Variables *
     **********************/

    mapping (bytes32 => bool) public relayedMessages;
    mapping (bytes32 => bool) public successfulMessages;
    mapping (bytes32 => bool) public sentMessages;
    uint256 public messageNonce;
    address public xDomainMessageSender;


    /********************
     * Public Functions *
     ********************/

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    // function sendMessage(
    //     address _target,
    //     bytes memory _message,
    //     uint256 _gasLimit
    // )
    //     public
    // {
    //     bytes memory xDomainCalldata = _getXDomainCalldata(
    //         _target,
    //         msg.sender,
    //         _message,
    //         messageNonce
    //     );

    //     _sendXDomainMessage(xDomainCalldata, _gasLimit);

    //     messageNonce += 1;
    //     sentMessages[keccak256(xDomainCalldata)] = true;
    // }

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Generates the correct cross domain calldata for a message.
     * @param _target Target contract address.
     * @param _sender Message sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @return ABI encoded cross domain calldata.
     */
    function _getXDomainCalldata(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "relayMessage(address,address,bytes,uint256)",
            _target,
            _sender,
            _message,
            _messageNonce
        );
    }

    /**
     * Sends a cross domain message.
     * _message Message to send.
     * _gasLimit Gas limit for the provided message.
     */
    function _sendXDomainMessage(
        bytes memory, // _message
        uint256 // _gasLimit
    )
        virtual
        internal
    {
        revert("Implement me in child contracts!");
    }
}
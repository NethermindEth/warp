// SPDX-License-Identifier: MIT
// @unsupported: ovm
pragma solidity 0.7.3;

// IStateReceiver represents interface to receive state
interface IStateReceiver {
    function onStateReceive(uint256 stateId, bytes calldata data) external;
}

// IFxMessageProcessor represents interface to process message
interface IFxMessageProcessor {
    function processMessageFromRoot(uint256 stateId, address rootMessageSender, bytes calldata data) external;
}

/**
 * @title FxChild child contract for state receiver
 */
contract MockFxChild is IStateReceiver {
    address public fxRoot;
    address public l2Messenger;

    event NewFxMessage(address rootMessageSender, address receiver, bytes data);

    function setFxRoot(address _fxRoot) public {
        require(fxRoot == address(0x0));
        fxRoot = _fxRoot;
    }

    function setL2Messenger(address _l2Messenger) public {
        require(l2Messenger == address(0x0));
        l2Messenger = _l2Messenger;
    }

    function onStateReceive(uint256 stateId, bytes calldata _data) external override {
        require(msg.sender == l2Messenger, "Invalid sender");
        (address rootMessageSender, address receiver, bytes memory data) = abi.decode(_data, (address, address, bytes));
        emit NewFxMessage(rootMessageSender, receiver, data);
        IFxMessageProcessor(receiver).processMessageFromRoot(stateId, rootMessageSender, data);
    }
}
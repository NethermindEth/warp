// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "../interfaces/optimism/messengers/iOVM_L1CrossDomainMessenger.sol";
import "./Connector.sol";

contract L1_OptimismConnector is Connector {
    iOVM_L1CrossDomainMessenger public immutable l1MessengerAddress;
    uint256 public immutable defaultGasLimit;

    constructor (
        address _owner,
        iOVM_L1CrossDomainMessenger _l1MessengerAddress,
        uint32 _defaultGasLimit
    )
        public
        Connector(_owner)
    {
        l1MessengerAddress = _l1MessengerAddress;
        defaultGasLimit = _defaultGasLimit;
    }

    /* ========== Override Functions ========== */

    function _forwardCrossDomainMessage() internal override {
        l1MessengerAddress.sendMessage(
            xDomainAddress,
            msg.data,
            uint32(defaultGasLimit)
        );
    }

    function _verifySender() internal override {
        require(msg.sender == address(l1MessengerAddress), "L1_OVM_CNR: Caller is not l1MessengerAddress");
        // Verify that cross-domain sender is xDomainAddress
        require(l1MessengerAddress.xDomainMessageSender() == xDomainAddress, "L1_OVM_CNR: Invalid cross-domain sender");
    }
}

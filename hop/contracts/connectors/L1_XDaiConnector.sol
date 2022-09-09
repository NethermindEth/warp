// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "../interfaces/xDai/messengers/IArbitraryMessageBridge.sol";
import "./Connector.sol";

contract L1_XDaiConnector is Connector {
    IArbitraryMessageBridge public l1MessengerAddress;
    /// @notice The xDai AMB uses bytes32 for chainId instead of uint256
    bytes32 public l2ChainId;
    address public l2BridgeConnectorAddress;
    uint256 public immutable defaultGasLimit;

    constructor (
        address _owner,
        IArbitraryMessageBridge _l1MessengerAddress,
        uint256 _defaultGasLimit,
        uint256 _l2ChainId
    )
        public
        Connector(_owner)
    {
        l1MessengerAddress = _l1MessengerAddress;
        defaultGasLimit = _defaultGasLimit;
        l2ChainId = bytes32(_l2ChainId);
    }

    /* ========== Override Functions ========== */

    function _forwardCrossDomainMessage() internal override {
        l1MessengerAddress.requireToPassMessage(
            xDomainAddress,
            msg.data,
            defaultGasLimit
        );
    }

    function _verifySender() internal override {
        require(msg.sender == address(l1MessengerAddress), "L2_XDAI_CNR: Caller is not the expected sender");
        require(l1MessengerAddress.messageSender() == xDomainAddress, "L2_XDAI_CNR: Invalid cross-domain sender");

        // With the xDai AMB, it is best practice to also check the source chainId
        // https://docs.tokenbridge.net/amb-bridge/how-to-develop-xchain-apps-by-amb#receive-a-method-call-from-the-amb-bridge
        require(l1MessengerAddress.messageSourceChainId() == l2ChainId, "L2_XDAI_CNR: Invalid source Chain ID");
    }
}

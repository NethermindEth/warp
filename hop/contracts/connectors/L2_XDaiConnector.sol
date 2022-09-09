// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "../interfaces/xDai/messengers/IArbitraryMessageBridge.sol";
import "./Connector.sol";

contract L2_XDaiConnector is Connector {
    IArbitraryMessageBridge public messenger;
    /// @notice The xDai AMB uses bytes32 for chainId instead of uint256
    bytes32 public immutable l1ChainId;
    uint256 public defaultGasLimit;

    constructor (
        address _owner,
        IArbitraryMessageBridge _messenger,
        uint256 _l1ChainId,
        uint256 _defaultGasLimit
    )
        public
        Connector(_owner)
    {
        messenger = _messenger;
        l1ChainId = bytes32(_l1ChainId);
        defaultGasLimit = _defaultGasLimit;
    }

    /* ========== Override Functions ========== */

    function _forwardCrossDomainMessage() internal override {
        messenger.requireToPassMessage(
            xDomainAddress,
            msg.data,
            defaultGasLimit
        );
    }

    function _verifySender() internal override {
        require(messenger.messageSender() == xDomainAddress, "L2_XDAI_CNR: Invalid cross-domain sender");
        require(msg.sender == address(messenger), "L2_XDAI_CNR: Caller is not the expected sender");

        // With the xDai AMB, it is best practice to also check the source chainId
        // https://docs.tokenbridge.net/amb-bridge/how-to-develop-xchain-apps-by-amb#receive-a-method-call-from-the-amb-bridge
        require(messenger.messageSourceChainId() == l1ChainId, "L2_XDAI_CNR: Invalid source Chain ID");
    }
}

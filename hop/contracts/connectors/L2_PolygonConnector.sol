// SPDX-License-Identifier: MIT

pragma solidity 0.7.3;

import "../polygon/tunnel/FxBaseChildTunnel.sol";

contract L2_PolygonConnector is FxBaseChildTunnel {
    address public owner;

    constructor (
        address _owner,
        address _fxChild
    )
        public
        FxBaseChildTunnel(_fxChild)
    {
        owner = _owner;
    }

    fallback () external {
        require(msg.sender == owner, "L2_PLGN_CNR: Only owner can forward messages");
        _sendMessageToRoot(msg.data);
    }

    /* ========== Override Functions ========== */

    function _processMessageFromRoot(
        uint256 /* stateId */,
        address sender,
        bytes memory data
    )
        internal
        override
        validateSender(sender)
    {
        (bool success,) = owner.call(data);
        require(success, "L2_PLGN_CNR: Failed to proxy message");
    }
}

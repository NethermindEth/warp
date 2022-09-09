// SPDX-License-Identifier: MIT

pragma solidity 0.7.3;

import "../polygon/tunnel/FxBaseRootTunnel.sol";

contract L1_PolygonConnector is FxBaseRootTunnel {
    address public owner;

    constructor (
        address _owner,
        address _checkpointManager,
        address _fxRoot,
        address _fxChildTunnel
    )
        public
        FxBaseRootTunnel(_checkpointManager, _fxRoot)
    {
        owner = _owner;
        setFxChildTunnel(_fxChildTunnel);
    }

    fallback () external {
        require(msg.sender == owner, "L1_PLGN_CNR: Only owner can forward messages");
        _sendMessageToChild(msg.data);
    }

    /* ========== Override Functions ========== */

    function _processMessageFromChild(bytes memory message) internal override {
        (bool success,) = owner.call(message);
        require(success, "L1_PLGN_CNR: Call to owner failed");
    }
}

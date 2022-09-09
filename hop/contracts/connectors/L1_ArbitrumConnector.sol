// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./Connector.sol";

contract L1_ArbitrumConnector is Connector {
    constructor (
        address _owner
    )
        public
        Connector(_owner)
    {}

    /* ========== Override Functions ========== */

    function _forwardCrossDomainMessage() internal override {
        // ToDo not implemented
    }

    function _verifySender() internal override {
        // ToDo not implemented
    }
}

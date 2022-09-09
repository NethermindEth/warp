// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

abstract contract Connector {
    address public owner;
    address public xDomainAddress;

    constructor(address _owner) public {
        owner = _owner;
    }

    fallback () external {
        if (msg.sender == owner) {
            _forwardCrossDomainMessage();
        } else {
            _verifySender();

            (bool success,) = owner.call(msg.data);
            require(success, "CNR: Failed to forward message");
        }
    }

    /**
     * @dev Sets the l2BridgeConnectorAddress
     * @param _xDomainAddress The new bridge connector address
     */
    function setXDomainAddress(address _xDomainAddress) external {
        require(xDomainAddress == address(0), "CNR: Connector address has already been set");
        xDomainAddress = _xDomainAddress;
    }

    /* ========== Virtual functions ========== */

    function _forwardCrossDomainMessage() internal virtual;
    function _verifySender() internal virtual;
}

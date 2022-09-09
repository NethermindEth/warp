// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (crosschain/arbitrum/LibArbitrumL1.sol)

pragma solidity ^0.8.4;

import { IBridgeUpgradeable as ArbitrumL1_Bridge } from "../../vendor/arbitrum/IBridgeUpgradeable.sol";
import { IInboxUpgradeable as ArbitrumL1_Inbox } from "../../vendor/arbitrum/IInboxUpgradeable.sol";
import { IOutboxUpgradeable as ArbitrumL1_Outbox } from "../../vendor/arbitrum/IOutboxUpgradeable.sol";
import "../errorsUpgradeable.sol";

/**
 * @dev Primitives for cross-chain aware contracts for
 * https://arbitrum.io/[Arbitrum].
 *
 * This version should only be used on L1 to process cross-chain messages
 * originating from L2. For the other side, use {LibArbitrumL2}.
 */
library LibArbitrumL1Upgradeable {
    /**
     * @dev Returns whether the current function call is the result of a
     * cross-chain message relayed by the `bridge`.
     */
    function isCrossChain(address bridge) internal view returns (bool) {
        return msg.sender == bridge;
    }

    /**
     * @dev Returns the address of the sender that triggered the current
     * cross-chain message through the `bridge`.
     *
     * NOTE: {isCrossChain} should be checked before trying to recover the
     * sender, as it will revert with `NotCrossChainCall` if the current
     * function call is not the result of a cross-chain message.
     */
    function crossChainSender(address bridge) internal view returns (address) {
        if (!isCrossChain(bridge)) revert NotCrossChainCall();

        address sender = ArbitrumL1_Outbox(ArbitrumL1_Bridge(bridge).activeOutbox()).l2ToL1Sender();
        require(sender != address(0), "LibArbitrumL1: system messages without sender");

        return sender;
    }
}

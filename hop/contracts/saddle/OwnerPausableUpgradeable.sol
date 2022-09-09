// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

/**
 * @title OwnerPausable
 * @notice An ownable contract allows the owner to pause and unpause the
 * contract without a delay.
 * @dev Only methods using the provided modifiers will be paused.
 */
abstract contract OwnerPausableUpgradeable is
    OwnableUpgradeable,
    PausableUpgradeable
{
    function __OwnerPausable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Pausable_init_unchained();
    }

    /**
     * @notice Pause the contract. Revert if already paused.
     */
    function pause() external onlyOwner {
        PausableUpgradeable._pause();
    }

    /**
     * @notice Unpause the contract. Revert if already unpaused.
     */
    function unpause() external onlyOwner {
        PausableUpgradeable._unpause();
    }
}

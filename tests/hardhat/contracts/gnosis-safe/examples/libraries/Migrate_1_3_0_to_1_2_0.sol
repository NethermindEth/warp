// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;
import "../../libraries/GnosisSafeStorage.sol";

/// @title Migration - migrates a Safe contract from 1.3.0 to 1.2.0
/// @author Richard Meissner - <richard@gnosis.io>
contract Migration is GnosisSafeStorage {
    bytes32 private constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;

    address public immutable migrationSingleton;
    address public immutable safe120Singleton;

    constructor(address targetSingleton) {
        require(targetSingleton != address(0), "Invalid singleton address provided");
        safe120Singleton = targetSingleton;
        migrationSingleton = address(this);
    }

    event ChangedMasterCopy(address singleton);

    bytes32 private guard;

    /// @dev Allows to migrate the contract. This can only be called via a delegatecall.
    function migrate() public {
        require(address(this) != migrationSingleton, "Migration should only be called via delegatecall");
        // Master copy address cannot be null.
        singleton = safe120Singleton;
        domainSeparator = keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, this));
        emit ChangedMasterCopy(singleton);
    }
}

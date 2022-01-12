// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

/// @title GnosisSafeStorage - Storage layout of the Safe contracts to be used in libraries
/// @author Richard Meissner - <richard@gnosis.io>
contract GnosisSafeStorage {
  // From /common/Singleton.sol
  address internal singleton;
  // From /common/ModuleManager.sol
  mapping(address => address) internal modules;
  // From /common/OwnerManager.sol
  mapping(address => address) internal owners;
  uint256 internal ownerCount;
  uint256 internal threshold;

  // From /GnosisSafe.sol
  bytes32 internal nonce;
  bytes32 internal domainSeparator;
  mapping(bytes32 => uint256) internal signedMessages;
  mapping(address => mapping(bytes32 => uint256)) internal approvedHashes;
}

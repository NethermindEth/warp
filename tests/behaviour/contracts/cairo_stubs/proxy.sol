pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  /// warp-cairo
  /// from starkware.starknet.common.syscalls import library_call
  /// DECORATOR(external)
  /// DECORATOR(raw_input)
  /// DECORATOR(raw_output)
  /// func __default__{
  ///     syscall_ptr : felt*,
  ///     pedersen_ptr : HashBuiltin*,
  ///     range_check_ptr,
  /// }(selector : felt, calldata_size : felt, calldata : felt*) -> (
  ///     retdata_size : felt, retdata : felt*
  /// ):
  ///     alloc_locals
  ///     let (class_hash_low) = WARP_STORAGE.read(STATEVAR(implementation_hash))
  ///     let (class_hash_high) = WARP_STORAGE.read(STATEVAR(implementation_hash) + 1)
  ///     let class_hash = class_hash_low + 2**128 * class_hash_high
  ///
  ///     let (retdata_size : felt, retdata : felt*) = library_call(
  ///         class_hash=class_hash,
  ///         function_selector=selector,
  ///         calldata_size=calldata_size,
  ///         calldata=calldata,
  ///     )
  ///     return (retdata_size=retdata_size, retdata=retdata)
  /// end
  fallback() external {

  }

  uint256 implementation_hash = 0;

  function setHash(uint256 newHash) external {
    implementation_hash = newHash;
  }
}

// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

import './AccessControl.sol';

contract Executor is AccessControl {
  bytes32 public constant EXECUTOR_ADMIN_ROLE = keccak256('TIMELOCK_ADMIN_ROLE');
  bytes32 public constant PROPOSER_ROLE = keccak256('PROPOSER_ROLE');
  bytes32 public constant EXECUTOR_ROLE = keccak256('EXECUTOR_ROLE');

  /**
   * @dev Initializes the contract with a given `minDelay`.
   */
  constructor(address[] memory proposers, address[] memory executors) {
    _setRoleAdmin(PROPOSER_ROLE, EXECUTOR_ADMIN_ROLE);
    _setRoleAdmin(EXECUTOR_ROLE, EXECUTOR_ADMIN_ROLE);

    // register proposers
    for (uint256 i = 0; i < proposers.length; ++i) {
      _setupRole(PROPOSER_ROLE, proposers[i]);
    }

    // register executors
    for (uint256 i = 0; i < executors.length; ++i) {
      _setupRole(EXECUTOR_ROLE, executors[i]);
    }
  }

  /**
   * @dev Modifier to make a function callable only by a certain role. In
   * addition to checking the sender's role, `address(0)` 's role is also
   * considered. Granting a role to `address(0)` is equivalent to enabling
   * this role for everyone.
   */
  modifier onlyRoleOrOpenRole(bytes32 role) {
    if (!hasRole(role, address(0))) {
      _checkRole(role, _msgSender());
    }
    _;
  }

  /**
   * @dev Contract might receive/hold ETH as part of the maintenance process.
   */
  receive() external payable {}

  /**
   * @dev Returns the identifier of an operation containing a single
   * transaction.
   */
  function hashOperation(
    address target,
    uint256 value,
    bytes calldata data,
    bytes32 predecessor,
    bytes32 salt
  ) public pure virtual returns (bytes32 hash) {
    return keccak256(abi.encode(target, value, data, predecessor, salt));
  }

  /**
   * @dev Returns the identifier of an operation containing a batch of
   * transactions.
   */
  function hashOperationBatch(
    address[] calldata targets,
    uint256[] calldata values,
    bytes[] calldata datas,
    bytes32 predecessor,
    bytes32 salt
  ) public pure virtual returns (bytes32 hash) {
    return keccak256(abi.encode(targets, values, datas, predecessor, salt));
  }

  /**
   * @dev Execute an (ready) operation containing a single transaction.
   *
   * Emits a {CallExecuted} event.
   *
   * Requirements:
   *
   * - the caller must have the 'executor' role.
   */
  function execute(
    address target,
    uint256 value,
    bytes calldata data,
    bytes32 predecessor,
    bytes32 salt
  ) public payable virtual onlyRoleOrOpenRole(EXECUTOR_ROLE) {
    bytes32 id = hashOperation(target, value, data, predecessor, salt);
    _call(id, 0, target, value, data);
  }

  /**
   * @dev Execute an (ready) operation containing a batch of transactions.
   *
   * Emits one {CallExecuted} event per transaction in the batch.
   *
   * Requirements:
   *
   * - the caller must have the 'executor' role.
   */
  function executeBatch(
    address[] calldata targets,
    uint256[] calldata values,
    bytes[] calldata datas,
    bytes32 predecessor,
    bytes32 salt
  ) public payable virtual onlyRoleOrOpenRole(EXECUTOR_ROLE) {
    require(targets.length == values.length, 'TimelockController: length mismatch');
    require(targets.length == datas.length, 'TimelockController: length mismatch');

    bytes32 id = hashOperationBatch(targets, values, datas, predecessor, salt);
    for (uint256 i = 0; i < targets.length; ++i) {
      _call(id, i, targets[i], values[i], datas[i]);
    }
  }

  /**
   * @dev Execute an operation's call.
   *
   * Emits a {CallExecuted} event.
   */
  function _call(
    bytes32 id,
    uint256 index,
    address target,
    uint256 value,
    bytes calldata data
  ) private {
    (bool success, ) = target.call{value: value}(data);
    require(success, 'Executor: underlying transaction reverted');
  }
}

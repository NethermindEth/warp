// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/// @title A simulator for trees
/// @author Larry A. Gardner
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental con tract.
contract Tree {
  /// @notice Calculate tree age in years, rounded up, for live trees
  /// @dev The Alexandr N. Tetearing algorithm could increase precision
  /// @param rings The number of rings from dendrochronological sample
  /// @return Age in years, rounded up for partial years
  function age(uint256 rings) external pure virtual returns (uint256) {
    return rings + 1;
  }

  /// @notice Returns the amount of leaves the tree has.
  /// @dev Returns only a fixed number.
  function leaves() external pure virtual returns (uint256) {
    return 2;
  }
}

contract Plant {
  function leaves() external pure virtual returns (uint256) {
    return 3;
  }
}

contract KumquatTree is Tree, Plant {
  function age(uint256 rings) external pure override returns (uint256) {
    return rings + 2;
  }

  /// Return the amount of leaves that this specific kind of tree has
  /// @inheritdoc Tree
  function leaves() external pure override(Tree, Plant) returns (uint256) {
    return 3;
  }
}

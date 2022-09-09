// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface IBonderRegistry {
    function isBonderAllowed(address bonder, uint256 credit) external view returns (bool);
}
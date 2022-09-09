// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IRootChainManager {
    function depositFor(
        address user,
        address rootToken,
        bytes calldata depositData
    ) external;
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface I_L1_PolygonMessenger {
    function syncState(
        address receiver,
        bytes calldata data
    ) external;
}
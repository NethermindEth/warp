// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IPolygonFxChild {
    function onStateReceive(uint256 stateId, bytes calldata _data) external;
}
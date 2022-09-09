// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface I_L2_PolygonMessengerProxy {
    function sendCrossDomainMessage(bytes memory _calldata) external;
    function xDomainMessageSender() external view returns (address);
    function processMessageFromRoot(
        bytes calldata message
    ) external;
}
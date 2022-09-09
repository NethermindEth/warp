// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface IForeignOmniBridge {
    function relayTokens(address token, address _receiver, uint256 _amount) external;
}

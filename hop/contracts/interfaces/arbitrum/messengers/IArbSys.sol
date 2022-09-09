// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.4.21 <0.7.0;

interface IArbSys {
    // Get ArbOS version number
    function arbOSVersion() external pure returns (uint);

    // Send given amount of Eth to dest with from sender.
    function withdrawEth(address dest) external payable;

    // Send a transaction to L1
    function sendTxToL1(address destAddr, bytes calldata calldataForL1) external payable;

    // Return the number of transactions issued by the given external account
    // or the account sequence number of the given contract
    function getTransactionCount(address account) external view returns(uint256);

    event EthWithdrawal(address indexed destAddr, uint amount);
    event ERC20Withdrawal(address indexed destAddr, address indexed tokenAddr, uint amount);
    event ERC721Withdrawal(address indexed destAddr, address indexed tokenAddr, uint indexed id);
}

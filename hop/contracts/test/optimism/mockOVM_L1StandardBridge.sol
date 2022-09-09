// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
pragma experimental ABIEncoderV2;

contract mockOVM_L1StandardBridge {
    function depositETH (
        uint32 _l2Gas,
        bytes calldata _data
    )
        external
        payable
    {}

    function depositETHTo (
        address _to,
        uint32 _l2Gas,
        bytes calldata _data
    )
        external
        payable
    {}

    function depositERC20 (
        address _l1Token,
        address _l2Token,
        uint _amount,
        uint32 _l2Gas,
        bytes calldata _data
    )
        external
    {}

    function depositERC20To (
        address _l1Token,
        address _l2Token,
        address _to,
        uint _amount,
        uint32 _l2Gas,
        bytes calldata _data
    )
        external
    {}
}
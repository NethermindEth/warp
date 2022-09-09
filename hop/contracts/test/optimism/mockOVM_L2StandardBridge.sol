// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
pragma experimental ABIEncoderV2;

contract mockOVM_L2StandardBridge {
    function withdraw (
        address _l2Token,
        uint _amount,
        uint32 _l1Gas,
        bytes calldata _data
    )
        external
    {}

    function withdrawTo (
        address _l2Token,
        address _to,
        uint _amount,
        uint32 _l1Gas,
        bytes calldata _data
    )
        external
    {}
}
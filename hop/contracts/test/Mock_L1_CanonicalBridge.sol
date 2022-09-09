// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "./Mock_L1_Messenger.sol";

contract Mock_L1_CanonicalBridge {
    using SafeERC20 for IERC20;

    IERC20 public canonicalToken;
    Mock_L1_Messenger public messenger;

    constructor (
        IERC20 _canonicalToken,
        Mock_L1_Messenger _messenger
    )
         public
    {
        canonicalToken = _canonicalToken;
        messenger = _messenger;
    }

    function sendMessage(
        address _target,
        bytes memory _message
    )
        public
    {
        messenger.sendMessage(
            _target,
            _message,
            uint32(0)
        );
    }

    /// @notice Polygon has a different messenger for each token
    function sendTokens(
        address _target,
        address _recipient,
        uint256 _amount,
        bool isPolygon
    )
        public
    {
        bytes memory mintCalldata = abi.encodeWithSignature("mint(address,uint256)", _recipient, _amount);

        canonicalToken.safeTransferFrom(msg.sender, address(this), _amount);

        if (isPolygon) {
            messenger.syncStateCanonicalToken(_target, mintCalldata);
        } else {
            sendMessage(_target, mintCalldata);
        }
    }
}

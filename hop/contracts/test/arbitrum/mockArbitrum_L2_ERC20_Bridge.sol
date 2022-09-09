//SPDX-License-Identifier: Unlicense
pragma solidity >0.6.0 <0.8.0;

import { MockERC20 } from "../MockERC20.sol";
import { IArbSys } from "../../interfaces/arbitrum/messengers/IArbSys.sol";

contract Arbitrum_L2_ERC20_Bridge {
    address public l1ERC20BridgeAddress;
    IArbSys public l2Messenger;

    constructor (
        address _l2Messenger,
        address _l1ERC20BridgeAddress
    ) public {
        l2Messenger = IArbSys(_l2Messenger);
        l1ERC20BridgeAddress = _l1ERC20BridgeAddress;
    }

    function withdraw(address _l1TokenAddress, address _l2TokenAddress, uint256 _amount) public {
        MockERC20(_l2TokenAddress).burn(msg.sender, _amount);

        // generate encoded calldata to be executed on L1
        bytes memory message = abi.encodeWithSignature(
            "withdraw(address,address,uint256)",
            _l1TokenAddress,
            msg.sender,
            _amount
        );

        l2Messenger.sendTxToL1(
            l1ERC20BridgeAddress,
            message
        );
    }
}

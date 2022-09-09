//SPDX-License-Identifier: Unlicense
pragma solidity >0.6.0 <0.8.0;

import { MockERC20 } from "../MockERC20.sol";
import { iAbs_BaseCrossDomainMessenger } from "@eth-optimism/contracts/build/contracts/iOVM/bridge/messaging/iAbs_BaseCrossDomainMessenger.sol";

contract OVM_L2_ERC20_Bridge {
    address public l1ERC20BridgeAddress;
    iAbs_BaseCrossDomainMessenger public l2Messenger;

    constructor (
        address _l2Messenger,
        address _l1ERC20BridgeAddress
    ) public {
        l2Messenger = iAbs_BaseCrossDomainMessenger(_l2Messenger);
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

        // send the message over to the L1CrossDomainMessenger
        uint32 gasLimit = 2500000;
        l2Messenger.sendMessage(l1ERC20BridgeAddress, message, gasLimit);
    }
}

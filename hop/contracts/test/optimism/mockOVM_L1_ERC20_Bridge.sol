//SPDX-License-Identifier: Unlicense
pragma solidity >0.6.0 <0.8.0;

import { MockERC20 } from "../MockERC20.sol";
import { iAbs_BaseCrossDomainMessenger } from "@eth-optimism/contracts/build/contracts/iOVM/bridge/messaging/iAbs_BaseCrossDomainMessenger.sol";

contract OVM_L1_ERC20_Bridge {
    iAbs_BaseCrossDomainMessenger public messenger;
    event Deposit(address indexed _sender, uint256 _amount);

    constructor (
        address _messenger
    ) public {
        messenger = iAbs_BaseCrossDomainMessenger(_messenger);
    }

    function deposit(
        address _l1TokenAddress,
        address _l2TokenAddress,
        address _depositor,
        uint256 _amount
    ) public {
        MockERC20(_l1TokenAddress).transferFrom(
            _depositor,
            address(this),
            _amount
        );

        // generate encoded calldata to be executed on L2
        bytes memory message = abi.encodeWithSignature(
            "mint(address,uint256)",
            _depositor,
            _amount
        );

        uint32 gasLimit = 9000000;
        messenger.sendMessage(_l2TokenAddress, message, gasLimit);

        emit Deposit(_depositor, _amount);
    }

    function withdraw(
        address _l1TokenAddress,
        address _withdrawer,
        uint256 _amount
    ) public {
        MockERC20(_l1TokenAddress).transfer(_withdrawer, _amount);
    }
}

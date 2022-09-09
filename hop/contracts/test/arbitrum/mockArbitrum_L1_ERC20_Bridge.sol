//SPDX-License-Identifier: Unlicense
// @unsupported: ovm
pragma solidity >0.6.0 <0.8.0;

import { MockERC20 } from "../MockERC20.sol";
import { IInbox } from "../../interfaces/arbitrum/messengers//IInbox.sol";

contract Arbitrum_L1_ERC20_Bridge {
    IInbox public messenger;
    event Deposit(address indexed _sender, uint256 _amount);

    constructor (
        address _messenger
    ) public {
        messenger = IInbox(_messenger);
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

        uint256 maxGas = 100000000000;
        messenger.createRetryableTicket(
            _l2TokenAddress,
            0,
            0,
            tx.origin,
            address(0),
            maxGas,
            0,
            message
        );

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

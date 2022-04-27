pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for struct
import { Account } from './importfrom.sol';

contract WARP{
  Account my_account = Account(1000, 50);

  function structImport(uint bal, uint limit) payable public {
    my_account.balance = bal;
    my_account.dailylimit = limit;
    assert(my_account.balance > my_account.dailylimit);
  }
}

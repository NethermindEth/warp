// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract Test {
   event Deposit(address indexed _from, uint112 indexed _id, uint _value);
   function deposit(uint112 _id) public payable {      
      emit Deposit({ _value: 24, _from:address(0x123), _id:_id});
   }
   address public seller;
   modifier onlySeller() {
      require(
         msg.sender == seller,
         "Only seller can call this."
      );
      _;
   }
   function sell(uint amount) public payable onlySeller { 
      if (amount > 2 ether)
         revert("Not enough Ether provided.");
   }
}
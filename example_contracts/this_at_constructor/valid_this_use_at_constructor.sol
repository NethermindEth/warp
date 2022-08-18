pragma solidity ^0.8;

contract Warp {
  address public contractAddress;

  constructor() {
    contractAddress = address(this);
    // However currently, member of address(this) is not supported which gets abandoned by transpiler.
    //eg - address(this).balance, but this behaviour is supported in solidity
  }
}

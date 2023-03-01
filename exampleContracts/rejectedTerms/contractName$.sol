pragma solidity ^0.8.6;

import "./contractNameLib.sol";

contract Test_me {
  function test() public pure returns (S memory) {
    return S(343);
  }
}

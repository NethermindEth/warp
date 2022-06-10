pragma solidity ^0.8.6;

import "./contract_name_lib.sol";

contract Test_me {
  function test() public pure returns (S memory) {
    return S(343);
  }
}

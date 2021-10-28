pragma solidity ^0.8.6;

contract WARP {
   function returnFun() public view returns(string memory){
      return "ABC";
   }

  function bytesFun() public view returns (string memory) {
    string memory x = new string(3);
    bytes memory b = bytes(x);
    b[0] = "A";
    b[1] = "B";
    b[2] = "C";
    return string(x);
  }
}

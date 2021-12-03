pragma solidity >=0.8.6;

contract WARP {
    function rando(uint a, uint b) public payable returns (uint) {
        if (a > b) {
            return a + 21;
        } else {
            return b + 42;
        }
    }
}
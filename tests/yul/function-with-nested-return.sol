pragma solidity >=0.8.6;

contract WARP {
    function test(uint i, uint j) public payable returns (bool) {
        if (i < j) {
            return true;
        }
        return false;
    }
}
pragma solidity >=0.8.6;

contract WARP {
    function transferFrom(uint i, uint j) public payable returns (bool) {
        for (uint k = 0; k < i; k += j) {
            if (k > j) {
                continue;
            }
            k -= 1;
        }
        return true;
    }
}
pragma solidity >=0.8.6;

contract WARP {
    function transferFrom(uint i, uint j) public payable returns (uint) {
        uint cant = 0;
        for (uint k = 0; k < i; k += j) {
            cant += k;
        }
        for(uint k = 0; k < j; k += i) {
            cant += k;
        }
        return cant;
    }
}
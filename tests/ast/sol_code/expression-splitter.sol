pragma solidity >=0.8.6;

contract WARP {
    function power(uint base, uint exponent) public returns (uint) {
        uint result = power(base * base, exponent / 2);
        if(exponent % 2 == 1){
            result = base * result;
        }
        return result;
    }
}
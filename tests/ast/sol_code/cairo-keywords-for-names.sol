pragma solidity >=0.8.6;

contract WARP {
    function func(uint felt, uint end) public payable returns (bool) {
		require(felt != 0);
		uint ret = end + felt;
        return ret > 100;
    }
}
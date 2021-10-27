pragma solidity >=0.8.6;

contract WARP {
    function deposit() public payable returns (uint) {
        uint amount = 0;
		for (uint i = 0; i < 10; ++i){
            for(uint j = i; j < 10; j += 2){
                uint val = i * j;
                for(uint k = 0; k <= 3; ++k){
                    amount += val + k;
                }
            }
        }
        return amount;
    }
}
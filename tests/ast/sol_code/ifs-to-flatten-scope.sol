pragma solidity >=0.8.6;

contract WARP {
    function transfer(uint sender, uint recipient, uint amount) public payable returns (uint res) {
        if (sender != recipient){
            require(amount > 0);
            if(amount > 100){
                res = 100;
            }
            else{
                res = amount;
            }
        }
        else{
            res = 0;
        }
    }
}
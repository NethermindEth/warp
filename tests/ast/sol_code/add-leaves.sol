pragma solidity >=0.8.6;

contract WARP {
    function funA(bool flag) public returns(uint res){
        uint var = 100;
        if(flag){
            res = 1;
        }
        else{
            res = 0;
        }
    }
    function funB() public { }
    function funC() public {
        funB();        
    }
}
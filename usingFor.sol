pragma solidity 0.8.14;

//SPDX-License-Identifier: MIT

library count{

    function addUint(uint a , uint b) public pure returns(uint){
        
        uint c = a + b;
        
        require(c >= a);   // Makre sure the right computation was made
        return c;
    }
}

contract Warp{
    
    using count for uint;
    
    function add(uint a, uint b) public pure returns(uint){
        return a.addUint(b);
    }

}

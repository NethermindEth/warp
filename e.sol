// SPDX-License-Identifier: MIT
pragma solidity ^0.7.1;

contract StackTooDeepTest2 {
    function addUints(
        uint256 a,uint256 b,uint256 c,uint256 d,uint256 e,uint256 f,uint256 g,uint256 h,uint256 i
    ) external pure returns(uint256) {
        
        uint256 result = 0;
        
        {
            result = a+b+c+d+e;
        }
        
        {
            result = result+f+g+h+i;
        }

        return result;
    }
}
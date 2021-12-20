pragma solidity ^0.8.6;

contract WARP {
    function f() public returns(uint ret) {
        ret = 1;
        for (;;) {
            ret += 1;
            if (ret >= 10) break;
        }
    }
}
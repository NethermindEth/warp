pragma solidity ^0.7.6;

contract WARP {

    function test() public view {
        address x = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function testCast() public view {
        address x = address(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    }

}

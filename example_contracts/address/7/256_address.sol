pragma solidity ^0.7.6;

contract WARP {

    function test160(uint160 me) public view {
        address x = address(uint256(me));
    }

    function test256(uint256 me) public view {
        address x = address(me);
        uint256 y = uint256(x);
    }
}

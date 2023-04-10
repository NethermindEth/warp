pragma solidity ^0.7.6;

contract WARP {

    function test() public view {
        address x = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
    }

    function test160(uint160 me) public view {
        address x = address(me);
    }

    function tes160FromAddress(address me) public view {
        uint160 y = uint160(me);
    }

}

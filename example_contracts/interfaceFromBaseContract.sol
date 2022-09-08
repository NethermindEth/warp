pragma solidity ^0.8.0;

// This is a small file to reproduce the bug where interfaces from the base contracts were not being
// generated in the final output

interface I {
    function owner() external view returns (address);
}

contract Base {
    address addr;

    modifier mod() {
        require(msg.sender == I(addr).owner());
        _;
    }

    function test(uint8 x, uint8 y) mod external view {
    }
}

contract WARP is Base {
    function test_fun() external view {}
}

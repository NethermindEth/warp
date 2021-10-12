pragma solidity ^0.8.6;

contract WARP {
    uint private counter;

    function increment() public returns (uint) {
        counter += 1;
        return counter;
    }
}

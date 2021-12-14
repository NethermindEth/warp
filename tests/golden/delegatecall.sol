pragma solidity ^0.8.6;

contract WARP {
    address public owner;
    address public lib;

    constructor(address _lib) {
        owner = msg.sender;
        lib = _lib;
    }

    fallback() external payable {
        lib.delegatecall(msg.data);
    }
}

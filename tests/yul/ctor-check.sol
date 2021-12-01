pragma solidity ^0.8.3;

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

contract WARP {
    address public owner;
    Lib public lib;

    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        address(lib).call(msg.data);
    }
}
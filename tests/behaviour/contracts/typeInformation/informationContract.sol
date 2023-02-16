// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Dummy {
    function dummy0() external pure returns (uint32);

    function dummy1() external pure returns (uint64);
}

contract WARP {
    function getName () public pure returns (string memory) {
        return type(WARP).name;
    }

    function getId() public pure returns (bytes4) {
        return type(Dummy).interfaceId;
    }
}

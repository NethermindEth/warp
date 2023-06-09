pragma solidity ^0.8.6;

contract WARP {

    function test160(uint160 n1, bytes20 n2) public view {
        address a1 = address(uint256(n1));
        address a2 = address(bytes32(n2));
    }

    function test256(uint256 n1, bytes32 n2) public view {
        address a1 = address(n1);
        address a2 = address(n2);

        uint256 m1 = uint256(a1);
        bytes32 m2 = bytes32(a2);
    }
}

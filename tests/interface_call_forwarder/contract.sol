pragma solidity ^0.8.14;

interface Forwarder_contract {
    function add(uint256 a, uint256 b) external returns (uint256 res);

    function sub(uint256 a, uint256 b) external returns (uint256 res);
}

contract itr{
    address public cairoContractAddress;
    constructor(address contractAddress) {
        cairoContractAddress = contractAddress;
    }
    function add(uint256 a, uint256 b) external returns (uint256 res) {
        return Forwarder_contract(cairoContractAddress).add(a, b);
    }
    function sub(uint256 a, uint256 b) external returns (uint256 res) {
        return Forwarder_contract(cairoContractAddress).sub(a, b);
    }
}
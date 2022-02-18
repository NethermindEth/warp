// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WARP {
    uint256 public _totalSupply = 100000000000000;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function addValue(uint256 value) external returns (uint256) {
        _totalSupply += value;
        return _totalSupply;
    }

    function reset() external {
        return delete _totalSupply;
    }

}

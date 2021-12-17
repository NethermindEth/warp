pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Rep is ERC20 {
    constructor() ERC20("Augur token", "REP") {}

    function faucet(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

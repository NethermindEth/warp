// SPDX-License-Identifier: MIT

pragma solidity 0.8;

import "../openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Hop Bridge Tokens or "hTokens" are layer-2 tokens that represent a deposit in the L1_Bridge
 * contract. Each Hop Bridge Token is a regular ERC20 that can be minted and burned by the L2_Bridge
 * that owns it.
 */

contract HopBridgeToken is ERC20, Ownable {

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals
    )
        ERC20(name, symbol)
    {
        _setupDecimals(decimals);
    }

    /**
     * @dev Mint new hToken for the account
     * @param account The account being minted for
     * @param amount The amount being minted
     */
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    /**
     * @dev Burn hToken from the account
     * @param account The account being burned from
     * @param amount The amount being burned
     */
    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8;

import "../openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/ISwap.sol";

/**
 * @title Liquidity Provider Token
 * @notice This token is an ERC20 detailed token with added capability to be minted by the owner.
 * It is used to represent user's shares when providing liquidity to swap contracts.
 */
contract LPToken is ERC20Burnable, Ownable {
    using SafeMath for uint256;

    // Address of the swap contract that owns this LP token. When a user adds liquidity to the swap contract,
    // they receive a proportionate amount of this LPToken.
    ISwap public swap;

    /**
     * @notice Deploys LPToken contract with given name, symbol, and decimals
     * @dev the caller of this constructor will become the owner of this contract
     * @param name_ name of this token
     * @param symbol_ symbol of this token
     * @param decimals_ number of decimals this token will be based on
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public ERC20(name_, symbol_) {
        _setupDecimals(decimals_);
        swap = ISwap(_msgSender());
    }

    /**
     * @notice Mints the given amount of LPToken to the recipient.
     * @dev only owner can call this mint function
     * @param recipient address of account to receive the tokens
     * @param amount amount of tokens to mint
     */
    function mint(address recipient, uint256 amount) external onlyOwner {
        require(amount != 0, "amount == 0");
        _mint(recipient, amount);
    }

    /**
     * @dev Overrides ERC20._beforeTokenTransfer() which get called on every transfers including
     * minting and burning. This ensures that swap.updateUserWithdrawFees are called everytime.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);
        swap.updateUserWithdrawFee(to, amount);
    }
}

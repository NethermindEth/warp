// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "../interfaces/IBonderRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BonderRegistry is IBonderRegistry, Ownable {

    mapping(address => bool) public isBonder;

    event BonderAdded (
        address indexed newBonder
    );

    event BonderRemoved (
        address indexed previousBonder
    );

    constructor(address[] memory bonders) public {
        for (uint256 i = 0; i < bonders.length; i++) {
            isBonder[bonders[i]] = true;
        }
    }

    /**
     * @dev Returns true if the Bonder is currently allowed to bond transfers.
     * @param bonder The bonder in question
     * @return true if the Bonder is currently allowed to bond transfers.
     */
    function isBonderAllowed(address bonder, uint256 /*credit*/) external view override returns (bool) {
        return isBonder[bonder];
    }

    /**
     * @dev Add Bonder to allowlist
     * @param bonder The address being added as a Bonder
     */
    function addBonder(address bonder) external onlyOwner {
        require(isBonder[bonder] == false, "BR: Address is already bonder");
        isBonder[bonder] = true;

        emit BonderAdded(bonder);
    }

    /**
     * @dev Remove Bonder from allowlist
     * @param bonder The address being removed as a Bonder
     */
    function removeBonder(address bonder) external onlyOwner {
        require(isBonder[bonder] == true, "BR: Address is not bonder");
        isBonder[bonder] = false;

        emit BonderRemoved(bonder);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "../../proxy/utils/Initializable.sol";

contract ERC165MissingDataUpgradeable is Initializable {
    function __ERC165MissingData_init() internal onlyInitializing {
    }

    function __ERC165MissingData_init_unchained() internal onlyInitializing {
    }
    function supportsInterface(bytes4 interfaceId) public view {} // missing return

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

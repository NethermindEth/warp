// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../utils/structs/EnumerableMapUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

// UintToAddressMap
contract UintToAddressMapMockUpgradeable is Initializable {
    function __UintToAddressMapMock_init() internal onlyInitializing {
    }

    function __UintToAddressMapMock_init_unchained() internal onlyInitializing {
    }
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;

    event OperationResult(bool result);

    EnumerableMapUpgradeable.UintToAddressMap private _map;

    function contains(uint256 key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(uint256 key, address value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(uint256 key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint256) {
        return _map.length();
    }

    function at(uint256 index) public view returns (uint256 key, address value) {
        return _map.at(index);
    }

    function tryGet(uint256 key) public view returns (bool, address) {
        return _map.tryGet(key);
    }

    function get(uint256 key) public view returns (address) {
        return _map.get(key);
    }

    function getWithMessage(uint256 key, string calldata errorMessage) public view returns (address) {
        return _map.get(key, errorMessage);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}

// AddressToUintMap
contract AddressToUintMapMockUpgradeable is Initializable {
    function __AddressToUintMapMock_init() internal onlyInitializing {
    }

    function __AddressToUintMapMock_init_unchained() internal onlyInitializing {
    }
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.AddressToUintMap;

    event OperationResult(bool result);

    EnumerableMapUpgradeable.AddressToUintMap private _map;

    function contains(address key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(address key, uint256 value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(address key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint256) {
        return _map.length();
    }

    function at(uint256 index) public view returns (address key, uint256 value) {
        return _map.at(index);
    }

    function tryGet(address key) public view returns (bool, uint256) {
        return _map.tryGet(key);
    }

    function get(address key) public view returns (uint256) {
        return _map.get(key);
    }

    function getWithMessage(address key, string calldata errorMessage) public view returns (uint256) {
        return _map.get(key, errorMessage);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}

contract Bytes32ToBytes32MapMockUpgradeable is Initializable {
    function __Bytes32ToBytes32MapMock_init() internal onlyInitializing {
    }

    function __Bytes32ToBytes32MapMock_init_unchained() internal onlyInitializing {
    }
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.Bytes32ToBytes32Map;

    event OperationResult(bool result);

    EnumerableMapUpgradeable.Bytes32ToBytes32Map private _map;

    function contains(bytes32 key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(bytes32 key, bytes32 value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(bytes32 key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint256) {
        return _map.length();
    }

    function at(uint256 index) public view returns (bytes32 key, bytes32 value) {
        return _map.at(index);
    }

    function tryGet(bytes32 key) public view returns (bool, bytes32) {
        return _map.tryGet(key);
    }

    function get(bytes32 key) public view returns (bytes32) {
        return _map.get(key);
    }

    function getWithMessage(bytes32 key, string calldata errorMessage) public view returns (bytes32) {
        return _map.get(key, errorMessage);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}

// UintToUintMap
contract UintToUintMapMockUpgradeable is Initializable {
    function __UintToUintMapMock_init() internal onlyInitializing {
    }

    function __UintToUintMapMock_init_unchained() internal onlyInitializing {
    }
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToUintMap;

    event OperationResult(bool result);

    EnumerableMapUpgradeable.UintToUintMap private _map;

    function contains(uint256 key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(uint256 key, uint256 value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(uint256 key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint256) {
        return _map.length();
    }

    function at(uint256 index) public view returns (uint256 key, uint256 value) {
        return _map.at(index);
    }

    function tryGet(uint256 key) public view returns (bool, uint256) {
        return _map.tryGet(key);
    }

    function get(uint256 key) public view returns (uint256) {
        return _map.get(key);
    }

    function getWithMessage(uint256 key, string calldata errorMessage) public view returns (uint256) {
        return _map.get(key, errorMessage);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}

// Bytes32ToUintMap
contract Bytes32ToUintMapMockUpgradeable is Initializable {
    function __Bytes32ToUintMapMock_init() internal onlyInitializing {
    }

    function __Bytes32ToUintMapMock_init_unchained() internal onlyInitializing {
    }
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.Bytes32ToUintMap;

    event OperationResult(bool result);

    EnumerableMapUpgradeable.Bytes32ToUintMap private _map;

    function contains(bytes32 key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(bytes32 key, uint256 value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(bytes32 key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint256) {
        return _map.length();
    }

    function at(uint256 index) public view returns (bytes32 key, uint256 value) {
        return _map.at(index);
    }

    function tryGet(bytes32 key) public view returns (bool, uint256) {
        return _map.tryGet(key);
    }

    function get(bytes32 key) public view returns (uint256) {
        return _map.get(key);
    }

    function getWithMessage(bytes32 key, string calldata errorMessage) public view returns (uint256) {
        return _map.get(key, errorMessage);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[47] private __gap;
}

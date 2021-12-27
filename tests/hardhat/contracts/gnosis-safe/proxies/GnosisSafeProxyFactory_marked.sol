interface IProxy {
  function masterCopy() external view returns (address);
}
contract GnosisSafeProxy {
  address internal singleton;
  constructor(address _singleton) {
    require(_singleton != address(0), 'Invalid singleton address provided');
    singleton = _singleton;
  }
  fallback() external payable {
    assembly {
      let _singleton := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
      if eq(
        calldataload(0),
        0xa619486e00000000000000000000000000000000000000000000000000000000
      ) {
        mstore(0, _singleton)
        return(0, 0x20)
      }
      calldatacopy(0, 0, calldatasize())
      let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
      returndatacopy(0, 0, returndatasize())
      if eq(success, 0) {
        revert(0, returndatasize())
      }
      return(0, returndatasize())
    }
  }
}
interface IProxyCreationCallback {
  function proxyCreated(
    GnosisSafeProxy proxy,
    address _singleton,
    bytes calldata initializer,
    uint256 saltNonce
  ) external;
}
pragma solidity ^0.8.0;
contract GnosisSafeProxyFactory {
  event ProxyCreation(GnosisSafeProxy proxy, address singleton);
  function createProxy(address singleton, bytes memory data)
    public
    returns (GnosisSafeProxy proxy)
  {
    proxy = new GnosisSafeProxy(singleton);
    if (data.length > 0)
      assembly {
        if eq(call(gas(), proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) {
          revert(0, 0)
        }
      }
    emit ProxyCreation(proxy, singleton);
  }
  function proxyRuntimeCode() public pure returns (bytes memory) {
    return type(GnosisSafeProxy).runtimeCode;
  }
  function proxyCreationCode() public pure returns (bytes memory) {
    return type(GnosisSafeProxy).creationCode;
  }
  function deployProxyWithNonce(
    address _singleton,
    bytes memory initializer,
    uint256 saltNonce
  ) internal returns (GnosisSafeProxy proxy) {
    bytes32 salt = keccak256(abi.encodePacked(keccak256(initializer), saltNonce));
    bytes memory deploymentData = abi.encodePacked(
      type(GnosisSafeProxy).creationCode,
      uint256(uint256(_singleton))
    );
    assembly {
      proxy := create2(0x0, add(0x20, deploymentData), mload(deploymentData), salt)
    }
    require(address(proxy) != address(0), 'Create2 call failed');
  }
  function createProxyWithNonce(
    address _singleton,
    bytes memory initializer,
    uint256 saltNonce
  ) public returns (GnosisSafeProxy proxy) {
    proxy = deployProxyWithNonce(_singleton, initializer, saltNonce);
    if (initializer.length > 0)
      assembly {
        if eq(
          call(gas(), proxy, 0, add(initializer, 0x20), mload(initializer), 0, 0),
          0
        ) {
          revert(0, 0)
        }
      }
    emit ProxyCreation(proxy, _singleton);
  }
  function createProxyWithCallback(
    address _singleton,
    bytes memory initializer,
    uint256 saltNonce,
    IProxyCreationCallback callback
  ) public returns (GnosisSafeProxy proxy) {
    uint256 saltNonceWithCallback = uint256(
      keccak256(abi.encodePacked(saltNonce, callback))
    );
    proxy = createProxyWithNonce(_singleton, initializer, saltNonceWithCallback);
    if (address(callback) != address(0))
      callback.proxyCreated(proxy, _singleton, initializer, saltNonce);
  }
  function calculateCreateProxyWithNonceAddress(
    address _singleton,
    bytes calldata initializer,
    uint256 saltNonce
  ) external returns (GnosisSafeProxy proxy) {
    proxy = deployProxyWithNonce(_singleton, initializer, saltNonce);
    revert(string(abi.encodePacked(proxy)));
  }
}


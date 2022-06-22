pragma solidity ^0.8.10;

contract WARP {
  /// warp-cairo
  /// func __warp_usrfn0_stub() -> ():
  ///     return (5)
  /// end
  function stub() internal returns (uint8) {
    return 0;
  }

  function useCairoStub() public returns (uint8) {
    return stub();
  }
}

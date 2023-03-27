
pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT



interface I{
    function invalid() external returns (uint8);
}


contract A{
    /// warp-cairo
    /// DECORATOR(external)
    /// func CURRENTFUNC()() -> (number : felt) {
    ///     return (783495,);
    /// }
    function invalid() public returns (uint128) {
    }
}


contract WARP{
    function f(address addr) public returns (uint8){
        return I(addr).invalid();
    }
}

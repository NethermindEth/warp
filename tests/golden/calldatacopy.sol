pragma solidity >=0.8.6;

contract WARP {
    function copyFourBytes(uint start) public payable returns (bytes4) {
        assembly {
            calldatacopy(start, 0, 4)
            return(0x0, 4)
        }
    }
}

pragma solidity >=0.8.6;

contract WARP {
    function callMe() public payable returns (bytes4) {
        assembly {
            calldatacopy(0x0, 0, 4)
            return(0x0, 4)
        }
    }
}

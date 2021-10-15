pragma solidity >=0.8.6;

contract WARP {
    function callMe() public payable returns (bytes4) {
        bytes32 ret;
        assembly {
            calldatacopy(0x0, 0, 4)
            ret := mload(0)
        }
        return bytes4(ret);
    }
}

pragma solidity ^0.8.6;

contract WARP {
    function multicall(bytes[] calldata data) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < 3; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            if (!success) {
                assembly {
                    result := add(result, 0x04)
                }
                revert();
            }
            results[i] = result;
        }
    }
}
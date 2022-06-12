contract WARP {
    address[] storageArray;
    function test_indices(uint256 len) public returns (uint)
    {
        while (storageArray.length < len)
            storageArray.push();
        while (storageArray.length > len)
            storageArray.pop();
        return storageArray.length;
    }
}

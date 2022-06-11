contract WARP {
    uint[] storageArray;
    function test_indices(uint256 len) public returns (uint)
    {
        while (storageArray.length < len)
            storageArray.push();
        while (storageArray.length > len)
            storageArray.pop();
        for (uint i = 0; i < len; i++)
            storageArray[i] = i + 1;

        for (uint i = 0; i < len; i++)
            require(storageArray[i] == i + 1);

        return storageArray.length;
    }
}

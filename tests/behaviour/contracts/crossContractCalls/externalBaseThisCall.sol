contract Base {
    function baseFunc(uint256[] calldata a) external virtual returns (uint256) {
        return a[0];
    }
}


contract WARP is Base {
    function baseFunc(uint256[] memory a) public override returns (uint256) {
        return a[1];
    }

    function externalCallSelfAsBase() public returns (uint256) {
        uint256[] memory m = new uint256[](2);
        m[0] = 42;
        m[1] = 23;
        return Base(this).baseFunc(m);
    }
}

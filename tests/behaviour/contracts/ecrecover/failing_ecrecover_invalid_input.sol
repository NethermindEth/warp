contract WARP {
    uint256 constant SECP256K1_N = 115792089237316195423570985008687907852837564279074904382605163141518161494337;

    // ecrecover should return zero for malformed input
    // (v should be 27 or 28, not 1)
    // Note that the precompile does not return zero but returns nothing.
    function f() public returns (uint160) {
        return ecrecover(bytes32(type(uint256).max), 1, bytes32(uint(2)), bytes32(uint(3)));
    }

    // should return 0 on r=0
    function g() public returns (uint160) {
        return ecrecover(bytes32(type(uint256).max), 27, bytes32(uint(0)), bytes32(uint(1)));
    }

    // should return 0 on s=0
    function h() public returns (uint160) {
        return ecrecover(bytes32(type(uint256).max), 27, bytes32(uint(1)), bytes32(uint(0)));
    }

    // should return 0 on r>=n
    function i() public returns (uint160) {
        return ecrecover(bytes32(type(uint256).max), 27, bytes32(SECP256K1_N), bytes32(uint(1)));
    }

    // should return 0 on s>=n
    function j() public returns (uint160) {
        return ecrecover(bytes32(type(uint256).max), 27, bytes32(uint(1)), bytes32(SECP256K1_N));
    }
}
// ====
// compileViaYul: also
// ----
// f() -> 0
// g() -> 0
// h() -> 0
// i() -> 0
// j() -> 0

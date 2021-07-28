def is_valid_uintN(n: int, x: int):
    return 0 <= x < 2 ** n


UINT256_BOUND = 2 ** 256
UINT256_HALF_BOUND = 2 ** 255
UINT128_BOUND = 2 ** 128


def int256_to_uint256(x: int) -> int:
    assert -UINT256_HALF_BOUND <= x < UINT256_HALF_BOUND
    return UINT256_BOUND + x if x < 0 else x


def uint256_to_int256(x: int) -> int:
    assert 0 <= x < UINT256_BOUND
    return x - UINT256_BOUND if x >= UINT256_HALF_BOUND else x

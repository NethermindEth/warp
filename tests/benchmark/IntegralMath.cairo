%lang starknet
%builtins pedersen range_check bitwise

from evm.uint256 import (
    is_eq, is_gt, is_lt, u256_add, u256_div, u256_mul, u256_shl, u256_shr, uint256_exp,
    uint256_mod, uint256_mulmod)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_or, uint256_not, uint256_sub)

const MAX_VAL = 2 ** 128 - 1

@view
func safeAdd{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (_not_y : Uint256) = uint256_not(y)
    let (_cond : Uint256) = is_gt(x, _not_y)
    if _cond.low + _cond.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    return u256_add(x, y)
end

@view
func unsafeAdd{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    return u256_add(x, y)
end

@view
func unsafeSub{range_check_ptr}(x : Uint256, y : Uint256) -> (diff : Uint256):
    return uint256_sub(x, y)
end

@view
func unsafeMul{range_check_ptr}(x : Uint256, y : Uint256) -> (prod : Uint256):
    return u256_mul(x, y)
end

@view
func mulMod{range_check_ptr}(x : Uint256, y : Uint256, z : Uint256) -> (res : Uint256):
    return uint256_mulmod(x, y, z)
end

@view
func mulModMax{range_check_ptr}(x : Uint256, y : Uint256) -> (res : Uint256):
    return uint256_mulmod(x, y, Uint256(MAX_VAL, MAX_VAL))
end

func block_0{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(n : Uint256, r : felt) -> (n : Uint256, r : felt):
    alloc_locals
    let (_cond : Uint256) = is_gt(n, Uint256(1, 0))
    if _cond.low + _cond.low == 0:
        return (n, r)
    end

    let (_val_0 : Uint256) = u256_shr(Uint256(1, 0), n)
    return block_0(_val_0, r + 1)
end

func block_5{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        _cond : Uint256, n : Uint256, s : Uint256, r : felt) -> (a : Uint256, b : felt):
    alloc_locals
    if _cond.low + _cond.low == 0:
        let (_val_0 : Uint256) = u256_shr(s, n)
        let (_val_1 : Uint256) = uint256_or(Uint256(r, 0), s)
        return (_val_0, _val_1.low)
    end
    return (n, r)
end

func block_1{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        n : Uint256, r : felt, s : Uint256) -> (n : Uint256, r : felt):
    alloc_locals
    let (_cond_0 : Uint256) = is_gt(s, Uint256(0, 0))
    if _cond_0.low + _cond_0.low == 0:
        return (n, r)
    end

    let (_val_0 : Uint256) = u256_shl(Uint256(1, 0), s)
    let (_cond_1 : Uint256) = is_lt(n, _val_0)
    let (n, r) = block_5(_cond_1, n, s, r)

    let (_val_1 : Uint256) = u256_shr(Uint256(1, 0), s)
    let s = _val_1
    return block_1(n, r, s)
end

# @dev Compute the largest integer smaller than or equal to the binary logarithm of `n`
@external
func floorLog2{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(n : Uint256) -> (res):
    alloc_locals

    let (_cond : Uint256) = is_lt(n, Uint256(256, 0))
    if _cond.low + _cond.high != 0:
        let (_, res : felt) = block_0(n, 0)
        return (res)
    else:
        let (_, res : felt) = block_1(n, 0, Uint256(128, 0))
        return (res)
    end
end

func block_2{range_check_ptr}(n : Uint256, x : Uint256, y : Uint256) -> (x : Uint256, y : Uint256):
    alloc_locals
    let (_cond : Uint256) = is_gt(x, y)
    if _cond.low + _cond.low == 0:
        return (x, y)
    end

    let (_val_0 : Uint256) = u256_div(n, y)
    let (_val_1 : Uint256) = u256_add(y, _val_0)
    let (y_val : Uint256) = u256_div(_val_1, Uint256(2, 0))

    return block_2(n, y, y_val)
end

# @dev Compute the largest integer smaller than or equal to the square root of `n`
@external
func floorSqrt{range_check_ptr}(n : Uint256) -> (res : Uint256):
    alloc_locals
    let (_cond : Uint256) = is_gt(n, Uint256(0, 0))
    if _cond.low + _cond.high != 0:
        let (_val_0 : Uint256) = u256_div(n, Uint256(2, 0))
        let (x : Uint256) = u256_add(_val_0, Uint256(1, 0))
        let (_val_1 : Uint256) = u256_div(n, x)
        let (_val_2 : Uint256) = u256_add(x, _val_1)
        let (y : Uint256) = u256_div(_val_2, Uint256(2, 0))
        let (x, _) = block_2(n, x, y)
        return (res=x)
    end
    let res : Uint256 = Uint256(low=0, high=0)
    return (res)
end

# @dev Compute the smallest integer larger than or equal to the square root of `n`
@external
func ceilSqrt{range_check_ptr}(n : Uint256) -> (res : Uint256):
    alloc_locals
    let (x : Uint256) = floorSqrt(n)
    let (_val_0 : Uint256) = uint256_exp(x, Uint256(2, 0))
    let (_cond : Uint256) = is_eq(_val_0, n)
    if _cond.low + _cond.high != 0:
        return (res=x)
    end
    return u256_add(x, Uint256(1, 0))
end

func block_6{range_check_ptr}(
        _cond : Uint256, x : Uint256, y : Uint256, z : Uint256, n : Uint256) -> (
        a : Uint256, b : Uint256):
    if _cond.low + _cond.high == 0:
        let (_val : Uint256) = u256_mul(y, z)
        let (n_val : Uint256) = uint256_sub(n, _val)
        let (x_val : Uint256) = u256_add(x, Uint256(1, 0))
        return (x_val, n_val)
    end
    return (x, n)
end

func block_3{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(n : Uint256, x : Uint256, y : Uint256) -> (n : Uint256, x : Uint256):
    alloc_locals
    let (_cond_0 : Uint256) = is_gt(y, Uint256(0, 0))
    if _cond_0.low + _cond_0.high == 0:
        return (n, x)
    end
    let (x_val : Uint256) = u256_shl(Uint256(1, 0), x)
    let (_val_0 : Uint256) = u256_mul(Uint256(3, 0), x_val)
    let (_val_1 : Uint256) = u256_add(x_val, Uint256(1, 0))
    let (_val_2 : Uint256) = u256_mul(_val_0, _val_1)
    let (z : Uint256) = u256_add(_val_2, Uint256(1, 0))
    let (_val_3 : Uint256) = u256_div(n, y)
    let (_cond_1 : Uint256) = is_lt(_val_3, z)
    let (x_val, n_val : Uint256) = block_6(_cond_1, x_val, y, z, n)
    let (y_val : Uint256) = u256_shr(Uint256(3, 0), y)
    return block_3(n_val, x_val, y_val)
end

# @dev Compute the largest integer smaller than or equal to the cubic root of `n`
@external
func floorCbrt{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(n : Uint256) -> (res : Uint256):
    alloc_locals
    let x : Uint256 = Uint256(0, 0)
    let (y : Uint256) = u256_shl(Uint256(255, 0), Uint256(1, 0))
    let (_, x) = block_3(n, x, y)
    return (res=x)
end

# @dev Compute the smallest integer larger than or equal to the cubic root of `n`
@external
func ceilCbrt{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(n : Uint256) -> (res : Uint256):
    alloc_locals
    let (x : Uint256) = floorCbrt(n)
    let (_sq : Uint256) = u256_mul(x, x)
    let (_val : Uint256) = u256_mul(x, _sq)
    let (_cond : Uint256) = is_eq(_val, n)
    if _cond.low + _cond.high != 0:
        return (res=x)
    end
    let (res) = u256_add(x, Uint256(1, 0))
    return (res)
end

# @dev Compute the nearest integer to the quotient of `n` and `d` (or `n / d`)
@external
func roundDiv{range_check_ptr}(n : Uint256, d : Uint256) -> (res : Uint256):
    alloc_locals
    let (_val_0 : Uint256) = u256_div(n, d)
    let (_val_1 : Uint256) = uint256_mod(n, d)
    let (_val_2 : Uint256) = u256_div(d, Uint256(2, 0))
    let (_val_3 : Uint256) = uint256_sub(d, _val_2)
    let (_val_4 : Uint256) = u256_div(_val_1, _val_3)
    return u256_add(_val_0, _val_4)
end

# @dev Compute the value of `x * y`
@external
func mul512{range_check_ptr}(x : Uint256, y : Uint256) -> (a : Uint256, b : Uint256):
    alloc_locals
    let (p : Uint256) = mulModMax(x, y)
    let (q : Uint256) = unsafeMul(x, y)
    let (_cond : Uint256) = is_lt(p, q)
    if _cond.low + _cond.high == 0:
        let (_val : Uint256) = uint256_sub(p, q)
        return (_val, q)
    end
    let (_val_0 : Uint256) = unsafeSub(p, q)
    let (_val_1 : Uint256) = uint256_sub(_val_0, Uint256(1, 0))
    return (_val_1, q)
end

# @dev Compute the value of `2 ^ 256 * xh + xl - y`, where `2 ^ 256 * xh + xl >= y`
@external
func sub512{range_check_ptr}(xh : Uint256, xl : Uint256, y : Uint256) -> (a : Uint256, b : Uint256):
    alloc_locals
    let (_cond : Uint256) = is_lt(xl, y)
    if _cond.low + _cond.high == 0:
        let (_val_0 : Uint256) = uint256_sub(xl, y)
        return (xh, _val_0)
    end
    let (_val_1 : Uint256) = uint256_sub(xh, Uint256(1, 0))
    let (_val_2 : Uint256) = unsafeSub(xl, y)
    return (_val_1, _val_2)
end

# @dev Compute the value of `(2 ^ 256 * xh + xl) / pow2n`, where `xl` is divisible by `pow2n`
@external
func div512{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(xh : Uint256, xl : Uint256, pow2n : Uint256) -> (res : Uint256):
    alloc_locals
    let (_val_0 : Uint256) = unsafeSub(Uint256(0, 0), pow2n)
    let (_val_1 : Uint256) = u256_div(_val_0, pow2n)
    # `1 << (256 - n)`
    let (pow2nInv : Uint256) = unsafeAdd(_val_1, Uint256(1, 0))
    let (_val_2 : Uint256) = unsafeMul(xh, pow2nInv)
    let (_val_3 : Uint256) = u256_div(xl, pow2n)
    let (_val_4 : Uint256) = uint256_or(_val_2, _val_3)
    # `(xh << (256 - n)) | (xl >> n)`
    return (res=_val_4)
end

func block_4{range_check_ptr}(x : Uint256, d : Uint256, i : Uint256) -> (res : Uint256):
    alloc_locals
    let (_cond : Uint256) = is_lt(i, Uint256(8, 0))
    if _cond.low + _cond.high == 0:
        return (res=x)
    end
    # `x = x * (2 - x * d) mod 2 ^ 256`
    let (_val_0 : Uint256) = unsafeMul(x, d)
    let (_val_1 : Uint256) = unsafeSub(Uint256(2, 0), _val_0)
    let (x_val : Uint256) = unsafeMul(x, _val_1)
    let (i_val : Uint256) = u256_add(i, Uint256(1, 0))
    return block_4(x_val, d, i_val)
end

# @dev Compute the inverse of `d` modulo `2 ^ 256`, where `d` is congruent to `1` modulo `2`
@external
func inv256{range_check_ptr}(d : Uint256) -> (res : Uint256):
    alloc_locals
    # approximate the root of `f(x) = 1 / x - d` using the newton–raphson convergence method
    let x : Uint256 = Uint256(1, 0)
    return block_4(x, d, Uint256(0, 0))
end

# @dev Compute the largest integer smaller than or equal to `x * y / z`
@external
func mulDivF{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        x : Uint256, y : Uint256, z : Uint256) -> (res : Uint256):
    alloc_locals
    let (xyh : Uint256, xyl : Uint256) = mul512(x, y)
    let (_cond_0 : Uint256) = is_eq(xyh, Uint256(0, 0))
    # `x * y < 2 ^ 256`
    if _cond_0.low + _cond_0.high != 0:
        let (result) = u256_div(xyl, z)
        return (result)
    end
    # `x * y / z < 2 ^ 256`
    let (_cond_1 : Uint256) = is_lt(xyh, z)
    if _cond_1.low + _cond_1.high != 0:
        # `m = x * y % z`
        let (m : Uint256) = mulMod(x, y, z)
        # `n = x * y - m` hence `n / z = floor(x * y / z)`
        let (nh : Uint256, nl : Uint256) = sub512(xyh, xyl, m)
        # `n < 2 ^ 256`
        let (_cond_2 : Uint256) = is_eq(nh, Uint256(0, 0))
        if _cond_2.low + _cond_2.high != 0:
            let (result) = u256_div(nl, z)
            return (result)
        end
        let (_val_0 : Uint256) = unsafeSub(Uint256(0, 0), z)
        # `p` is the largest power of 2 which `z` is divisible by
        let (p : Uint256) = uint256_and(_val_0, z)
        # `n` is divisible by `p` because `n` is divisible by `z` and `z` is divisible by `p`
        let (q : Uint256) = div512(nh, nl, p)
        let (_val_1 : Uint256) = u256_div(z, p)
        # `z / p = 1 mod 2` hence `inverse(z / p) = 1 mod 2 ^ 256`
        let (r : Uint256) = inv256(_val_1)
        # `q * r = (n / p) * inverse(z / p) = n / z`
        let (result) = unsafeMul(q, r)
        return (result)
    end
    # `x * y / z >= 2 ^ 256`
    assert 0 = 1
    jmp rel 0
end

# @dev Compute the smallest integer larger than or equal to `x * y / z`
@external
func mulDivC{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        x : Uint256, y : Uint256, z : Uint256) -> (res : Uint256):
    alloc_locals
    let (w : Uint256) = mulDivF(x, y, z)
    let (_val_0 : Uint256) = mulMod(x, y, z)
    let (_cond_0 : Uint256) = is_gt(_val_0, Uint256(0, 0))
    if _cond_0.low + _cond_0.high != 0:
        let (result) = safeAdd(w, Uint256(1, 0))
        return (result)
    end
    return (res=w)
end

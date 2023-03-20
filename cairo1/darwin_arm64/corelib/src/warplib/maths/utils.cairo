from starkware.cairo.common.math import split_felt, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256, uint256_le

func get_max{range_check_ptr}(op1, op2) -> (result: felt) {
    let le = is_le(op1, op2);
    if (le == 1) {
        return (op2,);
    } else {
        return (op1,);
    }
}

func get_min{range_check_ptr}(op1, op2) -> (result: felt) {
    let le = is_le(op1, op2);
    if (le == 1) {
        return (op1,);
    } else {
        return (op2,);
    }
}

func floor_div{range_check_ptr}(a, b) -> (res: felt) {
    let (q, _) = unsigned_div_rem(a, b);
    return (q,);
}

func ceil_div{range_check_ptr}(a, b) -> (res: felt) {
    let (q, r) = unsigned_div_rem(a, b);
    if (r == 0) {
        return (q,);
    } else {
        return (q + 1,);
    }
}

func update_msize{range_check_ptr}(msize, offset, size) -> (result: felt) {
    // Update MSIZE on memory access from 'offset' to 'offset +
    // size', according to the rules specified in the yellow paper.
    if (size == 0) {
        return (msize,);
    }

    let (result) = get_max(msize, offset + size);
    return (result,);
}

func round_down_to_multiple{range_check_ptr}(x, div) -> (y: felt) {
    let (r) = floor_div(x, div);
    return (r * div,);
}

func round_up_to_multiple{range_check_ptr}(x, div) -> (y: felt) {
    let (r) = ceil_div(x, div);
    return (r * div,);
}

func felt_to_uint256{range_check_ptr}(x) -> (x_: Uint256) {
    let split = split_felt(x);
    return (Uint256(low=split.low, high=split.high),);
}

func uint256_to_address_felt(x: Uint256) -> (address: felt) {
    return (x.low + x.high * 2 ** 128,);
}

func narrow_safe{range_check_ptr}(x: Uint256) -> (val: felt) {
    let (boundHigh, boundLow) = split_felt(-1);
    let (inRange) = uint256_le(x, Uint256(boundLow, boundHigh));
    assert inRange = 1;
    return (x.low + 2 ** 128 * x.high,);
}

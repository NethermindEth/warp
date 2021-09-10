%lang starknet
%builtins pedersen range_check

from evm.uint256 import is_gt, is_lt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_sub
from starkware.starknet.common.storage import Storage

@storage_var
func evm_storage(low : felt, high : felt, part : felt) -> (res : felt):
end

func s_load{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256, value : Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end

func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_i : Uint256, var_j : Uint256) -> (var : Uint256):
    alloc_locals
    local var_k : Uint256 = Uint256(low=0, high=0)
    let (var_k) = __warp_loop_0(var_j, var_k)

    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_transferFrom_external{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_i_low, var_i_high, var_j_low, var_j_high) -> (var_low, var_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var) = fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        Uint256(var_i_low, var_i_high), Uint256(var_j_low, var_j_high))
    return (var.low, var.high)
end

func revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=0, high=0)
    local _2_19 : Uint256 = _1_18
    assert 0 = 1
    return ()
end

func __warp_loop_body_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        __warp_break_0 : Uint256, var_j : Uint256, var_k : Uint256) -> (
        __warp_break_0 : Uint256, var_k : Uint256):
    alloc_locals

    let (local _1_11 : Uint256) = is_gt(var_k, var_j)

    let (__warp_break_0) = __warp_block_0_if(_1_11, __warp_break_0)

    let (var_k) = uint256_sub(var_k)

    let (var_k) = u256_add(var_k, var_j)

    return (__warp_break_0, var_k)
end

func __warp_loop_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals

    let (local __warp_subexpr_0 : Uint256) = is_lt(var_k, var_i)
    local memory_dict : DictAccess* = memory_dict
    let (var_k) = __warp_block_1_if(__warp_subexpr_0, var_j, var_k)

    return (var_k)
end

func __warp_block_0_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_1_11 : Uint256, __warp_break_0 : Uint256) -> (
        __warp_break_0 : Uint256):
    alloc_locals
    if _1_11.low + _1_11.high != 0:
        local __warp_break_0 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_0)
        return (__warp_break_0)
    else:
        return (__warp_break_0)
    end
end

func __warp_block_1_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        __warp_subexpr_0 : Uint256, var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_k) = __warp_block_2(var_j, var_k)

        return (var_k)
    else:
        return (var_k)
    end
end

func __warp_block_2{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    local __warp_break_0 : Uint256 = Uint256(low=0, high=0)
    let (__warp_break_0, var_k) = __warp_loop_body_0(__warp_break_0, var_j, var_k)

    let (var_k) = __warp_block_3_if(__warp_break_0, var_j, var_k)

    return (var_k)
end

func __warp_block_3_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        __warp_break_0 : Uint256, var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    if __warp_break_0.low + __warp_break_0.high != 0:
        return (var_k)
    else:
        let (var_k) = __warp_loop_0(var_j, var_k)

        return (var_k)
    end
end


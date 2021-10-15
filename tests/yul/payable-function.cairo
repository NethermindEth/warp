%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_lt
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_sub, uint256_xor)
from starkware.starknet.common.storage import Storage

func __warp_if_0{range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_res : Uint256) = uint256_xor(expr, var_wad)
        local range_check_ptr = range_check_ptr
        return (var_res)
    else:
        let (local var_res : Uint256) = uint256_and(expr, var_wad)
        local range_check_ptr = range_check_ptr
        return (var_res)
    end
end

func __warp_block_1{range_check_ptr}(expr : Uint256, match_var : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_if_0(__warp_subexpr_0, expr, var_wad)
    local range_check_ptr = range_check_ptr
    return (var_res)
end

func __warp_block_0{range_check_ptr}(_3_18 : Uint256, expr : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    local match_var : Uint256 = _3_18
    let (local var_res : Uint256) = __warp_block_1(expr, match_var, var_wad)
    local range_check_ptr = range_check_ptr
    return (var_res)
end

func fun_payableFunction{range_check_ptr}(
        var_src : Uint256, var_dst : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (local var_res : Uint256) = uint256_and(var_src, var_dst)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = uint256_xor(var_src, var_dst)
    local range_check_ptr = range_check_ptr
    local _1_16 : Uint256 = Uint256(low=4, high=0)
    let (local _2_17 : Uint256) = uint256_sub(var_res, var_sender)
    local range_check_ptr = range_check_ptr
    let (local _3_18 : Uint256) = is_lt(_2_17, _1_16)
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_0(_3_18, expr, var_wad)
    local range_check_ptr = range_check_ptr
    local var : Uint256 = var_res
    return (var)
end

@external
func fun_payableFunction_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_payableFunction(var_src, var_dst, var_wad, var_sender)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_gt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not
from starkware.starknet.common.storage import Storage

func __warp_cond_revert(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_add_uint256_141{range_check_ptr}(x : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_3 : Uint256) = uint256_not(Uint256(low=42, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_4 : Uint256) = is_gt(x, _1_3)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_4)
    local _3_5 : Uint256 = Uint256(low=42, high=0)
    let (local sum : Uint256) = u256_add(x, _3_5)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_add_uint256{range_check_ptr}(x_6 : Uint256) -> (sum_7 : Uint256):
    alloc_locals
    let (local _1_8 : Uint256) = uint256_not(Uint256(low=21, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_9 : Uint256) = is_gt(x_6, _1_8)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_9)
    local _3_10 : Uint256 = Uint256(low=21, high=0)
    let (local sum_7 : Uint256) = u256_add(x_6, _3_10)
    local range_check_ptr = range_check_ptr
    return (sum_7)
end

func __warp_block_1{range_check_ptr}(match_var : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_5 : Uint256, var : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var : Uint256) = checked_add_uint256_141(var_b)
        local range_check_ptr = range_check_ptr
        local __warp_leave_5 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_5, var)
    else:
        let (local var : Uint256) = checked_add_uint256(var_a)
        local range_check_ptr = range_check_ptr
        local __warp_leave_5 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_5, var)
    end
end

func __warp_block_0{range_check_ptr}(_1_11 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_5 : Uint256, var : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_11
    let (local __warp_leave_5 : Uint256, local var : Uint256) = __warp_block_1(
        match_var, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_5.low + __warp_leave_5.high != 0:
        return (__warp_leave_5, var)
    else:
        return (__warp_leave_5, var)
    end
end

func fun_rando{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    local __warp_leave_5 : Uint256 = Uint256(low=0, high=0)
    let (local _1_11 : Uint256) = is_gt(var_a, var_b)
    local range_check_ptr = range_check_ptr
    let (local __warp_leave_5 : Uint256, local var : Uint256) = __warp_block_0(_1_11, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_5.low + __warp_leave_5.high != 0:
        return (var)
    else:
        return (var)
    end
end

@external
func fun_rando_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_rando(var_a, var_b)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

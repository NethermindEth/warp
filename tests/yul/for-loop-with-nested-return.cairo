%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_gt, is_lt, is_zero, u256_add
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

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_5 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_6 : Uint256) = is_gt(x, _1_5)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_6)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_sub_uint256{range_check_ptr}(x_7 : Uint256) -> (diff : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=1, high=0)
    let (local _2_9 : Uint256) = is_lt(x_7, _1_8)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_9)
    let (local _3_10 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local diff : Uint256) = u256_add(x_7, _3_10)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func __warp_loop_body_0{range_check_ptr}(
        __warp_leave_0 : Uint256, var : Uint256, var_j : Uint256, var_k : Uint256,
        var_k_1 : Uint256) -> (__warp_leave_0 : Uint256, var : Uint256, var_k_1 : Uint256):
    alloc_locals
    let (local _1_11 : Uint256) = is_gt(var_k_1, var_j)
    local range_check_ptr = range_check_ptr
    if _1_11.low + _1_11.high != 0:
        local var : Uint256 = var_k
        local __warp_leave_0 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_0, var, var_k_1)
    end
    let (local var_k_1 : Uint256) = checked_sub_uint256(var_k_1)
    local range_check_ptr = range_check_ptr
    let (local var_k_1 : Uint256) = checked_add_uint256(var_k_1, var_j)
    local range_check_ptr = range_check_ptr
    return (__warp_leave_0, var, var_k_1)
end

func __warp_loop_0{range_check_ptr}(
        __warp_leave_0 : Uint256, var : Uint256, var_i : Uint256, var_j : Uint256, var_k : Uint256,
        var_k_1 : Uint256) -> (__warp_leave_0 : Uint256, var : Uint256, var_k_1 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(var_k_1, var_i)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (__warp_leave_0, var, var_k_1)
    end
    let (local __warp_leave_0 : Uint256, local var : Uint256,
        local var_k_1 : Uint256) = __warp_loop_body_0(__warp_leave_0, var, var_j, var_k, var_k_1)
    local range_check_ptr = range_check_ptr
    if __warp_leave_0.low + __warp_leave_0.high != 0:
        return (__warp_leave_0, var, var_k_1)
    end
    let (local __warp_leave_0 : Uint256, local var : Uint256,
        local var_k_1 : Uint256) = __warp_loop_0(__warp_leave_0, var, var_i, var_j, var_k, var_k_1)
    local range_check_ptr = range_check_ptr
    return (__warp_leave_0, var, var_k_1)
end

func __warp_block_0{range_check_ptr}(
        __warp_leave_8 : Uint256, var : Uint256, var_i : Uint256, var_j : Uint256, var_k : Uint256,
        var_k_1 : Uint256) -> (__warp_leave_8 : Uint256, var : Uint256, var_k_1 : Uint256):
    alloc_locals
    local __warp_leave_0 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_leave_0 : Uint256, local var : Uint256,
        local var_k_1 : Uint256) = __warp_loop_0(__warp_leave_0, var, var_i, var_j, var_k, var_k_1)
    local range_check_ptr = range_check_ptr
    if __warp_leave_0.low + __warp_leave_0.high != 0:
        local __warp_leave_8 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_8, var, var_k_1)
    else:
        return (__warp_leave_8, var, var_k_1)
    end
end

func fun_transferFrom{range_check_ptr}(var_i : Uint256, var_j : Uint256) -> (var : Uint256):
    alloc_locals
    local var : Uint256 = Uint256(low=0, high=0)
    local __warp_leave_8 : Uint256 = Uint256(low=0, high=0)
    local var_k : Uint256 = Uint256(low=0, high=0)
    local var_k_1 : Uint256 = var_k
    let (local __warp_leave_8 : Uint256, local var : Uint256,
        local var_k_1 : Uint256) = __warp_block_0(__warp_leave_8, var, var_i, var_j, var_k, var_k_1)
    local range_check_ptr = range_check_ptr
    if __warp_leave_8.low + __warp_leave_8.high != 0:
        return (var)
    end
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_i : Uint256, var_j : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_transferFrom(var_i, var_j)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

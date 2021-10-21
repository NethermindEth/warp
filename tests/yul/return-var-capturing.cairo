%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_eq, uint256_not, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func this_address() -> (res : felt):
end

@storage_var
func address_initialized() -> (res : felt):
end

func initialize_address{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end

func __warp_cond_revert(_3_3 : Uint256) -> ():
    alloc_locals
    if _3_3.low + _3_3.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=64, high=0)
    let (local _2_2 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, _1_1)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    let (local value0 : Uint256) = calldata_load(headStart.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_4 : Uint256 = Uint256(low=32, high=0)
    let (local _5_5 : Uint256) = u256_add(headStart, _4_4)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldata_load(_5_5.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0, value1)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_9 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_10 : Uint256) = is_gt(x, _1_9)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_10)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_block_2{range_check_ptr}(var_b : Uint256) -> (__warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local _2_12 : Uint256 = Uint256(low=42, high=0)
    let (local var : Uint256) = checked_add_uint256(var_b, _2_12)
    local range_check_ptr = range_check_ptr
    local __warp_leave_2 : Uint256 = Uint256(low=1, high=0)
    return (__warp_leave_2, var)
end

func __warp_block_3{range_check_ptr}(var_a : Uint256) -> (__warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local _3_13 : Uint256 = Uint256(low=21, high=0)
    let (local var : Uint256) = checked_add_uint256(var_a, _3_13)
    local range_check_ptr = range_check_ptr
    local __warp_leave_2 : Uint256 = Uint256(low=1, high=0)
    return (__warp_leave_2, var)
end

func __warp_if_2{range_check_ptr}(
        __warp_leave_9 : Uint256, __warp_subexpr_0 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_2 : Uint256, __warp_leave_9 : Uint256, var : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local __warp_leave_2 : Uint256, local var : Uint256) = __warp_block_2(var_b)
        local range_check_ptr = range_check_ptr
        if __warp_leave_2.low + __warp_leave_2.high != 0:
            local __warp_leave_9 : Uint256 = Uint256(low=1, high=0)
            return (__warp_leave_2, __warp_leave_9, var)
        else:
            return (__warp_leave_2, __warp_leave_9, var)
        end
    else:
        let (local __warp_leave_2 : Uint256, local var : Uint256) = __warp_block_3(var_a)
        local range_check_ptr = range_check_ptr
        if __warp_leave_2.low + __warp_leave_2.high != 0:
            local __warp_leave_9 : Uint256 = Uint256(low=1, high=0)
            return (__warp_leave_2, __warp_leave_9, var)
        else:
            return (__warp_leave_2, __warp_leave_9, var)
        end
    end
end

func __warp_block_1{range_check_ptr}(match_var : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local __warp_leave_9 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_leave_2 : Uint256, local __warp_leave_9 : Uint256,
        local var : Uint256) = __warp_if_2(__warp_leave_9, __warp_subexpr_0, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_9.low + __warp_leave_9.high != 0:
        return (__warp_leave_2, var)
    else:
        return (__warp_leave_2, var)
    end
end

func __warp_block_0{range_check_ptr}(_1_11 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_11
    let (local __warp_leave_2 : Uint256, local var : Uint256) = __warp_block_1(
        match_var, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_2.low + __warp_leave_2.high != 0:
        return (__warp_leave_2, var)
    else:
        return (__warp_leave_2, var)
    end
end

func fun_rando{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    local __warp_leave_2 : Uint256 = Uint256(low=0, high=0)
    let (local _1_11 : Uint256) = is_gt(var_a, var_b)
    local range_check_ptr = range_check_ptr
    let (local __warp_leave_2 : Uint256, local var : Uint256) = __warp_block_0(_1_11, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_2.low + __warp_leave_2.high != 0:
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

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos.low, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_6 : Uint256, value0_7 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_6, _1_8)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_7, headStart_6)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _13 : Uint256 = _4
    local _14 : Uint256 = _3
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_rando(param, param_1)
    local range_check_ptr = range_check_ptr
    local _15 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = uint256_sub(_16, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_5(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=2528696740, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_12, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> ():
    alloc_locals
    initialize_address(self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local _1 : Uint256 = Uint256(low=128, high=0)
    local _2 : Uint256 = Uint256(low=64, high=0)
    with memory_dict, msize, range_check_ptr:
        mstore_(offset=_2.low, value=_1)
    end

    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3 : Uint256 = Uint256(low=4, high=0)
    let (local _4 : Uint256) = __warp_constant_0()
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_0(_2, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

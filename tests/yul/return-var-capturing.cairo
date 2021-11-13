%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_sub

@storage_var
func this_address() -> (res : felt):
end

@storage_var
func address_initialized() -> (res : felt):
end

func initialize_address{range_check_ptr, syscall_ptr : felt*, pedersen_ptr : HashBuiltin*}(
        self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end

func __warp_cond_revert(_3_5 : Uint256) -> ():
    alloc_locals
    if _3_5.low + _3_5.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_3 : Uint256 = Uint256(low=64, high=0)
    let (local _2_4 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_5 : Uint256) = slt(_2_4, _1_3)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_5)
    let (local value0 : Uint256) = calldataload(headStart)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_6 : Uint256 = Uint256(low=32, high=0)
    let (local _5_7 : Uint256) = u256_add(headStart, _4_6)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldataload(_5_7)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_19 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_20 : Uint256) = is_gt(x, _1_19)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_20)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_block_2{range_check_ptr}(var_b : Uint256) -> (__warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local _2_22 : Uint256 = Uint256(low=42, high=0)
    let (local var : Uint256) = checked_add_uint256(var_b, _2_22)
    local range_check_ptr = range_check_ptr
    local __warp_leave_2 : Uint256 = Uint256(low=1, high=0)
    return (__warp_leave_2, var)
end

func __warp_block_3{range_check_ptr}(var_a : Uint256) -> (__warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local _3_23 : Uint256 = Uint256(low=21, high=0)
    let (local var : Uint256) = checked_add_uint256(var_a, _3_23)
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

func __warp_block_0{range_check_ptr}(_1_21 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_2 : Uint256, var : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_21
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
    let (local _1_21 : Uint256) = is_gt(var_a, var_b)
    local range_check_ptr = range_check_ptr
    let (local __warp_leave_2 : Uint256, local var : Uint256) = __warp_block_0(_1_21, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_2.low + __warp_leave_2.high != 0:
        return (var)
    else:
        return (var)
    end
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, value0_9 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_10 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_8, _1_10)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_9, headStart_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _13 : Uint256 = _4
    local _14 : Uint256 = _3
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_rando(param, param_1)
    local range_check_ptr = range_check_ptr
    local _15 : Uint256 = _2
    let (local memPos : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = uint256_sub(_16, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _17)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_5(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldataload(_7)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=2528696740, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_12, _2, _3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
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
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> (
        success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    initialize_address{
        range_check_ptr=range_check_ptr, syscall_ptr=syscall_ptr, pedersen_ptr=pedersen_ptr}(
        self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        local _1 : Uint256 = Uint256(low=128, high=0)
        local _2 : Uint256 = Uint256(low=64, high=0)
        uint256_mstore(offset=_2, value=_1)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3 : Uint256 = Uint256(low=4, high=0)
        let (local _4 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (local _5 : Uint256) = is_lt(_4, _3)
        local range_check_ptr = range_check_ptr
        let (local _6 : Uint256) = is_zero(_5)
        local range_check_ptr = range_check_ptr
        __warp_if_0(_2, _3, _4, _6)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end


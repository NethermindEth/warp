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

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1)
end

func checked_sub_uint256{range_check_ptr}(x_2 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(x_2, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local diff : Uint256) = u256_add(
        x_2,
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    return (diff)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_gt(x, __warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_loop_body_0{range_check_ptr}(
        __warp_leave_0 : Uint256, var : Uint256, var_j : Uint256, var_k : Uint256,
        var_k_1 : Uint256) -> (__warp_leave_0 : Uint256, var : Uint256, var_k_1 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_gt(var_k_1, var_j)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
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

func __warp_block_0{range_check_ptr}(var : Uint256, var_i : Uint256, var_j : Uint256) -> (
        var : Uint256, var_k_1 : Uint256):
    alloc_locals
    let (local __warp_leave_0 : Uint256, local var : Uint256,
        local var_k_1 : Uint256) = __warp_loop_0(
        Uint256(low=0, high=0), var, var_i, var_j, Uint256(low=0, high=0), Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    return (var, var_k_1)
end

func fun_transferFrom{range_check_ptr}(var_i : Uint256, var_j : Uint256) -> (var : Uint256):
    alloc_locals
    local var : Uint256 = Uint256(low=0, high=0)
    let (local var : Uint256, local var_k_1 : Uint256) = __warp_block_0(var, var_i, var_j)
    local range_check_ptr = range_check_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos, value=__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_1 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (local tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_1, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256(
        __warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_transferFrom(param, param_1)
    local range_check_ptr = range_check_ptr
    let (local memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_2()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (local __warp_subexpr_2 : Uint256) = calldataload(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local __warp_subexpr_1 : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_2)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_eq(Uint256(low=105102910, high=0), __warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    __warp_if_1(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_1()
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
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*) -> (
        success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        let (local __warp_subexpr_2 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (local __warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        local range_check_ptr = range_check_ptr
        let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        local range_check_ptr = range_check_ptr
        __warp_if_0(__warp_subexpr_0)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

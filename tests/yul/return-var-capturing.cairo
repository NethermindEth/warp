%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@constructor
func constructor{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    let termination_token = 0
    let (returndata_ptr : felt*) = alloc()
    let (__fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with memory_dict, msize, exec_env, termination_token:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
        if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
            assert 0 = 1
            jmp rel 0
        else:
            return ()
        end
    end
end

func __warp_block_2{range_check_ptr}(var_b : Uint256) -> (__warp_leave_1 : Uint256, var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        var_b,
        Uint256(low=340282366920938463463374607431768211413, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var : Uint256) = u256_add(var_b, Uint256(low=42, high=0))
    let __warp_leave_1 : Uint256 = Uint256(low=1, high=0)
    return (__warp_leave_1, var)
end

func __warp_block_3{range_check_ptr}(var_a : Uint256) -> (__warp_leave_1 : Uint256, var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        var_a,
        Uint256(low=340282366920938463463374607431768211434, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var : Uint256) = u256_add(var_a, Uint256(low=21, high=0))
    let __warp_leave_1 : Uint256 = Uint256(low=1, high=0)
    return (__warp_leave_1, var)
end

func __warp_if_2{range_check_ptr}(
        __warp_leave_5 : Uint256, __warp_subexpr_0 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_1 : Uint256, __warp_leave_5 : Uint256, var : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (__warp_leave_1 : Uint256, var : Uint256) = __warp_block_2(var_b)
        if __warp_leave_1.low + __warp_leave_1.high != 0:
            let __warp_leave_5 : Uint256 = Uint256(low=1, high=0)
            return (__warp_leave_1, __warp_leave_5, var)
        else:
            return (__warp_leave_1, __warp_leave_5, var)
        end
    else:
        let (__warp_leave_1 : Uint256, var : Uint256) = __warp_block_3(var_a)
        if __warp_leave_1.low + __warp_leave_1.high != 0:
            let __warp_leave_5 : Uint256 = Uint256(low=1, high=0)
            return (__warp_leave_1, __warp_leave_5, var)
        else:
            return (__warp_leave_1, __warp_leave_5, var)
        end
    end
end

func __warp_block_1{range_check_ptr}(match_var : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_1 : Uint256, var : Uint256):
    alloc_locals
    let __warp_leave_5 : Uint256 = Uint256(low=0, high=0)
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (__warp_leave_1 : Uint256, __warp_leave_5 : Uint256, var : Uint256) = __warp_if_2(
        __warp_leave_5, __warp_subexpr_0, var_a, var_b)
    if __warp_leave_5.low + __warp_leave_5.high != 0:
        return (__warp_leave_1, var)
    else:
        return (__warp_leave_1, var)
    end
end

func __warp_block_0{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_1 : Uint256, var : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_gt(var_a, var_b)
    let (__warp_leave_1 : Uint256, var : Uint256) = __warp_block_1(match_var, var_a, var_b)
    if __warp_leave_1.low + __warp_leave_1.high != 0:
        return (__warp_leave_1, var)
    else:
        return (__warp_leave_1, var)
    end
end

func fun_rando{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_leave_1 : Uint256, var : Uint256) = __warp_block_0(var_a, var_b)
    if __warp_leave_1.low + __warp_leave_1.high != 0:
        return (var)
    else:
        return (var)
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_4 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (__warp_subexpr_3 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (ret__warp_mangled : Uint256) = fun_rando(__warp_subexpr_3, __warp_subexpr_4)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=memPos, value=ret__warp_mangled)
    warp_return(memPos, Uint256(low=32, high=0))
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (__warp_subexpr_1 : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_eq(Uint256(low=2528696740, high=0), __warp_subexpr_1)
    __warp_if_1(__warp_subexpr_0)
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4()
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*) -> (
        returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let termination_token = 0
    let (__fp__, _) = get_fp_and_pc()
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict, termination_token:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        __warp_if_0(__warp_subexpr_0)
        if termination_token == 1:
            default_dict_finalize(memory_dict_start, memory_dict, 0)
            return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
        end
        assert 0 = 1
        jmp rel 0
    end
end

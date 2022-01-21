%lang starknet

from evm.array import validate_array
from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_sub

func __warp_identity_Uint256(arg0 : Uint256) -> (arg0 : Uint256):
    return (arg0)
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@constructor
func constructor{range_check_ptr}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    validate_array(calldata_size, calldata_len, calldata)
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with memory_dict, msize:
        __constructor_meat()
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

@external
func __main{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        calldata_size, calldata_len, calldata : felt*) -> (
        returndata_size, returndata_len, returndata : felt*):
    alloc_locals
    validate_array(calldata_size, calldata_len, calldata)
    let (__fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=cast(0, felt*), to_returndata_size=0, to_returndata_len=0, to_returndata=cast(0, felt*))
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    let termination_token = 0
    with exec_env, memory_dict, msize, termination_token:
        __main_meat()
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

func __constructor_meat{memory_dict : DictAccess*, msize, range_check_ptr}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_identity_Uint256(Uint256(low=128, high=0))
    uint256_mstore(offset=Uint256(low=64, high=0), value=__warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = __warp_constant_0()
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_loop_body_0{range_check_ptr}(
        _1 : Uint256, _2 : Uint256, __warp_break_0 : Uint256, var_ret : Uint256,
        var_ret_1 : Uint256) -> (__warp_break_0 : Uint256, var_ret : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        var_ret,
        Uint256(low=340282366920938463463374607431768211454, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(var_ret, var_ret_1)
    let var_ret_2 : Uint256 = sum
    let var_ret : Uint256 = sum
    let (__warp_subexpr_2 : Uint256) = is_lt(var_ret_2, Uint256(low=10, high=0))
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        let __warp_break_0 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_0, var_ret)
    else:
        return (__warp_break_0, var_ret)
    end
end

func __warp_loop_0{range_check_ptr}(
        _1 : Uint256, _2 : Uint256, var_ret : Uint256, var_ret_1 : Uint256) -> (var_ret : Uint256):
    alloc_locals
    let __warp_break_0 : Uint256 = Uint256(low=0, high=0)
    let (__warp_subexpr_0 : Uint256) = is_zero(var_ret_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_ret)
    end
    let (__warp_break_0 : Uint256, var_ret : Uint256) = __warp_loop_body_0(
        _1, _2, __warp_break_0, var_ret, var_ret_1)
    if __warp_break_0.low + __warp_break_0.high != 0:
        return (var_ret)
    end
    let (var_ret : Uint256) = __warp_loop_0(_1, _2, var_ret, var_ret_1)
    return (var_ret)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=headStart, value=value0)
    return (tail)
end

func __warp_block_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var_ret : Uint256 = Uint256(low=1, high=0)
    let (var_ret : Uint256) = __warp_loop_0(
        Uint256(low=4, high=0), Uint256(low=0, high=0), var_ret, Uint256(low=1, high=0))
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_4 : Uint256) = abi_encode_uint256(memPos, var_ret)
    let (__warp_subexpr_3 : Uint256) = uint256_sub(__warp_subexpr_4, memPos)
    warp_return(memPos, __warp_subexpr_3)
    return ()
end

func __warp_if_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_1()
        return ()
    else:
        return ()
    end
end

func __warp_block_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (__warp_subexpr_1 : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_eq(Uint256(low=638722032, high=0), __warp_subexpr_1)
    __warp_if_0(__warp_subexpr_0)
    return ()
end

func __warp_if_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(__warp_subexpr_1 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        __warp_block_0()
        return ()
    else:
        return ()
    end
end

func __main_meat{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_identity_Uint256(Uint256(low=128, high=0))
    uint256_mstore(offset=Uint256(low=64, high=0), value=__warp_subexpr_0)
    let (__warp_subexpr_3 : Uint256) = calldatasize()
    let (__warp_subexpr_2 : Uint256) = is_lt(__warp_subexpr_3, Uint256(low=4, high=0))
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    __warp_if_1(__warp_subexpr_1)
    if termination_token == 1:
        return ()
    end
    assert 0 = 1
    jmp rel 0
end

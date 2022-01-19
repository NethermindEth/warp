%lang starknet

from evm.array import validate_array
from evm.calls import calldatacopy, calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore, uint256_mstore8
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_or, uint256_sub

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
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_loop_body_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        i : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = u256_add(i, Uint256(low=160, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_mload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = u256_add(i, Uint256(low=256, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    return ()
end

func __warp_loop_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, i : Uint256, length : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    __warp_loop_body_0(i)
    let (i : Uint256) = u256_add(i, _1)
    let (i : Uint256) = __warp_loop_0(_1, i, length)
    return (i)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(length : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = u256_add(length, Uint256(low=256, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low=0, high=0))
    return ()
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, length : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0(length)
        return ()
    else:
        return ()
    end
end

func abi_encode_string_1184{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        tail : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=192, high=0), value=Uint256(low=32, high=0))
    let (length : Uint256) = uint256_mload(Uint256(low=128, high=0))
    uint256_mstore(offset=Uint256(low=224, high=0), value=length)
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256) = __warp_loop_0(Uint256(low=32, high=0), i, length)
    let (__warp_subexpr_0 : Uint256) = is_gt(i, length)
    __warp_if_0(__warp_subexpr_0, length)
    let (__warp_subexpr_2 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_and(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (tail : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=256, high=0))
    return (tail)
end

func memory_array_index_access_bytes{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256) -> (addr : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(baseRef)
    let (__warp_subexpr_1 : Uint256) = is_lt(Uint256(low=2, high=0), __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (addr : Uint256) = u256_add(baseRef, Uint256(low=34, high=0))
    return (addr)
end

func fun_bytesFun{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}() -> (var_mpos : Uint256):
    alloc_locals
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (newFreePtr : Uint256) = u256_add(memPtr, Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_1 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_or(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    uint256_mstore(offset=memPtr, value=Uint256(low=3, high=0))
    let (dataStart : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    let (__warp_subexpr_3 : Uint256) = calldatasize()
    calldatacopy(dataStart, __warp_subexpr_3, Uint256(low=32, high=0))
    let (__warp_subexpr_5 : Uint256) = uint256_mload(memPtr)
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore8(dataStart, Uint256(low=65, high=0))
    let (__warp_subexpr_8 : Uint256) = uint256_mload(memPtr)
    let (__warp_subexpr_7 : Uint256) = is_lt(Uint256(low=1, high=0), __warp_subexpr_8)
    let (__warp_subexpr_6 : Uint256) = is_zero(__warp_subexpr_7)
    if __warp_subexpr_6.low + __warp_subexpr_6.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_9 : Uint256) = u256_add(memPtr, Uint256(low=33, high=0))
    uint256_mstore8(__warp_subexpr_9, Uint256(low=66, high=0))
    let (__warp_subexpr_10 : Uint256) = memory_array_index_access_bytes(memPtr)
    uint256_mstore8(__warp_subexpr_10, Uint256(low=67, high=0))
    let var_mpos : Uint256 = memPtr
    return (var_mpos)
end

func __warp_loop_body_1{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, headStart : Uint256, i : Uint256, value0 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_4 : Uint256) = u256_add(value0, i)
    let (__warp_subexpr_3 : Uint256) = u256_add(__warp_subexpr_4, _1)
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, i)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(__warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_2, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    return ()
end

func __warp_loop_1{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, headStart : Uint256, i : Uint256, length : Uint256, value0 : Uint256) -> (
        i : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    __warp_loop_body_1(_1, headStart, i, value0)
    let (i : Uint256) = u256_add(i, _1)
    let (i : Uint256) = __warp_loop_1(_1, headStart, i, length, value0)
    return (i)
end

func __warp_block_1{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, length : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(headStart, length)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low=0, high=0))
    return ()
end

func __warp_if_1{memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_1 : Uint256, headStart : Uint256, length : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        __warp_block_1(headStart, length)
        return ()
    else:
        return ()
    end
end

func abi_encode_string{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=32, high=0))
    let (length : Uint256) = uint256_mload(value0)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=length)
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256) = __warp_loop_1(Uint256(low=32, high=0), headStart, i, length, value0)
    let (__warp_subexpr_1 : Uint256) = is_gt(i, length)
    __warp_if_1(__warp_subexpr_1, headStart, length)
    let (__warp_subexpr_4 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_and(
        __warp_subexpr_4,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, __warp_subexpr_3)
    let (tail : Uint256) = u256_add(__warp_subexpr_2, Uint256(low=64, high=0))
    return (tail)
end

func __warp_block_5{
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
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=192, high=0))
    uint256_mstore(offset=Uint256(low=128, high=0), value=Uint256(low=3, high=0))
    uint256_mstore(
        offset=Uint256(low=160, high=0),
        value=Uint256(low=0, high=86743870240126275024148876141787086848))
    let (__warp_subexpr_4 : Uint256) = abi_encode_string_1184()
    let (__warp_subexpr_3 : Uint256) = u256_add(
        __warp_subexpr_4,
        Uint256(low=340282366920938463463374607431768211264, high=340282366920938463463374607431768211455))
    warp_return(Uint256(low=192, high=0), __warp_subexpr_3)
    return ()
end

func __warp_block_7{
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
    let (ret__warp_mangled : Uint256) = fun_bytesFun()
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_4 : Uint256) = abi_encode_string(memPos, ret__warp_mangled)
    let (__warp_subexpr_3 : Uint256) = uint256_sub(__warp_subexpr_4, memPos)
    warp_return(memPos, __warp_subexpr_3)
    return ()
end

func __warp_if_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7()
        return ()
    else:
        return ()
    end
end

func __warp_block_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2619690814, high=0))
    __warp_if_2(__warp_subexpr_0)
    return ()
end

func __warp_if_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
        return ()
    else:
        __warp_block_6(match_var)
        return ()
    end
end

func __warp_block_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2606647602, high=0))
    __warp_if_3(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_4(match_var)
    return ()
end

func __warp_block_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    __warp_block_3()
    return ()
end

func __warp_if_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_2()
        return ()
    else:
        return ()
    end
end

func __main_meat{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    __warp_if_4(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    assert 0 = 1
    jmp rel 0
end

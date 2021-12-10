%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldatacopy, calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore, uint256_mstore8
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_sub

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

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func array_allocation_size_string{range_check_ptr}(length : Uint256) -> (size : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(length, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_2 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_and(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (size : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    return (size)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(size, Uint256(low=31, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_and(
        __warp_subexpr_1,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (newFreePtr : Uint256) = u256_add(memPtr, __warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_3 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, __warp_subexpr_4)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr : Uint256):
    alloc_locals
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr, size)
    return (memPtr)
end

func allocate_memory_array_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        length : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = array_allocation_size_string(length)
    let (memPtr : Uint256) = allocate_memory(__warp_subexpr_0)
    uint256_mstore(offset=memPtr, value=length)
    return (memPtr)
end

func store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}(memPtr : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=memPtr, value=Uint256(low='', high='ABC' * 256 ** 13))
    return ()
end

func copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}() -> (memPtr : Uint256):
    alloc_locals
    let (memPtr : Uint256) = allocate_memory_array_string(Uint256(low=3, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(
        __warp_subexpr_0)
    return (memPtr)
end

func array_storeLengthForEncoding_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos : Uint256, length : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    uint256_mstore(offset=pos, value=length)
    let (updated_pos : Uint256) = u256_add(pos, Uint256(low=32, high=0))
    return (updated_pos)
end

func __warp_loop_body_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = u256_add(src, i)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = u256_add(dst, i)
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    let (i : Uint256) = u256_add(i, Uint256(low=32, high=0))
    return (i)
end

func __warp_loop_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, length : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    let (i : Uint256) = __warp_loop_body_0(dst, i, src)
    let (i : Uint256) = __warp_loop_0(dst, i, length, src)
    return (i)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, length : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = u256_add(dst, length)
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low=0, high=0))
    return ()
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, dst : Uint256, length : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0(dst, length)
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length : Uint256) -> ():
    alloc_locals
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256) = __warp_loop_0(dst, i, length, src)
    let (__warp_subexpr_0 : Uint256) = is_gt(i, length)
    __warp_if_0(__warp_subexpr_0, dst, length)
    return ()
end

func abi_encode_string_memory_ptr{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (length : Uint256) = uint256_mload(value)
    let (pos_1 : Uint256) = array_storeLengthForEncoding_string(pos, length)
    let (__warp_subexpr_0 : Uint256) = u256_add(value, Uint256(low=32, high=0))
    copy_memory_to_memory(__warp_subexpr_0, pos_1, length)
    let (__warp_subexpr_2 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_and(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (end__warp_mangled : Uint256) = u256_add(pos_1, __warp_subexpr_1)
    return (end__warp_mangled)
end

func abi_encode_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (tail : Uint256) = abi_encode_string_memory_ptr(value0, __warp_subexpr_0)
    return (tail)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    calldatacopy(dataStart, __warp_subexpr_0, dataSizeInBytes)
    return ()
end

func allocate_and_zero_memory_array_string{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        length : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (memPtr : Uint256) = allocate_memory_array_string(length)
    let (__warp_subexpr_2 : Uint256) = array_allocation_size_string(length)
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    zero_memory_chunk_bytes1(__warp_subexpr_0, __warp_subexpr_1)
    return (memPtr)
end

func memory_array_index_access_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index : Uint256) -> (addr : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(baseRef)
    let (__warp_subexpr_1 : Uint256) = is_lt(index, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(baseRef, index)
    let (addr : Uint256) = u256_add(__warp_subexpr_3, Uint256(low=32, high=0))
    return (addr)
end

func fun_bytesFun{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_mpos : Uint256):
    alloc_locals
    let (expr_mpos : Uint256) = allocate_and_zero_memory_array_string(Uint256(low=3, high=0))
    let (__warp_subexpr_0 : Uint256) = memory_array_index_access_bytes(
        expr_mpos, Uint256(low=0, high=0))
    uint256_mstore8(__warp_subexpr_0, Uint256(low=65, high=0))
    let (__warp_subexpr_1 : Uint256) = memory_array_index_access_bytes(
        expr_mpos, Uint256(low=1, high=0))
    uint256_mstore8(__warp_subexpr_1, Uint256(low=66, high=0))
    let (__warp_subexpr_2 : Uint256) = memory_array_index_access_bytes(
        expr_mpos, Uint256(low=2, high=0))
    uint256_mstore8(__warp_subexpr_2, Uint256(low=67, high=0))
    let var_mpos : Uint256 = expr_mpos
    return (var_mpos)
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(Uint256(low=4, high=0), __warp_subexpr_0)
    let (
        ret__warp_mangled : Uint256) = copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(
        )
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_string(memPos, ret__warp_mangled)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos)
    warp_return(memPos, __warp_subexpr_1)
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(Uint256(low=4, high=0), __warp_subexpr_0)
    let (ret_1 : Uint256) = fun_bytesFun()
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_string(memPos_1, ret_1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    warp_return(memPos_1, __warp_subexpr_1)
    return ()
end

func __warp_if_3{
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
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2619690814, high=0))
    __warp_if_3(__warp_subexpr_0)
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        return ()
    else:
        __warp_block_4(match_var)
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2606647602, high=0))
    __warp_if_2(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_2(match_var)
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_1()
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
        __warp_if_1(__warp_subexpr_0)
        if termination_token == 1:
            default_dict_finalize(memory_dict_start, memory_dict, 0)
            return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
        end
        assert 0 = 1
        jmp rel 0
    end
end

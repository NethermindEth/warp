%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldatacopy, calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore, uint256_mstore8
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_sub

func abi_decode{range_check_ptr}(dataEnd : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(memPtr : Uint256) -> ():
    alloc_locals
    let (newFreePtr : Uint256) = u256_add(memPtr, Uint256(low=64, high=0))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}() -> (memPtr_4 : Uint256):
    alloc_locals
    let (memPtr_4 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_4)
end

func allocate_memory_array_string{memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_5 : Uint256):
    alloc_locals
    let (memPtr_5 : Uint256) = allocate_memory()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=memPtr_5, value=Uint256(low=3, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_5)
end

func store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}(memPtr_7 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=memPtr_7, value=Uint256(low='', high='ABC' * 256 ** 13))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}() -> (memPtr_8 : Uint256):
    alloc_locals
    let (memPtr_8 : Uint256) = allocate_memory_array_string()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr_8, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(
        __warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_8)
end

func array_storeLengthForEncoding_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos : Uint256, length : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    uint256_mstore(offset=pos, value=length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (updated_pos : Uint256) = u256_add(pos, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func __warp_loop_body_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = u256_add(src, i)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_mload(__warp_subexpr_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = u256_add(dst, i)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (i : Uint256) = u256_add(i, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_loop_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, length_1 : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length_1)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    let (i : Uint256) = __warp_loop_body_0(dst, i, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (i : Uint256) = __warp_loop_0(dst, i, length_1, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, length_1 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = u256_add(dst, length_1)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low=0, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, dst : Uint256, length_1 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0(dst, length_1)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length_1 : Uint256) -> ():
    alloc_locals
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256) = __warp_loop_0(dst, i, length_1, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_gt(i, length_1)
    local range_check_ptr = range_check_ptr
    __warp_if_0(__warp_subexpr_0, dst, length_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_string_memory_ptr{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos_2 : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (length_3 : Uint256) = uint256_mload(value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (pos_1 : Uint256) = array_storeLengthForEncoding_string(pos_2, length_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = u256_add(value, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(__warp_subexpr_0, pos_1, length_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = u256_add(length_3, Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_and(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (end__warp_mangled : Uint256) = u256_add(pos_1, __warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    return (end__warp_mangled)
end

func abi_encode_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=32, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    let (tail : Uint256) = abi_encode_string_memory_ptr(value0, __warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func allocate_memory_array_string_558{memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_6 : Uint256):
    alloc_locals
    let (memPtr_6 : Uint256) = allocate_memory()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=memPtr_6, value=Uint256(low=3, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_6)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    calldatacopy(dataStart, __warp_subexpr_0, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_string{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_9 : Uint256):
    alloc_locals
    let (memPtr_9 : Uint256) = allocate_memory_array_string_558()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr_9, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_9)
end

func memory_array_index_access_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256) -> (addr : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_mload(baseRef)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (addr : Uint256) = u256_add(baseRef, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    return (addr)
end

func memory_array_index_access_bytes_296{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef_10 : Uint256) -> (addr_11 : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(baseRef_10)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = is_lt(Uint256(low=1, high=0), __warp_subexpr_2)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (addr_11 : Uint256) = u256_add(baseRef_10, Uint256(low=33, high=0))
    local range_check_ptr = range_check_ptr
    return (addr_11)
end

func memory_array_index_access_bytes_297{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef_12 : Uint256) -> (addr_13 : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(baseRef_12)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = is_lt(Uint256(low=2, high=0), __warp_subexpr_2)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (addr_13 : Uint256) = u256_add(baseRef_12, Uint256(low=34, high=0))
    local range_check_ptr = range_check_ptr
    return (addr_13)
end

func fun_bytesFun{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_mpos : Uint256):
    alloc_locals
    let (expr_mpos : Uint256) = allocate_and_zero_memory_array_string()
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = memory_array_index_access_bytes(expr_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(__warp_subexpr_0, Uint256(low=65, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = memory_array_index_access_bytes_296(expr_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(__warp_subexpr_1, Uint256(low=66, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = memory_array_index_access_bytes_297(expr_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(__warp_subexpr_2, Uint256(low=67, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let var_mpos : Uint256 = expr_mpos
    return (var_mpos)
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    abi_decode(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (
        ret__warp_mangled : Uint256) = copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(
        )
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = abi_encode_string(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    abi_decode(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (ret_1 : Uint256) = fun_bytesFun()
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = abi_encode_string(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
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
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2619690814, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_4(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2606647602, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    __warp_block_2(match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_1{
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
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        local range_check_ptr = range_check_ptr
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        local range_check_ptr = range_check_ptr
        __warp_if_1(__warp_subexpr_0)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

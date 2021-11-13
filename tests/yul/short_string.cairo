%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldatacopy, calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore, uint256_mstore8
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_not, uint256_sub

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

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

func __warp_cond_revert(_3_3 : Uint256) -> ():
    alloc_locals
    if _3_3.low + _3_3.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=0, high=0)
    let (local _2_2 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, _1_1)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    return ()
end

func array_allocation_size_string{range_check_ptr}(length_25 : Uint256) -> (size_26 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_27 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_28 : Uint256) = is_gt(length_25, _1_27)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_28)
    local _3_29 : Uint256 = Uint256(low=32, high=0)
    let (local _4_30 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_31 : Uint256 = Uint256(low=31, high=0)
    let (local _6_32 : Uint256) = u256_add(length_25, _5_31)
    local range_check_ptr = range_check_ptr
    let (local _7_33 : Uint256) = uint256_and(_6_32, _4_30)
    local range_check_ptr = range_check_ptr
    let (local size_26 : Uint256) = u256_add(_7_33, _3_29)
    local range_check_ptr = range_check_ptr
    return (size_26)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_49 : Uint256, size_50 : Uint256) -> ():
    alloc_locals
    let (local _1_51 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_52 : Uint256 = Uint256(low=31, high=0)
    let (local _3_53 : Uint256) = u256_add(size_50, _2_52)
    local range_check_ptr = range_check_ptr
    let (local _4_54 : Uint256) = uint256_and(_3_53, _1_51)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr_49, _4_54)
    local range_check_ptr = range_check_ptr
    let (local _5_55 : Uint256) = is_lt(newFreePtr, memPtr_49)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_56 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_57 : Uint256) = is_gt(newFreePtr, _6_56)
    local range_check_ptr = range_check_ptr
    let (local _8_58 : Uint256) = uint256_sub(_7_57, _5_55)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_58)
    local _9_59 : Uint256 = Uint256(low=64, high=0)
    uint256_mstore(offset=_9_59, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr_20 : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_20 : Uint256) = uint256_mload(_1_21)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_20, size)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_20)
end

func allocate_memory_array_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_22 : Uint256) -> (memPtr_23 : Uint256):
    alloc_locals
    let (local _1_24 : Uint256) = array_allocation_size_string(length_22)
    local range_check_ptr = range_check_ptr
    let (local memPtr_23 : Uint256) = allocate_memory(_1_24)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=memPtr_23, value=length_22)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_23)
end

func store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}(memPtr_93 : Uint256) -> ():
    alloc_locals
    local _1_94 : Uint256 = Uint256(low='', high='ABC' * 256 ** 13)
    uint256_mstore(offset=memPtr_93, value=_1_94)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}() -> (memPtr_37 : Uint256):
    alloc_locals
    local _1_38 : Uint256 = Uint256(low=3, high=0)
    let (local memPtr_37 : Uint256) = allocate_memory_array_string(_1_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_39 : Uint256 = Uint256(low=32, high=0)
    let (local _3_40 : Uint256) = u256_add(memPtr_37, _2_39)
    local range_check_ptr = range_check_ptr
    store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(_3_40)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_37)
end

func array_storeLengthForEncoding_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_34 : Uint256, length_35 : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    uint256_mstore(offset=pos_34, value=length_35)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_36 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos_34, _1_36)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func __warp_loop_body_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (local _2_43 : Uint256) = u256_add(src, i)
    local range_check_ptr = range_check_ptr
    let (local _3_44 : Uint256) = uint256_mload(_2_43)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _4_45 : Uint256) = u256_add(dst, i)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_4_45, value=_3_44)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_42 : Uint256 = Uint256(low=32, high=0)
    let (local i : Uint256) = u256_add(i, _1_42)
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_loop_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, length_41 : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i, length_41)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    let (local i : Uint256) = __warp_loop_body_0(dst, i, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i : Uint256) = __warp_loop_0(dst, i, length_41, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, length_41 : Uint256) -> ():
    alloc_locals
    local _6_47 : Uint256 = Uint256(low=0, high=0)
    let (local _7_48 : Uint256) = u256_add(dst, length_41)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_7_48, value=_6_47)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_46 : Uint256, dst : Uint256, length_41 : Uint256) -> ():
    alloc_locals
    if _5_46.low + _5_46.high != 0:
        __warp_block_0(dst, length_41)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length_41 : Uint256) -> ():
    alloc_locals
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256) = __warp_loop_0(dst, i, length_41, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_46 : Uint256) = is_gt(i, length_41)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_5_46, dst, length_41)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_string_memory_ptr{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (local length : Uint256) = uint256_mload(value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_1 : Uint256) = array_storeLengthForEncoding_string(pos, length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_4 : Uint256 = Uint256(low=32, high=0)
    let (local _2_5 : Uint256) = u256_add(value, _1_4)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_5, pos_1, length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_6 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _4_7 : Uint256 = Uint256(low=31, high=0)
    let (local _5_8 : Uint256) = u256_add(length, _4_7)
    local range_check_ptr = range_check_ptr
    let (local _6_9 : Uint256) = uint256_and(_5_8, _3_6)
    local range_check_ptr = range_check_ptr
    let (local end__warp_mangled : Uint256) = u256_add(pos_1, _6_9)
    local range_check_ptr = range_check_ptr
    return (end__warp_mangled)
end

func abi_encode_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_10 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_11 : Uint256 = Uint256(low=32, high=0)
    uint256_mstore(offset=headStart_10, value=_1_11)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_12 : Uint256 = _1_11
    let (local _3_13 : Uint256) = u256_add(headStart_10, _1_11)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = abi_encode_string_memory_ptr(value0, _3_13)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    let (local _1_95 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    calldatacopy(dataStart, _1_95, dataSizeInBytes)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_string{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_14 : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (local memPtr : Uint256) = allocate_memory_array_string(length_14)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_15 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_16 : Uint256) = array_allocation_size_string(length_14)
    local range_check_ptr = range_check_ptr
    let (local _3_17 : Uint256) = u256_add(_2_16, _1_15)
    local range_check_ptr = range_check_ptr
    local _4_18 : Uint256 = Uint256(low=32, high=0)
    let (local _5_19 : Uint256) = u256_add(memPtr, _4_18)
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(_5_19, _3_17)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func memory_array_index_access_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index : Uint256) -> (addr : Uint256):
    alloc_locals
    let (local _1_70 : Uint256) = uint256_mload(baseRef)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_71 : Uint256) = is_lt(index, _1_70)
    local range_check_ptr = range_check_ptr
    let (local _3_72 : Uint256) = is_zero(_2_71)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_72)
    local _4_73 : Uint256 = Uint256(low=32, high=0)
    let (local _5_74 : Uint256) = u256_add(baseRef, index)
    local range_check_ptr = range_check_ptr
    let (local addr : Uint256) = u256_add(_5_74, _4_73)
    local range_check_ptr = range_check_ptr
    return (addr)
end

func fun_bytesFun{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_mpos : Uint256):
    alloc_locals
    local _1_60 : Uint256 = Uint256(low=3, high=0)
    let (local expr_mpos : Uint256) = allocate_and_zero_memory_array_string(_1_60)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_61 : Uint256 = Uint256(low=65, high=0)
    local _3_62 : Uint256 = Uint256(low=0, high=0)
    let (local _4_63 : Uint256) = memory_array_index_access_bytes(expr_mpos, _3_62)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_4_63, _2_61)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_64 : Uint256 = Uint256(low=66, high=0)
    local _6_65 : Uint256 = Uint256(low=1, high=0)
    let (local _7_66 : Uint256) = memory_array_index_access_bytes(expr_mpos, _6_65)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_7_66, _5_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_67 : Uint256 = Uint256(low=67, high=0)
    local _9_68 : Uint256 = Uint256(low=2, high=0)
    let (local _10_69 : Uint256) = memory_array_index_access_bytes(expr_mpos, _9_68)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_10_69, _8_67)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_mpos : Uint256 = expr_mpos
    return (var_mpos)
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    local _13 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (
        local ret__warp_mangled : Uint256) = copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(
        )
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14 : Uint256 = _2
    let (local memPos : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15 : Uint256) = abi_encode_string(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_sub(_15, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _16)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _17 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_17)
    local _18 : Uint256 = _4
    local _19 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_bytesFun()
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _20 : Uint256 = _2
    let (local memPos_1 : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_string(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _22)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2619690814, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_2, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_5(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2606647602, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_3(_2, _3, _4, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_1{
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
    __warp_block_2(_10, _2, _3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_1(_2, _3, _4)
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
        __warp_if_1(_2, _3, _4, _6)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

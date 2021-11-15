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

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=0, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    if _3_7.low + _3_7.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func array_allocation_size_string{range_check_ptr}(length_49 : Uint256) -> (size_50 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_51 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_52 : Uint256) = is_gt(length_49, _1_51)
    local range_check_ptr = range_check_ptr
    if _2_52.low + _2_52.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _3_53 : Uint256 = Uint256(low=32, high=0)
    let (local _4_54 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_55 : Uint256 = Uint256(low=31, high=0)
    let (local _6_56 : Uint256) = u256_add(length_49, _5_55)
    local range_check_ptr = range_check_ptr
    let (local _7_57 : Uint256) = uint256_and(_6_56, _4_54)
    local range_check_ptr = range_check_ptr
    let (local size_50 : Uint256) = u256_add(_7_57, _3_53)
    local range_check_ptr = range_check_ptr
    return (size_50)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_37 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_38 : Uint256 = Uint256(low=31, high=0)
    let (local _3_39 : Uint256) = u256_add(size, _2_38)
    local range_check_ptr = range_check_ptr
    let (local _4_40 : Uint256) = uint256_and(_3_39, _1_37)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_40)
    local range_check_ptr = range_check_ptr
    let (local _5_41 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_42 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_43 : Uint256) = is_gt(newFreePtr, _6_42)
    local range_check_ptr = range_check_ptr
    let (local _8_44 : Uint256) = uint256_sub(_7_43, _5_41)
    local range_check_ptr = range_check_ptr
    if _8_44.low + _8_44.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _9_45 : Uint256 = Uint256(low=64, high=0)
    uint256_mstore(offset=_9_45, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size_46 : Uint256) -> (
        memPtr_47 : Uint256):
    alloc_locals
    local _1_48 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_47 : Uint256) = uint256_mload(_1_48)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_47, size_46)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_47)
end

func allocate_memory_array_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_58 : Uint256) -> (memPtr_59 : Uint256):
    alloc_locals
    let (local _1_60 : Uint256) = array_allocation_size_string(length_58)
    local range_check_ptr = range_check_ptr
    let (local memPtr_59 : Uint256) = allocate_memory(_1_60)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=memPtr_59, value=length_58)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_59)
end

func store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}(memPtr_61 : Uint256) -> ():
    alloc_locals
    local _1_62 : Uint256 = Uint256(low='', high='ABC' * 256 ** 13)
    uint256_mstore(offset=memPtr_61, value=_1_62)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func copy_literal_to_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8{
        memory_dict : DictAccess*, msize, range_check_ptr}() -> (memPtr_63 : Uint256):
    alloc_locals
    local _1_64 : Uint256 = Uint256(low=3, high=0)
    let (local memPtr_63 : Uint256) = allocate_memory_array_string(_1_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_65 : Uint256 = Uint256(low=32, high=0)
    let (local _3_66 : Uint256) = u256_add(memPtr_63, _2_65)
    local range_check_ptr = range_check_ptr
    store_literal_in_memory_e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8(_3_66)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_63)
end

func array_storeLengthForEncoding_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos : Uint256, length : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    uint256_mstore(offset=pos, value=length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_8 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos, _1_8)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func __warp_loop_body_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (local _2_11 : Uint256) = u256_add(src, i)
    local range_check_ptr = range_check_ptr
    let (local _3_12 : Uint256) = uint256_mload(_2_11)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _4_13 : Uint256) = u256_add(dst, i)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_4_13, value=_3_12)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_10 : Uint256 = Uint256(low=32, high=0)
    let (local i : Uint256) = u256_add(i, _1_10)
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_loop_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, length_9 : Uint256, src : Uint256) -> (i : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i, length_9)
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
    let (local i : Uint256) = __warp_loop_0(dst, i, length_9, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, length_9 : Uint256) -> ():
    alloc_locals
    local _6_15 : Uint256 = Uint256(low=0, high=0)
    let (local _7_16 : Uint256) = u256_add(dst, length_9)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_7_16, value=_6_15)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_14 : Uint256, dst : Uint256, length_9 : Uint256) -> ():
    alloc_locals
    if _5_14.low + _5_14.high != 0:
        __warp_block_0(dst, length_9)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length_9 : Uint256) -> ():
    alloc_locals
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256) = __warp_loop_0(dst, i, length_9, src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_14 : Uint256) = is_gt(i, length_9)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_5_14, dst, length_9)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_string_memory_ptr{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos_17 : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (local length_18 : Uint256) = uint256_mload(value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_1 : Uint256) = array_storeLengthForEncoding_string(pos_17, length_18)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_19 : Uint256 = Uint256(low=32, high=0)
    let (local _2_20 : Uint256) = u256_add(value, _1_19)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_20, pos_1, length_18)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_21 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _4_22 : Uint256 = Uint256(low=31, high=0)
    let (local _5_23 : Uint256) = u256_add(length_18, _4_22)
    local range_check_ptr = range_check_ptr
    let (local _6_24 : Uint256) = uint256_and(_5_23, _3_21)
    local range_check_ptr = range_check_ptr
    let (local end__warp_mangled : Uint256) = u256_add(pos_1, _6_24)
    local range_check_ptr = range_check_ptr
    return (end__warp_mangled)
end

func abi_encode_string{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_25 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_26 : Uint256 = Uint256(low=32, high=0)
    uint256_mstore(offset=headStart_25, value=_1_26)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_27 : Uint256 = _1_26
    let (local _3_28 : Uint256) = u256_add(headStart_25, _1_26)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = abi_encode_string_memory_ptr(value0, _3_28)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    let (local _1_67 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    calldatacopy(dataStart, _1_67, dataSizeInBytes)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_string{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_68 : Uint256) -> (memPtr_69 : Uint256):
    alloc_locals
    let (local memPtr_69 : Uint256) = allocate_memory_array_string(length_68)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_70 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_71 : Uint256) = array_allocation_size_string(length_68)
    local range_check_ptr = range_check_ptr
    let (local _3_72 : Uint256) = u256_add(_2_71, _1_70)
    local range_check_ptr = range_check_ptr
    local _4_73 : Uint256 = Uint256(low=32, high=0)
    let (local _5_74 : Uint256) = u256_add(memPtr_69, _4_73)
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(_5_74, _3_72)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_69)
end

func memory_array_index_access_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index : Uint256) -> (addr : Uint256):
    alloc_locals
    let (local _1_81 : Uint256) = uint256_mload(baseRef)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_82 : Uint256) = is_lt(index, _1_81)
    local range_check_ptr = range_check_ptr
    let (local _3_83 : Uint256) = is_zero(_2_82)
    local range_check_ptr = range_check_ptr
    if _3_83.low + _3_83.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _4_84 : Uint256 = Uint256(low=32, high=0)
    let (local _5_85 : Uint256) = u256_add(baseRef, index)
    local range_check_ptr = range_check_ptr
    let (local addr : Uint256) = u256_add(_5_85, _4_84)
    local range_check_ptr = range_check_ptr
    return (addr)
end

func fun_bytesFun{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_mpos : Uint256):
    alloc_locals
    local _1_86 : Uint256 = Uint256(low=3, high=0)
    let (local expr_mpos : Uint256) = allocate_and_zero_memory_array_string(_1_86)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_87 : Uint256 = Uint256(low=65, high=0)
    local _3_88 : Uint256 = Uint256(low=0, high=0)
    let (local _4_89 : Uint256) = memory_array_index_access_bytes(expr_mpos, _3_88)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_4_89, _2_87)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_90 : Uint256 = Uint256(low=66, high=0)
    local _6_91 : Uint256 = Uint256(low=1, high=0)
    let (local _7_92 : Uint256) = memory_array_index_access_bytes(expr_mpos, _6_91)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_7_92, _5_90)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_93 : Uint256 = Uint256(low=67, high=0)
    local _9_94 : Uint256 = Uint256(low=2, high=0)
    let (local _10_95 : Uint256) = memory_array_index_access_bytes(expr_mpos, _9_94)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore8(_10_95, _8_93)
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
    if _11.low + _11.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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
    if _17.low + _17.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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

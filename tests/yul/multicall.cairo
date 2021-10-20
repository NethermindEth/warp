%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load, calldatacopy_
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, sgt, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

func __warp_stub() -> (res : Uint256):
    assert 1 = 0
    jmp rel 0
end

func __warp_holder() -> (res : Uint256):
    return (Uint256(0, 0))
end

@storage_var
func this_address() -> (res : felt):
end

func address{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}() -> (
        res : Uint256):
    let (addr) = this_address.read()
    return (res=Uint256(low=addr, high=0))
end

@storage_var
func address_initialized() -> (res : felt):
end

func gas() -> (res : Uint256):
    return (Uint256(100000, 100000))
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

func __warp_cond_revert(_4_4 : Uint256) -> ():
    alloc_locals
    if _4_4.low + _4_4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset : Uint256, end__warp_mangled : Uint256) -> (arrayPos : Uint256, length : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=31, high=0)
    let (local _2_2 : Uint256) = u256_add(offset, _1_1)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    let (local _4_4 : Uint256) = is_zero(_3_3)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_4)
    let (local length : Uint256) = calldata_load(offset.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_5 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_6 : Uint256) = is_gt(length, _5_5)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_6)
    local _7_7 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos : Uint256) = u256_add(offset, _7_7)
    local range_check_ptr = range_check_ptr
    local _8_8 : Uint256 = _7_7
    local _9_9 : Uint256 = Uint256(low=5, high=0)
    let (local _10_10 : Uint256) = uint256_shl(_9_9, length)
    local range_check_ptr = range_check_ptr
    let (local _11_11 : Uint256) = u256_add(offset, _10_10)
    local range_check_ptr = range_check_ptr
    let (local _12_12 : Uint256) = u256_add(_11_11, _7_7)
    local range_check_ptr = range_check_ptr
    let (local _13_13 : Uint256) = is_gt(_12_12, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_13)
    return (arrayPos, length)
end

func abi_decode_array_bytes_calldata_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_14 : Uint256 = Uint256(low=32, high=0)
    let (local _2_15 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_16 : Uint256) = slt(_2_15, _1_14)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_16)
    let (local offset_17 : Uint256) = calldata_load(headStart.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_18 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_19 : Uint256) = is_gt(offset_17, _4_18)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_19)
    let (local _6_20 : Uint256) = u256_add(headStart, offset_17)
    local range_check_ptr = range_check_ptr
    let (local value0_1 : Uint256,
        local value1_1 : Uint256) = abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr(
        _6_20, dataEnd)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local value0 : Uint256 = value0_1
    local value1 : Uint256 = value1_1
    return (value0, value1)
end

func array_allocation_size_array_bytes_dyn{range_check_ptr}(length_79 : Uint256) -> (
        size_80 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_81 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_82 : Uint256) = is_gt(length_79, _1_81)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_82)
    local _3_83 : Uint256 = Uint256(low=32, high=0)
    local _4_84 : Uint256 = Uint256(low=5, high=0)
    let (local _5_85 : Uint256) = uint256_shl(_4_84, length_79)
    local range_check_ptr = range_check_ptr
    let (local size_80 : Uint256) = u256_add(_5_85, _3_83)
    local range_check_ptr = range_check_ptr
    return (size_80)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_131 : Uint256, size_132 : Uint256) -> ():
    alloc_locals
    let (local _1_133 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_134 : Uint256 = Uint256(low=31, high=0)
    let (local _3_135 : Uint256) = u256_add(size_132, _2_134)
    local range_check_ptr = range_check_ptr
    let (local _4_136 : Uint256) = uint256_and(_3_135, _1_133)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr_131, _4_136)
    local range_check_ptr = range_check_ptr
    let (local _5_137 : Uint256) = is_lt(newFreePtr, memPtr_131)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_138 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_139 : Uint256) = is_gt(newFreePtr, _6_138)
    local range_check_ptr = range_check_ptr
    let (local _8_140 : Uint256) = uint256_sub(_7_139, _5_137)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_140)
    local _9_141 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_141.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr_71 : Uint256):
    alloc_locals
    local _1_72 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_71 : Uint256) = mload_(_1_72.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_71, size)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_71)
end

func allocate_memory_array_array_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_73 : Uint256) -> (memPtr_74 : Uint256):
    alloc_locals
    let (local _1_75 : Uint256) = array_allocation_size_array_bytes_dyn(length_73)
    local range_check_ptr = range_check_ptr
    let (local memPtr_74 : Uint256) = allocate_memory(_1_75)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_74.low, value=length_73)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_74)
end

func __warp_loop_body_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, i_206 : Uint256) -> (i_206 : Uint256):
    alloc_locals
    local _2_208 : Uint256 = Uint256(low=96, high=0)
    let (local _3_209 : Uint256) = u256_add(dataStart, i_206)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_3_209.low, value=_2_208)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_207 : Uint256 = Uint256(low=32, high=0)
    let (local i_206 : Uint256) = u256_add(i_206, _1_207)
    local range_check_ptr = range_check_ptr
    return (i_206)
end

func __warp_loop_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataSizeInBytes : Uint256, dataStart : Uint256, i_206 : Uint256) -> (i_206 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i_206, dataSizeInBytes)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i_206)
    end
    let (local i_206 : Uint256) = __warp_loop_body_3(dataStart, i_206)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i_206 : Uint256) = __warp_loop_3(dataSizeInBytes, dataStart, i_206)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_206)
end

func zero_complex_memory_array_array_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    local i_206 : Uint256 = Uint256(low=0, high=0)
    let (local i_206 : Uint256) = __warp_loop_3(dataSizeInBytes, dataStart, i_206)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_and_zero_memory_array_array_bytes_dyn{
        memory_dict : DictAccess*, msize, range_check_ptr}(length_65 : Uint256) -> (
        memPtr : Uint256):
    alloc_locals
    let (local memPtr : Uint256) = allocate_memory_array_array_bytes_dyn(length_65)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_66 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_67 : Uint256) = array_allocation_size_array_bytes_dyn(length_65)
    local range_check_ptr = range_check_ptr
    let (local _3_68 : Uint256) = u256_add(_2_67, _1_66)
    local range_check_ptr = range_check_ptr
    local _4_69 : Uint256 = Uint256(low=32, high=0)
    let (local _5_70 : Uint256) = u256_add(memPtr, _4_69)
    local range_check_ptr = range_check_ptr
    zero_complex_memory_array_array_bytes_dyn(_5_70, _3_68)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func access_calldata_tail_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref : Uint256, ptr_to_tail : Uint256) -> (addr : Uint256, length_52 : Uint256):
    alloc_locals
    let (local rel_offset_of_tail : Uint256) = calldata_load(ptr_to_tail.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_53 : Uint256) = uint256_not(Uint256(low=30, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_54 : Uint256) = __warp_constant_0()
    let (local _3_55 : Uint256) = uint256_sub(_2_54, base_ref)
    local range_check_ptr = range_check_ptr
    let (local _4_56 : Uint256) = u256_add(_3_55, _1_53)
    local range_check_ptr = range_check_ptr
    let (local _5_57 : Uint256) = slt(rel_offset_of_tail, _4_56)
    local range_check_ptr = range_check_ptr
    let (local _6_58 : Uint256) = is_zero(_5_57)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_58)
    let (local addr_1 : Uint256) = u256_add(base_ref, rel_offset_of_tail)
    local range_check_ptr = range_check_ptr
    let (local length_52 : Uint256) = calldata_load(addr_1.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_59 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_60 : Uint256) = is_gt(length_52, _7_59)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_60)
    local _9_61 : Uint256 = Uint256(low=32, high=0)
    let (local addr : Uint256) = u256_add(addr_1, _9_61)
    local range_check_ptr = range_check_ptr
    local _10_62 : Uint256 = _2_54
    let (local _11_63 : Uint256) = uint256_sub(_2_54, length_52)
    local range_check_ptr = range_check_ptr
    let (local _12_64 : Uint256) = sgt(addr, _11_63)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_64)
    return (addr, length_52)
end

func calldata_array_index_access_bytes_calldata_dyn_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref_102 : Uint256, length_103 : Uint256, index : Uint256) -> (
        addr_104 : Uint256, len : Uint256):
    alloc_locals
    let (local _1_105 : Uint256) = is_lt(index, length_103)
    local range_check_ptr = range_check_ptr
    let (local _2_106 : Uint256) = is_zero(_1_105)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_106)
    local _3_107 : Uint256 = Uint256(low=5, high=0)
    let (local _4_108 : Uint256) = uint256_shl(_3_107, index)
    local range_check_ptr = range_check_ptr
    let (local _5_109 : Uint256) = u256_add(base_ref_102, _4_108)
    local range_check_ptr = range_check_ptr
    let (local addr_1_110 : Uint256, local len_1 : Uint256) = access_calldata_tail_bytes_calldata(
        base_ref_102, _5_109)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local addr_104 : Uint256 = addr_1_110
    local len : Uint256 = len_1
    return (addr_104, len)
end

func copy_calldata_to_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length_111 : Uint256) -> ():
    alloc_locals
    calldatacopy_(dst, src, length_111)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_112 : Uint256 = Uint256(low=0, high=0)
    let (local _2_113 : Uint256) = u256_add(dst, length_111)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_2_113.low, value=_1_112)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        start : Uint256, length_32 : Uint256, pos_33 : Uint256) -> (end_34 : Uint256):
    alloc_locals
    copy_calldata_to_memory(start, pos_33, length_32)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local end_34 : Uint256) = u256_add(pos_33, length_32)
    local range_check_ptr = range_check_ptr
    return (end_34)
end

func array_allocation_size_bytes{range_check_ptr}(length_86 : Uint256) -> (size_87 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_88 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_89 : Uint256) = is_gt(length_86, _1_88)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_89)
    local _3_90 : Uint256 = Uint256(low=32, high=0)
    let (local _4_91 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_92 : Uint256 = Uint256(low=31, high=0)
    let (local _6_93 : Uint256) = u256_add(length_86, _5_92)
    local range_check_ptr = range_check_ptr
    let (local _7_94 : Uint256) = uint256_and(_6_93, _4_91)
    local range_check_ptr = range_check_ptr
    let (local size_87 : Uint256) = u256_add(_7_94, _3_90)
    local range_check_ptr = range_check_ptr
    return (size_87)
end

func allocate_memory_array_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_76 : Uint256) -> (memPtr_77 : Uint256):
    alloc_locals
    let (local _1_78 : Uint256) = array_allocation_size_bytes(length_76)
    local range_check_ptr = range_check_ptr
    let (local memPtr_77 : Uint256) = allocate_memory(_1_78)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_77.low, value=length_76)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_77)
end

func __warp_block_2{memory_dict : DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
    alloc_locals
    let (local _2_126 : Uint256) = __warp_constant_0()
    let (local data : Uint256) = allocate_memory_array_bytes(_2_126)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_127 : Uint256) = __warp_constant_0()
    local _4_128 : Uint256 = Uint256(low=0, high=0)
    local _5_129 : Uint256 = Uint256(low=32, high=0)
    let (local _6_130 : Uint256) = u256_add(data, _5_129)
    local range_check_ptr = range_check_ptr

    return (data)
end

func __warp_if_0{memory_dict : DictAccess*, msize, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        data : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local data : Uint256 = Uint256(low=96, high=0)
        return (data)
    else:
        let (local data : Uint256) = __warp_block_2()
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (data)
    end
end

func __warp_block_1{memory_dict : DictAccess*, msize, range_check_ptr}(match_var : Uint256) -> (
        data : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local data : Uint256) = __warp_if_0(__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func __warp_block_0{memory_dict : DictAccess*, msize, range_check_ptr}(_1_125 : Uint256) -> (
        data : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_125
    let (local data : Uint256) = __warp_block_1(match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func extract_returndata{memory_dict : DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
    alloc_locals
    let (local _1_125 : Uint256) = __warp_constant_0()
    let (local data : Uint256) = __warp_block_0(_1_125)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func memory_array_index_access_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index_161 : Uint256) -> (addr_162 : Uint256):
    alloc_locals
    let (local _1_163 : Uint256) = mload_(baseRef.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_164 : Uint256) = is_lt(index_161, _1_163)
    local range_check_ptr = range_check_ptr
    let (local _3_165 : Uint256) = is_zero(_2_164)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_165)
    local _4_166 : Uint256 = Uint256(low=32, high=0)
    local _5_167 : Uint256 = Uint256(low=5, high=0)
    let (local _6_168 : Uint256) = uint256_shl(_5_167, index_161)
    local range_check_ptr = range_check_ptr
    let (local _7_169 : Uint256) = u256_add(baseRef, _6_168)
    local range_check_ptr = range_check_ptr
    let (local addr_162 : Uint256) = u256_add(_7_169, _4_166)
    local range_check_ptr = range_check_ptr
    return (addr_162)
end

func increment_uint256{range_check_ptr}(value_156 : Uint256) -> (ret_157 : Uint256):
    alloc_locals
    let (local _1_158 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_159 : Uint256) = is_eq(value_156, _1_158)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_159)
    local _3_160 : Uint256 = Uint256(low=1, high=0)
    let (local ret_157 : Uint256) = u256_add(value_156, _3_160)
    local range_check_ptr = range_check_ptr
    return (ret_157)
end

func __warp_loop_body_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_data_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local expr_offset : Uint256,
        local expr_length : Uint256) = calldata_array_index_access_bytes_calldata_dyn_calldata(
        var_data_offset, var_data_length, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_142 : Uint256 = Uint256(low=64, high=0)
    let (local _2_143 : Uint256) = mload_(_1_142.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_144 : Uint256 = Uint256(low=0, high=0)
    local _4_145 : Uint256 = _3_144
    let (local _5_146 : Uint256) = abi_encode_bytes_calldata(expr_offset, expr_length, _2_143)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_147 : Uint256) = uint256_sub(_5_146, _2_143)
    local range_check_ptr = range_check_ptr
    let (local _7_148 : Uint256) = address()
    local storage_ptr : Storage* = storage_ptr
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _8_149 : Uint256) = gas()
    let (local expr_component : Uint256) = __warp_stub()
    let (local var_result_mpos : Uint256) = extract_returndata()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _9_150 : Uint256) = is_zero(expr_component)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_9_150)
    let (local _13_154 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=_13_154.low, value=var_result_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_155 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    let (local var_i : Uint256) = increment_uint256(var_i)
    local range_check_ptr = range_check_ptr
    return (var_i)
end

func __warp_loop_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_data_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(var_i, var_data_length)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_i)
    end
    let (local var_i : Uint256) = __warp_loop_body_2(
        var_data_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_i : Uint256) = __warp_loop_2(
        var_data_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_i)
end

func fun_multicall_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_data_offset : Uint256, var_data_length : Uint256) -> (var_results_mpos : Uint256):
    alloc_locals
    let (local var_results_mpos : Uint256) = allocate_and_zero_memory_array_array_bytes_dyn(
        var_data_length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_i : Uint256 = Uint256(low=0, high=0)
    let (local var_i : Uint256) = __warp_loop_2(
        var_data_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_results_mpos)
end

func array_storeLengthForEncoding_array_bytes_dyn{
        memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_95 : Uint256, length_96 : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    mstore_(offset=pos_95.low, value=length_96)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_97 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos_95, _1_97)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func array_storeLengthForEncoding_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_98 : Uint256, length_99 : Uint256) -> (updated_pos_100 : Uint256):
    alloc_locals
    mstore_(offset=pos_98.low, value=length_99)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_101 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos_100 : Uint256) = u256_add(pos_98, _1_101)
    local range_check_ptr = range_check_ptr
    return (updated_pos_100)
end

func __warp_loop_body_1{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_115 : Uint256, i_117 : Uint256, src_114 : Uint256) -> (i_117 : Uint256):
    alloc_locals
    let (local _2_119 : Uint256) = u256_add(src_114, i_117)
    local range_check_ptr = range_check_ptr
    let (local _3_120 : Uint256) = mload_(_2_119.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _4_121 : Uint256) = u256_add(dst_115, i_117)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_4_121.low, value=_3_120)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_118 : Uint256 = Uint256(low=32, high=0)
    let (local i_117 : Uint256) = u256_add(i_117, _1_118)
    local range_check_ptr = range_check_ptr
    return (i_117)
end

func __warp_loop_1{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_115 : Uint256, i_117 : Uint256, length_116 : Uint256, src_114 : Uint256) -> (
        i_117 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i_117, length_116)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i_117)
    end
    let (local i_117 : Uint256) = __warp_loop_body_1(dst_115, i_117, src_114)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i_117 : Uint256) = __warp_loop_1(dst_115, i_117, length_116, src_114)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_117)
end

func __warp_block_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_115 : Uint256, length_116 : Uint256) -> ():
    alloc_locals
    local _6_123 : Uint256 = Uint256(low=0, high=0)
    let (local _7_124 : Uint256) = u256_add(dst_115, length_116)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_7_124.low, value=_6_123)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_1{memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_122 : Uint256, dst_115 : Uint256, length_116 : Uint256) -> ():
    alloc_locals
    if _5_122.low + _5_122.high != 0:
        __warp_block_3(dst_115, length_116)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{memory_dict : DictAccess*, msize, range_check_ptr}(
        src_114 : Uint256, dst_115 : Uint256, length_116 : Uint256) -> ():
    alloc_locals
    local i_117 : Uint256 = Uint256(low=0, high=0)
    let (local i_117 : Uint256) = __warp_loop_1(dst_115, i_117, length_116, src_114)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_122 : Uint256) = is_gt(i_117, length_116)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_5_122, dst_115, length_116)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_35 : Uint256, pos_36 : Uint256) -> (end_37 : Uint256):
    alloc_locals
    let (local length_38 : Uint256) = mload_(value_35.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_1_39 : Uint256) = array_storeLengthForEncoding_bytes(pos_36, length_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_40 : Uint256 = Uint256(low=32, high=0)
    let (local _2_41 : Uint256) = u256_add(value_35, _1_40)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_41, pos_1_39, length_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_42 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _4_43 : Uint256 = Uint256(low=31, high=0)
    let (local _5_44 : Uint256) = u256_add(length_38, _4_43)
    local range_check_ptr = range_check_ptr
    let (local _6_45 : Uint256) = uint256_and(_5_44, _3_42)
    local range_check_ptr = range_check_ptr
    let (local end_37 : Uint256) = u256_add(pos_1_39, _6_45)
    local range_check_ptr = range_check_ptr
    return (end_37)
end

func abi_encodeUpdatedPos_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_21 : Uint256, pos : Uint256) -> (updatedPos : Uint256):
    alloc_locals
    let (local updatedPos : Uint256) = abi_encode_bytes(value0_21, pos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (updatedPos)
end

func __warp_loop_body_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_27 : Uint256, i : Uint256, pos_1 : Uint256, pos_22 : Uint256, srcPtr : Uint256,
        tail : Uint256) -> (i : Uint256, pos_22 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local _6_30 : Uint256) = uint256_sub(tail, pos_1)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_22.low, value=_6_30)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_31 : Uint256) = mload_(srcPtr.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = abi_encodeUpdatedPos_bytes(_7_31, tail)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local srcPtr : Uint256) = u256_add(srcPtr, _3_27)
    local range_check_ptr = range_check_ptr
    let (local pos_22 : Uint256) = u256_add(pos_22, _3_27)
    local range_check_ptr = range_check_ptr
    local _5_29 : Uint256 = Uint256(low=1, high=0)
    let (local i : Uint256) = u256_add(i, _5_29)
    local range_check_ptr = range_check_ptr
    return (i, pos_22, srcPtr, tail)
end

func __warp_loop_0{memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_27 : Uint256, i : Uint256, length_24 : Uint256, pos_1 : Uint256, pos_22 : Uint256,
        srcPtr : Uint256, tail : Uint256) -> (
        i : Uint256, pos_22 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i, length_24)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i, pos_22, srcPtr, tail)
    end
    let (local i : Uint256, local pos_22 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_body_0(_3_27, i, pos_1, pos_22, srcPtr, tail)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i : Uint256, local pos_22 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_3_27, i, length_24, pos_1, pos_22, srcPtr, tail)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i, pos_22, srcPtr, tail)
end

func abi_encode_array_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos_22 : Uint256) -> (end_23 : Uint256):
    alloc_locals
    let (local length_24 : Uint256) = mload_(value.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_22 : Uint256) = array_storeLengthForEncoding_array_bytes_dyn(pos_22, length_24)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local pos_1 : Uint256 = pos_22
    local _1_25 : Uint256 = Uint256(low=5, high=0)
    let (local _2_26 : Uint256) = uint256_shl(_1_25, length_24)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = u256_add(pos_22, _2_26)
    local range_check_ptr = range_check_ptr
    local _3_27 : Uint256 = Uint256(low=32, high=0)
    local _4_28 : Uint256 = _3_27
    let (local srcPtr : Uint256) = u256_add(value, _3_27)
    local range_check_ptr = range_check_ptr
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256, local pos_22 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_3_27, i, length_24, pos_1, pos_22, srcPtr, tail)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local end_23 : Uint256 = tail
    return (end_23)
end

func abi_encode_array_bytes_memory_ptr_dyn_memory_ptr{
        memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_46 : Uint256, value0_47 : Uint256) -> (tail_48 : Uint256):
    alloc_locals
    local _1_49 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=headStart_46.low, value=_1_49)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_50 : Uint256 = _1_49
    let (local _3_51 : Uint256) = u256_add(headStart_46, _1_49)
    local range_check_ptr = range_check_ptr
    let (local tail_48 : Uint256) = abi_encode_array_bytes_dyn(value0_47, _3_51)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_48)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _13 : Uint256 = _4
    local _14 : Uint256 = _3
    let (local param : Uint256,
        local param_1 : Uint256) = abi_decode_array_bytes_calldata_dyn_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret__warp_mangled : Uint256) = fun_multicall_dynArgs(param, param_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _15 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = abi_encode_array_bytes_memory_ptr_dyn_memory_ptr(
        memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = uint256_sub(_16, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _12 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_5(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=3544941711, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_3(_12, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
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
        __warp_if_2(_2, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

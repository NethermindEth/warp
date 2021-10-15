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
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

func __warp_cond_revert(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func copy_calldata_to_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, dst : Uint256, length_96 : Uint256) -> ():
    alloc_locals
    calldatacopy_(dst, src, length_96)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_97 : Uint256 = Uint256(low=0, high=0)
    let (local _2_98 : Uint256) = u256_add(dst, length_96)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_2_98.low, value=_1_97)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        start : Uint256, length_22 : Uint256, pos_23 : Uint256) -> (end_24 : Uint256):
    alloc_locals
    copy_calldata_to_memory(start, pos_23, length_22)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local end_24 : Uint256) = u256_add(pos_23, length_22)
    local range_check_ptr = range_check_ptr
    return (end_24)
end

func access_calldata_tail_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref : Uint256, ptr_to_tail : Uint256) -> (addr : Uint256, length_41 : Uint256):
    alloc_locals
    let (local rel_offset_of_tail : Uint256) = calldata_load(ptr_to_tail.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_42 : Uint256) = uint256_not(Uint256(low=30, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_43 : Uint256) = __warp_constant_0()
    let (local _3_44 : Uint256) = uint256_sub(_2_43, base_ref)
    local range_check_ptr = range_check_ptr
    let (local _4_45 : Uint256) = u256_add(_3_44, _1_42)
    local range_check_ptr = range_check_ptr
    let (local _5_46 : Uint256) = slt(rel_offset_of_tail, _4_45)
    local range_check_ptr = range_check_ptr
    let (local _6_47 : Uint256) = is_zero(_5_46)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_47)
    let (local addr_1 : Uint256) = u256_add(base_ref, rel_offset_of_tail)
    local range_check_ptr = range_check_ptr
    let (local length_41 : Uint256) = calldata_load(addr_1.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_48 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_49 : Uint256) = is_gt(length_41, _7_48)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_49)
    local _9_50 : Uint256 = Uint256(low=32, high=0)
    let (local addr : Uint256) = u256_add(addr_1, _9_50)
    local range_check_ptr = range_check_ptr
    local _10_51 : Uint256 = _2_43
    let (local _11_52 : Uint256) = uint256_sub(_2_43, length_41)
    local range_check_ptr = range_check_ptr
    let (local _12_53 : Uint256) = sgt(addr, _11_52)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_53)
    return (addr, length_41)
end

func array_allocation_size_array_bytes_dyn{range_check_ptr}(length_68 : Uint256) -> (
        size_69 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_70 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_71 : Uint256) = is_gt(length_68, _1_70)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_71)
    local _3_72 : Uint256 = Uint256(low=32, high=0)
    local _4_73 : Uint256 = Uint256(low=5, high=0)
    let (local _5_74 : Uint256) = uint256_shl(_4_73, length_68)
    local range_check_ptr = range_check_ptr
    let (local size_69 : Uint256) = u256_add(_5_74, _3_72)
    local range_check_ptr = range_check_ptr
    return (size_69)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_116 : Uint256, size_117 : Uint256) -> ():
    alloc_locals
    let (local _1_118 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_119 : Uint256 = Uint256(low=31, high=0)
    let (local _3_120 : Uint256) = u256_add(size_117, _2_119)
    local range_check_ptr = range_check_ptr
    let (local _4_121 : Uint256) = uint256_and(_3_120, _1_118)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr_116, _4_121)
    local range_check_ptr = range_check_ptr
    let (local _5_122 : Uint256) = is_lt(newFreePtr, memPtr_116)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_123 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_124 : Uint256) = is_gt(newFreePtr, _6_123)
    local range_check_ptr = range_check_ptr
    let (local _8_125 : Uint256) = uint256_sub(_7_124, _5_122)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_125)
    local _9_126 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_126.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr_60 : Uint256):
    alloc_locals
    local _1_61 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_60 : Uint256) = mload_(_1_61.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_60, size)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_60)
end

func allocate_memory_array_array_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_62 : Uint256) -> (memPtr_63 : Uint256):
    alloc_locals
    let (local _1_64 : Uint256) = array_allocation_size_array_bytes_dyn(length_62)
    local range_check_ptr = range_check_ptr
    let (local memPtr_63 : Uint256) = allocate_memory(_1_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_63.low, value=length_62)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_63)
end

func __warp_loop_body_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, i_173 : Uint256) -> (i_173 : Uint256):
    alloc_locals
    local _2_175 : Uint256 = Uint256(low=96, high=0)
    let (local _3_176 : Uint256) = u256_add(dataStart, i_173)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_3_176.low, value=_2_175)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_174 : Uint256 = Uint256(low=32, high=0)
    let (local i_173 : Uint256) = u256_add(i_173, _1_174)
    local range_check_ptr = range_check_ptr
    return (i_173)
end

func __warp_loop_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataSizeInBytes : Uint256, dataStart : Uint256, i_173 : Uint256) -> (i_173 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(i_173, dataSizeInBytes)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i_173)
    end
    let (local i_173 : Uint256) = __warp_loop_body_3(dataStart, i_173)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i_173 : Uint256) = __warp_loop_3(dataSizeInBytes, dataStart, i_173)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_173)
end

func zero_complex_memory_array_array_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    local i_173 : Uint256 = Uint256(low=0, high=0)
    let (local i_173 : Uint256) = __warp_loop_3(dataSizeInBytes, dataStart, i_173)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_and_zero_memory_array_array_bytes_dyn{
        memory_dict : DictAccess*, msize, range_check_ptr}(length_54 : Uint256) -> (
        memPtr : Uint256):
    alloc_locals
    let (local memPtr : Uint256) = allocate_memory_array_array_bytes_dyn(length_54)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_55 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_56 : Uint256) = array_allocation_size_array_bytes_dyn(length_54)
    local range_check_ptr = range_check_ptr
    let (local _3_57 : Uint256) = u256_add(_2_56, _1_55)
    local range_check_ptr = range_check_ptr
    local _4_58 : Uint256 = Uint256(low=32, high=0)
    let (local _5_59 : Uint256) = u256_add(memPtr, _4_58)
    local range_check_ptr = range_check_ptr
    zero_complex_memory_array_array_bytes_dyn(_5_59, _3_57)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func array_allocation_size_bytes{range_check_ptr}(length_75 : Uint256) -> (size_76 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_77 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_78 : Uint256) = is_gt(length_75, _1_77)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_78)
    local _3_79 : Uint256 = Uint256(low=32, high=0)
    let (local _4_80 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_81 : Uint256 = Uint256(low=31, high=0)
    let (local _6_82 : Uint256) = u256_add(length_75, _5_81)
    local range_check_ptr = range_check_ptr
    let (local _7_83 : Uint256) = uint256_and(_6_82, _4_80)
    local range_check_ptr = range_check_ptr
    let (local size_76 : Uint256) = u256_add(_7_83, _3_79)
    local range_check_ptr = range_check_ptr
    return (size_76)
end

func allocate_memory_array_bytes{memory_dict : DictAccess*, msize, range_check_ptr}(
        length_65 : Uint256) -> (memPtr_66 : Uint256):
    alloc_locals
    let (local _1_67 : Uint256) = array_allocation_size_bytes(length_65)
    local range_check_ptr = range_check_ptr
    let (local memPtr_66 : Uint256) = allocate_memory(_1_67)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_66.low, value=length_65)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_66)
end

func calldata_array_index_access_bytes_calldata_dyn_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref_87 : Uint256, length_88 : Uint256, index : Uint256) -> (
        addr_89 : Uint256, len : Uint256):
    alloc_locals
    let (local _1_90 : Uint256) = is_lt(index, length_88)
    local range_check_ptr = range_check_ptr
    let (local _2_91 : Uint256) = is_zero(_1_90)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_91)
    local _3_92 : Uint256 = Uint256(low=5, high=0)
    let (local _4_93 : Uint256) = uint256_shl(_3_92, index)
    local range_check_ptr = range_check_ptr
    let (local _5_94 : Uint256) = u256_add(base_ref_87, _4_93)
    local range_check_ptr = range_check_ptr
    let (local addr_1_95 : Uint256, local len_1 : Uint256) = access_calldata_tail_bytes_calldata(
        base_ref_87, _5_94)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local addr_89 : Uint256 = addr_1_95
    local len : Uint256 = len_1
    return (addr_89, len)
end

func __warp_block_3{memory_dict : DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
    alloc_locals
    let (local _2_111 : Uint256) = __warp_constant_0()
    let (local data : Uint256) = allocate_memory_array_bytes(_2_111)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_112 : Uint256) = __warp_constant_0()
    local _4_113 : Uint256 = Uint256(low=0, high=0)
    local _5_114 : Uint256 = Uint256(low=32, high=0)
    let (local _6_115 : Uint256) = u256_add(data, _5_114)
    local range_check_ptr = range_check_ptr

    return (data)
end

func __warp_if_1{memory_dict : DictAccess*, msize, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        data : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local data : Uint256 = Uint256(low=96, high=0)
        return (data)
    else:
        let (local data : Uint256) = __warp_block_3()
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (data)
    end
end

func __warp_block_2{memory_dict : DictAccess*, msize, range_check_ptr}(match_var : Uint256) -> (
        data : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local data : Uint256) = __warp_if_1(__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func __warp_block_1{memory_dict : DictAccess*, msize, range_check_ptr}(_1_110 : Uint256) -> (
        data : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_110
    let (local data : Uint256) = __warp_block_2(match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func extract_returndata{memory_dict : DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
    alloc_locals
    let (local _1_110 : Uint256) = __warp_constant_0()
    let (local data : Uint256) = __warp_block_1(_1_110)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func memory_array_index_access_bytes_dyn{memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index_144 : Uint256) -> (addr_145 : Uint256):
    alloc_locals
    let (local _1_146 : Uint256) = mload_(baseRef.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_147 : Uint256) = is_lt(index_144, _1_146)
    local range_check_ptr = range_check_ptr
    let (local _3_148 : Uint256) = is_zero(_2_147)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_148)
    local _4_149 : Uint256 = Uint256(low=32, high=0)
    local _5_150 : Uint256 = Uint256(low=5, high=0)
    let (local _6_151 : Uint256) = uint256_shl(_5_150, index_144)
    local range_check_ptr = range_check_ptr
    let (local _7_152 : Uint256) = u256_add(baseRef, _6_151)
    local range_check_ptr = range_check_ptr
    let (local addr_145 : Uint256) = u256_add(_7_152, _4_149)
    local range_check_ptr = range_check_ptr
    return (addr_145)
end

func increment_uint256{range_check_ptr}(value_140 : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    let (local _1_141 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_142 : Uint256) = is_eq(value_140, _1_141)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_142)
    local _3_143 : Uint256 = Uint256(low=1, high=0)
    let (local ret__warp_mangled : Uint256) = u256_add(value_140, _3_143)
    local range_check_ptr = range_check_ptr
    return (ret__warp_mangled)
end

func __warp_loop_body_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_data_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local expr_offset : Uint256,
        local expr_length : Uint256) = calldata_array_index_access_bytes_calldata_dyn_calldata(
        var_data_offset, var_data_length, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_127 : Uint256 = Uint256(low=64, high=0)
    let (local _2_128 : Uint256) = mload_(_1_127.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_129 : Uint256 = Uint256(low=0, high=0)
    local _4_130 : Uint256 = _3_129
    let (local _5_131 : Uint256) = abi_encode_bytes_calldata(expr_offset, expr_length, _2_128)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_132 : Uint256) = uint256_sub(_5_131, _2_128)
    local range_check_ptr = range_check_ptr
    let (local _7_133 : Uint256) = address()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _8_134 : Uint256) = gas()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_component : Uint256) = delegatecall(
        _8_134, _7_133, _2_128, _6_132, _3_129, _3_129)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local var_result_mpos : Uint256) = extract_returndata()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _9_135 : Uint256) = is_zero(expr_component)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_9_135)
    let (local _13_139 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=_13_139.low, value=var_result_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    let (local var_i : Uint256) = increment_uint256(var_i)
    local range_check_ptr = range_check_ptr
    return (var_i)
end

func __warp_loop_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_data_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(var_i, var_data_length)
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
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_i : Uint256) = __warp_loop_2(
        var_data_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_i)
end

func fun_multicall{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
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
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_results_mpos)
end

@external
func fun_multicall_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_data_offset : Uint256, var_data_length : Uint256, calldata_size, calldata_len,
        calldata : felt*) -> (var_results_mpos : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    with memory_dict, msize, exec_env:
        let (local var_results_mpos : Uint256) = fun_multicall(var_data_offset, var_data_length)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_results_mpos=var_results_mpos)
end

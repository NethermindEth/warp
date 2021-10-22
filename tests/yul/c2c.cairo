%lang starknet
%builtins pedersen range_check

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.calls import calldata_load, returndata_write, warp_static_call
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_identity_Uint256(arg0 : Uint256) -> (arg0 : Uint256):
    return (arg0)
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func this_address() -> (res : felt):
end

func address{
        syscall_ptr : felt*, storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        ) -> (res : Uint256):
    let (addr) = this_address.read()
    return (res=Uint256(low=addr, high=0))
end

@storage_var
func address_initialized() -> (res : felt):
end

func gas() -> (res : Uint256):
    return (Uint256(100000, 100000))
end

func initialize_address{
        syscall_ptr : felt*, storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end

func __warp_cond_revert(_4_134 : Uint256) -> ():
    alloc_locals
    if _4_134.low + _4_134.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func validator_revert_address{range_check_ptr}(value_130 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_131 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_132 : Uint256) = uint256_and(value_130, _1_131)
    local range_check_ptr = range_check_ptr
    let (local _3_133 : Uint256) = is_eq(value_130, _2_132)
    local range_check_ptr = range_check_ptr
    let (local _4_134 : Uint256) = is_zero(_3_133)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_134)
    return ()
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}(offset : Uint256) -> (
        value : Uint256):
    alloc_locals
    let (local value : Uint256) = calldata_load(offset.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_address(value)
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_array_uint8_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_1 : Uint256, end__warp_mangled : Uint256) -> (arrayPos : Uint256, length : Uint256):
    alloc_locals
    local _1_2 : Uint256 = Uint256(low=31, high=0)
    let (local _2_3 : Uint256) = u256_add(offset_1, _1_2)
    local range_check_ptr = range_check_ptr
    let (local _3_4 : Uint256) = slt(_2_3, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    let (local _4_5 : Uint256) = is_zero(_3_4)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_5)
    let (local length : Uint256) = calldata_load(offset_1.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_6 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_7 : Uint256) = is_gt(length, _5_6)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_7)
    local _7_8 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos : Uint256) = u256_add(offset_1, _7_8)
    local range_check_ptr = range_check_ptr
    local _8_9 : Uint256 = _7_8
    local _9_10 : Uint256 = Uint256(low=5, high=0)
    let (local _10_11 : Uint256) = uint256_shl(_9_10, length)
    local range_check_ptr = range_check_ptr
    let (local _11_12 : Uint256) = u256_add(offset_1, _10_11)
    local range_check_ptr = range_check_ptr
    let (local _12_13 : Uint256) = u256_add(_11_12, _7_8)
    local range_check_ptr = range_check_ptr
    let (local _13_14 : Uint256) = is_gt(_12_13, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_14)
    return (arrayPos, length)
end

func abi_decode_addresst_array_uint8_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_19 : Uint256 = Uint256(low=64, high=0)
    let (local _2_20 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_21 : Uint256) = slt(_2_20, _1_19)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_21)
    let (local value0 : Uint256) = abi_decode_address(headStart)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_22 : Uint256 = Uint256(low=32, high=0)
    let (local _5_23 : Uint256) = u256_add(headStart, _4_22)
    local range_check_ptr = range_check_ptr
    let (local offset_24 : Uint256) = calldata_load(_5_23.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_25 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_26 : Uint256) = is_gt(offset_24, _6_25)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_26)
    let (local _8_27 : Uint256) = u256_add(headStart, offset_24)
    local range_check_ptr = range_check_ptr
    let (local value1_1 : Uint256, local value2_1 : Uint256) = abi_decode_array_uint8_dyn_calldata(
        _8_27, dataEnd)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local value1 : Uint256 = value1_1
    local value2 : Uint256 = value2_1
    return (value0, value1, value2)
end

func array_storeLengthForEncoding_array_uint8_dyn{
        memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_73 : Uint256, length_74 : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    mstore_(offset=pos_73.low, value=length_74)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_75 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos_73, _1_75)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func validator_revert_uint8{range_check_ptr}(value_144 : Uint256) -> ():
    alloc_locals
    local _1_145 : Uint256 = Uint256(low=255, high=0)
    let (local _2_146 : Uint256) = uint256_and(value_144, _1_145)
    local range_check_ptr = range_check_ptr
    let (local _3_147 : Uint256) = is_eq(value_144, _2_146)
    local range_check_ptr = range_check_ptr
    let (local _4_148 : Uint256) = is_zero(_3_147)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_148)
    return ()
end

func abi_decode_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(offset_17 : Uint256) -> (
        value_18 : Uint256):
    alloc_locals
    let (local value_18 : Uint256) = calldata_load(offset_17.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_uint8(value_18)
    local range_check_ptr = range_check_ptr
    return (value_18)
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_59 : Uint256, pos_60 : Uint256) -> ():
    alloc_locals
    local _1_61 : Uint256 = Uint256(low=255, high=0)
    let (local _2_62 : Uint256) = uint256_and(value_59, _1_61)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_60.low, value=_2_62)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encodeUpdatedPos_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_46 : Uint256, pos : Uint256) -> (updatedPos : Uint256):
    alloc_locals
    abi_encode_uint8(value0_46, pos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_47 : Uint256 = Uint256(low=32, high=0)
    let (local updatedPos : Uint256) = u256_add(pos, _1_47)
    local range_check_ptr = range_check_ptr
    return (updatedPos)
end

func __warp_loop_body_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        i : Uint256, pos_50 : Uint256, srcPtr : Uint256) -> (
        i : Uint256, pos_50 : Uint256, srcPtr : Uint256):
    alloc_locals
    let (local _2_53 : Uint256) = abi_decode_uint8(srcPtr)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local pos_50 : Uint256) = abi_encodeUpdatedPos_uint8(_2_53, pos_50)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_54 : Uint256 = Uint256(low=32, high=0)
    let (local srcPtr : Uint256) = u256_add(srcPtr, _3_54)
    local range_check_ptr = range_check_ptr
    local _1_52 : Uint256 = Uint256(low=1, high=0)
    let (local i : Uint256) = u256_add(i, _1_52)
    local range_check_ptr = range_check_ptr
    return (i, pos_50, srcPtr)
end

func __warp_loop_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        i : Uint256, length_49 : Uint256, pos_50 : Uint256, srcPtr : Uint256) -> (
        i : Uint256, pos_50 : Uint256, srcPtr : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i, length_49)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i, pos_50, srcPtr)
    end
    let (local i : Uint256, local pos_50 : Uint256, local srcPtr : Uint256) = __warp_loop_body_0(
        i, pos_50, srcPtr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local i : Uint256, local pos_50 : Uint256, local srcPtr : Uint256) = __warp_loop_0(
        i, length_49, pos_50, srcPtr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (i, pos_50, srcPtr)
end

func abi_encode_array_uint8_dyn_calldata_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_48 : Uint256, length_49 : Uint256, pos_50 : Uint256) -> (end_51 : Uint256):
    alloc_locals
    let (local pos_50 : Uint256) = array_storeLengthForEncoding_array_uint8_dyn(pos_50, length_49)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local srcPtr : Uint256 = value_48
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256, local pos_50 : Uint256, local srcPtr : Uint256) = __warp_loop_0(
        i, length_49, pos_50, srcPtr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local end_51 : Uint256 = pos_50
    return (end_51)
end

func abi_encode_array_uint8_dyn_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_63 : Uint256, value0_64 : Uint256, value1_65 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_66 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=headStart_63.low, value=_1_66)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_67 : Uint256 = _1_66
    let (local _3_68 : Uint256) = u256_add(headStart_63, _1_66)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = abi_encode_array_uint8_dyn_calldata_ptr(
        value0_64, value1_65, _3_68)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_76 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_77 : Uint256 = Uint256(low=31, high=0)
    let (local _3_78 : Uint256) = u256_add(size, _2_77)
    local range_check_ptr = range_check_ptr
    let (local _4_79 : Uint256) = uint256_and(_3_78, _1_76)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_79)
    local range_check_ptr = range_check_ptr
    let (local _5_80 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_81 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_82 : Uint256) = is_gt(newFreePtr, _6_81)
    local range_check_ptr = range_check_ptr
    let (local _8_83 : Uint256) = uint256_sub(_7_82, _5_80)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_83)
    local _9_84 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_84.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func validator_revert_bool{range_check_ptr}(value_137 : Uint256) -> ():
    alloc_locals
    let (local _1_138 : Uint256) = is_zero(value_137)
    local range_check_ptr = range_check_ptr
    let (local _2_139 : Uint256) = is_zero(_1_138)
    local range_check_ptr = range_check_ptr
    let (local _3_140 : Uint256) = is_eq(value_137, _2_139)
    local range_check_ptr = range_check_ptr
    let (local _4_141 : Uint256) = is_zero(_3_140)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_141)
    return ()
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_15 : Uint256) -> (value_16 : Uint256):
    alloc_locals
    let (local value_16 : Uint256) = mload_(offset_15.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    validator_revert_bool(value_16)
    local range_check_ptr = range_check_ptr
    return (value_16)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_40 : Uint256, dataEnd_41 : Uint256) -> (value0_42 : Uint256):
    alloc_locals
    local _1_43 : Uint256 = Uint256(low=32, high=0)
    let (local _2_44 : Uint256) = uint256_sub(dataEnd_41, headStart_40)
    local range_check_ptr = range_check_ptr
    let (local _3_45 : Uint256) = slt(_2_44, _1_43)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_45)
    let (local value0_42 : Uint256) = abi_decode_t_bool_fromMemory(headStart_40)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_42)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_90 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _16_100 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    finalize_allocation(_6_90, _16_100)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_101 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    let (local _18_102 : Uint256) = u256_add(_6_90, _17_101)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_bool_fromMemory(_6_90, _18_102)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _14_98 : Uint256, _6_90 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _14_98.low + _14_98.high != 0:
        let (local expr : Uint256) = __warp_block_0(_6_90)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr)
    else:
        return (expr)
    end
end

func fun_callMe_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_add : Uint256, var_arr_offset : Uint256, var_arr_6_length : Uint256) -> (var : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_87 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_88 : Uint256) = uint256_and(var_add, _1_87)
    local range_check_ptr = range_check_ptr
    local _5_89 : Uint256 = Uint256(low=64, high=0)
    let (local _6_90 : Uint256) = mload_(_5_89.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_91 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=2934227323, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_90.low, value=_7_91)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_92 : Uint256 = Uint256(low=32, high=0)
    local _9_93 : Uint256 = Uint256(low=4, high=0)
    let (local _10_94 : Uint256) = u256_add(_6_90, _9_93)
    local range_check_ptr = range_check_ptr
    let (local _11_95 : Uint256) = abi_encode_array_uint8_dyn_calldata(
        _10_94, var_arr_offset, var_arr_6_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _12_96 : Uint256) = uint256_sub(_11_95, _6_90)
    local range_check_ptr = range_check_ptr
    let (local _13_97 : Uint256) = gas()
    local range_check_ptr = range_check_ptr
    let (local _14_98 : Uint256) = warp_static_call(_13_97, _2_88, _6_90, _12_96, _6_90, _8_92)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _15_99 : Uint256) = is_zero(_14_98)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_15_99)
    local expr : Uint256 = Uint256(low=0, high=0)
    let (local expr : Uint256) = __warp_if_0(_14_98, _6_90, expr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local var : Uint256 = expr
    return (var)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_55 : Uint256, pos_56 : Uint256) -> ():
    alloc_locals
    let (local _1_57 : Uint256) = is_zero(value_55)
    local range_check_ptr = range_check_ptr
    let (local _2_58 : Uint256) = is_zero(_1_57)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_56.low, value=_2_58)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_69 : Uint256, value0_70 : Uint256) -> (tail_71 : Uint256):
    alloc_locals
    local _1_72 : Uint256 = Uint256(low=32, high=0)
    let (local tail_71 : Uint256) = u256_add(headStart_69, _1_72)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_70, headStart_69)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_71)
end

func abi_decode_array_uint8_dyn_calldata_ptr{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_28 : Uint256, dataEnd_29 : Uint256) -> (value0_30 : Uint256, value1_31 : Uint256):
    alloc_locals
    local _1_32 : Uint256 = Uint256(low=32, high=0)
    let (local _2_33 : Uint256) = uint256_sub(dataEnd_29, headStart_28)
    local range_check_ptr = range_check_ptr
    let (local _3_34 : Uint256) = slt(_2_33, _1_32)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_34)
    let (local offset_35 : Uint256) = calldata_load(headStart_28.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_36 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_37 : Uint256) = is_gt(offset_35, _4_36)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_37)
    let (local _6_38 : Uint256) = u256_add(headStart_28, offset_35)
    local range_check_ptr = range_check_ptr
    let (local value0_1 : Uint256,
        local value1_1_39 : Uint256) = abi_decode_array_uint8_dyn_calldata(_6_38, dataEnd_29)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local value0_30 : Uint256 = value0_1
    local value1_31 : Uint256 = value1_1_39
    return (value0_30, value1_31)
end

func fun_callMeMaybe_dynArgs{range_check_ptr}(var_arr_length : Uint256) -> (var_ : Uint256):
    alloc_locals
    local var_ : Uint256 = Uint256(low=0, high=0)
    local _1_85 : Uint256 = Uint256(low=8, high=0)
    let (local _2_86 : Uint256) = is_gt(var_arr_length, _1_85)
    local range_check_ptr = range_check_ptr
    if _2_86.low + _2_86.high != 0:
        local var_ : Uint256 = Uint256(low=0, high=0)
        return (var_)
    end
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> (
        ):
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    local _13 : Uint256 = _3
    let (local param : Uint256, local param_1 : Uint256,
        local param_2 : Uint256) = abi_decode_addresst_array_uint8_dyn_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret__warp_mangled : Uint256) = fun_callMe_dynArgs(param, param_1, param_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_sub(_15, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _16)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _17 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17)
    local _18 : Uint256 = _4
    local _19 : Uint256 = _3
    let (local param_3 : Uint256,
        local param_4 : Uint256) = abi_decode_array_uint8_dyn_calldata_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret_1 : Uint256) = fun_callMeMaybe_dynArgs(param_4)
    local range_check_ptr = range_check_ptr
    local _20 : Uint256 = _2
    let (local memPos_1 : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_bool(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _22)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2934227323, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_2, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        __warp_block_5(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2052931480, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_3(_2, _3, _4, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> (
        ):
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_2(_10, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_1(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> (
        success : felt, returndata_size : felt, returndata_len : felt, f0 : felt, f1 : felt,
        f2 : felt, f3 : felt, f4 : felt, f5 : felt, f6 : felt, f7 : felt):
    alloc_locals
    let (local storage_ptr : Storage*) = alloc()
    initialize_address{
        syscall_ptr=syscall_ptr,
        storage_ptr=storage_ptr,
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr}(self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
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
        __warp_if_1(_2, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env

    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (
        1,
        exec_env.to_returndata_size,
        exec_env.to_returndata_len,
        f0=exec_env.to_returndata[0],
        f1=exec_env.to_returndata[1],
        f2=exec_env.to_returndata[2],
        f3=exec_env.to_returndata[3],
        f4=exec_env.to_returndata[4],
        f5=exec_env.to_returndata[5],
        f6=exec_env.to_returndata[6],
        f7=exec_env.to_returndata[7])
end

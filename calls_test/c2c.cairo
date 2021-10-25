%lang starknet
%builtins pedersen range_check

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.calls import calldata_load, calldatasize_, returndata_write, warp_static_call
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

func __warp_cond_revert(_4_101 : Uint256) -> ():
    alloc_locals
    if _4_101.low + _4_101.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func validator_revert_uint8{range_check_ptr}(value_97 : Uint256) -> ():
    alloc_locals
    local _1_98 : Uint256 = Uint256(low=255, high=0)
    let (local _2_99 : Uint256) = uint256_and(value_97, _1_98)
    local range_check_ptr = range_check_ptr
    let (local _3_100 : Uint256) = is_eq(value_97, _2_99)
    local range_check_ptr = range_check_ptr
    let (local _4_101 : Uint256) = is_zero(_3_100)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_101)
    return ()
end

func abi_decode_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(offset_3 : Uint256) -> (
        value_4 : Uint256):
    alloc_locals
    let (local value_4 : Uint256) = calldata_load(offset_3.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_uint8(value_4)
    local range_check_ptr = range_check_ptr
    return (value_4)
end

func abi_decode_tuple_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_14 : Uint256, dataEnd_15 : Uint256) -> (value0_16 : Uint256):
    alloc_locals
    local _1_17 : Uint256 = Uint256(low=32, high=0)
    let (local _2_18 : Uint256) = uint256_sub(dataEnd_15, headStart_14)
    local range_check_ptr = range_check_ptr
    let (local _3_19 : Uint256) = slt(_2_18, _1_17)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_19)
    let (local value0_16 : Uint256) = abi_decode_uint8(headStart_14)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0_16)
end

func fun_callMeMaybe{range_check_ptr}(var_arr : Uint256) -> (var_ : Uint256):
    alloc_locals
    local var_ : Uint256 = Uint256(low=0, high=0)
    local _1_43 : Uint256 = Uint256(low=8, high=0)
    local _2_44 : Uint256 = Uint256(low=255, high=0)
    let (local _3_45 : Uint256) = uint256_and(var_arr, _2_44)
    local range_check_ptr = range_check_ptr
    let (local _4_46 : Uint256) = is_gt(_3_45, _1_43)
    local range_check_ptr = range_check_ptr
    if _4_46.low + _4_46.high != 0:
        local var_ : Uint256 = Uint256(low=0, high=0)
        return (var_)
    end
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

@view
func fun_callMeMaybe_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_arr : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_ : Uint256) = fun_callMeMaybe(var_arr)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_=var_)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_20 : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_21 : Uint256) = is_zero(value_20)
    local range_check_ptr = range_check_ptr
    let (local _2_22 : Uint256) = is_zero(_1_21)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos.low, value=_2_22)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_27 : Uint256, value0_28 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_29 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_27, _1_29)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_28, headStart_27)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func validator_revert_address{range_check_ptr}(value_83 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_84 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_85 : Uint256) = uint256_and(value_83, _1_84)
    local range_check_ptr = range_check_ptr
    let (local _3_86 : Uint256) = is_eq(value_83, _2_85)
    local range_check_ptr = range_check_ptr
    let (local _4_87 : Uint256) = is_zero(_3_86)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_87)
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

func abi_decode_tuple_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=32, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_7)
    let (local value0 : Uint256) = abi_decode_address(headStart)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0)
end

func abi_encode_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_23 : Uint256, pos_24 : Uint256) -> ():
    alloc_locals
    local _1_25 : Uint256 = Uint256(low=255, high=0)
    let (local _2_26 : Uint256) = uint256_and(value_23, _1_25)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_24.low, value=_2_26)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_30 : Uint256, value0_31 : Uint256) -> (tail_32 : Uint256):
    alloc_locals
    local _1_33 : Uint256 = Uint256(low=32, high=0)
    let (local tail_32 : Uint256) = u256_add(headStart_30, _1_33)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(value0_31, headStart_30)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_32)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_34 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_35 : Uint256 = Uint256(low=31, high=0)
    let (local _3_36 : Uint256) = u256_add(size, _2_35)
    local range_check_ptr = range_check_ptr
    let (local _4_37 : Uint256) = uint256_and(_3_36, _1_34)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_37)
    local range_check_ptr = range_check_ptr
    let (local _5_38 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_39 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_40 : Uint256) = is_gt(newFreePtr, _6_39)
    local range_check_ptr = range_check_ptr
    let (local _8_41 : Uint256) = uint256_sub(_7_40, _5_38)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_41)
    local _9_42 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_42.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func validator_revert_bool{range_check_ptr}(value_90 : Uint256) -> ():
    alloc_locals
    let (local _1_91 : Uint256) = is_zero(value_90)
    local range_check_ptr = range_check_ptr
    let (local _2_92 : Uint256) = is_zero(_1_91)
    local range_check_ptr = range_check_ptr
    let (local _3_93 : Uint256) = is_eq(value_90, _2_92)
    local range_check_ptr = range_check_ptr
    let (local _4_94 : Uint256) = is_zero(_3_93)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_94)
    return ()
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_1 : Uint256) -> (value_2 : Uint256):
    alloc_locals
    let (local value_2 : Uint256) = mload_(offset_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    validator_revert_bool(value_2)
    local range_check_ptr = range_check_ptr
    return (value_2)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, dataEnd_9 : Uint256) -> (value0_10 : Uint256):
    alloc_locals
    local _1_11 : Uint256 = Uint256(low=32, high=0)
    let (local _2_12 : Uint256) = uint256_sub(dataEnd_9, headStart_8)
    local range_check_ptr = range_check_ptr
    let (local _3_13 : Uint256) = slt(_2_12, _1_11)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_13)
    let (local value0_10 : Uint256) = abi_decode_t_bool_fromMemory(headStart_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_10)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_50 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _17_61 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    finalize_allocation(_6_50, _17_61)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_62 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    let (local _19_63 : Uint256) = u256_add(_6_50, _18_62)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_bool_fromMemory(_6_50, _19_63)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_59 : Uint256, _6_50 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _15_59.low + _15_59.high != 0:
        let (local expr : Uint256) = __warp_block_0(_6_50)
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

func fun_callMe{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(var_add : Uint256) -> (var : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_47 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_48 : Uint256) = uint256_and(var_add, _1_47)
    local range_check_ptr = range_check_ptr
    local _5_49 : Uint256 = Uint256(low=64, high=0)
    let (local _6_50 : Uint256) = mload_(_5_49.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_51 : Uint256) = uint256_shl(
        Uint256(low=227, high=0), Uint256(low=219075091, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_50.low, value=_7_51)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_52 : Uint256 = Uint256(low=32, high=0)
    local _9_53 : Uint256 = Uint256(low=66, high=0)
    local _10_54 : Uint256 = Uint256(low=4, high=0)
    let (local _11_55 : Uint256) = u256_add(_6_50, _10_54)
    local range_check_ptr = range_check_ptr
    let (local _12_56 : Uint256) = abi_encode_tuple_rational_by(_11_55, _9_53)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_57 : Uint256) = uint256_sub(_12_56, _6_50)
    local range_check_ptr = range_check_ptr
    let (local _14_58 : Uint256) = gas()
    local range_check_ptr = range_check_ptr
    let (local _15_59 : Uint256) = warp_static_call(_14_58, _2_48, _6_50, _13_57, _6_50, _8_52)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _16_60 : Uint256) = is_zero(_15_59)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_60)
    local expr : Uint256 = Uint256(low=0, high=0)
    let (local expr : Uint256) = __warp_if_0(_15_59, _6_50, expr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local var : Uint256 = expr
    return (var)
end

@view
func fun_callMe_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_add : Uint256, calldata_size, calldata_len, calldata : felt*) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    with memory_dict, msize, exec_env:
        let (local var : Uint256) = fun_callMe(var_add)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_11)
    let (local _12 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    local _13 : Uint256 = _4
    local _14 : Uint256 = _3
    let (local _15 : Uint256) = abi_decode_tuple_uint8(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _16 : Uint256) = fun_callMeMaybe(_15)
    local range_check_ptr = range_check_ptr
    local _17 : Uint256 = _1
    let (local _18 : Uint256) = abi_encode_bool(_1, _16)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19 : Uint256) = u256_add(_18, _12)
    local range_check_ptr = range_check_ptr
    local _20 : Uint256 = _1
    returndata_write(_1, _19)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> (
        ):
    alloc_locals
    let (local _21 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_21)
    local _22 : Uint256 = _4
    local _23 : Uint256 = _3
    let (local _24 : Uint256) = abi_decode_tuple_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret__warp_mangled : Uint256) = fun_callMe(_24)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _25 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _26 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = uint256_sub(_26, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _27)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_2, _3, _4)
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

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2994440196, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_2, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        __warp_block_5(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1752600728, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_1, _2, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_3(_1, _2, _3, _4, match_var)
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
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_8, _9)
    local range_check_ptr = range_check_ptr
    __warp_block_2(_1, _10, _2, _3, _4)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_1(_1, _2, _3, _4)
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
func fun_ENTRY_POINT{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> (
        success : felt, returndata_size : felt, returndata_len : felt, f0 : felt, f1 : felt,
        f2 : felt, f3 : felt, f4 : felt, f5 : felt, f6 : felt, f7 : felt):
    alloc_locals
    initialize_address{
        syscall_ptr=syscall_ptr,
        storage_ptr=storage_ptr,
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr}(self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
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
    let (local _4 : Uint256) = calldatasize_{range_check_ptr=range_check_ptr, exec_env=exec_env}()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_1(_1, _2, _3, _4, _6)
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

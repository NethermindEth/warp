%lang starknet
%builtins pedersen range_check

from evm.array import array_copy_to_memory, array_create_from_memory
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
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_sub)
from starkware.starknet.common.storage import Storage

@contract_interface
namespace GenericCallInterface:
    func fun_ENTRY_POINT(calldata_size : felt, calldata_len : felt, calldata : felt*) -> (
            success : felt, returndata_len : felt, returndata : felt*):
    end
end

func calculate_data_len{range_check_ptr}(calldata_size) -> (calldata_len):
    let (calldata_len_, rem) = unsigned_div_rem(calldata_size, 8)
    if rem != 0:
        return (calldata_len=calldata_len_ + 1)
    else:
        return (calldata_len=calldata_len_)
    end
end

func warp_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, value : Uint256, in : Uint256, insize : Uint256,
        out : Uint256, outsize : Uint256) -> (success : Uint256):
    alloc_locals
    local memory_dict : DictAccess* = memory_dict

    # TODO will 128 bits be enough for addresses
    let (local mem : felt*) = array_create_from_memory{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr}(in.low, insize.low)
    local memory_dict : DictAccess* = memory_dict
    let (calldata_len_, rem) = unsigned_div_rem(insize.low, 8)
    let (calldata_len) = calculate_data_len(insize.low)
    let (local success, local return_size,
        local return_ : felt*) = GenericCallInterface.fun_ENTRY_POINT(
        address.low, insize.low, calldata_len, mem)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    array_copy_to_memory(return_size, return_, 0, out.low, outsize.low)
    let (returndata_len) = calculate_data_len(insize.low)
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size, calldata_len=exec_env.calldata_len, calldata=exec_env.calldata,
        returndata_size=return_size, returndata_len=returndata_len, returndata=return_
        )
    return (Uint256(success, 0))
end

func warp_static_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, in : Uint256, insize : Uint256, out : Uint256,
        outsize : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0, 0), in, insize, out, outsize)
end

@storage_var
func evm_storage(low : felt, high : felt, part : felt) -> (res : felt):
end

func s_load{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256, value : Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end

func __warp__id(arg : Uint256) -> (res : Uint256):
    return (res=arg)
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

func abi_encode_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_12 : Uint256) -> ():
    alloc_locals
    local _1_13 : Uint256 = Uint256(low=1, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_12.low, value=_1_13)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_rational_by_rational_by_rational_by{
        memory_dict : DictAccess*, msize, range_check_ptr}(headStart_17 : Uint256) -> (
        tail_18 : Uint256):
    alloc_locals
    local _1_19 : Uint256 = Uint256(low=96, high=0)
    let (local tail_18 : Uint256) = u256_add(headStart_17, _1_19)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(headStart_17)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_20 : Uint256 = Uint256(low=32, high=0)
    let (local _3_21 : Uint256) = u256_add(headStart_17, _2_20)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(_3_21)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_22 : Uint256 = Uint256(low=64, high=0)
    let (local _5_23 : Uint256) = u256_add(headStart_17, _4_22)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(_5_23)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_18)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_24 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_25 : Uint256 = Uint256(low=31, high=0)
    let (local _3_26 : Uint256) = u256_add(size, _2_25)
    local range_check_ptr = range_check_ptr
    let (local _4_27 : Uint256) = uint256_and(_3_26, _1_24)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_27)
    local range_check_ptr = range_check_ptr
    let (local _5_28 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_29 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_30 : Uint256) = is_gt(newFreePtr, _6_29)
    local range_check_ptr = range_check_ptr
    let (local _8_31 : Uint256) = uint256_sub(_7_30, _5_28)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_31)
    local _9_32 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_9_32.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func validator_revert_bool{range_check_ptr}(value_63 : Uint256) -> ():
    alloc_locals
    let (local _1_64 : Uint256) = is_zero(value_63)
    local range_check_ptr = range_check_ptr
    let (local _2_65 : Uint256) = is_zero(_1_64)
    local range_check_ptr = range_check_ptr
    let (local _3_66 : Uint256) = is_eq(value_63, _2_65)
    local range_check_ptr = range_check_ptr
    let (local _4_67 : Uint256) = is_zero(_3_66)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_67)
    return ()
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset : Uint256) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    validator_revert_bool(value)
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, dataEnd_5 : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_6 : Uint256 = Uint256(low=32, high=0)
    let (local _2_7 : Uint256) = uint256_sub(dataEnd_5, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_8 : Uint256) = slt(_2_7, _1_6)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_8)
    let (local value0 : Uint256) = abi_decode_t_bool_fromMemory(headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_37 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _17_49 : Uint256) = __warp__id(Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    finalize_allocation(_5_37, _17_49)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18 : Uint256) = __warp__id(Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    let (local _19 : Uint256) = u256_add(_5_37, _18)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_bool_fromMemory(_5_37, _19)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_47 : Uint256, _5_37 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _15_47.low + _15_47.high != 0:
        let (local expr : Uint256) = __warp_block_0(_5_37)
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

func fun_test{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}() -> (var : Uint256):
    alloc_locals
    local _1_33 : Uint256 = Uint256(low=0, high=0)
    let (local _2_34 : Uint256) = __warp__id(Uint256(1, 1))
    local range_check_ptr = range_check_ptr
    let (local _3_35 : Uint256) = is_zero(_2_34)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_35)
    local _4_36 : Uint256 = Uint256(low=64, high=0)
    let (local _5_37 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_36.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _6_38 : Uint256) = uint256_shl(
        Uint256(low=226, high=0), Uint256(low=773435945, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_5_37.low, value=_6_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _7_39 : Uint256 = Uint256(low=32, high=0)
    local _8_40 : Uint256 = Uint256(low=4, high=0)
    let (local _9_41 : Uint256) = u256_add(_5_37, _8_40)
    local range_check_ptr = range_check_ptr
    let (local _10_42 : Uint256) = abi_encode_rational_by_rational_by_rational_by(_9_41)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _11_43 : Uint256) = uint256_sub(_10_42, _5_37)
    local range_check_ptr = range_check_ptr
    local _12_44 : Uint256 = _1_33
    local _13_45 : Uint256 = _1_33
    let (local _14_46 : Uint256) = __warp__id(Uint256(1, 1))
    local range_check_ptr = range_check_ptr
    let (local _15_47 : Uint256) = warp_call{
        syscall_ptr=syscall_ptr,
        storage_ptr=storage_ptr,
        exec_env=exec_env,
        memory_dict=memory_dict,
        range_check_ptr=range_check_ptr}(_14_46, _1_33, _1_33, _5_37, _11_43, _5_37, _7_39)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _16_48 : Uint256) = is_zero(_15_47)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_48)
    local expr : Uint256 = _1_33
    let (local expr : Uint256) = __warp_if_0(_15_47, _5_37, expr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local var : Uint256 = expr
    return (var)
end

@external
func fun_test_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr)
    with memory_dict, msize, exec_env:
        let (local var : Uint256) = fun_test()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> ():
    alloc_locals
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    assert 0 = 1
    jmp rel 0
end

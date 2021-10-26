%lang starknet
%builtins pedersen range_check bitwise

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.calls import calldata_load, calldatasize_, returndata_write, warp_static_call
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_sub)
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

func __warp_cond_revert(_3_3 : Uint256) -> ():
    alloc_locals
    if _3_3.low + _3_3.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=32, high=0)
    let (local _2_2 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, _1_1)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    let (local value0 : Uint256) = calldata_load(headStart.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0)
end

func abi_encode_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_12 : Uint256, pos_13 : Uint256) -> ():
    alloc_locals
    local _1_14 : Uint256 = Uint256(low=255, high=0)
    let (local _2_15 : Uint256) = uint256_and(value_12, _1_14)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_13.low, value=_2_15)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_19 : Uint256, value0_20 : Uint256) -> (tail_21 : Uint256):
    alloc_locals
    local _1_22 : Uint256 = Uint256(low=32, high=0)
    let (local tail_21 : Uint256) = u256_add(headStart_19, _1_22)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(value0_20, headStart_19)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_21)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_23 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_24 : Uint256 = Uint256(low=31, high=0)
    let (local _3_25 : Uint256) = u256_add(size, _2_24)
    local range_check_ptr = range_check_ptr
    let (local _4_26 : Uint256) = uint256_and(_3_25, _1_23)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_26)
    local range_check_ptr = range_check_ptr
    let (local _5_27 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_28 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_29 : Uint256) = is_gt(newFreePtr, _6_28)
    local range_check_ptr = range_check_ptr
    let (local _8_30 : Uint256) = uint256_sub(_7_29, _5_27)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_30)
    local _9_31 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_31.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_4 : Uint256, dataEnd_5 : Uint256) -> (value0_6 : Uint256):
    alloc_locals
    local _1_7 : Uint256 = Uint256(low=32, high=0)
    let (local _2_8 : Uint256) = uint256_sub(dataEnd_5, headStart_4)
    local range_check_ptr = range_check_ptr
    let (local _3_9 : Uint256) = slt(_2_8, _1_7)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_9)
    let (local value0_6 : Uint256) = mload_(headStart_4.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_6)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_33 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _15_44 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    finalize_allocation(_4_33, _15_44)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_45 : Uint256) = __warp_identity_Uint256(
        Uint256(low=exec_env.returndata_size, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_46 : Uint256) = u256_add(_4_33, _16_45)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_bool_fromMemory(_4_33, _17_46)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _13_42 : Uint256, _4_33 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _13_42.low + _13_42.high != 0:
        let (local expr : Uint256) = __warp_block_0(_4_33)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr)
    else:
        return (expr)
    end
end

func fun_callMe{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(var_add : Uint256) -> (var : Uint256):
    alloc_locals
    local _3_32 : Uint256 = Uint256(low=64, high=0)
    let (local _4_33 : Uint256) = mload_(_3_32.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_34 : Uint256) = u256_shl(Uint256(low=227, high=0), Uint256(low=219075091, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_4_33.low, value=_5_34)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_35 : Uint256 = Uint256(low=32, high=0)
    local _7_36 : Uint256 = Uint256(low=66, high=0)
    local _8_37 : Uint256 = Uint256(low=4, high=0)
    let (local _9_38 : Uint256) = u256_add(_4_33, _8_37)
    local range_check_ptr = range_check_ptr
    let (local _10_39 : Uint256) = abi_encode_tuple_rational_by(_9_38, _7_36)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _11_40 : Uint256) = uint256_sub(_10_39, _4_33)
    local range_check_ptr = range_check_ptr
    let (local _12_41 : Uint256) = gas()
    local range_check_ptr = range_check_ptr
    let (local _13_42 : Uint256) = warp_static_call(_12_41, var_add, _4_33, _11_40, _4_33, _6_35)
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _14_43 : Uint256) = is_zero(_13_42)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_14_43)
    local expr : Uint256 = Uint256(low=0, high=0)
    let (local expr : Uint256) = __warp_if_0(_13_42, _4_33, expr)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var : Uint256 = expr
    return (var)
end

@view
func fun_callMe_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(
        var_add : Uint256, calldata_size, calldata_len, calldata : felt*,) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    with memory_dict, msize, exec_env:
        let (local var : Uint256) = fun_callMe(var_add)
    end
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_10 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local _2_11 : Uint256) = is_zero(_1_10)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos.low, value=_2_11)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_16 : Uint256, value0_17 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_16, _1_18)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_17, headStart_16)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> (
        ):
    alloc_locals
    let (local _13 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13)
    local _14 : Uint256 = _4
    local _15 : Uint256 = _3
    let (local _16 : Uint256) = abi_decode_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_callMe(_16)
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _17 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19 : Uint256) = uint256_sub(_18, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _19)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(
        _12 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_2(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> (
        ):
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=2994440196, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_2(_12, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(
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
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*}(
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
        __warp_if_1(_2, _3, _4, _6)
    end
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr

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

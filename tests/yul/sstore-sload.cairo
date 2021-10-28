%lang starknet
%builtins pedersen range_check bitwise

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.calls import calldata_load, calldatasize_, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import mstore_
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add, u256_shr
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not, uint256_sub
from starkware.starknet.common.storage import Storage

func sstore{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        key : Uint256, value : Uint256):
    evm_storage.write(key.low, key.high, value)
    return ()
end

func sload{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(key : Uint256) -> (
        value : Uint256):
    let (res) = evm_storage.read(key.low, key.high)
    return (res)
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func evm_storage(arg0_low, arg0_high) -> (res : Uint256):
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

func fun_test{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}() -> (
        var_res : Uint256):
    alloc_locals
    local _1_6 : Uint256 = Uint256(low=5, high=0)
    local _2_7 : Uint256 = Uint256(low=0, high=0)
    sstore(key=_2_7, value=_1_6)
    local storage_ptr : Storage* = storage_ptr
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local _3_8 : Uint256 = Uint256(low=1, high=0)
    let (local var_res : Uint256) = sload(_3_8)
    local storage_ptr : Storage* = storage_ptr
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return (var_res)
end

@external
func fun_test_external{
        bitwise_ptr : BitwiseBuiltin*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}() -> (var_res : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_res : Uint256) = fun_test()
    end
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_res=var_res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos.low, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_4 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_4, _1_5)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0, headStart_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _13 : Uint256) = __warp_constant_0()
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13)
    local _14 : Uint256 = _4
    local _15 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = fun_test()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _18 : Uint256 = _1
    let (local _19 : Uint256) = abi_encode_uint256(_1, _17)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20 : Uint256) = u256_add(_19, _16)
    local range_check_ptr = range_check_ptr
    local _21 : Uint256 = _1
    returndata_write(_1, _20)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _12 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_1(_1, _3, _4)
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

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=4171824493, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_1, _12, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_1, _3, _4)
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
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(
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
        __warp_if_0(_1, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
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

%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load, calldatacopy_
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_shl, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
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

func fun_callMe{exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        ) -> (var : Uint256):
    alloc_locals
    local var : Uint256 = Uint256(low=0, high=0)
    local _1_8 : Uint256 = Uint256(low=4, high=0)
    local _2_9 : Uint256 = Uint256(low=0, high=0)
    local _3_10 : Uint256 = _2_9
    calldatacopy_(_2_9, _2_9, _1_8)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_11 : Uint256 = _1_8
    local _5_12 : Uint256 = _2_9

    return (var)
end

@external
func fun_callMe_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    with memory_dict, msize, exec_env:
        let (local var : Uint256) = fun_callMe()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

func abi_encode_bytes4{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_4 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=4294967295, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_5 : Uint256) = uint256_and(value, _1_4)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos.low, value=_2_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_bytes4{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_6 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_7 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_6, _1_7)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes4(value0, headStart_6)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _13 : Uint256 = _4
    local _14 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_callMe()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _15 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = abi_encode_tuple_bytes4(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = uint256_sub(_16, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_1(_2, _3, _4)
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

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=2965284645, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_12, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_2, _3, _4)
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
        __warp_if_0(_2, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

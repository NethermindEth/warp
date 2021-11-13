%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mstore
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_sub

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
end

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

func __warp_cond_revert(_3_7 : Uint256) -> ():
    alloc_locals
    if _3_7.low + _3_7.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=0, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_7)
    return ()
end

func fun_test{exec_env : ExecutionEnvironment*, range_check_ptr}() -> (var_res : Uint256):
    alloc_locals
    let (local var_res : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    local _1_12 : Uint256 = Uint256(low=0, high=0)
    let (local _2_13 : Uint256) = calldataload(_1_12)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    __warp_cond_revert(_2_13)
    return (var_res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_9 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_8, _1_9)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0, headStart_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _13 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_13)
    local _14 : Uint256 = _4
    local _15 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = fun_test()
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    local _18 : Uint256 = _1
    let (local _19 : Uint256) = abi_encode_uint256(_1, _17)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20 : Uint256) = u256_add(_19, _16)
    local range_check_ptr = range_check_ptr
    local _21 : Uint256 = _1
    returndata_write(_1, _20)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _12 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_1(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldataload(_7)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=4171824493, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_1, _12, _3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_1, _3, _4)
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
        __warp_if_0(_1, _3, _4, _6)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end


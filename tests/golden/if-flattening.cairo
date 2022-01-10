%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_sub

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

func sload{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(key : Uint256) -> (
        value : Uint256):
    let (value) = evm_storage.read(key)
    return (value)
end

func sstore{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key : Uint256, value : Uint256):
    evm_storage.write(key, value)
    return ()
end

@storage_var
func evm_storage(arg0 : Uint256) -> (res : Uint256):
end

@constructor
func constructor{range_check_ptr}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    validate_array(calldata_size, calldata_len, calldata)
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with memory_dict, msize:
        __constructor_meat()
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

@external
func __main{
        bitwise_ptr : BitwiseBuiltin*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(calldata_size, calldata_len, calldata : felt*) -> (
        returndata_size, returndata_len, returndata : felt*):
    alloc_locals
    validate_array(calldata_size, calldata_len, calldata)
    let (__fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=cast(0, felt*), to_returndata_size=0, to_returndata_len=0, to_returndata=cast(0, felt*))
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    let termination_token = 0
    with exec_env, memory_dict, msize, termination_token:
        __main_meat()
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

func __constructor_meat{memory_dict : DictAccess*, msize, range_check_ptr}() -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_2{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_src)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (_1 : Uint256) = sload(dataSlot)
    let (__warp_subexpr_0 : Uint256) = is_lt(_1, var_wad)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_1 : Uint256) = uint256_sub(_1, var_wad)
    sstore(key=dataSlot, value=__warp_subexpr_1)
    let var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

func __warp_if_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var_res : Uint256 = Uint256(low=2, high=0)
        return (var_res)
    else:
        let (var_res : Uint256) = __warp_block_2(var_src, var_wad)
        return (var_res)
    end
end

func __warp_block_1{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        match_var : Uint256, var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_res : Uint256) = __warp_if_0(__warp_subexpr_0, var_src, var_wad)
    return (var_res)
end

func __warp_block_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_src, var_sender)
    let (match_var : Uint256) = is_zero(__warp_subexpr_0)
    let (var_res : Uint256) = __warp_block_1(match_var, var_src, var_wad)
    return (var_res)
end

func fun_transferFrom{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    let (var_res : Uint256) = __warp_block_0(var_sender, var_src, var_wad)
    let var : Uint256 = var_res
    return (var)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=headStart, value=value0)
    return (tail)
end

func __warp_block_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = calldataload(Uint256(low=4, high=0))
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_3)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    let (__warp_subexpr_5 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_4 : Uint256) = sload(__warp_subexpr_5)
    uint256_mstore(offset=Uint256(low=128, high=0), value=__warp_subexpr_4)
    warp_return(Uint256(low=128, high=0), Uint256(low=32, high=0))
    return ()
end

func __warp_block_8{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=96, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_5 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_4 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (__warp_subexpr_3 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (ret__warp_mangled : Uint256) = fun_transferFrom(
        __warp_subexpr_3, __warp_subexpr_4, __warp_subexpr_5)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_7 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    let (__warp_subexpr_6 : Uint256) = uint256_sub(__warp_subexpr_7, memPos)
    warp_return(memPos, __warp_subexpr_6)
    return ()
end

func __warp_if_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8()
        return ()
    else:
        return ()
    end
end

func __warp_block_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=823056368, high=0))
    __warp_if_1(__warp_subexpr_0)
    return ()
end

func __warp_if_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6()
        return ()
    else:
        __warp_block_7(match_var)
        return ()
    end
end

func __warp_block_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=776198108, high=0))
    __warp_if_2(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_5(match_var)
    return ()
end

func __warp_block_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    __warp_block_4()
    return ()
end

func __warp_if_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        return ()
    else:
        return ()
    end
end

func __main_meat{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    __warp_if_3(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    assert 0 = 1
    jmp rel 0
end

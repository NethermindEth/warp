%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldatacopy, calldataload, calldatasize, caller, returndata_copy
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import delegatecall, warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_sub

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

func sstore{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key : Uint256, value : Uint256):
    evm_storage.write(key, value)
    return ()
end

func sload{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(key : Uint256) -> (
        value : Uint256):
    let (value) = evm_storage.read(key)
    return (value)
end

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
end

func __warp_constant_10000000000000000000000000000000000000000() -> (res : Uint256):
    return (Uint256(low=131811359292784559562136384478721867776, high=29))
end

@storage_var
func evm_storage(arg0 : Uint256) -> (res : Uint256):
end

@constructor
func constructor{
        bitwise_ptr : BitwiseBuiltin*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    validate_array(calldata_size, calldata_len, calldata)
    let (__fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=cast(0, felt*), to_returndata_size=0, to_returndata_len=0, to_returndata=cast(0, felt*))
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with exec_env, memory_dict, msize:
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

func __constructor_meat{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = slt(__warp_subexpr_2, Uint256(low=32, high=0))
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = caller()
    sstore(key=Uint256(low=0, high=0), value=__warp_subexpr_3)
    let (__warp_subexpr_4 : Uint256) = calldataload(Uint256(low=0, high=0))
    sstore(key=Uint256(low=1, high=0), value=__warp_subexpr_4)
    return ()
end

func __warp_block_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = sload(Uint256(low=0, high=0))
    uint256_mstore(offset=Uint256(low=128, high=0), value=__warp_subexpr_3)
    warp_return(Uint256(low=128, high=0), Uint256(low=32, high=0))
    return ()
end

func __warp_block_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (ret__warp_mangled : Uint256) = sload(Uint256(low=1, high=0))
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=memPos, value=ret__warp_mangled)
    warp_return(memPos, Uint256(low=32, high=0))
    return ()
end

func __warp_if_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2457866800, high=0))
    __warp_if_2(__warp_subexpr_0)
    return ()
end

func __warp_if_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        return ()
    else:
        __warp_block_4(match_var)
        return ()
    end
end

func __warp_block_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
    __warp_if_1(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_2(match_var)
    return ()
end

func __warp_block_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    __warp_block_1()
    return ()
end

func __warp_if_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0()
        return ()
    else:
        return ()
    end
end

func __warp_block_8{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}() -> ():
    alloc_locals
    let (_6 : Uint256) = returndata_size()
    let _7 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (__warp_subexpr_0 : Uint256) = is_gt(_6, _7)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let _8 : Uint256 = Uint256(
        low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455)
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_4 : Uint256) = u256_add(_6, Uint256(low=31, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_and(__warp_subexpr_4, _8)
    let (__warp_subexpr_2 : Uint256) = u256_add(__warp_subexpr_3, Uint256(low=63, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_and(__warp_subexpr_2, _8)
    let (newFreePtr : Uint256) = u256_add(memPtr, __warp_subexpr_1)
    let (__warp_subexpr_7 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_6 : Uint256) = is_gt(newFreePtr, _7)
    let (__warp_subexpr_5 : Uint256) = uint256_sub(__warp_subexpr_6, __warp_subexpr_7)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    uint256_mstore(offset=memPtr, value=_6)
    let (__warp_subexpr_9 : Uint256) = returndata_size()
    let (__warp_subexpr_8 : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    returndata_copy(__warp_subexpr_8, Uint256(low=0, high=0), __warp_subexpr_9)
    return ()
end

func __warp_if_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return ()
    else:
        __warp_block_8()
        return ()
    end
end

func __warp_block_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    __warp_if_3(__warp_subexpr_0)
    return ()
end

func __warp_block_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}() -> ():
    alloc_locals
    let (match_var : Uint256) = returndata_size()
    __warp_block_7(match_var)
    return ()
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
    __warp_if_0(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    let (_2 : Uint256) = sload(Uint256(low=1, high=0))
    let (_3 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = calldatasize()
    calldatacopy(_3, Uint256(low=0, high=0), __warp_subexpr_3)
    let (__warp_subexpr_4 : Uint256) = calldatasize()
    let (_5 : Uint256) = u256_add(_3, __warp_subexpr_4)
    uint256_mstore(offset=_5, value=Uint256(low=0, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_sub(_5, _3)
    let (__warp_subexpr_6 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_5 : Uint256) = delegatecall(
        __warp_subexpr_6, _2, _3, __warp_subexpr_7, Uint256(low=0, high=0), Uint256(low=0, high=0))

    __warp_block_6()
    warp_return(Uint256(low=0, high=0), Uint256(low=0, high=0))
    return ()
end

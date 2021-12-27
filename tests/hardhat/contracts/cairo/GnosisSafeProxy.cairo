%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldatacopy, calldataload, calldatasize, returndata_copy
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mstore
from evm.uint256 import is_eq, is_zero, slt
from evm.yul_api import delegatecall, warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and

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

func __warp_constant_10000000000000000000000000000000000000000() -> (res : Uint256):
    return (Uint256(low=131811359292784559562136384478721867776, high=29))
end

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
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
    let (value : Uint256) = calldataload(Uint256(low=0, high=0))
    let (__warp_subexpr_3 : Uint256) = is_zero(value)
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    sstore(key=Uint256(low=0, high=0), value=value)
    return ()
end

func __warp_if_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(
        __warp_subexpr_1 : Uint256, usr_singleton : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        uint256_mstore(offset=Uint256(low=0, high=0), value=usr_singleton)
        warp_return(Uint256(low=0, high=0), Uint256(low=32, high=0))
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
    let (__warp_subexpr_0 : Uint256) = sload(Uint256(low=0, high=0))
    let (usr_singleton : Uint256) = uint256_and(
        __warp_subexpr_0, Uint256(low=340282366920938463463374607431768211455, high=4294967295))
    let (__warp_subexpr_2 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (__warp_subexpr_1 : Uint256) = is_eq(
        __warp_subexpr_2, Uint256(low=0, high=220783123770348745082092893906694832128))
    __warp_if_0(__warp_subexpr_1, usr_singleton)
    if termination_token == 1:
        return ()
    end
    let (__warp_subexpr_3 : Uint256) = calldatasize()
    calldatacopy(Uint256(low=0, high=0), Uint256(low=0, high=0), __warp_subexpr_3)
    let (__warp_subexpr_5 : Uint256) = calldatasize()
    let (__warp_subexpr_4 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (usr_success : Uint256) = delegatecall(
        __warp_subexpr_4,
        usr_singleton,
        Uint256(low=0, high=0),
        __warp_subexpr_5,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    let (__warp_subexpr_6 : Uint256) = returndata_size()
    returndata_copy(Uint256(low=0, high=0), Uint256(low=0, high=0), __warp_subexpr_6)
    let (__warp_subexpr_7 : Uint256) = is_zero(usr_success)
    if __warp_subexpr_7.low + __warp_subexpr_7.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_8 : Uint256) = returndata_size()
    warp_return(Uint256(low=0, high=0), __warp_subexpr_8)
    return ()
end

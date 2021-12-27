%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldatacopy, calldataload, calldatasize, caller, returndata_copy
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen, uint256_sha
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import (
    is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_div, u256_mul, u256_shl, u256_shr)
from evm.yul_api import address, delegatecall, staticcall, warp_call, warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_not, uint256_sub

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

func __warp_constant_1() -> (res : Uint256):
    return (Uint256(low=1, high=0))
end

func __warp_constant_10() -> (res : Uint256):
    return (Uint256(low=10, high=0))
end

@storage_var
func evm_storage(arg0 : Uint256) -> (res : Uint256):
end

@constructor
func constructor{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*):
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

func __constructor_meat{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    sstore(key=Uint256(low=4, high=0), value=Uint256(low=1, high=0))
    return ()
end

func abi_decode_addresst_uint256{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    return (value0, value1)
end

func fun_requireSelfCall{range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = address()
    let (__warp_subexpr_2 : Uint256) = caller()
    let (__warp_subexpr_1 : Uint256) = is_eq(__warp_subexpr_2, __warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral_3d41{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral_bd32{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func increment_uint256{range_check_ptr}(value : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(
        value,
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (ret__warp_mangled : Uint256) = u256_add(value, Uint256(low=1, high=0))
    return (ret__warp_mangled)
end

func require_helper_stringliteral_2ed3{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral_a5f8{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func modifier_authorized_742{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_threshold : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_2 : Uint256) = sload(Uint256(low=3, high=0))
    let (__warp_subexpr_1 : Uint256) = is_gt(var_threshold, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    require_helper_stringliteral_2ed3(__warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = is_lt(var_threshold, Uint256(low=1, high=0))
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    require_helper_stringliteral_a5f8(__warp_subexpr_3)
    sstore(key=Uint256(low=4, high=0), value=var_threshold)
    return ()
end

func __warp_block_0{range_check_ptr}(var_owner : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_owner, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_0{range_check_ptr}(expr : Uint256, var_owner : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_0(var_owner)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_1{range_check_ptr, syscall_ptr : felt*}(var_owner : Uint256) -> (
        expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = address()
    let (__warp_subexpr_0 : Uint256) = is_eq(var_owner, __warp_subexpr_1)
    let (expr_1 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_1)
end

func __warp_if_1{range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, expr_1 : Uint256, var_owner : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr_1 : Uint256) = __warp_block_1(var_owner)
        return (expr_1)
    else:
        return (expr_1)
    end
end

func __warp_if_2{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_10 : Uint256, var__threshold : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_10.low + __warp_subexpr_10.high != 0:
        modifier_authorized_742(var__threshold)
        return ()
    else:
        return ()
    end
end

func modifier_authorized_513{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_owner : Uint256, var__threshold : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_0 : Uint256) = is_zero(var_owner)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_0(expr, var_owner)
    let expr_1 : Uint256 = expr
    let (expr_1 : Uint256) = __warp_if_1(expr, expr_1, var_owner)
    require_helper_stringliteral_3d41(expr_1)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_owner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    require_helper_stringliteral_bd32(__warp_subexpr_1)
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_6 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_5 : Uint256) = sload(__warp_subexpr_6)
    let (
        __warp_subexpr_4 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_owner)
    sstore(key=__warp_subexpr_4, value=__warp_subexpr_5)
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    sstore(key=__warp_subexpr_7, value=var_owner)
    let (__warp_subexpr_9 : Uint256) = sload(Uint256(low=3, high=0))
    let (__warp_subexpr_8 : Uint256) = increment_uint256(__warp_subexpr_9)
    sstore(key=Uint256(low=3, high=0), value=__warp_subexpr_8)
    let (__warp_subexpr_12 : Uint256) = sload(Uint256(low=4, high=0))
    let (__warp_subexpr_11 : Uint256) = is_eq(__warp_subexpr_12, var__threshold)
    let (__warp_subexpr_10 : Uint256) = is_zero(__warp_subexpr_11)
    __warp_if_2(__warp_subexpr_10, var__threshold)
    return ()
end

func array_allocation_size_bytes{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        length : Uint256) -> (size : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(length, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_2 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_and(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (size : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    return (size)
end

func finalize_allocation{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(size, Uint256(low=31, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_and(
        __warp_subexpr_1,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (newFreePtr : Uint256) = u256_add(memPtr, __warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_3 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, __warp_subexpr_4)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func abi_decode_available_length_bytes{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(src : Uint256, length : Uint256, end__warp_mangled : Uint256) -> (
        array : Uint256):
    alloc_locals
    let (_1 : Uint256) = array_allocation_size_bytes(length)
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr, _1)
    let array : Uint256 = memPtr
    uint256_mstore(offset=memPtr, value=length)
    let (__warp_subexpr_1 : Uint256) = u256_add(src, length)
    let (__warp_subexpr_0 : Uint256) = is_gt(__warp_subexpr_1, end__warp_mangled)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_2 : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    calldatacopy(__warp_subexpr_2, src, length)
    let (__warp_subexpr_4 : Uint256) = u256_add(memPtr, length)
    let (__warp_subexpr_3 : Uint256) = u256_add(__warp_subexpr_4, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_3, value=Uint256(low=0, high=0))
    return (array)
end

func abi_decode_bytes{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(offset : Uint256, end__warp_mangled : Uint256) -> (array : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = u256_add(offset, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = slt(__warp_subexpr_2, end__warp_mangled)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_4 : Uint256) = calldataload(offset)
    let (__warp_subexpr_3 : Uint256) = u256_add(offset, Uint256(low=32, high=0))
    let (array : Uint256) = abi_decode_available_length_bytes(
        __warp_subexpr_3, __warp_subexpr_4, end__warp_mangled)
    return (array)
end

func abi_decode_bytes32t_bytest_bytest_uint256{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=36, high=0))
    let _1 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, _1)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value1 : Uint256) = abi_decode_bytes(__warp_subexpr_3, dataEnd)
    let (offset_1 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_4 : Uint256) = is_gt(offset_1, _1)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_5 : Uint256) = u256_add(Uint256(low=4, high=0), offset_1)
    let (value2 : Uint256) = abi_decode_bytes(__warp_subexpr_5, dataEnd)
    let (value3 : Uint256) = calldataload(Uint256(low=100, high=0))
    return (value0, value1, value2, value3)
end

func checked_div_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (r : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(y)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (r : Uint256) = u256_div(x, y)
    return (r)
end

func fun_mul_11039{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(var_a : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_a)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var : Uint256 = Uint256(low=0, high=0)
        return (var)
    end
    let (__warp_subexpr_3 : Uint256) = u256_div(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        var_a)
    let (__warp_subexpr_2 : Uint256) = is_gt(Uint256(low=65, high=0), __warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = uint256_and(Uint256(low=1, high=0), __warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (product : Uint256) = u256_mul(var_a, Uint256(low=65, high=0))
    let (__warp_subexpr_6 : Uint256) = checked_div_uint256(product, var_a)
    let (__warp_subexpr_5 : Uint256) = is_eq(__warp_subexpr_6, Uint256(low=65, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var : Uint256 = product
    return (var)
end

func require_helper_stringliteral_f27d{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func fun_signatureSplit{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_signatures_mpos : Uint256, var_pos : Uint256) -> (
        var_v : Uint256, var_r : Uint256, var_s : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = u256_mul(Uint256(low=65, high=0), var_pos)
    let (_1 : Uint256) = u256_add(var_signatures_mpos, __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, Uint256(low=32, high=0))
    let (var_r : Uint256) = uint256_mload(__warp_subexpr_1)
    let (__warp_subexpr_2 : Uint256) = u256_add(_1, Uint256(low=64, high=0))
    let (var_s : Uint256) = uint256_mload(__warp_subexpr_2)
    let (__warp_subexpr_4 : Uint256) = u256_add(_1, Uint256(low=65, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_mload(__warp_subexpr_4)
    let (var_v : Uint256) = uint256_and(__warp_subexpr_3, Uint256(low=255, high=0))
    return (var_v, var_r, var_s)
end

func abi_encode_bytes32_uint8_bytes32_bytes32{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256, value2 : Uint256,
        value3 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=128, high=0))
    uint256_mstore(offset=headStart, value=value0)
    let (__warp_subexpr_1 : Uint256) = uint256_and(value1, Uint256(low=255, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=value2)
    let (__warp_subexpr_3 : Uint256) = u256_add(headStart, Uint256(low=96, high=0))
    uint256_mstore(offset=__warp_subexpr_3, value=value3)
    return (tail)
end

func abi_encode_packed_stringliteral_178a_bytes32{
        memory_dict : DictAccess*, msize, range_check_ptr}(pos : Uint256, value0 : Uint256) -> (
        end__warp_mangled : Uint256):
    alloc_locals
    uint256_mstore(
        offset=pos,
        value=Uint256(low=42937160393541677824438716521481502720, high=33591329408501007666763191150309172580))
    let (__warp_subexpr_0 : Uint256) = u256_add(pos, Uint256(low=28, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=value0)
    let (end__warp_mangled : Uint256) = u256_add(pos, Uint256(low=60, high=0))
    return (end__warp_mangled)
end

func checked_sub_uint8{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(x : Uint256) -> (
        diff : Uint256):
    alloc_locals
    let (x_1 : Uint256) = uint256_and(x, Uint256(low=255, high=0))
    let (__warp_subexpr_0 : Uint256) = is_lt(x_1, Uint256(low=4, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (diff : Uint256) = u256_add(
        x_1,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    return (diff)
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32_11041{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=8, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}(slot : Uint256, key : Uint256) -> (
        dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=slot)
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func require_helper_stringliteral_bc24{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral_d153{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func fun_add_11043{range_check_ptr}(var_a : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        var_a,
        Uint256(low=340282366920938463463374607431768211423, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(var_a, Uint256(low=32, high=0))
    let (__warp_subexpr_1 : Uint256) = is_lt(sum, var_a)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var : Uint256 = sum
    return (var)
end

func require_helper_stringliteral_3724{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func fun_add{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_not(var_b)
    let (__warp_subexpr_0 : Uint256) = is_gt(var_a, __warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(var_a, var_b)
    let (__warp_subexpr_2 : Uint256) = is_lt(sum, var_a)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var : Uint256 = sum
    return (var)
end

func require_helper_stringliteral_00ae{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_loop_body_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        i : Uint256, pos : Uint256, value : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_4 : Uint256) = u256_add(value, i)
    let (__warp_subexpr_3 : Uint256) = u256_add(__warp_subexpr_4, Uint256(low=32, high=0))
    let (__warp_subexpr_2 : Uint256) = u256_add(pos, i)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(__warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_2, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    let (i : Uint256) = u256_add(i, Uint256(low=32, high=0))
    return (i)
end

func __warp_loop_0{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        i : Uint256, length : Uint256, pos : Uint256, value : Uint256) -> (i : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i)
    end
    let (i : Uint256) = __warp_loop_body_0(i, pos, value)
    let (i : Uint256) = __warp_loop_0(i, length, pos, value)
    return (i)
end

func __warp_block_2{memory_dict : DictAccess*, msize, range_check_ptr}(
        length : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(pos, length)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low=0, high=0))
    return ()
end

func __warp_if_3{memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, length : Uint256, pos : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_2(length, pos)
        return ()
    else:
        return ()
    end
end

func abi_encode_bytes_memory_ptr{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (length : Uint256) = uint256_mload(value)
    uint256_mstore(offset=pos, value=length)
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256) = __warp_loop_0(i, length, pos, value)
    let (__warp_subexpr_0 : Uint256) = is_gt(i, length)
    __warp_if_3(__warp_subexpr_0, length, pos)
    let (__warp_subexpr_3 : Uint256) = u256_add(length, Uint256(low=31, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_and(
        __warp_subexpr_3,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_1 : Uint256) = u256_add(pos, __warp_subexpr_2)
    let (end__warp_mangled : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    return (end__warp_mangled)
end

func abi_encode_bytes_bytes{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=64, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    let (tail_1 : Uint256) = abi_encode_bytes_memory_ptr(value0, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(tail_1, headStart)
    let (__warp_subexpr_1 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=__warp_subexpr_2)
    let (tail : Uint256) = abi_encode_bytes_memory_ptr(value1, tail_1)
    return (tail)
end

func abi_decode_bytes4_fromMemory{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value : Uint256) = uint256_mload(headStart)
    let (__warp_subexpr_4 : Uint256) = uint256_and(
        value, Uint256(low=0, high=340282366841710300949110269838224261120))
    let (__warp_subexpr_3 : Uint256) = is_eq(value, __warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value0 : Uint256 = value
    return (value0)
end

func require_helper_stringliteral_1d9d{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_9{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_2 : Uint256) = abi_encode_bytes32_uint8_bytes32_bytes32(
        _1, var_dataHash, expr_component, expr_component_1, expr_component_2)
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=0, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_sub(_2, _1)
    let (__warp_subexpr_2 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_1 : Uint256) = staticcall(
        __warp_subexpr_2,
        Uint256(low=1, high=0),
        _1,
        __warp_subexpr_3,
        Uint256(low=0, high=0),
        Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var_currentOwner : Uint256) = uint256_mload(Uint256(low=0, high=0))
    return (var_currentOwner)
end

func __warp_block_10{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (expr_1810_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_1 : Uint256) = u256_add(expr_1810_mpos, Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = abi_encode_packed_stringliteral_178a_bytes32(
        __warp_subexpr_1, var_dataHash)
    let (_3 : Uint256) = uint256_sub(__warp_subexpr_0, expr_1810_mpos)
    let (__warp_subexpr_2 : Uint256) = u256_add(
        _3,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    uint256_mstore(offset=expr_1810_mpos, value=__warp_subexpr_2)
    finalize_allocation(expr_1810_mpos, _3)
    let (__warp_subexpr_4 : Uint256) = uint256_mload(expr_1810_mpos)
    let (__warp_subexpr_3 : Uint256) = u256_add(expr_1810_mpos, Uint256(low=32, high=0))
    let (expr_1 : Uint256) = uint256_sha(__warp_subexpr_3, __warp_subexpr_4)
    let (expr_2 : Uint256) = checked_sub_uint8(expr_component)
    let (_4 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_5 : Uint256) = abi_encode_bytes32_uint8_bytes32_bytes32(
        _4, expr_1, expr_2, expr_component_1, expr_component_2)
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=0, high=0))
    let (__warp_subexpr_8 : Uint256) = uint256_sub(_5, _4)
    let (__warp_subexpr_7 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_6 : Uint256) = staticcall(
        __warp_subexpr_7,
        Uint256(low=1, high=0),
        _4,
        __warp_subexpr_8,
        Uint256(low=0, high=0),
        Uint256(low=32, high=0))
    let (__warp_subexpr_5 : Uint256) = is_zero(__warp_subexpr_6)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var_currentOwner : Uint256) = uint256_mload(Uint256(low=0, high=0))
    return (var_currentOwner)
end

func __warp_if_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, expr_component : Uint256, expr_component_1 : Uint256,
        expr_component_2 : Uint256, var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_currentOwner : Uint256) = __warp_block_9(
            expr_component, expr_component_1, expr_component_2, var_dataHash)
        return (var_currentOwner)
    else:
        let (var_currentOwner : Uint256) = __warp_block_10(
            expr_component, expr_component_1, expr_component_2, var_dataHash)
        return (var_currentOwner)
    end
end

func __warp_block_8{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        match_var : Uint256, var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_currentOwner : Uint256) = __warp_if_6(
        __warp_subexpr_0, expr_component, expr_component_1, expr_component_2, var_dataHash)
    return (var_currentOwner)
end

func __warp_block_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_and(expr_component, Uint256(low=255, high=0))
    let (match_var : Uint256) = is_gt(__warp_subexpr_0, Uint256(low=30, high=0))
    let (var_currentOwner : Uint256) = __warp_block_8(
        expr_component, expr_component_1, expr_component_2, match_var, var_dataHash)
    return (var_currentOwner)
end

func __warp_block_12{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component_1 : Uint256, var_dataHash : Uint256) -> (expr_3 : Uint256):
    alloc_locals
    let (
        __warp_subexpr_3 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_11041(
        expr_component_1)
    let (__warp_subexpr_2 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32(
        __warp_subexpr_3, var_dataHash)
    let (__warp_subexpr_1 : Uint256) = sload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    let (expr_3 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_3)
end

func __warp_if_7{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_1 : Uint256, expr_3 : Uint256, expr_component_1 : Uint256,
        var_dataHash : Uint256) -> (expr_3 : Uint256):
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        let (expr_3 : Uint256) = __warp_block_12(expr_component_1, var_dataHash)
        return (expr_3)
    else:
        return (expr_3)
    end
end

func __warp_block_11{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component_1 : Uint256, var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let var_currentOwner : Uint256 = expr_component_1
    let (__warp_subexpr_0 : Uint256) = caller()
    let (expr_3 : Uint256) = is_eq(__warp_subexpr_0, expr_component_1)
    let (__warp_subexpr_1 : Uint256) = is_zero(expr_3)
    let (expr_3 : Uint256) = __warp_if_7(__warp_subexpr_1, expr_3, expr_component_1, var_dataHash)
    require_helper_stringliteral_bc24(expr_3)
    return (var_currentOwner)
end

func __warp_if_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, expr_component : Uint256, expr_component_1 : Uint256,
        expr_component_2 : Uint256, var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_currentOwner : Uint256) = __warp_block_7(
            expr_component, expr_component_1, expr_component_2, var_dataHash)
        return (var_currentOwner)
    else:
        let (var_currentOwner : Uint256) = __warp_block_11(expr_component_1, var_dataHash)
        return (var_currentOwner)
    end
end

func __warp_block_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        match_var : Uint256, var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_currentOwner : Uint256) = __warp_if_5(
        __warp_subexpr_0, expr_component, expr_component_1, expr_component_2, var_dataHash)
    return (var_currentOwner)
end

func __warp_block_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        var_dataHash : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_and(expr_component, Uint256(low=255, high=0))
    let (match_var : Uint256) = is_eq(__warp_subexpr_0, Uint256(low=1, high=0))
    let (var_currentOwner : Uint256) = __warp_block_6(
        expr_component, expr_component_1, expr_component_2, match_var, var_dataHash)
    return (var_currentOwner)
end

func __warp_block_14{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_6 : Uint256) -> (expr_6 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_6, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_6, __warp_subexpr_2)
    let (expr_6 : Uint256) = abi_decode_bytes4_fromMemory(_6, __warp_subexpr_1)
    return (expr_6)
end

func __warp_if_8{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_6 : Uint256, _7 : Uint256, expr_6 : Uint256) -> (expr_6 : Uint256):
    alloc_locals
    if _7.low + _7.high != 0:
        let (expr_6 : Uint256) = __warp_block_14(_6)
        return (expr_6)
    else:
        return (expr_6)
    end
end

func __warp_block_13{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_component_1 : Uint256, expr_component_2 : Uint256, var_data_1631_mpos : Uint256,
        var_requiredSignatures : Uint256, var_signatures_1633_mpos : Uint256) -> (
        var_currentOwner : Uint256):
    alloc_locals
    let var_currentOwner : Uint256 = expr_component_1
    let (__warp_subexpr_2 : Uint256) = fun_mul_11039(var_requiredSignatures)
    let (__warp_subexpr_1 : Uint256) = is_lt(expr_component_2, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    require_helper_stringliteral_d153(__warp_subexpr_0)
    let (expr_4 : Uint256) = fun_add_11043(expr_component_2)
    let (__warp_subexpr_5 : Uint256) = uint256_mload(var_signatures_1633_mpos)
    let (__warp_subexpr_4 : Uint256) = is_gt(expr_4, __warp_subexpr_5)
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    require_helper_stringliteral_3724(__warp_subexpr_3)
    let (__warp_subexpr_9 : Uint256) = u256_add(var_signatures_1633_mpos, expr_component_2)
    let (__warp_subexpr_8 : Uint256) = u256_add(__warp_subexpr_9, Uint256(low=32, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_mload(__warp_subexpr_8)
    let (__warp_subexpr_6 : Uint256) = fun_add_11043(expr_component_2)
    let (expr_5 : Uint256) = fun_add(__warp_subexpr_6, __warp_subexpr_7)
    let (__warp_subexpr_12 : Uint256) = uint256_mload(var_signatures_1633_mpos)
    let (__warp_subexpr_11 : Uint256) = is_gt(expr_5, __warp_subexpr_12)
    let (__warp_subexpr_10 : Uint256) = is_zero(__warp_subexpr_11)
    require_helper_stringliteral_00ae(__warp_subexpr_10)
    let (_6 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_6, value=Uint256(low=0, high=43538606692490932770690938137319833600))
    let (__warp_subexpr_18 : Uint256) = u256_add(var_signatures_1633_mpos, expr_component_2)
    let (__warp_subexpr_17 : Uint256) = u256_add(__warp_subexpr_18, Uint256(low=32, high=0))
    let (__warp_subexpr_16 : Uint256) = u256_add(_6, Uint256(low=4, high=0))
    let (__warp_subexpr_15 : Uint256) = abi_encode_bytes_bytes(
        __warp_subexpr_16, var_data_1631_mpos, __warp_subexpr_17)
    let (__warp_subexpr_14 : Uint256) = uint256_sub(__warp_subexpr_15, _6)
    let (__warp_subexpr_13 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_7 : Uint256) = staticcall(
        __warp_subexpr_13, expr_component_1, _6, __warp_subexpr_14, _6, Uint256(low=32, high=0))
    let (__warp_subexpr_19 : Uint256) = is_zero(_7)
    if __warp_subexpr_19.low + __warp_subexpr_19.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr_6 : Uint256 = Uint256(low=0, high=0)
    let (expr_6 : Uint256) = __warp_if_8(_6, _7, expr_6)
    let (__warp_subexpr_21 : Uint256) = uint256_and(
        expr_6, Uint256(low=0, high=340282366841710300949110269838224261120))
    let (__warp_subexpr_20 : Uint256) = is_eq(
        __warp_subexpr_21, Uint256(low=0, high=43538606692490932770690938137319833600))
    require_helper_stringliteral_1d9d(__warp_subexpr_20)
    return (var_currentOwner)
end

func __warp_if_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, expr_component : Uint256, expr_component_1 : Uint256,
        expr_component_2 : Uint256, var_dataHash : Uint256, var_data_1631_mpos : Uint256,
        var_requiredSignatures : Uint256, var_signatures_1633_mpos : Uint256) -> (
        var_currentOwner : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_currentOwner : Uint256) = __warp_block_5(
            expr_component, expr_component_1, expr_component_2, var_dataHash)
        return (var_currentOwner)
    else:
        let (var_currentOwner : Uint256) = __warp_block_13(
            expr_component_1,
            expr_component_2,
            var_data_1631_mpos,
            var_requiredSignatures,
            var_signatures_1633_mpos)
        return (var_currentOwner)
    end
end

func __warp_block_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        match_var : Uint256, var_dataHash : Uint256, var_data_1631_mpos : Uint256,
        var_requiredSignatures : Uint256, var_signatures_1633_mpos : Uint256) -> (
        var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_currentOwner : Uint256) = __warp_if_4(
        __warp_subexpr_0,
        expr_component,
        expr_component_1,
        expr_component_2,
        var_dataHash,
        var_data_1631_mpos,
        var_requiredSignatures,
        var_signatures_1633_mpos)
    return (var_currentOwner)
end

func __warp_block_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_component : Uint256, expr_component_1 : Uint256, expr_component_2 : Uint256,
        var_dataHash : Uint256, var_data_1631_mpos : Uint256, var_requiredSignatures : Uint256,
        var_signatures_1633_mpos : Uint256) -> (var_currentOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_and(expr_component, Uint256(low=255, high=0))
    let (match_var : Uint256) = is_zero(__warp_subexpr_0)
    let (var_currentOwner : Uint256) = __warp_block_4(
        expr_component,
        expr_component_1,
        expr_component_2,
        match_var,
        var_dataHash,
        var_data_1631_mpos,
        var_requiredSignatures,
        var_signatures_1633_mpos)
    return (var_currentOwner)
end

func __warp_block_15{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_currentOwner : Uint256) -> (expr_7 : Uint256):
    alloc_locals
    let (
        __warp_subexpr_2 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_currentOwner)
    let (__warp_subexpr_1 : Uint256) = sload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    let (expr_7 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_7)
end

func __warp_if_9{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr_7 : Uint256, var_currentOwner : Uint256) -> (expr_7 : Uint256):
    alloc_locals
    if expr_7.low + expr_7.high != 0:
        let (expr_7 : Uint256) = __warp_block_15(var_currentOwner)
        return (expr_7)
    else:
        return (expr_7)
    end
end

func __warp_block_16{range_check_ptr}(var_currentOwner : Uint256) -> (expr_8 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_currentOwner, Uint256(low=1, high=0))
    let (expr_8 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_8)
end

func __warp_if_10{range_check_ptr}(
        expr_7 : Uint256, expr_8 : Uint256, var_currentOwner : Uint256) -> (expr_8 : Uint256):
    alloc_locals
    if expr_7.low + expr_7.high != 0:
        let (expr_8 : Uint256) = __warp_block_16(var_currentOwner)
        return (expr_8)
    else:
        return (expr_8)
    end
end

func __warp_loop_body_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_dataHash : Uint256, var_data_1631_mpos : Uint256, var_i : Uint256,
        var_lastOwner : Uint256, var_requiredSignatures : Uint256,
        var_signatures_1633_mpos : Uint256) -> (
        var_currentOwner : Uint256, var_i : Uint256, var_lastOwner : Uint256):
    alloc_locals
    let (expr_component : Uint256, expr_component_1 : Uint256,
        expr_component_2 : Uint256) = fun_signatureSplit(var_signatures_1633_mpos, var_i)
    let (var_currentOwner : Uint256) = __warp_block_3(
        expr_component,
        expr_component_1,
        expr_component_2,
        var_dataHash,
        var_data_1631_mpos,
        var_requiredSignatures,
        var_signatures_1633_mpos)
    let (expr_7 : Uint256) = is_gt(var_currentOwner, var_lastOwner)
    let (expr_7 : Uint256) = __warp_if_9(expr_7, var_currentOwner)
    let expr_8 : Uint256 = expr_7
    let (expr_8 : Uint256) = __warp_if_10(expr_7, expr_8, var_currentOwner)
    require_helper_stringliteral(expr_8)
    let var_lastOwner : Uint256 = var_currentOwner
    let (var_i : Uint256) = increment_uint256(var_i)
    return (var_currentOwner, var_i, var_lastOwner)
end

func __warp_loop_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_currentOwner : Uint256, var_dataHash : Uint256, var_data_1631_mpos : Uint256,
        var_i : Uint256, var_lastOwner : Uint256, var_requiredSignatures : Uint256,
        var_signatures_1633_mpos : Uint256) -> (
        var_currentOwner : Uint256, var_i : Uint256, var_lastOwner : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(var_i, var_requiredSignatures)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_currentOwner, var_i, var_lastOwner)
    end
    let (var_currentOwner : Uint256, var_i : Uint256, var_lastOwner : Uint256) = __warp_loop_body_7(
        var_dataHash,
        var_data_1631_mpos,
        var_i,
        var_lastOwner,
        var_requiredSignatures,
        var_signatures_1633_mpos)
    let (var_currentOwner : Uint256, var_i : Uint256, var_lastOwner : Uint256) = __warp_loop_7(
        var_currentOwner,
        var_dataHash,
        var_data_1631_mpos,
        var_i,
        var_lastOwner,
        var_requiredSignatures,
        var_signatures_1633_mpos)
    return (var_currentOwner, var_i, var_lastOwner)
end

func fun_checkNSignatures{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_dataHash : Uint256, var_data_1631_mpos : Uint256, var_signatures_1633_mpos : Uint256,
        var_requiredSignatures : Uint256) -> ():
    alloc_locals
    let (expr : Uint256) = uint256_mload(var_signatures_1633_mpos)
    let (__warp_subexpr_2 : Uint256) = fun_mul_11039(var_requiredSignatures)
    let (__warp_subexpr_1 : Uint256) = is_lt(expr, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    require_helper_stringliteral_f27d(__warp_subexpr_0)
    let var_currentOwner : Uint256 = Uint256(low=0, high=0)
    let (var_currentOwner : Uint256, var_i : Uint256, var_lastOwner : Uint256) = __warp_loop_7(
        var_currentOwner,
        var_dataHash,
        var_data_1631_mpos,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        var_requiredSignatures,
        var_signatures_1633_mpos)
    return ()
end

func abi_decode_address{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (value0 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    return (value0)
end

func __warp_block_17{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_module)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_1 : Uint256) = sload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_11{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_17(var_module)
        return (expr)
    else:
        return (expr)
    end
end

func fun_isModuleEnabled{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_module : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(Uint256(low=1, high=0), var_module)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_11(expr, var_module)
    let var : Uint256 = expr
    return (var)
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (__warp_subexpr_1 : Uint256) = is_zero(value0)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    uint256_mstore(offset=headStart, value=__warp_subexpr_0)
    return (tail)
end

func __warp_block_18{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(var_owner : Uint256) -> (
        expr : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_owner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_1 : Uint256) = sload(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_12{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_owner : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_18(var_owner)
        return (expr)
    else:
        return (expr)
    end
end

func fun_isOwner{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(var_owner : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_owner, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_12(expr, var_owner)
    let var : Uint256 = expr
    return (var)
end

func abi_decode_10929{range_check_ptr}(dataEnd : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=headStart, value=value0)
    return (tail)
end

func abi_decode_addresst_uint256t_bytest_enum_Operation{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value2 : Uint256) = abi_decode_bytes(__warp_subexpr_3, dataEnd)
    let (value : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_5 : Uint256) = is_lt(value, Uint256(low=2, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value3 : Uint256 = value
    return (value0, value1, value2, value3)
end

func __warp_block_21{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_data_33_mpos : Uint256, var_to : Uint256, var_txGas : Uint256, var_value : Uint256) -> (
        var_success : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_mload(var_data_33_mpos)
    let (__warp_subexpr_0 : Uint256) = u256_add(var_data_33_mpos, Uint256(low=32, high=0))
    let (var_success : Uint256) = warp_call(
        var_txGas,
        var_to,
        var_value,
        __warp_subexpr_0,
        __warp_subexpr_1,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    return (var_success)
end

func __warp_block_22{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_data_33_mpos : Uint256, var_to : Uint256, var_txGas : Uint256) -> (
        var_success : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_mload(var_data_33_mpos)
    let (__warp_subexpr_0 : Uint256) = u256_add(var_data_33_mpos, Uint256(low=32, high=0))
    let (var_success : Uint256) = delegatecall(
        var_txGas,
        var_to,
        __warp_subexpr_0,
        __warp_subexpr_1,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    return (var_success)
end

func __warp_if_13{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_data_33_mpos : Uint256, var_to : Uint256,
        var_txGas : Uint256, var_value : Uint256) -> (var_success : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_success : Uint256) = __warp_block_21(
            var_data_33_mpos, var_to, var_txGas, var_value)
        return (var_success)
    else:
        let (var_success : Uint256) = __warp_block_22(var_data_33_mpos, var_to, var_txGas)
        return (var_success)
    end
end

func __warp_block_20{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        match_var : Uint256, var_data_33_mpos : Uint256, var_to : Uint256, var_txGas : Uint256,
        var_value : Uint256) -> (var_success : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_success : Uint256) = __warp_if_13(
        __warp_subexpr_0, var_data_33_mpos, var_to, var_txGas, var_value)
    return (var_success)
end

func __warp_block_19{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_data_33_mpos : Uint256, var_operation : Uint256, var_to : Uint256, var_txGas : Uint256,
        var_value : Uint256) -> (var_success : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_eq(var_operation, Uint256(low=1, high=0))
    let (var_success : Uint256) = __warp_block_20(
        match_var, var_data_33_mpos, var_to, var_txGas, var_value)
    return (var_success)
end

func fun_execute{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_33_mpos : Uint256, var_operation : Uint256,
        var_txGas : Uint256) -> (var_success : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(var_operation, Uint256(low=2, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var_success : Uint256) = __warp_block_19(
        var_data_33_mpos, var_operation, var_to, var_txGas, var_value)
    return (var_success)
end

func __warp_block_23{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = caller()
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_0)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    let (expr : Uint256) = is_zero(__warp_subexpr_1)
    return (expr)
end

func __warp_if_14{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(expr : Uint256) -> (
        expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_23()
        return (expr)
    else:
        return (expr)
    end
end

func fun_execTransactionFromModule{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_mpos : Uint256,
        var_operation : Uint256) -> (var_success : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = caller()
    let (__warp_subexpr_0 : Uint256) = is_eq(__warp_subexpr_1, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_14(expr)
    let (__warp_subexpr_2 : Uint256) = is_zero(expr)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (var_success : Uint256) = fun_execute(
        var_to, var_value, var_data_mpos, var_operation, __warp_subexpr_3)
    return (var_success)
end

func fun_execTransactionFromModuleReturnData{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_264_mpos : Uint256,
        var_operation : Uint256) -> (var_success : Uint256, var_returnData_mpos : Uint256):
    alloc_locals
    let (var_success : Uint256) = fun_execTransactionFromModule(
        var_to, var_value, var_data_264_mpos, var_operation)
    let (usr_ptr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(usr_ptr, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    uint256_mstore(offset=Uint256(low=64, high=0), value=__warp_subexpr_0)
    let (__warp_subexpr_3 : Uint256) = returndata_size()
    uint256_mstore(offset=usr_ptr, value=__warp_subexpr_3)
    let (__warp_subexpr_5 : Uint256) = returndata_size()
    let (__warp_subexpr_4 : Uint256) = u256_add(usr_ptr, Uint256(low=32, high=0))
    returndata_copy(__warp_subexpr_4, Uint256(low=0, high=0), __warp_subexpr_5)
    let var_returnData_mpos : Uint256 = usr_ptr
    return (var_success, var_returnData_mpos)
end

func abi_encode_bool_bytes{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_zero(value0)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    uint256_mstore(offset=headStart, value=__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    let (tail : Uint256) = abi_encode_bytes_memory_ptr(value1, __warp_subexpr_3)
    return (tail)
end

func __warp_loop_body_4{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, memPtr : Uint256, var_index : Uint256,
        var_offset : Uint256) -> (var_index : Uint256):
    alloc_locals
    let (__warp_subexpr_4 : Uint256) = u256_shl(_2, var_index)
    let (__warp_subexpr_3 : Uint256) = u256_add(var_offset, var_index)
    let (__warp_subexpr_2 : Uint256) = u256_add(memPtr, __warp_subexpr_4)
    let (__warp_subexpr_1 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = u256_add(__warp_subexpr_2, _1)
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    let (var_index : Uint256) = increment_uint256(var_index)
    return (var_index)
end

func __warp_loop_4{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, memPtr : Uint256, var_index : Uint256, var_length : Uint256,
        var_offset : Uint256) -> (var_index : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(var_index, var_length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_index)
    end
    let (var_index : Uint256) = __warp_loop_body_4(_1, _2, memPtr, var_index, var_offset)
    let (var_index : Uint256) = __warp_loop_4(_1, _2, memPtr, var_index, var_length, var_offset)
    return (var_index)
end

func fun_getStorageAt{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_offset : Uint256, var_length : Uint256) -> (var_1056_mpos : Uint256):
    alloc_locals
    let (__warp_subexpr_4 : Uint256) = u256_div(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        var_length)
    let (__warp_subexpr_3 : Uint256) = is_zero(var_length)
    let (__warp_subexpr_2 : Uint256) = is_gt(Uint256(low=32, high=0), __warp_subexpr_4)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = uint256_and(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (product : Uint256) = u256_shl(Uint256(low=5, high=0), var_length)
    let (_3 : Uint256) = array_allocation_size_bytes(product)
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr, _3)
    uint256_mstore(offset=memPtr, value=product)
    let (__warp_subexpr_8 : Uint256) = array_allocation_size_bytes(product)
    let (__warp_subexpr_7 : Uint256) = u256_add(
        __warp_subexpr_8,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_6 : Uint256) = calldatasize()
    let (__warp_subexpr_5 : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    calldatacopy(__warp_subexpr_5, __warp_subexpr_6, __warp_subexpr_7)
    let var_index : Uint256 = Uint256(low=0, high=0)
    let (var_index : Uint256) = __warp_loop_4(
        Uint256(low=32, high=0), Uint256(low=5, high=0), memPtr, var_index, var_length, var_offset)
    let var_1056_mpos : Uint256 = memPtr
    return (var_1056_mpos)
end

func abi_encode_bytes{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (tail : Uint256) = abi_encode_bytes_memory_ptr(value0, __warp_subexpr_0)
    return (tail)
end

func getter_fun_signedMessages{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(key : Uint256) -> (
        ret__warp_mangled : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=7, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (ret__warp_mangled : Uint256) = sload(__warp_subexpr_0)
    return (ret__warp_mangled)
end

func require_helper_stringliteral_eab5{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32_10961{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32_10962{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func __warp_block_24{range_check_ptr}(var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_module, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_15{range_check_ptr}(expr : Uint256, var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_24(var_module)
        return (expr)
    else:
        return (expr)
    end
end

func modifier_authorized_121{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_module : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_0 : Uint256) = is_zero(var_module)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_15(expr, var_module)
    require_helper_stringliteral_eab5(expr)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_module)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_4 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = sload(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (
        __warp_subexpr_7 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10961(
        )
    let (__warp_subexpr_6 : Uint256) = sload(__warp_subexpr_7)
    let (
        __warp_subexpr_5 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10962(
        var_module)
    sstore(key=__warp_subexpr_5, value=__warp_subexpr_6)
    let (
        __warp_subexpr_8 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10961(
        )
    sstore(key=__warp_subexpr_8, value=var_module)
    return ()
end

func abi_decode_bytes_calldata{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        offset : Uint256, end__warp_mangled : Uint256) -> (arrayPos : Uint256, length : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = u256_add(offset, Uint256(low=31, high=0))
    let (__warp_subexpr_1 : Uint256) = slt(__warp_subexpr_2, end__warp_mangled)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (length : Uint256) = calldataload(offset)
    let (__warp_subexpr_3 : Uint256) = is_gt(length, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (arrayPos : Uint256) = u256_add(offset, Uint256(low=32, high=0))
    let (__warp_subexpr_6 : Uint256) = u256_add(offset, length)
    let (__warp_subexpr_5 : Uint256) = u256_add(__warp_subexpr_6, Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = is_gt(__warp_subexpr_5, end__warp_mangled)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return (arrayPos, length)
    end
end

func abi_decode_addresst_uint256t_bytes_calldatat_enum_Operationt_uint256t_uint256t_uint256t_addresst_address_payablet_bytes{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256, value4 : Uint256,
        value5 : Uint256, value6 : Uint256, value7 : Uint256, value8 : Uint256, value9 : Uint256,
        value10 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=320, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=68, high=0))
    let _1 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, _1)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value2_1 : Uint256, value3_1 : Uint256) = abi_decode_bytes_calldata(
        __warp_subexpr_3, dataEnd)
    let value2 : Uint256 = value2_1
    let value3 : Uint256 = value3_1
    let (value : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_5 : Uint256) = is_lt(value, Uint256(low=2, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value4 : Uint256 = value
    let (value5 : Uint256) = calldataload(Uint256(low=132, high=0))
    let (value6 : Uint256) = calldataload(Uint256(low=164, high=0))
    let (value7 : Uint256) = calldataload(Uint256(low=196, high=0))
    let (value8 : Uint256) = calldataload(Uint256(low=228, high=0))
    let (value9 : Uint256) = calldataload(Uint256(low=260, high=0))
    let (offset_1 : Uint256) = calldataload(Uint256(low=292, high=0))
    let (__warp_subexpr_6 : Uint256) = is_gt(offset_1, _1)
    if __warp_subexpr_6.low + __warp_subexpr_6.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_7 : Uint256) = u256_add(Uint256(low=4, high=0), offset_1)
    let (value10 : Uint256) = abi_decode_bytes(__warp_subexpr_7, dataEnd)
    return (value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
end

func abi_encode_enum_Operation{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(value, Uint256(low=2, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=pos, value=value)
    return ()
end

func finalize_allocation_17618{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256) -> ():
    alloc_locals
    let (newFreePtr : Uint256) = u256_add(memPtr, Uint256(low=384, high=0))
    let (__warp_subexpr_2 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_1 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func finalize_allocation_17613{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256) -> ():
    alloc_locals
    let (newFreePtr : Uint256) = u256_add(memPtr, Uint256(low=128, high=0))
    let (__warp_subexpr_2 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_1 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func fun_domainSeparator{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> (var : Uint256):
    alloc_locals
    let (expr_1961_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_1 : Uint256) = u256_add(expr_1961_mpos, Uint256(low=32, high=0))
    uint256_mstore(
        offset=_1,
        value=Uint256(low=289660710824790902021086744184246145560, high=95577634524166658962789403354750223779))
    let (__warp_subexpr_1 : Uint256) = __warp_constant_1()
    let (__warp_subexpr_0 : Uint256) = u256_add(expr_1961_mpos, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    let (__warp_subexpr_3 : Uint256) = address()
    let (__warp_subexpr_2 : Uint256) = u256_add(expr_1961_mpos, Uint256(low=96, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=__warp_subexpr_3)
    uint256_mstore(offset=expr_1961_mpos, value=Uint256(low=96, high=0))
    finalize_allocation_17613(expr_1961_mpos)
    let (__warp_subexpr_4 : Uint256) = uint256_mload(expr_1961_mpos)
    let (var : Uint256) = uint256_sha(_1, __warp_subexpr_4)
    return (var)
end

func abi_encode_packed_bytes1_bytes1_bytes32_bytes32{
        memory_dict : DictAccess*, msize, range_check_ptr}(
        pos : Uint256, value2 : Uint256, value3 : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    uint256_mstore(offset=pos, value=Uint256(low=0, high=33230699894622896822595176507008614400))
    let (__warp_subexpr_0 : Uint256) = u256_add(pos, Uint256(low=1, high=0))
    uint256_mstore(
        offset=__warp_subexpr_0, value=Uint256(low=0, high=1329227995784915872903807060280344576))
    let (__warp_subexpr_1 : Uint256) = u256_add(pos, Uint256(low=2, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=value2)
    let (__warp_subexpr_2 : Uint256) = u256_add(pos, Uint256(low=34, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=value3)
    let (end__warp_mangled : Uint256) = u256_add(pos, Uint256(low=66, high=0))
    return (end__warp_mangled)
end

func fun_encodeTransactionData{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_offset : Uint256,
        var_data_length : Uint256, var_operation : Uint256, var_safeTxGas : Uint256,
        var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_refundReceiver : Uint256, var__nonce : Uint256) -> (var__mpos : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (_mpos : Uint256) = abi_decode_available_length_bytes(
        var_data_offset, var_data_length, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(_mpos)
    let (__warp_subexpr_1 : Uint256) = u256_add(_mpos, Uint256(low=32, high=0))
    let (expr : Uint256) = uint256_sha(__warp_subexpr_1, __warp_subexpr_2)
    let (expr_2009_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_1 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=32, high=0))
    uint256_mstore(
        offset=_1,
        value=Uint256(low=283443295553986174409180464831274321624, high=249246167456708384638066978265382115130))
    let (__warp_subexpr_3 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_3, value=var_to)
    let (__warp_subexpr_4 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=96, high=0))
    uint256_mstore(offset=__warp_subexpr_4, value=var_value)
    let (__warp_subexpr_5 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=128, high=0))
    uint256_mstore(offset=__warp_subexpr_5, value=expr)
    let (__warp_subexpr_6 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=160, high=0))
    abi_encode_enum_Operation(var_operation, __warp_subexpr_6)
    let (__warp_subexpr_7 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=192, high=0))
    uint256_mstore(offset=__warp_subexpr_7, value=var_safeTxGas)
    let (__warp_subexpr_8 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=224, high=0))
    uint256_mstore(offset=__warp_subexpr_8, value=var_baseGas)
    let (__warp_subexpr_9 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=256, high=0))
    uint256_mstore(offset=__warp_subexpr_9, value=var_gasPrice)
    let (__warp_subexpr_10 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=288, high=0))
    uint256_mstore(offset=__warp_subexpr_10, value=var_gasToken)
    let (__warp_subexpr_11 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=320, high=0))
    uint256_mstore(offset=__warp_subexpr_11, value=var_refundReceiver)
    let (__warp_subexpr_12 : Uint256) = u256_add(expr_2009_mpos, Uint256(low=352, high=0))
    uint256_mstore(offset=__warp_subexpr_12, value=var__nonce)
    uint256_mstore(offset=expr_2009_mpos, value=Uint256(low=352, high=0))
    finalize_allocation_17618(expr_2009_mpos)
    let (__warp_subexpr_13 : Uint256) = uint256_mload(expr_2009_mpos)
    let (expr_1 : Uint256) = uint256_sha(_1, __warp_subexpr_13)
    let (expr_2 : Uint256) = fun_domainSeparator()
    let (expr_2025_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_15 : Uint256) = u256_add(expr_2025_mpos, Uint256(low=32, high=0))
    let (__warp_subexpr_14 : Uint256) = abi_encode_packed_bytes1_bytes1_bytes32_bytes32(
        __warp_subexpr_15, expr_2, expr_1)
    let (_3 : Uint256) = uint256_sub(__warp_subexpr_14, expr_2025_mpos)
    let (__warp_subexpr_16 : Uint256) = u256_add(
        _3,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    uint256_mstore(offset=expr_2025_mpos, value=__warp_subexpr_16)
    finalize_allocation(expr_2025_mpos, _3)
    let var__mpos : Uint256 = expr_2025_mpos
    return (var__mpos)
end

func update_storage_value_offsett_address_to_address_11033{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(value : Uint256) -> ():
    alloc_locals
    sstore(key=Uint256(low=5, high=0), value=value)
    return ()
end

func fun_checkSignatures{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_dataHash : Uint256, var_data_1603_mpos : Uint256,
        var_signatures_1605_mpos : Uint256) -> ():
    alloc_locals
    let (_1 : Uint256) = sload(Uint256(low=4, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    fun_checkNSignatures(var_dataHash, var_data_1603_mpos, var_signatures_1605_mpos, _1)
    return ()
end

func abi_encode_address_uint256_bytes_calldata_enum_Operation_uint256_uint256_uint256_address_address_payable_bytes_address{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256, value2 : Uint256,
        value3 : Uint256, value4 : Uint256, value5 : Uint256, value6 : Uint256, value7 : Uint256,
        value8 : Uint256, value9 : Uint256, value10 : Uint256, value11 : Uint256) -> (
        tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=value0)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=value1)
    let (__warp_subexpr_1 : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=Uint256(low=352, high=0))
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, Uint256(low=352, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=value3)
    let (__warp_subexpr_3 : Uint256) = u256_add(headStart, Uint256(low=384, high=0))
    calldatacopy(__warp_subexpr_3, value2, value3)
    let (__warp_subexpr_5 : Uint256) = u256_add(headStart, value3)
    let (__warp_subexpr_4 : Uint256) = u256_add(__warp_subexpr_5, Uint256(low=384, high=0))
    uint256_mstore(offset=__warp_subexpr_4, value=Uint256(low=0, high=0))
    let (__warp_subexpr_7 : Uint256) = u256_add(value3, Uint256(low=31, high=0))
    let (__warp_subexpr_6 : Uint256) = uint256_and(
        __warp_subexpr_7,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (_1 : Uint256) = u256_add(headStart, __warp_subexpr_6)
    let (__warp_subexpr_8 : Uint256) = u256_add(headStart, Uint256(low=96, high=0))
    abi_encode_enum_Operation(value4, __warp_subexpr_8)
    let (__warp_subexpr_9 : Uint256) = u256_add(headStart, Uint256(low=128, high=0))
    uint256_mstore(offset=__warp_subexpr_9, value=value5)
    let (__warp_subexpr_10 : Uint256) = u256_add(headStart, Uint256(low=160, high=0))
    uint256_mstore(offset=__warp_subexpr_10, value=value6)
    let (__warp_subexpr_11 : Uint256) = u256_add(headStart, Uint256(low=192, high=0))
    uint256_mstore(offset=__warp_subexpr_11, value=value7)
    let (__warp_subexpr_12 : Uint256) = u256_add(headStart, Uint256(low=224, high=0))
    uint256_mstore(offset=__warp_subexpr_12, value=value8)
    let (__warp_subexpr_13 : Uint256) = u256_add(headStart, Uint256(low=256, high=0))
    uint256_mstore(offset=__warp_subexpr_13, value=value9)
    let (__warp_subexpr_16 : Uint256) = uint256_sub(_1, headStart)
    let (__warp_subexpr_15 : Uint256) = u256_add(__warp_subexpr_16, Uint256(low=384, high=0))
    let (__warp_subexpr_14 : Uint256) = u256_add(headStart, Uint256(low=288, high=0))
    uint256_mstore(offset=__warp_subexpr_14, value=__warp_subexpr_15)
    let (__warp_subexpr_17 : Uint256) = u256_add(_1, Uint256(low=384, high=0))
    let (tail : Uint256) = abi_encode_bytes_memory_ptr(value10, __warp_subexpr_17)
    let (__warp_subexpr_18 : Uint256) = u256_add(headStart, Uint256(low=320, high=0))
    uint256_mstore(offset=__warp_subexpr_18, value=value11)
    return (tail)
end

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_mul_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(x : Uint256) -> (
        product : Uint256):
    alloc_locals
    let (__warp_subexpr_4 : Uint256) = u256_div(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        x)
    let (__warp_subexpr_3 : Uint256) = is_zero(x)
    let (__warp_subexpr_2 : Uint256) = is_gt(Uint256(low=64, high=0), __warp_subexpr_4)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = uint256_and(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (product : Uint256) = u256_shl(Uint256(low=6, high=0), x)
    return (product)
end

func checked_div_uint256_11035{range_check_ptr}(x : Uint256) -> (r : Uint256):
    alloc_locals
    let (r : Uint256) = u256_div(x, Uint256(low=63, high=0))
    return (r)
end

func checked_add_uint256{range_check_ptr}(x : Uint256) -> (sum : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        x,
        Uint256(low=340282366920938463463374607431768208955, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(x, Uint256(low=2500, high=0))
    return (sum)
end

func __warp_if_16(__warp_subexpr_0 : Uint256, var_a : Uint256, var_b : Uint256) -> (expr : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let expr : Uint256 = var_b
        return (expr)
    else:
        let expr : Uint256 = var_a
        return (expr)
    end
end

func __warp_block_26{range_check_ptr}(match_var : Uint256, var_a : Uint256, var_b : Uint256) -> (
        expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr : Uint256) = __warp_if_16(__warp_subexpr_0, var_a, var_b)
    return (expr)
end

func __warp_block_25{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_lt(var_a, var_b)
    let (match_var : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_block_26(match_var, var_a, var_b)
    return (expr)
end

func fun_max{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (expr : Uint256) = __warp_block_25(var_a, var_b)
    let var : Uint256 = expr
    return (var)
end

func checked_add_uint256_11037{range_check_ptr}(x : Uint256) -> (sum : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(
        x,
        Uint256(low=340282366920938463463374607431768210955, high=340282366920938463463374607431768211455))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(x, Uint256(low=500, high=0))
    return (sum)
end

func require_helper_stringliteral_9d97{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_sub_uint256{range_check_ptr}(x : Uint256) -> (diff : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_lt(x, Uint256(low=2500, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (diff : Uint256) = u256_add(
        x,
        Uint256(low=340282366920938463463374607431768208956, high=340282366920938463463374607431768211455))
    return (diff)
end

func fun_sub{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(var_b, var_a)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_1 : Uint256) = is_lt(var_a, var_b)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (var : Uint256) = uint256_sub(var_a, var_b)
    return (var)
end

func require_helper_stringliteral_9933{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func fun_mul{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (
        var_ : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_a)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var_ : Uint256 = Uint256(low=0, high=0)
        return (var_)
    end
    let (__warp_subexpr_3 : Uint256) = u256_div(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        var_a)
    let (__warp_subexpr_2 : Uint256) = is_gt(var_b, __warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = uint256_and(Uint256(low=1, high=0), __warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (product : Uint256) = u256_mul(var_a, var_b)
    let (__warp_subexpr_6 : Uint256) = checked_div_uint256(product, var_a)
    let (__warp_subexpr_5 : Uint256) = is_eq(__warp_subexpr_6, var_b)
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var_ : Uint256 = product
    return (var_)
end

func require_helper_stringliteral_74ed{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper_stringliteral_4353{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_if_17{range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_refundReceiver : Uint256) -> (expr : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let expr : Uint256 = var_refundReceiver
        return (expr)
    else:
        let (expr : Uint256) = caller()
        return (expr)
    end
end

func __warp_block_28{range_check_ptr, syscall_ptr : felt*}(
        match_var : Uint256, var_refundReceiver : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr : Uint256) = __warp_if_17(__warp_subexpr_0, var_refundReceiver)
    return (expr)
end

func __warp_block_27{range_check_ptr, syscall_ptr : felt*}(var_refundReceiver : Uint256) -> (
        expr : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_zero(var_refundReceiver)
    let (expr : Uint256) = __warp_block_28(match_var, var_refundReceiver)
    return (expr)
end

func __warp_block_35{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = uint256_mload(Uint256(low=0, high=0))
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(usr_success)
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    let (var_transferred : Uint256) = is_zero(__warp_subexpr_0)
    return (var_transferred)
end

func __warp_if_20{bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_transferred : Uint256) = __warp_block_35(usr_success)
        return (var_transferred)
    else:
        let var_transferred : Uint256 = Uint256(low=0, high=0)
        return (var_transferred)
    end
end

func __warp_block_34{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=32, high=0))
    let (var_transferred : Uint256) = __warp_if_20(__warp_subexpr_0, usr_success)
    return (var_transferred)
end

func __warp_if_19{bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, match_var : Uint256, usr_success : Uint256) -> (
        var_transferred : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var_transferred : Uint256 = usr_success
        return (var_transferred)
    else:
        let (var_transferred : Uint256) = __warp_block_34(match_var, usr_success)
        return (var_transferred)
    end
end

func __warp_block_33{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_transferred : Uint256) = __warp_if_19(__warp_subexpr_0, match_var, usr_success)
    return (var_transferred)
end

func __warp_block_32{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (match_var : Uint256) = returndata_size()
    let (var_transferred : Uint256) = __warp_block_33(match_var, usr_success)
    return (var_transferred)
end

func __warp_block_31{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = fun_add(var_gasUsed, var_baseGas)
    let (var_payment : Uint256) = fun_mul(__warp_subexpr_0, var_gasPrice)
    let (expr_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_1 : Uint256) = u256_add(expr_mpos, Uint256(low=32, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=224668671643508016486903311432943665152))
    let (__warp_subexpr_1 : Uint256) = u256_add(expr_mpos, Uint256(low=36, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=expr)
    let (__warp_subexpr_2 : Uint256) = u256_add(expr_mpos, Uint256(low=68, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=var_payment)
    uint256_mstore(offset=expr_mpos, value=Uint256(low=68, high=0))
    finalize_allocation_17613(expr_mpos)
    let (__warp_subexpr_5 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_4 : Uint256) = uint256_mload(expr_mpos)
    let (__warp_subexpr_3 : Uint256) = u256_add(
        __warp_subexpr_5,
        Uint256(low=340282366920938463463374607431768201456, high=340282366920938463463374607431768211455))
    let (usr_success : Uint256) = warp_call(
        __warp_subexpr_3,
        var_gasToken,
        Uint256(low=0, high=0),
        _1,
        __warp_subexpr_4,
        Uint256(low=0, high=0),
        Uint256(low=32, high=0))
    let (var_transferred : Uint256) = __warp_block_32(usr_success)
    require_helper_stringliteral_74ed(var_transferred)
    return (var_payment)
end

func __warp_if_21(__warp_subexpr_0 : Uint256, var_gasPrice : Uint256) -> (expr_2 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (expr_2 : Uint256) = __warp_constant_10()
        return (expr_2)
    else:
        let expr_2 : Uint256 = var_gasPrice
        return (expr_2)
    end
end

func __warp_block_38{range_check_ptr}(match_var : Uint256, var_gasPrice : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr_2 : Uint256) = __warp_if_21(__warp_subexpr_0, var_gasPrice)
    return (expr_2)
end

func __warp_block_37{range_check_ptr}(var_gasPrice : Uint256) -> (expr_2 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10()
    let (match_var : Uint256) = is_lt(var_gasPrice, __warp_subexpr_0)
    let (expr_2 : Uint256) = __warp_block_38(match_var, var_gasPrice)
    return (expr_2)
end

func __warp_if_22(_2 : Uint256, __warp_subexpr_0 : Uint256) -> (_2 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let _2 : Uint256 = Uint256(low=2300, high=0)
        return (_2)
    else:
        return (_2)
    end
end

func __warp_block_36{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256, var_gasUsed : Uint256) -> (
        var_payment : Uint256):
    alloc_locals
    let (expr_1 : Uint256) = fun_add(var_gasUsed, var_baseGas)
    let (expr_2 : Uint256) = __warp_block_37(var_gasPrice)
    let (var_payment : Uint256) = fun_mul(expr_1, expr_2)
    let _2 : Uint256 = Uint256(low=0, high=0)
    let (__warp_subexpr_0 : Uint256) = is_zero(var_payment)
    let (_2 : Uint256) = __warp_if_22(_2, __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = warp_call(
        _2,
        expr,
        var_payment,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    require_helper_stringliteral_4353(__warp_subexpr_1)
    return (var_payment)
end

func __warp_if_18{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, expr : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256,
        var_gasToken : Uint256, var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_payment : Uint256) = __warp_block_31(
            expr, var_baseGas, var_gasPrice, var_gasToken, var_gasUsed)
        return (var_payment)
    else:
        let (var_payment : Uint256) = __warp_block_36(expr, var_baseGas, var_gasPrice, var_gasUsed)
        return (var_payment)
    end
end

func __warp_block_30{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, match_var : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256,
        var_gasToken : Uint256, var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_payment : Uint256) = __warp_if_18(
        __warp_subexpr_0, expr, var_baseGas, var_gasPrice, var_gasToken, var_gasUsed)
    return (var_payment)
end

func __warp_block_29{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_zero(var_gasToken)
    let (var_payment : Uint256) = __warp_block_30(
        expr, match_var, var_baseGas, var_gasPrice, var_gasToken, var_gasUsed)
    return (var_payment)
end

func fun_handlePayment{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_gasUsed : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256,
        var_gasToken : Uint256, var_refundReceiver : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (expr : Uint256) = __warp_block_27(var_refundReceiver)
    let (var_payment : Uint256) = __warp_block_29(
        expr, var_baseGas, var_gasPrice, var_gasToken, var_gasUsed)
    return (var_payment)
end

func abi_encode_bytes32_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    uint256_mstore(offset=headStart, value=value0)
    let (__warp_subexpr_2 : Uint256) = is_zero(value1)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=__warp_subexpr_1)
    return (tail)
end

func __warp_block_40{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_2 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_2, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_2, __warp_subexpr_2)
    abi_decode(_2, __warp_subexpr_1)
    return ()
end

func __warp_if_24{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_2 : Uint256, _3 : Uint256) -> ():
    alloc_locals
    if _3.low + _3.high != 0:
        __warp_block_40(_2)
        return ()
    else:
        return ()
    end
end

func __warp_block_39{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_1 : Uint256, var_baseGas : Uint256, var_data_1324_length : Uint256,
        var_data_1324_offset : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_operation : Uint256, var_refundReceiver : Uint256, var_safeTxGas : Uint256,
        var_signatures_1339_mpos : Uint256, var_to : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_2, value=Uint256(low=0, high=156769626060188724792637705978407550976))
    let (__warp_subexpr_4 : Uint256) = caller()
    let (__warp_subexpr_3 : Uint256) = u256_add(_2, Uint256(low=4, high=0))
    let (
        __warp_subexpr_2 : Uint256) = abi_encode_address_uint256_bytes_calldata_enum_Operation_uint256_uint256_uint256_address_address_payable_bytes_address(
        __warp_subexpr_3,
        var_to,
        var_value,
        var_data_1324_offset,
        var_data_1324_length,
        var_operation,
        var_safeTxGas,
        var_baseGas,
        var_gasPrice,
        var_gasToken,
        var_refundReceiver,
        var_signatures_1339_mpos,
        __warp_subexpr_4)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, _2)
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_3 : Uint256) = warp_call(
        __warp_subexpr_0,
        expr_1,
        Uint256(low=0, high=0),
        _2,
        __warp_subexpr_1,
        _2,
        Uint256(low=0, high=0))
    let (__warp_subexpr_5 : Uint256) = is_zero(_3)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    __warp_if_24(_2, _3)
    return ()
end

func __warp_if_23{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_3 : Uint256, expr_1 : Uint256, var_baseGas : Uint256,
        var_data_1324_length : Uint256, var_data_1324_offset : Uint256, var_gasPrice : Uint256,
        var_gasToken : Uint256, var_operation : Uint256, var_refundReceiver : Uint256,
        var_safeTxGas : Uint256, var_signatures_1339_mpos : Uint256, var_to : Uint256,
        var_value : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        __warp_block_39(
            expr_1,
            var_baseGas,
            var_data_1324_length,
            var_data_1324_offset,
            var_gasPrice,
            var_gasToken,
            var_operation,
            var_refundReceiver,
            var_safeTxGas,
            var_signatures_1339_mpos,
            var_to,
            var_value)
        return ()
    else:
        return ()
    end
end

func __warp_block_43{range_check_ptr}() -> (expr_5 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (expr_5 : Uint256) = checked_sub_uint256(__warp_subexpr_0)
    return (expr_5)
end

func __warp_if_25{range_check_ptr}(__warp_subexpr_0 : Uint256, var_safeTxGas : Uint256) -> (
        expr_5 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let expr_5 : Uint256 = var_safeTxGas
        return (expr_5)
    else:
        let (expr_5 : Uint256) = __warp_block_43()
        return (expr_5)
    end
end

func __warp_block_42{range_check_ptr}(match_var : Uint256, var_safeTxGas : Uint256) -> (
        expr_5 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr_5 : Uint256) = __warp_if_25(__warp_subexpr_0, var_safeTxGas)
    return (expr_5)
end

func __warp_block_41{range_check_ptr}(var_gasPrice : Uint256, var_safeTxGas : Uint256) -> (
        expr_5 : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_zero(var_gasPrice)
    let (expr_5 : Uint256) = __warp_block_42(match_var, var_safeTxGas)
    return (expr_5)
end

func __warp_block_44{range_check_ptr}(var_safeTxGas : Uint256) -> (expr_7 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_safeTxGas)
    let (expr_7 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_7)
end

func __warp_if_26{range_check_ptr}(
        __warp_subexpr_14 : Uint256, expr_7 : Uint256, var_safeTxGas : Uint256) -> (
        expr_7 : Uint256):
    alloc_locals
    if __warp_subexpr_14.low + __warp_subexpr_14.high != 0:
        let (expr_7 : Uint256) = __warp_block_44(var_safeTxGas)
        return (expr_7)
    else:
        return (expr_7)
    end
end

func __warp_block_45{range_check_ptr}(var_gasPrice : Uint256) -> (expr_8 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_gasPrice)
    let (expr_8 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_8)
end

func __warp_if_27{range_check_ptr}(
        __warp_subexpr_15 : Uint256, expr_8 : Uint256, var_gasPrice : Uint256) -> (
        expr_8 : Uint256):
    alloc_locals
    if __warp_subexpr_15.low + __warp_subexpr_15.high != 0:
        let (expr_8 : Uint256) = __warp_block_45(var_gasPrice)
        return (expr_8)
    else:
        return (expr_8)
    end
end

func __warp_block_46{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr_6 : Uint256, var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_refundReceiver : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = fun_handlePayment(
        expr_6, var_baseGas, var_gasPrice, var_gasToken, var_refundReceiver)

    return ()
end

func __warp_if_28{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_16 : Uint256, expr_6 : Uint256, var_baseGas : Uint256,
        var_gasPrice : Uint256, var_gasToken : Uint256, var_refundReceiver : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_16.low + __warp_subexpr_16.high != 0:
        __warp_block_46(expr_6, var_baseGas, var_gasPrice, var_gasToken, var_refundReceiver)
        return ()
    else:
        return ()
    end
end

func __warp_block_48{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_4 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_4, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_4, __warp_subexpr_2)
    abi_decode(_4, __warp_subexpr_1)
    return ()
end

func __warp_if_30{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_4 : Uint256, _5 : Uint256) -> ():
    alloc_locals
    if _5.low + _5.high != 0:
        __warp_block_48(_4)
        return ()
    else:
        return ()
    end
end

func __warp_block_47{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, expr_1 : Uint256, var_success : Uint256) -> ():
    alloc_locals
    let (_4 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_4, value=Uint256(low=0, high=195599408563376862459601491944395505664))
    let (__warp_subexpr_3 : Uint256) = u256_add(_4, Uint256(low=4, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bytes32_bool(__warp_subexpr_3, expr, var_success)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, _4)
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_5 : Uint256) = warp_call(
        __warp_subexpr_0,
        expr_1,
        Uint256(low=0, high=0),
        _4,
        __warp_subexpr_1,
        _4,
        Uint256(low=0, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    __warp_if_30(_4, _5)
    return ()
end

func __warp_if_29{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_18 : Uint256, expr : Uint256, expr_1 : Uint256, var_success : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_18.low + __warp_subexpr_18.high != 0:
        __warp_block_47(expr, expr_1, var_success)
        return ()
    else:
        return ()
    end
end

func fun_execTransaction{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_1324_offset : Uint256,
        var_data_1324_length : Uint256, var_operation : Uint256, var_safeTxGas : Uint256,
        var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_refundReceiver : Uint256, var_signatures_1339_mpos : Uint256) -> (
        var_success : Uint256):
    alloc_locals
    let (_1 : Uint256) = sload(Uint256(low=5, high=0))
    let (expr_1360_mpos : Uint256) = fun_encodeTransactionData(
        var_to,
        var_value,
        var_data_1324_offset,
        var_data_1324_length,
        var_operation,
        var_safeTxGas,
        var_baseGas,
        var_gasPrice,
        var_gasToken,
        var_refundReceiver,
        _1)
    let (__warp_subexpr_0 : Uint256) = increment_uint256(_1)
    update_storage_value_offsett_address_to_address_11033(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(expr_1360_mpos)
    let (__warp_subexpr_1 : Uint256) = u256_add(expr_1360_mpos, Uint256(low=32, high=0))
    let (expr : Uint256) = uint256_sha(__warp_subexpr_1, __warp_subexpr_2)
    fun_checkSignatures(expr, expr_1360_mpos, var_signatures_1339_mpos)
    let (expr_1 : Uint256) = sload(
        Uint256(low=121816481939259035148028565361356715208, high=98530635266159011945338023816300572120))
    let (__warp_subexpr_4 : Uint256) = is_zero(expr_1)
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    __warp_if_23(
        __warp_subexpr_3,
        expr_1,
        var_baseGas,
        var_data_1324_length,
        var_data_1324_offset,
        var_gasPrice,
        var_gasToken,
        var_operation,
        var_refundReceiver,
        var_safeTxGas,
        var_signatures_1339_mpos,
        var_to,
        var_value)
    let (expr_2 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_5 : Uint256) = checked_mul_uint256(var_safeTxGas)
    let (expr_3 : Uint256) = checked_div_uint256_11035(__warp_subexpr_5)
    let (__warp_subexpr_10 : Uint256) = checked_add_uint256(var_safeTxGas)
    let (__warp_subexpr_9 : Uint256) = fun_max(expr_3, __warp_subexpr_10)
    let (__warp_subexpr_8 : Uint256) = checked_add_uint256_11037(__warp_subexpr_9)
    let (__warp_subexpr_7 : Uint256) = is_lt(expr_2, __warp_subexpr_8)
    let (__warp_subexpr_6 : Uint256) = is_zero(__warp_subexpr_7)
    require_helper_stringliteral_9d97(__warp_subexpr_6)
    let (expr_4 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (expr_5 : Uint256) = __warp_block_41(var_gasPrice, var_safeTxGas)
    let (__warp_subexpr_12 : Uint256) = calldatasize()
    let (__warp_subexpr_11 : Uint256) = abi_decode_available_length_bytes(
        var_data_1324_offset, var_data_1324_length, __warp_subexpr_12)
    let (var_success : Uint256) = fun_execute(
        var_to, var_value, __warp_subexpr_11, var_operation, expr_5)
    let (__warp_subexpr_13 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (expr_6 : Uint256) = fun_sub(expr_4, __warp_subexpr_13)
    let expr_7 : Uint256 = var_success
    let (__warp_subexpr_14 : Uint256) = is_zero(var_success)
    let (expr_7 : Uint256) = __warp_if_26(__warp_subexpr_14, expr_7, var_safeTxGas)
    let expr_8 : Uint256 = expr_7
    let (__warp_subexpr_15 : Uint256) = is_zero(expr_7)
    let (expr_8 : Uint256) = __warp_if_27(__warp_subexpr_15, expr_8, var_gasPrice)
    require_helper_stringliteral_9933(expr_8)
    let (__warp_subexpr_17 : Uint256) = is_zero(var_gasPrice)
    let (__warp_subexpr_16 : Uint256) = is_zero(__warp_subexpr_17)
    __warp_if_28(
        __warp_subexpr_16, expr_6, var_baseGas, var_gasPrice, var_gasToken, var_refundReceiver)
    let (__warp_subexpr_19 : Uint256) = is_zero(expr_1)
    let (__warp_subexpr_18 : Uint256) = is_zero(__warp_subexpr_19)
    __warp_if_29(__warp_subexpr_18, expr, expr_1, var_success)
    return (var_success)
end

func mapping_index_access_mapping_bytes32_uint256_of_bytes32_10938{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=8, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func abi_decode_bytes32t_bytest_bytes{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=96, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=36, high=0))
    let _1 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, _1)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value1 : Uint256) = abi_decode_bytes(__warp_subexpr_3, dataEnd)
    let (offset_1 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_4 : Uint256) = is_gt(offset_1, _1)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_5 : Uint256) = u256_add(Uint256(low=4, high=0), offset_1)
    let (value2 : Uint256) = abi_decode_bytes(__warp_subexpr_5, dataEnd)
    return (value0, value1, value2)
end

func array_allocation_size_array_address_dyn{range_check_ptr}(length : Uint256) -> (size : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_gt(length, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_1 : Uint256) = u256_shl(Uint256(low=5, high=0), length)
    let (size : Uint256) = u256_add(__warp_subexpr_1, Uint256(low=32, high=0))
    return (size)
end

func allocate_and_zero_memory_array_array_address_dyn{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(length : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (_1 : Uint256) = array_allocation_size_array_address_dyn(length)
    let (memPtr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr_1, _1)
    uint256_mstore(offset=memPtr_1, value=length)
    let memPtr : Uint256 = memPtr_1
    let (__warp_subexpr_3 : Uint256) = array_allocation_size_array_address_dyn(length)
    let (__warp_subexpr_2 : Uint256) = u256_add(
        __warp_subexpr_3,
        Uint256(low=340282366920938463463374607431768211424, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr_1, Uint256(low=32, high=0))
    calldatacopy(__warp_subexpr_0, __warp_subexpr_1, __warp_subexpr_2)
    return (memPtr)
end

func memory_array_index_access_address_dyn{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index : Uint256) -> (addr : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(baseRef)
    let (__warp_subexpr_1 : Uint256) = is_lt(index, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_4 : Uint256) = u256_shl(Uint256(low=5, high=0), index)
    let (__warp_subexpr_3 : Uint256) = u256_add(baseRef, __warp_subexpr_4)
    let (addr : Uint256) = u256_add(__warp_subexpr_3, Uint256(low=32, high=0))
    return (addr)
end

func __warp_loop_body_3{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, expr_807_mpos : Uint256,
        var_currentOwner : Uint256, var_index : Uint256) -> (
        var_currentOwner : Uint256, var_index : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = memory_array_index_access_address_dyn(
        expr_807_mpos, var_index)
    uint256_mstore(offset=__warp_subexpr_0, value=var_currentOwner)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_currentOwner)
    uint256_mstore(offset=_3, value=_2)
    let (__warp_subexpr_1 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), _4)
    let (var_currentOwner : Uint256) = sload(__warp_subexpr_1)
    let (var_index : Uint256) = increment_uint256(var_index)
    return (var_currentOwner, var_index)
end

func __warp_loop_3{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, expr_807_mpos : Uint256,
        var_currentOwner : Uint256, var_index : Uint256) -> (
        var_currentOwner : Uint256, var_index : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = is_eq(var_currentOwner, _1)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_currentOwner, var_index)
    end
    let (var_currentOwner : Uint256, var_index : Uint256) = __warp_loop_body_3(
        _2, _3, _4, expr_807_mpos, var_currentOwner, var_index)
    let (var_currentOwner : Uint256, var_index : Uint256) = __warp_loop_3(
        _1, _2, _3, _4, expr_807_mpos, var_currentOwner, var_index)
    return (var_currentOwner, var_index)
end

func fun_getOwners{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        var_mpos : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = sload(Uint256(low=3, high=0))
    let (expr_807_mpos : Uint256) = allocate_and_zero_memory_array_array_address_dyn(
        __warp_subexpr_0)
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_1 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (var_currentOwner : Uint256) = sload(__warp_subexpr_1)
    let (var_currentOwner : Uint256, var_index : Uint256) = __warp_loop_3(
        Uint256(low=1, high=0),
        Uint256(low=2, high=0),
        Uint256(low=32, high=0),
        Uint256(low=64, high=0),
        expr_807_mpos,
        var_currentOwner,
        Uint256(low=0, high=0))
    let var_mpos : Uint256 = expr_807_mpos
    return (var_mpos)
end

func __warp_loop_body_1{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, i : Uint256, pos : Uint256, srcPtr : Uint256) -> (
        i : Uint256, pos : Uint256, srcPtr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_mload(srcPtr)
    uint256_mstore(offset=pos, value=__warp_subexpr_0)
    let (pos : Uint256) = u256_add(pos, _1)
    let (srcPtr : Uint256) = u256_add(srcPtr, _1)
    let (i : Uint256) = u256_add(i, Uint256(low=1, high=0))
    return (i, pos, srcPtr)
end

func __warp_loop_1{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, i : Uint256, length : Uint256, pos : Uint256, srcPtr : Uint256) -> (
        i : Uint256, pos : Uint256, srcPtr : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(i, length)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i, pos, srcPtr)
    end
    let (i : Uint256, pos : Uint256, srcPtr : Uint256) = __warp_loop_body_1(_1, i, pos, srcPtr)
    let (i : Uint256, pos : Uint256, srcPtr : Uint256) = __warp_loop_1(_1, i, length, pos, srcPtr)
    return (i, pos, srcPtr)
end

func abi_encode_array_address_dyn{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> (end__warp_mangled : Uint256):
    alloc_locals
    let (length : Uint256) = uint256_mload(value)
    uint256_mstore(offset=pos, value=length)
    let (pos : Uint256) = u256_add(pos, Uint256(low=32, high=0))
    let (srcPtr : Uint256) = u256_add(value, Uint256(low=32, high=0))
    let i : Uint256 = Uint256(low=0, high=0)
    let (i : Uint256, pos : Uint256, srcPtr : Uint256) = __warp_loop_1(
        Uint256(low=32, high=0), i, length, pos, srcPtr)
    let end__warp_mangled : Uint256 = pos
    return (end__warp_mangled)
end

func abi_encode_array_address_dyn_memory_ptr{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (tail : Uint256) = abi_encode_array_address_dyn(value0, __warp_subexpr_0)
    return (tail)
end

func abi_decode_array_address_dyn_calldatat_uint256t_addresst_bytes_calldatat_addresst_addresst_uint256t_address_payable{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256, value4 : Uint256,
        value5 : Uint256, value6 : Uint256, value7 : Uint256, value8 : Uint256, value9 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=256, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (offset : Uint256) = calldataload(Uint256(low=4, high=0))
    let _1 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, _1)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_5 : Uint256) = u256_add(offset, Uint256(low=35, high=0))
    let (__warp_subexpr_4 : Uint256) = slt(__warp_subexpr_5, dataEnd)
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_6 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (length : Uint256) = calldataload(__warp_subexpr_6)
    let (__warp_subexpr_7 : Uint256) = is_gt(length, _1)
    if __warp_subexpr_7.low + __warp_subexpr_7.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_11 : Uint256) = u256_shl(Uint256(low=5, high=0), length)
    let (__warp_subexpr_10 : Uint256) = u256_add(offset, __warp_subexpr_11)
    let (__warp_subexpr_9 : Uint256) = u256_add(__warp_subexpr_10, Uint256(low=36, high=0))
    let (__warp_subexpr_8 : Uint256) = is_gt(__warp_subexpr_9, dataEnd)
    if __warp_subexpr_8.low + __warp_subexpr_8.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = u256_add(offset, Uint256(low=36, high=0))
    let value1 : Uint256 = length
    let (value2 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (value3 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (offset_1 : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_12 : Uint256) = is_gt(offset_1, _1)
    if __warp_subexpr_12.low + __warp_subexpr_12.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_13 : Uint256) = u256_add(Uint256(low=4, high=0), offset_1)
    let (value4_1 : Uint256, value5_1 : Uint256) = abi_decode_bytes_calldata(
        __warp_subexpr_13, dataEnd)
    let value4 : Uint256 = value4_1
    let value5 : Uint256 = value5_1
    let (value6 : Uint256) = calldataload(Uint256(low=132, high=0))
    let (value7 : Uint256) = calldataload(Uint256(low=164, high=0))
    let (value8 : Uint256) = calldataload(Uint256(low=196, high=0))
    let (value9 : Uint256) = calldataload(Uint256(low=228, high=0))
    return (value0, value1, value2, value3, value4, value5, value6, value7, value8, value9)
end

func __warp_loop_body_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_2 : Uint256, dst : Uint256, src : Uint256) -> (
        dst : Uint256, src : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(src)
    uint256_mstore(offset=dst, value=__warp_subexpr_0)
    let (dst : Uint256) = u256_add(dst, _2)
    let (src : Uint256) = u256_add(src, _2)
    return (dst, src)
end

func __warp_loop_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_2 : Uint256, dst : Uint256, src : Uint256, srcEnd : Uint256) -> (
        dst : Uint256, src : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_lt(src, srcEnd)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (dst, src)
    end
    let (dst : Uint256, src : Uint256) = __warp_loop_body_5(_2, dst, src)
    let (dst : Uint256, src : Uint256) = __warp_loop_5(_2, dst, src, srcEnd)
    return (dst, src)
end

func require_helper_stringliteral_3a32{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_49{range_check_ptr}(_3 : Uint256, _4 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(_4, _3)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_31{range_check_ptr}(_3 : Uint256, _4 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_49(_3, _4)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_50{range_check_ptr, syscall_ptr : felt*}(_4 : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = address()
    let (__warp_subexpr_0 : Uint256) = is_eq(_4, __warp_subexpr_1)
    let (expr_1 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_1)
end

func __warp_if_32{range_check_ptr, syscall_ptr : felt*}(
        _4 : Uint256, expr : Uint256, expr_1 : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr_1 : Uint256) = __warp_block_50(_4)
        return (expr_1)
    else:
        return (expr_1)
    end
end

func __warp_block_51{range_check_ptr}(_4 : Uint256, var_currentOwner : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_currentOwner, _4)
    let (expr_2 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_2)
end

func __warp_if_33{range_check_ptr}(
        _4 : Uint256, expr_1 : Uint256, expr_2 : Uint256, var_currentOwner : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    if expr_1.low + expr_1.high != 0:
        let (expr_2 : Uint256) = __warp_block_51(_4, var_currentOwner)
        return (expr_2)
    else:
        return (expr_2)
    end
end

func __warp_loop_body_6{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _3 : Uint256, __warp_break_6 : Uint256, memPtr : Uint256, var_currentOwner : Uint256,
        var_i : Uint256) -> (__warp_break_6 : Uint256, var_currentOwner : Uint256, var_i : Uint256):
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = uint256_mload(memPtr)
    let (__warp_subexpr_1 : Uint256) = is_lt(var_i, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let __warp_break_6 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_6, var_currentOwner, var_i)
    end
    let (__warp_subexpr_3 : Uint256) = memory_array_index_access_address_dyn(memPtr, var_i)
    let (_4 : Uint256) = uint256_mload(__warp_subexpr_3)
    let (__warp_subexpr_4 : Uint256) = is_zero(_4)
    let (expr : Uint256) = is_zero(__warp_subexpr_4)
    let (expr : Uint256) = __warp_if_31(_3, _4, expr)
    let expr_1 : Uint256 = expr
    let (expr_1 : Uint256) = __warp_if_32(_4, expr, expr_1)
    let expr_2 : Uint256 = expr_1
    let (expr_2 : Uint256) = __warp_if_33(_4, expr_1, expr_2, var_currentOwner)
    require_helper_stringliteral_3d41(expr_2)
    let (
        __warp_subexpr_7 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        _4)
    let (__warp_subexpr_6 : Uint256) = sload(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = is_zero(__warp_subexpr_6)
    require_helper_stringliteral_bd32(__warp_subexpr_5)
    let (
        __warp_subexpr_8 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_currentOwner)
    sstore(key=__warp_subexpr_8, value=_4)
    let var_currentOwner : Uint256 = _4
    let (var_i : Uint256) = increment_uint256(var_i)
    return (__warp_break_6, var_currentOwner, var_i)
end

func __warp_loop_6{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _3 : Uint256, memPtr : Uint256, var_currentOwner : Uint256, var_i : Uint256) -> (
        var_currentOwner : Uint256, var_i : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(_3)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_currentOwner, var_i)
    end
    let (__warp_break_6 : Uint256, var_currentOwner : Uint256,
        var_i : Uint256) = __warp_loop_body_6(
        _3, Uint256(low=0, high=0), memPtr, var_currentOwner, var_i)
    let (var_currentOwner : Uint256, var_i : Uint256) = __warp_loop_6(
        _3, memPtr, var_currentOwner, var_i)
    return (var_currentOwner, var_i)
end

func update_storage_value_offsett_address_to_address_11021{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(slot : Uint256) -> ():
    alloc_locals
    sstore(key=slot, value=Uint256(low=1, high=0))
    return ()
end

func update_storage_value_offsett_address_to_address{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(value : Uint256) -> ():
    alloc_locals
    sstore(key=Uint256(low=3, high=0), value=value)
    return ()
end

func update_storage_value_offsett_address_to_address_11023{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(value : Uint256) -> ():
    alloc_locals
    sstore(key=Uint256(low=4, high=0), value=value)
    return ()
end

func fun_internalSetFallbackHandler{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_handler : Uint256) -> ():
    alloc_locals
    sstore(
        key=Uint256(low=87825846081101499500981431604900075733, high=144358433641795870133215269870563063761),
        value=var_handler)
    return ()
end

func __warp_block_52{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_data_73_mpos : Uint256, var_to : Uint256) -> ():
    alloc_locals
    let (_2 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_3 : Uint256) = uint256_mload(var_data_73_mpos)
    let (__warp_subexpr_2 : Uint256) = u256_add(var_data_73_mpos, Uint256(low=32, high=0))
    let (__warp_subexpr_1 : Uint256) = delegatecall(
        _2,
        var_to,
        __warp_subexpr_2,
        __warp_subexpr_3,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_if_34{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_5 : Uint256, var_data_73_mpos : Uint256, var_to : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        __warp_block_52(var_data_73_mpos, var_to)
        return ()
    else:
        return ()
    end
end

func fun_setupModules{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_data_73_mpos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=0, high=0), value=Uint256(low=1, high=0))
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_4 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    sstore(key=__warp_subexpr_4, value=Uint256(low=1, high=0))
    let (__warp_subexpr_6 : Uint256) = is_zero(var_to)
    let (__warp_subexpr_5 : Uint256) = is_zero(__warp_subexpr_6)
    __warp_if_34(__warp_subexpr_5, var_data_73_mpos, var_to)
    return ()
end

func fun_mul_17612{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(var_a : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_a)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var : Uint256 = Uint256(low=0, high=0)
        return (var)
    end
    let (__warp_subexpr_3 : Uint256) = u256_div(
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455),
        var_a)
    let (__warp_subexpr_2 : Uint256) = is_gt(Uint256(low=1, high=0), __warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = uint256_and(Uint256(low=1, high=0), __warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_6 : Uint256) = checked_div_uint256(var_a, var_a)
    let (__warp_subexpr_5 : Uint256) = is_eq(__warp_subexpr_6, Uint256(low=1, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let var : Uint256 = var_a
    return (var)
end

func __warp_if_35{range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_refundReceiver : Uint256) -> (expr : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let expr : Uint256 = var_refundReceiver
        return (expr)
    else:
        let (expr : Uint256) = caller()
        return (expr)
    end
end

func __warp_block_54{range_check_ptr, syscall_ptr : felt*}(
        match_var : Uint256, var_refundReceiver : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr : Uint256) = __warp_if_35(__warp_subexpr_0, var_refundReceiver)
    return (expr)
end

func __warp_block_53{range_check_ptr, syscall_ptr : felt*}(var_refundReceiver : Uint256) -> (
        expr : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_zero(var_refundReceiver)
    let (expr : Uint256) = __warp_block_54(match_var, var_refundReceiver)
    return (expr)
end

func __warp_block_61{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = uint256_mload(Uint256(low=0, high=0))
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(usr_success)
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    let (var_transferred : Uint256) = is_zero(__warp_subexpr_0)
    return (var_transferred)
end

func __warp_if_38{bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_transferred : Uint256) = __warp_block_61(usr_success)
        return (var_transferred)
    else:
        let var_transferred : Uint256 = Uint256(low=0, high=0)
        return (var_transferred)
    end
end

func __warp_block_60{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=32, high=0))
    let (var_transferred : Uint256) = __warp_if_38(__warp_subexpr_0, usr_success)
    return (var_transferred)
end

func __warp_if_37{bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, match_var : Uint256, usr_success : Uint256) -> (
        var_transferred : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let var_transferred : Uint256 = usr_success
        return (var_transferred)
    else:
        let (var_transferred : Uint256) = __warp_block_60(match_var, usr_success)
        return (var_transferred)
    end
end

func __warp_block_59{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_transferred : Uint256) = __warp_if_37(__warp_subexpr_0, match_var, usr_success)
    return (var_transferred)
end

func __warp_block_58{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(usr_success : Uint256) -> (var_transferred : Uint256):
    alloc_locals
    let (match_var : Uint256) = returndata_size()
    let (var_transferred : Uint256) = __warp_block_59(match_var, usr_success)
    return (var_transferred)
end

func __warp_block_57{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_gasToken : Uint256, var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (var_payment : Uint256) = fun_mul_17612(var_gasUsed)
    let (expr_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (_1 : Uint256) = u256_add(expr_mpos, Uint256(low=32, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=224668671643508016486903311432943665152))
    let (__warp_subexpr_0 : Uint256) = u256_add(expr_mpos, Uint256(low=36, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=expr)
    let (__warp_subexpr_1 : Uint256) = u256_add(expr_mpos, Uint256(low=68, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=var_payment)
    uint256_mstore(offset=expr_mpos, value=Uint256(low=68, high=0))
    finalize_allocation_17613(expr_mpos)
    let (__warp_subexpr_4 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_3 : Uint256) = uint256_mload(expr_mpos)
    let (__warp_subexpr_2 : Uint256) = u256_add(
        __warp_subexpr_4,
        Uint256(low=340282366920938463463374607431768201456, high=340282366920938463463374607431768211455))
    let (usr_success : Uint256) = warp_call(
        __warp_subexpr_2,
        var_gasToken,
        Uint256(low=0, high=0),
        _1,
        __warp_subexpr_3,
        Uint256(low=0, high=0),
        Uint256(low=32, high=0))
    let (var_transferred : Uint256) = __warp_block_58(usr_success)
    require_helper_stringliteral_74ed(var_transferred)
    return (var_payment)
end

func __warp_if_39(__warp_subexpr_0 : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (expr_1 : Uint256) = __warp_constant_10()
        return (expr_1)
    else:
        let expr_1 : Uint256 = Uint256(low=1, high=0)
        return (expr_1)
    end
end

func __warp_block_64{range_check_ptr}(match_var : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (expr_1 : Uint256) = __warp_if_39(__warp_subexpr_0)
    return (expr_1)
end

func __warp_block_63{range_check_ptr}() -> (expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10()
    let (match_var : Uint256) = is_lt(Uint256(low=1, high=0), __warp_subexpr_0)
    let (expr_1 : Uint256) = __warp_block_64(match_var)
    return (expr_1)
end

func __warp_if_40(_2 : Uint256, __warp_subexpr_0 : Uint256) -> (_2 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let _2 : Uint256 = Uint256(low=2300, high=0)
        return (_2)
    else:
        return (_2)
    end
end

func __warp_block_62{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, syscall_ptr : felt*}(expr : Uint256, var_gasUsed : Uint256) -> (
        var_payment : Uint256):
    alloc_locals
    let (expr_1 : Uint256) = __warp_block_63()
    let (var_payment : Uint256) = fun_mul(var_gasUsed, expr_1)
    let _2 : Uint256 = Uint256(low=0, high=0)
    let (__warp_subexpr_0 : Uint256) = is_zero(var_payment)
    let (_2 : Uint256) = __warp_if_40(_2, __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = warp_call(
        _2,
        expr,
        var_payment,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    require_helper_stringliteral_4353(__warp_subexpr_1)
    return (var_payment)
end

func __warp_if_36{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, expr : Uint256, var_gasToken : Uint256,
        var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (var_payment : Uint256) = __warp_block_57(expr, var_gasToken, var_gasUsed)
        return (var_payment)
    else:
        let (var_payment : Uint256) = __warp_block_62(expr, var_gasUsed)
        return (var_payment)
    end
end

func __warp_block_56{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, match_var : Uint256, var_gasToken : Uint256, var_gasUsed : Uint256) -> (
        var_payment : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    let (var_payment : Uint256) = __warp_if_36(__warp_subexpr_0, expr, var_gasToken, var_gasUsed)
    return (var_payment)
end

func __warp_block_55{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_gasToken : Uint256, var_gasUsed : Uint256) -> (var_payment : Uint256):
    alloc_locals
    let (match_var : Uint256) = is_zero(var_gasToken)
    let (var_payment : Uint256) = __warp_block_56(expr, match_var, var_gasToken, var_gasUsed)
    return (var_payment)
end

func fun_handlePayment_11024{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_gasUsed : Uint256, var_gasToken : Uint256, var_refundReceiver : Uint256) -> (
        var_payment : Uint256):
    alloc_locals
    let (expr : Uint256) = __warp_block_53(var_refundReceiver)
    let (var_payment : Uint256) = __warp_block_55(expr, var_gasToken, var_gasUsed)
    return (var_payment)
end

func __warp_if_41{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_12 : Uint256, var_fallbackHandler : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_12.low + __warp_subexpr_12.high != 0:
        fun_internalSetFallbackHandler(var_fallbackHandler)
        return ()
    else:
        return ()
    end
end

func __warp_block_65{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_payment : Uint256, var_paymentReceiver : Uint256, var_paymentToken : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = fun_handlePayment_11024(
        var_payment, var_paymentToken, var_paymentReceiver)

    return ()
end

func __warp_if_42{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_16 : Uint256, var_payment : Uint256, var_paymentReceiver : Uint256,
        var_paymentToken : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_16.low + __warp_subexpr_16.high != 0:
        __warp_block_65(var_payment, var_paymentReceiver, var_paymentToken)
        return ()
    else:
        return ()
    end
end

func fun_setup{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_owners_offset : Uint256, var_owners_length : Uint256, var_threshold : Uint256,
        var_to : Uint256, var_data_1272_offset : Uint256, var_data_1272_length : Uint256,
        var_fallbackHandler : Uint256, var_paymentToken : Uint256, var_payment : Uint256,
        var_paymentReceiver : Uint256) -> ():
    alloc_locals
    let (_1 : Uint256) = array_allocation_size_array_address_dyn(var_owners_length)
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr, _1)
    uint256_mstore(offset=memPtr, value=var_owners_length)
    let (dst : Uint256) = u256_add(memPtr, Uint256(low=32, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_shl(Uint256(low=5, high=0), var_owners_length)
    let (srcEnd : Uint256) = u256_add(var_owners_offset, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = is_gt(srcEnd, __warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let src : Uint256 = var_owners_offset
    let (dst : Uint256, src : Uint256) = __warp_loop_5(Uint256(low=32, high=0), dst, src, srcEnd)
    let (__warp_subexpr_4 : Uint256) = sload(Uint256(low=4, high=0))
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    require_helper_stringliteral_3a32(__warp_subexpr_3)
    let (__warp_subexpr_7 : Uint256) = uint256_mload(memPtr)
    let (__warp_subexpr_6 : Uint256) = is_gt(var_threshold, __warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = is_zero(__warp_subexpr_6)
    require_helper_stringliteral_2ed3(__warp_subexpr_5)
    let (__warp_subexpr_9 : Uint256) = is_lt(var_threshold, Uint256(low=1, high=0))
    let (__warp_subexpr_8 : Uint256) = is_zero(__warp_subexpr_9)
    require_helper_stringliteral_a5f8(__warp_subexpr_8)
    let var_currentOwner : Uint256 = Uint256(low=1, high=0)
    let (var_currentOwner : Uint256, var_i : Uint256) = __warp_loop_6(
        Uint256(low=1, high=0), memPtr, var_currentOwner, Uint256(low=0, high=0))
    let (
        __warp_subexpr_10 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_currentOwner)
    update_storage_value_offsett_address_to_address_11021(__warp_subexpr_10)
    let (__warp_subexpr_11 : Uint256) = uint256_mload(memPtr)
    update_storage_value_offsett_address_to_address(__warp_subexpr_11)
    update_storage_value_offsett_address_to_address_11023(var_threshold)
    let (__warp_subexpr_13 : Uint256) = is_zero(var_fallbackHandler)
    let (__warp_subexpr_12 : Uint256) = is_zero(__warp_subexpr_13)
    __warp_if_41(__warp_subexpr_12, var_fallbackHandler)
    let (__warp_subexpr_15 : Uint256) = calldatasize()
    let (__warp_subexpr_14 : Uint256) = abi_decode_available_length_bytes(
        var_data_1272_offset, var_data_1272_length, __warp_subexpr_15)
    fun_setupModules(var_to, __warp_subexpr_14)
    let (__warp_subexpr_17 : Uint256) = is_zero(var_payment)
    let (__warp_subexpr_16 : Uint256) = is_zero(__warp_subexpr_17)
    __warp_if_42(__warp_subexpr_16, var_payment, var_paymentReceiver, var_paymentToken)
    return ()
end

func abi_decode_addresst_uint256t_bytes_calldatat_enum_Operation{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256, value4 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value2_1 : Uint256, value3_1 : Uint256) = abi_decode_bytes_calldata(
        __warp_subexpr_3, dataEnd)
    let value2 : Uint256 = value2_1
    let value3 : Uint256 = value3_1
    let (value : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_5 : Uint256) = is_lt(value, Uint256(low=2, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value4 : Uint256 = value
    return (value0, value1, value2, value3, value4)
end

func finalize_allocation_17610{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256) -> ():
    alloc_locals
    let (newFreePtr : Uint256) = u256_add(memPtr, Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = is_lt(newFreePtr, memPtr)
    let (__warp_subexpr_1 : Uint256) = is_gt(newFreePtr, Uint256(low=18446744073709551615, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, __warp_subexpr_2)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func fun_requiredTxGas{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_1867_offset : Uint256,
        var_data_1867_length : Uint256, var_operation : Uint256) -> (var : Uint256):
    alloc_locals
    let (expr : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_4 : Uint256) = calldatasize()
    let (__warp_subexpr_3 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_2 : Uint256) = abi_decode_available_length_bytes(
        var_data_1867_offset, var_data_1867_length, __warp_subexpr_4)
    let (__warp_subexpr_1 : Uint256) = fun_execute(
        var_to, var_value, __warp_subexpr_2, var_operation, __warp_subexpr_3)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (_1 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (__warp_subexpr_5 : Uint256) = is_lt(expr, _1)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (expr_1904_mpos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_sub(expr, _1)
    let (__warp_subexpr_6 : Uint256) = u256_add(expr_1904_mpos, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_6, value=__warp_subexpr_7)
    uint256_mstore(offset=expr_1904_mpos, value=Uint256(low=32, high=0))
    finalize_allocation_17610(expr_1904_mpos)
    let (_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_2, value=Uint256(low=0, high=11648788701761662505209215850878337024))
    let (__warp_subexpr_8 : Uint256) = u256_add(_2, Uint256(low=4, high=0))
    uint256_mstore(offset=__warp_subexpr_8, value=Uint256(low=32, high=0))
    let (__warp_subexpr_11 : Uint256) = u256_add(_2, Uint256(low=36, high=0))
    let (__warp_subexpr_10 : Uint256) = abi_encode_bytes_memory_ptr(
        expr_1904_mpos, __warp_subexpr_11)
    assert 0 = 1
    jmp rel 0
end

func __warp_block_66{range_check_ptr}(_1 : Uint256, var_currentModule : Uint256) -> (
        expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_currentModule, _1)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_43{range_check_ptr}(_1 : Uint256, expr : Uint256, var_currentModule : Uint256) -> (
        expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_66(_1, var_currentModule)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_if_44{range_check_ptr}(
        expr : Uint256, expr_1 : Uint256, var_moduleCount : Uint256, var_pageSize : Uint256) -> (
        expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr_1 : Uint256) = is_lt(var_moduleCount, var_pageSize)
        return (expr_1)
    else:
        return (expr_1)
    end
end

func __warp_loop_body_2{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, __warp_break_2 : Uint256,
        var_array_mpos : Uint256, var_currentModule : Uint256, var_moduleCount : Uint256,
        var_pageSize : Uint256) -> (
        __warp_break_2 : Uint256, var_currentModule : Uint256, var_moduleCount : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(var_currentModule)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_43(_1, expr, var_currentModule)
    let expr_1 : Uint256 = expr
    let (expr_1 : Uint256) = __warp_if_44(expr, expr_1, var_moduleCount, var_pageSize)
    let (__warp_subexpr_1 : Uint256) = is_zero(expr_1)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        let __warp_break_2 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_2, var_currentModule, var_moduleCount)
    end
    let (__warp_subexpr_2 : Uint256) = memory_array_index_access_address_dyn(
        var_array_mpos, var_moduleCount)
    uint256_mstore(offset=__warp_subexpr_2, value=var_currentModule)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_currentModule)
    uint256_mstore(offset=_2, value=_1)
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), _3)
    let (var_currentModule : Uint256) = sload(__warp_subexpr_3)
    let (var_moduleCount : Uint256) = increment_uint256(var_moduleCount)
    return (__warp_break_2, var_currentModule, var_moduleCount)
end

func __warp_loop_2{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, var_array_mpos : Uint256,
        var_currentModule : Uint256, var_moduleCount : Uint256, var_pageSize : Uint256) -> (
        var_currentModule : Uint256, var_moduleCount : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_currentModule, var_moduleCount)
    end
    let (__warp_break_2 : Uint256, var_currentModule : Uint256,
        var_moduleCount : Uint256) = __warp_loop_body_2(
        _1,
        _2,
        _3,
        Uint256(low=0, high=0),
        var_array_mpos,
        var_currentModule,
        var_moduleCount,
        var_pageSize)
    let (var_currentModule : Uint256, var_moduleCount : Uint256) = __warp_loop_2(
        _1, _2, _3, var_array_mpos, var_currentModule, var_moduleCount, var_pageSize)
    return (var_currentModule, var_moduleCount)
end

func fun_getModulesPaginated{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_start : Uint256, var_pageSize : Uint256) -> (
        var_array_mpos : Uint256, var_next : Uint256):
    alloc_locals
    let (var_array_mpos : Uint256) = allocate_and_zero_memory_array_array_address_dyn(var_pageSize)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_start)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (var_currentModule : Uint256) = sload(__warp_subexpr_0)
    let (var_currentModule : Uint256, var_moduleCount : Uint256) = __warp_loop_2(
        Uint256(low=1, high=0),
        Uint256(low=32, high=0),
        Uint256(low=64, high=0),
        var_array_mpos,
        var_currentModule,
        Uint256(low=0, high=0),
        var_pageSize)
    let var_next : Uint256 = var_currentModule
    uint256_mstore(offset=var_array_mpos, value=Uint256(low=0, high=0))
    return (var_array_mpos, var_next)
end

func abi_encode_array_address_dyn_address{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256) -> (tail : Uint256):
    alloc_locals
    uint256_mstore(offset=headStart, value=Uint256(low=64, high=0))
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    let (tail : Uint256) = abi_encode_array_address_dyn(value0, __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=value1)
    return (tail)
end

func fun_approveHash{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_hashToApprove : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = caller()
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_0)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_4 : Uint256) = caller()
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_4)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=8, high=0))
    let (_2 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_hashToApprove)
    uint256_mstore(offset=Uint256(low=32, high=0), value=_2)
    let (__warp_subexpr_5 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    sstore(key=__warp_subexpr_5, value=Uint256(low=1, high=0))
    return ()
end

func abi_decode_addresst_uint256t_bytes_calldatat_enum_Operationt_uint256t_uint256t_uint256t_addresst_addresst_uint256{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256, value4 : Uint256,
        value5 : Uint256, value6 : Uint256, value7 : Uint256, value8 : Uint256, value9 : Uint256,
        value10 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=320, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (offset : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_2 : Uint256) = is_gt(offset, Uint256(low=18446744073709551615, high=0))
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(Uint256(low=4, high=0), offset)
    let (value2_1 : Uint256, value3_1 : Uint256) = abi_decode_bytes_calldata(
        __warp_subexpr_3, dataEnd)
    let value2 : Uint256 = value2_1
    let value3 : Uint256 = value3_1
    let (value : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_5 : Uint256) = is_lt(value, Uint256(low=2, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value4 : Uint256 = value
    let (value5 : Uint256) = calldataload(Uint256(low=132, high=0))
    let (value6 : Uint256) = calldataload(Uint256(low=164, high=0))
    let (value7 : Uint256) = calldataload(Uint256(low=196, high=0))
    let (value8 : Uint256) = calldataload(Uint256(low=228, high=0))
    let (value9 : Uint256) = calldataload(Uint256(low=260, high=0))
    let (value10 : Uint256) = calldataload(Uint256(low=292, high=0))
    return (value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
end

func fun_getTransactionHash{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_value : Uint256, var_data_2034_offset : Uint256,
        var_data_2034_length : Uint256, var_operation : Uint256, var_safeTxGas : Uint256,
        var_baseGas : Uint256, var_gasPrice : Uint256, var_gasToken : Uint256,
        var_refundReceiver : Uint256, var_nonce : Uint256) -> (var : Uint256):
    alloc_locals
    let (expr_2066_mpos : Uint256) = fun_encodeTransactionData(
        var_to,
        var_value,
        var_data_2034_offset,
        var_data_2034_length,
        var_operation,
        var_safeTxGas,
        var_baseGas,
        var_gasPrice,
        var_gasToken,
        var_refundReceiver,
        var_nonce)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(expr_2066_mpos)
    let (__warp_subexpr_0 : Uint256) = u256_add(expr_2066_mpos, Uint256(low=32, high=0))
    let (var : Uint256) = uint256_sha(__warp_subexpr_0, __warp_subexpr_1)
    return (var)
end

func __warp_block_67{range_check_ptr}(var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_module, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_45{range_check_ptr}(expr : Uint256, var_module : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_67(var_module)
        return (expr)
    else:
        return (expr)
    end
end

func modifier_authorized_171{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_prevModule : Uint256, var_module : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_0 : Uint256) = is_zero(var_module)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_45(expr, var_module)
    require_helper_stringliteral_eab5(expr)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_prevModule)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=1, high=0))
    let (__warp_subexpr_4 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = sload(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = is_eq(__warp_subexpr_3, var_module)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (
        __warp_subexpr_7 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10962(
        var_module)
    let (__warp_subexpr_6 : Uint256) = sload(__warp_subexpr_7)
    let (
        __warp_subexpr_5 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10962(
        var_prevModule)
    sstore(key=__warp_subexpr_5, value=__warp_subexpr_6)
    let (
        __warp_subexpr_8 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10962(
        var_module)
    sstore(key=__warp_subexpr_8, value=Uint256(low=0, high=0))
    return ()
end

func __warp_block_69{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1, __warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = returndata_size()
    let (__warp_subexpr_3 : Uint256) = u256_add(_1, __warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, _1)
    let (__warp_subexpr_1 : Uint256) = slt(__warp_subexpr_2, Uint256(low=32, high=0))
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value : Uint256) = uint256_mload(_1)
    let (__warp_subexpr_8 : Uint256) = is_zero(value)
    let (__warp_subexpr_7 : Uint256) = is_zero(__warp_subexpr_8)
    let (__warp_subexpr_6 : Uint256) = is_eq(value, __warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = is_zero(__warp_subexpr_6)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = value
    return (expr)
end

func __warp_if_47{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256, _2 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _2.low + _2.high != 0:
        let (expr : Uint256) = __warp_block_69(_1)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_68{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(var_guard : Uint256) -> ():
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=2657353690144770786078675143579664384))
    let (__warp_subexpr_0 : Uint256) = u256_add(_1, Uint256(low=4, high=0))
    uint256_mstore(
        offset=__warp_subexpr_0,
        value=Uint256(low=0, high=306842194895162478015972484139026743296))
    let (__warp_subexpr_1 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2 : Uint256) = staticcall(
        __warp_subexpr_1, var_guard, _1, Uint256(low=36, high=0), _1, Uint256(low=32, high=0))
    let (__warp_subexpr_2 : Uint256) = is_zero(_2)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = Uint256(low=0, high=0)
    let (expr : Uint256) = __warp_if_47(_1, _2, expr)
    let (__warp_subexpr_3 : Uint256) = is_zero(expr)
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_if_46{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_guard : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_68(var_guard)
        return ()
    else:
        return ()
    end
end

func modifier_authorized{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_guard : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_1 : Uint256) = is_zero(var_guard)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    __warp_if_46(__warp_subexpr_0, var_guard)
    sstore(
        key=Uint256(low=121816481939259035148028565361356715208, high=98530635266159011945338023816300572120),
        value=var_guard)
    return ()
end

func abi_decode_addresst_addresst_address{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=96, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    return (value0, value1, value2)
end

func require_helper_stringliteral_f86d{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_70{range_check_ptr}(var_newOwner : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_newOwner, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_48{range_check_ptr}(expr : Uint256, var_newOwner : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_70(var_newOwner)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_71{range_check_ptr, syscall_ptr : felt*}(var_newOwner : Uint256) -> (
        expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = address()
    let (__warp_subexpr_0 : Uint256) = is_eq(var_newOwner, __warp_subexpr_1)
    let (expr_1 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_1)
end

func __warp_if_49{range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, expr_1 : Uint256, var_newOwner : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr_1 : Uint256) = __warp_block_71(var_newOwner)
        return (expr_1)
    else:
        return (expr_1)
    end
end

func __warp_block_72{range_check_ptr}(var_oldOwner : Uint256) -> (expr_2 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_oldOwner, Uint256(low=1, high=0))
    let (expr_2 : Uint256) = is_zero(__warp_subexpr_0)
    return (expr_2)
end

func __warp_if_50{range_check_ptr}(expr_2 : Uint256, var_oldOwner : Uint256) -> (expr_2 : Uint256):
    alloc_locals
    if expr_2.low + expr_2.high != 0:
        let (expr_2 : Uint256) = __warp_block_72(var_oldOwner)
        return (expr_2)
    else:
        return (expr_2)
    end
end

func modifier_authorized_655{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_prevOwner : Uint256, var_oldOwner : Uint256, var_newOwner : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (__warp_subexpr_0 : Uint256) = is_zero(var_newOwner)
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    let (expr : Uint256) = __warp_if_48(expr, var_newOwner)
    let expr_1 : Uint256 = expr
    let (expr_1 : Uint256) = __warp_if_49(expr, expr_1, var_newOwner)
    require_helper_stringliteral_3d41(expr_1)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_newOwner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    require_helper_stringliteral_bd32(__warp_subexpr_1)
    let (__warp_subexpr_4 : Uint256) = is_zero(var_oldOwner)
    let (expr_2 : Uint256) = is_zero(__warp_subexpr_4)
    let (expr_2 : Uint256) = __warp_if_50(expr_2, var_oldOwner)
    require_helper_stringliteral_3d41(expr_2)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_prevOwner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_6 : Uint256) = sload(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = is_eq(__warp_subexpr_6, var_oldOwner)
    require_helper_stringliteral_f86d(__warp_subexpr_5)
    let (
        __warp_subexpr_10 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_oldOwner)
    let (__warp_subexpr_9 : Uint256) = sload(__warp_subexpr_10)
    let (
        __warp_subexpr_8 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_newOwner)
    sstore(key=__warp_subexpr_8, value=__warp_subexpr_9)
    let (
        __warp_subexpr_11 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_prevOwner)
    sstore(key=__warp_subexpr_11, value=var_newOwner)
    let (
        __warp_subexpr_12 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_oldOwner)
    sstore(key=__warp_subexpr_12, value=Uint256(low=0, high=0))
    return ()
end

func modifier_authorized_864{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_handler : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    sstore(
        key=Uint256(low=87825846081101499500981431604900075733, high=144358433641795870133215269870563063761),
        value=var_handler)
    return ()
end

func decrement_uint256{range_check_ptr}(value : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(value)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (ret__warp_mangled : Uint256) = u256_add(
        value,
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455))
    return (ret__warp_mangled)
end

func __warp_block_73{range_check_ptr}(var_owner : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(var_owner, Uint256(low=1, high=0))
    let (expr : Uint256) = is_zero(__warp_subexpr_0)
    return (expr)
end

func __warp_if_51{range_check_ptr}(expr : Uint256, var_owner : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_73(var_owner)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_if_52{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_14 : Uint256, var_threshold : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_14.low + __warp_subexpr_14.high != 0:
        modifier_authorized_742(var_threshold)
        return ()
    else:
        return ()
    end
end

func modifier_authorized_583{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_prevOwner : Uint256, var_owner : Uint256, var_threshold : Uint256) -> ():
    alloc_locals
    fun_requireSelfCall()
    let (_1 : Uint256) = sload(Uint256(low=3, high=0))
    let (__warp_subexpr_0 : Uint256) = is_lt(_1, Uint256(low=1, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_3 : Uint256) = u256_add(
        _1,
        Uint256(low=340282366920938463463374607431768211455, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_2 : Uint256) = is_lt(__warp_subexpr_3, var_threshold)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    require_helper_stringliteral_2ed3(__warp_subexpr_1)
    let (__warp_subexpr_4 : Uint256) = is_zero(var_owner)
    let (expr : Uint256) = is_zero(__warp_subexpr_4)
    let (expr : Uint256) = __warp_if_51(expr, var_owner)
    require_helper_stringliteral_3d41(expr)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_prevOwner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_7 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_6 : Uint256) = sload(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = is_eq(__warp_subexpr_6, var_owner)
    require_helper_stringliteral_f86d(__warp_subexpr_5)
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_owner)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_10 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_9 : Uint256) = sload(__warp_subexpr_10)
    let (
        __warp_subexpr_8 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_prevOwner)
    sstore(key=__warp_subexpr_8, value=__warp_subexpr_9)
    let (
        __warp_subexpr_11 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10982(
        var_owner)
    sstore(key=__warp_subexpr_11, value=Uint256(low=0, high=0))
    let (__warp_subexpr_13 : Uint256) = sload(Uint256(low=3, high=0))
    let (__warp_subexpr_12 : Uint256) = decrement_uint256(__warp_subexpr_13)
    update_storage_value_offsett_address_to_address(__warp_subexpr_12)
    let (__warp_subexpr_16 : Uint256) = sload(Uint256(low=4, high=0))
    let (__warp_subexpr_15 : Uint256) = is_eq(__warp_subexpr_16, var_threshold)
    let (__warp_subexpr_14 : Uint256) = is_zero(__warp_subexpr_15)
    __warp_if_52(__warp_subexpr_14, var_threshold)
    return ()
end

func copy_literal_to_memory_6a08c3e203132c561752255a4d52ffae85bb9c5d33cb3291520dea1b84356389{
        bitwise_ptr : BitwiseBuiltin*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr : Uint256):
    alloc_locals
    let (memPtr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation_17610(memPtr_1)
    uint256_mstore(offset=memPtr_1, value=Uint256(low=5, high=0))
    let memPtr : Uint256 = memPtr_1
    let (__warp_subexpr_0 : Uint256) = u256_add(memPtr_1, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=Uint256(low='', high='1.3.0' * 256 ** 11))
    return (memPtr)
end

func __warp_if_53{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        warp_return(Uint256(low=0, high=0), Uint256(low=0, high=0))
        return ()
    else:
        return ()
    end
end

func fun{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (usr_handler : Uint256) = sload(
        Uint256(low=87825846081101499500981431604900075733, high=144358433641795870133215269870563063761))
    let (__warp_subexpr_0 : Uint256) = is_zero(usr_handler)
    __warp_if_53(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    calldatacopy(Uint256(low=0, high=0), Uint256(low=0, high=0), __warp_subexpr_1)
    let (__warp_subexpr_4 : Uint256) = caller()
    let (__warp_subexpr_3 : Uint256) = u256_shl(Uint256(low=96, high=0), __warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    uint256_mstore(offset=__warp_subexpr_2, value=__warp_subexpr_3)
    let (__warp_subexpr_7 : Uint256) = calldatasize()
    let (__warp_subexpr_6 : Uint256) = u256_add(__warp_subexpr_7, Uint256(low=20, high=0))
    let (__warp_subexpr_5 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (usr_success : Uint256) = warp_call(
        __warp_subexpr_5,
        usr_handler,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0),
        __warp_subexpr_6,
        Uint256(low=0, high=0),
        Uint256(low=0, high=0))
    let (__warp_subexpr_8 : Uint256) = returndata_size()
    returndata_copy(Uint256(low=0, high=0), Uint256(low=0, high=0), __warp_subexpr_8)
    let (__warp_subexpr_9 : Uint256) = is_zero(usr_success)
    if __warp_subexpr_9.low + __warp_subexpr_9.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_10 : Uint256) = returndata_size()
    warp_return(Uint256(low=0, high=0), __warp_subexpr_10)
    return ()
end

func __warp_block_76{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    modifier_authorized_513(param, param_1)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_78{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_2 : Uint256, param_3 : Uint256, param_4 : Uint256,
        param_5 : Uint256) = abi_decode_bytes32t_bytest_bytest_uint256(__warp_subexpr_0)
    fun_checkNSignatures(param_2, param_3, param_4, param_5)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_80{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret__warp_mangled : Uint256) = fun_isModuleEnabled(__warp_subexpr_0)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    warp_return(memPos, __warp_subexpr_2)
    return ()
end

func __warp_block_82{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret_1 : Uint256) = fun_isOwner(__warp_subexpr_0)
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_bool(memPos_1, ret_1)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_1)
    warp_return(memPos_1, __warp_subexpr_2)
    return ()
end

func __warp_block_84{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = __warp_constant_1()
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_2, __warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    warp_return(memPos_2, __warp_subexpr_1)
    return ()
end

func __warp_block_86{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_6 : Uint256, param_7 : Uint256, param_8 : Uint256,
        param_9 : Uint256) = abi_decode_addresst_uint256t_bytest_enum_Operation(__warp_subexpr_0)
    let (ret_2 : Uint256) = fun_execTransactionFromModule(param_6, param_7, param_8, param_9)
    let (memPos_3 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_3, ret_2)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_3)
    warp_return(memPos_3, __warp_subexpr_1)
    return ()
end

func __warp_block_88{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_10 : Uint256, param_11 : Uint256, param_12 : Uint256,
        param_13 : Uint256) = abi_decode_addresst_uint256t_bytest_enum_Operation(__warp_subexpr_0)
    let (ret_3 : Uint256, ret_4 : Uint256) = fun_execTransactionFromModuleReturnData(
        param_10, param_11, param_12, param_13)
    let (memPos_4 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool_bytes(memPos_4, ret_3, ret_4)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_4)
    warp_return(memPos_4, __warp_subexpr_1)
    return ()
end

func __warp_block_90{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_14 : Uint256, param_15 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (ret_5 : Uint256) = fun_getStorageAt(param_14, param_15)
    let (memPos_5 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bytes(memPos_5, ret_5)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_5)
    warp_return(memPos_5, __warp_subexpr_1)
    return ()
end

func __warp_block_92{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret_6 : Uint256) = getter_fun_signedMessages(__warp_subexpr_0)
    let (memPos_6 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_6, ret_6)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_6)
    warp_return(memPos_6, __warp_subexpr_2)
    return ()
end

func __warp_block_94{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    modifier_authorized_121(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_2, Uint256(low=0, high=0))
    return ()
end

func __warp_block_96{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    modifier_authorized_742(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_2, Uint256(low=0, high=0))
    return ()
end

func __warp_block_98{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_16 : Uint256, param_17 : Uint256, param_18 : Uint256, param_19 : Uint256,
        param_20 : Uint256, param_21 : Uint256, param_22 : Uint256, param_23 : Uint256,
        param_24 : Uint256, param_25 : Uint256,
        param_26 : Uint256) = abi_decode_addresst_uint256t_bytes_calldatat_enum_Operationt_uint256t_uint256t_uint256t_addresst_address_payablet_bytes(
        __warp_subexpr_0)
    let (ret_7 : Uint256) = fun_execTransaction(
        param_16,
        param_17,
        param_18,
        param_19,
        param_20,
        param_21,
        param_22,
        param_23,
        param_24,
        param_25,
        param_26)
    let (memPos_7 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_7, ret_7)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_7)
    warp_return(memPos_7, __warp_subexpr_1)
    return ()
end

func __warp_block_100{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_27 : Uint256, param_28 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (
        __warp_subexpr_2 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32_10938(
        param_27)
    let (__warp_subexpr_1 : Uint256) = mapping_index_access_mapping_bytes32_uint256_of_bytes32(
        __warp_subexpr_2, param_28)
    let (value : Uint256) = sload(__warp_subexpr_1)
    let (memPos_8 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_4 : Uint256) = abi_encode_uint256(memPos_8, value)
    let (__warp_subexpr_3 : Uint256) = uint256_sub(__warp_subexpr_4, memPos_8)
    warp_return(memPos_8, __warp_subexpr_3)
    return ()
end

func __warp_block_102{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_29 : Uint256, param_30 : Uint256,
        param_31 : Uint256) = abi_decode_bytes32t_bytest_bytes(__warp_subexpr_0)
    fun_checkSignatures(param_29, param_30, param_31)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_104{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (ret_8 : Uint256) = fun_getOwners()
    let (memPos_9 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_array_address_dyn_memory_ptr(memPos_9, ret_8)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_9)
    warp_return(memPos_9, __warp_subexpr_1)
    return ()
end

func __warp_block_106{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (ret_9 : Uint256) = sload(Uint256(low=5, high=0))
    let (memPos_10 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_10, ret_9)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_10)
    warp_return(memPos_10, __warp_subexpr_1)
    return ()
end

func __warp_block_109{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_34 : Uint256, param_35 : Uint256, param_36 : Uint256, param_37 : Uint256,
        param_38 : Uint256, param_39 : Uint256, param_40 : Uint256, param_41 : Uint256,
        param_42 : Uint256,
        param_43 : Uint256) = abi_decode_array_address_dyn_calldatat_uint256t_addresst_bytes_calldatat_addresst_addresst_uint256t_address_payable(
        __warp_subexpr_0)
    fun_setup(
        param_34,
        param_35,
        param_36,
        param_37,
        param_38,
        param_39,
        param_40,
        param_41,
        param_42,
        param_43)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_111{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_44 : Uint256, param_45 : Uint256, param_46 : Uint256, param_47 : Uint256,
        param_48 : Uint256) = abi_decode_addresst_uint256t_bytes_calldatat_enum_Operation(
        __warp_subexpr_0)
    let (ret_10 : Uint256) = fun_requiredTxGas(param_44, param_45, param_46, param_47, param_48)
    let (memPos_11 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_11, ret_10)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_11)
    warp_return(memPos_11, __warp_subexpr_1)
    return ()
end

func __warp_block_113{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_49 : Uint256, param_50 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (ret_11 : Uint256, ret_12 : Uint256) = fun_getModulesPaginated(param_49, param_50)
    let (memPos_12 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_array_address_dyn_address(
        memPos_12, ret_11, ret_12)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_12)
    warp_return(memPos_12, __warp_subexpr_1)
    return ()
end

func __warp_block_115{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    fun_approveHash(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_2, Uint256(low=0, high=0))
    return ()
end

func __warp_block_117{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_51 : Uint256, param_52 : Uint256, param_53 : Uint256, param_54 : Uint256,
        param_55 : Uint256, param_56 : Uint256, param_57 : Uint256, param_58 : Uint256,
        param_59 : Uint256, param_60 : Uint256,
        param_61 : Uint256) = abi_decode_addresst_uint256t_bytes_calldatat_enum_Operationt_uint256t_uint256t_uint256t_addresst_addresst_uint256(
        __warp_subexpr_0)
    let (ret_13 : Uint256) = fun_getTransactionHash(
        param_51,
        param_52,
        param_53,
        param_54,
        param_55,
        param_56,
        param_57,
        param_58,
        param_59,
        param_60,
        param_61)
    let (memPos_13 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_13, ret_13)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_13)
    warp_return(memPos_13, __warp_subexpr_1)
    return ()
end

func __warp_block_119{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_62 : Uint256, param_63 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    modifier_authorized_171(param_62, param_63)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_121{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    modifier_authorized(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_2, Uint256(low=0, high=0))
    return ()
end

func __warp_block_123{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_64 : Uint256, param_65 : Uint256,
        param_66 : Uint256) = abi_decode_addresst_addresst_address(__warp_subexpr_0)
    modifier_authorized_655(param_64, param_65, param_66)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_125{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (_1 : Uint256) = sload(Uint256(low=4, high=0))
    let (memPos_14 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_14, _1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_14)
    warp_return(memPos_14, __warp_subexpr_1)
    return ()
end

func __warp_block_127{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_67 : Uint256, param_68 : Uint256, param_69 : Uint256, param_70 : Uint256,
        param_71 : Uint256, param_72 : Uint256, param_73 : Uint256, param_74 : Uint256,
        param_75 : Uint256, param_76 : Uint256,
        param_77 : Uint256) = abi_decode_addresst_uint256t_bytes_calldatat_enum_Operationt_uint256t_uint256t_uint256t_addresst_addresst_uint256(
        __warp_subexpr_0)
    let (ret_14 : Uint256) = fun_encodeTransactionData(
        param_67,
        param_68,
        param_69,
        param_70,
        param_71,
        param_72,
        param_73,
        param_74,
        param_75,
        param_76,
        param_77)
    let (memPos_15 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bytes(memPos_15, ret_14)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_15)
    warp_return(memPos_15, __warp_subexpr_1)
    return ()
end

func __warp_block_129{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    modifier_authorized_864(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_2, Uint256(low=0, high=0))
    return ()
end

func __warp_block_131{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (ret_15 : Uint256) = fun_domainSeparator()
    let (memPos_16 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_16, ret_15)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_16)
    warp_return(memPos_16, __warp_subexpr_1)
    return ()
end

func __warp_block_133{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_78 : Uint256, param_79 : Uint256,
        param_80 : Uint256) = abi_decode_addresst_addresst_address(__warp_subexpr_0)
    modifier_authorized_583(param_78, param_79, param_80)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_135{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode_10929(__warp_subexpr_0)
    let (
        ret_mpos : Uint256) = copy_literal_to_memory_6a08c3e203132c561752255a4d52ffae85bb9c5d33cb3291520dea1b84356389(
        )
    let (memPos_17 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bytes(memPos_17, ret_mpos)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_17)
    warp_return(memPos_17, __warp_subexpr_1)
    return ()
end

func __warp_if_84{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_135()
        return ()
    else:
        return ()
    end
end

func __warp_block_134{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4288785780, high=0))
    __warp_if_84(__warp_subexpr_0)
    return ()
end

func __warp_if_83{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_133()
        return ()
    else:
        __warp_block_134(match_var)
        return ()
    end
end

func __warp_block_132{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4175191513, high=0))
    __warp_if_83(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_82{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_131()
        return ()
    else:
        __warp_block_132(match_var)
        return ()
    end
end

func __warp_block_130{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4137212453, high=0))
    __warp_if_82(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_81{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_129()
        return ()
    else:
        __warp_block_130(match_var)
        return ()
    end
end

func __warp_block_128{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4035576611, high=0))
    __warp_if_81(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_80{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_127()
        return ()
    else:
        __warp_block_128(match_var)
        return ()
    end
end

func __warp_block_126{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3899013083, high=0))
    __warp_if_80(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_79{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_125()
        return ()
    else:
        __warp_block_126(match_var)
        return ()
    end
end

func __warp_block_124{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3880924600, high=0))
    __warp_if_79(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_78{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_123()
        return ()
    else:
        __warp_block_124(match_var)
        return ()
    end
end

func __warp_block_122{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3810047275, high=0))
    __warp_if_78(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_77{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_121()
        return ()
    else:
        __warp_block_122(match_var)
        return ()
    end
end

func __warp_block_120{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3785006553, high=0))
    __warp_if_77(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_76{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_119()
        return ()
    else:
        __warp_block_120(match_var)
        return ()
    end
end

func __warp_block_118{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3758739422, high=0))
    __warp_if_76(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_75{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_117()
        return ()
    else:
        __warp_block_118(match_var)
        return ()
    end
end

func __warp_block_116{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3637583736, high=0))
    __warp_if_75(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_74{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_115()
        return ()
    else:
        __warp_block_116(match_var)
        return ()
    end
end

func __warp_block_114{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3571039693, high=0))
    __warp_if_74(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_73{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_113()
        return ()
    else:
        __warp_block_114(match_var)
        return ()
    end
end

func __warp_block_112{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3425666130, high=0))
    __warp_if_73(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_72{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_111()
        return ()
    else:
        __warp_block_112(match_var)
        return ()
    end
end

func __warp_block_110{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3301587612, high=0))
    __warp_if_72(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_71{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_109()
        return ()
    else:
        __warp_block_110(match_var)
        return ()
    end
end

func __warp_block_108{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3057549325, high=0))
    __warp_if_71(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_107{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3036330505, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        __warp_block_108(match_var)
        return ()
    end
end

func __warp_if_70{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_106()
        return ()
    else:
        __warp_block_107(match_var)
        return ()
    end
end

func __warp_block_105{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2952712416, high=0))
    __warp_if_70(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_69{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_104()
        return ()
    else:
        __warp_block_105(match_var)
        return ()
    end
end

func __warp_block_103{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2699460139, high=0))
    __warp_if_69(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_68{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_102()
        return ()
    else:
        __warp_block_103(match_var)
        return ()
    end
end

func __warp_block_101{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2471442961, high=0))
    __warp_if_68(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_67{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_100()
        return ()
    else:
        __warp_block_101(match_var)
        return ()
    end
end

func __warp_block_99{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2105747828, high=0))
    __warp_if_67(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_66{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_98()
        return ()
    else:
        __warp_block_99(match_var)
        return ()
    end
end

func __warp_block_97{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1786122754, high=0))
    __warp_if_66(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_65{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_96()
        return ()
    else:
        __warp_block_97(match_var)
        return ()
    end
end

func __warp_block_95{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1766752451, high=0))
    __warp_if_65(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_64{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_94()
        return ()
    else:
        __warp_block_95(match_var)
        return ()
    end
end

func __warp_block_93{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1628133669, high=0))
    __warp_if_64(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_63{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_92()
        return ()
    else:
        __warp_block_93(match_var)
        return ()
    end
end

func __warp_block_91{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1525071159, high=0))
    __warp_if_63(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_62{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_90()
        return ()
    else:
        __warp_block_91(match_var)
        return ()
    end
end

func __warp_block_89{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1445245531, high=0))
    __warp_if_62(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_61{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_88()
        return ()
    else:
        __warp_block_89(match_var)
        return ()
    end
end

func __warp_block_87{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1378420543, high=0))
    __warp_if_61(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_60{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_86()
        return ()
    else:
        __warp_block_87(match_var)
        return ()
    end
end

func __warp_block_85{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1183261095, high=0))
    __warp_if_60(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_59{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_84()
        return ()
    else:
        __warp_block_85(match_var)
        return ()
    end
end

func __warp_block_83{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=872998000, high=0))
    __warp_if_59(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_58{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_82()
        return ()
    else:
        __warp_block_83(match_var)
        return ()
    end
end

func __warp_block_81{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=794083182, high=0))
    __warp_if_58(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_57{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_80()
        return ()
    else:
        __warp_block_81(match_var)
        return ()
    end
end

func __warp_block_79{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=765121853, high=0))
    __warp_if_57(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_56{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_78()
        return ()
    else:
        __warp_block_79(match_var)
        return ()
    end
end

func __warp_block_77{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=318466272, high=0))
    __warp_if_56(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_55{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_76()
        return ()
    else:
        __warp_block_77(match_var)
        return ()
    end
end

func __warp_block_75{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=223883027, high=0))
    __warp_if_55(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_74{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_75(match_var)
    return ()
end

func __warp_if_54{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        termination_token}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_74()
        return ()
    else:
        return ()
    end
end

func __warp_if_85{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, termination_token}(__warp_subexpr_3 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        warp_return(Uint256(low=0, high=0), Uint256(low=0, high=0))
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
    __warp_if_54(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    let (__warp_subexpr_4 : Uint256) = calldatasize()
    let (__warp_subexpr_3 : Uint256) = is_zero(__warp_subexpr_4)
    __warp_if_85(__warp_subexpr_3)
    if termination_token == 1:
        return ()
    end
    let (__warp_subexpr_5 : Uint256) = __warp_constant_0()
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    fun()
    if termination_token == 1:
        return ()
    end
    warp_return(Uint256(low=0, high=0), Uint256(low=0, high=0))
    return ()
end

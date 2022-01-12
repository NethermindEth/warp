%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import staticcall, warp_call, warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_or, uint256_sub

func __warp_identity_Uint256(arg0 : Uint256) -> (arg0 : Uint256):
    return (arg0)
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
end

func __warp_constant_10000000000000000000000000000000000000000() -> (res : Uint256):
    return (Uint256(low=131811359292784559562136384478721867776, high=29))
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
func __main{bitwise_ptr : BitwiseBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> (
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
    let (__warp_subexpr_0 : Uint256) = __warp_identity_Uint256(Uint256(low=128, high=0))
    uint256_mstore(offset=Uint256(low=64, high=0), value=__warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = __warp_constant_0()
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
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
    let (__warp_subexpr_2 : Uint256) = uint256_or(__warp_subexpr_3, __warp_subexpr_4)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    uint256_mstore(offset=Uint256(low=64, high=0), value=newFreePtr)
    return ()
end

func abi_decode_bool_fromMemory{
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
    let (__warp_subexpr_5 : Uint256) = is_zero(value)
    let (__warp_subexpr_4 : Uint256) = is_zero(__warp_subexpr_5)
    let (__warp_subexpr_3 : Uint256) = is_eq(value, __warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value0 : Uint256 = value
    return (value0)
end

func __warp_block_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, __warp_subexpr_2)
    let (expr : Uint256) = abi_decode_bool_fromMemory(_1, __warp_subexpr_1)
    return (expr)
end

func __warp_if_0{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256, _2 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _2.low + _2.high != 0:
        let (expr : Uint256) = __warp_block_0(_1)
        return (expr)
    else:
        return (expr)
    end
end

func fun_sendMoneyz{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(
        var_contract_addr : Uint256, var_from : Uint256, var_to : Uint256,
        var_amount : Uint256) -> (var : Uint256):
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=47480692178561195778129796594248187904))
    let (__warp_subexpr_0 : Uint256) = u256_add(_1, Uint256(low=4, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=var_from)
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, Uint256(low=36, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=var_to)
    let (__warp_subexpr_2 : Uint256) = u256_add(_1, Uint256(low=68, high=0))
    uint256_mstore(offset=__warp_subexpr_2, value=var_amount)
    let (__warp_subexpr_3 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2 : Uint256) = warp_call(
        __warp_subexpr_3,
        var_contract_addr,
        Uint256(low=0, high=0),
        _1,
        Uint256(low=100, high=0),
        _1,
        Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(_2)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = Uint256(low=0, high=0)
    let (expr : Uint256) = __warp_if_0(_1, _2, expr)
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

func abi_decode_addresst_address{
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

func __warp_block_1{
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
    let (expr : Uint256) = uint256_mload(_1)
    return (expr)
end

func __warp_if_1{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256, _2 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _2.low + _2.high != 0:
        let (expr : Uint256) = __warp_block_1(_1)
        return (expr)
    else:
        return (expr)
    end
end

func fun_checkMoneyz{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(var_addr : Uint256, var_to : Uint256) -> (
        var_ : Uint256):
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=149706943620704588101898925390394556416))
    let (__warp_subexpr_0 : Uint256) = u256_add(_1, Uint256(low=4, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=var_to)
    let (__warp_subexpr_1 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2 : Uint256) = staticcall(
        __warp_subexpr_1, var_addr, _1, Uint256(low=36, high=0), _1, Uint256(low=32, high=0))
    let (__warp_subexpr_2 : Uint256) = is_zero(_2)
    if __warp_subexpr_2.low + __warp_subexpr_2.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = Uint256(low=0, high=0)
    let (expr : Uint256) = __warp_if_1(_1, _2, expr)
    let var_ : Uint256 = expr
    return (var_)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=headStart, value=value0)
    return (tail)
end

func __warp_block_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, __warp_subexpr_2)
    let (expr : Uint256) = abi_decode_bool_fromMemory(_1, __warp_subexpr_1)
    return (expr)
end

func __warp_if_2{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr}(_1 : Uint256, _2 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _2.low + _2.high != 0:
        let (expr : Uint256) = __warp_block_2(_1)
        return (expr)
    else:
        return (expr)
    end
end

func fun_gimmeMoney{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*}(var_add : Uint256, var_to : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=86073011240779955229814836696849580032))
    let (__warp_subexpr_0 : Uint256) = u256_add(_1, Uint256(low=4, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=var_to)
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, Uint256(low=36, high=0))
    uint256_mstore(offset=__warp_subexpr_1, value=Uint256(low=42, high=0))
    let (__warp_subexpr_2 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2 : Uint256) = warp_call(
        __warp_subexpr_2,
        var_add,
        Uint256(low=0, high=0),
        _1,
        Uint256(low=68, high=0),
        _1,
        Uint256(low=32, high=0))
    let (__warp_subexpr_3 : Uint256) = is_zero(_2)
    if __warp_subexpr_3.low + __warp_subexpr_3.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = Uint256(low=0, high=0)
    let (expr : Uint256) = __warp_if_2(_1, _2, expr)
    let var : Uint256 = expr
    return (var)
end

func __warp_block_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_6 : Uint256) = calldataload(Uint256(low=100, high=0))
    let (__warp_subexpr_5 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (__warp_subexpr_4 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (__warp_subexpr_3 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (ret__warp_mangled : Uint256) = fun_sendMoneyz(
        __warp_subexpr_3, __warp_subexpr_4, __warp_subexpr_5, __warp_subexpr_6)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_8 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    let (__warp_subexpr_7 : Uint256) = uint256_sub(__warp_subexpr_8, memPos)
    warp_return(memPos, __warp_subexpr_7)
    return ()
end

func __warp_block_7{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256) = abi_decode_addresst_address(__warp_subexpr_0)
    let (ret_1 : Uint256) = fun_checkMoneyz(param, param_1)
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    warp_return(memPos_1, __warp_subexpr_1)
    return ()
end

func __warp_block_9{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_2 : Uint256, param_3 : Uint256) = abi_decode_addresst_address(__warp_subexpr_0)
    let (ret_2 : Uint256) = fun_gimmeMoney(param_2, param_3)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    warp_return(memPos_2, __warp_subexpr_1)
    return ()
end

func __warp_if_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9()
        return ()
    else:
        return ()
    end
end

func __warp_block_8{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3747097146, high=0))
    __warp_if_3(__warp_subexpr_0)
    return ()
end

func __warp_if_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7()
        return ()
    else:
        __warp_block_8(match_var)
        return ()
    end
end

func __warp_block_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1506652845, high=0))
    __warp_if_4(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_5{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
        return ()
    else:
        __warp_block_6(match_var)
        return ()
    end
end

func __warp_block_4{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=762392335, high=0))
    __warp_if_5(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_3{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_4(match_var)
    return ()
end

func __warp_if_6{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_1 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        __warp_block_3()
        return ()
    else:
        return ()
    end
end

func __main_meat{
        bitwise_ptr : BitwiseBuiltin*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        msize, range_check_ptr, syscall_ptr : felt*, termination_token}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = __warp_identity_Uint256(Uint256(low=128, high=0))
    uint256_mstore(offset=Uint256(low=64, high=0), value=__warp_subexpr_0)
    let (__warp_subexpr_3 : Uint256) = calldatasize()
    let (__warp_subexpr_2 : Uint256) = is_lt(__warp_subexpr_3, Uint256(low=4, high=0))
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    __warp_if_6(__warp_subexpr_1)
    if termination_token == 1:
        return ()
    end
    assert 0 = 1
    jmp rel 0
end

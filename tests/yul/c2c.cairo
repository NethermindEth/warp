%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write, warp_call, warp_static_call
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_sub

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
end

func __warp_constant_10000000000000000000000000000000000000000() -> (res : Uint256):
    return (Uint256(low=131811359292784559562136384478721867776, high=29))
end

func abi_decode_addresst_addresst_addresst_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(dataEnd : Uint256) -> (
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
    let (value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (value3 : Uint256) = calldataload(Uint256(low=100, high=0))
    return (value0, value1, value2, value3)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_6 : Uint256, pos_7 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_7, value=value_6)
    return ()
end

func abi_encode_address_address_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_27 : Uint256, value0_28 : Uint256, value1_29 : Uint256, value2_30 : Uint256) -> (
        tail_31 : Uint256):
    alloc_locals
    let (tail_31 : Uint256) = u256_add(headStart_27, Uint256(low=96, high=0))
    abi_encode_uint256_to_uint256(value0_28, headStart_27)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart_27, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256(value1_29, __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = u256_add(headStart_27, Uint256(low=64, high=0))
    abi_encode_uint256_to_uint256(value2_30, __warp_subexpr_1)
    return (tail_31)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
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

func validator_revert_bool{range_check_ptr}(value_11 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = is_zero(value_11)
    let (__warp_subexpr_2 : Uint256) = is_zero(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_eq(value_11, __warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset : Uint256) -> (value_12 : Uint256):
    alloc_locals
    let (value_12 : Uint256) = uint256_mload(offset)
    validator_revert_bool(value_12)
    return (value_12)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_13 : Uint256, dataEnd_14 : Uint256) -> (value0_15 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd_14, headStart_13)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_15 : Uint256) = abi_decode_t_bool_fromMemory(headStart_13)
    return (value0_15)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_34 : Uint256) -> (expr_36 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1_34, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_1_34, __warp_subexpr_2)
    let (expr_36 : Uint256) = abi_decode_bool_fromMemory(_1_34, __warp_subexpr_1)
    return (expr_36)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_34 : Uint256, _2_35 : Uint256, expr_36 : Uint256) -> (expr_36 : Uint256):
    alloc_locals
    if _2_35.low + _2_35.high != 0:
        let (expr_36 : Uint256) = __warp_block_0(_1_34)
        return (expr_36)
    else:
        return (expr_36)
    end
end

func fun_sendMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_contract_addr : Uint256, var_from : Uint256, var_to_32 : Uint256,
        var_amount : Uint256) -> (var_33 : Uint256):
    alloc_locals
    let (_1_34 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1_34, value=Uint256(low=0, high=47480692178561195778129796594248187904))
    let (__warp_subexpr_3 : Uint256) = u256_add(_1_34, Uint256(low=4, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_address_address_uint256(
        __warp_subexpr_3, var_from, var_to_32, var_amount)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, _1_34)
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2_35 : Uint256) = warp_call(
        __warp_subexpr_0,
        var_contract_addr,
        Uint256(low=0, high=0),
        _1_34,
        __warp_subexpr_1,
        _1_34,
        Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(_2_35)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr_36 : Uint256 = Uint256(low=0, high=0)
    let (expr_36 : Uint256) = __warp_if_0(_1_34, _2_35, expr_36)
    let var_33 : Uint256 = expr_36
    return (var_33)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_zero(value)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    uint256_mstore(offset=pos, value=__warp_subexpr_0)
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_1 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    abi_encode_bool_to_bool(value0_1, headStart)
    return (tail)
end

func abi_decode_addresst_address{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_2 : Uint256) -> (value0_3 : Uint256, value1_4 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_2,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_3 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1_4 : Uint256) = calldataload(Uint256(low=36, high=0))
    return (value0_3, value1_4)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, value0_9 : Uint256) -> (tail_10 : Uint256):
    alloc_locals
    let (tail_10 : Uint256) = u256_add(headStart_8, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256(value0_9, headStart_8)
    return (tail_10)
end

func abi_decode_uint256_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_20 : Uint256, dataEnd_21 : Uint256) -> (value0_22 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd_21, headStart_20)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_22 : Uint256) = uint256_mload(headStart_20)
    return (value0_22)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_24 : Uint256) -> (expr_26 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1_24, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_1_24, __warp_subexpr_2)
    let (expr_26 : Uint256) = abi_decode_uint256_fromMemory(_1_24, __warp_subexpr_1)
    return (expr_26)
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_24 : Uint256, _2_25 : Uint256, expr_26 : Uint256) -> (expr_26 : Uint256):
    alloc_locals
    if _2_25.low + _2_25.high != 0:
        let (expr_26 : Uint256) = __warp_block_1(_1_24)
        return (expr_26)
    else:
        return (expr_26)
    end
end

func fun_checkMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_addr : Uint256, var_to_23 : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (_1_24 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1_24, value=Uint256(low=0, high=149706943620704588101898925390394556416))
    let (__warp_subexpr_3 : Uint256) = u256_add(_1_24, Uint256(low=4, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(__warp_subexpr_3, var_to_23)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, _1_24)
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2_25 : Uint256) = warp_static_call(
        __warp_subexpr_0, var_addr, _1_24, __warp_subexpr_1, _1_24, Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(_2_25)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr_26 : Uint256 = Uint256(low=0, high=0)
    let (expr_26 : Uint256) = __warp_if_1(_1_24, _2_25, expr_26)
    let var_ : Uint256 = expr_26
    return (var_)
end

func abi_encode_uint256_to_uint256_793{memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_5 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_5, value=Uint256(low=42, high=0))
    return ()
end

func abi_encode_address_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_16 : Uint256, value0_17 : Uint256) -> (tail_18 : Uint256):
    alloc_locals
    let (tail_18 : Uint256) = u256_add(headStart_16, Uint256(low=64, high=0))
    abi_encode_uint256_to_uint256(value0_17, headStart_16)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart_16, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256_793(__warp_subexpr_0)
    return (tail_18)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = returndata_size()
    finalize_allocation(_1, __warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = returndata_size()
    let (__warp_subexpr_1 : Uint256) = u256_add(_1, __warp_subexpr_2)
    let (expr : Uint256) = abi_decode_bool_fromMemory(_1, __warp_subexpr_1)
    return (expr)
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _2 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _2.low + _2.high != 0:
        let (expr : Uint256) = __warp_block_2(_1)
        return (expr)
    else:
        return (expr)
    end
end

func fun_gimmeMoney{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_add : Uint256, var_to : Uint256) -> (var : Uint256):
    alloc_locals
    let (_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    uint256_mstore(offset=_1, value=Uint256(low=0, high=86073011240779955229814836696849580032))
    let (__warp_subexpr_3 : Uint256) = u256_add(_1, Uint256(low=4, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_address_rational_by(__warp_subexpr_3, var_to)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, _1)
    let (__warp_subexpr_0 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (_2 : Uint256) = warp_call(
        __warp_subexpr_0,
        var_add,
        Uint256(low=0, high=0),
        _1,
        __warp_subexpr_1,
        _1,
        Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = is_zero(_2)
    if __warp_subexpr_4.low + __warp_subexpr_4.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let expr : Uint256 = Uint256(low=0, high=0)
    let (expr : Uint256) = __warp_if_2(_1, _2, expr)
    let var : Uint256 = expr
    return (var)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256, param_2 : Uint256,
        param_3 : Uint256) = abi_decode_addresst_addresst_addresst_uint256(__warp_subexpr_0)
    let (ret__warp_mangled : Uint256) = fun_sendMoneyz(param, param_1, param_2, param_3)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos)
    returndata_write(memPos, __warp_subexpr_1)
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_4 : Uint256, param_5 : Uint256) = abi_decode_addresst_address(__warp_subexpr_0)
    let (ret_1 : Uint256) = fun_checkMoneyz(param_4, param_5)
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    returndata_write(memPos_1, __warp_subexpr_1)
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_6 : Uint256, param_7 : Uint256) = abi_decode_addresst_address(__warp_subexpr_0)
    let (ret_2 : Uint256) = fun_gimmeMoney(param_6, param_7)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    returndata_write(memPos_2, __warp_subexpr_1)
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9()
        return ()
    else:
        return ()
    end
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3747097146, high=0))
    __warp_if_6(__warp_subexpr_0)
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1506652845, high=0))
    __warp_if_5(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(__warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=762392335, high=0))
    __warp_if_4(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_4(match_var)
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(__warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*) -> (
        success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let (__fp__, _) = get_fp_and_pc()
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        __warp_if_3(__warp_subexpr_0)
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

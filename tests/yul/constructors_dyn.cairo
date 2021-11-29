%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_sub

func sload{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(key : Uint256) -> (
        value : Uint256):
    let (value) = evm_storage.read(key.low, key.high)
    return (value)
end

func sstore{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key : Uint256, value : Uint256):
    evm_storage.write(key.low, key.high, value)
    return ()
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func evm_storage(arg0_low, arg0_high) -> (res : Uint256):
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

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr : Uint256):
    alloc_locals
    let (memPtr : Uint256) = uint256_mload(Uint256(low=64, high=0))
    finalize_allocation(memPtr, size)
    return (memPtr)
end

func abi_decode_struct_Person{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, end__warp_mangled : Uint256) -> (value : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(end__warp_mangled, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value : Uint256) = allocate_memory(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = calldataload(headStart)
    uint256_mstore(offset=value, value=__warp_subexpr_2)
    let (__warp_subexpr_5 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (__warp_subexpr_4 : Uint256) = calldataload(__warp_subexpr_5)
    let (__warp_subexpr_3 : Uint256) = u256_add(value, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_3, value=__warp_subexpr_4)
    return (value)
end

func abi_decode_addresst_struct_Persont_uint256{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(headStart)
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (value1 : Uint256) = abi_decode_struct_Person(__warp_subexpr_2, dataEnd)
    let (__warp_subexpr_3 : Uint256) = u256_add(headStart, Uint256(low=96, high=0))
    let (value2 : Uint256) = calldataload(__warp_subexpr_3)
    return (value0, value1, value2)
end

func copy_arguments_for_constructor_object_WARP{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ret_param : Uint256, ret_param_1 : Uint256, ret_param_2 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (ret_param_3 : Uint256, ret_param_4 : Uint256,
        ret_param_5 : Uint256) = abi_decode_addresst_struct_Persont_uint256(
        Uint256(low=0, high=0), __warp_subexpr_0)
    let ret_param : Uint256 = ret_param_3
    let ret_param_1 : Uint256 = ret_param_4
    let ret_param_2 : Uint256 = ret_param_5
    return (ret_param, ret_param_1, ret_param_2)
end

func update_byte_slice_shift(value : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    let result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_address_to_address{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        slot : Uint256, value : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = sload(slot)
    let (__warp_subexpr_0 : Uint256) = update_byte_slice_shift(__warp_subexpr_1, value)
    sstore(key=slot, value=__warp_subexpr_0)
    return ()
end

func cleanup_uint256_deployment(value : Uint256) -> (cleaned : Uint256):
    alloc_locals
    let cleaned : Uint256 = value
    return (cleaned)
end

func constructor_WARP{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_owner : Uint256, var_person_mpos : Uint256, var_ownerCellNumber : Uint256) -> ():
    alloc_locals
    update_storage_value_offsett_address_to_address(Uint256(low=0, high=0), var_owner)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(var_person_mpos)
    let (__warp_subexpr_0 : Uint256) = cleanup_uint256_deployment(__warp_subexpr_1)
    update_storage_value_offsett_address_to_address(Uint256(low=1, high=0), __warp_subexpr_0)
    update_storage_value_offsett_address_to_address(Uint256(low=2, high=0), var_ownerCellNumber)
    return ()
end

@constructor
func constructor{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    let termination_token = 0
    let (returndata_ptr : felt*) = alloc()
    let (__fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with memory_dict, msize, exec_env, termination_token:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_0 : Uint256) = __warp_constant_0()
        if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
            assert 0 = 1
            jmp rel 0
        end
        let (_1 : Uint256, _2 : Uint256, _3 : Uint256) = copy_arguments_for_constructor_object_WARP(
            )
        constructor_WARP(_1, _2, _3)
        return ()
    end
end

func abi_decode_struct_Person_calldata{range_check_ptr}(
        offset : Uint256, end__warp_mangled : Uint256) -> (value : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(end__warp_mangled, offset)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let value : Uint256 = offset
    return (value)
end

func abi_decode_addresst_struct_Person_calldatat_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_sub(dataEnd, headStart)
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0 : Uint256) = calldataload(headStart)
    let (__warp_subexpr_2 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    let (value1 : Uint256) = abi_decode_struct_Person_calldata(__warp_subexpr_2, dataEnd)
    let (__warp_subexpr_3 : Uint256) = u256_add(headStart, Uint256(low=96, high=0))
    let (value2 : Uint256) = calldataload(__warp_subexpr_3)
    return (value0, value1, value2)
end

func cleanup_uint256(value : Uint256) -> (cleaned : Uint256):
    alloc_locals
    let cleaned : Uint256 = value
    return (cleaned)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_person_offset : Uint256) -> (expr : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = sload(Uint256(low=1, high=0))
    let (_1 : Uint256) = cleanup_uint256(__warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = calldataload(var_person_offset)
    let (expr : Uint256) = is_eq(_1, __warp_subexpr_1)
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(expr : Uint256, var_person_offset : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr : Uint256) = __warp_block_0(var_person_offset)
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_1{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_ownerCellNumberCheck : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=2, high=0))
    let (__warp_subexpr_0 : Uint256) = cleanup_uint256(__warp_subexpr_1)
    let (expr_1 : Uint256) = is_eq(__warp_subexpr_0, var_ownerCellNumberCheck)
    return (expr_1)
end

func __warp_if_1{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, expr_1 : Uint256, var_ownerCellNumberCheck : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (expr_1 : Uint256) = __warp_block_1(var_ownerCellNumberCheck)
        return (expr_1)
    else:
        return (expr_1)
    end
end

func fun_validate_constructor{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_ownerCheck : Uint256, var_person_offset : Uint256,
        var_ownerCellNumberCheck : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=0, high=0))
    let (__warp_subexpr_0 : Uint256) = cleanup_uint256(__warp_subexpr_1)
    let (expr : Uint256) = is_eq(__warp_subexpr_0, var_ownerCheck)
    let (expr : Uint256) = __warp_if_0(expr, var_person_offset)
    let expr_1 : Uint256 = expr
    let (expr_1 : Uint256) = __warp_if_1(expr, expr_1, var_ownerCellNumberCheck)
    let var : Uint256 = expr_1
    return (var)
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
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    abi_encode_bool_to_bool(value0, headStart)
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

func extract_from_storage_value_dynamict_uint256{range_check_ptr}(
        slot_value : Uint256, offset : Uint256) -> (value : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = u256_shl(Uint256(low=3, high=0), offset)
    let (value : Uint256) = u256_shr(__warp_subexpr_0, slot_value)
    return (value)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value)
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256(value0, headStart)
    return (tail)
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256,
        param_2 : Uint256) = abi_decode_addresst_struct_Person_calldatat_uint256(
        Uint256(low=4, high=0), __warp_subexpr_0)
    let (__warp_subexpr_3 : Uint256) = fun_validate_constructor(param, param_1, param_2)
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(Uint256(low=128, high=0), __warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211328, high=340282366920938463463374607431768211455))
    warp_return(Uint256(low=128, high=0), __warp_subexpr_1)
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(Uint256(low=4, high=0), __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=2, high=0))
    let (ret__warp_mangled : Uint256) = extract_from_storage_value_dynamict_uint256(
        __warp_subexpr_1, Uint256(low=0, high=0))
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    warp_return(memPos, __warp_subexpr_2)
    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(Uint256(low=4, high=0), __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=0, high=0))
    let (ret_1 : Uint256) = extract_from_storage_value_dynamict_uint256(
        __warp_subexpr_1, Uint256(low=0, high=0))
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_1)
    warp_return(memPos_1, __warp_subexpr_2)
    return ()
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(Uint256(low=4, high=0), __warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=1, high=0))
    let (ret_2 : Uint256) = extract_from_storage_value_dynamict_uint256(
        __warp_subexpr_1, Uint256(low=0, high=0))
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_2, ret_2)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_2)
    warp_return(memPos_2, __warp_subexpr_2)
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10()
        return ()
    else:
        return ()
    end
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2647152338, high=0))
    __warp_if_6(__warp_subexpr_0)
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8()
        return ()
    else:
        __warp_block_9(match_var)
        return ()
    end
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
    __warp_if_5(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1104667242, high=0))
    __warp_if_4(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4()
        return ()
    else:
        __warp_block_5(match_var)
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=898672770, high=0))
    __warp_if_3(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_3(match_var)
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_2()
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*) -> (
        returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let termination_token = 0
    let (__fp__, _) = get_fp_and_pc()
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env = &exec_env_
    let (memory_dict) = default_dict_new(0)
    let memory_dict_start = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict, termination_token:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        __warp_if_2(__warp_subexpr_0)
        if termination_token == 1:
            default_dict_finalize(memory_dict_start, memory_dict, 0)
            return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
        end
        assert 0 = 1
        jmp rel 0
    end
end

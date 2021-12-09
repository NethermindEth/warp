%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_not, uint256_sub

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

@storage_var
func balanceOf(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func evm_storage(arg0_low, arg0_high) -> (res : Uint256):
end

func abi_decode{range_check_ptr}(dataEnd : Uint256) -> ():
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

func extract_from_storage_value_dynamict_uint256(slot_value : Uint256) -> (value : Uint256):
    alloc_locals
    let value : Uint256 = slot_value
    return (value)
end

func abi_encode_uint256_to_uint256_1010{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_2 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=128, high=0), value=value_2)
    return ()
end

func abi_encode_uint256_440{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let tail : Uint256 = Uint256(low=160, high=0)
    abi_encode_uint256_to_uint256_1010(value0)
    return (tail)
end

func extract_from_storage_value_dynamict_uint8{range_check_ptr}(slot_value_6 : Uint256) -> (
        value_7 : Uint256):
    alloc_locals
    let (value_7 : Uint256) = uint256_and(slot_value_6, Uint256(low=255, high=0))
    return (value_7)
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_8 : Uint256, pos_9 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_and(value_8, Uint256(low=255, high=0))
    uint256_mstore(offset=pos_9, value=__warp_subexpr_0)
    return ()
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_10 : Uint256, value0_11 : Uint256) -> (tail_12 : Uint256):
    alloc_locals
    let (tail_12 : Uint256) = u256_add(headStart_10, Uint256(low=32, high=0))
    abi_encode_uint8_to_uint8(value0_11, headStart_10)
    return (tail_12)
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_13 : Uint256) -> (value0_14 : Uint256, value1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_13,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_14 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    return (value0_14, value1)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key_25 : Uint256) -> (dataSlot_26 : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key_25)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (dataSlot_26 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot_26)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(slot : Uint256) -> (
        value_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = sload(slot)
    let (value_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_0)
    return (value_1)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_sub_uint256{range_check_ptr}(x_33 : Uint256, y_34 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_lt(x_33, y_34)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (diff : Uint256) = uint256_sub(x_33, y_34)
    return (diff)
end

func update_byte_slice_shift(value_29 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    let result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        slot_30 : Uint256, value_31 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = sload(slot_30)
    let (__warp_subexpr_0 : Uint256) = update_byte_slice_shift(__warp_subexpr_1, value_31)
    sstore(key=slot_30, value=__warp_subexpr_0)
    return ()
end

func fun_withdraw{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_wad : Uint256, var_sender_35 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_sender_35)
    let (__warp_subexpr_2 : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, var_wad)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    require_helper(__warp_subexpr_0)
    let (_1_36 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_sender_35)
    let (__warp_subexpr_6 : Uint256) = sload(_1_36)
    let (__warp_subexpr_5 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_6)
    let (__warp_subexpr_4 : Uint256) = checked_sub_uint256(__warp_subexpr_5, var_wad)
    update_storage_value_offsett_uint256_to_uint256(_1_36, __warp_subexpr_4)
    return ()
end

func abi_decode_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_15 : Uint256) -> (value0_16 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_15,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_16 : Uint256) = calldataload(Uint256(low=4, high=0))
    return (value0_16)
end

func fun_get_balance{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src_40 : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_src_40)
    let (var : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_0)
    return (var)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_3 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_3)
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_4 : Uint256) -> (tail_5 : Uint256):
    alloc_locals
    let (tail_5 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256(value0_4, headStart)
    return (tail_5)
end

func abi_decode_uint256t_uint256t_uint256t_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(dataEnd_17 : Uint256) -> (
        value0_18 : Uint256, value1_19 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_17,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_18 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1_19 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    let (value3 : Uint256) = calldataload(Uint256(low=100, high=0))
    return (value0_18, value1_19, value2, value3)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_not(y)
    let (__warp_subexpr_0 : Uint256) = is_gt(x, __warp_subexpr_1)
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(x, y)
    return (sum)
end

func __warp_block_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src : Uint256, var_wad_37 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_src)
    let (__warp_subexpr_2 : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, var_wad_37)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    require_helper(__warp_subexpr_0)
    return ()
end

func __warp_if_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_src : Uint256, var_wad_37 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0(var_src, var_wad_37)
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad_37 : Uint256, var_sender_38 : Uint256) -> (
        var_ : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_eq(var_src, var_sender_38)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    __warp_if_0(__warp_subexpr_0, var_src, var_wad_37)
    let (_1_39 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_src)
    let (__warp_subexpr_4 : Uint256) = sload(_1_39)
    let (__warp_subexpr_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = checked_sub_uint256(__warp_subexpr_3, var_wad_37)
    update_storage_value_offsett_uint256_to_uint256(_1_39, __warp_subexpr_2)
    let (_2 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_dst)
    let (__warp_subexpr_7 : Uint256) = sload(_2)
    let (__warp_subexpr_6 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = checked_add_uint256(__warp_subexpr_6, var_wad_37)
    update_storage_value_offsett_uint256_to_uint256(_2, __warp_subexpr_5)
    let var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_20 : Uint256, pos_21 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_zero(value_20)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    uint256_mstore(offset=pos_21, value=__warp_subexpr_0)
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_22 : Uint256, value0_23 : Uint256) -> (tail_24 : Uint256):
    alloc_locals
    let (tail_24 : Uint256) = u256_add(headStart_22, Uint256(low=32, high=0))
    abi_encode_bool_to_bool(value0_23, headStart_22)
    return (tail_24)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256_448{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key_27 : Uint256) -> (ret_28 : Uint256):
    alloc_locals
    let (ret_28) = balanceOf.read(key_27.low, key_27.high)
    return (ret_28)
end

func fun_deposit{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_sender : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (_1_32 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_sender)
    let (__warp_subexpr_2 : Uint256) = sload(_1_32)
    let (__warp_subexpr_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = checked_add_uint256(__warp_subexpr_1, var_value)
    update_storage_value_offsett_uint256_to_uint256(_1_32, __warp_subexpr_0)
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = sload(Uint256(low=1, high=0))
    let (__warp_subexpr_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256_440(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211328, high=340282366920938463463374607431768211455))
    warp_return(Uint256(low=128, high=0), __warp_subexpr_1)
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=0, high=0))
    let (ret__warp_mangled : Uint256) = extract_from_storage_value_dynamict_uint8(__warp_subexpr_1)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint8(memPos, ret__warp_mangled)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    warp_return(memPos, __warp_subexpr_2)
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256) = abi_decode_uint256t_uint256(__warp_subexpr_0)
    fun_withdraw(param, param_1)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_uint256(__warp_subexpr_1)
    let (ret_1 : Uint256) = fun_get_balance(__warp_subexpr_0)
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_1)
    warp_return(memPos_1, __warp_subexpr_2)
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_2 : Uint256, param_3 : Uint256, param_4 : Uint256,
        param_5 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256(__warp_subexpr_0)
    let (ret_2 : Uint256) = fun_transferFrom(param_2, param_3, param_4, param_5)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    warp_return(memPos_2, __warp_subexpr_1)
    return ()
end

func __warp_block_13{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_uint256(__warp_subexpr_1)
    let (ret_3 : Uint256) = getter_fun_balanceOf(__warp_subexpr_0)
    let (memPos_3 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_3, ret_3)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_3)
    warp_return(memPos_3, __warp_subexpr_2)
    return ()
end

func __warp_block_15{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_6 : Uint256, param_7 : Uint256) = abi_decode_uint256t_uint256(__warp_subexpr_0)
    fun_deposit(param_6, param_7)
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    warp_return(__warp_subexpr_1, Uint256(low=0, high=0))
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_15()
        return ()
    else:
        return ()
    end
end

func __warp_block_14{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3803951448, high=0))
    __warp_if_8(__warp_subexpr_0)
    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13()
        return ()
    else:
        __warp_block_14(match_var)
        return ()
    end
end

func __warp_block_12{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2630350600, high=0))
    __warp_if_7(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11()
        return ()
    else:
        __warp_block_12(match_var)
        return ()
    end
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    __warp_if_6(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9()
        return ()
    else:
        __warp_block_10(match_var)
        return ()
    end
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1530952232, high=0))
    __warp_if_5(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1142570608, high=0))
    __warp_if_4(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    __warp_if_3(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
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
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    __warp_if_2(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_2(match_var)
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_1()
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
        __warp_if_1(__warp_subexpr_0)
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

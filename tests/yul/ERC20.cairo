%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, caller, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_sub

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
func balances(arg0_low, arg0_high) -> (res : Uint256):
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

func extract_from_storage_value_dynamict_uint256(slot_value : Uint256) -> (value_14 : Uint256):
    alloc_locals
    let value_14 : Uint256 = slot_value
    return (value_14)
end

func abi_encode_uint256_to_uint256_949{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=Uint256(low=128, high=0), value=value)
    return ()
end

func abi_encode_uint256_428{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let tail : Uint256 = Uint256(low=160, high=0)
    abi_encode_uint256_to_uint256_949(value0)
    return (tail)
end

func abi_decode_addresst_addresst_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_4 : Uint256) -> (value0_5 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_4,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=96, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_5 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    let (value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    return (value0_5, value1, value2)
end

func mapping_index_access_mapping_address_uint256_of_address{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key_21 : Uint256) -> (dataSlot_22 : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key_21)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    let (dataSlot_22 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot_22)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(slot : Uint256) -> (
        value_15 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = sload(slot)
    let (value_15 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_0)
    return (value_15)
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

func update_byte_slice_shift(value_25 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    let result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        slot_26 : Uint256, value_27 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = sload(slot_26)
    let (__warp_subexpr_0 : Uint256) = update_byte_slice_shift(__warp_subexpr_1, value_27)
    sstore(key=slot_26, value=__warp_subexpr_0)
    return ()
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

func fun_transfer{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_sender_34 : Uint256, var_recipient_35 : Uint256, var_amount_36 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(
        var_sender_34)
    let (_1_37 : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_0)
    let (__warp_subexpr_2 : Uint256) = is_lt(_1_37, var_amount_36)
    let (__warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    require_helper(__warp_subexpr_1)
    let (__warp_subexpr_4 : Uint256) = uint256_sub(_1_37, var_amount_36)
    let (__warp_subexpr_3 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(
        var_sender_34)
    update_storage_value_offsett_uint256_to_uint256(__warp_subexpr_3, __warp_subexpr_4)
    let (_2 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(var_recipient_35)
    let (__warp_subexpr_7 : Uint256) = sload(_2)
    let (__warp_subexpr_6 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = checked_add_uint256(__warp_subexpr_6, var_amount_36)
    update_storage_value_offsett_uint256_to_uint256(_2, __warp_subexpr_5)
    return ()
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_sender : Uint256, var_recipient_31 : Uint256, var_amount_32 : Uint256) -> (
        var_33 : Uint256):
    alloc_locals
    fun_transfer(var_sender, var_recipient_31, var_amount_32)
    let var_33 : Uint256 = Uint256(low=1, high=0)
    return (var_33)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_6 : Uint256, pos_7 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_zero(value_6)
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    uint256_mstore(offset=pos_7, value=__warp_subexpr_0)
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, value0_9 : Uint256) -> (tail_10 : Uint256):
    alloc_locals
    let (tail_10 : Uint256) = u256_add(headStart_8, Uint256(low=32, high=0))
    abi_encode_bool_to_bool(value0_9, headStart_8)
    return (tail_10)
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(pos_11 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_11, value=Uint256(low=18, high=0))
    return ()
end

func abi_encode_uint8_947{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_12 : Uint256) -> (tail_13 : Uint256):
    alloc_locals
    let (tail_13 : Uint256) = u256_add(headStart_12, Uint256(low=32, high=0))
    abi_encode_uint8(headStart_12)
    return (tail_13)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_1 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_1)
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_2 : Uint256) -> (tail_3 : Uint256):
    alloc_locals
    let (tail_3 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    abi_encode_uint256_to_uint256(value0_2, headStart)
    return (tail_3)
end

func abi_decode_addresst_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_16 : Uint256) -> (value0_17 : Uint256, value1_18 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_16,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_17 : Uint256) = calldataload(Uint256(low=4, high=0))
    let (value1_18 : Uint256) = calldataload(Uint256(low=36, high=0))
    return (value0_17, value1_18)
end

func fun_mint{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_to : Uint256, var_amount : Uint256) -> (var : Uint256):
    alloc_locals
    let (_1_28 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(var_to)
    let (__warp_subexpr_2 : Uint256) = sload(_1_28)
    let (__warp_subexpr_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = checked_add_uint256(__warp_subexpr_1, var_amount)
    update_storage_value_offsett_uint256_to_uint256(_1_28, __warp_subexpr_0)
    let var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

func abi_decode_address{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_19 : Uint256) -> (value0_20 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_19,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_20 : Uint256) = calldataload(Uint256(low=4, high=0))
    return (value0_20)
end

func mapping_index_access_mapping_address_uint256_of_address_438{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func getter_fun_balances{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key_23 : Uint256) -> (ret_24 : Uint256):
    alloc_locals
    let (ret_24) = balances.read(key_23.low, key_23.high)
    return (ret_24)
end

func fun_balanceOf{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_account : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(
        var_account)
    let (var_ : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_0)
    return (var_)
end

func fun_transfer_73{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_recipient : Uint256, var_amount_29 : Uint256) -> (
        var_30 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = caller()
    fun_transfer(__warp_subexpr_0, var_recipient, var_amount_29)
    let var_30 : Uint256 = Uint256(low=1, high=0)
    return (var_30)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (__warp_subexpr_4 : Uint256) = sload(Uint256(low=1, high=0))
    let (__warp_subexpr_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256_428(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211328, high=340282366920938463463374607431768211455))
    returndata_write(Uint256(low=128, high=0), __warp_subexpr_1)
    return ()
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256,
        param_2 : Uint256) = abi_decode_addresst_addresst_uint256(__warp_subexpr_0)
    let (ret__warp_mangled : Uint256) = fun_transferFrom(param, param_1, param_2)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos)
    returndata_write(memPos, __warp_subexpr_1)
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint8_947(memPos_1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    returndata_write(memPos_1, __warp_subexpr_1)
    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=1, high=0))
    let (ret_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_1)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_2, ret_1)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_2)
    returndata_write(memPos_2, __warp_subexpr_2)
    return ()
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_3 : Uint256, param_4 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (ret_2 : Uint256) = fun_mint(param_3, param_4)
    let (memPos_3 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_3, ret_2)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_3)
    returndata_write(memPos_3, __warp_subexpr_1)
    return ()
end

func __warp_block_12{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret_3 : Uint256) = getter_fun_balances(__warp_subexpr_0)
    let (memPos_4 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_4, ret_3)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_4)
    returndata_write(memPos_4, __warp_subexpr_2)
    return ()
end

func __warp_block_14{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret_4 : Uint256) = fun_balanceOf(__warp_subexpr_0)
    let (memPos_5 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_5, ret_4)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_5)
    returndata_write(memPos_5, __warp_subexpr_2)
    return ()
end

func __warp_block_16{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param_5 : Uint256, param_6 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (ret_5 : Uint256) = fun_transfer_73(param_5, param_6)
    let (memPos_6 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_6, ret_5)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_6)
    returndata_write(memPos_6, __warp_subexpr_1)
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_16()
        return ()
    else:
        return ()
    end
end

func __warp_block_15{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2835717307, high=0))
    __warp_if_8(__warp_subexpr_0)
    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_14()
        return ()
    else:
        __warp_block_15(match_var)
        return ()
    end
end

func __warp_block_13{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1889567281, high=0))
    __warp_if_7(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_12()
        return ()
    else:
        __warp_block_13(match_var)
        return ()
    end
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1857877511, high=0))
    __warp_if_6(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10()
        return ()
    else:
        __warp_block_11(match_var)
        return ()
    end
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1086394137, high=0))
    __warp_if_5(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
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
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1051392107, high=0))
    __warp_if_4(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
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
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    __warp_if_3(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
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
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=599290589, high=0))
    __warp_if_2(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_2()
        return ()
    else:
        __warp_block_3(match_var)
        return ()
    end
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    __warp_if_1(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_1(match_var)
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0()
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
    let (local __fp__, _) = get_fp_and_pc()
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        __warp_if_0(__warp_subexpr_0)
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

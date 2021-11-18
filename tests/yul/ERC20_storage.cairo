%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
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
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
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
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256_440{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let tail : Uint256 = Uint256(low=160, high=0)
    abi_encode_uint256_to_uint256_1010(value0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func extract_from_storage_value_dynamict_uint8{range_check_ptr}(slot_value_6 : Uint256) -> (
        value_7 : Uint256):
    alloc_locals
    let (value_7 : Uint256) = uint256_and(slot_value_6, Uint256(low=255, high=0))
    local range_check_ptr = range_check_ptr
    return (value_7)
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_8 : Uint256, pos_9 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = uint256_and(value_8, Uint256(low=255, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_9, value=__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_10 : Uint256, value0_11 : Uint256) -> (tail_12 : Uint256):
    alloc_locals
    let (tail_12 : Uint256) = u256_add(headStart_10, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(value0_11, headStart_10)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_12)
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_13 : Uint256) -> (value0_14 : Uint256, value1 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_13,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=64, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_14 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_14, value1)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key_25 : Uint256) -> (dataSlot_26 : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key_25)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (dataSlot_26 : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return (dataSlot_26)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(slot : Uint256) -> (
        value_1 : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = sload(slot)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (value_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_0)
    return (value_1)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
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
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (diff : Uint256) = uint256_sub(x_33, y_34)
    local range_check_ptr = range_check_ptr
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
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_0 : Uint256) = update_byte_slice_shift(__warp_subexpr_1, value_31)
    sstore(key=slot_30, value=__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func fun_withdraw{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_wad : Uint256, var_sender_35 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_sender_35)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_3)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, var_wad)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    require_helper(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (_1_36 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_sender_35)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_6 : Uint256) = sload(_1_36)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_5 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_6)
    let (__warp_subexpr_4 : Uint256) = checked_sub_uint256(__warp_subexpr_5, var_wad)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256(_1_36, __warp_subexpr_4)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_decode_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_15 : Uint256) -> (value0_16 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_15,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_16 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_16)
end

func fun_get_balance{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src_40 : Uint256) -> (var : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_src_40)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (var : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_3 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_4 : Uint256) -> (tail_5 : Uint256):
    alloc_locals
    let (tail_5 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_4, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_5)
end

func abi_decode_uint256t_uint256t_uint256t_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(dataEnd_17 : Uint256) -> (
        value0_18 : Uint256, value1_19 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_17,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=128, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (value0_18 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (value1_19 : Uint256) = calldataload(Uint256(low=36, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (value3 : Uint256) = calldataload(Uint256(low=100, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_18, value1_19, value2, value3)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_gt(x, __warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_block_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src : Uint256, var_wad_37 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_3 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(
        var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = read_from_storage_split_dynamic_uint256(__warp_subexpr_3)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, var_wad_37)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    require_helper(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_src : Uint256, var_wad_37 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0(var_src, var_wad_37)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
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
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    __warp_if_0(__warp_subexpr_0, var_src, var_wad_37)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (_1_39 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_4 : Uint256) = sload(_1_39)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = checked_sub_uint256(__warp_subexpr_3, var_wad_37)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256(_1_39, __warp_subexpr_2)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (_2 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_dst)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_7 : Uint256) = sload(_2)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_6 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_7)
    let (__warp_subexpr_5 : Uint256) = checked_add_uint256(__warp_subexpr_6, var_wad_37)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256(_2, __warp_subexpr_5)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_20 : Uint256, pos_21 : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = is_zero(value_20)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_21, value=__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_22 : Uint256, value0_23 : Uint256) -> (tail_24 : Uint256):
    alloc_locals
    let (tail_24 : Uint256) = u256_add(headStart_22, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_23, headStart_22)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_24)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256_448{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
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
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = sload(_1_32)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_1 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_2)
    let (__warp_subexpr_0 : Uint256) = checked_add_uint256(__warp_subexpr_1, var_value)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256(_1_32, __warp_subexpr_0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    abi_decode(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_4 : Uint256) = sload(Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_4)
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256_440(__warp_subexpr_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211328, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    returndata_write(Uint256(low=128, high=0), __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    abi_decode(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = sload(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (ret__warp_mangled : Uint256) = extract_from_storage_value_dynamict_uint8(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint8(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, __warp_subexpr_2)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (param : Uint256, param_1 : Uint256) = abi_decode_uint256t_uint256(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    fun_withdraw(param, param_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    returndata_write(__warp_subexpr_1, Uint256(low=0, high=0))
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (__warp_subexpr_0 : Uint256) = abi_decode_uint256(__warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (ret_1 : Uint256) = fun_get_balance(__warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, __warp_subexpr_2)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (param_2 : Uint256, param_3 : Uint256, param_4 : Uint256,
        param_5 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (ret_2 : Uint256) = fun_transferFrom(param_2, param_3, param_4, param_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_2, __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_13{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (__warp_subexpr_0 : Uint256) = abi_decode_uint256(__warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (ret_3 : Uint256) = getter_fun_balanceOf(__warp_subexpr_0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (memPos_3 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos_3, ret_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos_3)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_3, __warp_subexpr_2)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_15{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (param_6 : Uint256, param_7 : Uint256) = abi_decode_uint256t_uint256(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    fun_deposit(param_6, param_7)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (__warp_subexpr_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    returndata_write(__warp_subexpr_1, Uint256(low=0, high=0))
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_15()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_14{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3803951448, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_8(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_14(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_12{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2630350600, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_12(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_10(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1530952232, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_8(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1142570608, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_6(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_4(match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(__warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    __warp_block_2(match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_1()
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
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
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        let (__warp_subexpr_2 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        local range_check_ptr = range_check_ptr
        let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
        local range_check_ptr = range_check_ptr
        __warp_if_1(__warp_subexpr_0)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

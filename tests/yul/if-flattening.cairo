%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_sub

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
func allowance(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func evm_storage(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func this_address() -> (res : felt):
end

@storage_var
func address_initialized() -> (res : felt):
end

func initialize_address{range_check_ptr, syscall_ptr : felt*, pedersen_ptr : HashBuiltin*}(
        self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end

func abi_decode_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = u256_add(
        dataEnd,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256_252{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local dataSlot : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return (dataSlot)
end

func extract_from_storage_value_dynamict_uint256(slot_value : Uint256) -> (value : Uint256):
    alloc_locals
    local value : Uint256 = slot_value
    return (value)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(slot : Uint256) -> (
        value_3 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = sload(slot)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local value_3 : Uint256) = extract_from_storage_value_dynamict_uint256(__warp_subexpr_0)
    return (value_3)
end

func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        key_4 : Uint256) -> (ret_5 : Uint256):
    alloc_locals
    let (ret_5) = allowance.read(key_4.low, key_4.high)
    return (ret_5)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_6 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_6)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_7 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (local tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_7, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode_uint256t_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        dataEnd_8 : Uint256) -> (value0_9 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = u256_add(
        dataEnd_8,
        Uint256(low=340282366920938463463374607431768211452, high=340282366920938463463374607431768211455))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = slt(__warp_subexpr_1, Uint256(low=96, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_9 : Uint256) = calldataload(Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local value1 : Uint256) = calldataload(Uint256(low=36, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local value2 : Uint256) = calldataload(Uint256(low=68, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_9, value1, value2)
end

func mapping_index_access_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key_1 : Uint256) -> (dataSlot_2 : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=0, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local dataSlot_2 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return (dataSlot_2)
end

func checked_sub_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(x, y)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local diff : Uint256) = uint256_sub(x, y)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func update_byte_slice_shift(value_10 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        slot_11 : Uint256, value_12 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = sload(slot_11)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local __warp_subexpr_0 : Uint256) = update_byte_slice_shift(__warp_subexpr_1, value_12)
    sstore(key=slot_11, value=__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_2{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    let (local _1 : Uint256) = mapping_index_access_mapping_uint256_uint256_of_uint256(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = sload(_1)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local __warp_subexpr_1 : Uint256) = extract_from_storage_value_dynamict_uint256(
        __warp_subexpr_2)
    let (local __warp_subexpr_0 : Uint256) = checked_sub_uint256(__warp_subexpr_1, var_wad)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256(_1, __warp_subexpr_0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

func __warp_if_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(__warp_subexpr_0 : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local var_res : Uint256 = Uint256(low=2, high=0)
        return (var_res)
    else:
        let (local var_res : Uint256) = __warp_block_2(var_src, var_wad)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return (var_res)
    end
end

func __warp_block_1{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(match_var : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_if_0(__warp_subexpr_0, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_res)
end

func __warp_block_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(var_src, var_sender)
    local range_check_ptr = range_check_ptr
    let (local match_var : Uint256) = is_zero(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_1(match_var, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_res)
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (local var_res : Uint256) = __warp_block_0(var_sender, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var : Uint256 = var_res
    return (var)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local __warp_subexpr_0 : Uint256) = abi_decode_uint256(__warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_allowance(__warp_subexpr_0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, __warp_subexpr_2)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = calldatasize()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local param : Uint256, local param_1 : Uint256,
        local param_2 : Uint256) = abi_decode_uint256t_uint256t_uint256(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_transferFrom(param, param_1, param_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, __warp_subexpr_1)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256) -> ():
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
        return ()
    end
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(match_var : Uint256) -> (
        ):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=823056368, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(__warp_subexpr_0)
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
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=776198108, high=0))
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

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    __warp_block_4(match_var)
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
        __warp_block_3()
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
        bitwise_ptr : BitwiseBuiltin*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> (
        success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    initialize_address{
        range_check_ptr=range_check_ptr, syscall_ptr=syscall_ptr, pedersen_ptr=pedersen_ptr}(
        self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
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
        let (local __warp_subexpr_2 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (local __warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
        local range_check_ptr = range_check_ptr
        let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
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

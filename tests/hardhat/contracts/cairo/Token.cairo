%lang starknet
%builtins pedersen range_check bitwise

from evm.array import validate_array
from evm.calls import calldataload, calldatasize, caller
from evm.exec_env import ExecutionEnvironment
from evm.hashing import uint256_pedersen
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from evm.yul_api import warp_return
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_sub

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

@storage_var
func evm_storage(arg0 : Uint256) -> (res : Uint256):
end

@constructor
func constructor{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    validate_array(calldata_len, calldata)
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
func __main{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> (
        returndata_size, returndata_len, returndata : felt*):
    alloc_locals
    validate_array(calldata_len, calldata)
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
    sstore(key=Uint256(low=0, high=0), value=Uint256(low=1000000, high=0))
    let (__warp_subexpr_1 : Uint256) = caller()
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_1)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_2 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    sstore(key=__warp_subexpr_2, value=Uint256(low=1000000, high=0))
    let (__warp_subexpr_3 : Uint256) = caller()
    sstore(key=Uint256(low=1, high=0), value=__warp_subexpr_3)
    return ()
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

func abi_encode_uint256_650{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let tail : Uint256 = Uint256(low=160, high=0)
    uint256_mstore(offset=Uint256(low=128, high=0), value=value0)
    return (tail)
end

func abi_decode_address{exec_env : ExecutionEnvironment*, range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256):
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

func fun_balanceOf{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_account : Uint256) -> (var : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=var_account)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_0 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (var : Uint256) = sload(__warp_subexpr_0)
    return (var)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=headStart, value=value0)
    return (tail)
end

func abi_decode_addresst_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
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

func mapping_index_access_mapping_address_uint256_of_address{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    uint256_mstore(offset=Uint256(low=0, high=0), value=key)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (dataSlot : Uint256) = uint256_pedersen(Uint256(low=0, high=0), Uint256(low=64, high=0))
    return (dataSlot)
end

func fun_transfer{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_to : Uint256, var_amount : Uint256) -> (
        var : Uint256, var_ : Uint256):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = caller()
    uint256_mstore(offset=Uint256(low=0, high=0), value=__warp_subexpr_0)
    uint256_mstore(offset=Uint256(low=32, high=0), value=Uint256(low=2, high=0))
    let (__warp_subexpr_3 : Uint256) = uint256_pedersen(
        Uint256(low=0, high=0), Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = sload(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, var_amount)
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_4 : Uint256) = caller()
    let (_1 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(__warp_subexpr_4)
    let (_2 : Uint256) = sload(_1)
    let (__warp_subexpr_5 : Uint256) = is_lt(_2, var_amount)
    if __warp_subexpr_5.low + __warp_subexpr_5.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_6 : Uint256) = uint256_sub(_2, var_amount)
    sstore(key=_1, value=__warp_subexpr_6)
    let (_3 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(var_to)
    let (_4 : Uint256) = sload(_3)
    let (__warp_subexpr_8 : Uint256) = uint256_not(var_amount)
    let (__warp_subexpr_7 : Uint256) = is_gt(_4, __warp_subexpr_8)
    if __warp_subexpr_7.low + __warp_subexpr_7.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (__warp_subexpr_9 : Uint256) = u256_add(_4, var_amount)
    sstore(key=_3, value=__warp_subexpr_9)
    let (__warp_subexpr_11 : Uint256) = caller()
    let (__warp_subexpr_10 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(
        __warp_subexpr_11)
    let (_5 : Uint256) = sload(__warp_subexpr_10)
    let (__warp_subexpr_12 : Uint256) = mapping_index_access_mapping_address_uint256_of_address(
        var_to)
    let (_6 : Uint256) = sload(__warp_subexpr_12)
    let var : Uint256 = _5
    let var_ : Uint256 = _6
    return (var, var_)
end

func abi_encode_uint256_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0 : Uint256, value1 : Uint256) -> (tail : Uint256):
    alloc_locals
    let (tail : Uint256) = u256_add(headStart, Uint256(low=64, high=0))
    uint256_mstore(offset=headStart, value=value0)
    let (__warp_subexpr_0 : Uint256) = u256_add(headStart, Uint256(low=32, high=0))
    uint256_mstore(offset=__warp_subexpr_0, value=value1)
    return (tail)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (__warp_subexpr_3 : Uint256) = sload(Uint256(low=0, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256_650(__warp_subexpr_3)
    let (__warp_subexpr_1 : Uint256) = u256_add(
        __warp_subexpr_2,
        Uint256(low=340282366920938463463374607431768211328, high=340282366920938463463374607431768211455))
    warp_return(Uint256(low=128, high=0), __warp_subexpr_1)
    return ()
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_1 : Uint256) = calldatasize()
    let (__warp_subexpr_0 : Uint256) = abi_decode_address(__warp_subexpr_1)
    let (ret__warp_mangled : Uint256) = fun_balanceOf(__warp_subexpr_0)
    let (memPos : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_3 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    let (__warp_subexpr_2 : Uint256) = uint256_sub(__warp_subexpr_3, memPos)
    warp_return(memPos, __warp_subexpr_2)
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    abi_decode(__warp_subexpr_0)
    let (ret_1 : Uint256) = sload(Uint256(low=1, high=0))
    let (memPos_1 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_1)
    warp_return(memPos_1, __warp_subexpr_1)
    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldatasize()
    let (param : Uint256, param_1 : Uint256) = abi_decode_addresst_uint256(__warp_subexpr_0)
    let (ret_2 : Uint256, ret_3 : Uint256) = fun_transfer(param, param_1)
    let (memPos_2 : Uint256) = uint256_mload(Uint256(low=64, high=0))
    let (__warp_subexpr_2 : Uint256) = abi_encode_uint256_uint256(memPos_2, ret_2, ret_3)
    let (__warp_subexpr_1 : Uint256) = uint256_sub(__warp_subexpr_2, memPos_2)
    warp_return(memPos_2, __warp_subexpr_1)
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8()
        return ()
    else:
        return ()
    end
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2835717307, high=0))
    __warp_if_4(__warp_subexpr_0)
    return ()
end

func __warp_if_3{
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
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
    __warp_if_3(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_2{
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
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1889567281, high=0))
    __warp_if_2(__warp_subexpr_0, match_var)
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
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
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        match_var : Uint256) -> ():
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    __warp_if_1(__warp_subexpr_0, match_var)
    return ()
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    let (__warp_subexpr_0 : Uint256) = calldataload(Uint256(low=0, high=0))
    let (match_var : Uint256) = u256_shr(Uint256(low=224, high=0), __warp_subexpr_0)
    __warp_block_1(match_var)
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}(
        __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_0()
        return ()
    else:
        return ()
    end
end

func __main_meat{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*, termination_token}() -> (
        ):
    alloc_locals
    uint256_mstore(offset=Uint256(low=64, high=0), value=Uint256(low=128, high=0))
    let (__warp_subexpr_2 : Uint256) = calldatasize()
    let (__warp_subexpr_1 : Uint256) = is_lt(__warp_subexpr_2, Uint256(low=4, high=0))
    let (__warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    __warp_if_0(__warp_subexpr_0)
    if termination_token == 1:
        return ()
    end
    assert 0 = 1
    jmp rel 0
end


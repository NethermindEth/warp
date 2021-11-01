%lang starknet
%builtins pedersen range_check bitwise

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.calls import calldata_load, calldatasize_, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_sub)

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func owner() -> (res : Uint256):
end

@storage_var
func ownerAge() -> (res : Uint256):
end

@storage_var
func ownerCellNumber() -> (res : Uint256):
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

func __warp_cond_revert(_3_31 : Uint256) -> ():
    alloc_locals
    if _3_31.low + _3_31.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(headStart_28 : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_29 : Uint256 = Uint256(low=0, high=0)
    let (local _2_30 : Uint256) = uint256_sub(dataEnd, headStart_28)
    local range_check_ptr = range_check_ptr
    let (local _3_31 : Uint256) = slt(_2_30, _1_29)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_31)
    return ()
end

@view
func getter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        ) -> (value_89 : Uint256):
    alloc_locals
    let (res) = ownerCellNumber.read()
    return (res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_44 : Uint256, pos_45 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_45.low, value=value_44)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_49 : Uint256, value0_50 : Uint256) -> (tail_51 : Uint256):
    alloc_locals
    local _1_52 : Uint256 = Uint256(low=32, high=0)
    let (local tail_51 : Uint256) = u256_add(headStart_49, _1_52)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_50, headStart_49)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_51)
end

@view
func getter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_91 : Uint256):
    alloc_locals
    let (res) = owner.read()
    return (res)
end

func abi_encode_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_43 : Uint256, pos : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos.low, value=value_43)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_46 : Uint256, value0_47 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_48 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_46, _1_48)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_47, headStart_46)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

@view
func getter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_87 : Uint256):
    alloc_locals
    let (res) = ownerAge.read()
    return (res)
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    local _13 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _15 : Uint256) = getter_fun_ownerCellNumber()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _16 : Uint256 = _1
    let (local _17 : Uint256) = abi_encode_uint256(_1, _15)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18 : Uint256) = u256_add(_17, _14)
    local range_check_ptr = range_check_ptr
    local _19 : Uint256 = _1
    returndata_write(_1, _18)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _26 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_26)
    local _27 : Uint256 = _4
    local _28 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_owner()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _29 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30 : Uint256) = abi_encode_tuple_address(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31 : Uint256) = uint256_sub(_30, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _31)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _32 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_32)
    local _33 : Uint256 = _4
    local _34 : Uint256 = _3
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = getter_fun_ownerAge()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _35 : Uint256 = _2
    let (local memPos_1 : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _36 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = uint256_sub(_36, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _37)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
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
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2647152338, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_2, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5(_2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_6(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_4(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1104667242, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_1(_1, _2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_2(_1, _2, _3, _4, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_1(_1, _10, _2, _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_1, _2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
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
        success : felt, returndata_size : felt, returndata_len : felt, f0 : felt, f1 : felt,
        f2 : felt, f3 : felt, f4 : felt, f5 : felt, f6 : felt, f7 : felt):
    alloc_locals
    initialize_address{
        range_check_ptr=range_check_ptr, syscall_ptr=syscall_ptr, pedersen_ptr=pedersen_ptr}(
        self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        local _1 : Uint256 = Uint256(low=128, high=0)
        local _2 : Uint256 = Uint256(low=64, high=0)
        with memory_dict, msize, range_check_ptr:
            mstore_(offset=_2.low, value=_1)
        end

        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3 : Uint256 = Uint256(low=4, high=0)
        let (local _4 : Uint256) = calldatasize_()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        let (local _5 : Uint256) = is_lt(_4, _3)
        local range_check_ptr = range_check_ptr
        let (local _6 : Uint256) = is_zero(_5)
        local range_check_ptr = range_check_ptr
        with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, syscall_ptr:
            __warp_if_0(_1, _2, _3, _4, _6)
        end

        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (
        1,
        exec_env.to_returndata_size,
        exec_env.to_returndata_len,
        f0=exec_env.to_returndata[0],
        f1=exec_env.to_returndata[1],
        f2=exec_env.to_returndata[2],
        f3=exec_env.to_returndata[3],
        f4=exec_env.to_returndata[4],
        f5=exec_env.to_returndata[5],
        f6=exec_env.to_returndata[6],
        f7=exec_env.to_returndata[7])
end

func array_allocation_size_array_uint256{range_check_ptr}(length_54 : Uint256) -> (
        size_55 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_56 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_57 : Uint256) = is_gt(length_54, _1_56)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_57)
    local _3_58 : Uint256 = Uint256(low=5, high=0)
    let (local size_55 : Uint256) = u256_shl(_3_58, length_54)
    local range_check_ptr = range_check_ptr
    return (size_55)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_62 : Uint256, size_63 : Uint256) -> ():
    alloc_locals
    let (local _1_64 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_65 : Uint256 = Uint256(low=31, high=0)
    let (local _3_66 : Uint256) = u256_add(size_63, _2_65)
    local range_check_ptr = range_check_ptr
    let (local _4_67 : Uint256) = uint256_and(_3_66, _1_64)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr_62, _4_67)
    local range_check_ptr = range_check_ptr
    let (local _5_68 : Uint256) = is_lt(newFreePtr, memPtr_62)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_69 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_70 : Uint256) = is_gt(newFreePtr, _6_69)
    local range_check_ptr = range_check_ptr
    let (local _8_71 : Uint256) = uint256_sub(_7_70, _5_68)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_71)
    local _9_72 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_72.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size : Uint256) -> (
        memPtr : Uint256):
    alloc_locals
    local _1_53 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr : Uint256) = mload_(_1_53.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr, size)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func __warp_loop_body_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, src : Uint256) -> (dst : Uint256, i : Uint256, src : Uint256):
    alloc_locals
    let (local _7_7 : Uint256) = calldata_load(src.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_(offset=dst.low, value=_7_7)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_8 : Uint256 = Uint256(low=32, high=0)
    let (local dst : Uint256) = u256_add(dst, _8_8)
    local range_check_ptr = range_check_ptr
    let (local src : Uint256) = u256_add(src, _8_8)
    local range_check_ptr = range_check_ptr
    local _6_6 : Uint256 = Uint256(low=1, high=0)
    let (local i : Uint256) = u256_add(i, _6_6)
    local range_check_ptr = range_check_ptr
    return (dst, i, src)
end

func __warp_loop_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst : Uint256, i : Uint256, length : Uint256, src : Uint256) -> (
        dst : Uint256, i : Uint256, src : Uint256):
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = is_lt(i, length)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_zero(__warp_subexpr_1)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (dst, i, src)
    end
    let (local dst : Uint256, local i : Uint256, local src : Uint256) = __warp_loop_body_0(
        dst, i, src)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local dst : Uint256, local i : Uint256, local src : Uint256) = __warp_loop_0(
        dst, i, length, src)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (dst, i, src)
end

func abi_decode_available_length_array_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset : Uint256, length : Uint256, end__warp_mangled : Uint256) -> (array : Uint256):
    alloc_locals
    let (local _1_1 : Uint256) = array_allocation_size_array_uint256(length)
    local range_check_ptr = range_check_ptr
    let (local array : Uint256) = allocate_memory(_1_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local dst : Uint256 = array
    local src : Uint256 = offset
    local _2_2 : Uint256 = Uint256(low=5, high=0)
    let (local _3_3 : Uint256) = u256_shl(_2_2, length)
    local range_check_ptr = range_check_ptr
    let (local _4_4 : Uint256) = u256_add(offset, _3_3)
    local range_check_ptr = range_check_ptr
    let (local _5_5 : Uint256) = is_gt(_4_4, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_5)
    local i : Uint256 = Uint256(low=0, high=0)
    let (local dst : Uint256, local i : Uint256, local src : Uint256) = __warp_loop_0(
        dst, i, length, src)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array)
end

func abi_decode_array_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_9 : Uint256, end_10 : Uint256) -> (array_11 : Uint256):
    alloc_locals
    local _1_12 : Uint256 = Uint256(low=31, high=0)
    let (local _2_13 : Uint256) = u256_add(offset_9, _1_12)
    local range_check_ptr = range_check_ptr
    let (local _3_14 : Uint256) = slt(_2_13, end_10)
    local range_check_ptr = range_check_ptr
    let (local _4_15 : Uint256) = is_zero(_3_14)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_15)
    local _5_16 : Uint256 = Uint256(low=3, high=0)
    let (local array_11 : Uint256) = abi_decode_available_length_array_uint256(
        offset_9, _5_16, end_10)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array_11)
end

func abi_decode_struct_Person{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, end_17 : Uint256) -> (value : Uint256):
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=64, high=0)
    let (local _2_19 : Uint256) = uint256_sub(end_17, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_20 : Uint256) = slt(_2_19, _1_18)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_20)
    local _4_21 : Uint256 = _1_18
    let (local value : Uint256) = allocate_memory(_1_18)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_22 : Uint256) = calldata_load(headStart.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_(offset=value.low, value=_5_22)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_23 : Uint256 = Uint256(low=32, high=0)
    let (local _7_24 : Uint256) = u256_add(headStart, _6_23)
    local range_check_ptr = range_check_ptr
    let (local _8_25 : Uint256) = calldata_load(_7_24.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9_26 : Uint256 = _6_23
    let (local _10_27 : Uint256) = u256_add(value, _6_23)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_10_27.low, value=_8_25)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_addresst_struct_Persont_uint256t_array_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_32 : Uint256, dataEnd_33 : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_34 : Uint256 = Uint256(low=224, high=0)
    let (local _2_35 : Uint256) = uint256_sub(dataEnd_33, headStart_32)
    local range_check_ptr = range_check_ptr
    let (local _3_36 : Uint256) = slt(_2_35, _1_34)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_36)
    let (local value0 : Uint256) = calldata_load(headStart_32.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_37 : Uint256 = Uint256(low=32, high=0)
    let (local _5_38 : Uint256) = u256_add(headStart_32, _4_37)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = abi_decode_struct_Person(_5_38, dataEnd_33)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_39 : Uint256 = Uint256(low=96, high=0)
    let (local _7_40 : Uint256) = u256_add(headStart_32, _6_39)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldata_load(_7_40.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_41 : Uint256 = Uint256(low=128, high=0)
    let (local _9_42 : Uint256) = u256_add(headStart_32, _8_41)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = abi_decode_array_uint256(_9_42, dataEnd_33)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0, value1, value2, value3)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_59 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_60 : Uint256) = is_gt(x, _1_59)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_60)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func cleanup_uint256(value_61 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_61
    return (cleaned)
end

@external
func setter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_139 : Uint256) -> ():
    alloc_locals
    owner.write(value_139)
    return ()
end

func memory_array_index_access_uint256{range_check_ptr}(baseRef : Uint256, index : Uint256) -> (
        addr : Uint256):
    alloc_locals
    local _1_93 : Uint256 = Uint256(low=3, high=0)
    let (local _2_94 : Uint256) = is_lt(index, _1_93)
    local range_check_ptr = range_check_ptr
    let (local _3_95 : Uint256) = is_zero(_2_94)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_95)
    local _4_96 : Uint256 = Uint256(low=5, high=0)
    let (local _5_97 : Uint256) = u256_shl(_4_96, index)
    local range_check_ptr = range_check_ptr
    let (local addr : Uint256) = u256_add(baseRef, _5_97)
    local range_check_ptr = range_check_ptr
    return (addr)
end

func read_from_memoryt_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        ptr : Uint256) -> (returnValue : Uint256):
    alloc_locals
    let (local _1_116 : Uint256) = mload_(ptr.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local returnValue : Uint256) = cleanup_uint256(_1_116)
    return (returnValue)
end

@external
func setter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_129 : Uint256) -> ():
    alloc_locals
    ownerAge.write(value_129)
    return ()
end

@external
func setter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_134 : Uint256) -> ():
    alloc_locals
    ownerCellNumber.write(value_134)
    return ()
end

func fun_warp_ctorHelper_DynArgs{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_owner : Uint256, var_ownerAge_mpos : Uint256, var_ownerCellNumber : Uint256,
        var_rando_mpos : Uint256) -> ():
    alloc_locals
    setter_fun_owner(var_owner)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _1_81 : Uint256) = mload_(var_ownerAge_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_82 : Uint256) = cleanup_uint256(_1_81)
    local _3_83 : Uint256 = Uint256(low=0, high=0)
    let (local _4_84 : Uint256) = memory_array_index_access_uint256(var_rando_mpos, _3_83)
    local range_check_ptr = range_check_ptr
    let (local _5_85 : Uint256) = read_from_memoryt_uint256(_4_84)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_86 : Uint256) = checked_add_uint256(_2_82, _5_85)
    local range_check_ptr = range_check_ptr
    setter_fun_ownerAge(_6_86)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    setter_fun_ownerCellNumber(var_ownerCellNumber)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

@constructor
func constructor{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with pedersen_ptr, range_check_ptr, bitwise_ptr, memory_dict, msize, exec_env:
        local _1_73 : Uint256 = Uint256(low=128, high=0)
        local _2_74 : Uint256 = Uint256(low=64, high=0)
        mstore_(offset=_2_74.low, value=_1_73)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3_75 : Uint256 = Uint256(low=4, high=0)
        let (local _4_76 : Uint256) = calldatasize_()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        local _7_77 : Uint256 = Uint256(low=0, high=0)
        let (local _8_78 : Uint256) = calldata_load(_7_77.low)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        local _9_79 : Uint256 = Uint256(low=224, high=0)
        let (local _10_80 : Uint256) = u256_shr(_9_79, _8_78)
        local range_check_ptr = range_check_ptr
        let (local _20 : Uint256) = __warp_constant_0()
        __warp_cond_revert(_20)
        local _21 : Uint256 = _4_76
        local _22 : Uint256 = _3_75
        let (local param : Uint256, local param_1 : Uint256, local param_2 : Uint256,
            local param_3 : Uint256) = abi_decode_addresst_struct_Persont_uint256t_array_uint256(
            _3_75, _4_76)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        fun_warp_ctorHelper_DynArgs(param, param_1, param_2, param_3)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        local _23 : Uint256 = _7_77
        local _24 : Uint256 = _2_74
        let (local _25 : Uint256) = mload_(_2_74.low)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        returndata_write(_25, _7_77)
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

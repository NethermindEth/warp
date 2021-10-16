%lang starknet
%builtins pedersen range_check

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, u256_add
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not, uint256_sub
from starkware.starknet.common.storage import Storage

@contract_interface
namespace GenericCallInterface:
    func fun_ENTRY_POINT(calldata_size : felt, calldata_len : felt, calldata : felt*) -> (
            success : felt, returndata_len : felt, returndata : felt*):
    end
end

func calculate_data_len{range_check_ptr}(calldata_size) -> (calldata_len):
    let (calldata_len_, rem) = unsigned_div_rem(calldata_size, 8)
    if rem != 0:
        return (calldata_len=calldata_len_ + 1)
    else:
        return (calldata_len=calldata_len_)
    end
end

func warp_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, value : Uint256, in : Uint256, insize : Uint256,
        out : Uint256, outsize : Uint256) -> (success : Uint256):
    alloc_locals
    local memory_dict : DictAccess* = memory_dict

    # TODO will 128 bits be enough for addresses
    let (local mem : felt*) = array_create_from_memory{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr}(in.low, insize.low)
    local memory_dict : DictAccess* = memory_dict
    let (calldata_len_, rem) = unsigned_div_rem(insize.low, 8)
    let (calldata_len) = calculate_data_len(insize.low)
    let (local success, local return_size,
        local return_ : felt*) = GenericCallInterface.fun_ENTRY_POINT(
        address.low, insize.low, calldata_len, mem)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    array_copy_to_memory(return_size, return_, 0, out.low, outsize.low)
    let (returndata_len) = calculate_data_len(insize.low)
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size, calldata_len=exec_env.calldata_len, calldata=exec_env.calldata,
        returndata_size=return_size, returndata_len=returndata_len, returndata=return_
        )
    return (Uint256(success, 0))
end

func warp_static_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, in : Uint256, insize : Uint256, out : Uint256,
        outsize : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0, 0), in, insize, out, outsize)
end

@storage_var
func allowance(arg0_low, arg0_high, arg1_low, arg1_high) -> (res : Uint256):
end

@storage_var
func balanceOf(arg0_low, arg0_high) -> (res : Uint256):
end

<<<<<<< HEAD
func __warp_cond_revert(_4 : Uint256) -> ():
=======
@storage_var
func evm_storage(low : felt, high : felt, part : felt) -> (res : felt):
end

func s_load{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256, value : Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end

func __warp__id(arg : Uint256) -> (res : Uint256):
    return (res=arg)
end

func __warp_cond_revert(_4_4 : Uint256) -> ():
>>>>>>> staticcall
    alloc_locals
    if _4_4.low + _4_4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

@view
func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_101 : Uint256) -> (value_102 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0_101.low, arg0_101.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_114 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_114)
    return ()
end

func checked_sub_uint256{range_check_ptr}(x_65 : Uint256, y_66 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_67 : Uint256) = is_lt(x_65, y_66)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_67)
    let (local diff : Uint256) = uint256_sub(x_65, y_66)
    local range_check_ptr = range_check_ptr
    return (diff)
end

@external
func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_124 : Uint256, value_125 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_124.low, arg0_124.high, value_125)
    return ()
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_wad_91 : Uint256, var_sender_92 : Uint256) -> ():
    alloc_locals
    let (local _1_93 : Uint256) = getter_fun_balanceOf(var_sender_92)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_94 : Uint256) = is_lt(_1_93, var_wad_91)
    local range_check_ptr = range_check_ptr
    let (local _3_95 : Uint256) = is_zero(_2_94)
    local range_check_ptr = range_check_ptr
    require_helper(_3_95)
    local range_check_ptr = range_check_ptr
    let (local _4_96 : Uint256) = getter_fun_balanceOf(var_sender_92)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_97 : Uint256) = checked_sub_uint256(_4_96, var_wad_91)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_92, _5_97)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_91 : Uint256, var_sender_92 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_91, var_sender_92)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

func fun_get_balance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256) -> (var : Uint256):
    alloc_locals
    let (local var : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var)
end

@external
func fun_get_balance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_get_balance(var_src)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

@view
func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_98 : Uint256):
    alloc_locals
    let (res) = allowance.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func cleanup_uint256(value_68 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_68
    return (cleaned)
end

@external
func setter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_119 : Uint256, arg1_120 : Uint256, value_121 : Uint256) -> ():
    alloc_locals
    allowance.write(arg0_119.low, arg0_119.high, arg1_120.low, arg1_120.high, value_121)
    return ()
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_63 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_64 : Uint256) = is_gt(x, _1_63)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_64)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_74 : Uint256, var_src_72 : Uint256, var_wad_73 : Uint256) -> ():
    alloc_locals
    let (local _3_78 : Uint256) = getter_fun_allowance(var_src_72, var_sender_74)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_79 : Uint256) = is_lt(_3_78, var_wad_73)
    local range_check_ptr = range_check_ptr
    let (local _5_80 : Uint256) = is_zero(_4_79)
    local range_check_ptr = range_check_ptr
    require_helper(_5_80)
    local range_check_ptr = range_check_ptr
    let (local _6_81 : Uint256) = getter_fun_balanceOf(var_src_72)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_82 : Uint256) = cleanup_uint256(_6_81)
    let (local _8_83 : Uint256) = is_lt(_7_82, var_wad_73)
    local range_check_ptr = range_check_ptr
    let (local _9_84 : Uint256) = is_zero(_8_83)
    local range_check_ptr = range_check_ptr
    require_helper(_9_84)
    local range_check_ptr = range_check_ptr
    let (local _10_85 : Uint256) = getter_fun_allowance(var_src_72, var_sender_74)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _11_86 : Uint256) = checked_sub_uint256(_10_85, var_wad_73)
    local range_check_ptr = range_check_ptr
    setter_fun_allowance(var_src_72, var_sender_74, _11_86)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_if_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_77 : Uint256, var_sender_74 : Uint256, var_src_72 : Uint256, var_wad_73 : Uint256) -> ():
    alloc_locals
    if _2_77.low + _2_77.high != 0:
        __warp_block_0(var_sender_74, var_src_72, var_wad_73)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src_72 : Uint256, var_dst : Uint256, var_wad_73 : Uint256, var_sender_74 : Uint256) -> (
        var_75 : Uint256):
    alloc_locals
    let (local _1_76 : Uint256) = is_eq(var_src_72, var_sender_74)
    local range_check_ptr = range_check_ptr
    let (local _2_77 : Uint256) = is_zero(_1_76)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_2_77, var_sender_74, var_src_72, var_wad_73)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _12_87 : Uint256) = getter_fun_balanceOf(var_src_72)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _13_88 : Uint256) = checked_sub_uint256(_12_87, var_wad_73)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_src_72, _13_88)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _14_89 : Uint256) = getter_fun_balanceOf(var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _15_90 : Uint256) = checked_add_uint256(_14_89, var_wad_73)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_dst, _15_90)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_75 : Uint256 = Uint256(low=1, high=0)
    return (var_75)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src_72 : Uint256, var_dst : Uint256, var_wad_73 : Uint256, var_sender_74 : Uint256) -> (
        var_75 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_75 : Uint256) = fun_transferFrom(
            var_src_72, var_dst, var_wad_73, var_sender_74)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_75=var_75)
end

func fun_approve{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    setter_fun_allowance(var_sender, var_guy, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_ : Uint256) = fun_approve(var_guy, var_wad, var_sender)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_=var_)
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_69 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _1_70 : Uint256) = getter_fun_balanceOf(var_sender_69)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_71 : Uint256) = checked_add_uint256(_1_70, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_69, _2_71)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_69 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_deposit(var_sender_69, var_value)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> ():
    alloc_locals
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    assert 0 = 1
    jmp rel 0
end

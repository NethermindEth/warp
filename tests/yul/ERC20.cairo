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
        arg0_108 : Uint256) -> (value_109 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0_108.low, arg0_108.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_121 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_121)
    return ()
end

func checked_sub_uint256{range_check_ptr}(x_72 : Uint256, y_73 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_74 : Uint256) = is_lt(x_72, y_73)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_74)
    let (local diff : Uint256) = uint256_sub(x_72, y_73)
    local range_check_ptr = range_check_ptr
    return (diff)
end

@external
func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_131 : Uint256, value_132 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_131.low, arg0_131.high, value_132)
    return ()
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_70 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_71 : Uint256) = is_gt(x, _1_70)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_71)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_76 : Uint256, var_value : Uint256) -> (var_77 : Uint256, var_ : Uint256):
    alloc_locals
    let (local _1_78 : Uint256) = getter_fun_balanceOf(var_sender_76)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_79 : Uint256) = checked_add_uint256(_1_78, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_76, _2_79)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_77 : Uint256 = Uint256(low=21, high=0)
    local var_ : Uint256 = Uint256(low=12, high=0)
    return (var_77, var_)
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_76 : Uint256, var_value : Uint256) -> (var_77 : Uint256, var_ : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_77 : Uint256, local var_ : Uint256) = fun_deposit(var_sender_76, var_value)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_77=var_77, var_=var_)
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_wad_98 : Uint256, var_sender_99 : Uint256) -> ():
    alloc_locals
    let (local _1_100 : Uint256) = getter_fun_balanceOf(var_sender_99)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_101 : Uint256) = is_lt(_1_100, var_wad_98)
    local range_check_ptr = range_check_ptr
    let (local _3_102 : Uint256) = is_zero(_2_101)
    local range_check_ptr = range_check_ptr
    require_helper(_3_102)
    local range_check_ptr = range_check_ptr
    let (local _4_103 : Uint256) = getter_fun_balanceOf(var_sender_99)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_104 : Uint256) = checked_sub_uint256(_4_103, var_wad_98)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_99, _5_104)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_component : Uint256, local expr_component_1 : Uint256) = fun_deposit(
        var_sender_99, var_wad_98)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_98 : Uint256, var_sender_99 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_98, var_sender_99)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_105 : Uint256):
    alloc_locals
    let (res) = allowance.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func cleanup_uint256(value_75 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_75
    return (cleaned)
end

func setter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_126 : Uint256, arg1_127 : Uint256, value_128 : Uint256) -> ():
    alloc_locals
    allowance.write(arg0_126.low, arg0_126.high, arg1_127.low, arg1_127.high, value_128)
    return ()
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_81 : Uint256, var_src : Uint256, var_wad_80 : Uint256) -> ():
    alloc_locals
    let (local _3_85 : Uint256) = getter_fun_allowance(var_src, var_sender_81)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_86 : Uint256) = is_lt(_3_85, var_wad_80)
    local range_check_ptr = range_check_ptr
    let (local _5_87 : Uint256) = is_zero(_4_86)
    local range_check_ptr = range_check_ptr
    require_helper(_5_87)
    local range_check_ptr = range_check_ptr
    let (local _6_88 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_89 : Uint256) = cleanup_uint256(_6_88)
    let (local _8_90 : Uint256) = is_lt(_7_89, var_wad_80)
    local range_check_ptr = range_check_ptr
    let (local _9_91 : Uint256) = is_zero(_8_90)
    local range_check_ptr = range_check_ptr
    require_helper(_9_91)
    local range_check_ptr = range_check_ptr
    let (local _10_92 : Uint256) = getter_fun_allowance(var_src, var_sender_81)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _11_93 : Uint256) = checked_sub_uint256(_10_92, var_wad_80)
    local range_check_ptr = range_check_ptr
    setter_fun_allowance(var_src, var_sender_81, _11_93)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_if_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_84 : Uint256, var_sender_81 : Uint256, var_src : Uint256, var_wad_80 : Uint256) -> ():
    alloc_locals
    if _2_84.low + _2_84.high != 0:
        __warp_block_0(var_sender_81, var_src, var_wad_80)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256, var_dst : Uint256, var_wad_80 : Uint256, var_sender_81 : Uint256) -> (
        var_82 : Uint256):
    alloc_locals
    let (local _1_83 : Uint256) = is_eq(var_src, var_sender_81)
    local range_check_ptr = range_check_ptr
    let (local _2_84 : Uint256) = is_zero(_1_83)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_2_84, var_sender_81, var_src, var_wad_80)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _12_94 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _13_95 : Uint256) = checked_sub_uint256(_12_94, var_wad_80)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_src, _13_95)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _14_96 : Uint256) = getter_fun_balanceOf(var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _15_97 : Uint256) = checked_add_uint256(_14_96, var_wad_80)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_dst, _15_97)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_82 : Uint256 = Uint256(low=1, high=0)
    return (var_82)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad_80 : Uint256, var_sender_81 : Uint256) -> (
        var_82 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_82 : Uint256) = fun_transferFrom(var_src, var_dst, var_wad_80, var_sender_81)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_82=var_82)
end

func fun_approve{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    setter_fun_allowance(var_sender, var_guy, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_approve(var_guy, var_wad, var_sender)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
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

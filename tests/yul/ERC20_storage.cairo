%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not, uint256_sub
from starkware.starknet.common.storage import Storage

@storage_var
func allowance(arg0_low, arg0_high, arg1_low, arg1_high) -> (res : Uint256):
end

@storage_var
func balanceOf(arg0_low, arg0_high) -> (res : Uint256):
end

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

func __warp_block_00(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_55 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_56 : Uint256) = is_gt(x, _1_55)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_56)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_sub_uint256{range_check_ptr}(x_57 : Uint256, y_58 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_59 : Uint256) = is_lt(x_57, y_58)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_59)
    let (local diff : Uint256) = uint256_sub(x_57, y_58)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func cleanup_uint256(value_60 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_60
    return (cleaned)
end

func setter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_104 : Uint256, arg1_105 : Uint256, value_106 : Uint256) -> ():
    alloc_locals
    allowance.write(arg0_104.low, arg0_104.high, arg1_105.low, arg1_105.high, value_106)
    return ()
end

func fun_approve{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    setter_fun_allowance{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender, var_guy, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var__low, var__high):
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
    return (var_.low, var_.high)
end

func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_86 : Uint256) -> (value_87 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0_86.low, arg0_86.high)
    return (res)
end

func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_109 : Uint256, value_110 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_109.low, arg0_109.high, value_110)
    return ()
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_61 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _1_62 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender_61)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_63 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _1_62, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender_61, _2_63)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_61 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_deposit(var_sender_61, var_value)
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
    let (local var : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var)
end

@external
func fun_get_balance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256) -> (var_low, var_high):
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
    return (var.low, var.high)
end

func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_83 : Uint256):
    alloc_locals
    let (res) = allowance.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_99 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_99)
    return ()
end

func __warp_block_1{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_66 : Uint256, var_src_64 : Uint256, var_wad_65 : Uint256) -> ():
    alloc_locals
    let (local _3_70 : Uint256) = getter_fun_allowance{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64, var_sender_66)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_71 : Uint256) = is_lt(_3_70, var_wad_65)
    local range_check_ptr = range_check_ptr
    let (local _5_72 : Uint256) = is_zero(_4_71)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_5_72)
    local range_check_ptr = range_check_ptr
    let (local _6_73 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_74 : Uint256) = cleanup_uint256(_6_73)
    let (local _8_75 : Uint256) = is_lt(_7_74, var_wad_65)
    local range_check_ptr = range_check_ptr
    let (local _9 : Uint256) = is_zero(_8_75)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_9)
    local range_check_ptr = range_check_ptr
    let (local _10 : Uint256) = getter_fun_allowance{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64, var_sender_66)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _11 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _10, var_wad_65)
    local range_check_ptr = range_check_ptr
    setter_fun_allowance{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64, var_sender_66, _11)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_0_if{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_69 : Uint256, var_sender_66 : Uint256, var_src_64 : Uint256, var_wad_65 : Uint256) -> ():
    alloc_locals
    if _2_69.low + _2_69.high != 0:
        __warp_block_1{
            pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
            var_sender_66, var_src_64, var_wad_65)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src_64 : Uint256, var_dst : Uint256, var_wad_65 : Uint256, var_sender_66 : Uint256) -> (
        var_67 : Uint256):
    alloc_locals
    let (local _1_68 : Uint256) = is_eq(var_src_64, var_sender_66)
    local range_check_ptr = range_check_ptr
    let (local _2_69 : Uint256) = is_zero(_1_68)
    local range_check_ptr = range_check_ptr
    __warp_block_0_if{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        _2_69, var_sender_66, var_src_64, var_wad_65)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _12 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _13 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _12, var_wad_65)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_src_64, _13)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _14 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _15 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _14, var_wad_65)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_dst, _15)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_67 : Uint256 = Uint256(low=1, high=0)
    return (var_67)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src_64 : Uint256, var_dst : Uint256, var_wad_65 : Uint256, var_sender_66 : Uint256) -> (
        var_67_low, var_67_high):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_67 : Uint256) = fun_transferFrom(
            var_src_64, var_dst, var_wad_65, var_sender_66)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_67.low, var_67.high)
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_wad_76 : Uint256, var_sender_77 : Uint256) -> ():
    alloc_locals
    let (local _1_78 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender_77)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_79 : Uint256) = is_lt(_1_78, var_wad_76)
    local range_check_ptr = range_check_ptr
    let (local _3_80 : Uint256) = is_zero(_2_79)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_3_80)
    local range_check_ptr = range_check_ptr
    let (local _4_81 : Uint256) = getter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender_77)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_82 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _4_81, var_wad_76)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf{
        pedersen_ptr=pedersen_ptr, range_check_ptr=range_check_ptr, storage_ptr=storage_ptr}(
        var_sender_77, _5_82)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_76 : Uint256, var_sender_77 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_76, var_sender_77)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

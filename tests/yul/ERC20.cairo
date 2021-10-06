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
    let (local _1_62 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_63 : Uint256) = is_gt(x, _1_62)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_63)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_sub_uint256{range_check_ptr}(x_64 : Uint256, y_65 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_66 : Uint256) = is_lt(x_64, y_65)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_66)
    let (local diff : Uint256) = uint256_sub(x_64, y_65)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func cleanup_uint256(value_67 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_67
    return (cleaned)
end

func setter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_111 : Uint256, arg1_112 : Uint256, value_113 : Uint256) -> ():
    alloc_locals
    allowance.write(arg0_111.low, arg0_111.high, arg1_112.low, arg1_112.high, value_113)
    return ()
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

@view
func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_93 : Uint256) -> (value_94 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0_93.low, arg0_93.high)
    return (res)
end

@external
func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_116 : Uint256, value_117 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_116.low, arg0_116.high, value_117)
    return ()
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_68 : Uint256, var_value : Uint256) -> (var_69 : Uint256, var_ : Uint256):
    alloc_locals
    let (local _1_70 : Uint256) = getter_fun_balanceOf(var_sender_68)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_71 : Uint256) = checked_add_uint256(_1_70, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_68, _2_71)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_69 : Uint256 = Uint256(low=21, high=0)
    local var_ : Uint256 = Uint256(low=12, high=0)
    return (var_69, var_)
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_68 : Uint256, var_value : Uint256) -> (var_69 : Uint256, var_ : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_69 : Uint256, local var_ : Uint256) = fun_deposit(var_sender_68, var_value)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_69=var_69, var_=var_)
end

func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_90 : Uint256):
    alloc_locals
    let (res) = allowance.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_106 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_106)
    return ()
end

func __warp_block_1{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender_73 : Uint256, var_src : Uint256, var_wad_72 : Uint256) -> ():
    alloc_locals
    let (local _3_77 : Uint256) = getter_fun_allowance(var_src, var_sender_73)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_78 : Uint256) = is_lt(_3_77, var_wad_72)
    local range_check_ptr = range_check_ptr
    let (local _5_79 : Uint256) = is_zero(_4_78)
    local range_check_ptr = range_check_ptr
    require_helper(_5_79)
    local range_check_ptr = range_check_ptr
    let (local _6_80 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_81 : Uint256) = cleanup_uint256(_6_80)
    let (local _8_82 : Uint256) = is_lt(_7_81, var_wad_72)
    local range_check_ptr = range_check_ptr
    let (local _9 : Uint256) = is_zero(_8_82)
    local range_check_ptr = range_check_ptr
    require_helper(_9)
    local range_check_ptr = range_check_ptr
    let (local _10 : Uint256) = getter_fun_allowance(var_src, var_sender_73)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _11 : Uint256) = checked_sub_uint256(_10, var_wad_72)
    local range_check_ptr = range_check_ptr
    setter_fun_allowance(var_src, var_sender_73, _11)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_0_if{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_76 : Uint256, var_sender_73 : Uint256, var_src : Uint256, var_wad_72 : Uint256) -> ():
    alloc_locals
    if _2_76.low + _2_76.high != 0:
        __warp_block_1(var_sender_73, var_src, var_wad_72)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256, var_dst : Uint256, var_wad_72 : Uint256, var_sender_73 : Uint256) -> (
        var_74 : Uint256):
    alloc_locals
    let (local _1_75 : Uint256) = is_eq(var_src, var_sender_73)
    local range_check_ptr = range_check_ptr
    let (local _2_76 : Uint256) = is_zero(_1_75)
    local range_check_ptr = range_check_ptr
    __warp_block_0_if(_2_76, var_sender_73, var_src, var_wad_72)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _12 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _13 : Uint256) = checked_sub_uint256(_12, var_wad_72)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_src, _13)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _14 : Uint256) = getter_fun_balanceOf(var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _15 : Uint256) = checked_add_uint256(_14, var_wad_72)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_dst, _15)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_74 : Uint256 = Uint256(low=1, high=0)
    return (var_74)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad_72 : Uint256, var_sender_73 : Uint256) -> (
        var_74 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_74 : Uint256) = fun_transferFrom(var_src, var_dst, var_wad_72, var_sender_73)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_74=var_74)
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_wad_83 : Uint256, var_sender_84 : Uint256) -> ():
    alloc_locals
    let (local _1_85 : Uint256) = getter_fun_balanceOf(var_sender_84)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_86 : Uint256) = is_lt(_1_85, var_wad_83)
    local range_check_ptr = range_check_ptr
    let (local _3_87 : Uint256) = is_zero(_2_86)
    local range_check_ptr = range_check_ptr
    require_helper(_3_87)
    local range_check_ptr = range_check_ptr
    let (local _4_88 : Uint256) = getter_fun_balanceOf(var_sender_84)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_89 : Uint256) = checked_sub_uint256(_4_88, var_wad_83)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_84, _5_89)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_component : Uint256, local expr_component_1 : Uint256) = fun_deposit(
        var_sender_84, var_wad_83)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_83 : Uint256, var_sender_84 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_83, var_sender_84)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

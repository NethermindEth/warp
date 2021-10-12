%lang starknet
%builtins pedersen range_check

from evm.calls import get_caller_data_uint256
from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_gt, is_lt, is_zero, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not, uint256_sub
from starkware.starknet.common.storage import Storage

@storage_var
func allowances(arg0_low, arg0_high, arg1_low, arg1_high) -> (res : Uint256):
end

@storage_var
func balances(arg0_low, arg0_high) -> (res : Uint256):
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

@storage_var
func this_address() -> (res : felt):
end

@storage_var
func address_initialized() -> (res : felt):
end

func __warp_block_00(_4_160 : Uint256) -> ():
    alloc_locals
    if _4_160.low + _4_160.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func setter_fun_allowances{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_147 : Uint256, arg1_148 : Uint256, value_149 : Uint256) -> ():
    alloc_locals
    allowances.write(arg0_147.low, arg0_147.high, arg1_148.low, arg1_148.high, value_149)
    return ()
end

func fun__approve{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_owner : Uint256, var_spender : Uint256, var_amount : Uint256) -> ():
    alloc_locals
    setter_fun_allowances(var_owner, var_spender, var_amount)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func fun_approve{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_88 : Uint256, var_amount_89 : Uint256) -> (var : Uint256):
    alloc_locals
    let (local _1_90 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun__approve(_1_90, var_spender_88, var_amount_89)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_88 : Uint256, var_amount_89 : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_approve(var_spender_88, var_amount_89)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

func getter_fun_balances{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_122 : Uint256) -> (value_123 : Uint256):
    alloc_locals
    let (res) = balances.read(arg0_122.low, arg0_122.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_142 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_142)
    return ()
end

func setter_fun_balances{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_152 : Uint256, value_153 : Uint256) -> ():
    alloc_locals
    balances.write(arg0_152.low, arg0_152.high, value_153)
    return ()
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_79 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_80 : Uint256) = is_gt(x, _1_79)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_80)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_transfer{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender : Uint256, var_recipient : Uint256, var_amount_81 : Uint256) -> ():
    alloc_locals
    let (local _1_82 : Uint256) = getter_fun_balances(var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_83 : Uint256) = is_lt(_1_82, var_amount_81)
    local range_check_ptr = range_check_ptr
    let (local _3_84 : Uint256) = is_zero(_2_83)
    local range_check_ptr = range_check_ptr
    require_helper(_3_84)
    local range_check_ptr = range_check_ptr
    let (local _4_85 : Uint256) = uint256_sub(_1_82, var_amount_81)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_sender, _4_85)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_86 : Uint256) = getter_fun_balances(var_recipient)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _6_87 : Uint256) = checked_add_uint256(_5_86, var_amount_81)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_recipient, _6_87)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_transfer_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender : Uint256, var_recipient : Uint256, var_amount_81 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_transfer(var_sender, var_recipient, var_amount_81)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

func getter_fun_allowances{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_119 : Uint256):
    alloc_locals
    let (res) = allowances.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func fun_transferFrom{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_105 : Uint256, var_recipient_106 : Uint256, var_amount_107 : Uint256) -> (
        var_108 : Uint256):
    alloc_locals
    fun_transfer(var_sender_105, var_recipient_106, var_amount_107)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _1_109 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_110 : Uint256) = getter_fun_allowances(var_sender_105, _1_109)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_111 : Uint256) = is_lt(_2_110, var_amount_107)
    local range_check_ptr = range_check_ptr
    let (local _4_112 : Uint256) = is_zero(_3_111)
    local range_check_ptr = range_check_ptr
    require_helper(_4_112)
    local range_check_ptr = range_check_ptr
    let (local _5_113 : Uint256) = uint256_sub(_2_110, var_amount_107)
    local range_check_ptr = range_check_ptr
    local _6_114 : Uint256 = _1_109
    fun__approve(var_sender_105, _1_109, _5_113)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_108 : Uint256 = Uint256(low=1, high=0)
    return (var_108)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_105 : Uint256, var_recipient_106 : Uint256, var_amount_107 : Uint256) -> (
        var_108 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_108 : Uint256) = fun_transferFrom(
            var_sender_105, var_recipient_106, var_amount_107)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_108=var_108)
end

func fun_increaseAllowance{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_99 : Uint256, var_addedValue : Uint256) -> (var_100 : Uint256):
    alloc_locals
    let (local _1_101 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_102 : Uint256) = getter_fun_allowances(_1_101, var_spender_99)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_103 : Uint256) = checked_add_uint256(_2_102, var_addedValue)
    local range_check_ptr = range_check_ptr
    local _4_104 : Uint256 = _1_101
    fun__approve(_1_101, var_spender_99, _3_103)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_100 : Uint256 = Uint256(low=1, high=0)
    return (var_100)
end

@external
func fun_increaseAllowance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_99 : Uint256, var_addedValue : Uint256) -> (var_100 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_100 : Uint256) = fun_increaseAllowance(var_spender_99, var_addedValue)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_100=var_100)
end

func fun_decreaseAllowance{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_91 : Uint256, var_subtractedValue : Uint256) -> (var_92 : Uint256):
    alloc_locals
    let (local _1_93 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_94 : Uint256) = getter_fun_allowances(_1_93, var_spender_91)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_95 : Uint256) = is_lt(_2_94, var_subtractedValue)
    local range_check_ptr = range_check_ptr
    let (local _4_96 : Uint256) = is_zero(_3_95)
    local range_check_ptr = range_check_ptr
    require_helper(_4_96)
    local range_check_ptr = range_check_ptr
    let (local _5_97 : Uint256) = uint256_sub(_2_94, var_subtractedValue)
    local range_check_ptr = range_check_ptr
    local _6_98 : Uint256 = _1_93
    fun__approve(_1_93, var_spender_91, _5_97)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_92 : Uint256 = Uint256(low=1, high=0)
    return (var_92)
end

@external
func fun_decreaseAllowance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_91 : Uint256, var_subtractedValue : Uint256) -> (var_92 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_92 : Uint256) = fun_decreaseAllowance(var_spender_91, var_subtractedValue)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_92=var_92)
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, init_address : felt) -> ():
    alloc_locals
    let (address_init) = address_initialized.read()
    if address_init == 0:
        this_address.write(init_address)
        address_initialized.write(1)
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar syscall_ptr : felt* = syscall_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar syscall_ptr : felt* = syscall_ptr
    end
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0

    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

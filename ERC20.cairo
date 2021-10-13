%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load, get_caller_data_uint256
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

@storage_var
func allowances(arg0_low, arg0_high, arg1_low, arg1_high) -> (res : Uint256):
end

@storage_var
func balances(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func bday() -> (res : Uint256):
end

@storage_var
func totalSupply() -> (res : Uint256):
end

func __warp_holder() -> (res : Uint256):
    return (res=Uint256(0, 0))
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

func __warp_cond_revert(_4_173 : Uint256) -> ():
    alloc_locals
    if _4_173.low + _4_173.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func validator_revert_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_169 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_170 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_171 : Uint256) = uint256_and(value_169, _1_170)
    local range_check_ptr = range_check_ptr
    let (local _3_172 : Uint256) = is_eq(value_169, _2_171)
    local range_check_ptr = range_check_ptr
    let (local _4_173 : Uint256) = is_zero(_3_172)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_173)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_address_1091{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=4, high=0)
    let (local value : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _1_1.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_addresst_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_34 : Uint256) -> (value0_35 : Uint256, value1_36 : Uint256):
    alloc_locals
    local _1_37 : Uint256 = Uint256(low=64, high=0)
    let (local _2_38 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_39 : Uint256) = u256_add(dataEnd_34, _2_38)
    local range_check_ptr = range_check_ptr
    let (local _4_40 : Uint256) = slt(_3_39, _1_37)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_40)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_35 : Uint256) = abi_decode_address_1091()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_41 : Uint256 = Uint256(low=36, high=0)
    let (local value1_36 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_41.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_35, value1_36)
end

func setter_fun_allowances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_157 : Uint256, arg1_158 : Uint256, value_159 : Uint256) -> ():
    alloc_locals
    allowances.write(arg0_157.low, arg0_157.high, arg1_158.low, arg1_158.high, value_159)
    return ()
end

func fun__approve{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_owner : Uint256, var_spender : Uint256, var_amount : Uint256) -> ():
    alloc_locals
    setter_fun_allowances(var_owner, var_spender, var_amount)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func fun_approve{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_95 : Uint256, var_amount_96 : Uint256) -> (var : Uint256):
    alloc_locals
    let (local _1_97 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun__approve(_1_97, var_spender_95, var_amount_96)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

func abi_encode_bool_to_bool_1099{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_62 : Uint256) -> ():
    alloc_locals
    let (local _1_63 : Uint256) = is_zero(value_62)
    local range_check_ptr = range_check_ptr
    let (local _2_64 : Uint256) = is_zero(_1_63)
    local range_check_ptr = range_check_ptr
    local _3_65 : Uint256 = Uint256(low=128, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_65.low, value=_2_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bool_549{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_73 : Uint256) -> (tail : Uint256):
    alloc_locals
    local tail : Uint256 = Uint256(low=160, high=0)
    abi_encode_bool_to_bool_1099(value0_73)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail)
end

func abi_decode{exec_env : ExecutionEnvironment, range_check_ptr}(dataEnd : Uint256) -> ():
    alloc_locals
    local _1_17 : Uint256 = Uint256(low=0, high=0)
    let (local _2_18 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_19 : Uint256) = u256_add(dataEnd, _2_18)
    local range_check_ptr = range_check_ptr
    let (local _4_20 : Uint256) = slt(_3_19, _1_17)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_20)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func getter_fun_totalSupply{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_136 : Uint256):
    alloc_locals
    let (res) = totalSupply.read()
    return (res)
end

func abi_encode_uint256_to_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_69 : Uint256, pos_70 : Uint256) -> ():
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_70.low, value=value_69)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_77 : Uint256, value0_78 : Uint256) -> (tail_79 : Uint256):
    alloc_locals
    local _1_80 : Uint256 = Uint256(low=32, high=0)
    let (local tail_79 : Uint256) = u256_add(headStart_77, _1_80)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_78, headStart_77)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_79)
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}() -> (value_2 : Uint256):
    alloc_locals
    local _1_3 : Uint256 = Uint256(low=36, high=0)
    let (local value_2 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_1_3.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value_2)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_2)
end

func abi_decode_addresst_addresst_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_26 : Uint256) -> (value0_27 : Uint256, value1_28 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_29 : Uint256 = Uint256(low=96, high=0)
    let (local _2_30 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_31 : Uint256) = u256_add(dataEnd_26, _2_30)
    local range_check_ptr = range_check_ptr
    let (local _4_32 : Uint256) = slt(_3_31, _1_29)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_32)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_27 : Uint256) = abi_decode_address_1091()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local value1_28 : Uint256) = abi_decode_address()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_33 : Uint256 = Uint256(low=68, high=0)
    let (local value2 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_33.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_27, value1_28, value2)
end

func getter_fun_balances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_132 : Uint256) -> (value_133 : Uint256):
    alloc_locals
    let (res) = balances.read(arg0_132.low, arg0_132.high)
    return (res)
end

func require_helper{exec_env : ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_152 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_152)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func setter_fun_balances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_162 : Uint256, value_163 : Uint256) -> ():
    alloc_locals
    balances.write(arg0_162.low, arg0_162.high, value_163)
    return ()
end

func checked_add_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_86 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_87 : Uint256) = is_gt(x, _1_86)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_87)
    local exec_env : ExecutionEnvironment = exec_env
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_transfer{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_sender : Uint256, var_recipient : Uint256, var_amount_88 : Uint256) -> ():
    alloc_locals
    let (local _1_89 : Uint256) = getter_fun_balances(var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_90 : Uint256) = is_lt(_1_89, var_amount_88)
    local range_check_ptr = range_check_ptr
    let (local _3_91 : Uint256) = is_zero(_2_90)
    local range_check_ptr = range_check_ptr
    require_helper(_3_91)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_92 : Uint256) = uint256_sub(_1_89, var_amount_88)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_sender, _4_92)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_93 : Uint256) = getter_fun_balances(var_recipient)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_94 : Uint256) = checked_add_uint256(_5_93, var_amount_88)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_recipient, _6_94)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func getter_fun_allowances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0 : Uint256, arg1 : Uint256) -> (value_129 : Uint256):
    alloc_locals
    let (res) = allowances.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func fun_transferFrom{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_115 : Uint256, var_recipient_116 : Uint256, var_amount_117 : Uint256) -> (
        var_118 : Uint256):
    alloc_locals
    fun_transfer(var_sender_115, var_recipient_116, var_amount_117)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _1_119 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_120 : Uint256) = getter_fun_allowances(var_sender_115, _1_119)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_121 : Uint256) = is_lt(_2_120, var_amount_117)
    local range_check_ptr = range_check_ptr
    let (local _4_122 : Uint256) = is_zero(_3_121)
    local range_check_ptr = range_check_ptr
    require_helper(_4_122)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_123 : Uint256) = uint256_sub(_2_120, var_amount_117)
    local range_check_ptr = range_check_ptr
    local _6_124 : Uint256 = _1_119
    fun__approve(var_sender_115, _1_119, _5_123)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_118 : Uint256 = Uint256(low=1, high=0)
    return (var_118)
end

func abi_encode_bool_to_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_66 : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_67 : Uint256) = is_zero(value_66)
    local range_check_ptr = range_check_ptr
    let (local _2_68 : Uint256) = is_zero(_1_67)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos.low, value=_2_68)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_74 : Uint256) -> (tail_75 : Uint256):
    alloc_locals
    local _1_76 : Uint256 = Uint256(low=32, high=0)
    let (local tail_75 : Uint256) = u256_add(headStart, _1_76)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_74, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_75)
end

func abi_encode_uint8_to_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_71 : Uint256) -> ():
    alloc_locals
    local _1_72 : Uint256 = Uint256(low=18, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_71.low, value=_1_72)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_81 : Uint256) -> (tail_82 : Uint256):
    alloc_locals
    local _1_83 : Uint256 = Uint256(low=32, high=0)
    let (local tail_82 : Uint256) = u256_add(headStart_81, _1_83)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(headStart_81)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_82)
end

func fun_increaseAllowance{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_109 : Uint256, var_addedValue : Uint256) -> (var_110 : Uint256):
    alloc_locals
    let (local _1_111 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_112 : Uint256) = getter_fun_allowances(_1_111, var_spender_109)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_113 : Uint256) = checked_add_uint256(_2_112, var_addedValue)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_114 : Uint256 = _1_111
    fun__approve(_1_111, var_spender_109, _3_113)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_110 : Uint256 = Uint256(low=1, high=0)
    return (var_110)
end

func fun_decreaseAllowance{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_101 : Uint256, var_subtractedValue : Uint256) -> (var_102 : Uint256):
    alloc_locals
    let (local _1_103 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_104 : Uint256) = getter_fun_allowances(_1_103, var_spender_101)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_105 : Uint256) = is_lt(_2_104, var_subtractedValue)
    local range_check_ptr = range_check_ptr
    let (local _4_106 : Uint256) = is_zero(_3_105)
    local range_check_ptr = range_check_ptr
    require_helper(_4_106)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_107 : Uint256) = uint256_sub(_2_104, var_subtractedValue)
    local range_check_ptr = range_check_ptr
    local _6_108 : Uint256 = _1_103
    fun__approve(_1_103, var_spender_101, _5_107)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_102 : Uint256 = Uint256(low=1, high=0)
    return (var_102)
end

func fun_transfer_79{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_recipient_125 : Uint256, var_amount_126 : Uint256) -> (var_127 : Uint256):
    alloc_locals
    let (local _1_128 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun_transfer(_1_128, var_recipient_125, var_amount_126)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_127 : Uint256 = Uint256(low=1, high=0)
    return (var_127)
end

func abi_decode_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(dataEnd_55 : Uint256) -> (
        value0_56 : Uint256):
    alloc_locals
    local _1_57 : Uint256 = Uint256(low=32, high=0)
    let (local _2_58 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_59 : Uint256) = u256_add(dataEnd_55, _2_58)
    local range_check_ptr = range_check_ptr
    let (local _4_60 : Uint256) = slt(_3_59, _1_57)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_60)
    local exec_env : ExecutionEnvironment = exec_env
    local _5_61 : Uint256 = Uint256(low=4, high=0)
    let (local value0_56 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_61.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_56)
end

func setter_fun_bday{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_166 : Uint256) -> ():
    alloc_locals
    bday.write(value_166)
    return ()
end

func fun_setBday{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_newBday : Uint256) -> ():
    alloc_locals
    setter_fun_bday(var_newBday)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _2 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_holder()
    __warp_cond_revert(_11)
    local exec_env : ExecutionEnvironment = exec_env
    local _12 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_addresst_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = fun_approve(param, param_1)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _15 : Uint256) = abi_encode_bool_549(_14)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = u256_add(_15, _13)
    local range_check_ptr = range_check_ptr
    local _17 : Uint256 = _2

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _18 : Uint256) = __warp_holder()
    __warp_cond_revert(_18)
    local exec_env : ExecutionEnvironment = exec_env
    local _19 : Uint256 = _4
    abi_decode(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _20 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = uint256_sub(_20, memPos)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _22 : Uint256) = __warp_holder()
    __warp_cond_revert(_22)
    local exec_env : ExecutionEnvironment = exec_env
    local _23 : Uint256 = _4
    let (local param_2 : Uint256, local param_3 : Uint256,
        local param_4 : Uint256) = abi_decode_addresst_addresst_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_transferFrom(param_2, param_3, param_4)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_1 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _24 : Uint256) = abi_encode_bool(memPos_1, ret_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25 : Uint256) = uint256_sub(_24, memPos_1)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _26 : Uint256) = __warp_holder()
    __warp_cond_revert(_26)
    local exec_env : ExecutionEnvironment = exec_env
    local _27 : Uint256 = _4
    abi_decode(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPos_2 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _28 : Uint256) = abi_encode_uint8(memPos_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29 : Uint256) = uint256_sub(_28, memPos_2)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _30 : Uint256) = __warp_holder()
    __warp_cond_revert(_30)
    local exec_env : ExecutionEnvironment = exec_env
    local _31 : Uint256 = _4
    let (local param_5 : Uint256, local param_6 : Uint256) = abi_decode_addresst_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_increaseAllowance(param_5, param_6)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_3 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _32 : Uint256) = abi_encode_bool(memPos_3, ret_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_3)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _34 : Uint256) = __warp_holder()
    __warp_cond_revert(_34)
    local exec_env : ExecutionEnvironment = exec_env
    local _35 : Uint256 = _4
    let (local param_7 : Uint256, local param_8 : Uint256) = abi_decode_addresst_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = fun_decreaseAllowance(param_7, param_8)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_4 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _36 : Uint256) = abi_encode_bool(memPos_4, ret_3)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = uint256_sub(_36, memPos_4)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _38 : Uint256) = __warp_holder()
    __warp_cond_revert(_38)
    local exec_env : ExecutionEnvironment = exec_env
    local _39 : Uint256 = _4
    let (local param_9 : Uint256, local param_10 : Uint256) = abi_decode_addresst_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = fun_transfer_79(param_9, param_10)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_5 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _40 : Uint256) = abi_encode_bool(memPos_5, ret_4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _41 : Uint256) = uint256_sub(_40, memPos_5)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _42 : Uint256) = __warp_holder()
    __warp_cond_revert(_42)
    local exec_env : ExecutionEnvironment = exec_env
    local _43 : Uint256 = _4
    let (local _44 : Uint256) = abi_decode_uint256(_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_setBday(_44)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _45 : Uint256 = _7
    let (local _46 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_18{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3706639928, high=0))
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_17(_1, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_18(_1, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return ()
    end
end

func __warp_block_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2876712492, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_8(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_15(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_16(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_14{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_14(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_12{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2757214935, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_12(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=961581905, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_10(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_8(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_6{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_6(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_1, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3(_2, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_4(_1, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=157198259, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_1(_1, _2, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_2(_1, _2, _4, _7, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _7.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_1(_1, _10, _2, _4, _7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_1, _2, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, init_address : felt) -> ():
    alloc_locals
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(init_address)
    address_initialized.write(1)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local _1 : Uint256 = Uint256(low=64, high=0)
    local _2 : Uint256 = Uint256(low=128, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1.low, value=_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3 : Uint256 = Uint256(low=4, high=0)
    local _4 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_0(_1, _2, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

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
func totalSupply() -> (res : Uint256):
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

func shift_right_unsigned{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_199 : Uint256) -> (newValue : Uint256):
    alloc_locals
    local _1_200 : Uint256 = Uint256(low=224, high=0)
    let (local newValue : Uint256) = uint256_shr(_1_200, value_199)
    local range_check_ptr = range_check_ptr
    return (newValue)
end

func cleanup_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(value_99 : Uint256) -> (
        cleaned_100 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_101 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local cleaned_100 : Uint256) = uint256_and(value_99, _1_101)
    local range_check_ptr = range_check_ptr
    return (cleaned_100)
end

func cleanup_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_95 : Uint256) -> (
        cleaned : Uint256):
    alloc_locals
    let (local cleaned : Uint256) = cleanup_uint160(value_95)
    local range_check_ptr = range_check_ptr
    return (cleaned)
end

func __warp_cond_revert(_3_204 : Uint256) -> ():
    alloc_locals
    if _3_204.low + _3_204.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func validator_revert_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_201 : Uint256) -> ():
    alloc_locals
    let (local _1_202 : Uint256) = cleanup_address(value_201)
    local range_check_ptr = range_check_ptr
    let (local _2_203 : Uint256) = is_eq(value_201, _1_202)
    local range_check_ptr = range_check_ptr
    let (local _3_204 : Uint256) = is_zero(_2_203)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_204)
    return ()
end

func abi_decode_address_1678{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=4, high=0)
    let (local value : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _1_1.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value)
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_address_262{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value_4 : Uint256):
    alloc_locals
    let (local value_4 : Uint256) = abi_decode_address_1678()
    local range_check_ptr = range_check_ptr
    return (value_4)
end

func abi_decode_address_1124{exec_env : ExecutionEnvironment, range_check_ptr}(
        end__warp_mangled : Uint256) -> (value_5 : Uint256):
    alloc_locals
    let (local value_5 : Uint256) = abi_decode_address_262()
    local range_check_ptr = range_check_ptr
    return (value_5)
end

func cleanup_uint256(value_103 : Uint256) -> (cleaned_104 : Uint256):
    alloc_locals
    local cleaned_104 : Uint256 = value_103
    return (cleaned_104)
end

func validator_revert_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_207 : Uint256) -> ():
    alloc_locals
    let (local _1_208 : Uint256) = cleanup_uint256(value_207)
    let (local _2_209 : Uint256) = is_eq(value_207, _1_208)
    local range_check_ptr = range_check_ptr
    let (local _3_210 : Uint256) = is_zero(_2_209)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_210)
    return ()
end

func abi_decode_uint256{exec_env : ExecutionEnvironment, range_check_ptr}() -> (value_25 : Uint256):
    alloc_locals
    local _1_26 : Uint256 = Uint256(low=36, high=0)
    let (local value_25 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_1_26.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint256(value_25)
    local range_check_ptr = range_check_ptr
    return (value_25)
end

func abi_decode_uint256_263{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value_30 : Uint256):
    alloc_locals
    let (local value_30 : Uint256) = abi_decode_uint256()
    local range_check_ptr = range_check_ptr
    return (value_30)
end

func abi_decode_uint256_1130{exec_env : ExecutionEnvironment, range_check_ptr}(
        end_31 : Uint256) -> (value_32 : Uint256):
    alloc_locals
    let (local value_32 : Uint256) = abi_decode_uint256_263()
    local range_check_ptr = range_check_ptr
    return (value_32)
end

func abi_decode_addresst_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_49 : Uint256) -> (value0_50 : Uint256, value1_51 : Uint256):
    alloc_locals
    local _1_52 : Uint256 = Uint256(low=64, high=0)
    let (local _2_53 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_54 : Uint256) = u256_add(dataEnd_49, _2_53)
    local range_check_ptr = range_check_ptr
    let (local _4_55 : Uint256) = slt(_3_54, _1_52)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_55)
    let (local value0_50 : Uint256) = abi_decode_address_1124(dataEnd_49)
    local range_check_ptr = range_check_ptr
    let (local value1_51 : Uint256) = abi_decode_uint256_1130(dataEnd_49)
    local range_check_ptr = range_check_ptr
    return (value0_50, value1_51)
end

func setter_fun_allowances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_190 : Uint256, arg1_191 : Uint256, value_192 : Uint256) -> ():
    alloc_locals
    allowances.write(arg0_190.low, arg0_190.high, arg1_191.low, arg1_191.high, value_192)
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
    return ()
end

func fun_approve{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_121 : Uint256, var_amount_122 : Uint256) -> (var_123 : Uint256):
    alloc_locals
    let (local _1_124 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun__approve(_1_124, var_spender_121, var_amount_122)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_123 : Uint256 = Uint256(low=1, high=0)
    return (var_123)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_121 : Uint256, var_amount_122 : Uint256) -> (var_123 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_123 : Uint256) = fun_approve(var_spender_121, var_amount_122)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_123=var_123)
end

func allocate_unbounded{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr : Uint256):
    alloc_locals
    local _1_87 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_87.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr)
end

func cleanup_bool{exec_env : ExecutionEnvironment, range_check_ptr}(value_96 : Uint256) -> (
        cleaned_97 : Uint256):
    alloc_locals
    let (local _1_98 : Uint256) = is_zero(value_96)
    local range_check_ptr = range_check_ptr
    let (local cleaned_97 : Uint256) = is_zero(_1_98)
    local range_check_ptr = range_check_ptr
    return (cleaned_97)
end

func abi_encode_bool_to_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_69 : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_70 : Uint256) = cleanup_bool(value_69)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos.low, value=_1_70)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_77 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_78 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart, _1_78)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_77, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode{exec_env : ExecutionEnvironment, range_check_ptr}(dataEnd : Uint256) -> ():
    alloc_locals
    local _1_33 : Uint256 = Uint256(low=0, high=0)
    let (local _2_34 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_35 : Uint256) = u256_add(dataEnd, _2_34)
    local range_check_ptr = range_check_ptr
    let (local _4_36 : Uint256) = slt(_3_35, _1_33)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_36)
    return ()
end

@view
func getter_fun_totalSupply{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_169 : Uint256):
    alloc_locals
    let (res) = totalSupply.read()
    return (res)
end

func fun_totalSupply{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (var_ : Uint256):
    alloc_locals
    let (local var_ : Uint256) = getter_fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_)
end

@view
func fun_totalSupply_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        ) -> (var_ : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_ : Uint256) = fun_totalSupply()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_=var_)
end

func abi_encode_uint256_to_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_71 : Uint256, pos_72 : Uint256) -> ():
    alloc_locals
    let (local _1_73 : Uint256) = cleanup_uint256(value_71)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_72.low, value=_1_73)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_79 : Uint256, value0_80 : Uint256) -> (tail_81 : Uint256):
    alloc_locals
    local _1_82 : Uint256 = Uint256(low=32, high=0)
    let (local tail_81 : Uint256) = u256_add(headStart_79, _1_82)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_80, headStart_79)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_81)
end

func abi_decode_address_1679{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value_2 : Uint256):
    alloc_locals
    local _1_3 : Uint256 = Uint256(low=36, high=0)
    let (local value_2 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_1_3.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value_2)
    local range_check_ptr = range_check_ptr
    return (value_2)
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}() -> (value_6 : Uint256):
    alloc_locals
    let (local value_6 : Uint256) = abi_decode_address_1679()
    local range_check_ptr = range_check_ptr
    return (value_6)
end

func abi_decode_address_1125{exec_env : ExecutionEnvironment, range_check_ptr}(end_7 : Uint256) -> (
        value_8 : Uint256):
    alloc_locals
    let (local value_8 : Uint256) = abi_decode_address()
    local range_check_ptr = range_check_ptr
    return (value_8)
end

func abi_decode_uint256_1683{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value_23 : Uint256):
    alloc_locals
    local _1_24 : Uint256 = Uint256(low=68, high=0)
    let (local value_23 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_1_24.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint256(value_23)
    local range_check_ptr = range_check_ptr
    return (value_23)
end

func abi_decode_uint256_263_1128{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        value_27 : Uint256):
    alloc_locals
    let (local value_27 : Uint256) = abi_decode_uint256_1683()
    local range_check_ptr = range_check_ptr
    return (value_27)
end

func abi_decode_uint256_1128{exec_env : ExecutionEnvironment, range_check_ptr}(
        end_28 : Uint256) -> (value_29 : Uint256):
    alloc_locals
    let (local value_29 : Uint256) = abi_decode_uint256_263_1128()
    local range_check_ptr = range_check_ptr
    return (value_29)
end

func abi_decode_addresst_addresst_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_42 : Uint256) -> (value0_43 : Uint256, value1_44 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_45 : Uint256 = Uint256(low=96, high=0)
    let (local _2_46 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_47 : Uint256) = u256_add(dataEnd_42, _2_46)
    local range_check_ptr = range_check_ptr
    let (local _4_48 : Uint256) = slt(_3_47, _1_45)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_48)
    let (local value0_43 : Uint256) = abi_decode_address_1124(dataEnd_42)
    local range_check_ptr = range_check_ptr
    let (local value1_44 : Uint256) = abi_decode_address_1125(dataEnd_42)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = abi_decode_uint256_1128(dataEnd_42)
    local range_check_ptr = range_check_ptr
    return (value0_43, value1_44, value2)
end

func getter_fun_balances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_165 : Uint256) -> (value_166 : Uint256):
    alloc_locals
    let (res) = balances.read(arg0_165.low, arg0_165.high)
    return (res)
end

func require_helper{exec_env : ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_185 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_185)
    return ()
end

func wrapping_sub_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_213 : Uint256, y_214 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_215 : Uint256) = uint256_sub(x_213, y_214)
    local range_check_ptr = range_check_ptr
    let (local diff : Uint256) = cleanup_uint256(_1_215)
    return (diff)
end

func setter_fun_balances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0_195 : Uint256, value_196 : Uint256) -> ():
    alloc_locals
    balances.write(arg0_195.low, arg0_195.high, value_196)
    return ()
end

func checked_add_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local x_1 : Uint256) = cleanup_uint256(x)
    let (local y_1 : Uint256) = cleanup_uint256(y)
    let (local _1_93 : Uint256) = uint256_not(y_1)
    local range_check_ptr = range_check_ptr
    let (local _2_94 : Uint256) = is_gt(x_1, _1_93)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_94)
    let (local sum : Uint256) = u256_add(x_1, y_1)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_transfer{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_sender : Uint256, var_recipient : Uint256, var_amount_110 : Uint256) -> ():
    alloc_locals
    let (local _1_111 : Uint256) = getter_fun_balances(var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_112 : Uint256) = cleanup_uint256(var_amount_110)
    let (local _3_113 : Uint256) = cleanup_uint256(_1_111)
    let (local _4_114 : Uint256) = is_lt(_3_113, _2_112)
    local range_check_ptr = range_check_ptr
    let (local _5_115 : Uint256) = is_zero(_4_114)
    local range_check_ptr = range_check_ptr
    require_helper(_5_115)
    local range_check_ptr = range_check_ptr
    let (local _6_116 : Uint256) = wrapping_sub_uint256(_1_111, var_amount_110)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_sender, _6_116)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_117 : Uint256) = getter_fun_balances(var_recipient)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _8_118 : Uint256) = checked_add_uint256(_7_117, var_amount_110)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_recipient, _8_118)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_transfer_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender : Uint256, var_recipient : Uint256, var_amount_110 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_transfer(var_sender, var_recipient, var_amount_110)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

func getter_fun_allowances{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0 : Uint256, arg1 : Uint256) -> (value_162 : Uint256):
    alloc_locals
    let (res) = allowances.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

func fun_transferFrom{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_146 : Uint256, var_recipient_147 : Uint256, var_amount_148 : Uint256) -> (
        var_149 : Uint256):
    alloc_locals
    fun_transfer(var_sender_146, var_recipient_147, var_amount_148)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _1_150 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_151 : Uint256) = getter_fun_allowances(var_sender_146, _1_150)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_152 : Uint256) = cleanup_uint256(var_amount_148)
    let (local _4_153 : Uint256) = cleanup_uint256(_2_151)
    let (local _5_154 : Uint256) = is_lt(_4_153, _3_152)
    local range_check_ptr = range_check_ptr
    let (local _6_155 : Uint256) = is_zero(_5_154)
    local range_check_ptr = range_check_ptr
    require_helper(_6_155)
    local range_check_ptr = range_check_ptr
    let (local _7_156 : Uint256) = wrapping_sub_uint256(_2_151, var_amount_148)
    local range_check_ptr = range_check_ptr
    local _8_157 : Uint256 = _1_150
    fun__approve(var_sender_146, _1_150, _7_156)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_149 : Uint256 = Uint256(low=1, high=0)
    return (var_149)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_146 : Uint256, var_recipient_147 : Uint256, var_amount_148 : Uint256) -> (
        var_149 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_149 : Uint256) = fun_transferFrom(
            var_sender_146, var_recipient_147, var_amount_148)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_149=var_149)
end

func cleanup_uint8_1138() -> (cleaned_105 : Uint256):
    alloc_locals
    local cleaned_105 : Uint256 = Uint256(low=18, high=0)
    return (cleaned_105)
end

func convert_rational_by_to_uint8() -> (converted_109 : Uint256):
    alloc_locals
    let (local converted_109 : Uint256) = cleanup_uint8_1138()
    return (converted_109)
end

func fun_decimals() -> (var_129 : Uint256):
    alloc_locals
    let (local var_129 : Uint256) = convert_rational_by_to_uint8()
    return (var_129)
end

@view
func fun_decimals_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        ) -> (var_129 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_129 : Uint256) = fun_decimals()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_129=var_129)
end

func cleanup_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(value_106 : Uint256) -> (
        cleaned_107 : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=255, high=0)
    let (local cleaned_107 : Uint256) = uint256_and(value_106, _1_108)
    local range_check_ptr = range_check_ptr
    return (cleaned_107)
end

func abi_encode_uint8_to_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_74 : Uint256, pos_75 : Uint256) -> ():
    alloc_locals
    let (local _1_76 : Uint256) = cleanup_uint8(value_74)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_75.low, value=_1_76)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_83 : Uint256, value0_84 : Uint256) -> (tail_85 : Uint256):
    alloc_locals
    local _1_86 : Uint256 = Uint256(low=32, high=0)
    let (local tail_85 : Uint256) = u256_add(headStart_83, _1_86)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(value0_84, headStart_83)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_85)
end

func fun_increaseAllowance{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_140 : Uint256, var_addedValue : Uint256) -> (var_141 : Uint256):
    alloc_locals
    let (local _1_142 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_143 : Uint256) = getter_fun_allowances(_1_142, var_spender_140)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_144 : Uint256) = checked_add_uint256(_2_143, var_addedValue)
    local range_check_ptr = range_check_ptr
    local _4_145 : Uint256 = _1_142
    fun__approve(_1_142, var_spender_140, _3_144)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_141 : Uint256 = Uint256(low=1, high=0)
    return (var_141)
end

@external
func fun_increaseAllowance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_140 : Uint256, var_addedValue : Uint256) -> (var_141 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_141 : Uint256) = fun_increaseAllowance(var_spender_140, var_addedValue)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_141=var_141)
end

func fun_decreaseAllowance{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_130 : Uint256, var_subtractedValue : Uint256) -> (var_131 : Uint256):
    alloc_locals
    let (local _1_132 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_133 : Uint256) = getter_fun_allowances(_1_132, var_spender_130)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_134 : Uint256) = cleanup_uint256(var_subtractedValue)
    let (local _4_135 : Uint256) = cleanup_uint256(_2_133)
    let (local _5_136 : Uint256) = is_lt(_4_135, _3_134)
    local range_check_ptr = range_check_ptr
    let (local _6_137 : Uint256) = is_zero(_5_136)
    local range_check_ptr = range_check_ptr
    require_helper(_6_137)
    local range_check_ptr = range_check_ptr
    let (local _7_138 : Uint256) = wrapping_sub_uint256(_2_133, var_subtractedValue)
    local range_check_ptr = range_check_ptr
    local _8_139 : Uint256 = _1_132
    fun__approve(_1_132, var_spender_130, _7_138)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_131 : Uint256 = Uint256(low=1, high=0)
    return (var_131)
end

@external
func fun_decreaseAllowance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_spender_130 : Uint256, var_subtractedValue : Uint256) -> (var_131 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_131 : Uint256) = fun_decreaseAllowance(var_spender_130, var_subtractedValue)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_131=var_131)
end

func fun_transfer_63{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_recipient_158 : Uint256, var_amount_159 : Uint256) -> (var_160 : Uint256):
    alloc_locals
    let (local _1_161 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun_transfer(_1_161, var_recipient_158, var_amount_159)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_160 : Uint256 = Uint256(low=1, high=0)
    return (var_160)
end

func abi_decode_addresst_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_37 : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_38 : Uint256 = Uint256(low=64, high=0)
    let (local _2_39 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_40 : Uint256) = u256_add(dataEnd_37, _2_39)
    local range_check_ptr = range_check_ptr
    let (local _4_41 : Uint256) = slt(_3_40, _1_38)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_41)
    let (local value0 : Uint256) = abi_decode_address_1124(dataEnd_37)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = abi_decode_address_1125(dataEnd_37)
    local range_check_ptr = range_check_ptr
    return (value0, value1)
end

func fun_allowance{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_owner_119 : Uint256, var_spender_120 : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (local var : Uint256) = getter_fun_allowances(var_owner_119, var_spender_120)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var)
end

@view
func fun_allowance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_owner_119 : Uint256, var_spender_120 : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_allowance(var_owner_119, var_spender_120)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

func abi_decode_array_address_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset : Uint256, end_9 : Uint256) -> (arrayPos : Uint256, length : Uint256):
    alloc_locals
    local _1_10 : Uint256 = Uint256(low=31, high=0)
    let (local _2_11 : Uint256) = u256_add(offset, _1_10)
    local range_check_ptr = range_check_ptr
    let (local _3_12 : Uint256) = slt(_2_11, end_9)
    local range_check_ptr = range_check_ptr
    let (local _4_13 : Uint256) = is_zero(_3_12)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_13)
    let (local length : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_14 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_15 : Uint256) = is_gt(length, _5_14)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_15)
    local _7_16 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos : Uint256) = u256_add(offset, _7_16)
    local range_check_ptr = range_check_ptr
    local _8_17 : Uint256 = _7_16
    local _9_18 : Uint256 = Uint256(low=5, high=0)
    let (local _10_19 : Uint256) = uint256_shl(_9_18, length)
    local range_check_ptr = range_check_ptr
    let (local _11_20 : Uint256) = u256_add(offset, _10_19)
    local range_check_ptr = range_check_ptr
    let (local _12_21 : Uint256) = u256_add(_11_20, _7_16)
    local range_check_ptr = range_check_ptr
    let (local _13_22 : Uint256) = is_gt(_12_21, end_9)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_22)
    return (arrayPos, length)
end

func abi_decode_array_address_dyn_calldata_ptr{exec_env : ExecutionEnvironment, range_check_ptr}(
        dataEnd_56 : Uint256) -> (value0_57 : Uint256, value1_58 : Uint256):
    alloc_locals
    local _1_59 : Uint256 = Uint256(low=32, high=0)
    let (local _2_60 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_61 : Uint256) = u256_add(dataEnd_56, _2_60)
    local range_check_ptr = range_check_ptr
    let (local _4_62 : Uint256) = slt(_3_61, _1_59)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_62)
    local _5_63 : Uint256 = Uint256(low=4, high=0)
    let (local offset_64 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_63.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_65 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_66 : Uint256) = is_gt(offset_64, _6_65)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_66)
    local _8_67 : Uint256 = _5_63
    let (local _9_68 : Uint256) = u256_add(_5_63, offset_64)
    local range_check_ptr = range_check_ptr
    let (local value0_1 : Uint256,
        local value1_1 : Uint256) = abi_decode_array_address_dyn_calldata(_9_68, dataEnd_56)
    local range_check_ptr = range_check_ptr
    local value0_57 : Uint256 = value0_1
    local value1_58 : Uint256 = value1_1
    return (value0_57, value1_58)
end

func cleanup_uint256_1137() -> (cleaned_102 : Uint256):
    alloc_locals
    local cleaned_102 : Uint256 = Uint256(low=0, high=0)
    return (cleaned_102)
end

func convert_rational_by_to_uint256() -> (converted : Uint256):
    alloc_locals
    let (local converted : Uint256) = cleanup_uint256_1137()
    return (converted)
end

func calldata_array_index_access_address_dyn_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref : Uint256, length_88 : Uint256, index : Uint256) -> (addr : Uint256):
    alloc_locals
    let (local _1_89 : Uint256) = is_lt(index, length_88)
    local range_check_ptr = range_check_ptr
    let (local _2_90 : Uint256) = is_zero(_1_89)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_90)
    local _3_91 : Uint256 = Uint256(low=5, high=0)
    let (local _4_92 : Uint256) = uint256_shl(_3_91, index)
    local range_check_ptr = range_check_ptr
    let (local addr : Uint256) = u256_add(base_ref, _4_92)
    local range_check_ptr = range_check_ptr
    return (addr)
end

func read_from_calldatat_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr : Uint256) -> (returnValue : Uint256):
    alloc_locals
    let (local value_184 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value_184)
    local range_check_ptr = range_check_ptr
    local returnValue : Uint256 = value_184
    return (returnValue)
end

func fun_balanceOf_dynArgs_dynArgs{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_account_offset : Uint256, var_account_length : Uint256) -> (
        var_125 : Uint256):
    alloc_locals
    let (local _1_126 : Uint256) = convert_rational_by_to_uint256()
    let (local _2_127 : Uint256) = calldata_array_index_access_address_dyn_calldata(
        var_account_offset, var_account_length, _1_126)
    local range_check_ptr = range_check_ptr
    let (local _3_128 : Uint256) = read_from_calldatat_address(_2_127)
    local range_check_ptr = range_check_ptr
    let (local var_125 : Uint256) = getter_fun_balances(_3_128)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_125)
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _10 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_10)
    local _11 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_addresst_uint256(_4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_approve(param, param_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _12 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_sub(_12, memPos)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(_4 : Uint256) -> ():
    alloc_locals
    let (local _14 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_14)
    local _15 : Uint256 = _4
    abi_decode(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_1 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _16 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = uint256_sub(_16, memPos_1)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _18 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_18)
    local _19 : Uint256 = _4
    let (local param_2 : Uint256, local param_3 : Uint256,
        local param_4 : Uint256) = abi_decode_addresst_addresst_uint256(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_transferFrom(param_2, param_3, param_4)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_2 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _20 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = uint256_sub(_20, memPos_2)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _22 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_22)
    local _23 : Uint256 = _4
    abi_decode(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = fun_decimals()
    let (local memPos_3 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _24 : Uint256) = abi_encode_uint8(memPos_3, ret_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25 : Uint256) = uint256_sub(_24, memPos_3)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _26 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_26)
    local _27 : Uint256 = _4
    let (local param_5 : Uint256, local param_6 : Uint256) = abi_decode_addresst_uint256(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = fun_increaseAllowance(param_5, param_6)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_4 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _28 : Uint256) = abi_encode_bool(memPos_4, ret_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29 : Uint256) = uint256_sub(_28, memPos_4)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _30 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_30)
    local _31 : Uint256 = _4
    let (local param_7 : Uint256, local param_8 : Uint256) = abi_decode_addresst_uint256(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_5 : Uint256) = fun_decreaseAllowance(param_7, param_8)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_5 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _32 : Uint256) = abi_encode_bool(memPos_5, ret_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_5)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _4 : Uint256) -> ():
    alloc_locals
    let (local _34 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_34)
    local _35 : Uint256 = _4
    let (local param_9 : Uint256, local param_10 : Uint256) = abi_decode_addresst_uint256(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_6 : Uint256) = fun_transfer_63(param_9, param_10)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_6 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _36 : Uint256) = abi_encode_bool(memPos_6, ret_6)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = uint256_sub(_36, memPos_6)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(_4 : Uint256) -> ():
    alloc_locals
    let (local _38 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_38)
    local _39 : Uint256 = _4
    let (local param_11 : Uint256, local param_12 : Uint256) = abi_decode_addresst_address(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_7 : Uint256) = fun_allowance(param_11, param_12)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_7 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _40 : Uint256) = abi_encode_uint256(memPos_7, ret_7)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _41 : Uint256) = uint256_sub(_40, memPos_7)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_19{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(_4 : Uint256) -> ():
    alloc_locals
    let (local _42 : Uint256) = Uint256(0, 0)
    __warp_cond_revert(_42)
    local _43 : Uint256 = _4
    let (local param_13 : Uint256,
        local param_14 : Uint256) = abi_decode_array_address_dyn_calldata_ptr(_4)
    local range_check_ptr = range_check_ptr
    let (local ret_8 : Uint256) = fun_balanceOf_dynArgs_dynArgs(param_13, param_14)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_8 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _44 : Uint256) = abi_encode_uint256(memPos_8, ret_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _45 : Uint256) = uint256_sub(_44, memPos_8)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_19(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_18{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4039700746, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_9(_4, __warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_17(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_18(_4, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3714247998, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_8(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_15(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_16(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_14(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2757214935, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_12(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=961581905, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_10(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_8(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_6(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3(_4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_4(_4, match_var)
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
        _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=157198259, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_1(_4, __warp_subexpr_0, match_var)
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
        _4 : Uint256, _9 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _9
    __warp_block_2(_4, match_var)
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
        _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _7.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _9 : Uint256) = shift_right_unsigned(_8)
    local range_check_ptr = range_check_ptr
    __warp_block_1(_4, _9)
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
        _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_4)
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
    local _1 : Uint256 = Uint256(low=128, high=0)
    local _2 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2.low, value=_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3 : Uint256 = Uint256(low=4, high=0)
    local _4 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_4, _6)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

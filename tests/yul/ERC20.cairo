%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load
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
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func balanceOf(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func decimals() -> (res : Uint256):
end

@storage_var
func totalSupply() -> (res : Uint256):
end

func __warp_holder() -> (res : Uint256):
    return (Uint256(0, 0))
end

@storage_var
func this_address() -> (res : felt):
end

func address{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}() -> (
        res : Uint256):
    let (addr) = this_address.read()
    return (res=Uint256(low=addr, high=0))
end

@storage_var
func address_initialized() -> (res : felt):
end

func gas() -> (res : Uint256):
    return (Uint256(100000, 100000))
end

func initialize_address{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end

func __warp_cond_revert(_3_3 : Uint256) -> ():
    alloc_locals
    if _3_3.low + _3_3.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=0, high=0)
    let (local _2_2 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, _1_1)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    return ()
end

@view
func getter_fun_totalSupply{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        ) -> (value_85 : Uint256):
    alloc_locals
    let (res) = totalSupply.read()
    return (res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_32 : Uint256, pos_33 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_33.low, value=value_32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_41 : Uint256, value0_42 : Uint256) -> (tail_43 : Uint256):
    alloc_locals
    local _1_44 : Uint256 = Uint256(low=32, high=0)
    let (local tail_43 : Uint256) = u256_add(headStart_41, _1_44)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_42, headStart_41)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_43)
end

@view
func getter_fun_decimals{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        ) -> (value_83 : Uint256):
    alloc_locals
    let (res) = decimals.read()
    return (res)
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_34 : Uint256, pos_35 : Uint256) -> ():
    alloc_locals
    local _1_36 : Uint256 = Uint256(low=255, high=0)
    let (local _2_37 : Uint256) = uint256_and(value_34, _1_36)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_35.low, value=_2_37)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_52 : Uint256, value0_53 : Uint256) -> (tail_54 : Uint256):
    alloc_locals
    local _1_55 : Uint256 = Uint256(low=32, high=0)
    let (local tail_54 : Uint256) = u256_add(headStart_52, _1_55)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(value0_53, headStart_52)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_54)
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_9 : Uint256, dataEnd_10 : Uint256) -> (value0_11 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_12 : Uint256 = Uint256(low=64, high=0)
    let (local _2_13 : Uint256) = uint256_sub(dataEnd_10, headStart_9)
    local range_check_ptr = range_check_ptr
    let (local _3_14 : Uint256) = slt(_2_13, _1_12)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_14)
    let (local value0_11 : Uint256) = calldata_load(headStart_9.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_15 : Uint256 = Uint256(low=32, high=0)
    let (local _5_16 : Uint256) = u256_add(headStart_9, _4_15)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldata_load(_5_16.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0_11, value1)
end

@view
func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256) -> (value_81 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0.low, arg0.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_93 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_93)
    return ()
end

func checked_sub_uint256{range_check_ptr}(x_58 : Uint256, y_59 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_60 : Uint256) = is_lt(x_58, y_59)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_60)
    let (local diff : Uint256) = uint256_sub(x_58, y_59)
    local range_check_ptr = range_check_ptr
    return (diff)
end

@external
func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_102 : Uint256, value_103 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_102.low, arg0_102.high, value_103)
    return ()
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_56 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_57 : Uint256) = is_gt(x, _1_56)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_57)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender : Uint256, var_value : Uint256) -> (var_ : Uint256, var : Uint256):
    alloc_locals
    let (local _1_61 : Uint256) = getter_fun_balanceOf(var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_62 : Uint256) = checked_add_uint256(_1_61, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender, _2_62)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_ : Uint256 = Uint256(low=21, high=0)
    local var : Uint256 = Uint256(low=12, high=0)
    return (var_, var)
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender : Uint256, var_value : Uint256) -> (var_ : Uint256, var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_ : Uint256, local var : Uint256) = fun_deposit(var_sender, var_value)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_=var_, var=var)
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_wad_74 : Uint256, var_sender_75 : Uint256) -> ():
    alloc_locals
    let (local _1_76 : Uint256) = getter_fun_balanceOf(var_sender_75)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_77 : Uint256) = is_lt(_1_76, var_wad_74)
    local range_check_ptr = range_check_ptr
    let (local _3_78 : Uint256) = is_zero(_2_77)
    local range_check_ptr = range_check_ptr
    require_helper(_3_78)
    local range_check_ptr = range_check_ptr
    let (local _4_79 : Uint256) = getter_fun_balanceOf(var_sender_75)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _5_80 : Uint256) = checked_sub_uint256(_4_79, var_wad_74)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_75, _5_80)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_component : Uint256, local expr_component_1 : Uint256) = fun_deposit(
        var_sender_75, var_wad_74)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_74 : Uint256, var_sender_75 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_74, var_sender_75)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end

func abi_decode_uint256t_uint256t_uint256t_uint256{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_17 : Uint256, dataEnd_18 : Uint256) -> (
        value0_19 : Uint256, value1_20 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=128, high=0)
    let (local _2_22 : Uint256) = uint256_sub(dataEnd_18, headStart_17)
    local range_check_ptr = range_check_ptr
    let (local _3_23 : Uint256) = slt(_2_22, _1_21)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_23)
    let (local value0_19 : Uint256) = calldata_load(headStart_17.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_24 : Uint256 = Uint256(low=32, high=0)
    let (local _5_25 : Uint256) = u256_add(headStart_17, _4_24)
    local range_check_ptr = range_check_ptr
    let (local value1_20 : Uint256) = calldata_load(_5_25.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_26 : Uint256 = Uint256(low=64, high=0)
    let (local _7_27 : Uint256) = u256_add(headStart_17, _6_26)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldata_load(_7_27.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_28 : Uint256 = Uint256(low=96, high=0)
    let (local _9_29 : Uint256) = u256_add(headStart_17, _8_28)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = calldata_load(_9_29.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0_19, value1_20, value2, value3)
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256, var_wad : Uint256) -> ():
    alloc_locals
    let (local _3_67 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_68 : Uint256) = is_lt(_3_67, var_wad)
    local range_check_ptr = range_check_ptr
    let (local _5_69 : Uint256) = is_zero(_4_68)
    local range_check_ptr = range_check_ptr
    require_helper(_5_69)
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_66 : Uint256, var_src : Uint256, var_wad : Uint256) -> ():
    alloc_locals
    if _2_66.low + _2_66.high != 0:
        __warp_block_0(var_src, var_wad)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256, var_dst : Uint256, var_wad : Uint256, var_sender_63 : Uint256) -> (
        var_64 : Uint256):
    alloc_locals
    let (local _1_65 : Uint256) = is_eq(var_src, var_sender_63)
    local range_check_ptr = range_check_ptr
    let (local _2_66 : Uint256) = is_zero(_1_65)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_2_66, var_src, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _6_70 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_71 : Uint256) = checked_sub_uint256(_6_70, var_wad)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_src, _7_71)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _8_72 : Uint256) = getter_fun_balanceOf(var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _9_73 : Uint256) = checked_add_uint256(_8_72, var_wad)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_dst, _9_73)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_64 : Uint256 = Uint256(low=1, high=0)
    return (var_64)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad : Uint256, var_sender_63 : Uint256) -> (
        var_64 : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_64 : Uint256) = fun_transferFrom(var_src, var_dst, var_wad, var_sender_63)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_64=var_64)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_30 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local _2_31 : Uint256) = is_zero(_1_30)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos.low, value=_2_31)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_38 : Uint256, value0_39 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_40 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_38, _1_40)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_39, headStart_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_4 : Uint256, dataEnd_5 : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_6 : Uint256 = Uint256(low=32, high=0)
    let (local _2_7 : Uint256) = uint256_sub(dataEnd_5, headStart_4)
    local range_check_ptr = range_check_ptr
    let (local _3_8 : Uint256) = slt(_2_7, _1_6)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_8)
    let (local value0 : Uint256) = calldata_load(headStart_4.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0)
end

func abi_encode_uint256_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_45 : Uint256, value0_46 : Uint256, value1_47 : Uint256) -> (tail_48 : Uint256):
    alloc_locals
    local _1_49 : Uint256 = Uint256(low=64, high=0)
    let (local tail_48 : Uint256) = u256_add(headStart_45, _1_49)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_46, headStart_45)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_50 : Uint256 = Uint256(low=32, high=0)
    let (local _3_51 : Uint256) = u256_add(headStart_45, _2_50)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value1_47, _3_51)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_48)
end

func __warp_block_4{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_holder()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = getter_fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _15 : Uint256 = _2
    let (local _16 : Uint256) = abi_encode_uint256(_2, _14)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = u256_add(_16, _13)
    local range_check_ptr = range_check_ptr
    local _18 : Uint256 = _2

    return ()
end

func __warp_block_6{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _19 : Uint256) = __warp_holder()
    __warp_cond_revert(_19)
    local _20 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_decimals()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_uint8(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _23 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    fun_withdraw(param, param_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _24 : Uint256 = _7
    let (local _25 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _26 : Uint256 = _4
    let (local param_2 : Uint256, local param_3 : Uint256, local param_4 : Uint256,
        local param_5 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret_1 : Uint256) = fun_transferFrom(param_2, param_3, param_4, param_5)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_1 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = abi_encode_bool(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _28 : Uint256) = uint256_sub(_27, memPos_1)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_12{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _29 : Uint256) = __warp_holder()
    __warp_cond_revert(_29)
    local _30 : Uint256 = _4
    let (local _31 : Uint256) = abi_decode_uint256(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret_2 : Uint256) = getter_fun_balanceOf(_31)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_2 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _32 : Uint256) = abi_encode_uint256(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_2)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_14{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _34 : Uint256 = _4
    let (local param_6 : Uint256, local param_7 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local ret_3 : Uint256, local ret_4 : Uint256) = fun_deposit(param_6, param_7)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_3 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35 : Uint256) = abi_encode_uint256_uint256(memPos_3, ret_3, ret_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _36 : Uint256) = uint256_sub(_35, memPos_3)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_14(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

func __warp_block_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3803951448, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(_1, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_12(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        __warp_block_13(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_11{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2630350600, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_1, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        __warp_block_11(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_1, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        __warp_block_9(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_7{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1142570608, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_1, _3, _4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_7(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256,
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4(_2, _3, _4)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_5(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_1, _2, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_3(_1, _2, _3, _4, _7, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_2(_1, _10, _2, _3, _4, _7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_1(_1, _2, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*, self_address : felt) -> ():
    alloc_locals
    initialize_address(self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local _1 : Uint256 = Uint256(low=64, high=0)
    local _2 : Uint256 = Uint256(low=128, high=0)
    with memory_dict, msize, range_check_ptr:
        mstore_(offset=_1.low, value=_2)
    end

    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3 : Uint256 = Uint256(low=4, high=0)
    let (local _4 : Uint256) = __warp_constant_0()
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_1(_1, _2, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

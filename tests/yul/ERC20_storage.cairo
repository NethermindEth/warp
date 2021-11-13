%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_not, uint256_sub

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

func __warp_cond_revert(_3_7 : Uint256) -> ():
    alloc_locals
    if _3_7.low + _3_7.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=0, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_7)
    return ()
end

func getter_fun_totalSupply{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        ) -> (value : Uint256):
    alloc_locals
    let (res) = totalSupply.read()
    return (res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_9 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_9)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_10 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_11 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_10, _1_11)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0, headStart_10)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func getter_fun_decimals{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_12 : Uint256):
    alloc_locals
    let (res) = decimals.read()
    return (res)
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_14 : Uint256, pos_15 : Uint256) -> ():
    alloc_locals
    local _1_16 : Uint256 = Uint256(low=255, high=0)
    let (local _2_17 : Uint256) = uint256_and(value_14, _1_16)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_15, value=_2_17)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_18 : Uint256, value0_19 : Uint256) -> (tail_20 : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=32, high=0)
    let (local tail_20 : Uint256) = u256_add(headStart_18, _1_21)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(value0_19, headStart_18)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_20)
end

func abi_decode_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_22 : Uint256, dataEnd_23 : Uint256) -> (value0_24 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_25 : Uint256 = Uint256(low=64, high=0)
    let (local _2_26 : Uint256) = uint256_sub(dataEnd_23, headStart_22)
    local range_check_ptr = range_check_ptr
    let (local _3_27 : Uint256) = slt(_2_26, _1_25)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_27)
    let (local value0_24 : Uint256) = calldataload(headStart_22)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_28 : Uint256 = Uint256(low=32, high=0)
    let (local _5_29 : Uint256) = u256_add(headStart_22, _4_28)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldataload(_5_29)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_24, value1)
end

func getter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        arg0 : Uint256) -> (value_57 : Uint256):
    alloc_locals
    let (res) = balanceOf.read(arg0.low, arg0.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_77 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_77)
    return ()
end

func checked_sub_uint256{range_check_ptr}(x_80 : Uint256, y_81 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_82 : Uint256) = is_lt(x_80, y_81)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_82)
    let (local diff : Uint256) = uint256_sub(x_80, y_81)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func setter_fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        arg0_69 : Uint256, value_70 : Uint256) -> ():
    alloc_locals
    balanceOf.write(arg0_69.low, arg0_69.high, value_70)
    return ()
end

func fun_withdraw{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_wad : Uint256, var_sender_83 : Uint256) -> ():
    alloc_locals
    let (local _1_84 : Uint256) = getter_fun_balanceOf(var_sender_83)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_85 : Uint256) = is_lt(_1_84, var_wad)
    local range_check_ptr = range_check_ptr
    let (local _3_86 : Uint256) = is_zero(_2_85)
    local range_check_ptr = range_check_ptr
    require_helper(_3_86)
    local range_check_ptr = range_check_ptr
    let (local _4_87 : Uint256) = getter_fun_balanceOf(var_sender_83)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _5_88 : Uint256) = checked_sub_uint256(_4_87, var_wad)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender_83, _5_88)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_decode_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_30 : Uint256, dataEnd_31 : Uint256) -> (value0_32 : Uint256):
    alloc_locals
    local _1_33 : Uint256 = Uint256(low=32, high=0)
    let (local _2_34 : Uint256) = uint256_sub(dataEnd_31, headStart_30)
    local range_check_ptr = range_check_ptr
    let (local _3_35 : Uint256) = slt(_2_34, _1_33)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_35)
    let (local value0_32 : Uint256) = calldataload(headStart_30)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_32)
end

func fun_get_balance{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_src_100 : Uint256) -> (var : Uint256):
    alloc_locals
    let (local var : Uint256) = getter_fun_balanceOf(var_src_100)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var)
end

func abi_decode_uint256t_uint256t_uint256t_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_36 : Uint256, dataEnd_37 : Uint256) -> (
        value0_38 : Uint256, value1_39 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_40 : Uint256 = Uint256(low=128, high=0)
    let (local _2_41 : Uint256) = uint256_sub(dataEnd_37, headStart_36)
    local range_check_ptr = range_check_ptr
    let (local _3_42 : Uint256) = slt(_2_41, _1_40)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_42)
    let (local value0_38 : Uint256) = calldataload(headStart_36)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_43 : Uint256 = Uint256(low=32, high=0)
    let (local _5_44 : Uint256) = u256_add(headStart_36, _4_43)
    local range_check_ptr = range_check_ptr
    let (local value1_39 : Uint256) = calldataload(_5_44)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _6_45 : Uint256 = Uint256(low=64, high=0)
    let (local _7_46 : Uint256) = u256_add(headStart_36, _6_45)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldataload(_7_46)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _8_47 : Uint256 = Uint256(low=96, high=0)
    let (local _9_48 : Uint256) = u256_add(headStart_36, _8_47)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = calldataload(_9_48)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_38, value1_39, value2, value3)
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_67 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_68 : Uint256) = is_gt(x, _1_67)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_68)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_src : Uint256, var_wad_89 : Uint256) -> ():
    alloc_locals
    let (local _3_93 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _4_94 : Uint256) = is_lt(_3_93, var_wad_89)
    local range_check_ptr = range_check_ptr
    let (local _5_95 : Uint256) = is_zero(_4_94)
    local range_check_ptr = range_check_ptr
    require_helper(_5_95)
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_0{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2_92 : Uint256, var_src : Uint256, var_wad_89 : Uint256) -> ():
    alloc_locals
    if _2_92.low + _2_92.high != 0:
        __warp_block_0(var_src, var_wad_89)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad_89 : Uint256, var_sender_90 : Uint256) -> (
        var_ : Uint256):
    alloc_locals
    let (local _1_91 : Uint256) = is_eq(var_src, var_sender_90)
    local range_check_ptr = range_check_ptr
    let (local _2_92 : Uint256) = is_zero(_1_91)
    local range_check_ptr = range_check_ptr
    __warp_if_0(_2_92, var_src, var_wad_89)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _6_96 : Uint256) = getter_fun_balanceOf(var_src)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _7_97 : Uint256) = checked_sub_uint256(_6_96, var_wad_89)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_src, _7_97)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _8_98 : Uint256) = getter_fun_balanceOf(var_dst)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _9_99 : Uint256) = checked_add_uint256(_8_98, var_wad_89)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_dst, _9_99)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_49 : Uint256, pos_50 : Uint256) -> ():
    alloc_locals
    let (local _1_51 : Uint256) = is_zero(value_49)
    local range_check_ptr = range_check_ptr
    let (local _2_52 : Uint256) = is_zero(_1_51)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_50, value=_2_52)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_53 : Uint256, value0_54 : Uint256) -> (tail_55 : Uint256):
    alloc_locals
    local _1_56 : Uint256 = Uint256(low=32, high=0)
    let (local tail_55 : Uint256) = u256_add(headStart_53, _1_56)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_54, headStart_53)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_55)
end

func fun_deposit{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_sender : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _1_75 : Uint256) = getter_fun_balanceOf(var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_76 : Uint256) = checked_add_uint256(_1_75, var_value)
    local range_check_ptr = range_check_ptr
    setter_fun_balanceOf(var_sender, _2_76)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = getter_fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _15 : Uint256 = _2
    let (local _16 : Uint256) = abi_encode_uint256(_2, _14)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = u256_add(_16, _13)
    local range_check_ptr = range_check_ptr
    local _18 : Uint256 = _2
    returndata_write(_2, _17)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _19 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_19)
    local _20 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_decimals()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_uint8(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _22)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _23 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    fun_withdraw(param, param_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _24 : Uint256 = _7
    let (local _25 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    returndata_write(_25, _7)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _26 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_26)
    local _27 : Uint256 = _4
    let (local _28 : Uint256) = abi_decode_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_get_balance(_28)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_1 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30 : Uint256) = uint256_sub(_29, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _30)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_12{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _31 : Uint256 = _4
    let (local param_2 : Uint256, local param_3 : Uint256, local param_4 : Uint256,
        local param_5 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_transferFrom(param_2, param_3, param_4, param_5)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_2 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _32 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_2)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_2, _33)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_14{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _34 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_34)
    local _35 : Uint256 = _4
    let (local _36 : Uint256) = abi_decode_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = getter_fun_balanceOf(_36)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_3 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = abi_encode_uint256(memPos_3, ret_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _38 : Uint256) = uint256_sub(_37, memPos_3)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_3, _38)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_16{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _39 : Uint256 = _4
    let (local param_6 : Uint256, local param_7 : Uint256) = abi_decode_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    fun_deposit(param_6, param_7)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _40 : Uint256 = _7
    let (local _41 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    returndata_write(_41, _7)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_16(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment* = exec_env
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

func __warp_block_15{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3803951448, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_8(_1, _3, _4, _7, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_14(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_15(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_13{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2630350600, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_12(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_13(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_11(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1530952232, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_9(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1142570608, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_7(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256,
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_4(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_5(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_1, _2, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_3(_1, _2, _3, _4, _7, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldataload(_7)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_2(_1, _10, _2, _3, _4, _7)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_1(_1, _2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
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
        success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    initialize_address{
        range_check_ptr=range_check_ptr, syscall_ptr=syscall_ptr, pedersen_ptr=pedersen_ptr}(
        self_address)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (returndata_ptr : felt*) = alloc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with exec_env, msize, memory_dict:
        local _1 : Uint256 = Uint256(low=64, high=0)
        local _2 : Uint256 = Uint256(low=128, high=0)
        uint256_mstore(offset=_1, value=_2)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3 : Uint256 = Uint256(low=4, high=0)
        let (local _4 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (local _5 : Uint256) = is_lt(_4, _3)
        local range_check_ptr = range_check_ptr
        let (local _6 : Uint256) = is_zero(_5)
        local range_check_ptr = range_check_ptr
        __warp_if_1(_1, _2, _3, _4, _6)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end


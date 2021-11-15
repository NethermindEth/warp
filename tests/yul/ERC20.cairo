%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, caller, returndata_write
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
func balances(arg0_low, arg0_high) -> (res : Uint256):
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

func abi_decode{range_check_ptr}(headStart : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=0, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    if _3_7.low + _3_7.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func getter_fun_totalSupply{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        ) -> (value_36 : Uint256):
    alloc_locals
    let (res) = totalSupply.read()
    return (res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_8 : Uint256, value0 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_9 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_8, _1_9)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0, headStart_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode_addresst_addresst_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_10 : Uint256, dataEnd_11 : Uint256) -> (
        value0_12 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_13 : Uint256 = Uint256(low=96, high=0)
    let (local _2_14 : Uint256) = uint256_sub(dataEnd_11, headStart_10)
    local range_check_ptr = range_check_ptr
    let (local _3_15 : Uint256) = slt(_2_14, _1_13)
    local range_check_ptr = range_check_ptr
    if _3_15.low + _3_15.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_12 : Uint256) = calldataload(headStart_10)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_16 : Uint256 = Uint256(low=32, high=0)
    let (local _5_17 : Uint256) = u256_add(headStart_10, _4_16)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldataload(_5_17)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _6_18 : Uint256 = Uint256(low=64, high=0)
    let (local _7_19 : Uint256) = u256_add(headStart_10, _6_18)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldataload(_7_19)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_12, value1, value2)
end

func getter_fun_balances{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        arg0 : Uint256) -> (value_53 : Uint256):
    alloc_locals
    let (res) = balances.read(arg0.low, arg0.high)
    return (res)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_79 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    if _1_79.low + _1_79.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func setter_fun_balances{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        arg0_65 : Uint256, value_66 : Uint256) -> ():
    alloc_locals
    balances.write(arg0_65.low, arg0_65.high, value_66)
    return ()
end

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_63 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_64 : Uint256) = is_gt(x, _1_63)
    local range_check_ptr = range_check_ptr
    if _2_64.low + _2_64.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func fun_transfer{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_sender_82 : Uint256, var_recipient_83 : Uint256, var_amount_84 : Uint256) -> ():
    alloc_locals
    let (local _1_85 : Uint256) = getter_fun_balances(var_sender_82)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_86 : Uint256) = is_lt(_1_85, var_amount_84)
    local range_check_ptr = range_check_ptr
    let (local _3_87 : Uint256) = is_zero(_2_86)
    local range_check_ptr = range_check_ptr
    require_helper(_3_87)
    local range_check_ptr = range_check_ptr
    let (local _4_88 : Uint256) = uint256_sub(_1_85, var_amount_84)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_sender_82, _4_88)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _5_89 : Uint256) = getter_fun_balances(var_recipient_83)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _6_90 : Uint256) = checked_add_uint256(_5_89, var_amount_84)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_recipient_83, _6_90)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_sender : Uint256, var_recipient_76 : Uint256, var_amount_77 : Uint256) -> (
        var_78 : Uint256):
    alloc_locals
    fun_transfer(var_sender, var_recipient_76, var_amount_77)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var_78 : Uint256 = Uint256(low=1, high=0)
    return (var_78)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_20 : Uint256, pos_21 : Uint256) -> ():
    alloc_locals
    let (local _1_22 : Uint256) = is_zero(value_20)
    local range_check_ptr = range_check_ptr
    let (local _2_23 : Uint256) = is_zero(_1_22)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_21, value=_2_23)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_24 : Uint256, value0_25 : Uint256) -> (tail_26 : Uint256):
    alloc_locals
    local _1_27 : Uint256 = Uint256(low=32, high=0)
    let (local tail_26 : Uint256) = u256_add(headStart_24, _1_27)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_25, headStart_24)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_26)
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_28 : Uint256, pos_29 : Uint256) -> ():
    alloc_locals
    local _1_30 : Uint256 = Uint256(low=255, high=0)
    let (local _2_31 : Uint256) = uint256_and(value_28, _1_30)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_29, value=_2_31)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_32 : Uint256, value0_33 : Uint256) -> (tail_34 : Uint256):
    alloc_locals
    local _1_35 : Uint256 = Uint256(low=32, high=0)
    let (local tail_34 : Uint256) = u256_add(headStart_32, _1_35)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8(value0_33, headStart_32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_34)
end

func abi_decode_addresst_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_38 : Uint256, dataEnd_39 : Uint256) -> (value0_40 : Uint256, value1_41 : Uint256):
    alloc_locals
    local _1_42 : Uint256 = Uint256(low=64, high=0)
    let (local _2_43 : Uint256) = uint256_sub(dataEnd_39, headStart_38)
    local range_check_ptr = range_check_ptr
    let (local _3_44 : Uint256) = slt(_2_43, _1_42)
    local range_check_ptr = range_check_ptr
    if _3_44.low + _3_44.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_40 : Uint256) = calldataload(headStart_38)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_45 : Uint256 = Uint256(low=32, high=0)
    let (local _5_46 : Uint256) = u256_add(headStart_38, _4_45)
    local range_check_ptr = range_check_ptr
    let (local value1_41 : Uint256) = calldataload(_5_46)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_40, value1_41)
end

func fun_mint{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_to : Uint256, var_amount : Uint256) -> (var : Uint256):
    alloc_locals
    let (local _1_71 : Uint256) = getter_fun_balances(var_to)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_72 : Uint256) = checked_add_uint256(_1_71, var_amount)
    local range_check_ptr = range_check_ptr
    setter_fun_balances(var_to, _2_72)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

func abi_decode_address{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_47 : Uint256, dataEnd_48 : Uint256) -> (value0_49 : Uint256):
    alloc_locals
    local _1_50 : Uint256 = Uint256(low=32, high=0)
    let (local _2_51 : Uint256) = uint256_sub(dataEnd_48, headStart_47)
    local range_check_ptr = range_check_ptr
    let (local _3_52 : Uint256) = slt(_2_51, _1_50)
    local range_check_ptr = range_check_ptr
    if _3_52.low + _3_52.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_49 : Uint256) = calldataload(headStart_47)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_49)
end

func fun_balanceOf{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_account : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local var_ : Uint256) = getter_fun_balances(var_account)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_)
end

func fun_transfer_73{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_recipient : Uint256, var_amount_73 : Uint256) -> (var_74 : Uint256):
    alloc_locals
    let (local _1_75 : Uint256) = caller()
    local syscall_ptr : felt* = syscall_ptr
    fun_transfer(_1_75, var_recipient, var_amount_73)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var_74 : Uint256 = Uint256(low=1, high=0)
    return (var_74)
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    if _11.low + _11.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _19 : Uint256) = __warp_constant_0()
    if _19.low + _19.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _20 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256,
        local param_2 : Uint256) = abi_decode_addresst_addresst_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_transferFrom(param, param_1, param_2)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _22)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _23 : Uint256) = __warp_constant_0()
    if _23.low + _23.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _24 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local memPos_1 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _25 : Uint256 = Uint256(low=18, high=0)
    let (local _26 : Uint256) = abi_encode_uint8(memPos_1, _25)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = uint256_sub(_26, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _27)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _28 : Uint256) = __warp_constant_0()
    if _28.low + _28.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _29 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = getter_fun_totalSupply()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_2 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30 : Uint256) = abi_encode_uint256(memPos_2, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31 : Uint256) = uint256_sub(_30, memPos_2)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_2, _31)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _32 : Uint256) = __warp_constant_0()
    if _32.low + _32.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _33 : Uint256 = _4
    let (local param_3 : Uint256, local param_4 : Uint256) = abi_decode_addresst_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_mint(param_3, param_4)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_3 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _34 : Uint256) = abi_encode_bool(memPos_3, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35 : Uint256) = uint256_sub(_34, memPos_3)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_3, _35)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_13{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _36 : Uint256) = __warp_constant_0()
    if _36.low + _36.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _37 : Uint256 = _4
    let (local _38 : Uint256) = abi_decode_address(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = getter_fun_balances(_38)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_4 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _39 : Uint256) = abi_encode_uint256(memPos_4, ret_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _40 : Uint256) = uint256_sub(_39, memPos_4)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_4, _40)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_15{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _41 : Uint256) = __warp_constant_0()
    if _41.low + _41.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _42 : Uint256 = _4
    let (local _43 : Uint256) = abi_decode_address(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = fun_balanceOf(_43)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_5 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _44 : Uint256) = abi_encode_uint256(memPos_5, ret_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _45 : Uint256) = uint256_sub(_44, memPos_5)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_5, _45)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_17{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _46 : Uint256) = __warp_constant_0()
    if _46.low + _46.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _47 : Uint256 = _4
    let (local param_5 : Uint256, local param_6 : Uint256) = abi_decode_addresst_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_5 : Uint256) = fun_transfer_73(param_5, param_6)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_6 : Uint256) = uint256_mload(_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _48 : Uint256) = abi_encode_bool(memPos_6, ret_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _49 : Uint256) = uint256_sub(_48, memPos_6)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_6, _49)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_17(_1, _3, _4)
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

func __warp_block_16{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_8(_1, _3, _4, __warp_subexpr_0)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_15(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_16(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_14{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_7(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_14(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_12{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1857877511, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_12(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1086394137, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_10(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1051392107, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_8(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_5(_1, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_6(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_2(_1, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_3(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_4(_1, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_1(_1, _2, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_2(_1, _2, _3, _4, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_0{
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
    __warp_block_1(_1, _10, _2, _3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_0(_1, _2, _3, _4)
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
        __warp_if_0(_1, _2, _3, _4, _6)
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

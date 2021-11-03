%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldata_load, calldatasize_, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_sub

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

@storage_var
func owner() -> (res : Uint256):
end

@storage_var
func ownerAge() -> (res : Uint256):
end

@storage_var
func ownerCellNumber() -> (res : Uint256):
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

func getter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        ) -> (value_41 : Uint256):
    alloc_locals
    let (res) = ownerCellNumber.read()
    return (res)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_17 : Uint256, pos_18 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_18.low, value=value_17)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_26 : Uint256, value0_27 : Uint256) -> (tail_28 : Uint256):
    alloc_locals
    local _1_29 : Uint256 = Uint256(low=32, high=0)
    let (local tail_28 : Uint256) = u256_add(headStart_26, _1_29)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_27, headStart_26)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_28)
end

func getter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_43 : Uint256):
    alloc_locals
    let (res) = owner.read()
    return (res)
end

func abi_encode_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos.low, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_19 : Uint256, value0_20 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_19, _1_21)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_20, headStart_19)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func getter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_39 : Uint256):
    alloc_locals
    let (res) = ownerAge.read()
    return (res)
end

func abi_decode_addresst_uint256t_uint256{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_4 : Uint256, dataEnd_5 : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_6 : Uint256 = Uint256(low=96, high=0)
    let (local _2_7 : Uint256) = uint256_sub(dataEnd_5, headStart_4)
    local range_check_ptr = range_check_ptr
    let (local _3_8 : Uint256) = slt(_2_7, _1_6)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_8)
    let (local value0 : Uint256) = calldata_load(headStart_4.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_9 : Uint256 = Uint256(low=32, high=0)
    let (local _5_10 : Uint256) = u256_add(headStart_4, _4_9)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldata_load(_5_10.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _6_11 : Uint256 = Uint256(low=64, high=0)
    let (local _7_12 : Uint256) = u256_add(headStart_4, _6_11)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldata_load(_7_12.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1, value2)
end

func cleanup_address(value_30 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_30
    return (cleaned)
end

func cleanup_uint256(value_31 : Uint256) -> (cleaned_32 : Uint256):
    alloc_locals
    local cleaned_32 : Uint256 = value_31
    return (cleaned_32)
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_ownerAgeCheck : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _3_35 : Uint256) = getter_fun_ownerAge()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _4_36 : Uint256) = cleanup_uint256(_3_35)
    let (local expr : Uint256) = is_eq(var_ownerAgeCheck, _4_36)
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, var_ownerAgeCheck : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (local expr : Uint256) = __warp_block_0(var_ownerAgeCheck)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return (expr)
    else:
        return (expr)
    end
end

func __warp_block_1{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_ownerCellNumberCheck : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    let (local _5_37 : Uint256) = getter_fun_ownerCellNumber()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _6_38 : Uint256) = cleanup_uint256(_5_37)
    let (local expr_1 : Uint256) = is_eq(var_ownerCellNumberCheck, _6_38)
    local range_check_ptr = range_check_ptr
    return (expr_1)
end

func __warp_if_1{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        expr : Uint256, expr_1 : Uint256, var_ownerCellNumberCheck : Uint256) -> (expr_1 : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (local expr_1 : Uint256) = __warp_block_1(var_ownerCellNumberCheck)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return (expr_1)
    else:
        return (expr_1)
    end
end

func fun_validate_constructor{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        var_ownerCheck : Uint256, var_ownerAgeCheck : Uint256,
        var_ownerCellNumberCheck : Uint256) -> (var : Uint256):
    alloc_locals
    let (local _1_33 : Uint256) = getter_fun_owner()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _2_34 : Uint256) = cleanup_address(_1_33)
    let (local expr : Uint256) = is_eq(var_ownerCheck, _2_34)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = __warp_if_0(expr, var_ownerAgeCheck)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local expr_1 : Uint256 = expr
    let (local expr_1 : Uint256) = __warp_if_1(expr, expr_1, var_ownerCellNumberCheck)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var : Uint256 = expr_1
    return (var)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_13 : Uint256, pos_14 : Uint256) -> ():
    alloc_locals
    let (local _1_15 : Uint256) = is_zero(value_13)
    local range_check_ptr = range_check_ptr
    let (local _2_16 : Uint256) = is_zero(_1_15)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_14.low, value=_2_16)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_22 : Uint256, value0_23 : Uint256) -> (tail_24 : Uint256):
    alloc_locals
    local _1_25 : Uint256 = Uint256(low=32, high=0)
    let (local tail_24 : Uint256) = u256_add(headStart_22, _1_25)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_23, headStart_22)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_24)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = getter_fun_ownerCellNumber()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _15 : Uint256 = _1
    let (local _16 : Uint256) = abi_encode_uint256(_1, _14)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = u256_add(_16, _13)
    local range_check_ptr = range_check_ptr
    local _18 : Uint256 = _1
    returndata_write(_1, _17)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _19 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_19)
    local _20 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = getter_fun_owner()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _21 : Uint256 = _2
    let (local memPos : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = abi_encode_tuple_address(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23 : Uint256) = uint256_sub(_22, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _23)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _24 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_24)
    local _25 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = getter_fun_ownerAge()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _26 : Uint256 = _2
    let (local memPos_1 : Uint256) = mload_(_2.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _28 : Uint256) = uint256_sub(_27, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _28)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _29 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_29)
    local _30 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256,
        local param_2 : Uint256) = abi_decode_addresst_uint256t_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_validate_constructor(param, param_1, param_2)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _31 : Uint256 = _2
    let (local memPos_2 : Uint256) = mload_(_2.low)
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

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_11(_2, _3, _4)
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

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2902484523, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_2, _3, _4, __warp_subexpr_0)
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
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_10(_2, _3, _4, match_var)
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
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2647152338, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_2, _3, _4, __warp_subexpr_0, match_var)
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
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_8(_2, _3, _4, match_var)
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
        _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_2, _3, _4, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
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
        __warp_block_6(_2, _3, _4, match_var)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1104667242, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_3(_1, _2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_4(_1, _2, _3, _4, match_var)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_3(_1, _10, _2, _3, _4)
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
        _1 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_2(_1, _2, _3, _4)
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
        local _1 : Uint256 = Uint256(low=128, high=0)
        local _2 : Uint256 = Uint256(low=64, high=0)
        with memory_dict, msize, range_check_ptr:
            mstore_(offset=_2.low, value=_1)
        end

        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3 : Uint256 = Uint256(low=4, high=0)
        let (local _4 : Uint256) = calldatasize_()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        let (local _5 : Uint256) = is_lt(_4, _3)
        local range_check_ptr = range_check_ptr
        let (local _6 : Uint256) = is_zero(_5)
        local range_check_ptr = range_check_ptr
        with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, syscall_ptr:
            __warp_if_2(_1, _2, _3, _4, _6)
        end

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

func setter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_61 : Uint256) -> ():
    alloc_locals
    owner.write(value_61)
    return ()
end

func setter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_51 : Uint256) -> ():
    alloc_locals
    ownerAge.write(value_51)
    return ()
end

func setter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_56 : Uint256) -> ():
    alloc_locals
    ownerCellNumber.write(value_56)
    return ()
end

@constructor
func constructor{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(
        var_owner : Uint256, var_ownerAge : Uint256, var_ownerCellNumber : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with pedersen_ptr, range_check_ptr, bitwise_ptr, memory_dict, msize:
        setter_fun_owner(var_owner)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        setter_fun_ownerAge(var_ownerAge)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        setter_fun_ownerCellNumber(var_ownerCellNumber)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
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

func __warp_cond_revert(_3_10 : Uint256) -> ():
    alloc_locals
    if _3_10.low + _3_10.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_struct_Person_calldata{range_check_ptr}(
        offset : Uint256, end__warp_mangled : Uint256) -> (value_7 : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=64, high=0)
    let (local _2_9 : Uint256) = uint256_sub(end__warp_mangled, offset)
    local range_check_ptr = range_check_ptr
    let (local _3_10 : Uint256) = slt(_2_9, _1_8)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_10)
    local value_7 : Uint256 = offset
    return (value_7)
end

func abi_decode_addresst_struct_Person_calldatat_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_11 : Uint256 = Uint256(low=128, high=0)
    let (local _2_12 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_13 : Uint256) = slt(_2_12, _1_11)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_13)
    let (local value0 : Uint256) = calldataload(headStart)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_14 : Uint256 = Uint256(low=32, high=0)
    let (local _5_15 : Uint256) = u256_add(headStart, _4_14)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = abi_decode_struct_Person_calldata(_5_15, dataEnd)
    local range_check_ptr = range_check_ptr
    local _6_16 : Uint256 = Uint256(low=96, high=0)
    let (local _7_17 : Uint256) = u256_add(headStart, _6_16)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldataload(_7_17)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1, value2)
end

func getter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_82 : Uint256):
    alloc_locals
    let (res) = owner.read()
    return (res)
end

func getter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}() -> (
        value_90 : Uint256):
    alloc_locals
    let (res) = ownerAge.read()
    return (res)
end

func getter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        ) -> (value_29 : Uint256):
    alloc_locals
    let (res) = ownerCellNumber.read()
    return (res)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(var_person_offset : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _2_95 : Uint256) = getter_fun_ownerAge()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _3_96 : Uint256) = calldataload(var_person_offset)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    let (local expr : Uint256) = is_eq(_2_95, _3_96)
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(expr : Uint256, var_person_offset : Uint256) -> (expr : Uint256):
    alloc_locals
    if expr.low + expr.high != 0:
        let (local expr : Uint256) = __warp_block_0(var_person_offset)
        local exec_env : ExecutionEnvironment* = exec_env
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
    let (local _4_97 : Uint256) = getter_fun_ownerCellNumber()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_1 : Uint256) = is_eq(_4_97, var_ownerCellNumberCheck)
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

func fun_validate_constructor{
        exec_env : ExecutionEnvironment*, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_ownerCheck : Uint256, var_person_offset : Uint256,
        var_ownerCellNumberCheck : Uint256) -> (var : Uint256):
    alloc_locals
    let (local _1_94 : Uint256) = getter_fun_owner()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local expr : Uint256) = is_eq(_1_94, var_ownerCheck)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = __warp_if_0(expr, var_person_offset)
    local exec_env : ExecutionEnvironment* = exec_env
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
        value_18 : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_19 : Uint256) = is_zero(value_18)
    local range_check_ptr = range_check_ptr
    let (local _2_20 : Uint256) = is_zero(_1_19)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos, value=_2_20)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_21 : Uint256, value0_22 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_23 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_21, _1_23)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_22, headStart_21)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode{range_check_ptr}(headStart_24 : Uint256, dataEnd_25 : Uint256) -> ():
    alloc_locals
    local _1_26 : Uint256 = Uint256(low=0, high=0)
    let (local _2_27 : Uint256) = uint256_sub(dataEnd_25, headStart_24)
    local range_check_ptr = range_check_ptr
    let (local _3_28 : Uint256) = slt(_2_27, _1_26)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_28)
    return ()
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_31 : Uint256, pos_32 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_32, value=value_31)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_33 : Uint256, value0_34 : Uint256) -> (tail_35 : Uint256):
    alloc_locals
    local _1_36 : Uint256 = Uint256(low=32, high=0)
    let (local tail_35 : Uint256) = u256_add(headStart_33, _1_36)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_34, headStart_33)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_35)
end

func abi_encode_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_84 : Uint256, pos_85 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_85, value=value_84)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_tuple_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_86 : Uint256, value0_87 : Uint256) -> (tail_88 : Uint256):
    alloc_locals
    local _1_89 : Uint256 = Uint256(low=32, high=0)
    let (local tail_88 : Uint256) = u256_add(headStart_86, _1_89)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_87, headStart_86)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_88)
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256,
        local param_2 : Uint256) = abi_decode_addresst_struct_Person_calldatat_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = fun_validate_constructor(param, param_1, param_2)
    local exec_env : ExecutionEnvironment* = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _15 : Uint256 = _1
    let (local _16 : Uint256) = abi_encode_bool(_1, _14)
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
    let (local ret__warp_mangled : Uint256) = getter_fun_ownerCellNumber()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _21 : Uint256 = _2
    let (local memPos : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
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
    let (local _29 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_29)
    local _30 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = getter_fun_owner()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _31 : Uint256 = _2
    let (local memPos_1 : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _32 : Uint256) = abi_encode_tuple_address(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _33)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_11{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _34 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_34)
    local _35 : Uint256 = _4
    abi_decode(_3, _4)
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = getter_fun_ownerAge()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _36 : Uint256 = _2
    let (local memPos_2 : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = abi_encode_uint256(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _38 : Uint256) = uint256_sub(_37, memPos_2)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_2, _38)
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
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2647152338, high=0))
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
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2376452955, high=0))
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
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1104667242, high=0))
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
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=898672770, high=0))
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
    let (local _8 : Uint256) = calldataload(_7)
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
        uint256_mstore(offset=_2, value=_1)
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
        __warp_if_2(_1, _2, _3, _4, _6)
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

func cleanup_uint256(value : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value
    return (cleaned)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_45 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_46 : Uint256 = Uint256(low=31, high=0)
    let (local _3_47 : Uint256) = u256_add(size, _2_46)
    local range_check_ptr = range_check_ptr
    let (local _4_48 : Uint256) = uint256_and(_3_47, _1_45)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_48)
    local range_check_ptr = range_check_ptr
    let (local _5_49 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_50 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_51 : Uint256) = is_gt(newFreePtr, _6_50)
    local range_check_ptr = range_check_ptr
    let (local _8_52 : Uint256) = uint256_sub(_7_51, _5_49)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_52)
    local _9_53 : Uint256 = Uint256(low=64, high=0)
    uint256_mstore(offset=_9_53, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{memory_dict : DictAccess*, msize, range_check_ptr}(size_54 : Uint256) -> (
        memPtr_55 : Uint256):
    alloc_locals
    local _1_56 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_55 : Uint256) = uint256_mload(_1_56)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_55, size_54)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_55)
end

func abi_decode_struct_Person{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_57 : Uint256, end_58 : Uint256) -> (value_59 : Uint256):
    alloc_locals
    local _1_60 : Uint256 = Uint256(low=64, high=0)
    let (local _2_61 : Uint256) = uint256_sub(end_58, headStart_57)
    local range_check_ptr = range_check_ptr
    let (local _3_62 : Uint256) = slt(_2_61, _1_60)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_62)
    local _4_63 : Uint256 = _1_60
    let (local value_59 : Uint256) = allocate_memory(_1_60)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_64 : Uint256) = calldataload(headStart_57)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    uint256_mstore(offset=value_59, value=_5_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_65 : Uint256 = Uint256(low=32, high=0)
    let (local _7_66 : Uint256) = u256_add(headStart_57, _6_65)
    local range_check_ptr = range_check_ptr
    let (local _8_67 : Uint256) = calldataload(_7_66)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9_68 : Uint256 = _6_65
    let (local _10_69 : Uint256) = u256_add(value_59, _6_65)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_10_69, value=_8_67)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value_59)
end

func abi_decode_addresst_struct_Persont_uint256{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_70 : Uint256, dataEnd_71 : Uint256) -> (
        value0_72 : Uint256, value1_73 : Uint256, value2_74 : Uint256):
    alloc_locals
    local _1_75 : Uint256 = Uint256(low=128, high=0)
    let (local _2_76 : Uint256) = uint256_sub(dataEnd_71, headStart_70)
    local range_check_ptr = range_check_ptr
    let (local _3_77 : Uint256) = slt(_2_76, _1_75)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_77)
    let (local value0_72 : Uint256) = calldataload(headStart_70)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_78 : Uint256 = Uint256(low=32, high=0)
    let (local _5_79 : Uint256) = u256_add(headStart_70, _4_78)
    local range_check_ptr = range_check_ptr
    let (local value1_73 : Uint256) = abi_decode_struct_Person(_5_79, dataEnd_71)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_80 : Uint256 = Uint256(low=96, high=0)
    let (local _7_81 : Uint256) = u256_add(headStart_70, _6_80)
    local range_check_ptr = range_check_ptr
    let (local value2_74 : Uint256) = calldataload(_7_81)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_72, value1_73, value2_74)
end

func setter_fun_owner{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_98 : Uint256) -> ():
    alloc_locals
    owner.write(value_98)
    return ()
end

func setter_fun_ownerAge{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_103 : Uint256) -> ():
    alloc_locals
    ownerAge.write(value_103)
    return ()
end

func setter_fun_ownerCellNumber{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(
        value_108 : Uint256) -> ():
    alloc_locals
    ownerCellNumber.write(value_108)
    return ()
end

func fun_warp_ctorHelper_DynArgs{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        syscall_ptr : felt*}(
        var_owner : Uint256, var_person_mpos : Uint256, var_ownerCellNumber : Uint256) -> ():
    alloc_locals
    setter_fun_owner(var_owner)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _1_121 : Uint256) = uint256_mload(var_person_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_122 : Uint256) = cleanup_uint256(_1_121)
    setter_fun_ownerAge(_2_122)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    setter_fun_ownerCellNumber(var_ownerCellNumber)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

@constructor
func constructor{
        pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}(calldata_size, calldata_len, calldata : felt*):
    alloc_locals
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (returndata_ptr : felt*) = alloc()
    let (local __fp__, _) = get_fp_and_pc()
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr, to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)
    let exec_env : ExecutionEnvironment* = &exec_env_
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with pedersen_ptr, range_check_ptr, bitwise_ptr, memory_dict, msize, exec_env:
        local _1_113 : Uint256 = Uint256(low=128, high=0)
        local _2_114 : Uint256 = Uint256(low=64, high=0)
        uint256_mstore(offset=_2_114, value=_1_113)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local _3_115 : Uint256 = Uint256(low=4, high=0)
        let (local _4_116 : Uint256) = calldatasize()
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        local _7_117 : Uint256 = Uint256(low=0, high=0)
        let (local _8_118 : Uint256) = calldataload(_7_117)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment* = exec_env
        local _9_119 : Uint256 = Uint256(low=224, high=0)
        let (local _10_120 : Uint256) = u256_shr(_9_119, _8_118)
        local range_check_ptr = range_check_ptr
        let (local _24 : Uint256) = __warp_constant_0()
        __warp_cond_revert(_24)
        local _25 : Uint256 = _4_116
        let (local param_3 : Uint256, local param_4 : Uint256,
            local param_5 : Uint256) = abi_decode_addresst_struct_Persont_uint256(_3_115, _4_116)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        fun_warp_ctorHelper_DynArgs(param_3, param_4, param_5)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        local _26 : Uint256 = _7_117
        local _27 : Uint256 = _2_114
        let (local _28 : Uint256) = uint256_mload(_2_114)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        returndata_write(_28, _7_117)
        local exec_env : ExecutionEnvironment* = exec_env
        return ()
    end
end


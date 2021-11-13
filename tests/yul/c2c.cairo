%lang starknet
%builtins pedersen range_check bitwise

from evm.calls import calldataload, calldatasize, returndata_write, warp_call, warp_static_call
from evm.exec_env import ExecutionEnvironment
from evm.memory import uint256_mload, uint256_mstore
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_shl, u256_shr
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_not, uint256_sub

func returndata_size{exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.returndata_size, high=0))
end

func __warp_constant_10000000000000000000000000000000000000000() -> (res : Uint256):
    return (Uint256(low=131811359292784559562136384478721867776, high=29))
end

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
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

func __warp_cond_revert(_3_12 : Uint256) -> ():
    alloc_locals
    if _3_12.low + _3_12.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_addresst_addresst_addresst_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_6 : Uint256, dataEnd_7 : Uint256) -> (
        value0_8 : Uint256, value1_9 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_10 : Uint256 = Uint256(low=128, high=0)
    let (local _2_11 : Uint256) = uint256_sub(dataEnd_7, headStart_6)
    local range_check_ptr = range_check_ptr
    let (local _3_12 : Uint256) = slt(_2_11, _1_10)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_12)
    let (local value0_8 : Uint256) = calldataload(headStart_6)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_13 : Uint256 = Uint256(low=32, high=0)
    let (local _5_14 : Uint256) = u256_add(headStart_6, _4_13)
    local range_check_ptr = range_check_ptr
    let (local value1_9 : Uint256) = calldataload(_5_14)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _6_15 : Uint256 = Uint256(low=64, high=0)
    let (local _7_16 : Uint256) = u256_add(headStart_6, _6_15)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldataload(_7_16)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _8_17 : Uint256 = Uint256(low=96, high=0)
    let (local _9_18 : Uint256) = u256_add(headStart_6, _8_17)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = calldataload(_9_18)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_8, value1_9, value2, value3)
end

func abi_encode_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_31 : Uint256, pos : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos, value=value_31)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_38 : Uint256, pos_39 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_39, value=value_38)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_address_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_43 : Uint256, value0_44 : Uint256, value1_45 : Uint256, value2_46 : Uint256) -> (
        tail_47 : Uint256):
    alloc_locals
    local _1_48 : Uint256 = Uint256(low=96, high=0)
    let (local tail_47 : Uint256) = u256_add(headStart_43, _1_48)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_44, headStart_43)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_49 : Uint256 = Uint256(low=32, high=0)
    let (local _3_50 : Uint256) = u256_add(headStart_43, _2_49)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_45, _3_50)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_51 : Uint256 = Uint256(low=64, high=0)
    let (local _5_52 : Uint256) = u256_add(headStart_43, _4_51)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_46, _5_52)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_47)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_68 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_69 : Uint256 = Uint256(low=31, high=0)
    let (local _3_70 : Uint256) = u256_add(size, _2_69)
    local range_check_ptr = range_check_ptr
    let (local _4_71 : Uint256) = uint256_and(_3_70, _1_68)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_71)
    local range_check_ptr = range_check_ptr
    let (local _5_72 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_73 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_74 : Uint256) = is_gt(newFreePtr, _6_73)
    local range_check_ptr = range_check_ptr
    let (local _8_75 : Uint256) = uint256_sub(_7_74, _5_72)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_75)
    local _9_76 : Uint256 = Uint256(low=64, high=0)
    uint256_mstore(offset=_9_76, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func validator_revert_bool{range_check_ptr}(value_146 : Uint256) -> ():
    alloc_locals
    let (local _1_147 : Uint256) = is_zero(value_146)
    local range_check_ptr = range_check_ptr
    let (local _2_148 : Uint256) = is_zero(_1_147)
    local range_check_ptr = range_check_ptr
    let (local _3_149 : Uint256) = is_eq(value_146, _2_148)
    local range_check_ptr = range_check_ptr
    let (local _4_150 : Uint256) = is_zero(_3_149)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_150)
    return ()
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset : Uint256) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = uint256_mload(offset)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    validator_revert_bool(value)
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_19 : Uint256, dataEnd_20 : Uint256) -> (value0_21 : Uint256):
    alloc_locals
    local _1_22 : Uint256 = Uint256(low=32, high=0)
    let (local _2_23 : Uint256) = uint256_sub(dataEnd_20, headStart_19)
    local range_check_ptr = range_check_ptr
    let (local _3_24 : Uint256) = slt(_2_23, _1_22)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_24)
    let (local value0_21 : Uint256) = abi_decode_t_bool_fromMemory(headStart_19)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_21)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_112 : Uint256) -> (expr_123 : Uint256):
    alloc_locals
    let (local _15_124 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_4_112, _15_124)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_125 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _17_126 : Uint256) = u256_add(_4_112, _16_125)
    local range_check_ptr = range_check_ptr
    let (local expr_123 : Uint256) = abi_decode_bool_fromMemory(_4_112, _17_126)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_123)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _13_121 : Uint256, _4_112 : Uint256, expr_123 : Uint256) -> (expr_123 : Uint256):
    alloc_locals
    if _13_121.low + _13_121.high != 0:
        let (local expr_123 : Uint256) = __warp_block_0(_4_112)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_123)
    else:
        return (expr_123)
    end
end

func fun_sendMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_contract_addr : Uint256, var_from : Uint256, var_to_109 : Uint256,
        var_amount : Uint256) -> (var_110 : Uint256):
    alloc_locals
    local _3_111 : Uint256 = Uint256(low=64, high=0)
    let (local _4_112 : Uint256) = uint256_mload(_3_111)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_113 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_4_112, value=_5_113)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_114 : Uint256 = Uint256(low=32, high=0)
    local _7_115 : Uint256 = Uint256(low=4, high=0)
    let (local _8_116 : Uint256) = u256_add(_4_112, _7_115)
    local range_check_ptr = range_check_ptr
    let (local _9_117 : Uint256) = abi_encode_address_address_uint256(
        _8_116, var_from, var_to_109, var_amount)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_118 : Uint256) = uint256_sub(_9_117, _4_112)
    local range_check_ptr = range_check_ptr
    local _11_119 : Uint256 = Uint256(low=0, high=0)
    let (local _12_120 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _13_121 : Uint256) = warp_call(
        _12_120, var_contract_addr, _11_119, _4_112, _10_118, _4_112, _6_114)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _14_122 : Uint256) = is_zero(_13_121)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_14_122)
    local expr_123 : Uint256 = _11_119
    let (local expr_123 : Uint256) = __warp_if_0(_13_121, _4_112, expr_123)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_110 : Uint256 = expr_123
    return (var_110)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_32 : Uint256, pos_33 : Uint256) -> ():
    alloc_locals
    let (local _1_34 : Uint256) = is_zero(value_32)
    local range_check_ptr = range_check_ptr
    let (local _2_35 : Uint256) = is_zero(_1_34)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos_33, value=_2_35)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_60 : Uint256, value0_61 : Uint256) -> (tail_62 : Uint256):
    alloc_locals
    local _1_63 : Uint256 = Uint256(low=32, high=0)
    let (local tail_62 : Uint256) = u256_add(headStart_60, _1_63)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_61, headStart_60)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_62)
end

func abi_decode_addresst_address{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=64, high=0)
    let (local _2_2 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = slt(_2_2, _1_1)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    let (local value0 : Uint256) = calldataload(headStart)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_4 : Uint256 = Uint256(low=32, high=0)
    let (local _5_5 : Uint256) = u256_add(headStart, _4_4)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldataload(_5_5)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1)
end

func abi_encode_tuple_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_40 : Uint256, value0_41 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_42 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_40, _1_42)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_41, headStart_40)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode_uint256_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_25 : Uint256, dataEnd_26 : Uint256) -> (value0_27 : Uint256):
    alloc_locals
    local _1_28 : Uint256 = Uint256(low=32, high=0)
    let (local _2_29 : Uint256) = uint256_sub(dataEnd_26, headStart_25)
    local range_check_ptr = range_check_ptr
    let (local _3_30 : Uint256) = slt(_2_29, _1_28)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_30)
    let (local value0_27 : Uint256) = uint256_mload(headStart_25)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_27)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_78 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _14_88 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_4_78, _14_88)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_89 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _16_90 : Uint256) = u256_add(_4_78, _15_89)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_uint256_fromMemory(_4_78, _16_90)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_86 : Uint256, _4_78 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _12_86.low + _12_86.high != 0:
        let (local expr : Uint256) = __warp_block_1(_4_78)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr)
    else:
        return (expr)
    end
end

func fun_checkMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_addr : Uint256, var_to : Uint256) -> (var_ : Uint256):
    alloc_locals
    local _3_77 : Uint256 = Uint256(low=64, high=0)
    let (local _4_78 : Uint256) = uint256_mload(_3_77)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_79 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_4_78, value=_5_79)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_80 : Uint256 = Uint256(low=32, high=0)
    local _7_81 : Uint256 = Uint256(low=4, high=0)
    let (local _8_82 : Uint256) = u256_add(_4_78, _7_81)
    local range_check_ptr = range_check_ptr
    let (local _9_83 : Uint256) = abi_encode_tuple_address(_8_82, var_to)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_84 : Uint256) = uint256_sub(_9_83, _4_78)
    local range_check_ptr = range_check_ptr
    let (local _11_85 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _12_86 : Uint256) = warp_static_call(_11_85, var_addr, _4_78, _10_84, _4_78, _6_80)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _13_87 : Uint256) = is_zero(_12_86)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_87)
    local expr : Uint256 = Uint256(low=0, high=0)
    let (local expr : Uint256) = __warp_if_1(_12_86, _4_78, expr)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_ : Uint256 = expr
    return (var_)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_64 : Uint256, value0_65 : Uint256) -> (tail_66 : Uint256):
    alloc_locals
    local _1_67 : Uint256 = Uint256(low=32, high=0)
    let (local tail_66 : Uint256) = u256_add(headStart_64, _1_67)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_65, headStart_64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_66)
end

func abi_encode_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_36 : Uint256, pos_37 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_37, value=value_36)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_53 : Uint256, value0_54 : Uint256, value1_55 : Uint256) -> (tail_56 : Uint256):
    alloc_locals
    local _1_57 : Uint256 = Uint256(low=64, high=0)
    let (local tail_56 : Uint256) = u256_add(headStart_53, _1_57)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_54, headStart_53)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_58 : Uint256 = Uint256(low=32, high=0)
    let (local _3_59 : Uint256) = u256_add(headStart_53, _2_58)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(value1_55, _3_59)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_56)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_93 : Uint256) -> (expr_105 : Uint256):
    alloc_locals
    let (local _16_106 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_4_93, _16_106)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_107 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _18_108 : Uint256) = u256_add(_4_93, _17_107)
    local range_check_ptr = range_check_ptr
    let (local expr_105 : Uint256) = abi_decode_bool_fromMemory(_4_93, _18_108)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_105)
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _14_103 : Uint256, _4_93 : Uint256, expr_105 : Uint256) -> (expr_105 : Uint256):
    alloc_locals
    if _14_103.low + _14_103.high != 0:
        let (local expr_105 : Uint256) = __warp_block_2(_4_93)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_105)
    else:
        return (expr_105)
    end
end

func fun_gimmeMoney{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_add : Uint256, var_to_91 : Uint256) -> (var : Uint256):
    alloc_locals
    local _3_92 : Uint256 = Uint256(low=64, high=0)
    let (local _4_93 : Uint256) = uint256_mload(_3_92)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_94 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=1086394137, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_4_93, value=_5_94)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_95 : Uint256 = Uint256(low=32, high=0)
    local _7_96 : Uint256 = Uint256(low=42, high=0)
    local _8_97 : Uint256 = Uint256(low=4, high=0)
    let (local _9_98 : Uint256) = u256_add(_4_93, _8_97)
    local range_check_ptr = range_check_ptr
    let (local _10_99 : Uint256) = abi_encode_address_rational_by(_9_98, var_to_91, _7_96)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _11_100 : Uint256) = uint256_sub(_10_99, _4_93)
    local range_check_ptr = range_check_ptr
    local _12_101 : Uint256 = Uint256(low=0, high=0)
    let (local _13_102 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _14_103 : Uint256) = warp_call(
        _13_102, var_add, _12_101, _4_93, _11_100, _4_93, _6_95)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _15_104 : Uint256) = is_zero(_14_103)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_15_104)
    local expr_105 : Uint256 = _12_101
    let (local expr_105 : Uint256) = __warp_if_2(_14_103, _4_93, expr_105)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var : Uint256 = expr_105
    return (var)
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_11)
    local _12 : Uint256 = _4
    local _13 : Uint256 = _3
    let (local param : Uint256, local param_1 : Uint256, local param_2 : Uint256,
        local param_3 : Uint256) = abi_decode_addresst_addresst_addresst_uint256(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_sendMoneyz(param, param_1, param_2, param_3)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _14 : Uint256 = _2
    let (local memPos : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15 : Uint256) = abi_encode_bool(memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_sub(_15, memPos)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos, _16)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_8{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _17 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_17)
    local _18 : Uint256 = _4
    local _19 : Uint256 = _3
    let (local param_4 : Uint256, local param_5 : Uint256) = abi_decode_addresst_address(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_checkMoneyz(param_4, param_5)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _20 : Uint256 = _2
    let (local memPos_1 : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22 : Uint256) = uint256_sub(_21, memPos_1)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_1, _22)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_block_10{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _23 : Uint256) = __warp_constant_0()
    __warp_cond_revert(_23)
    local _24 : Uint256 = _4
    local _25 : Uint256 = _3
    let (local param_6 : Uint256, local param_7 : Uint256) = abi_decode_addresst_address(_3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_gimmeMoney(param_6, param_7)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _26 : Uint256 = _2
    let (local memPos_2 : Uint256) = uint256_mload(_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = abi_encode_bool(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _28 : Uint256) = uint256_sub(_27, memPos_2)
    local range_check_ptr = range_check_ptr
    returndata_write(memPos_2, _28)
    local exec_env : ExecutionEnvironment* = exec_env
    return ()
end

func __warp_if_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_9{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3747097146, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_6(_2, _3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_8(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_9(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_7{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1506652845, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_5(_2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _2 : Uint256, _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_6(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_7(_2, _3, _4, match_var)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_5{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=762392335, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_4(_2, _3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_4{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_10 : Uint256, _2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_5(_2, _3, _4, match_var)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldataload(_7)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = u256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_4(_10, _2, _3, _4)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_3{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_3(_2, _3, _4)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
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
        __warp_if_3(_2, _3, _4, _6)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
    end
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)
end

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

func abi_decode_addresst_addresst_addresst_uint256{
        exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart : Uint256, dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_5 : Uint256 = Uint256(low=128, high=0)
    let (local _2_6 : Uint256) = uint256_sub(dataEnd, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_7 : Uint256) = slt(_2_6, _1_5)
    local range_check_ptr = range_check_ptr
    if _3_7.low + _3_7.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0 : Uint256) = calldataload(headStart)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_8 : Uint256 = Uint256(low=32, high=0)
    let (local _5_9 : Uint256) = u256_add(headStart, _4_8)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = calldataload(_5_9)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _6_10 : Uint256 = Uint256(low=64, high=0)
    let (local _7_11 : Uint256) = u256_add(headStart, _6_10)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = calldataload(_7_11)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _8_12 : Uint256 = Uint256(low=96, high=0)
    let (local _9_13 : Uint256) = u256_add(headStart, _8_12)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = calldataload(_9_13)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0, value1, value2, value3)
end

func abi_encode_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_65 : Uint256, pos_66 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_66, value=value_65)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_28 : Uint256, pos_29 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_29, value=value_28)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_address_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_123 : Uint256, value0_124 : Uint256, value1_125 : Uint256,
        value2_126 : Uint256) -> (tail_127 : Uint256):
    alloc_locals
    local _1_128 : Uint256 = Uint256(low=96, high=0)
    let (local tail_127 : Uint256) = u256_add(headStart_123, _1_128)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_124, headStart_123)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_129 : Uint256 = Uint256(low=32, high=0)
    let (local _3_130 : Uint256) = u256_add(headStart_123, _2_129)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_125, _3_130)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_131 : Uint256 = Uint256(low=64, high=0)
    let (local _5_132 : Uint256) = u256_add(headStart_123, _4_131)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_126, _5_132)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_127)
end

func finalize_allocation{memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_42 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_43 : Uint256 = Uint256(low=31, high=0)
    let (local _3_44 : Uint256) = u256_add(size, _2_43)
    local range_check_ptr = range_check_ptr
    let (local _4_45 : Uint256) = uint256_and(_3_44, _1_42)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr, _4_45)
    local range_check_ptr = range_check_ptr
    let (local _5_46 : Uint256) = is_lt(newFreePtr, memPtr)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = u256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_47 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_48 : Uint256) = is_gt(newFreePtr, _6_47)
    local range_check_ptr = range_check_ptr
    let (local _8_49 : Uint256) = uint256_sub(_7_48, _5_46)
    local range_check_ptr = range_check_ptr
    if _8_49.low + _8_49.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local _9_50 : Uint256 = Uint256(low=64, high=0)
    uint256_mstore(offset=_9_50, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func validator_revert_bool{range_check_ptr}(value_51 : Uint256) -> ():
    alloc_locals
    let (local _1_52 : Uint256) = is_zero(value_51)
    local range_check_ptr = range_check_ptr
    let (local _2_53 : Uint256) = is_zero(_1_52)
    local range_check_ptr = range_check_ptr
    let (local _3_54 : Uint256) = is_eq(value_51, _2_53)
    local range_check_ptr = range_check_ptr
    let (local _4_55 : Uint256) = is_zero(_3_54)
    local range_check_ptr = range_check_ptr
    if _4_55.low + _4_55.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_t_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        offset : Uint256) -> (value_58 : Uint256):
    alloc_locals
    let (local value_58 : Uint256) = uint256_mload(offset)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    validator_revert_bool(value_58)
    local range_check_ptr = range_check_ptr
    return (value_58)
end

func abi_decode_bool_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_59 : Uint256, dataEnd_60 : Uint256) -> (value0_61 : Uint256):
    alloc_locals
    local _1_62 : Uint256 = Uint256(low=32, high=0)
    let (local _2_63 : Uint256) = uint256_sub(dataEnd_60, headStart_59)
    local range_check_ptr = range_check_ptr
    let (local _3_64 : Uint256) = slt(_2_63, _1_62)
    local range_check_ptr = range_check_ptr
    if _3_64.low + _3_64.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_61 : Uint256) = abi_decode_t_bool_fromMemory(headStart_59)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_61)
end

func __warp_block_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_136 : Uint256) -> (expr_147 : Uint256):
    alloc_locals
    let (local _13_148 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_2_136, _13_148)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_149 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _15_150 : Uint256) = u256_add(_2_136, _14_149)
    local range_check_ptr = range_check_ptr
    let (local expr_147 : Uint256) = abi_decode_bool_fromMemory(_2_136, _15_150)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_147)
end

func __warp_if_0{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_145 : Uint256, _2_136 : Uint256, expr_147 : Uint256) -> (expr_147 : Uint256):
    alloc_locals
    if _11_145.low + _11_145.high != 0:
        let (local expr_147 : Uint256) = __warp_block_0(_2_136)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_147)
    else:
        return (expr_147)
    end
end

func fun_sendMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_contract_addr : Uint256, var_from : Uint256, var_to_133 : Uint256,
        var_amount : Uint256) -> (var_134 : Uint256):
    alloc_locals
    local _1_135 : Uint256 = Uint256(low=64, high=0)
    let (local _2_136 : Uint256) = uint256_mload(_1_135)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_137 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_2_136, value=_3_137)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_138 : Uint256 = Uint256(low=32, high=0)
    local _5_139 : Uint256 = Uint256(low=4, high=0)
    let (local _6_140 : Uint256) = u256_add(_2_136, _5_139)
    local range_check_ptr = range_check_ptr
    let (local _7_141 : Uint256) = abi_encode_address_address_uint256(
        _6_140, var_from, var_to_133, var_amount)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_142 : Uint256) = uint256_sub(_7_141, _2_136)
    local range_check_ptr = range_check_ptr
    local _9_143 : Uint256 = Uint256(low=0, high=0)
    let (local _10_144 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _11_145 : Uint256) = warp_call(
        _10_144, var_contract_addr, _9_143, _2_136, _8_142, _2_136, _4_138)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _12_146 : Uint256) = is_zero(_11_145)
    local range_check_ptr = range_check_ptr
    if _12_146.low + _12_146.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local expr_147 : Uint256 = _9_143
    let (local expr_147 : Uint256) = __warp_if_0(_11_145, _2_136, expr_147)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_134 : Uint256 = expr_147
    return (var_134)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_14 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local _2_15 : Uint256) = is_zero(_1_14)
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=pos, value=_2_15)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_16 : Uint256, value0_17 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart_16, _1_18)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool(value0_17, headStart_16)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_decode_addresst_address{exec_env : ExecutionEnvironment*, range_check_ptr}(
        headStart_19 : Uint256, dataEnd_20 : Uint256) -> (value0_21 : Uint256, value1_22 : Uint256):
    alloc_locals
    local _1_23 : Uint256 = Uint256(low=64, high=0)
    let (local _2_24 : Uint256) = uint256_sub(dataEnd_20, headStart_19)
    local range_check_ptr = range_check_ptr
    let (local _3_25 : Uint256) = slt(_2_24, _1_23)
    local range_check_ptr = range_check_ptr
    if _3_25.low + _3_25.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_21 : Uint256) = calldataload(headStart_19)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local _4_26 : Uint256 = Uint256(low=32, high=0)
    let (local _5_27 : Uint256) = u256_add(headStart_19, _4_26)
    local range_check_ptr = range_check_ptr
    let (local value1_22 : Uint256) = calldataload(_5_27)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    return (value0_21, value1_22)
end

func abi_encode_tuple_address{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_103 : Uint256, value0_104 : Uint256) -> (tail_105 : Uint256):
    alloc_locals
    local _1_106 : Uint256 = Uint256(low=32, high=0)
    let (local tail_105 : Uint256) = u256_add(headStart_103, _1_106)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_104, headStart_103)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_105)
end

func abi_decode_uint256_fromMemory{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_97 : Uint256, dataEnd_98 : Uint256) -> (value0_99 : Uint256):
    alloc_locals
    local _1_100 : Uint256 = Uint256(low=32, high=0)
    let (local _2_101 : Uint256) = uint256_sub(dataEnd_98, headStart_97)
    local range_check_ptr = range_check_ptr
    let (local _3_102 : Uint256) = slt(_2_101, _1_100)
    local range_check_ptr = range_check_ptr
    if _3_102.low + _3_102.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    let (local value0_99 : Uint256) = uint256_mload(headStart_97)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_99)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_109 : Uint256) -> (expr_119 : Uint256):
    alloc_locals
    let (local _12_120 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_2_109, _12_120)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_121 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _14_122 : Uint256) = u256_add(_2_109, _13_121)
    local range_check_ptr = range_check_ptr
    let (local expr_119 : Uint256) = abi_decode_uint256_fromMemory(_2_109, _14_122)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_119)
end

func __warp_if_1{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _10_117 : Uint256, _2_109 : Uint256, expr_119 : Uint256) -> (expr_119 : Uint256):
    alloc_locals
    if _10_117.low + _10_117.high != 0:
        let (local expr_119 : Uint256) = __warp_block_1(_2_109)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_119)
    else:
        return (expr_119)
    end
end

func fun_checkMoneyz{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_addr : Uint256, var_to_107 : Uint256) -> (var_ : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=64, high=0)
    let (local _2_109 : Uint256) = uint256_mload(_1_108)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_110 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_2_109, value=_3_110)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_111 : Uint256 = Uint256(low=32, high=0)
    local _5_112 : Uint256 = Uint256(low=4, high=0)
    let (local _6_113 : Uint256) = u256_add(_2_109, _5_112)
    local range_check_ptr = range_check_ptr
    let (local _7_114 : Uint256) = abi_encode_tuple_address(_6_113, var_to_107)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_115 : Uint256) = uint256_sub(_7_114, _2_109)
    local range_check_ptr = range_check_ptr
    let (local _9_116 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _10_117 : Uint256) = warp_static_call(
        _9_116, var_addr, _2_109, _8_115, _2_109, _4_111)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _11_118 : Uint256) = is_zero(_10_117)
    local range_check_ptr = range_check_ptr
    if _11_118.low + _11_118.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local expr_119 : Uint256 = Uint256(low=0, high=0)
    let (local expr_119 : Uint256) = __warp_if_1(_10_117, _2_109, expr_119)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_ : Uint256 = expr_119
    return (var_)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_30 : Uint256, value0_31 : Uint256) -> (tail_32 : Uint256):
    alloc_locals
    local _1_33 : Uint256 = Uint256(low=32, high=0)
    let (local tail_32 : Uint256) = u256_add(headStart_30, _1_33)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_31, headStart_30)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_32)
end

func abi_encode_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_67 : Uint256, pos_68 : Uint256) -> ():
    alloc_locals
    uint256_mstore(offset=pos_68, value=value_67)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_rational_by{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_69 : Uint256, value0_70 : Uint256, value1_71 : Uint256) -> (tail_72 : Uint256):
    alloc_locals
    local _1_73 : Uint256 = Uint256(low=64, high=0)
    let (local tail_72 : Uint256) = u256_add(headStart_69, _1_73)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_70, headStart_69)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_74 : Uint256 = Uint256(low=32, high=0)
    let (local _3_75 : Uint256) = u256_add(headStart_69, _2_74)
    local range_check_ptr = range_check_ptr
    abi_encode_rational_by(value1_71, _3_75)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_72)
end

func __warp_block_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_82 : Uint256) -> (expr : Uint256):
    alloc_locals
    let (local _14_94 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    finalize_allocation(_2_82, _14_94)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_95 : Uint256) = returndata_size()
    local exec_env : ExecutionEnvironment* = exec_env
    let (local _16_96 : Uint256) = u256_add(_2_82, _15_95)
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = abi_decode_bool_fromMemory(_2_82, _16_96)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr)
end

func __warp_if_2{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_92 : Uint256, _2_82 : Uint256, expr : Uint256) -> (expr : Uint256):
    alloc_locals
    if _12_92.low + _12_92.high != 0:
        let (local expr : Uint256) = __warp_block_2(_2_82)
        local exec_env : ExecutionEnvironment* = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr)
    else:
        return (expr)
    end
end

func fun_gimmeMoney{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_add : Uint256, var_to : Uint256) -> (var : Uint256):
    alloc_locals
    local _1_81 : Uint256 = Uint256(low=64, high=0)
    let (local _2_82 : Uint256) = uint256_mload(_1_81)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_83 : Uint256) = u256_shl(
        Uint256(low=224, high=0), Uint256(low=1086394137, high=0))
    local range_check_ptr = range_check_ptr
    uint256_mstore(offset=_2_82, value=_3_83)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_84 : Uint256 = Uint256(low=32, high=0)
    local _5_85 : Uint256 = Uint256(low=42, high=0)
    local _6_86 : Uint256 = Uint256(low=4, high=0)
    let (local _7_87 : Uint256) = u256_add(_2_82, _6_86)
    local range_check_ptr = range_check_ptr
    let (local _8_88 : Uint256) = abi_encode_address_rational_by(_7_87, var_to, _5_85)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _9_89 : Uint256) = uint256_sub(_8_88, _2_82)
    local range_check_ptr = range_check_ptr
    local _10_90 : Uint256 = Uint256(low=0, high=0)
    let (local _11_91 : Uint256) = __warp_constant_10000000000000000000000000000000000000000()
    let (local _12_92 : Uint256) = warp_call(_11_91, var_add, _10_90, _2_82, _9_89, _2_82, _4_84)
    local syscall_ptr : felt* = syscall_ptr
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local range_check_ptr = range_check_ptr
    let (local _13_93 : Uint256) = is_zero(_12_92)
    local range_check_ptr = range_check_ptr
    if _13_93.low + _13_93.high != 0:
        assert 0 = 1
        jmp rel 0
    end
    local expr : Uint256 = _10_90
    let (local expr : Uint256) = __warp_if_2(_12_92, _2_82, expr)
    local exec_env : ExecutionEnvironment* = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var : Uint256 = expr
    return (var)
end

func __warp_block_6{
        exec_env : ExecutionEnvironment*, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_2 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _11 : Uint256) = __warp_constant_0()
    if _11.low + _11.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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
    if _17.low + _17.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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
    if _23.low + _23.high != 0:
        assert 0 = 1
        jmp rel 0
    end
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

%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load, calldatacopy_, get_caller_data_uint256
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.sha3 import sha
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, sgt, slt, u256_add, u256_div, u256_mul
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
func I_am_a_mistake() -> (res : Uint256):
end

@storage_var
func OCaml() -> (res : Uint256):
end

@storage_var
func WETH9() -> (res : Uint256):
end

@storage_var
func age() -> (res : Uint256):
end

@storage_var
func amountInCached() -> (res : Uint256):
end

@storage_var
func balancePeople(arg0_low, arg0_high) -> (res : Uint256):
end

@storage_var
func factory() -> (res : Uint256):
end

@storage_var
func seaplusplus() -> (res : Uint256):
end

@storage_var
func succinctly() -> (res : Uint256):
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

func shift_right_unsigned{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2017 : Uint256) -> (newValue_2018 : Uint256):
    alloc_locals
    local _1_2019 : Uint256 = Uint256(low=224, high=0)
    let (local newValue_2018 : Uint256) = uint256_shr(_1_2019, value_2017)
    local range_check_ptr = range_check_ptr
    return (newValue_2018)
end

func __warp_cond_revert(_3_108 : Uint256) -> ():
    alloc_locals
    if _3_108.low + _3_108.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_struct_ExactInputSingleParams_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_103 : Uint256, end_104 : Uint256) -> (value_105 : Uint256):
    alloc_locals
    local _1_106 : Uint256 = Uint256(low=256, high=0)
    let (local _2_107 : Uint256) = uint256_sub(end_104, offset_103)
    local range_check_ptr = range_check_ptr
    let (local _3_108 : Uint256) = slt(_2_107, _1_106)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_108)
    local exec_env : ExecutionEnvironment = exec_env
    local value_105 : Uint256 = offset_103
    return (value_105)
end

func abi_decode_struct_ExactInputSingleParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_301 : Uint256, dataEnd_302 : Uint256) -> (value0_303 : Uint256):
    alloc_locals
    local _1_304 : Uint256 = Uint256(low=256, high=0)
    let (local _2_305 : Uint256) = uint256_sub(dataEnd_302, headStart_301)
    local range_check_ptr = range_check_ptr
    let (local _3_306 : Uint256) = slt(_2_305, _1_304)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_306)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_307 : Uint256 = Uint256(low=0, high=0)
    let (local _4_308 : Uint256) = u256_add(headStart_301, offset_307)
    local range_check_ptr = range_check_ptr
    let (local value0_303 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata(
        _4_308, dataEnd_302)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_303)
end

func zero_value_for_split_uint256() -> (ret_2096 : Uint256):
    alloc_locals
    local ret_2096 : Uint256 = Uint256(low=0, high=0)
    return (ret_2096)
end

func cleanup_uint256(value_784 : Uint256) -> (cleaned_785 : Uint256):
    alloc_locals
    local cleaned_785 : Uint256 = value_784
    return (cleaned_785)
end

func validator_revert_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2063 : Uint256) -> ():
    alloc_locals
    let (local _1_2064 : Uint256) = cleanup_uint256(value_2063)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2065 : Uint256) = is_eq(value_2063, _1_2064)
    local range_check_ptr = range_check_ptr
    let (local _3_2066 : Uint256) = is_zero(_2_2065)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2066)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1922 : Uint256) -> (returnValue_1923 : Uint256):
    alloc_locals
    let (local value_1924 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_1922.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint256(value_1924)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1923 : Uint256 = value_1924
    return (returnValue_1923)
end

func fun_blockTimestamp() -> (var : Uint256):
    alloc_locals
    let (local expr_942 : Uint256) = __warp_holder()
    local var : Uint256 = expr_942
    return (var)
end

func require_helper{exec_env : ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_1937 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_1937)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func cleanup_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(value_778 : Uint256) -> (
        cleaned_779 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_780 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local cleaned_779 : Uint256) = uint256_and(value_778, _1_780)
    local range_check_ptr = range_check_ptr
    return (cleaned_779)
end

func cleanup_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_768 : Uint256) -> (
        cleaned : Uint256):
    alloc_locals
    let (local cleaned : Uint256) = cleanup_uint160(value_768)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (cleaned)
end

func validator_revert_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2027 : Uint256) -> ():
    alloc_locals
    let (local _1_2028 : Uint256) = cleanup_address(value_2027)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_2029 : Uint256) = is_eq(value_2027, _1_2028)
    local range_check_ptr = range_check_ptr
    let (local _3_2030 : Uint256) = is_zero(_2_2029)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2030)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1914 : Uint256) -> (returnValue : Uint256):
    alloc_locals
    let (local value_1915 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_1914.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value_1915)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue : Uint256 = value_1915
    return (returnValue)
end

func validator_revert_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2051 : Uint256) -> ():
    alloc_locals
    let (local _1_2052 : Uint256) = cleanup_uint160(value_2051)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2053 : Uint256) = is_eq(value_2051, _1_2052)
    local range_check_ptr = range_check_ptr
    let (local _3_2054 : Uint256) = is_zero(_2_2053)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2054)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1916 : Uint256) -> (returnValue_1917 : Uint256):
    alloc_locals
    let (local value_1918 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_1916.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint160(value_1918)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1917 : Uint256 = value_1918
    return (returnValue_1917)
end

func cleanup_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(value_781 : Uint256) -> (
        cleaned_782 : Uint256):
    alloc_locals
    local _1_783 : Uint256 = Uint256(low=16777215, high=0)
    let (local cleaned_782 : Uint256) = uint256_and(value_781, _1_783)
    local range_check_ptr = range_check_ptr
    return (cleaned_782)
end

func validator_revert_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2057 : Uint256) -> ():
    alloc_locals
    let (local _1_2058 : Uint256) = cleanup_uint24(value_2057)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2059 : Uint256) = is_eq(value_2057, _1_2058)
    local range_check_ptr = range_check_ptr
    let (local _3_2060 : Uint256) = is_zero(_2_2059)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2060)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1919 : Uint256) -> (returnValue_1920 : Uint256):
    alloc_locals
    let (local value_1921 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_1919.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint24(value_1921)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1920 : Uint256 = value_1921
    return (returnValue_1920)
end

func allocate_unbounded{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_680 : Uint256):
    alloc_locals
    local _1_681 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_680 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_681.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_680)
end

func shift_left_96{exec_env : ExecutionEnvironment, range_check_ptr}(value_2014 : Uint256) -> (
        newValue_2015 : Uint256):
    alloc_locals
    local _1_2016 : Uint256 = Uint256(low=96, high=0)
    let (local newValue_2015 : Uint256) = uint256_shl(_1_2016, value_2014)
    local range_check_ptr = range_check_ptr
    return (newValue_2015)
end

func leftAlign_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(value_1828 : Uint256) -> (
        aligned_1829 : Uint256):
    alloc_locals
    let (local aligned_1829 : Uint256) = shift_left_96(value_1828)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (aligned_1829)
end

func leftAlign_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_1825 : Uint256) -> (
        aligned : Uint256):
    alloc_locals
    let (local aligned : Uint256) = leftAlign_uint160(value_1825)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (aligned)
end

func abi_encode_address_to_address_nonPadded_inplace{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_384 : Uint256, pos_385 : Uint256) -> ():
    alloc_locals
    let (local _1_386 : Uint256) = cleanup_address(value_384)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_387 : Uint256) = leftAlign_address(_1_386)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_385.low, value=_2_387)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func shift_left_232{exec_env : ExecutionEnvironment, range_check_ptr}(value_2011 : Uint256) -> (
        newValue_2012 : Uint256):
    alloc_locals
    local _1_2013 : Uint256 = Uint256(low=232, high=0)
    let (local newValue_2012 : Uint256) = uint256_shl(_1_2013, value_2011)
    local range_check_ptr = range_check_ptr
    return (newValue_2012)
end

func leftAlign_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(value_1830 : Uint256) -> (
        aligned_1831 : Uint256):
    alloc_locals
    let (local aligned_1831 : Uint256) = shift_left_232(value_1830)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (aligned_1831)
end

func abi_encode_uint24_to_uint24_nonPadded_inplace{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_459 : Uint256, pos_460 : Uint256) -> ():
    alloc_locals
    let (local _1_461 : Uint256) = cleanup_uint24(value_459)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_462 : Uint256) = leftAlign_uint24(_1_461)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_460.low, value=_2_462)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_packed_address_uint24_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_472 : Uint256, value0_473 : Uint256, value1_474 : Uint256, value2_475 : Uint256) -> (
        end_476 : Uint256):
    alloc_locals
    abi_encode_address_to_address_nonPadded_inplace(value0_473, pos_472)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_477 : Uint256 = Uint256(low=20, high=0)
    let (local pos_472 : Uint256) = u256_add(pos_472, _1_477)
    local range_check_ptr = range_check_ptr
    abi_encode_uint24_to_uint24_nonPadded_inplace(value1_474, pos_472)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_478 : Uint256 = Uint256(low=3, high=0)
    let (local pos_472 : Uint256) = u256_add(pos_472, _2_478)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address_nonPadded_inplace(value2_475, pos_472)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_479 : Uint256 = _1_477
    let (local pos_472 : Uint256) = u256_add(pos_472, _1_477)
    local range_check_ptr = range_check_ptr
    local end_476 : Uint256 = pos_472
    return (end_476)
end

func round_up_to_mul_of{exec_env : ExecutionEnvironment, range_check_ptr}(value_1974 : Uint256) -> (
        result : Uint256):
    alloc_locals
    local _1_1975 : Uint256 = Uint256(low=31, high=0)
    let (local _2_1976 : Uint256) = uint256_not(_1_1975)
    local range_check_ptr = range_check_ptr
    local _3_1977 : Uint256 = _1_1975
    let (local _4_1978 : Uint256) = u256_add(value_1974, _1_1975)
    local range_check_ptr = range_check_ptr
    let (local result : Uint256) = uint256_and(_4_1978, _2_1976)
    local range_check_ptr = range_check_ptr
    return (result)
end

func finalize_allocation{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_929 : Uint256, size_930 : Uint256) -> ():
    alloc_locals
    let (local _1_931 : Uint256) = round_up_to_mul_of(size_930)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local newFreePtr : Uint256) = u256_add(memPtr_929, _1_931)
    local range_check_ptr = range_check_ptr
    let (local _2_932 : Uint256) = is_lt(newFreePtr, memPtr_929)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_933 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_934 : Uint256) = is_gt(newFreePtr, _3_933)
    local range_check_ptr = range_check_ptr
    let (local _5_935 : Uint256) = uint256_sub(_4_934, _2_932)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_935)
    local exec_env : ExecutionEnvironment = exec_env
    local _6_936 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_936.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        size : Uint256) -> (memPtr_668 : Uint256):
    alloc_locals
    let (local memPtr_668 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    finalize_allocation(memPtr_668, size)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_668)
end

func allocate_memory_struct_struct_SwapCallbackData_storage_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_678 : Uint256):
    alloc_locals
    local _1_679 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_678 : Uint256) = allocate_memory(_1_679)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_678)
end

func write_to_memory_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_2078 : Uint256, value_2079 : Uint256) -> ():
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_2078.low, value=value_2079)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func write_to_memory_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_2075 : Uint256, value_2076 : Uint256) -> ():
    alloc_locals
    let (local _1_2077 : Uint256) = cleanup_address(value_2076)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_2075.low, value=_1_2077)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func convert_rational_0_by_1_to_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_861 : Uint256) -> (converted_862 : Uint256):
    alloc_locals
    let (local converted_862 : Uint256) = cleanup_uint160(value_861)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_862)
end

func convert_rational_by_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_857 : Uint256) -> (converted_858 : Uint256):
    alloc_locals
    let (local converted_858 : Uint256) = convert_rational_0_by_1_to_uint160(value_857)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_858)
end

func convert_uint160_to_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_902 : Uint256) -> (converted_903 : Uint256):
    alloc_locals
    let (local converted_903 : Uint256) = cleanup_uint160(value_902)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_903)
end

func convert_uint160_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_890 : Uint256) -> (converted_891 : Uint256):
    alloc_locals
    let (local converted_891 : Uint256) = convert_uint160_to_uint160(value_890)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_891)
end

func convert_contract_SwapRouter_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_853 : Uint256) -> (converted_854 : Uint256):
    alloc_locals
    let (local converted_854 : Uint256) = convert_uint160_to_address(value_853)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_854)
end

func setter_fun_balancePeople{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0 : Uint256, value_1994 : Uint256) -> ():
    alloc_locals
    balancePeople.write(arg0.low, arg0.high, value_1994)
    return ()
end

func convert_rational_21_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_878 : Uint256) -> (converted_879 : Uint256):
    alloc_locals
    let (local converted_879 : Uint256) = cleanup_uint256(value_878)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_879)
end

func setter_fun_age{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1988 : Uint256) -> ():
    alloc_locals
    age.write(value_1988)
    return ()
end

func convert_rational_0_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_863 : Uint256) -> (converted_864 : Uint256):
    alloc_locals
    let (local converted_864 : Uint256) = cleanup_uint256(value_863)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_864)
end

func convert_rational_by_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_876 : Uint256) -> (converted_877 : Uint256):
    alloc_locals
    let (local converted_877 : Uint256) = cleanup_uint256(value_876)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_877)
end

func checked_add_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_744 : Uint256, y_745 : Uint256) -> (sum_746 : Uint256):
    alloc_locals
    let (local x_744 : Uint256) = cleanup_uint256(x_744)
    local exec_env : ExecutionEnvironment = exec_env
    let (local y_745 : Uint256) = cleanup_uint256(y_745)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_747 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_748 : Uint256) = uint256_sub(_1_747, y_745)
    local range_check_ptr = range_check_ptr
    let (local _3_749 : Uint256) = is_gt(x_744, _2_748)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_749)
    local exec_env : ExecutionEnvironment = exec_env
    let (local sum_746 : Uint256) = u256_add(x_744, y_745)
    local range_check_ptr = range_check_ptr
    return (sum_746)
end

func array_length_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_706 : Uint256) -> (length_707 : Uint256):
    alloc_locals
    let (local length_707 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(value_706.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (length_707)
end

func fun_toAddress{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_bytes_2364_mpos : Uint256, var_start : Uint256) -> (var_1609 : Uint256):
    alloc_locals
    local expr_1610 : Uint256 = Uint256(low=20, high=0)
    let (local _1_1611 : Uint256) = convert_rational_by_to_uint256(expr_1610)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1612 : Uint256) = checked_add_uint256(var_start, _1_1611)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1613 : Uint256) = cleanup_uint256(var_start)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1614 : Uint256) = cleanup_uint256(expr_1_1612)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1615 : Uint256) = is_lt(_3_1614, _2_1613)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1616 : Uint256) = is_zero(_4_1615)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1616)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1617 : Uint256) = array_length_bytes(var_bytes_2364_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _5_1618 : Uint256 = _1_1611
    let (local expr_4_1619 : Uint256) = checked_add_uint256(var_start, _1_1611)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1620 : Uint256) = cleanup_uint256(expr_4_1619)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_1621 : Uint256) = cleanup_uint256(expr_3_1617)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_1622 : Uint256) = is_lt(_7_1621, _6_1620)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1623 : Uint256) = is_zero(_8_1622)
    local range_check_ptr = range_check_ptr
    require_helper(expr_5_1623)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_tempAddress : Uint256 = Uint256(low=0, high=0)
    let (local _9_1624 : Uint256) = uint256_shl(Uint256(low=96, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    local _10_1625 : Uint256 = Uint256(low=32, high=0)
    let (local _11_1626 : Uint256) = u256_add(var_bytes_2364_mpos, _10_1625)
    local range_check_ptr = range_check_ptr
    let (local _12_1627 : Uint256) = u256_add(_11_1626, var_start)
    local range_check_ptr = range_check_ptr
    let (local _13_1628 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_12_1627.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local var_tempAddress : Uint256) = u256_div(_13_1628, _9_1624)
    local range_check_ptr = range_check_ptr
    local var_1609 : Uint256 = var_tempAddress
    return (var_1609)
end

func constant_ADDR_SIZE{exec_env : ExecutionEnvironment, range_check_ptr}() -> (ret_789 : Uint256):
    alloc_locals
    local expr : Uint256 = Uint256(low=20, high=0)
    let (local _1_790 : Uint256) = convert_rational_by_to_uint256(expr)
    local exec_env : ExecutionEnvironment = exec_env
    local ret_789 : Uint256 = _1_790
    return (ret_789)
end

func convert_rational_3_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_882 : Uint256) -> (converted_883 : Uint256):
    alloc_locals
    let (local converted_883 : Uint256) = cleanup_uint256(value_882)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_883)
end

func fun_toUint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_bytes_mpos : Uint256, var_start_1636 : Uint256) -> (var_1637 : Uint256):
    alloc_locals
    local expr_1638 : Uint256 = Uint256(low=3, high=0)
    let (local _1_1639 : Uint256) = convert_rational_3_by_1_to_uint256(expr_1638)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1640 : Uint256) = checked_add_uint256(var_start_1636, _1_1639)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1641 : Uint256) = cleanup_uint256(var_start_1636)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1642 : Uint256) = cleanup_uint256(expr_1_1640)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1643 : Uint256) = is_lt(_3_1642, _2_1641)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1644 : Uint256) = is_zero(_4_1643)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1644)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1645 : Uint256) = array_length_bytes(var_bytes_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _5_1646 : Uint256 = _1_1639
    let (local expr_4_1647 : Uint256) = checked_add_uint256(var_start_1636, _1_1639)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1648 : Uint256) = cleanup_uint256(expr_4_1647)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_1649 : Uint256) = cleanup_uint256(expr_3_1645)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_1650 : Uint256) = is_lt(_7_1649, _6_1648)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1651 : Uint256) = is_zero(_8_1650)
    local range_check_ptr = range_check_ptr
    require_helper(expr_5_1651)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_tempUint : Uint256 = Uint256(low=0, high=0)
    let (local _9_1652 : Uint256) = u256_add(var_bytes_mpos, expr_1638)
    local range_check_ptr = range_check_ptr
    let (local _10_1653 : Uint256) = u256_add(_9_1652, var_start_1636)
    local range_check_ptr = range_check_ptr
    let (local var_tempUint : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_10_1653.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local var_1637 : Uint256 = var_tempUint
    return (var_1637)
end

func constant_FEE_SIZE{exec_env : ExecutionEnvironment, range_check_ptr}() -> (ret_793 : Uint256):
    alloc_locals
    local expr_794 : Uint256 = Uint256(low=3, high=0)
    let (local _1_795 : Uint256) = convert_rational_3_by_1_to_uint256(expr_794)
    local exec_env : ExecutionEnvironment = exec_env
    local ret_793 : Uint256 = _1_795
    return (ret_793)
end

func constant_NEXT_OFFSET{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_804 : Uint256):
    alloc_locals
    let (local expr_805 : Uint256) = constant_ADDR_SIZE()
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_806 : Uint256) = constant_FEE_SIZE()
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2_807 : Uint256) = checked_add_uint256(expr_805, expr_1_806)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_804 : Uint256 = expr_2_807
    return (ret_804)
end

func fun_decodeFirstPool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_2485_mpos : Uint256) -> (
        var_tokenA : Uint256, var_tokenB : Uint256, var_fee : Uint256):
    alloc_locals
    local expr_973 : Uint256 = Uint256(low=0, high=0)
    let (local _1_974 : Uint256) = convert_rational_0_by_1_to_uint256(expr_973)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_975 : Uint256) = fun_toAddress(var_path_2485_mpos, _1_974)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_tokenA : Uint256 = expr_1_975
    let (local expr_2_976 : Uint256) = constant_ADDR_SIZE()
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_3_977 : Uint256) = fun_toUint24(var_path_2485_mpos, expr_2_976)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_fee : Uint256 = expr_3_977
    let (local expr_4_978 : Uint256) = constant_NEXT_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_5_979 : Uint256) = fun_toAddress(var_path_2485_mpos, expr_4_978)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_tokenB : Uint256 = expr_5_979
    return (var_tokenA, var_tokenB, var_fee)
end

func getter_fun_factory{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1811 : Uint256):
    alloc_locals
    let (res) = factory.read()
    return (res)
end

func allocate_memory_struct_struct_PoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_674 : Uint256):
    alloc_locals
    local _1_675 : Uint256 = Uint256(low=96, high=0)
    let (local memPtr_674 : Uint256) = allocate_memory(_1_675)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_674)
end

func zero_value_for_address() -> (ret_2097 : Uint256):
    alloc_locals
    local ret_2097 : Uint256 = Uint256(low=0, high=0)
    return (ret_2097)
end

func zero_value_for_uint24() -> (ret_2099 : Uint256):
    alloc_locals
    local ret_2099 : Uint256 = Uint256(low=0, high=0)
    return (ret_2099)
end

func allocate_and_zero_memory_struct_struct_PoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_661 : Uint256):
    alloc_locals
    let (local memPtr_661 : Uint256) = allocate_memory_struct_struct_PoolKey()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local offset_662 : Uint256 = memPtr_661
    let (local _1_663 : Uint256) = zero_value_for_address()
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_661.low, value=_1_663)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_664 : Uint256 = Uint256(low=32, high=0)
    let (local offset_662 : Uint256) = u256_add(memPtr_661, _2_664)
    local range_check_ptr = range_check_ptr
    local _3_665 : Uint256 = _1_663
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=offset_662.low, value=_1_663)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_666 : Uint256 = _2_664
    let (local offset_662 : Uint256) = u256_add(offset_662, _2_664)
    local range_check_ptr = range_check_ptr
    let (local _5_667 : Uint256) = zero_value_for_uint24()
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=offset_662.low, value=_5_667)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_661)
end

func zero_value_for_split_struct_PoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        ret_2095 : Uint256):
    alloc_locals
    let (local ret_2095 : Uint256) = allocate_and_zero_memory_struct_struct_PoolKey()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (ret_2095)
end

func allocate_memory_struct_struct_PoolKey_storage_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_676 : Uint256):
    alloc_locals
    local _1_677 : Uint256 = Uint256(low=96, high=0)
    let (local memPtr_676 : Uint256) = allocate_memory(_1_677)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_676)
end

func write_to_memory_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_2080 : Uint256, value_2081 : Uint256) -> ():
    alloc_locals
    let (local _1_2082 : Uint256) = cleanup_uint24(value_2081)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_2080.low, value=_1_2082)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func __warp_block_0(var_tokenA_1203 : Uint256, var_tokenB_1204 : Uint256) -> (
        var_tokenA_1203 : Uint256, var_tokenB_1204 : Uint256):
    alloc_locals
    local expr_2578_component : Uint256 = var_tokenB_1204
    local var_tokenB_1204 : Uint256 = var_tokenA_1203
    local var_tokenA_1203 : Uint256 = expr_2578_component
    return (var_tokenA_1203, var_tokenB_1204)
end

func __warp_if_0{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1209 : Uint256, var_tokenA_1203 : Uint256, var_tokenB_1204 : Uint256) -> (
        var_tokenA_1203 : Uint256, var_tokenB_1204 : Uint256):
    alloc_locals
    if expr_1209.low + expr_1209.high != 0:
        let (local var_tokenA_1203 : Uint256, local var_tokenB_1204 : Uint256) = __warp_block_0(
            var_tokenA_1203, var_tokenB_1204)
        local exec_env : ExecutionEnvironment = exec_env
        return (var_tokenA_1203, var_tokenB_1204)
    else:
        return (var_tokenA_1203, var_tokenB_1204)
    end
end

func fun_getPoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_tokenA_1203 : Uint256, var_tokenB_1204 : Uint256, var_fee_1205 : Uint256) -> (
        var__mpos : Uint256):
    alloc_locals
    let (local _1_1206 : Uint256) = zero_value_for_split_struct_PoolKey()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    let (local _2_1207 : Uint256) = cleanup_address(var_tokenB_1204)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1208 : Uint256) = cleanup_address(var_tokenA_1203)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1209 : Uint256) = is_gt(_3_1208, _2_1207)
    local range_check_ptr = range_check_ptr
    let (local var_tokenA_1203 : Uint256, local var_tokenB_1204 : Uint256) = __warp_if_0(
        expr_1209, var_tokenA_1203, var_tokenB_1204)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2586_mpos : Uint256) = allocate_memory_struct_struct_PoolKey_storage_ptr()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_1210 : Uint256 = Uint256(low=0, high=0)
    let (local _5_1211 : Uint256) = u256_add(expr_2586_mpos, _4_1210)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_5_1211, var_tokenA_1203)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_1212 : Uint256 = Uint256(low=32, high=0)
    let (local _7_1213 : Uint256) = u256_add(expr_2586_mpos, _6_1212)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_7_1213, var_tokenB_1204)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1214 : Uint256 = Uint256(low=64, high=0)
    let (local _9_1215 : Uint256) = u256_add(expr_2586_mpos, _8_1214)
    local range_check_ptr = range_check_ptr
    write_to_memory_uint24(_9_1215, var_fee_1205)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var__mpos : Uint256 = expr_2586_mpos
    return (var__mpos)
end

func read_from_memoryt_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        ptr_1925 : Uint256) -> (returnValue_1926 : Uint256):
    alloc_locals
    let (local _1_1927 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(ptr_1925.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local value_1928 : Uint256) = cleanup_address(_1_1927)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1926 : Uint256 = value_1928
    return (returnValue_1926)
end

func read_from_memoryt_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        ptr_1929 : Uint256) -> (returnValue_1930 : Uint256):
    alloc_locals
    let (local _1_1931 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(ptr_1929.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local value_1932 : Uint256) = cleanup_uint24(_1_1931)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local returnValue_1930 : Uint256 = value_1932
    return (returnValue_1930)
end

func abi_encode_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_381 : Uint256, pos_382 : Uint256) -> ():
    alloc_locals
    let (local _1_383 : Uint256) = cleanup_address(value_381)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_382.low, value=_1_383)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_456 : Uint256, pos_457 : Uint256) -> ():
    alloc_locals
    let (local _1_458 : Uint256) = cleanup_uint24(value_456)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_457.low, value=_1_458)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_address_address_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_507 : Uint256, value0_508 : Uint256, value1_509 : Uint256,
        value2_510 : Uint256) -> (tail_511 : Uint256):
    alloc_locals
    local _1_512 : Uint256 = Uint256(low=96, high=0)
    let (local tail_511 : Uint256) = u256_add(headStart_507, _1_512)
    local range_check_ptr = range_check_ptr
    local _2_513 : Uint256 = Uint256(low=0, high=0)
    let (local _3_514 : Uint256) = u256_add(headStart_507, _2_513)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_508, _3_514)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_515 : Uint256 = Uint256(low=32, high=0)
    let (local _5_516 : Uint256) = u256_add(headStart_507, _4_515)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_509, _5_516)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_517 : Uint256 = Uint256(low=64, high=0)
    let (local _7_518 : Uint256) = u256_add(headStart_507, _6_517)
    local range_check_ptr = range_check_ptr
    abi_encode_uint24(value2_510, _7_518)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_511)
end

func array_dataslot_bytes{exec_env : ExecutionEnvironment, range_check_ptr}(ptr_699 : Uint256) -> (
        data_700 : Uint256):
    alloc_locals
    local _1_701 : Uint256 = Uint256(low=32, high=0)
    let (local data_700 : Uint256) = u256_add(ptr_699, _1_701)
    local range_check_ptr = range_check_ptr
    return (data_700)
end

func cleanup_rational_by(value_776 : Uint256) -> (cleaned_777 : Uint256):
    alloc_locals
    local cleaned_777 : Uint256 = value_776
    return (cleaned_777)
end

func shift_left{exec_env : ExecutionEnvironment, range_check_ptr}(value_2006 : Uint256) -> (
        newValue : Uint256):
    alloc_locals
    local _1_2007 : Uint256 = Uint256(low=0, high=0)
    let (local newValue : Uint256) = uint256_shl(_1_2007, value_2006)
    local range_check_ptr = range_check_ptr
    return (newValue)
end

func convert_rational_by_to_bytes32{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_869 : Uint256) -> (converted_870 : Uint256):
    alloc_locals
    let (local _1_871 : Uint256) = cleanup_rational_by(value_869)
    local exec_env : ExecutionEnvironment = exec_env
    let (local converted_870 : Uint256) = shift_left(_1_871)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_870)
end

func constant_POOL_INIT_CODE_HASH{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_808 : Uint256):
    alloc_locals
    local expr_809 : Uint256 = Uint256(low=166342034028256148788603429286353537876, high=302145465843558604112129201577554957650)
    let (local _1_810 : Uint256) = convert_rational_by_to_bytes32(expr_809)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_808 : Uint256 = _1_810
    return (ret_808)
end

func array_storeLengthForEncoding_string_nonPadded_inplace(
        pos_730 : Uint256, length_731 : Uint256) -> (updated_pos_732 : Uint256):
    alloc_locals
    local updated_pos_732 : Uint256 = pos_730
    return (updated_pos_732)
end

func store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_2023 : Uint256) -> ():
    alloc_locals
    let (local _1_2024 : Uint256) = uint256_shl(Uint256(low=248, high=0), Uint256(low=255, high=0))
    local range_check_ptr = range_check_ptr
    local _2_2025 : Uint256 = Uint256(low=0, high=0)
    let (local _3_2026 : Uint256) = u256_add(memPtr_2023, _2_2025)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_2026.low, value=_1_2024)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_stringliteral_8b1a{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_435 : Uint256) -> (end_436 : Uint256):
    alloc_locals
    local _1_437 : Uint256 = Uint256(low=1, high=0)
    let (local pos_435 : Uint256) = array_storeLengthForEncoding_string_nonPadded_inplace(
        pos_435, _1_437)
    local exec_env : ExecutionEnvironment = exec_env
    store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9(
        pos_435)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_438 : Uint256 = _1_437
    let (local end_436 : Uint256) = u256_add(pos_435, _1_437)
    local range_check_ptr = range_check_ptr
    return (end_436)
end

func cleanup_bytes32(value_772 : Uint256) -> (cleaned_773 : Uint256):
    alloc_locals
    local cleaned_773 : Uint256 = value_772
    return (cleaned_773)
end

func leftAlign_bytes32(value_1826 : Uint256) -> (aligned_1827 : Uint256):
    alloc_locals
    local aligned_1827 : Uint256 = value_1826
    return (aligned_1827)
end

func abi_encode_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_404 : Uint256, pos_405 : Uint256) -> ():
    alloc_locals
    let (local _1_406 : Uint256) = cleanup_bytes32(value_404)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_407 : Uint256) = leftAlign_bytes32(_1_406)
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_405.low, value=_2_407)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_484 : Uint256, value0_485 : Uint256, value1_486 : Uint256, value2_487 : Uint256) -> (
        end_488 : Uint256):
    alloc_locals
    let (local pos_484 : Uint256) = abi_encode_stringliteral_8b1a(pos_484)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address_nonPadded_inplace(value0_485, pos_484)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_489 : Uint256 = Uint256(low=20, high=0)
    let (local pos_484 : Uint256) = u256_add(pos_484, _1_489)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32(value1_486, pos_484)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_490 : Uint256 = Uint256(low=32, high=0)
    let (local pos_484 : Uint256) = u256_add(pos_484, _2_490)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32(value2_487, pos_484)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_491 : Uint256 = _2_490
    let (local pos_484 : Uint256) = u256_add(pos_484, _2_490)
    local range_check_ptr = range_check_ptr
    local end_488 : Uint256 = pos_484
    return (end_488)
end

func convert_bytes32_to_bytes20{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_833 : Uint256) -> (converted_834 : Uint256):
    alloc_locals
    let (local converted_834 : Uint256) = cleanup_bytes32(value_833)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_834)
end

func shift_right_96_unsigned{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2020 : Uint256) -> (newValue_2021 : Uint256):
    alloc_locals
    local _1_2022 : Uint256 = Uint256(low=96, high=0)
    let (local newValue_2021 : Uint256) = uint256_shr(_1_2022, value_2020)
    local range_check_ptr = range_check_ptr
    return (newValue_2021)
end

func convert_bytes20_to_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_830 : Uint256) -> (converted_831 : Uint256):
    alloc_locals
    let (local _1_832 : Uint256) = shift_right_96_unsigned(value_830)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local converted_831 : Uint256) = convert_uint160_to_uint160(_1_832)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_831)
end

func convert_bytes20_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_828 : Uint256) -> (converted_829 : Uint256):
    alloc_locals
    let (local converted_829 : Uint256) = convert_bytes20_to_uint160(value_828)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_829)
end

func fun_computeAddress{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_factory : Uint256, var_key_mpos : Uint256) -> (var_pool : Uint256):
    alloc_locals
    local _1_943 : Uint256 = Uint256(low=0, high=0)
    let (local _2_944 : Uint256) = u256_add(var_key_mpos, _1_943)
    local range_check_ptr = range_check_ptr
    let (local _3_945 : Uint256) = read_from_memoryt_address(_2_944)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_946 : Uint256 = Uint256(low=32, high=0)
    let (local _5_947 : Uint256) = u256_add(var_key_mpos, _4_946)
    local range_check_ptr = range_check_ptr
    let (local _6_948 : Uint256) = read_from_memoryt_address(_5_947)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_949 : Uint256) = cleanup_address(_6_948)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_950 : Uint256) = cleanup_address(_3_945)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_951 : Uint256) = is_lt(_8_950, _7_949)
    local range_check_ptr = range_check_ptr
    require_helper(expr_951)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _9_952 : Uint256) = read_from_memoryt_address(_2_944)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_953 : Uint256) = read_from_memoryt_address(_5_947)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_954 : Uint256 = Uint256(low=64, high=0)
    let (local _12_955 : Uint256) = u256_add(var_key_mpos, _11_954)
    local range_check_ptr = range_check_ptr
    let (local _13_956 : Uint256) = read_from_memoryt_uint24(_12_955)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2626_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _14_957 : Uint256 = _4_946
    let (local _15_958 : Uint256) = u256_add(expr_2626_mpos, _4_946)
    local range_check_ptr = range_check_ptr
    let (local _16_959 : Uint256) = abi_encode_address_address_uint24(
        _15_958, _9_952, _10_953, _13_956)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_960 : Uint256) = uint256_sub(_16_959, _15_958)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_2626_mpos.low, value=_17_960)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _18_961 : Uint256) = uint256_sub(_16_959, expr_2626_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_2626_mpos, _18_961)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_962 : Uint256) = array_length_bytes(expr_2626_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _20_963 : Uint256) = array_dataslot_bytes(expr_2626_mpos)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_964 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _20_963.low, _19_962.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2_965 : Uint256) = constant_POOL_INIT_CODE_HASH()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2629_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _21_966 : Uint256 = _4_946
    let (local _22_967 : Uint256) = u256_add(expr_2629_mpos, _4_946)
    local range_check_ptr = range_check_ptr
    let (local _23_968 : Uint256) = abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32(
        _22_967, var_factory, expr_1_964, expr_2_965)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _24_969 : Uint256) = uint256_sub(_23_968, _22_967)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_2629_mpos.low, value=_24_969)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _25_970 : Uint256) = uint256_sub(_23_968, expr_2629_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_2629_mpos, _25_970)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _26_971 : Uint256) = array_length_bytes(expr_2629_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _27_972 : Uint256) = array_dataslot_bytes(expr_2629_mpos)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_3 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _27_972.low, _26_971.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_4 : Uint256) = convert_bytes32_to_bytes20(expr_3)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_5 : Uint256) = convert_bytes20_to_address(expr_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_pool : Uint256 = expr_5
    return (var_pool)
end

func convert_uint160_to_contract_IUniswapV3Pool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_898 : Uint256) -> (converted_899 : Uint256):
    alloc_locals
    let (local converted_899 : Uint256) = convert_uint160_to_uint160(value_898)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_899)
end

func convert_address_to_contract_IUniswapV3Pool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_824 : Uint256) -> (converted_825 : Uint256):
    alloc_locals
    let (local converted_825 : Uint256) = convert_uint160_to_contract_IUniswapV3Pool(value_824)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_825)
end

func fun_getPool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_tokenA_1216 : Uint256, var_tokenB_1217 : Uint256, var_fee_1218 : Uint256) -> (
        var_address : Uint256):
    alloc_locals
    let (local _1_1219 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2804_mpos : Uint256) = fun_getPoolKey(
        var_tokenA_1216, var_tokenB_1217, var_fee_1218)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_1220 : Uint256) = fun_computeAddress(_1_1219, expr_2804_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2806_address : Uint256) = convert_address_to_contract_IUniswapV3Pool(expr_1220)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_address : Uint256 = expr_2806_address
    return (var_address)
end

func convert_contract_IUniswapV3Pool_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_841 : Uint256) -> (converted_842 : Uint256):
    alloc_locals
    let (local converted_842 : Uint256) = convert_uint160_to_address(value_841)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_842)
end

func convert_t_rational_by_to_t_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_886 : Uint256) -> (converted_887 : Uint256):
    alloc_locals
    let (local converted_887 : Uint256) = cleanup_uint256(value_886)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_887)
end

func cleanup_int256(value_774 : Uint256) -> (cleaned_775 : Uint256):
    alloc_locals
    local cleaned_775 : Uint256 = value_774
    return (cleaned_775)
end

func convert_uint256_to_int256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_904 : Uint256) -> (converted_905 : Uint256):
    alloc_locals
    let (local converted_905 : Uint256) = cleanup_int256(value_904)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_905)
end

func fun_toInt256{exec_env : ExecutionEnvironment, range_check_ptr}(var_y_1629 : Uint256) -> (
        var_z_1630 : Uint256):
    alloc_locals
    let (local expr_1631 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1632 : Uint256) = convert_t_rational_by_to_t_uint256(expr_1631)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1633 : Uint256) = cleanup_uint256(var_y_1629)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1634 : Uint256) = is_lt(_2_1633, _1_1632)
    local range_check_ptr = range_check_ptr
    require_helper(expr_1_1634)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1635 : Uint256) = convert_uint256_to_int256(var_y_1629)
    local exec_env : ExecutionEnvironment = exec_env
    local var_z_1630 : Uint256 = expr_2_1635
    return (var_z_1630)
end

func convert_rational_by_to_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_872 : Uint256) -> (converted_873 : Uint256):
    alloc_locals
    let (local converted_873 : Uint256) = cleanup_uint160(value_872)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_873)
end

func constant_MAX_SQRT_RATIO{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_796 : Uint256):
    alloc_locals
    local expr_797 : Uint256 = Uint256(low=318775800626314356294205765087544249638, high=4294805859)
    let (local _1_798 : Uint256) = convert_rational_by_to_uint160(expr_797)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_796 : Uint256 = _1_798
    return (ret_796)
end

func convert_t_rational_by_to_t_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_874 : Uint256) -> (converted_875 : Uint256):
    alloc_locals
    let (local converted_875 : Uint256) = cleanup_uint160(value_874)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_875)
end

func checked_sub_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_761 : Uint256, y_762 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local x_761 : Uint256) = cleanup_uint160(x_761)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local y_762 : Uint256) = cleanup_uint160(y_762)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_763 : Uint256) = is_lt(x_761, y_762)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_763)
    local exec_env : ExecutionEnvironment = exec_env
    let (local diff : Uint256) = uint256_sub(x_761, y_762)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func convert_rational_4295128739_by_1_to_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_884 : Uint256) -> (converted_885 : Uint256):
    alloc_locals
    let (local converted_885 : Uint256) = cleanup_uint160(value_884)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_885)
end

func constant_MIN_SQRT_RATIO{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_799 : Uint256):
    alloc_locals
    local expr_800 : Uint256 = Uint256(low=4295128739, high=0)
    let (local _1_801 : Uint256) = convert_rational_4295128739_by_1_to_uint160(expr_800)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_799 : Uint256 = _1_801
    return (ret_799)
end

func checked_add_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local x : Uint256) = cleanup_uint160(x)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local y : Uint256) = cleanup_uint160(y)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_741 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_742 : Uint256) = uint256_sub(_1_741, y)
    local range_check_ptr = range_check_ptr
    let (local _3_743 : Uint256) = is_gt(x, _2_742)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_743)
    local exec_env : ExecutionEnvironment = exec_env
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func array_storeLengthForEncoding_bytes_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_715 : Uint256, length_716 : Uint256) -> (updated_pos_717 : Uint256):
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_715.low, value=length_716)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_718 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos_717 : Uint256) = u256_add(pos_715, _1_718)
    local range_check_ptr = range_check_ptr
    return (updated_pos_717)
end

func __warp_loop_body_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_912 : Uint256, i_914 : Uint256, src_911 : Uint256) -> (i_914 : Uint256):
    alloc_locals
    let (local _2_916 : Uint256) = u256_add(src_911, i_914)
    local range_check_ptr = range_check_ptr
    let (local _3_917 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_2_916.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _4_918 : Uint256) = u256_add(dst_912, i_914)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_4_918.low, value=_3_917)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_915 : Uint256 = Uint256(low=32, high=0)
    let (local i_914 : Uint256) = u256_add(i_914, _1_915)
    local range_check_ptr = range_check_ptr
    return (i_914)
end

func __warp_loop_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_912 : Uint256, i_914 : Uint256, src_911 : Uint256) -> (i_914 : Uint256):
    alloc_locals
    let (local i_914 : Uint256) = __warp_loop_body_1(dst_912, i_914, src_911)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local i_914 : Uint256) = __warp_loop_1(dst_912, i_914, src_911)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_914)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_912 : Uint256, length_913 : Uint256) -> ():
    alloc_locals
    local _6_920 : Uint256 = Uint256(low=0, high=0)
    let (local _7_921 : Uint256) = u256_add(dst_912, length_913)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_7_921.low, value=_6_920)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_919 : Uint256, dst_912 : Uint256, length_913 : Uint256) -> ():
    alloc_locals
    if _5_919.low + _5_919.high != 0:
        __warp_block_1(dst_912, length_913)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return ()
    else:
        return ()
    end
end

func copy_memory_to_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src_911 : Uint256, dst_912 : Uint256, length_913 : Uint256) -> ():
    alloc_locals
    local i_914 : Uint256 = Uint256(low=0, high=0)
    let (local i_914 : Uint256) = __warp_loop_1(dst_912, i_914, src_911)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_919 : Uint256) = is_gt(i_914, length_913)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_5_919, dst_912, length_913)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_411 : Uint256, pos_412 : Uint256) -> (end_413 : Uint256):
    alloc_locals
    let (local length_414 : Uint256) = array_length_bytes(value_411)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local pos_412 : Uint256) = array_storeLengthForEncoding_bytes_memory_ptr(
        pos_412, length_414)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_415 : Uint256 = Uint256(low=32, high=0)
    let (local _2_416 : Uint256) = u256_add(value_411, _1_415)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_416, pos_412, length_414)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_417 : Uint256) = round_up_to_mul_of(length_414)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local end_413 : Uint256) = u256_add(pos_412, _3_417)
    local range_check_ptr = range_check_ptr
    return (end_413)
end

func abi_encode_address_to_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_378 : Uint256, pos_379 : Uint256) -> ():
    alloc_locals
    let (local _1_380 : Uint256) = cleanup_address(value_378)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_379.low, value=_1_380)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_struct_SwapCallbackData{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_439 : Uint256, pos_440 : Uint256) -> (end_441 : Uint256):
    alloc_locals
    local _1_442 : Uint256 = Uint256(low=64, high=0)
    let (local tail_443 : Uint256) = u256_add(pos_440, _1_442)
    local range_check_ptr = range_check_ptr
    local _2_444 : Uint256 = Uint256(low=0, high=0)
    let (local _3_445 : Uint256) = u256_add(value_439, _2_444)
    local range_check_ptr = range_check_ptr
    let (local memberValue0 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_3_445.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _4_446 : Uint256) = uint256_sub(tail_443, pos_440)
    local range_check_ptr = range_check_ptr
    local _5_447 : Uint256 = _2_444
    let (local _6_448 : Uint256) = u256_add(pos_440, _2_444)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_448.low, value=_4_446)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tail_443 : Uint256) = abi_encode_bytes_memory_ptr(memberValue0, tail_443)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _7_449 : Uint256 = Uint256(low=32, high=0)
    let (local _8_450 : Uint256) = u256_add(value_439, _7_449)
    local range_check_ptr = range_check_ptr
    let (local memberValue0_1 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_450.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _9_451 : Uint256 = _7_449
    let (local _10_452 : Uint256) = u256_add(pos_440, _7_449)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(memberValue0_1, _10_452)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local end_441 : Uint256 = tail_443
    return (end_441)
end

func abi_encode_struct_SwapCallbackData_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_622 : Uint256, value0_623 : Uint256) -> (tail_624 : Uint256):
    alloc_locals
    local _1_625 : Uint256 = Uint256(low=32, high=0)
    let (local tail_624 : Uint256) = u256_add(headStart_622, _1_625)
    local range_check_ptr = range_check_ptr
    let (local _2_626 : Uint256) = uint256_sub(tail_624, headStart_622)
    local range_check_ptr = range_check_ptr
    local _3_627 : Uint256 = Uint256(low=0, high=0)
    let (local _4_628 : Uint256) = u256_add(headStart_622, _3_627)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_4_628.low, value=_2_626)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tail_624 : Uint256) = abi_encode_struct_SwapCallbackData(value0_623, tail_624)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_624)
end

func shift_left_224{exec_env : ExecutionEnvironment, range_check_ptr}(value_2008 : Uint256) -> (
        newValue_2009 : Uint256):
    alloc_locals
    local _1_2010 : Uint256 = Uint256(low=224, high=0)
    let (local newValue_2009 : Uint256) = uint256_shl(_1_2010, value_2008)
    local range_check_ptr = range_check_ptr
    return (newValue_2009)
end

func cleanup_bool{exec_env : ExecutionEnvironment, range_check_ptr}(value_769 : Uint256) -> (
        cleaned_770 : Uint256):
    alloc_locals
    let (local _1_771 : Uint256) = is_zero(value_769)
    local range_check_ptr = range_check_ptr
    let (local cleaned_770 : Uint256) = is_zero(_1_771)
    local range_check_ptr = range_check_ptr
    return (cleaned_770)
end

func abi_encode_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_398 : Uint256, pos_399 : Uint256) -> ():
    alloc_locals
    let (local _1_400 : Uint256) = cleanup_bool(value_398)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_399.low, value=_1_400)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_int256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_425 : Uint256, pos_426 : Uint256) -> ():
    alloc_locals
    let (local _1_427 : Uint256) = cleanup_int256(value_425)
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_426.low, value=_1_427)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint160{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_453 : Uint256, pos_454 : Uint256) -> ():
    alloc_locals
    let (local _1_455 : Uint256) = cleanup_uint160(value_453)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_454.low, value=_1_455)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func array_storeLengthForEncoding_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_719 : Uint256, length_720 : Uint256) -> (updated_pos_721 : Uint256):
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_719.low, value=length_720)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_722 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos_721 : Uint256) = u256_add(pos_719, _1_722)
    local range_check_ptr = range_check_ptr
    return (updated_pos_721)
end

func abi_encode_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_418 : Uint256, pos_419 : Uint256) -> (end_420 : Uint256):
    alloc_locals
    let (local length_421 : Uint256) = array_length_bytes(value_418)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local pos_419 : Uint256) = array_storeLengthForEncoding_bytes(pos_419, length_421)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_422 : Uint256 = Uint256(low=32, high=0)
    let (local _2_423 : Uint256) = u256_add(value_418, _1_422)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_423, pos_419, length_421)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_424 : Uint256) = round_up_to_mul_of(length_421)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local end_420 : Uint256) = u256_add(pos_419, _3_424)
    local range_check_ptr = range_check_ptr
    return (end_420)
end

func abi_encode_address_bool_int256_uint160_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_580 : Uint256, value0_581 : Uint256, value1_582 : Uint256, value2_583 : Uint256,
        value3_584 : Uint256, value4_585 : Uint256) -> (tail_586 : Uint256):
    alloc_locals
    local _1_587 : Uint256 = Uint256(low=160, high=0)
    let (local tail_586 : Uint256) = u256_add(headStart_580, _1_587)
    local range_check_ptr = range_check_ptr
    local _2_588 : Uint256 = Uint256(low=0, high=0)
    let (local _3_589 : Uint256) = u256_add(headStart_580, _2_588)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_581, _3_589)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_590 : Uint256 = Uint256(low=32, high=0)
    let (local _5_591 : Uint256) = u256_add(headStart_580, _4_590)
    local range_check_ptr = range_check_ptr
    abi_encode_bool(value1_582, _5_591)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_592 : Uint256 = Uint256(low=64, high=0)
    let (local _7_593 : Uint256) = u256_add(headStart_580, _6_592)
    local range_check_ptr = range_check_ptr
    abi_encode_int256(value2_583, _7_593)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_594 : Uint256 = Uint256(low=96, high=0)
    let (local _9_595 : Uint256) = u256_add(headStart_580, _8_594)
    local range_check_ptr = range_check_ptr
    abi_encode_uint160(value3_584, _9_595)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_596 : Uint256) = uint256_sub(tail_586, headStart_580)
    local range_check_ptr = range_check_ptr
    local _11_597 : Uint256 = Uint256(low=128, high=0)
    let (local _12_598 : Uint256) = u256_add(headStart_580, _11_597)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_598.low, value=_10_596)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tail_586 : Uint256) = abi_encode_bytes(value4_585, tail_586)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_586)
end

func validator_revert_int256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2045 : Uint256) -> ():
    alloc_locals
    let (local _1_2046 : Uint256) = cleanup_int256(value_2045)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2047 : Uint256) = is_eq(value_2045, _1_2046)
    local range_check_ptr = range_check_ptr
    let (local _3_2048 : Uint256) = is_zero(_2_2047)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2048)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_int256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_63 : Uint256, end_64 : Uint256) -> (value_65 : Uint256):
    alloc_locals
    let (local value_65 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset_63.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    validator_revert_int256(value_65)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_65)
end

func abi_decode_int256t_int256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_247 : Uint256, dataEnd_248 : Uint256) -> (
        value0_249 : Uint256, value1_250 : Uint256):
    alloc_locals
    local _1_251 : Uint256 = Uint256(low=64, high=0)
    let (local _2_252 : Uint256) = uint256_sub(dataEnd_248, headStart_247)
    local range_check_ptr = range_check_ptr
    let (local _3_253 : Uint256) = slt(_2_252, _1_251)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_253)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_254 : Uint256 = Uint256(low=0, high=0)
    let (local _4_255 : Uint256) = u256_add(headStart_247, offset_254)
    local range_check_ptr = range_check_ptr
    let (local value0_249 : Uint256) = abi_decode_int256_fromMemory(_4_255, dataEnd_248)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local offset_1_256 : Uint256 = Uint256(low=32, high=0)
    let (local _5_257 : Uint256) = u256_add(headStart_247, offset_1_256)
    local range_check_ptr = range_check_ptr
    let (local value1_250 : Uint256) = abi_decode_int256_fromMemory(_5_257, dataEnd_248)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_249, value1_250)
end

func negate_int256{exec_env : ExecutionEnvironment, range_check_ptr}(value_1885 : Uint256) -> (
        ret_1886 : Uint256):
    alloc_locals
    let (local value_1885 : Uint256) = cleanup_int256(value_1885)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_1887 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1888 : Uint256) = is_eq(value_1885, _1_1887)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_1888)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_1889 : Uint256 = Uint256(low=0, high=0)
    let (local ret_1886 : Uint256) = uint256_sub(_3_1889, value_1885)
    local range_check_ptr = range_check_ptr
    return (ret_1886)
end

func convert_int256_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_855 : Uint256) -> (converted_856 : Uint256):
    alloc_locals
    let (local converted_856 : Uint256) = cleanup_uint256(value_855)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_856)
end

func __warp_block_2{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        var_recipient : Uint256):
    alloc_locals
    let (local expr_2967_address : Uint256) = __warp_holder()
    let (local expr_3_985 : Uint256) = convert_contract_SwapRouter_to_address(expr_2967_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_recipient : Uint256 = expr_3_985
    return (var_recipient)
end

func __warp_if_2{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_984 : Uint256, var_recipient : Uint256) -> (var_recipient : Uint256):
    alloc_locals
    if expr_2_984.low + expr_2_984.high != 0:
        let (local var_recipient : Uint256) = __warp_block_2()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (var_recipient)
    else:
        return (var_recipient)
    end
end

func __warp_block_8{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_9 : Uint256):
    alloc_locals
    let (local expr_10 : Uint256) = constant_MAX_SQRT_RATIO()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_11 : Uint256 = Uint256(low=1, high=0)
    let (local _9_994 : Uint256) = convert_t_rational_by_to_t_uint160(expr_11)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_12 : Uint256) = checked_sub_uint160(expr_10, _9_994)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_9 : Uint256 = expr_12
    return (expr_9)
end

func __warp_block_9{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_9 : Uint256):
    alloc_locals
    let (local expr_13 : Uint256) = constant_MIN_SQRT_RATIO()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_14 : Uint256 = Uint256(low=1, high=0)
    let (local _10_995 : Uint256) = convert_t_rational_by_to_t_uint160(expr_14)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_15 : Uint256) = checked_add_uint160(expr_13, _10_995)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_9 : Uint256 = expr_15
    return (expr_9)
end

func __warp_if_4{exec_env : ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        expr_9 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_9 : Uint256) = __warp_block_8()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_9)
    else:
        let (local expr_9 : Uint256) = __warp_block_9()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_9)
    end
end

func __warp_block_7{exec_env : ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (
        expr_9 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_9 : Uint256) = __warp_if_4(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_9)
end

func __warp_block_6{exec_env : ExecutionEnvironment, range_check_ptr}(expr_5_991 : Uint256) -> (
        expr_9 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_5_991
    let (local expr_9 : Uint256) = __warp_block_7(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_9)
end

func __warp_block_5{exec_env : ExecutionEnvironment, range_check_ptr}(expr_5_991 : Uint256) -> (
        expr_8 : Uint256):
    alloc_locals
    local expr_9 : Uint256 = Uint256(low=0, high=0)
    let (local expr_9 : Uint256) = __warp_block_6(expr_5_991)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_8 : Uint256 = expr_9
    return (expr_8)
end

func __warp_if_3{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_5_991 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_8 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_8 : Uint256 = var_sqrtPriceLimitX96
        return (expr_8)
    else:
        let (local expr_8 : Uint256) = __warp_block_5(expr_5_991)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_8)
    end
end

func __warp_block_4{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_5_991 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_8 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_8 : Uint256) = __warp_if_3(__warp_subexpr_0, expr_5_991, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_8)
end

func __warp_block_3{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_5_991 : Uint256, expr_7 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_8 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_7
    let (local expr_8 : Uint256) = __warp_block_4(expr_5_991, match_var, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_8)
end

func __warp_block_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1001 : Uint256) -> (expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
    alloc_locals
    let (local _28_1011 : Uint256) = __warp_holder()
    finalize_allocation(_18_1001, _28_1011)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29_1012 : Uint256) = __warp_holder()
    let (local _30_1013 : Uint256) = u256_add(_18_1001, _29_1012)
    local range_check_ptr = range_check_ptr
    let (local expr_3034_component : Uint256,
        local expr_3034_component_1 : Uint256) = abi_decode_int256t_int256_fromMemory(
        _18_1001, _30_1013)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_3034_component, expr_3034_component_1)
end

func __warp_if_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1001 : Uint256, _26_1009 : Uint256, expr_3034_component : Uint256,
        expr_3034_component_1 : Uint256) -> (
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
    alloc_locals
    if _26_1009.low + _26_1009.high != 0:
        let (local expr_3034_component : Uint256,
            local expr_3034_component_1 : Uint256) = __warp_block_10(_18_1001)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_3034_component, expr_3034_component_1)
    else:
        return (expr_3034_component, expr_3034_component_1)
    end
end

func __warp_if_6(
        __warp_subexpr_0 : Uint256, expr_3034_component : Uint256,
        expr_3034_component_1 : Uint256) -> (expr_16 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_16 : Uint256 = expr_3034_component
        return (expr_16)
    else:
        local expr_16 : Uint256 = expr_3034_component_1
        return (expr_16)
    end
end

func __warp_block_12{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256, match_var : Uint256) -> (
        expr_16 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_16 : Uint256) = __warp_if_6(
        __warp_subexpr_0, expr_3034_component, expr_3034_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    return (expr_16)
end

func __warp_block_11{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256, expr_5_991 : Uint256) -> (
        expr_16 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_5_991
    let (local expr_16 : Uint256) = __warp_block_12(
        expr_3034_component, expr_3034_component_1, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_16)
end

func fun_exactInputInternal{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_amountIn : Uint256, var_recipient : Uint256, var_sqrtPriceLimitX96 : Uint256,
        var_data_2953_mpos : Uint256) -> (var_amountOut : Uint256):
    alloc_locals
    local expr_980 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_981 : Uint256) = convert_rational_by_to_address(expr_980)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_982 : Uint256) = cleanup_address(expr_1_981)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_983 : Uint256) = cleanup_address(var_recipient)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_984 : Uint256) = is_eq(_2_983, _1_982)
    local range_check_ptr = range_check_ptr
    let (local var_recipient : Uint256) = __warp_if_2(expr_2_984, var_recipient)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    setter_fun_balancePeople(var_recipient, var_amountIn)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local expr_4_986 : Uint256 = Uint256(low=21, high=0)
    let (local _3_987 : Uint256) = convert_rational_21_by_1_to_uint256(expr_4_986)
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_age(_3_987)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_988 : Uint256) = u256_add(var_data_2953_mpos, expr_980)
    local range_check_ptr = range_check_ptr
    let (local _342_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_988.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2991_component : Uint256, local expr_2991_component_1 : Uint256,
        local expr_2991_component_2 : Uint256) = fun_decodeFirstPool(_342_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_989 : Uint256) = cleanup_address(expr_2991_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_990 : Uint256) = cleanup_address(expr_2991_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_5_991 : Uint256) = is_lt(_6_990, _5_989)
    local range_check_ptr = range_check_ptr
    let (local expr_3007_address : Uint256) = fun_getPool(
        expr_2991_component, expr_2991_component_1, expr_2991_component_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_3008_address : Uint256) = convert_contract_IUniswapV3Pool_to_address(
        expr_3007_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_3008_functionSelector : Uint256 = Uint256(low=1884727471, high=0)
    let (local expr_6 : Uint256) = fun_toInt256(var_amountIn)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _7_992 : Uint256) = convert_rational_0_by_1_to_uint160(expr_980)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_993 : Uint256) = cleanup_uint160(var_sqrtPriceLimitX96)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_7 : Uint256) = is_eq(_8_993, _7_992)
    local range_check_ptr = range_check_ptr
    local expr_8 : Uint256 = Uint256(low=0, high=0)
    let (local expr_8 : Uint256) = __warp_block_3(expr_5_991, expr_7, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3033_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _11_996 : Uint256 = Uint256(low=32, high=0)
    let (local _12_997 : Uint256) = u256_add(expr_3033_mpos, _11_996)
    local range_check_ptr = range_check_ptr
    let (local _13_998 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(
        _12_997, var_data_2953_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_999 : Uint256) = uint256_sub(_13_998, _12_997)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_3033_mpos.low, value=_14_999)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _15_1000 : Uint256) = uint256_sub(_13_998, expr_3033_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3033_mpos, _15_1000)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1001 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _19_1002 : Uint256) = shift_left_224(expr_3008_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_18_1001.low, value=_19_1002)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _20_1003 : Uint256 = Uint256(low=4, high=0)
    let (local _21_1004 : Uint256) = u256_add(_18_1001, _20_1003)
    local range_check_ptr = range_check_ptr
    let (local _22_1005 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(
        _21_1004, var_recipient, expr_5_991, expr_6, expr_8, expr_3033_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _23_1006 : Uint256 = Uint256(low=64, high=0)
    let (local _24_1007 : Uint256) = uint256_sub(_22_1005, _18_1001)
    local range_check_ptr = range_check_ptr
    let (local _25_1008 : Uint256) = __warp_holder()
    let (local _26_1009 : Uint256) = __warp_holder()
    let (local _27_1010 : Uint256) = is_zero(_26_1009)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_27_1010)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3034_component : Uint256 = Uint256(low=0, high=0)
    local expr_3034_component_1 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3034_component : Uint256, local expr_3034_component_1 : Uint256) = __warp_if_5(
        _18_1001, _26_1009, expr_3034_component, expr_3034_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_16 : Uint256 = Uint256(low=0, high=0)
    let (local expr_16 : Uint256) = __warp_block_11(
        expr_3034_component, expr_3034_component_1, expr_5_991)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_17 : Uint256) = negate_int256(expr_16)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_18 : Uint256) = convert_int256_to_uint256(expr_17)
    local exec_env : ExecutionEnvironment = exec_env
    local var_amountOut : Uint256 = expr_18
    return (var_amountOut)
end

func fun_exactInputSingle_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1015 : Uint256, var_params_offset : Uint256) -> (var_amountOut_1016 : Uint256):
    alloc_locals
    local _2_1017 : Uint256 = Uint256(low=160, high=0)
    let (local _3_1018 : Uint256) = u256_add(var_params_offset, _2_1017)
    local range_check_ptr = range_check_ptr
    let (local expr_1019 : Uint256) = read_from_calldatat_uint256(_3_1018)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_1020 : Uint256 = Uint256(low=96, high=0)
    let (local _5_1021 : Uint256) = u256_add(var_params_offset, _4_1020)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1022 : Uint256) = read_from_calldatat_address(_5_1021)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_1023 : Uint256 = Uint256(low=224, high=0)
    let (local _7_1024 : Uint256) = u256_add(var_params_offset, _6_1023)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1025 : Uint256) = read_from_calldatat_uint160(_7_1024)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _8_1026 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1027 : Uint256) = u256_add(var_params_offset, _8_1026)
    local range_check_ptr = range_check_ptr
    let (local expr_3_1028 : Uint256) = read_from_calldatat_address(_9_1027)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _10_1029 : Uint256 = Uint256(low=64, high=0)
    let (local _11_1030 : Uint256) = u256_add(var_params_offset, _10_1029)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1031 : Uint256) = read_from_calldatat_uint24(_11_1030)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _12_1032 : Uint256 = Uint256(low=32, high=0)
    let (local _13_1033 : Uint256) = u256_add(var_params_offset, _12_1032)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1034 : Uint256) = read_from_calldatat_address(_13_1033)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3077_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _14_1035 : Uint256 = _12_1032
    let (local _15_1036 : Uint256) = u256_add(expr_3077_mpos, _12_1032)
    local range_check_ptr = range_check_ptr
    let (local _16_1037 : Uint256) = abi_encode_packed_address_uint24_address(
        _15_1036, expr_3_1028, expr_4_1031, expr_5_1034)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_1038 : Uint256) = uint256_sub(_16_1037, _15_1036)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_3077_mpos.low, value=_17_1038)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _18_1039 : Uint256) = uint256_sub(_16_1037, expr_3077_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3077_mpos, _18_1039)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_6_1040 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (
        local expr_3080_mpos : Uint256) = allocate_memory_struct_struct_SwapCallbackData_storage_ptr(
        )
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _19_1041 : Uint256 = _8_1026
    let (local _20_1042 : Uint256) = u256_add(expr_3080_mpos, _8_1026)
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(_20_1042, expr_3077_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _21_1043 : Uint256 = _12_1032
    let (local _22_1044 : Uint256) = u256_add(expr_3080_mpos, _12_1032)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_22_1044, expr_6_1040)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_7_1045 : Uint256) = fun_exactInputInternal(
        expr_1019, expr_1_1022, expr_2_1025, expr_3080_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_amountOut_1016 : Uint256 = expr_7_1045
    local _23_1046 : Uint256 = Uint256(low=192, high=0)
    let (local _24_1047 : Uint256) = u256_add(var_params_offset, _23_1046)
    local range_check_ptr = range_check_ptr
    let (local expr_8_1048 : Uint256) = read_from_calldatat_uint256(_24_1047)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1049 : Uint256) = cleanup_uint256(expr_8_1048)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_1050 : Uint256) = cleanup_uint256(expr_7_1045)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _27_1051 : Uint256) = is_lt(_26_1050, _25_1049)
    local range_check_ptr = range_check_ptr
    let (local expr_9_1052 : Uint256) = is_zero(_27_1051)
    local range_check_ptr = range_check_ptr
    require_helper(expr_9_1052)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountOut_1016)
end

func modifier_checkDeadline_3056{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amountOut_1841 : Uint256, var_params_offset_1842 : Uint256) -> (_1_1843 : Uint256):
    alloc_locals
    local _2_1844 : Uint256 = Uint256(low=128, high=0)
    let (local _3_1845 : Uint256) = u256_add(var_params_offset_1842, _2_1844)
    local range_check_ptr = range_check_ptr
    let (local expr_1846 : Uint256) = read_from_calldatat_uint256(_3_1845)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1847 : Uint256) = fun_blockTimestamp()
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1848 : Uint256) = cleanup_uint256(expr_1846)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1849 : Uint256) = cleanup_uint256(expr_1_1847)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1850 : Uint256) = is_gt(_5_1849, _4_1848)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1851 : Uint256) = is_zero(_6_1850)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1851)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1843 : Uint256) = fun_exactInputSingle_dynArgs_inner(
        var_amountOut_1841, var_params_offset_1842)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1843)
end

func fun_exactInputSingle_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3050_offset : Uint256) -> (var_amountOut_1014 : Uint256):
    alloc_locals
    let (local zero_uint256 : Uint256) = zero_value_for_split_uint256()
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountOut_1014 : Uint256) = modifier_checkDeadline_3056(
        zero_uint256, var_params_3050_offset)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountOut_1014)
end

func abi_encode_uint256_to_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_463 : Uint256, pos_464 : Uint256) -> ():
    alloc_locals
    let (local _1_465 : Uint256) = cleanup_uint256(value_463)
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_464.low, value=_1_465)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_629 : Uint256, value0_630 : Uint256) -> (tail_631 : Uint256):
    alloc_locals
    local _1_632 : Uint256 = Uint256(low=32, high=0)
    let (local tail_631 : Uint256) = u256_add(headStart_629, _1_632)
    local range_check_ptr = range_check_ptr
    local _2_633 : Uint256 = Uint256(low=0, high=0)
    let (local _3_634 : Uint256) = u256_add(headStart_629, _2_633)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_630, _3_634)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_631)
end

func abi_decode_struct_ExactOutputSingleParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_115 : Uint256, end_116 : Uint256) -> (value_117 : Uint256):
    alloc_locals
    local _1_118 : Uint256 = Uint256(low=256, high=0)
    let (local _2_119 : Uint256) = uint256_sub(end_116, offset_115)
    local range_check_ptr = range_check_ptr
    let (local _3_120 : Uint256) = slt(_2_119, _1_118)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_120)
    local exec_env : ExecutionEnvironment = exec_env
    local value_117 : Uint256 = offset_115
    return (value_117)
end

func abi_decode_struct_ExactOutputSingleParams_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_321 : Uint256, dataEnd_322 : Uint256) -> (value0_323 : Uint256):
    alloc_locals
    local _1_324 : Uint256 = Uint256(low=256, high=0)
    let (local _2_325 : Uint256) = uint256_sub(dataEnd_322, headStart_321)
    local range_check_ptr = range_check_ptr
    let (local _3_326 : Uint256) = slt(_2_325, _1_324)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_326)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_327 : Uint256 = Uint256(low=0, high=0)
    let (local _4_328 : Uint256) = u256_add(headStart_321, offset_327)
    local range_check_ptr = range_check_ptr
    let (local value0_323 : Uint256) = abi_decode_struct_ExactOutputSingleParams_calldata_ptr(
        _4_328, dataEnd_322)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_323)
end

func __warp_block_13{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        var_recipient_1088 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = __warp_holder()
    let (local expr_1_1094 : Uint256) = convert_contract_SwapRouter_to_address(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_recipient_1088 : Uint256 = expr_1_1094
    return (var_recipient_1088)
end

func __warp_if_7{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, var_recipient_1088 : Uint256) -> (var_recipient_1088 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_recipient_1088 : Uint256) = __warp_block_13()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (var_recipient_1088)
    else:
        return (var_recipient_1088)
    end
end

func __warp_block_19{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_7_1104 : Uint256):
    alloc_locals
    let (local expr_8_1105 : Uint256) = constant_MAX_SQRT_RATIO()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _7_1106 : Uint256) = convert_t_rational_by_to_t_uint160(Uint256(low=1, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_9_1107 : Uint256) = checked_sub_uint160(expr_8_1105, _7_1106)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_7_1104 : Uint256 = expr_9_1107
    return (expr_7_1104)
end

func __warp_block_20{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_7_1104 : Uint256):
    alloc_locals
    let (local expr_10_1108 : Uint256) = constant_MIN_SQRT_RATIO()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_1109 : Uint256) = convert_t_rational_by_to_t_uint160(Uint256(low=1, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_11_1110 : Uint256) = checked_add_uint160(expr_10_1108, _8_1109)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_7_1104 : Uint256 = expr_11_1110
    return (expr_7_1104)
end

func __warp_if_9{exec_env : ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        expr_7_1104 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_7_1104 : Uint256) = __warp_block_19()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_7_1104)
    else:
        let (local expr_7_1104 : Uint256) = __warp_block_20()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_7_1104)
    end
end

func __warp_block_18{exec_env : ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (
        expr_7_1104 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_7_1104 : Uint256) = __warp_if_9(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_7_1104)
end

func __warp_block_17{exec_env : ExecutionEnvironment, range_check_ptr}(expr_2_1097 : Uint256) -> (
        expr_7_1104 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_2_1097
    let (local expr_7_1104 : Uint256) = __warp_block_18(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_7_1104)
end

func __warp_block_16{exec_env : ExecutionEnvironment, range_check_ptr}(expr_2_1097 : Uint256) -> (
        expr_6_1103 : Uint256):
    alloc_locals
    local expr_7_1104 : Uint256 = Uint256(low=0, high=0)
    let (local expr_7_1104 : Uint256) = __warp_block_17(expr_2_1097)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_6_1103 : Uint256 = expr_7_1104
    return (expr_6_1103)
end

func __warp_if_8{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_2_1097 : Uint256,
        var_sqrtPriceLimitX96_1089 : Uint256) -> (expr_6_1103 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_6_1103 : Uint256 = var_sqrtPriceLimitX96_1089
        return (expr_6_1103)
    else:
        let (local expr_6_1103 : Uint256) = __warp_block_16(expr_2_1097)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_6_1103)
    end
end

func __warp_block_15{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_1097 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96_1089 : Uint256) -> (
        expr_6_1103 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_6_1103 : Uint256) = __warp_if_8(
        __warp_subexpr_0, expr_2_1097, var_sqrtPriceLimitX96_1089)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_6_1103)
end

func __warp_block_14{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_1097 : Uint256, expr_5_1102 : Uint256, var_sqrtPriceLimitX96_1089 : Uint256) -> (
        expr_6_1103 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_5_1102
    let (local expr_6_1103 : Uint256) = __warp_block_15(
        expr_2_1097, match_var, var_sqrtPriceLimitX96_1089)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_6_1103)
end

func __warp_block_21{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1114 : Uint256) -> (expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
    alloc_locals
    let (local _17_1119 : Uint256) = __warp_holder()
    finalize_allocation(_12_1114, _17_1119)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1120 : Uint256) = __warp_holder()
    let (local __warp_subexpr_0 : Uint256) = u256_add(_12_1114, _18_1120)
    local range_check_ptr = range_check_ptr
    let (local expr_3260_component : Uint256,
        local expr_3260_component_1 : Uint256) = abi_decode_int256t_int256_fromMemory(
        _12_1114, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_3260_component, expr_3260_component_1)
end

func __warp_if_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1114 : Uint256, _16_1118 : Uint256, expr_3260_component : Uint256,
        expr_3260_component_1 : Uint256) -> (
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
    alloc_locals
    if _16_1118.low + _16_1118.high != 0:
        let (local expr_3260_component : Uint256,
            local expr_3260_component_1 : Uint256) = __warp_block_21(_12_1114)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_3260_component, expr_3260_component_1)
    else:
        return (expr_3260_component, expr_3260_component_1)
    end
end

func __warp_block_24{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_1 : Uint256):
    alloc_locals
    let (local expr_12_1121 : Uint256) = convert_int256_to_uint256(expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_13_1122 : Uint256) = negate_int256(expr_3260_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_14_1123 : Uint256) = convert_int256_to_uint256(expr_13_1122)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3289_component : Uint256 = expr_12_1121
    local expr_component_1 : Uint256 = expr_14_1123
    return (expr_3289_component, expr_component_1)
end

func __warp_block_25{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_1 : Uint256):
    alloc_locals
    let (local expr_15_1124 : Uint256) = convert_int256_to_uint256(expr_3260_component)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_16_1125 : Uint256) = negate_int256(expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_17_1126 : Uint256) = convert_int256_to_uint256(expr_16_1125)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3289_component : Uint256 = expr_15_1124
    local expr_component_1 : Uint256 = expr_17_1126
    return (expr_3289_component, expr_component_1)
end

func __warp_if_11{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_3260_component : Uint256,
        expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_1 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_3289_component : Uint256,
            local expr_component_1 : Uint256) = __warp_block_24(
            expr_3260_component, expr_3260_component_1)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3289_component, expr_component_1)
    else:
        let (local expr_3289_component : Uint256,
            local expr_component_1 : Uint256) = __warp_block_25(
            expr_3260_component, expr_3260_component_1)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3289_component, expr_component_1)
    end
end

func __warp_block_23{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256, match_var : Uint256) -> (
        expr_3289_component : Uint256, expr_component_1 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_3289_component : Uint256, local expr_component_1 : Uint256) = __warp_if_11(
        __warp_subexpr_0, expr_3260_component, expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3289_component, expr_component_1)
end

func __warp_block_22{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_1097 : Uint256, expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_1 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_2_1097
    let (local expr_3289_component : Uint256, local expr_component_1 : Uint256) = __warp_block_23(
        expr_3260_component, expr_3260_component_1, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3289_component, expr_component_1)
end

func __warp_block_26{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_component_1 : Uint256, var_amountOut_1087 : Uint256) -> ():
    alloc_locals
    let (local _19_1127 : Uint256) = cleanup_uint256(var_amountOut_1087)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _20_1128 : Uint256) = cleanup_uint256(expr_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = is_eq(_20_1128, _19_1127)
    local range_check_ptr = range_check_ptr
    require_helper(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_12{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_5_1102 : Uint256, expr_component_1 : Uint256, var_amountOut_1087 : Uint256) -> ():
    alloc_locals
    if expr_5_1102.low + expr_5_1102.high != 0:
        __warp_block_26(expr_component_1, var_amountOut_1087)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func fun_exactOutputInternal{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_amountOut_1087 : Uint256, var_recipient_1088 : Uint256,
        var_sqrtPriceLimitX96_1089 : Uint256, var_data_mpos : Uint256) -> (
        var_amountIn_1090 : Uint256):
    alloc_locals
    let (local expr_1091 : Uint256) = convert_rational_by_to_address(Uint256(low=0, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1092 : Uint256) = cleanup_address(expr_1091)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1093 : Uint256) = cleanup_address(var_recipient_1088)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = is_eq(_2_1093, _1_1092)
    local range_check_ptr = range_check_ptr
    let (local var_recipient_1088 : Uint256) = __warp_if_7(__warp_subexpr_0, var_recipient_1088)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_1 : Uint256) = u256_add(var_data_mpos, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _420_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(__warp_subexpr_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_3216_component : Uint256, local expr_3216_component_1 : Uint256,
        local expr_component : Uint256) = fun_decodeFirstPool(_420_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_1095 : Uint256) = cleanup_address(expr_3216_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1096 : Uint256) = cleanup_address(expr_3216_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1097 : Uint256) = is_lt(_4_1096, _3_1095)
    local range_check_ptr = range_check_ptr
    let (local expr_3232_address : Uint256) = fun_getPool(
        expr_3216_component_1, expr_3216_component, expr_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_3233_address : Uint256) = convert_contract_IUniswapV3Pool_to_address(
        expr_3232_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1098 : Uint256) = fun_toInt256(var_amountOut_1087)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_4_1099 : Uint256) = negate_int256(expr_3_1098)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_1100 : Uint256) = convert_rational_0_by_1_to_uint160(Uint256(low=0, high=0))
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1101 : Uint256) = cleanup_uint160(var_sqrtPriceLimitX96_1089)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_5_1102 : Uint256) = is_eq(_6_1101, _5_1100)
    local range_check_ptr = range_check_ptr
    local expr_6_1103 : Uint256 = Uint256(low=0, high=0)
    let (local expr_6_1103 : Uint256) = __warp_block_14(
        expr_2_1097, expr_5_1102, var_sqrtPriceLimitX96_1089)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3259_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_1111 : Uint256) = u256_add(expr_3259_mpos, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    let (local _10_1112 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(
        _9_1111, var_data_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = uint256_sub(_10_1112, _9_1111)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_3259_mpos.low, value=__warp_subexpr_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local __warp_subexpr_3 : Uint256) = uint256_sub(_10_1112, expr_3259_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3259_mpos, __warp_subexpr_3)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _11_1113 : Uint256) = __warp_holder()
    let (local __warp_subexpr_4 : Uint256) = is_zero(_11_1113)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(__warp_subexpr_4)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _12_1114 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _13_1115 : Uint256) = shift_left_224(Uint256(low=1884727471, high=0))
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_1114.low, value=_13_1115)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local __warp_subexpr_5 : Uint256) = u256_add(_12_1114, Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    let (local _14_1116 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(
        __warp_subexpr_5,
        var_recipient_1088,
        expr_2_1097,
        expr_4_1099,
        expr_6_1103,
        expr_3259_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1117 : Uint256) = __warp_holder()
    let (local __warp_subexpr_6 : Uint256) = uint256_sub(_14_1116, _12_1114)
    local range_check_ptr = range_check_ptr
    let (local _16_1118 : Uint256) = __warp_holder()
    let (local __warp_subexpr_7 : Uint256) = is_zero(_16_1118)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(__warp_subexpr_7)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3260_component : Uint256 = Uint256(low=0, high=0)
    local expr_3260_component_1 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3260_component : Uint256, local expr_3260_component_1 : Uint256) = __warp_if_10(
        _12_1114, _16_1118, expr_3260_component, expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_3289_component : Uint256 = Uint256(low=0, high=0)
    local expr_component_1 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3289_component : Uint256, local expr_component_1 : Uint256) = __warp_block_22(
        expr_2_1097, expr_3260_component, expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_amountIn_1090 : Uint256 = expr_3289_component
    __warp_if_12(expr_5_1102, expr_component_1, var_amountOut_1087)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountIn_1090)
end

func constant_DEFAULT_AMOUNT_IN_CACHED{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_791 : Uint256):
    alloc_locals
    let (local expr_792 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    local ret_791 : Uint256 = expr_792
    return (ret_791)
end

func setter_fun_amountInCached{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1991 : Uint256) -> ():
    alloc_locals
    amountInCached.write(value_1991)
    return ()
end

func fun_exactOutputSingle_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1131 : Uint256, var_params_offset_1132 : Uint256) -> (var_amountIn_1133 : Uint256):
    alloc_locals
    local _2_1134 : Uint256 = Uint256(low=160, high=0)
    let (local _3_1135 : Uint256) = u256_add(var_params_offset_1132, _2_1134)
    local range_check_ptr = range_check_ptr
    let (local expr_1136 : Uint256) = read_from_calldatat_uint256(_3_1135)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_1137 : Uint256 = Uint256(low=96, high=0)
    let (local _5_1138 : Uint256) = u256_add(var_params_offset_1132, _4_1137)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1139 : Uint256) = read_from_calldatat_address(_5_1138)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_1140 : Uint256 = Uint256(low=224, high=0)
    let (local _7_1141 : Uint256) = u256_add(var_params_offset_1132, _6_1140)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1142 : Uint256) = read_from_calldatat_uint160(_7_1141)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _8_1143 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1144 : Uint256) = u256_add(var_params_offset_1132, _8_1143)
    local range_check_ptr = range_check_ptr
    let (local expr_3_1145 : Uint256) = read_from_calldatat_address(_9_1144)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _10_1146 : Uint256 = Uint256(low=64, high=0)
    let (local _11_1147 : Uint256) = u256_add(var_params_offset_1132, _10_1146)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1148 : Uint256) = read_from_calldatat_uint24(_11_1147)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _12_1149 : Uint256 = Uint256(low=0, high=0)
    let (local _13_1150 : Uint256) = u256_add(var_params_offset_1132, _12_1149)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1151 : Uint256) = read_from_calldatat_address(_13_1150)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _14_1152 : Uint256 = _8_1143
    let (local _15_1153 : Uint256) = u256_add(expr_mpos, _8_1143)
    local range_check_ptr = range_check_ptr
    let (local _16_1154 : Uint256) = abi_encode_packed_address_uint24_address(
        _15_1153, expr_3_1145, expr_4_1148, expr_5_1151)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_1155 : Uint256) = uint256_sub(_16_1154, _15_1153)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_mpos.low, value=_17_1155)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _18_1156 : Uint256) = uint256_sub(_16_1154, expr_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_mpos, _18_1156)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_6_1157 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (
        local expr_3336_mpos : Uint256) = allocate_memory_struct_struct_SwapCallbackData_storage_ptr(
        )
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _19_1158 : Uint256 = _12_1149
    let (local _20_1159 : Uint256) = u256_add(expr_3336_mpos, _12_1149)
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(_20_1159, expr_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _21_1160 : Uint256 = _8_1143
    let (local _22_1161 : Uint256) = u256_add(expr_3336_mpos, _8_1143)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_22_1161, expr_6_1157)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_7_1162 : Uint256) = fun_exactOutputInternal(
        expr_1136, expr_1_1139, expr_2_1142, expr_3336_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_amountIn_1133 : Uint256 = expr_7_1162
    local _23_1163 : Uint256 = Uint256(low=192, high=0)
    let (local _24_1164 : Uint256) = u256_add(var_params_offset_1132, _23_1163)
    local range_check_ptr = range_check_ptr
    let (local expr_8_1165 : Uint256) = read_from_calldatat_uint256(_24_1164)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1166 : Uint256) = cleanup_uint256(expr_8_1165)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_1167 : Uint256) = cleanup_uint256(expr_7_1162)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _27_1168 : Uint256) = is_gt(_26_1167, _25_1166)
    local range_check_ptr = range_check_ptr
    let (local expr_9_1169 : Uint256) = is_zero(_27_1168)
    local range_check_ptr = range_check_ptr
    require_helper(expr_9_1169)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_10_1170 : Uint256) = constant_DEFAULT_AMOUNT_IN_CACHED()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_amountInCached(expr_10_1170)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_amountIn_1133)
end

func modifier_checkDeadline_3312{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amountIn_1863 : Uint256, var_params_offset_1864 : Uint256) -> (_1_1865 : Uint256):
    alloc_locals
    local _2_1866 : Uint256 = Uint256(low=128, high=0)
    let (local _3_1867 : Uint256) = u256_add(var_params_offset_1864, _2_1866)
    local range_check_ptr = range_check_ptr
    let (local expr_1868 : Uint256) = read_from_calldatat_uint256(_3_1867)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1869 : Uint256) = fun_blockTimestamp()
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1870 : Uint256) = cleanup_uint256(expr_1868)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1871 : Uint256) = cleanup_uint256(expr_1_1869)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1872 : Uint256) = is_gt(_5_1871, _4_1870)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1873 : Uint256) = is_zero(_6_1872)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1873)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1865 : Uint256) = fun_exactOutputSingle_dynArgs_inner(
        var_amountIn_1863, var_params_offset_1864)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1865)
end

func fun_exactOutputSingle_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3306_offset : Uint256) -> (var_amountIn_1129 : Uint256):
    alloc_locals
    let (local zero_uint256_1130 : Uint256) = zero_value_for_split_uint256()
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountIn_1129 : Uint256) = modifier_checkDeadline_3312(
        zero_uint256_1130, var_params_3306_offset)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountIn_1129)
end

func abi_decode{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_150 : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_151 : Uint256 = Uint256(low=0, high=0)
    let (local _2_152 : Uint256) = uint256_sub(dataEnd, headStart_150)
    local range_check_ptr = range_check_ptr
    let (local _3_153 : Uint256) = slt(_2_152, _1_151)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_153)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func convert_contract_PeripheryPayments_to_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(value_849 : Uint256) -> (
        converted_850 : Uint256):
    alloc_locals
    let (local converted_850 : Uint256) = convert_uint160_to_address(value_849)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_850)
end

func array_allocation_size_bytes{exec_env : ExecutionEnvironment, range_check_ptr}(
        length_688 : Uint256) -> (size_689 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_690 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_691 : Uint256) = is_gt(length_688, _1_690)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_691)
    local exec_env : ExecutionEnvironment = exec_env
    let (local size_689 : Uint256) = round_up_to_mul_of(length_688)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _3_692 : Uint256 = Uint256(low=32, high=0)
    let (local size_689 : Uint256) = u256_add(size_689, _3_692)
    local range_check_ptr = range_check_ptr
    return (size_689)
end

func allocate_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_671 : Uint256) -> (memPtr_672 : Uint256):
    alloc_locals
    let (local allocSize_673 : Uint256) = array_allocation_size_bytes(length_671)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPtr_672 : Uint256) = allocate_memory(allocSize_673)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_672.low, value=length_671)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_672)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_2091 : Uint256, dataSizeInBytes_2092 : Uint256) -> ():
    alloc_locals
    local _1_2093 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        dataStart_2091, _1_2093, dataSizeInBytes_2092)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_655 : Uint256) -> (memPtr_656 : Uint256):
    alloc_locals
    let (local memPtr_656 : Uint256) = allocate_memory_array_bytes(length_655)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local dataStart_657 : Uint256 = memPtr_656
    let (local dataSize_658 : Uint256) = array_allocation_size_bytes(length_655)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _1_659 : Uint256 = Uint256(low=32, high=0)
    let (local dataStart_657 : Uint256) = u256_add(memPtr_656, _1_659)
    local range_check_ptr = range_check_ptr
    local _2_660 : Uint256 = _1_659
    let (local dataSize_658 : Uint256) = uint256_sub(dataSize_658, _1_659)
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(dataStart_657, dataSize_658)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_656)
end

func zero_value_for_split_bytes() -> (ret_2094 : Uint256):
    alloc_locals
    local ret_2094 : Uint256 = Uint256(low=96, high=0)
    return (ret_2094)
end

func __warp_block_29{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        data_922 : Uint256):
    alloc_locals
    let (local _2_924 : Uint256) = __warp_holder()
    let (local data_922 : Uint256) = allocate_memory_array_bytes(_2_924)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_925 : Uint256) = __warp_holder()
    local _4_926 : Uint256 = Uint256(low=0, high=0)
    local _5_927 : Uint256 = Uint256(low=32, high=0)
    let (local _6_928 : Uint256) = u256_add(data_922, _5_927)
    local range_check_ptr = range_check_ptr
    __warp_holder()
    return (data_922)
end

func __warp_if_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> (data_922 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local data_922 : Uint256) = zero_value_for_split_bytes()
        local exec_env : ExecutionEnvironment = exec_env
        return (data_922)
    else:
        let (local data_922 : Uint256) = __warp_block_29()
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (data_922)
    end
end

func __warp_block_28{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256) -> (data_922 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local data_922 : Uint256) = __warp_if_13(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data_922)
end

func __warp_block_27{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_923 : Uint256) -> (data_922 : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_923
    let (local data_922 : Uint256) = __warp_block_28(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data_922)
end

func extract_returndata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        data_922 : Uint256):
    alloc_locals
    let (local _1_923 : Uint256) = __warp_holder()
    let (local data_922 : Uint256) = __warp_block_27(_1_923)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data_922)
end

func fun_safeTransferETH{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_to : Uint256, var_value_1329 : Uint256) -> ():
    alloc_locals
    local expr_1330 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1331 : Uint256) = convert_rational_0_by_1_to_uint256(expr_1330)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1562_mpos : Uint256) = allocate_and_zero_memory_array_bytes(_1_1331)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_1332 : Uint256 = Uint256(low=32, high=0)
    let (local _3_1333 : Uint256) = u256_add(expr_1562_mpos, _2_1332)
    local range_check_ptr = range_check_ptr
    let (local _4_1334 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1562_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_1335 : Uint256) = __warp_holder()
    let (local expr_component_1336 : Uint256) = __warp_holder()
    let (local _6_1337 : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    require_helper(expr_component_1336)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_30{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(expr_1321 : Uint256) -> ():
    alloc_locals
    let (local expr_4_1327 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_5_1328 : Uint256) = __warp_holder()
    fun_safeTransferETH(expr_4_1327, expr_5_1328)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_14{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(expr_1321 : Uint256, expr_3_1326 : Uint256) -> ():
    alloc_locals
    if expr_3_1326.low + expr_3_1326.high != 0:
        __warp_block_30(expr_1321)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func fun_refundETH{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local expr_1680_address : Uint256) = __warp_holder()
    let (local expr_1321 : Uint256) = convert_contract_PeripheryPayments_to_address(
        expr_1680_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1322 : Uint256) = __warp_holder()
    local expr_2_1323 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1324 : Uint256) = convert_rational_0_by_1_to_uint256(expr_2_1323)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1325 : Uint256) = cleanup_uint256(expr_1_1322)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_3_1326 : Uint256) = is_gt(_2_1325, _1_1324)
    local range_check_ptr = range_check_ptr
    __warp_if_14(expr_1321, expr_3_1326)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_encode_tuple{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_469 : Uint256) -> (tail_470 : Uint256):
    alloc_locals
    local _1_471 : Uint256 = Uint256(low=0, high=0)
    let (local tail_470 : Uint256) = u256_add(headStart_469, _1_471)
    local range_check_ptr = range_check_ptr
    return (tail_470)
end

func getter_fun_succinctly{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1817 : Uint256):
    alloc_locals
    let (res) = succinctly.read()
    return (res)
end

func abi_encode_tuple_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_492 : Uint256, value0_493 : Uint256) -> (tail_494 : Uint256):
    alloc_locals
    local _1_495 : Uint256 = Uint256(low=32, high=0)
    let (local tail_494 : Uint256) = u256_add(headStart_492, _1_495)
    local range_check_ptr = range_check_ptr
    local _2_496 : Uint256 = Uint256(low=0, high=0)
    let (local _3_497 : Uint256) = u256_add(headStart_492, _2_496)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_493, _3_497)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_494)
end

func getter_fun_age{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1805 : Uint256):
    alloc_locals
    let (res) = age.read()
    return (res)
end

func getter_fun_OCaml{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1799 : Uint256):
    alloc_locals
    let (res) = OCaml.read()
    return (res)
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset : Uint256, end_14 : Uint256) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        offset.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_address(value)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value)
end

func abi_decode_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_141 : Uint256, end_142 : Uint256) -> (value_143 : Uint256):
    alloc_locals
    let (local value_143 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_141.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint256(value_143)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_143)
end

func cleanup_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(value_786 : Uint256) -> (
        cleaned_787 : Uint256):
    alloc_locals
    local _1_788 : Uint256 = Uint256(low=255, high=0)
    let (local cleaned_787 : Uint256) = uint256_and(value_786, _1_788)
    local range_check_ptr = range_check_ptr
    return (cleaned_787)
end

func validator_revert_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2069 : Uint256) -> ():
    alloc_locals
    let (local _1_2070 : Uint256) = cleanup_uint8(value_2069)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2071 : Uint256) = is_eq(value_2069, _1_2070)
    local range_check_ptr = range_check_ptr
    let (local _3_2072 : Uint256) = is_zero(_2_2071)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2072)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_147 : Uint256, end_148 : Uint256) -> (value_149 : Uint256):
    alloc_locals
    let (local value_149 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_147.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_uint8(value_149)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_149)
end

func validator_revert_bytes32{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2039 : Uint256) -> ():
    alloc_locals
    let (local _1_2040 : Uint256) = cleanup_bytes32(value_2039)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2041 : Uint256) = is_eq(value_2039, _1_2040)
    local range_check_ptr = range_check_ptr
    let (local _3_2042 : Uint256) = is_zero(_2_2041)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2042)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_bytes32{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_32 : Uint256, end_33 : Uint256) -> (value_34 : Uint256):
    alloc_locals
    let (local value_34 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_32.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_bytes32(value_34)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_34)
end

func abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_205 : Uint256, dataEnd_206 : Uint256) -> (
        value0_207 : Uint256, value1_208 : Uint256, value2_209 : Uint256, value3_210 : Uint256,
        value4_211 : Uint256, value5 : Uint256):
    alloc_locals
    local _1_212 : Uint256 = Uint256(low=192, high=0)
    let (local _2_213 : Uint256) = uint256_sub(dataEnd_206, headStart_205)
    local range_check_ptr = range_check_ptr
    let (local _3_214 : Uint256) = slt(_2_213, _1_212)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_214)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_215 : Uint256 = Uint256(low=0, high=0)
    let (local _4_216 : Uint256) = u256_add(headStart_205, offset_215)
    local range_check_ptr = range_check_ptr
    let (local value0_207 : Uint256) = abi_decode_address(_4_216, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_217 : Uint256 = Uint256(low=32, high=0)
    let (local _5_218 : Uint256) = u256_add(headStart_205, offset_1_217)
    local range_check_ptr = range_check_ptr
    let (local value1_208 : Uint256) = abi_decode_uint256(_5_218, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_2_219 : Uint256 = Uint256(low=64, high=0)
    let (local _6_220 : Uint256) = u256_add(headStart_205, offset_2_219)
    local range_check_ptr = range_check_ptr
    let (local value2_209 : Uint256) = abi_decode_uint256(_6_220, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_3_221 : Uint256 = Uint256(low=96, high=0)
    let (local _7_222 : Uint256) = u256_add(headStart_205, offset_3_221)
    local range_check_ptr = range_check_ptr
    let (local value3_210 : Uint256) = abi_decode_uint8(_7_222, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_4_223 : Uint256 = Uint256(low=128, high=0)
    let (local _8_224 : Uint256) = u256_add(headStart_205, offset_4_223)
    local range_check_ptr = range_check_ptr
    let (local value4_211 : Uint256) = abi_decode_bytes32(_8_224, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_5 : Uint256 = Uint256(low=160, high=0)
    let (local _9_225 : Uint256) = u256_add(headStart_205, offset_5)
    local range_check_ptr = range_check_ptr
    let (local value5 : Uint256) = abi_decode_bytes32(_9_225, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_207, value1_208, value2_209, value3_210, value4_211, value5)
end

func convert_uint160_to_contract_IERC20PermitAllowed{
        exec_env : ExecutionEnvironment, range_check_ptr}(value_892 : Uint256) -> (
        converted_893 : Uint256):
    alloc_locals
    let (local converted_893 : Uint256) = convert_uint160_to_uint160(value_892)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_893)
end

func convert_address_to_contract_IERC20PermitAllowed{
        exec_env : ExecutionEnvironment, range_check_ptr}(value_818 : Uint256) -> (
        converted_819 : Uint256):
    alloc_locals
    let (local converted_819 : Uint256) = convert_uint160_to_contract_IERC20PermitAllowed(value_818)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_819)
end

func convert_contract_IERC20PermitAllowed_to_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(value_835 : Uint256) -> (
        converted_836 : Uint256):
    alloc_locals
    let (local converted_836 : Uint256) = convert_uint160_to_address(value_835)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_836)
end

func convert_contract_SelfPermit_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_851 : Uint256) -> (converted_852 : Uint256):
    alloc_locals
    let (local converted_852 : Uint256) = convert_uint160_to_address(value_851)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_852)
end

func abi_encode_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_466 : Uint256, pos_467 : Uint256) -> ():
    alloc_locals
    let (local _1_468 : Uint256) = cleanup_uint8(value_466)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_467.low, value=_1_468)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bytes32_to_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_401 : Uint256, pos_402 : Uint256) -> ():
    alloc_locals
    let (local _1_403 : Uint256) = cleanup_bytes32(value_401)
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_402.low, value=_1_403)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_531 : Uint256, value0_532 : Uint256, value1_533 : Uint256, value2_534 : Uint256,
        value3_535 : Uint256, value4_536 : Uint256, value5_537 : Uint256, value6 : Uint256,
        value7 : Uint256) -> (tail_538 : Uint256):
    alloc_locals
    local _1_539 : Uint256 = Uint256(low=256, high=0)
    let (local tail_538 : Uint256) = u256_add(headStart_531, _1_539)
    local range_check_ptr = range_check_ptr
    local _2_540 : Uint256 = Uint256(low=0, high=0)
    let (local _3_541 : Uint256) = u256_add(headStart_531, _2_540)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_532, _3_541)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_542 : Uint256 = Uint256(low=32, high=0)
    let (local _5_543 : Uint256) = u256_add(headStart_531, _4_542)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_533, _5_543)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_544 : Uint256 = Uint256(low=64, high=0)
    let (local _7_545 : Uint256) = u256_add(headStart_531, _6_544)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_534, _7_545)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_546 : Uint256 = Uint256(low=96, high=0)
    let (local _9_547 : Uint256) = u256_add(headStart_531, _8_546)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value3_535, _9_547)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _10_548 : Uint256 = Uint256(low=128, high=0)
    let (local _11_549 : Uint256) = u256_add(headStart_531, _10_548)
    local range_check_ptr = range_check_ptr
    abi_encode_bool(value4_536, _11_549)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _12_550 : Uint256 = Uint256(low=160, high=0)
    let (local _13_551 : Uint256) = u256_add(headStart_531, _12_550)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value5_537, _13_551)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_552 : Uint256 = Uint256(low=192, high=0)
    let (local _15_553 : Uint256) = u256_add(headStart_531, _14_552)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6, _15_553)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _16_554 : Uint256 = Uint256(low=224, high=0)
    let (local _17_555 : Uint256) = u256_add(headStart_531, _16_554)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value7, _17_555)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_538)
end

func abi_decode_fromMemory{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_154 : Uint256, dataEnd_155 : Uint256) -> ():
    alloc_locals
    local _1_156 : Uint256 = Uint256(low=0, high=0)
    let (local _2_157 : Uint256) = uint256_sub(dataEnd_155, headStart_154)
    local range_check_ptr = range_check_ptr
    let (local _3_158 : Uint256) = slt(_2_157, _1_156)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_158)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_31{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1436 : Uint256) -> ():
    alloc_locals
    let (local _14_1447 : Uint256) = __warp_holder()
    finalize_allocation(_3_1436, _14_1447)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1448 : Uint256) = __warp_holder()
    let (local _16_1449 : Uint256) = u256_add(_3_1436, _15_1448)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_3_1436, _16_1449)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1445 : Uint256, _3_1436 : Uint256) -> ():
    alloc_locals
    if _12_1445.low + _12_1445.high != 0:
        __warp_block_31(_3_1436)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func fun_selfPermitAllowed{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_token_1427 : Uint256, var_nonce_1428 : Uint256, var_expiry_1429 : Uint256,
        var_v_1430 : Uint256, var_r_1431 : Uint256, var_s_1432 : Uint256) -> ():
    alloc_locals
    let (local expr_2257_address : Uint256) = convert_address_to_contract_IERC20PermitAllowed(
        var_token_1427)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2258_address : Uint256) = convert_contract_IERC20PermitAllowed_to_address(
        expr_2257_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2258_functionSelector : Uint256 = Uint256(low=2412490508, high=0)
    let (local expr_1433 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_2263_address : Uint256) = __warp_holder()
    let (local expr_1_1434 : Uint256) = convert_contract_SelfPermit_to_address(expr_2263_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2_1435 : Uint256 = Uint256(low=1, high=0)
    let (local _3_1436 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1437 : Uint256) = shift_left_224(expr_2258_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1436.low, value=_4_1437)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1438 : Uint256 = Uint256(low=4, high=0)
    let (local _6_1439 : Uint256) = u256_add(_3_1436, _5_1438)
    local range_check_ptr = range_check_ptr
    let (
        local _7_1440 : Uint256) = abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32(
        _6_1439,
        expr_1433,
        expr_1_1434,
        var_nonce_1428,
        var_expiry_1429,
        expr_2_1435,
        var_v_1430,
        var_r_1431,
        var_s_1432)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1441 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1442 : Uint256) = uint256_sub(_7_1440, _3_1436)
    local range_check_ptr = range_check_ptr
    local _10_1443 : Uint256 = _8_1441
    let (local _11_1444 : Uint256) = __warp_holder()
    let (local _12_1445 : Uint256) = __warp_holder()
    let (local _13_1446 : Uint256) = is_zero(_12_1445)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_1446)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_15(_12_1445, _3_1436)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_struct_ExactOutputParams_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_109 : Uint256, end_110 : Uint256) -> (value_111 : Uint256):
    alloc_locals
    local _1_112 : Uint256 = Uint256(low=160, high=0)
    let (local _2_113 : Uint256) = uint256_sub(end_110, offset_109)
    local range_check_ptr = range_check_ptr
    let (local _3_114 : Uint256) = slt(_2_113, _1_112)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_114)
    local exec_env : ExecutionEnvironment = exec_env
    local value_111 : Uint256 = offset_109
    return (value_111)
end

func abi_decode_struct_ExactOutputParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_309 : Uint256, dataEnd_310 : Uint256) -> (value0_311 : Uint256):
    alloc_locals
    local _1_312 : Uint256 = Uint256(low=32, high=0)
    let (local _2_313 : Uint256) = uint256_sub(dataEnd_310, headStart_309)
    local range_check_ptr = range_check_ptr
    let (local _3_314 : Uint256) = slt(_2_313, _1_312)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_314)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_315 : Uint256 = Uint256(low=0, high=0)
    let (local _5_316 : Uint256) = u256_add(headStart_309, _4_315)
    local range_check_ptr = range_check_ptr
    let (local offset_317 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_316.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_318 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_319 : Uint256) = is_gt(offset_317, _6_318)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_319)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_320 : Uint256) = u256_add(headStart_309, offset_317)
    local range_check_ptr = range_check_ptr
    let (local value0_311 : Uint256) = abi_decode_struct_ExactOutputParams_calldata(
        _8_320, dataEnd_310)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_311)
end

func access_calldata_tail_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref : Uint256, ptr_to_tail : Uint256) -> (addr : Uint256, length_635 : Uint256):
    alloc_locals
    let (local rel_offset_of_tail : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_to_tail.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _1_636 : Uint256 = Uint256(low=1, high=0)
    local _2_637 : Uint256 = Uint256(low=32, high=0)
    let (local _3_638 : Uint256) = uint256_sub(_2_637, _1_636)
    local range_check_ptr = range_check_ptr
    local _4_639 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    let (local _5_640 : Uint256) = uint256_sub(_4_639, base_ref)
    local range_check_ptr = range_check_ptr
    let (local _6_641 : Uint256) = uint256_sub(_5_640, _3_638)
    local range_check_ptr = range_check_ptr
    let (local _7_642 : Uint256) = slt(rel_offset_of_tail, _6_641)
    local range_check_ptr = range_check_ptr
    let (local _8_643 : Uint256) = is_zero(_7_642)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_643)
    local exec_env : ExecutionEnvironment = exec_env
    let (local addr : Uint256) = u256_add(base_ref, rel_offset_of_tail)
    local range_check_ptr = range_check_ptr
    let (local length_635 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(addr.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _9_644 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _10_645 : Uint256) = is_gt(length_635, _9_644)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_10_645)
    local exec_env : ExecutionEnvironment = exec_env
    local _11_646 : Uint256 = _2_637
    let (local addr : Uint256) = u256_add(addr, _2_637)
    local range_check_ptr = range_check_ptr
    local _12_647 : Uint256 = _1_636
    let (local _13_648 : Uint256) = u256_mul(length_635, _1_636)
    local range_check_ptr = range_check_ptr
    local _14_649 : Uint256 = _4_639
    let (local _15_650 : Uint256) = uint256_sub(_4_639, _13_648)
    local range_check_ptr = range_check_ptr
    let (local _16_651 : Uint256) = sgt(addr, _15_650)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_651)
    local exec_env : ExecutionEnvironment = exec_env
    return (addr, length_635)
end

func copy_calldata_to_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src_906 : Uint256, dst_907 : Uint256, length_908 : Uint256) -> ():
    alloc_locals
    calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(dst_907, src_906, length_908)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_909 : Uint256 = Uint256(low=0, high=0)
    let (local _2_910 : Uint256) = u256_add(dst_907, length_908)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_910.low, value=_1_909)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_decode_available_length_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src : Uint256, length : Uint256, end__warp_mangled : Uint256) -> (array : Uint256):
    alloc_locals
    let (local _1_1 : Uint256) = array_allocation_size_bytes(length)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local array : Uint256) = allocate_memory(_1_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=array.low, value=length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_2 : Uint256 = Uint256(low=32, high=0)
    let (local dst : Uint256) = u256_add(array, _2_2)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = u256_add(src, length)
    local range_check_ptr = range_check_ptr
    let (local _4_4 : Uint256) = is_gt(_3_3, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_4)
    local exec_env : ExecutionEnvironment = exec_env
    copy_calldata_to_memory(src, dst, length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array)
end

func convert_array_bytes_calldata_to_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_815 : Uint256, length_816 : Uint256) -> (converted : Uint256):
    alloc_locals
    local _1_817 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    let (local converted : Uint256) = abi_decode_available_length_bytes(
        value_815, length_816, _1_817)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (converted)
end

func getter_fun_amountInCached{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1808 : Uint256):
    alloc_locals
    let (res) = amountInCached.read()
    return (res)
end

func fun_exactOutput_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1174 : Uint256, var_params_offset_1175 : Uint256) -> (var_amountIn_1176 : Uint256):
    alloc_locals
    local _2_1177 : Uint256 = Uint256(low=96, high=0)
    let (local _3_1178 : Uint256) = u256_add(var_params_offset_1175, _2_1177)
    local range_check_ptr = range_check_ptr
    let (local expr_1179 : Uint256) = read_from_calldatat_uint256(_3_1178)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_1180 : Uint256 = Uint256(low=32, high=0)
    let (local _5_1181 : Uint256) = u256_add(var_params_offset_1175, _4_1180)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1182 : Uint256) = read_from_calldatat_address(_5_1181)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2_1183 : Uint256 = Uint256(low=0, high=0)
    let (local _6_1184 : Uint256) = u256_add(var_params_offset_1175, expr_2_1183)
    local range_check_ptr = range_check_ptr
    let (local expr_offset : Uint256,
        local expr_3373_length : Uint256) = access_calldata_tail_bytes_calldata(
        var_params_offset_1175, _6_1184)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1185 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (
        local expr_3376_mpos : Uint256) = allocate_memory_struct_struct_SwapCallbackData_storage_ptr(
        )
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _485_mpos : Uint256) = convert_array_bytes_calldata_to_bytes(
        expr_offset, expr_3373_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1186 : Uint256) = u256_add(expr_3376_mpos, expr_2_1183)
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(_7_1186, _485_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _8_1187 : Uint256 = _4_1180
    let (local _9_1188 : Uint256) = u256_add(expr_3376_mpos, _4_1180)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_9_1188, expr_3_1185)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_1189 : Uint256) = convert_rational_0_by_1_to_uint160(expr_2_1183)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _11_1190 : Uint256) = fun_exactOutputInternal(
        expr_1179, expr_1_1182, _10_1189, expr_3376_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    __warp_holder()
    let (local _12_1191 : Uint256) = getter_fun_amountInCached()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local var_amountIn_1176 : Uint256 = _12_1191
    local _13_1192 : Uint256 = Uint256(low=128, high=0)
    let (local _14_1193 : Uint256) = u256_add(var_params_offset_1175, _13_1192)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1194 : Uint256) = read_from_calldatat_uint256(_14_1193)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _15_1195 : Uint256) = cleanup_uint256(expr_4_1194)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _16_1196 : Uint256) = cleanup_uint256(_12_1191)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1197 : Uint256) = is_gt(_16_1196, _15_1195)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1198 : Uint256) = is_zero(_17_1197)
    local range_check_ptr = range_check_ptr
    require_helper(expr_5_1198)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_6_1199 : Uint256) = constant_DEFAULT_AMOUNT_IN_CACHED()
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_amountInCached(expr_6_1199)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_amountIn_1176)
end

func modifier_checkDeadline{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amountIn_1874 : Uint256, var_params_offset_1875 : Uint256) -> (_1_1876 : Uint256):
    alloc_locals
    local _2_1877 : Uint256 = Uint256(low=64, high=0)
    let (local _3_1878 : Uint256) = u256_add(var_params_offset_1875, _2_1877)
    local range_check_ptr = range_check_ptr
    let (local expr_1879 : Uint256) = read_from_calldatat_uint256(_3_1878)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1880 : Uint256) = fun_blockTimestamp()
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1881 : Uint256) = cleanup_uint256(expr_1879)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1882 : Uint256) = cleanup_uint256(expr_1_1880)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1883 : Uint256) = is_gt(_5_1882, _4_1881)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1884 : Uint256) = is_zero(_6_1883)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1884)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1876 : Uint256) = fun_exactOutput_dynArgs_inner(
        var_amountIn_1874, var_params_offset_1875)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1876)
end

func fun_exactOutput_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_1171 : Uint256) -> (var_amountIn_1172 : Uint256):
    alloc_locals
    let (local zero_uint256_1173 : Uint256) = zero_value_for_split_uint256()
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountIn_1172 : Uint256) = modifier_checkDeadline(
        zero_uint256_1173, var_params_offset_1171)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountIn_1172)
end

func abi_decode_uint256t_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_349 : Uint256, dataEnd_350 : Uint256) -> (
        value0_351 : Uint256, value1_352 : Uint256):
    alloc_locals
    local _1_353 : Uint256 = Uint256(low=64, high=0)
    let (local _2_354 : Uint256) = uint256_sub(dataEnd_350, headStart_349)
    local range_check_ptr = range_check_ptr
    let (local _3_355 : Uint256) = slt(_2_354, _1_353)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_355)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_356 : Uint256 = Uint256(low=0, high=0)
    let (local _4_357 : Uint256) = u256_add(headStart_349, offset_356)
    local range_check_ptr = range_check_ptr
    let (local value0_351 : Uint256) = abi_decode_uint256(_4_357, dataEnd_350)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_358 : Uint256 = Uint256(low=32, high=0)
    let (local _5_359 : Uint256) = u256_add(headStart_349, offset_1_358)
    local range_check_ptr = range_check_ptr
    let (local value1_352 : Uint256) = abi_decode_address(_5_359, dataEnd_350)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_351, value1_352)
end

func getter_fun_WETH9{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1802 : Uint256):
    alloc_locals
    let (res) = WETH9.read()
    return (res)
end

func convert_uint160_to_contract_IWETH9{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_900 : Uint256) -> (converted_901 : Uint256):
    alloc_locals
    let (local converted_901 : Uint256) = convert_uint160_to_uint160(value_900)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_901)
end

func convert_address_to_contract_IWETH9{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_826 : Uint256) -> (converted_827 : Uint256):
    alloc_locals
    let (local converted_827 : Uint256) = convert_uint160_to_contract_IWETH9(value_826)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_827)
end

func convert_contract_IWETH9_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_843 : Uint256) -> (converted_844 : Uint256):
    alloc_locals
    let (local converted_844 : Uint256) = convert_uint160_to_address(value_843)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_844)
end

func abi_decode_t_uint256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_144 : Uint256, end_145 : Uint256) -> (value_146 : Uint256):
    alloc_locals
    let (local value_146 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset_144.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    validator_revert_uint256(value_146)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_146)
end

func abi_decode_uint256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_341 : Uint256, dataEnd_342 : Uint256) -> (value0_343 : Uint256):
    alloc_locals
    local _1_344 : Uint256 = Uint256(low=32, high=0)
    let (local _2_345 : Uint256) = uint256_sub(dataEnd_342, headStart_341)
    local range_check_ptr = range_check_ptr
    let (local _3_346 : Uint256) = slt(_2_345, _1_344)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_346)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_347 : Uint256 = Uint256(low=0, high=0)
    let (local _4_348 : Uint256) = u256_add(headStart_341, offset_347)
    local range_check_ptr = range_check_ptr
    let (local value0_343 : Uint256) = abi_decode_t_uint256_fromMemory(_4_348, dataEnd_342)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_343)
end

func __warp_block_32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_1750 : Uint256) -> (expr_1_1760 : Uint256):
    alloc_locals
    let (local _14_1761 : Uint256) = __warp_holder()
    finalize_allocation(_4_1750, _14_1761)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1762 : Uint256) = __warp_holder()
    let (local _16_1763 : Uint256) = u256_add(_4_1750, _15_1762)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1760 : Uint256) = abi_decode_uint256_fromMemory(_4_1750, _16_1763)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1760)
end

func __warp_if_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1758 : Uint256, _4_1750 : Uint256, expr_1_1760 : Uint256) -> (expr_1_1760 : Uint256):
    alloc_locals
    if _12_1758.low + _12_1758.high != 0:
        let (local expr_1_1760 : Uint256) = __warp_block_32(_4_1750)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1760)
    else:
        return (expr_1_1760)
    end
end

func __warp_block_34{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _25_1773 : Uint256) -> ():
    alloc_locals
    let (local _34_1782 : Uint256) = __warp_holder()
    finalize_allocation(_25_1773, _34_1782)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35_1783 : Uint256) = __warp_holder()
    let (local _36_1784 : Uint256) = u256_add(_25_1773, _35_1783)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_25_1773, _36_1784)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_18{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _25_1773 : Uint256, _32_1780 : Uint256) -> ():
    alloc_locals
    if _32_1780.low + _32_1780.high != 0:
        __warp_block_34(_25_1773)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_33{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _6_1752 : Uint256, expr_1_1760 : Uint256, expr_3_1768 : Uint256,
        var_recipient_1747 : Uint256) -> ():
    alloc_locals
    let (local _22_1772 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1617_address : Uint256) = convert_address_to_contract_IWETH9(_22_1772)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1618_address : Uint256) = convert_contract_IWETH9_to_address(expr_1617_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1618_functionSelector : Uint256 = Uint256(low=773487949, high=0)
    let (local _25_1773 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_1774 : Uint256) = shift_left_224(expr_1618_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_25_1773.low, value=_26_1774)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _27_1775 : Uint256 = _6_1752
    let (local _28_1776 : Uint256) = u256_add(_25_1773, _6_1752)
    local range_check_ptr = range_check_ptr
    let (local _29_1777 : Uint256) = abi_encode_uint256(_28_1776, expr_1_1760)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30_1778 : Uint256) = uint256_sub(_29_1777, _25_1773)
    local range_check_ptr = range_check_ptr
    let (local _31_1779 : Uint256) = __warp_holder()
    let (local _32_1780 : Uint256) = __warp_holder()
    let (local _33_1781 : Uint256) = is_zero(_32_1780)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_33_1781)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_18(_25_1773, _32_1780)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1747, expr_1_1760)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _6_1752 : Uint256, expr_1_1760 : Uint256, expr_3_1768 : Uint256, expr_4_1771 : Uint256,
        var_recipient_1747 : Uint256) -> ():
    alloc_locals
    if expr_4_1771.low + expr_4_1771.high != 0:
        __warp_block_33(_6_1752, expr_1_1760, expr_3_1768, var_recipient_1747)
        local exec_env : ExecutionEnvironment = exec_env
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

func fun_unwrapWETH9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_amountMinimum_1746 : Uint256, var_recipient_1747 : Uint256) -> ():
    alloc_locals
    let (local _1_1748 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1598_address : Uint256) = convert_address_to_contract_IWETH9(_1_1748)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1599_address : Uint256) = convert_contract_IWETH9_to_address(expr_1598_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_functionSelector : Uint256 = Uint256(low=1889567281, high=0)
    let (local expr_1602_address : Uint256) = __warp_holder()
    let (local expr_1749 : Uint256) = convert_contract_PeripheryPayments_to_address(
        expr_1602_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1750 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1751 : Uint256) = shift_left_224(expr_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_4_1750.low, value=_5_1751)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _6_1752 : Uint256 = Uint256(low=4, high=0)
    let (local _7_1753 : Uint256) = u256_add(_4_1750, _6_1752)
    local range_check_ptr = range_check_ptr
    let (local _8_1754 : Uint256) = abi_encode_tuple_address(_7_1753, expr_1749)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _9_1755 : Uint256 = Uint256(low=32, high=0)
    let (local _10_1756 : Uint256) = uint256_sub(_8_1754, _4_1750)
    local range_check_ptr = range_check_ptr
    let (local _11_1757 : Uint256) = __warp_holder()
    let (local _12_1758 : Uint256) = __warp_holder()
    let (local _13_1759 : Uint256) = is_zero(_12_1758)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_1759)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1760 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1760 : Uint256) = __warp_if_16(_12_1758, _4_1750, expr_1_1760)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17_1764 : Uint256) = cleanup_uint256(var_amountMinimum_1746)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _18_1765 : Uint256) = cleanup_uint256(expr_1_1760)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _19_1766 : Uint256) = is_lt(_18_1765, _17_1764)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1767 : Uint256) = is_zero(_19_1766)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1767)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_3_1768 : Uint256 = Uint256(low=0, high=0)
    let (local _20_1769 : Uint256) = convert_rational_0_by_1_to_uint256(expr_3_1768)
    local exec_env : ExecutionEnvironment = exec_env
    local _21_1770 : Uint256 = _18_1765
    let (local expr_4_1771 : Uint256) = is_gt(_18_1765, _20_1769)
    local range_check_ptr = range_check_ptr
    __warp_if_17(_6_1752, expr_1_1760, expr_3_1768, expr_4_1771, var_recipient_1747)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func abi_decode_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_50 : Uint256, end_51 : Uint256) -> (array_52 : Uint256):
    alloc_locals
    local _1_53 : Uint256 = Uint256(low=31, high=0)
    let (local _2_54 : Uint256) = u256_add(offset_50, _1_53)
    local range_check_ptr = range_check_ptr
    let (local _3_55 : Uint256) = slt(_2_54, end_51)
    local range_check_ptr = range_check_ptr
    let (local _4_56 : Uint256) = is_zero(_3_55)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_56)
    local exec_env : ExecutionEnvironment = exec_env
    let (local length_57 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_50.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_58 : Uint256 = Uint256(low=32, high=0)
    let (local _6_59 : Uint256) = u256_add(offset_50, _5_58)
    local range_check_ptr = range_check_ptr
    let (local array_52 : Uint256) = abi_decode_available_length_bytes(_6_59, length_57, end_51)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array_52)
end

func abi_decode_struct_ExactInputParams{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, end_76 : Uint256) -> (value_77 : Uint256):
    alloc_locals
    local _1_78 : Uint256 = Uint256(low=160, high=0)
    let (local _2_79 : Uint256) = uint256_sub(end_76, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_80 : Uint256) = slt(_2_79, _1_78)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_80)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_81 : Uint256 = _1_78
    let (local value_77 : Uint256) = allocate_memory(_1_78)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_82 : Uint256 = Uint256(low=0, high=0)
    let (local _6_83 : Uint256) = u256_add(headStart, _5_82)
    local range_check_ptr = range_check_ptr
    let (local offset_84 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_6_83.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_85 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_86 : Uint256) = is_gt(offset_84, _7_85)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_86)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_87 : Uint256) = u256_add(headStart, offset_84)
    local range_check_ptr = range_check_ptr
    let (local _10_88 : Uint256) = abi_decode_bytes(_9_87, end_76)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_89 : Uint256 = _5_82
    let (local _12_90 : Uint256) = u256_add(value_77, _5_82)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_90.low, value=_10_88)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local offset_1 : Uint256 = Uint256(low=32, high=0)
    let (local _13_91 : Uint256) = u256_add(headStart, offset_1)
    local range_check_ptr = range_check_ptr
    let (local _14_92 : Uint256) = abi_decode_address(_13_91, end_76)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _15_93 : Uint256) = u256_add(value_77, offset_1)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_15_93.low, value=_14_92)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local offset_2 : Uint256 = Uint256(low=64, high=0)
    let (local _16_94 : Uint256) = u256_add(headStart, offset_2)
    local range_check_ptr = range_check_ptr
    let (local _17_95 : Uint256) = abi_decode_uint256(_16_94, end_76)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _18_96 : Uint256) = u256_add(value_77, offset_2)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_18_96.low, value=_17_95)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local offset_3 : Uint256 = Uint256(low=96, high=0)
    let (local _19_97 : Uint256) = u256_add(headStart, offset_3)
    local range_check_ptr = range_check_ptr
    let (local _20_98 : Uint256) = abi_decode_uint256(_19_97, end_76)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _21_99 : Uint256) = u256_add(value_77, offset_3)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_21_99.low, value=_20_98)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local offset_4 : Uint256 = Uint256(low=128, high=0)
    let (local _22_100 : Uint256) = u256_add(headStart, offset_4)
    local range_check_ptr = range_check_ptr
    let (local _23_101 : Uint256) = abi_decode_uint256(_22_100, end_76)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _24_102 : Uint256) = u256_add(value_77, offset_4)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_24_102.low, value=_23_101)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (value_77)
end

func abi_decode_struct_ExactInputParams_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_289 : Uint256, dataEnd_290 : Uint256) -> (value0_291 : Uint256):
    alloc_locals
    local _1_292 : Uint256 = Uint256(low=32, high=0)
    let (local _2_293 : Uint256) = uint256_sub(dataEnd_290, headStart_289)
    local range_check_ptr = range_check_ptr
    let (local _3_294 : Uint256) = slt(_2_293, _1_292)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_294)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_295 : Uint256 = Uint256(low=0, high=0)
    let (local _5_296 : Uint256) = u256_add(headStart_289, _4_295)
    local range_check_ptr = range_check_ptr
    let (local offset_297 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_296.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_298 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_299 : Uint256) = is_gt(offset_297, _6_298)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_299)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_300 : Uint256) = u256_add(headStart_289, offset_297)
    local range_check_ptr = range_check_ptr
    let (local value0_291 : Uint256) = abi_decode_struct_ExactInputParams(_8_300, dataEnd_290)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_291)
end

func read_from_memoryt_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        ptr_1933 : Uint256) -> (returnValue_1934 : Uint256):
    alloc_locals
    let (local _1_1935 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(ptr_1933.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local value_1936 : Uint256) = cleanup_uint256(_1_1935)
    local exec_env : ExecutionEnvironment = exec_env
    local returnValue_1934 : Uint256 = value_1936
    return (returnValue_1934)
end

func constant_POP_OFFSET{exec_env : ExecutionEnvironment, range_check_ptr}() -> (ret_811 : Uint256):
    alloc_locals
    let (local expr_812 : Uint256) = constant_NEXT_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_813 : Uint256) = constant_ADDR_SIZE()
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2_814 : Uint256) = checked_add_uint256(expr_812, expr_1_813)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_811 : Uint256 = expr_2_814
    return (ret_811)
end

func constant_MULTIPLE_POOLS_MIN_LENGTH{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_802 : Uint256):
    alloc_locals
    let (local expr_803 : Uint256) = constant_POP_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1 : Uint256) = constant_NEXT_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2 : Uint256) = checked_add_uint256(expr_803, expr_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local ret_802 : Uint256 = expr_2
    return (ret_802)
end

func fun_hasMultiplePools{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_mpos : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local expr_1221 : Uint256) = array_length_bytes(var_path_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1222 : Uint256) = constant_MULTIPLE_POOLS_MIN_LENGTH()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1223 : Uint256) = cleanup_uint256(expr_1_1222)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1224 : Uint256) = cleanup_uint256(expr_1221)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1225 : Uint256) = is_lt(_2_1224, _1_1223)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1226 : Uint256) = is_zero(_3_1225)
    local range_check_ptr = range_check_ptr
    local var_ : Uint256 = expr_2_1226
    return (var_)
end

func convert_rational_31_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_880 : Uint256) -> (converted_881 : Uint256):
    alloc_locals
    let (local converted_881 : Uint256) = cleanup_uint256(value_880)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_881)
end

func __warp_loop_body_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _14_1521 : Uint256, usr_cc : Uint256, usr_mc : Uint256) -> (
        usr_cc : Uint256, usr_mc : Uint256):
    alloc_locals
    let (local _24_1531 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(usr_cc.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=usr_mc.low, value=_24_1531)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _22_1529 : Uint256 = _14_1521
    let (local usr_mc : Uint256) = u256_add(usr_mc, _14_1521)
    local range_check_ptr = range_check_ptr
    local _23_1530 : Uint256 = _14_1521
    let (local usr_cc : Uint256) = u256_add(usr_cc, _14_1521)
    local range_check_ptr = range_check_ptr
    return (usr_cc, usr_mc)
end

func __warp_loop_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _14_1521 : Uint256, usr_cc : Uint256, usr_mc : Uint256) -> (
        usr_cc : Uint256, usr_mc : Uint256):
    alloc_locals
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_body_4(
        _14_1521, usr_cc, usr_mc)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(_14_1521, usr_cc, usr_mc)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (usr_cc, usr_mc)
end

func __warp_block_37{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1500 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    local _12_1519 : Uint256 = Uint256(low=64, high=0)
    let (local var_tempBytes_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_12_1519.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local usr_lengthmod : Uint256) = uint256_and(var_length, expr_1500)
    local range_check_ptr = range_check_ptr
    let (local _13_1520 : Uint256) = is_zero(usr_lengthmod)
    local range_check_ptr = range_check_ptr
    local _14_1521 : Uint256 = Uint256(low=32, high=0)
    let (local _15_1522 : Uint256) = u256_mul(_14_1521, _13_1520)
    local range_check_ptr = range_check_ptr
    let (local _16_1523 : Uint256) = u256_add(var_tempBytes_mpos, usr_lengthmod)
    local range_check_ptr = range_check_ptr
    let (local usr_mc : Uint256) = u256_add(_16_1523, _15_1522)
    local range_check_ptr = range_check_ptr
    let (local usr_end : Uint256) = u256_add(usr_mc, var_length)
    local range_check_ptr = range_check_ptr
    local _17_1524 : Uint256 = _13_1520
    local _18_1525 : Uint256 = _14_1521
    local _19_1526 : Uint256 = _15_1522
    let (local _20_1527 : Uint256) = u256_add(var__bytes_mpos, usr_lengthmod)
    local range_check_ptr = range_check_ptr
    let (local _21_1528 : Uint256) = u256_add(_20_1527, _15_1522)
    local range_check_ptr = range_check_ptr
    let (local usr_cc : Uint256) = u256_add(_21_1528, var__start)
    local range_check_ptr = range_check_ptr
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(_14_1521, usr_cc, usr_mc)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=var_tempBytes_mpos.low, value=var_length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _25_1532 : Uint256) = uint256_not(expr_1500)
    local range_check_ptr = range_check_ptr
    let (local _26_1533 : Uint256) = u256_add(usr_mc, expr_1500)
    local range_check_ptr = range_check_ptr
    let (local _27_1534 : Uint256) = uint256_and(_26_1533, _25_1532)
    local range_check_ptr = range_check_ptr
    local _28_1535 : Uint256 = _12_1519
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_1519.low, value=_27_1534)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (var_tempBytes_mpos)
end

func __warp_block_38{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_tempBytes_mpos : Uint256):
    alloc_locals
    local _29_1536 : Uint256 = Uint256(low=64, high=0)
    let (local var_tempBytes_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_29_1536.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _30_1537 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=var_tempBytes_mpos.low, value=_30_1537)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _31_1538 : Uint256 = Uint256(low=32, high=0)
    let (local _32_1539 : Uint256) = u256_add(var_tempBytes_mpos, _31_1538)
    local range_check_ptr = range_check_ptr
    local _33_1540 : Uint256 = _29_1536
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_29_1536.low, value=_32_1539)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (var_tempBytes_mpos)
end

func __warp_if_19{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_1500 : Uint256, var__bytes_mpos : Uint256,
        var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_tempBytes_mpos : Uint256) = __warp_block_37(
            expr_1500, var__bytes_mpos, var__start, var_length)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (var_tempBytes_mpos)
    else:
        let (local var_tempBytes_mpos : Uint256) = __warp_block_38()
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (var_tempBytes_mpos)
    end
end

func __warp_block_36{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1500 : Uint256, match_var : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_tempBytes_mpos : Uint256) = __warp_if_19(
        __warp_subexpr_0, expr_1500, var__bytes_mpos, var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tempBytes_mpos)
end

func __warp_block_35{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_1518 : Uint256, expr_1500 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    local match_var : Uint256 = _11_1518
    let (local var_tempBytes_mpos : Uint256) = __warp_block_36(
        expr_1500, match_var, var__bytes_mpos, var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tempBytes_mpos)
end

func fun_slice{exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (
        var_2328_mpos : Uint256):
    alloc_locals
    local expr_1500 : Uint256 = Uint256(low=31, high=0)
    let (local _1_1501 : Uint256) = convert_rational_31_by_1_to_uint256(expr_1500)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1502 : Uint256) = checked_add_uint256(var_length, _1_1501)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1503 : Uint256) = cleanup_uint256(var_length)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1504 : Uint256) = cleanup_uint256(expr_1_1502)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1505 : Uint256) = is_lt(_3_1504, _2_1503)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1506 : Uint256) = is_zero(_4_1505)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1506)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1507 : Uint256) = checked_add_uint256(var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_1508 : Uint256) = cleanup_uint256(var__start)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1509 : Uint256) = cleanup_uint256(expr_3_1507)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_1510 : Uint256) = is_lt(_6_1509, _5_1508)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1511 : Uint256) = is_zero(_7_1510)
    local range_check_ptr = range_check_ptr
    require_helper(expr_4_1511)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_5_1512 : Uint256) = array_length_bytes(var__bytes_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_6_1513 : Uint256) = checked_add_uint256(var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_1514 : Uint256) = cleanup_uint256(expr_6_1513)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_1515 : Uint256) = cleanup_uint256(expr_5_1512)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _10_1516 : Uint256) = is_lt(_9_1515, _8_1514)
    local range_check_ptr = range_check_ptr
    let (local expr_7_1517 : Uint256) = is_zero(_10_1516)
    local range_check_ptr = range_check_ptr
    require_helper(expr_7_1517)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_tempBytes_mpos : Uint256 = Uint256(low=0, high=0)
    let (local _11_1518 : Uint256) = is_zero(var_length)
    local range_check_ptr = range_check_ptr
    let (local var_tempBytes_mpos : Uint256) = __warp_block_35(
        _11_1518, expr_1500, var__bytes_mpos, var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_2328_mpos : Uint256 = var_tempBytes_mpos
    return (var_2328_mpos)
end

func fun_getFirstPool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_2518_mpos : Uint256) -> (var_2521_mpos : Uint256):
    alloc_locals
    local expr_1200 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1201 : Uint256) = constant_POP_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1202 : Uint256) = convert_rational_0_by_1_to_uint256(expr_1200)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2527_mpos : Uint256) = fun_slice(var_path_2518_mpos, _1_1202, expr_1_1201)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_2521_mpos : Uint256 = expr_2527_mpos
    return (var_2521_mpos)
end

func write_to_memory_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_2083 : Uint256, value_2084 : Uint256) -> ():
    alloc_locals
    let (local _1_2085 : Uint256) = cleanup_uint256(value_2084)
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_2083.low, value=_1_2085)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func checked_sub_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_764 : Uint256, y_765 : Uint256) -> (diff_766 : Uint256):
    alloc_locals
    let (local x_764 : Uint256) = cleanup_uint256(x_764)
    local exec_env : ExecutionEnvironment = exec_env
    let (local y_765 : Uint256) = cleanup_uint256(y_765)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_767 : Uint256) = is_lt(x_764, y_765)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_767)
    local exec_env : ExecutionEnvironment = exec_env
    let (local diff_766 : Uint256) = uint256_sub(x_764, y_765)
    local range_check_ptr = range_check_ptr
    return (diff_766)
end

func fun_skipToken{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_2532_mpos : Uint256) -> (var_mpos : Uint256):
    alloc_locals
    let (local expr_1496 : Uint256) = constant_NEXT_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1497 : Uint256) = array_length_bytes(var_path_2532_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2_1498 : Uint256) = constant_NEXT_OFFSET()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1499 : Uint256) = checked_sub_uint256(expr_1_1497, expr_2_1498)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2544_mpos : Uint256) = fun_slice(var_path_2532_mpos, expr_1496, expr_3_1499)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_mpos : Uint256 = expr_2544_mpos
    return (var_mpos)
end

func __warp_block_41{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_params_mpos : Uint256) -> (expr_3_1066 : Uint256):
    alloc_locals
    local _8_1067 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1068 : Uint256) = u256_add(var_params_mpos, _8_1067)
    local range_check_ptr = range_check_ptr
    let (local _10_1069 : Uint256) = read_from_memoryt_address(_9_1068)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_3_1066 : Uint256 = _10_1069
    return (expr_3_1066)
end

func __warp_block_42{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_3_1066 : Uint256):
    alloc_locals
    let (local expr_3127_address : Uint256) = __warp_holder()
    let (local expr_4_1070 : Uint256) = convert_contract_SwapRouter_to_address(expr_3127_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_3_1066 : Uint256 = expr_4_1070
    return (expr_3_1066)
end

func __warp_if_20{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, var_params_mpos : Uint256) -> (expr_3_1066 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_3_1066 : Uint256) = __warp_block_41(var_params_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_3_1066)
    else:
        let (local expr_3_1066 : Uint256) = __warp_block_42()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3_1066)
    end
end

func __warp_block_40{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, var_params_mpos : Uint256) -> (expr_3_1066 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_3_1066 : Uint256) = __warp_if_20(__warp_subexpr_0, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_3_1066)
end

func __warp_block_39{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_2_1062 : Uint256, var_params_mpos : Uint256) -> (expr_3_1066 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_2_1062
    let (local expr_3_1066 : Uint256) = __warp_block_40(match_var, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_3_1066)
end

func __warp_block_45{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1064 : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_204 : Uint256, var_amountOut_1056 : Uint256):
    alloc_locals
    let (local _16_1078 : Uint256) = read_from_memoryt_uint256(_6_1064)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local var_amountOut_1056 : Uint256 = _16_1078
    local __warp_break_2 : Uint256 = Uint256(low=1, high=0)
    local __warp_leave_204 : Uint256 = Uint256(low=1, high=0)
    return (__warp_break_2, __warp_leave_204, var_amountOut_1056)
end

func __warp_block_46{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_1061 : Uint256) -> (var_payer : Uint256):
    alloc_locals
    let (local expr_3147_address : Uint256) = __warp_holder()
    let (local expr_7_1079 : Uint256) = convert_contract_SwapRouter_to_address(expr_3147_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_payer : Uint256 = expr_7_1079
    let (local _405_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_1061.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_3157_mpos : Uint256) = fun_skipToken(_405_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_4_1061.low, value=expr_3157_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (var_payer)
end

func __warp_if_76{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_1061 : Uint256, _6_1064 : Uint256, __warp_break_2 : Uint256, __warp_leave_204 : Uint256,
        __warp_leave_366 : Uint256, __warp_subexpr_0 : Uint256, var_amountOut_1056 : Uint256,
        var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_204 : Uint256, __warp_leave_366 : Uint256,
        var_amountOut_1056 : Uint256, var_payer : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local __warp_break_2 : Uint256, local __warp_leave_204 : Uint256,
            local var_amountOut_1056 : Uint256) = __warp_block_45(_6_1064)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        if __warp_leave_204.low + __warp_leave_204.high != 0:
            local __warp_leave_366 : Uint256 = Uint256(low=1, high=0)
            return (
                __warp_break_2, __warp_leave_204, __warp_leave_366, var_amountOut_1056, var_payer)
        else:
            return (
                __warp_break_2, __warp_leave_204, __warp_leave_366, var_amountOut_1056, var_payer)
        end
    else:
        let (local var_payer : Uint256) = __warp_block_46(_4_1061)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (__warp_break_2, __warp_leave_204, __warp_leave_366, var_amountOut_1056, var_payer)
    end
end

func __warp_block_44{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_1061 : Uint256, _6_1064 : Uint256, __warp_break_2 : Uint256, __warp_leave_204 : Uint256,
        match_var : Uint256, var_amountOut_1056 : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_204 : Uint256, var_amountOut_1056 : Uint256,
        var_payer : Uint256):
    alloc_locals
    local __warp_leave_366 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_break_2 : Uint256, local __warp_leave_204 : Uint256,
        local __warp_leave_366 : Uint256, local var_amountOut_1056 : Uint256,
        local var_payer : Uint256) = __warp_if_76(
        _4_1061,
        _6_1064,
        __warp_break_2,
        __warp_leave_204,
        __warp_leave_366,
        __warp_subexpr_0,
        var_amountOut_1056,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_366.low + __warp_leave_366.high != 0:
        return (__warp_break_2, __warp_leave_204, var_amountOut_1056, var_payer)
    else:
        return (__warp_break_2, __warp_leave_204, var_amountOut_1056, var_payer)
    end
end

func __warp_block_43{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_1061 : Uint256, _6_1064 : Uint256, __warp_break_2 : Uint256, __warp_leave_204 : Uint256,
        expr_2_1062 : Uint256, var_amountOut_1056 : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_204 : Uint256, var_amountOut_1056 : Uint256,
        var_payer : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_2_1062
    let (local __warp_break_2 : Uint256, local __warp_leave_204 : Uint256,
        local var_amountOut_1056 : Uint256, local var_payer : Uint256) = __warp_block_44(
        _4_1061,
        _6_1064,
        __warp_break_2,
        __warp_leave_204,
        match_var,
        var_amountOut_1056,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_204.low + __warp_leave_204.high != 0:
        return (__warp_break_2, __warp_leave_204, var_amountOut_1056, var_payer)
    else:
        return (__warp_break_2, __warp_leave_204, var_amountOut_1056, var_payer)
    end
end

func __warp_loop_body_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        __warp_break_2 : Uint256, var_params_mpos : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, var_amountOut_1056 : Uint256, var_payer : Uint256):
    alloc_locals
    local var_amountOut_1056 : Uint256 = Uint256(low=0, high=0)
    local __warp_leave_204 : Uint256 = Uint256(low=0, high=0)
    local expr_1_1058 : Uint256 = Uint256(low=1, high=0)
    let (local _2_1059 : Uint256) = is_zero(expr_1_1058)
    local range_check_ptr = range_check_ptr
    if _2_1059.low + _2_1059.high != 0:
        local __warp_break_2 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_2, var_amountOut_1056, var_payer)
    end
    local _3_1060 : Uint256 = Uint256(low=0, high=0)
    let (local _4_1061 : Uint256) = u256_add(var_params_mpos, _3_1060)
    local range_check_ptr = range_check_ptr
    let (local _383_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_1061.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2_1062 : Uint256) = fun_hasMultiplePools(_383_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1063 : Uint256 = Uint256(low=96, high=0)
    let (local _6_1064 : Uint256) = u256_add(var_params_mpos, _5_1063)
    local range_check_ptr = range_check_ptr
    let (local _7_1065 : Uint256) = read_from_memoryt_uint256(_6_1064)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local expr_3_1066 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3_1066 : Uint256) = __warp_block_39(expr_2_1062, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_5_1071 : Uint256 = _3_1060
    local _11_1072 : Uint256 = _4_1061
    let (local _mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_1061.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_3137_mpos : Uint256) = fun_getFirstPool(_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (
        local expr_3139_mpos : Uint256) = allocate_memory_struct_struct_SwapCallbackData_storage_ptr(
        )
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _12_1073 : Uint256) = u256_add(expr_3139_mpos, _3_1060)
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(_12_1073, expr_3137_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _13_1074 : Uint256 = Uint256(low=32, high=0)
    let (local _14_1075 : Uint256) = u256_add(expr_3139_mpos, _13_1074)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_14_1075, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1076 : Uint256) = convert_rational_0_by_1_to_uint160(_3_1060)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_6_1077 : Uint256) = fun_exactInputInternal(
        _7_1065, expr_3_1066, _15_1076, expr_3139_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    write_to_memory_uint256(_6_1064, expr_6_1077)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local __warp_break_2 : Uint256, local __warp_leave_204 : Uint256,
        local var_amountOut_1056 : Uint256, local var_payer : Uint256) = __warp_block_43(
        _4_1061,
        _6_1064,
        __warp_break_2,
        __warp_leave_204,
        expr_2_1062,
        var_amountOut_1056,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_204.low + __warp_leave_204.high != 0:
        return (__warp_break_2, var_amountOut_1056, var_payer)
    else:
        return (__warp_break_2, var_amountOut_1056, var_payer)
    end
end

func __warp_loop_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_params_mpos : Uint256, var_payer : Uint256) -> (
        var_amountOut_1056 : Uint256, var_payer : Uint256):
    alloc_locals
    local __warp_break_2 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_break_2 : Uint256, local var_amountOut_1056 : Uint256,
        local var_payer : Uint256) = __warp_loop_body_2(__warp_break_2, var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    if __warp_break_2.low + __warp_break_2.high != 0:
        return (var_amountOut_1056, var_payer)
    end
    let (local var_amountOut_1056 : Uint256, local var_payer : Uint256) = __warp_loop_2(
        var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_amountOut_1056, var_payer)
end

func fun_exactInput_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1055 : Uint256, var_params_mpos : Uint256) -> (var_amountOut_1056 : Uint256):
    alloc_locals
    local var_amountOut_1056 : Uint256 = _1_1055
    let (local expr_1057 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    local var_payer : Uint256 = expr_1057
    let (local var_amountOut_1056 : Uint256, local var_payer : Uint256) = __warp_loop_2(
        var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _17_1080 : Uint256 = Uint256(low=128, high=0)
    let (local _18_1081 : Uint256) = u256_add(var_params_mpos, _17_1080)
    local range_check_ptr = range_check_ptr
    let (local _19_1082 : Uint256) = read_from_memoryt_uint256(_18_1081)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _20_1083 : Uint256) = cleanup_uint256(_19_1082)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _21_1084 : Uint256) = cleanup_uint256(var_amountOut_1056)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _22_1085 : Uint256) = is_lt(_21_1084, _20_1083)
    local range_check_ptr = range_check_ptr
    let (local expr_8_1086 : Uint256) = is_zero(_22_1085)
    local range_check_ptr = range_check_ptr
    require_helper(expr_8_1086)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountOut_1056)
end

func modifier_checkDeadline_3101{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amountOut_1852 : Uint256, var_params_mpos_1853 : Uint256) -> (_1_1854 : Uint256):
    alloc_locals
    local _2_1855 : Uint256 = Uint256(low=64, high=0)
    let (local _3_1856 : Uint256) = u256_add(var_params_mpos_1853, _2_1855)
    local range_check_ptr = range_check_ptr
    let (local _4_1857 : Uint256) = read_from_memoryt_uint256(_3_1856)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_1858 : Uint256) = fun_blockTimestamp()
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1859 : Uint256) = cleanup_uint256(_4_1857)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1860 : Uint256) = cleanup_uint256(expr_1858)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_1861 : Uint256) = is_gt(_6_1860, _5_1859)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1862 : Uint256) = is_zero(_7_1861)
    local range_check_ptr = range_check_ptr
    require_helper(expr_1_1862)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1854 : Uint256) = fun_exactInput_dynArgs_inner(
        var_amountOut_1852, var_params_mpos_1853)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1854)
end

func fun_exactInput_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3095_mpos : Uint256) -> (var_amountOut_1053 : Uint256):
    alloc_locals
    let (local zero_uint256_1054 : Uint256) = zero_value_for_split_uint256()
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountOut_1053 : Uint256) = modifier_checkDeadline_3101(
        zero_uint256_1054, var_params_3095_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountOut_1053)
end

func getter_fun_I_am_a_mistake{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1796 : Uint256):
    alloc_locals
    let (res) = I_am_a_mistake.read()
    return (res)
end

func getter_fun_seaplusplus{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1814 : Uint256):
    alloc_locals
    let (res) = seaplusplus.read()
    return (res)
end

func abi_decode_int256{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_60 : Uint256, end_61 : Uint256) -> (value_62 : Uint256):
    alloc_locals
    let (local value_62 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_60.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    validator_revert_int256(value_62)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_62)
end

func abi_decode_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_35 : Uint256, end_36 : Uint256) -> (arrayPos_37 : Uint256, length_38 : Uint256):
    alloc_locals
    local _1_39 : Uint256 = Uint256(low=31, high=0)
    let (local _2_40 : Uint256) = u256_add(offset_35, _1_39)
    local range_check_ptr = range_check_ptr
    let (local _3_41 : Uint256) = slt(_2_40, end_36)
    local range_check_ptr = range_check_ptr
    let (local _4_42 : Uint256) = is_zero(_3_41)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_42)
    local exec_env : ExecutionEnvironment = exec_env
    let (local length_38 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_35.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_43 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_44 : Uint256) = is_gt(length_38, _5_43)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_44)
    local exec_env : ExecutionEnvironment = exec_env
    local _7_45 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos_37 : Uint256) = u256_add(offset_35, _7_45)
    local range_check_ptr = range_check_ptr
    local _8_46 : Uint256 = Uint256(low=1, high=0)
    let (local _9_47 : Uint256) = u256_mul(length_38, _8_46)
    local range_check_ptr = range_check_ptr
    let (local _10_48 : Uint256) = u256_add(arrayPos_37, _9_47)
    local range_check_ptr = range_check_ptr
    let (local _11_49 : Uint256) = is_gt(_10_48, end_36)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_11_49)
    local exec_env : ExecutionEnvironment = exec_env
    return (arrayPos_37, length_38)
end

func abi_decode_int256t_int256t_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_258 : Uint256, dataEnd_259 : Uint256) -> (
        value0_260 : Uint256, value1_261 : Uint256, value2_262 : Uint256, value3_263 : Uint256):
    alloc_locals
    local _1_264 : Uint256 = Uint256(low=96, high=0)
    let (local _2_265 : Uint256) = uint256_sub(dataEnd_259, headStart_258)
    local range_check_ptr = range_check_ptr
    let (local _3_266 : Uint256) = slt(_2_265, _1_264)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_266)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_267 : Uint256 = Uint256(low=0, high=0)
    let (local _4_268 : Uint256) = u256_add(headStart_258, offset_267)
    local range_check_ptr = range_check_ptr
    let (local value0_260 : Uint256) = abi_decode_int256(_4_268, dataEnd_259)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_269 : Uint256 = Uint256(low=32, high=0)
    let (local _5_270 : Uint256) = u256_add(headStart_258, offset_1_269)
    local range_check_ptr = range_check_ptr
    let (local value1_261 : Uint256) = abi_decode_int256(_5_270, dataEnd_259)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_271 : Uint256 = Uint256(low=64, high=0)
    let (local _7_272 : Uint256) = u256_add(headStart_258, _6_271)
    local range_check_ptr = range_check_ptr
    let (local offset_2_273 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_7_272.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_274 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _9_275 : Uint256) = is_gt(offset_2_273, _8_274)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_9_275)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _10_276 : Uint256) = u256_add(headStart_258, offset_2_273)
    local range_check_ptr = range_check_ptr
    let (local value2_262 : Uint256, local value3_263 : Uint256) = abi_decode_bytes_calldata(
        _10_276, dataEnd_259)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_260, value1_261, value2_262, value3_263)
end

func convert_rational_by_to_int256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_859 : Uint256) -> (converted_860 : Uint256):
    alloc_locals
    let (local converted_860 : Uint256) = cleanup_int256(value_859)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_860)
end

func abi_decode_struct_SwapCallbackData{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_121 : Uint256, end_122 : Uint256) -> (value_123 : Uint256):
    alloc_locals
    local _1_124 : Uint256 = Uint256(low=64, high=0)
    let (local _2_125 : Uint256) = uint256_sub(end_122, headStart_121)
    local range_check_ptr = range_check_ptr
    let (local _3_126 : Uint256) = slt(_2_125, _1_124)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_126)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_127 : Uint256 = _1_124
    let (local value_123 : Uint256) = allocate_memory(_1_124)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_128 : Uint256 = Uint256(low=0, high=0)
    let (local _6_129 : Uint256) = u256_add(headStart_121, _5_128)
    local range_check_ptr = range_check_ptr
    let (local offset_130 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_6_129.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_131 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_132 : Uint256) = is_gt(offset_130, _7_131)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_132)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_133 : Uint256) = u256_add(headStart_121, offset_130)
    local range_check_ptr = range_check_ptr
    let (local _10_134 : Uint256) = abi_decode_bytes(_9_133, end_122)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_135 : Uint256 = _5_128
    let (local _12_136 : Uint256) = u256_add(value_123, _5_128)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_136.low, value=_10_134)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local offset_1_137 : Uint256 = Uint256(low=32, high=0)
    let (local _13_138 : Uint256) = u256_add(headStart_121, offset_1_137)
    local range_check_ptr = range_check_ptr
    let (local _14_139 : Uint256) = abi_decode_address(_13_138, end_122)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _15_140 : Uint256) = u256_add(value_123, offset_1_137)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_15_140.low, value=_14_139)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (value_123)
end

func abi_decode_struct_SwapCallbackData_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_329 : Uint256, dataEnd_330 : Uint256) -> (value0_331 : Uint256):
    alloc_locals
    local _1_332 : Uint256 = Uint256(low=32, high=0)
    let (local _2_333 : Uint256) = uint256_sub(dataEnd_330, headStart_329)
    local range_check_ptr = range_check_ptr
    let (local _3_334 : Uint256) = slt(_2_333, _1_332)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_334)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_335 : Uint256 = Uint256(low=0, high=0)
    let (local _5_336 : Uint256) = u256_add(headStart_329, _4_335)
    local range_check_ptr = range_check_ptr
    let (local offset_337 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_336.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_338 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_339 : Uint256) = is_gt(offset_337, _6_338)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_339)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_340 : Uint256) = u256_add(headStart_329, offset_337)
    local range_check_ptr = range_check_ptr
    let (local value0_331 : Uint256) = abi_decode_struct_SwapCallbackData(_8_340, dataEnd_330)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_331)
end

func fun_verifyCallback_2694{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_factory_1789 : Uint256, var_poolKey_mpos : Uint256) -> (
        var_pool_2671_address : Uint256):
    alloc_locals
    let (local expr_1790 : Uint256) = fun_computeAddress(var_factory_1789, var_poolKey_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2680_address : Uint256) = convert_address_to_contract_IUniswapV3Pool(expr_1790)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_pool_2671_address : Uint256 = expr_2680_address
    let (local expr_1_1791 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_2_1792 : Uint256) = convert_contract_IUniswapV3Pool_to_address(
        expr_2680_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1793 : Uint256) = cleanup_address(expr_2_1792)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1794 : Uint256) = cleanup_address(expr_1_1791)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1795 : Uint256) = is_eq(_2_1794, _1_1793)
    local range_check_ptr = range_check_ptr
    require_helper(expr_3_1795)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_pool_2671_address)
end

func fun_verifyCallback{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_factory_1785 : Uint256, var_tokenA_1786 : Uint256, var_tokenB_1787 : Uint256,
        var_fee_1788 : Uint256) -> (var_pool_address : Uint256):
    alloc_locals
    let (local expr_2658_mpos : Uint256) = fun_getPoolKey(
        var_tokenA_1786, var_tokenB_1787, var_fee_1788)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2659_address : Uint256) = fun_verifyCallback_2694(
        var_factory_1785, expr_2658_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var_pool_address : Uint256 = expr_2659_address
    return (var_pool_address)
end

func abi_encode_address_address_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_519 : Uint256, value0_520 : Uint256, value1_521 : Uint256,
        value2_522 : Uint256) -> (tail_523 : Uint256):
    alloc_locals
    local _1_524 : Uint256 = Uint256(low=96, high=0)
    let (local tail_523 : Uint256) = u256_add(headStart_519, _1_524)
    local range_check_ptr = range_check_ptr
    local _2_525 : Uint256 = Uint256(low=0, high=0)
    let (local _3_526 : Uint256) = u256_add(headStart_519, _2_525)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_520, _3_526)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_527 : Uint256 = Uint256(low=32, high=0)
    let (local _5_528 : Uint256) = u256_add(headStart_519, _4_527)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_521, _5_528)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_529 : Uint256 = Uint256(low=64, high=0)
    let (local _7_530 : Uint256) = u256_add(headStart_519, _6_529)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_522, _7_530)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_523)
end

func validator_revert_bool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_2033 : Uint256) -> ():
    alloc_locals
    let (local _1_2034 : Uint256) = cleanup_bool(value_2033)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_2035 : Uint256) = is_eq(value_2033, _1_2034)
    local range_check_ptr = range_check_ptr
    let (local _3_2036 : Uint256) = is_zero(_2_2035)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_2036)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_t_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_29 : Uint256, end_30 : Uint256) -> (value_31 : Uint256):
    alloc_locals
    let (local value_31 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset_29.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    validator_revert_bool(value_31)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_31)
end

func abi_decode_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_239 : Uint256, dataEnd_240 : Uint256) -> (value0_241 : Uint256):
    alloc_locals
    local _1_242 : Uint256 = Uint256(low=32, high=0)
    let (local _2_243 : Uint256) = uint256_sub(dataEnd_240, headStart_239)
    local range_check_ptr = range_check_ptr
    let (local _3_244 : Uint256) = slt(_2_243, _1_242)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_244)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_245 : Uint256 = Uint256(low=0, high=0)
    let (local _4_246 : Uint256) = u256_add(headStart_239, offset_245)
    local range_check_ptr = range_check_ptr
    let (local value0_241 : Uint256) = abi_decode_t_bool_fromMemory(_4_246, dataEnd_240)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_241)
end

func __warp_block_48{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1342 : Uint256, expr_1437_component_2_mpos : Uint256) -> (expr_5_1363 : Uint256):
    alloc_locals
    let (local _19_1365 : Uint256) = array_length_bytes(expr_1437_component_2_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _20_1366 : Uint256 = _1_1342
    let (local _21_1367 : Uint256) = u256_add(expr_1437_component_2_mpos, _1_1342)
    local range_check_ptr = range_check_ptr
    let (local _22_1368 : Uint256) = u256_add(_21_1367, _19_1365)
    local range_check_ptr = range_check_ptr
    local _23_1369 : Uint256 = _1_1342
    local _24_1370 : Uint256 = _21_1367
    let (local expr_6_1371 : Uint256) = abi_decode_bool_fromMemory(_21_1367, _22_1368)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_5_1363 : Uint256 = expr_6_1371
    return (expr_5_1363)
end

func __warp_if_22{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1364 : Uint256, _1_1342 : Uint256, expr_1437_component_2_mpos : Uint256,
        expr_5_1363 : Uint256) -> (expr_5_1363 : Uint256):
    alloc_locals
    if _18_1364.low + _18_1364.high != 0:
        let (local expr_5_1363 : Uint256) = __warp_block_48(_1_1342, expr_1437_component_2_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_5_1363)
    else:
        return (expr_5_1363)
    end
end

func __warp_block_47{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1353 : Uint256, _1_1342 : Uint256, expr_1437_component_2_mpos : Uint256) -> (
        expr_1_1357 : Uint256):
    alloc_locals
    let (local expr_2_1358 : Uint256) = array_length_bytes(expr_1437_component_2_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3_1359 : Uint256 = _12_1353
    let (local _16_1360 : Uint256) = convert_rational_0_by_1_to_uint256(_12_1353)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1361 : Uint256) = cleanup_uint256(expr_2_1358)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_4_1362 : Uint256) = is_eq(_17_1361, _16_1360)
    local range_check_ptr = range_check_ptr
    local expr_5_1363 : Uint256 = expr_4_1362
    let (local _18_1364 : Uint256) = is_zero(expr_4_1362)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1363 : Uint256) = __warp_if_22(
        _18_1364, _1_1342, expr_1437_component_2_mpos, expr_5_1363)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1_1357 : Uint256 = expr_5_1363
    return (expr_1_1357)
end

func __warp_if_21{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1353 : Uint256, _1_1342 : Uint256, expr_1437_component : Uint256,
        expr_1437_component_2_mpos : Uint256, expr_1_1357 : Uint256) -> (expr_1_1357 : Uint256):
    alloc_locals
    if expr_1437_component.low + expr_1437_component.high != 0:
        let (local expr_1_1357 : Uint256) = __warp_block_47(
            _12_1353, _1_1342, expr_1437_component_2_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1357)
    else:
        return (expr_1_1357)
    end
end

func fun_safeTransferFrom{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1338 : Uint256, var_from : Uint256, var_to_1339 : Uint256,
        var_value_1340 : Uint256) -> ():
    alloc_locals
    let (local expr_1341 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_1436_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _1_1342 : Uint256 = Uint256(low=32, high=0)
    let (local _2_1343 : Uint256) = u256_add(expr_1436_mpos, _1_1342)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_1343.low, value=expr_1341)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_1344 : Uint256 = Uint256(low=4, high=0)
    let (local _2_1343 : Uint256) = u256_add(_2_1343, _3_1344)
    local range_check_ptr = range_check_ptr
    let (local _4_1345 : Uint256) = abi_encode_address_address_uint256(
        _2_1343, var_from, var_to_1339, var_value_1340)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1346 : Uint256 = _1_1342
    let (local _6_1347 : Uint256) = u256_add(expr_1436_mpos, _1_1342)
    local range_check_ptr = range_check_ptr
    let (local _7_1348 : Uint256) = uint256_sub(_4_1345, _6_1347)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_1436_mpos.low, value=_7_1348)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _8_1349 : Uint256) = uint256_sub(_4_1345, expr_1436_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_1436_mpos, _8_1349)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _9_1350 : Uint256 = _1_1342
    local _10_1351 : Uint256 = _6_1347
    let (local _11_1352 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1436_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _12_1353 : Uint256 = Uint256(low=0, high=0)
    local _13_1354 : Uint256 = _12_1353
    local _14_1355 : Uint256 = _12_1353
    let (local _15_1356 : Uint256) = __warp_holder()
    let (local expr_1437_component : Uint256) = __warp_holder()
    let (local expr_1437_component_2_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1_1357 : Uint256 = expr_1437_component
    let (local expr_1_1357 : Uint256) = __warp_if_21(
        _12_1353, _1_1342, expr_1437_component, expr_1437_component_2_mpos, expr_1_1357)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    require_helper(expr_1_1357)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_599 : Uint256, value0_600 : Uint256, value1_601 : Uint256) -> (
        tail_602 : Uint256):
    alloc_locals
    local _1_603 : Uint256 = Uint256(low=64, high=0)
    let (local tail_602 : Uint256) = u256_add(headStart_599, _1_603)
    local range_check_ptr = range_check_ptr
    local _2_604 : Uint256 = Uint256(low=0, high=0)
    let (local _3_605 : Uint256) = u256_add(headStart_599, _2_604)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_600, _3_605)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_606 : Uint256 = Uint256(low=32, high=0)
    let (local _5_607 : Uint256) = u256_add(headStart_599, _4_606)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value1_601, _5_607)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_602)
end

func __warp_block_50{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1376 : Uint256, expr_component_mpos : Uint256) -> (expr_5_1397 : Uint256):
    alloc_locals
    let (local _19_1399 : Uint256) = array_length_bytes(expr_component_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _20_1400 : Uint256 = _1_1376
    let (local _21_1401 : Uint256) = u256_add(expr_component_mpos, _1_1376)
    local range_check_ptr = range_check_ptr
    let (local _22_1402 : Uint256) = u256_add(_21_1401, _19_1399)
    local range_check_ptr = range_check_ptr
    local _23_1403 : Uint256 = _1_1376
    local _24_1404 : Uint256 = _21_1401
    let (local expr_6_1405 : Uint256) = abi_decode_bool_fromMemory(_21_1401, _22_1402)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_5_1397 : Uint256 = expr_6_1405
    return (expr_5_1397)
end

func __warp_if_24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1398 : Uint256, _1_1376 : Uint256, expr_5_1397 : Uint256,
        expr_component_mpos : Uint256) -> (expr_5_1397 : Uint256):
    alloc_locals
    if _18_1398.low + _18_1398.high != 0:
        let (local expr_5_1397 : Uint256) = __warp_block_50(_1_1376, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_5_1397)
    else:
        return (expr_5_1397)
    end
end

func __warp_block_49{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1387 : Uint256, _1_1376 : Uint256, expr_component_mpos : Uint256) -> (
        expr_1_1391 : Uint256):
    alloc_locals
    let (local expr_2_1392 : Uint256) = array_length_bytes(expr_component_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3_1393 : Uint256 = _12_1387
    let (local _16_1394 : Uint256) = convert_rational_0_by_1_to_uint256(_12_1387)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1395 : Uint256) = cleanup_uint256(expr_2_1392)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_4_1396 : Uint256) = is_eq(_17_1395, _16_1394)
    local range_check_ptr = range_check_ptr
    local expr_5_1397 : Uint256 = expr_4_1396
    let (local _18_1398 : Uint256) = is_zero(expr_4_1396)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1397 : Uint256) = __warp_if_24(
        _18_1398, _1_1376, expr_5_1397, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1_1391 : Uint256 = expr_5_1397
    return (expr_1_1391)
end

func __warp_if_23{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1387 : Uint256, _1_1376 : Uint256, expr_1481_component : Uint256,
        expr_1_1391 : Uint256, expr_component_mpos : Uint256) -> (expr_1_1391 : Uint256):
    alloc_locals
    if expr_1481_component.low + expr_1481_component.high != 0:
        let (local expr_1_1391 : Uint256) = __warp_block_49(_12_1387, _1_1376, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1391)
    else:
        return (expr_1_1391)
    end
end

func fun_safeTransfer{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1372 : Uint256, var_to_1373 : Uint256, var_value_1374 : Uint256) -> ():
    alloc_locals
    let (local expr_1375 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_1480_mpos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _1_1376 : Uint256 = Uint256(low=32, high=0)
    let (local _2_1377 : Uint256) = u256_add(expr_1480_mpos, _1_1376)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_1377.low, value=expr_1375)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_1378 : Uint256 = Uint256(low=4, high=0)
    let (local _2_1377 : Uint256) = u256_add(_2_1377, _3_1378)
    local range_check_ptr = range_check_ptr
    let (local _4_1379 : Uint256) = abi_encode_address_uint256(_2_1377, var_to_1373, var_value_1374)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1380 : Uint256 = _1_1376
    let (local _6_1381 : Uint256) = u256_add(expr_1480_mpos, _1_1376)
    local range_check_ptr = range_check_ptr
    let (local _7_1382 : Uint256) = uint256_sub(_4_1379, _6_1381)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_1480_mpos.low, value=_7_1382)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _8_1383 : Uint256) = uint256_sub(_4_1379, expr_1480_mpos)
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_1480_mpos, _8_1383)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _9_1384 : Uint256 = _1_1376
    local _10_1385 : Uint256 = _6_1381
    let (local _11_1386 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1480_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _12_1387 : Uint256 = Uint256(low=0, high=0)
    local _13_1388 : Uint256 = _12_1387
    local _14_1389 : Uint256 = _12_1387
    let (local _15_1390 : Uint256) = __warp_holder()
    let (local expr_1481_component : Uint256) = __warp_holder()
    let (local expr_component_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1_1391 : Uint256 = expr_1481_component
    let (local expr_1_1391 : Uint256) = __warp_if_23(
        _12_1387, _1_1376, expr_1481_component, expr_1_1391, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    require_helper(expr_1_1391)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_51{exec_env : ExecutionEnvironment, range_check_ptr}(var_value : Uint256) -> (
        expr_1_1280 : Uint256):
    alloc_locals
    let (local expr_1715_address : Uint256) = __warp_holder()
    let (local expr_2_1281 : Uint256) = convert_contract_PeripheryPayments_to_address(
        expr_1715_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3_1282 : Uint256) = __warp_holder()
    let (local _4_1283 : Uint256) = cleanup_uint256(var_value)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1284 : Uint256) = cleanup_uint256(expr_3_1282)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1285 : Uint256) = is_lt(_5_1284, _4_1283)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1286 : Uint256) = is_zero(_6_1285)
    local range_check_ptr = range_check_ptr
    local expr_1_1280 : Uint256 = expr_4_1286
    return (expr_1_1280)
end

func __warp_if_25{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1279 : Uint256, expr_1_1280 : Uint256, var_value : Uint256) -> (expr_1_1280 : Uint256):
    alloc_locals
    if expr_1279.low + expr_1279.high != 0:
        let (local expr_1_1280 : Uint256) = __warp_block_51(var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_1_1280)
    else:
        return (expr_1_1280)
    end
end

func __warp_if_27{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        fun_safeTransferFrom(var_token, var_payer_1274, var_recipient_1275, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        fun_safeTransfer(var_token, var_recipient_1275, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    end
end

func __warp_block_56{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_27(__warp_subexpr_0, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_55{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_6_1290 : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = expr_6_1290
    __warp_block_56(match_var, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_54{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_payer_1274 : Uint256, var_recipient_1275 : Uint256, var_token : Uint256,
        var_value : Uint256) -> ():
    alloc_locals
    let (local expr_1741_address : Uint256) = __warp_holder()
    let (local expr_5_1287 : Uint256) = convert_contract_PeripheryPayments_to_address(
        expr_1741_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _7_1288 : Uint256) = cleanup_address(expr_5_1287)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_1289 : Uint256) = cleanup_address(var_payer_1274)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_6_1290 : Uint256) = is_eq(_8_1289, _7_1288)
    local range_check_ptr = range_check_ptr
    __warp_block_55(expr_6_1290, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_58{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1292 : Uint256) -> ():
    alloc_locals
    let (local _22_1302 : Uint256) = __warp_holder()
    finalize_allocation(_12_1292, _22_1302)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1303 : Uint256) = __warp_holder()
    let (local _24_1304 : Uint256) = u256_add(_12_1292, _23_1303)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_12_1292, _24_1304)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_28{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1292 : Uint256, _20_1300 : Uint256) -> ():
    alloc_locals
    if _20_1300.low + _20_1300.high != 0:
        __warp_block_58(_12_1292)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_59{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _28_1306 : Uint256) -> (expr_7_1317 : Uint256):
    alloc_locals
    let (local _39_1318 : Uint256) = __warp_holder()
    finalize_allocation(_28_1306, _39_1318)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _40_1319 : Uint256) = __warp_holder()
    let (local _41_1320 : Uint256) = u256_add(_28_1306, _40_1319)
    local range_check_ptr = range_check_ptr
    let (local expr_7_1317 : Uint256) = abi_decode_bool_fromMemory(_28_1306, _41_1320)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_7_1317)
end

func __warp_if_29{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _28_1306 : Uint256, _37_1315 : Uint256, expr_7_1317 : Uint256) -> (expr_7_1317 : Uint256):
    alloc_locals
    if _37_1315.low + _37_1315.high != 0:
        let (local expr_7_1317 : Uint256) = __warp_block_59(_28_1306)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_7_1317)
    else:
        return (expr_7_1317)
    end
end

func __warp_block_57{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_recipient_1275 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _9_1291 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1723_address : Uint256) = convert_address_to_contract_IWETH9(_9_1291)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1724_address : Uint256) = convert_contract_IWETH9_to_address(expr_1723_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1724_functionSelector : Uint256 = Uint256(low=3504541104, high=0)
    let (local _12_1292 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _13_1293 : Uint256) = shift_left_224(expr_1724_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_12_1292.low, value=_13_1293)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _14_1294 : Uint256 = Uint256(low=4, high=0)
    let (local _15_1295 : Uint256) = u256_add(_12_1292, _14_1294)
    local range_check_ptr = range_check_ptr
    let (local _16_1296 : Uint256) = abi_encode_tuple(_15_1295)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _17_1297 : Uint256 = Uint256(low=0, high=0)
    let (local _18_1298 : Uint256) = uint256_sub(_16_1296, _12_1292)
    local range_check_ptr = range_check_ptr
    let (local _19_1299 : Uint256) = __warp_holder()
    let (local _20_1300 : Uint256) = __warp_holder()
    let (local _21_1301 : Uint256) = is_zero(_20_1300)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_21_1301)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_28(_12_1292, _20_1300)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25_1305 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1731_address : Uint256) = convert_address_to_contract_IWETH9(_25_1305)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1732_address : Uint256) = convert_contract_IWETH9_to_address(expr_1731_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1732_functionSelector : Uint256 = Uint256(low=2835717307, high=0)
    let (local _28_1306 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _29_1307 : Uint256) = shift_left_224(expr_1732_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_28_1306.low, value=_29_1307)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _30_1308 : Uint256 = _14_1294
    let (local _31_1309 : Uint256) = u256_add(_28_1306, _14_1294)
    local range_check_ptr = range_check_ptr
    let (local _32_1310 : Uint256) = abi_encode_address_uint256(
        _31_1309, var_recipient_1275, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _33_1311 : Uint256 = Uint256(low=32, high=0)
    let (local _34_1312 : Uint256) = uint256_sub(_32_1310, _28_1306)
    local range_check_ptr = range_check_ptr
    local _35_1313 : Uint256 = _17_1297
    let (local _36_1314 : Uint256) = __warp_holder()
    let (local _37_1315 : Uint256) = __warp_holder()
    let (local _38_1316 : Uint256) = is_zero(_37_1315)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_38_1316)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_7_1317 : Uint256 = Uint256(low=0, high=0)
    let (local expr_7_1317 : Uint256) = __warp_if_29(_28_1306, _37_1315, expr_7_1317)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_26{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        __warp_subexpr_0 : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_54(var_payer_1274, var_recipient_1275, var_token, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_57(var_recipient_1275, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_53{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        match_var : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_26(__warp_subexpr_0, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_52{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        expr_1_1280 : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = expr_1_1280
    __warp_block_53(match_var, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func fun_pay{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_token : Uint256, var_payer_1274 : Uint256, var_recipient_1275 : Uint256,
        var_value : Uint256) -> ():
    alloc_locals
    let (local _1_1276 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1277 : Uint256) = cleanup_address(_1_1276)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1278 : Uint256) = cleanup_address(var_token)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1279 : Uint256) = is_eq(_3_1278, _2_1277)
    local range_check_ptr = range_check_ptr
    local expr_1_1280 : Uint256 = expr_1279
    let (local expr_1_1280 : Uint256) = __warp_if_25(expr_1279, expr_1_1280, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    __warp_block_52(expr_1_1280, var_payer_1274, var_recipient_1275, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_60{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1655 : Uint256, var_amount1Delta : Uint256) -> (expr_2_1658 : Uint256):
    alloc_locals
    local _4_1660 : Uint256 = _1_1655
    let (local _5_1661 : Uint256) = cleanup_int256(var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_3_1662 : Uint256) = sgt(_5_1661, _1_1655)
    local range_check_ptr = range_check_ptr
    local expr_2_1658 : Uint256 = expr_3_1662
    return (expr_2_1658)
end

func __warp_if_30{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1655 : Uint256, _3_1659 : Uint256, expr_2_1658 : Uint256,
        var_amount1Delta : Uint256) -> (expr_2_1658 : Uint256):
    alloc_locals
    if _3_1659.low + _3_1659.high != 0:
        let (local expr_2_1658 : Uint256) = __warp_block_60(_1_1655, var_amount1Delta)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2_1658)
    else:
        return (expr_2_1658)
    end
end

func __warp_block_63{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1667 : Uint256):
    alloc_locals
    let (local _10_1668 : Uint256) = cleanup_address(expr_2853_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _11_1669 : Uint256) = cleanup_address(expr_2853_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_4_1670 : Uint256) = is_lt(_11_1669, _10_1668)
    local range_check_ptr = range_check_ptr
    let (local expr_5_1671 : Uint256) = convert_int256_to_uint256(var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_component_1667 : Uint256 = expr_4_1670
    local expr_2887_component : Uint256 = expr_5_1671
    return (expr_2887_component, expr_component_1667)
end

func __warp_block_64{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1667 : Uint256):
    alloc_locals
    let (local _12_1672 : Uint256) = cleanup_address(expr_2853_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _13_1673 : Uint256) = cleanup_address(expr_2853_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_6_1674 : Uint256) = is_lt(_13_1673, _12_1672)
    local range_check_ptr = range_check_ptr
    let (local expr_7_1675 : Uint256) = convert_int256_to_uint256(var_amount0Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_component_1667 : Uint256 = expr_6_1674
    local expr_2887_component : Uint256 = expr_7_1675
    return (expr_2887_component, expr_component_1667)
end

func __warp_if_31{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1667 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_2887_component : Uint256,
            local expr_component_1667 : Uint256) = __warp_block_63(
            expr_2853_component, expr_2853_component_1, var_amount1Delta)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2887_component, expr_component_1667)
    else:
        let (local expr_2887_component : Uint256,
            local expr_component_1667 : Uint256) = __warp_block_64(
            expr_2853_component, expr_2853_component_1, var_amount0Delta)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2887_component, expr_component_1667)
    end
end

func __warp_block_62{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256, match_var : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1667 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_2887_component : Uint256, local expr_component_1667 : Uint256) = __warp_if_31(
        __warp_subexpr_0,
        expr_2853_component,
        expr_2853_component_1,
        var_amount0Delta,
        var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2887_component, expr_component_1667)
end

func __warp_block_61{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1_1657 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1667 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_1_1657
    let (local expr_2887_component : Uint256,
        local expr_component_1667 : Uint256) = __warp_block_62(
        expr_2853_component, expr_2853_component_1, match_var, var_amount0Delta, var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2887_component, expr_component_1667)
end

func __warp_block_70{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    setter_fun_amountInCached(expr_2887_component)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14_1677 : Uint256 = Uint256(low=32, high=0)
    let (local _15_1678 : Uint256) = u256_add(expr_2842_mpos, _14_1677)
    local range_check_ptr = range_check_ptr
    let (local _16_1679 : Uint256) = read_from_memoryt_address(_15_1678)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_9_1680 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun_pay(expr_2853_component_1, _16_1679, expr_9_1680, expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_71{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    let (local _184_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_7_1664.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2910_mpos : Uint256) = fun_skipToken(_184_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_7_1664.low, value=expr_2910_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_10_1681 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _17_1682 : Uint256) = convert_rational_0_by_1_to_uint160(expr_1654)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _18_1683 : Uint256) = fun_exactOutputInternal(
        expr_2887_component, expr_10_1681, _17_1682, expr_2842_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    __warp_holder()
    return ()
end

func __warp_if_33{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, __warp_subexpr_0 : Uint256, expr_1654 : Uint256,
        expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_70(expr_2842_mpos, expr_2853_component_1, expr_2887_component)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_71(_7_1664, expr_1654, expr_2842_mpos, expr_2887_component)
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

func __warp_block_69{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_33(
        _7_1664,
        __warp_subexpr_0,
        expr_1654,
        expr_2842_mpos,
        expr_2853_component_1,
        expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_68{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256, expr_8_1676 : Uint256) -> (
        ):
    alloc_locals
    local match_var : Uint256 = expr_8_1676
    __warp_block_69(
        _7_1664, expr_1654, expr_2842_mpos, expr_2853_component_1, expr_2887_component, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_67{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
    alloc_locals
    let (local _174_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_7_1664.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_8_1676 : Uint256) = fun_hasMultiplePools(_174_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_block_68(
        _7_1664,
        expr_1654,
        expr_2842_mpos,
        expr_2853_component_1,
        expr_2887_component,
        expr_8_1676)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_72{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2887_component : Uint256) -> (
        ):
    alloc_locals
    local _19_1684 : Uint256 = Uint256(low=32, high=0)
    let (local _20_1685 : Uint256) = u256_add(expr_2842_mpos, _19_1684)
    local range_check_ptr = range_check_ptr
    let (local _21_1686 : Uint256) = read_from_memoryt_address(_20_1685)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_11_1687 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun_pay(expr_2853_component, _21_1686, expr_11_1687, expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_if_32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, __warp_subexpr_0 : Uint256, expr_1654 : Uint256,
        expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_67(
            _7_1664, expr_1654, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_72(expr_2842_mpos, expr_2853_component, expr_2887_component)
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

func __warp_block_66{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_32(
        _7_1664,
        __warp_subexpr_0,
        expr_1654,
        expr_2842_mpos,
        expr_2853_component,
        expr_2853_component_1,
        expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_65{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _7_1664 : Uint256, expr_1654 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256, expr_component_1667 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = expr_component_1667
    __warp_block_66(
        _7_1664,
        expr_1654,
        expr_2842_mpos,
        expr_2853_component,
        expr_2853_component_1,
        expr_2887_component,
        match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func fun_uniswapV3SwapCallback_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amount0Delta : Uint256, var_amount1Delta : Uint256, var__data_offset : Uint256,
        var_data_length : Uint256) -> ():
    alloc_locals
    local expr_1654 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1655 : Uint256) = convert_rational_by_to_int256(expr_1654)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1656 : Uint256) = cleanup_int256(var_amount0Delta)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1657 : Uint256) = sgt(_2_1656, _1_1655)
    local range_check_ptr = range_check_ptr
    local expr_2_1658 : Uint256 = expr_1_1657
    let (local _3_1659 : Uint256) = is_zero(expr_1_1657)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1658 : Uint256) = __warp_if_30(
        _1_1655, _3_1659, expr_2_1658, var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1658)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1663 : Uint256) = u256_add(var__data_offset, var_data_length)
    local range_check_ptr = range_check_ptr
    let (local expr_2842_mpos : Uint256) = abi_decode_struct_SwapCallbackData_memory_ptr(
        var__data_offset, _6_1663)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1664 : Uint256) = u256_add(expr_2842_mpos, expr_1654)
    local range_check_ptr = range_check_ptr
    let (local _159_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_7_1664.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2853_component : Uint256, local expr_2853_component_1 : Uint256,
        local expr_2853_component_2 : Uint256) = fun_decodeFirstPool(_159_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_1665 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_1666 : Uint256) = fun_verifyCallback(
        _8_1665, expr_2853_component, expr_2853_component_1, expr_2853_component_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    __warp_holder()
    local expr_component_1667 : Uint256 = Uint256(low=0, high=0)
    local expr_2887_component : Uint256 = Uint256(low=0, high=0)
    let (local expr_2887_component : Uint256,
        local expr_component_1667 : Uint256) = __warp_block_61(
        expr_1_1657,
        expr_2853_component,
        expr_2853_component_1,
        var_amount0Delta,
        var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    __warp_block_65(
        _7_1664,
        expr_1654,
        expr_2842_mpos,
        expr_2853_component,
        expr_2853_component_1,
        expr_2887_component,
        expr_component_1667)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_decode_uint256t_addresst_uint256t_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_360 : Uint256, dataEnd_361 : Uint256) -> (
        value0_362 : Uint256, value1_363 : Uint256, value2_364 : Uint256, value3_365 : Uint256):
    alloc_locals
    local _1_366 : Uint256 = Uint256(low=128, high=0)
    let (local _2_367 : Uint256) = uint256_sub(dataEnd_361, headStart_360)
    local range_check_ptr = range_check_ptr
    let (local _3_368 : Uint256) = slt(_2_367, _1_366)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_368)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_369 : Uint256 = Uint256(low=0, high=0)
    let (local _4_370 : Uint256) = u256_add(headStart_360, offset_369)
    local range_check_ptr = range_check_ptr
    let (local value0_362 : Uint256) = abi_decode_uint256(_4_370, dataEnd_361)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_371 : Uint256 = Uint256(low=32, high=0)
    let (local _5_372 : Uint256) = u256_add(headStart_360, offset_1_371)
    local range_check_ptr = range_check_ptr
    let (local value1_363 : Uint256) = abi_decode_address(_5_372, dataEnd_361)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_2_373 : Uint256 = Uint256(low=64, high=0)
    let (local _6_374 : Uint256) = u256_add(headStart_360, offset_2_373)
    local range_check_ptr = range_check_ptr
    let (local value2_364 : Uint256) = abi_decode_uint256(_6_374, dataEnd_361)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_3_375 : Uint256 = Uint256(low=96, high=0)
    let (local _7_376 : Uint256) = u256_add(headStart_360, offset_3_375)
    local range_check_ptr = range_check_ptr
    let (local value3_365 : Uint256) = abi_decode_address(_7_376, dataEnd_361)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_362, value1_363, value2_364, value3_365)
end

func convert_rational_100_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_867 : Uint256) -> (converted_868 : Uint256):
    alloc_locals
    let (local converted_868 : Uint256) = cleanup_uint256(value_867)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_868)
end

func convert_contract_PeripheryPaymentsWithFee_to_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(value_847 : Uint256) -> (
        converted_848 : Uint256):
    alloc_locals
    let (local converted_848 : Uint256) = convert_uint160_to_address(value_847)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_848)
end

func checked_mul_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_753 : Uint256, y_754 : Uint256) -> (product : Uint256):
    alloc_locals
    let (local x_753 : Uint256) = cleanup_uint256(x_753)
    local exec_env : ExecutionEnvironment = exec_env
    let (local y_754 : Uint256) = cleanup_uint256(y_754)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_755 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_756 : Uint256) = u256_div(_1_755, x_753)
    local range_check_ptr = range_check_ptr
    let (local _3_757 : Uint256) = is_gt(y_754, _2_756)
    local range_check_ptr = range_check_ptr
    let (local _4_758 : Uint256) = is_zero(x_753)
    local range_check_ptr = range_check_ptr
    let (local _5_759 : Uint256) = is_zero(_4_758)
    local range_check_ptr = range_check_ptr
    let (local _6_760 : Uint256) = uint256_and(_5_759, _3_757)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_760)
    local exec_env : ExecutionEnvironment = exec_env
    let (local product : Uint256) = u256_mul(x_753, y_754)
    local range_check_ptr = range_check_ptr
    return (product)
end

func checked_div_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_750 : Uint256, y_751 : Uint256) -> (r : Uint256):
    alloc_locals
    let (local x_750 : Uint256) = cleanup_uint256(x_750)
    local exec_env : ExecutionEnvironment = exec_env
    let (local y_751 : Uint256) = cleanup_uint256(y_751)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_752 : Uint256) = is_zero(y_751)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_752)
    local exec_env : ExecutionEnvironment = exec_env
    let (local r : Uint256) = u256_div(x_750, y_751)
    local range_check_ptr = range_check_ptr
    return (r)
end

func __warp_block_73{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (expr_2_1232 : Uint256, var_z : Uint256):
    alloc_locals
    let (local expr_3_1234 : Uint256) = checked_mul_uint256(var_x, var_y)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_z : Uint256 = expr_3_1234
    let (local expr_4_1235 : Uint256) = checked_div_uint256(expr_3_1234, var_x)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1236 : Uint256) = cleanup_uint256(var_y)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1237 : Uint256) = cleanup_uint256(expr_4_1235)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_5_1238 : Uint256) = is_eq(_5_1237, _4_1236)
    local range_check_ptr = range_check_ptr
    local expr_2_1232 : Uint256 = expr_5_1238
    return (expr_2_1232, var_z)
end

func __warp_if_34{exec_env : ExecutionEnvironment, range_check_ptr}(
        _3_1233 : Uint256, expr_2_1232 : Uint256, var_x : Uint256, var_y : Uint256,
        var_z : Uint256) -> (expr_2_1232 : Uint256, var_z : Uint256):
    alloc_locals
    if _3_1233.low + _3_1233.high != 0:
        let (local expr_2_1232 : Uint256, local var_z : Uint256) = __warp_block_73(var_x, var_y)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2_1232, var_z)
    else:
        return (expr_2_1232, var_z)
    end
end

func fun_mul{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (var_z : Uint256):
    alloc_locals
    let (local zero_uint256_1227 : Uint256) = zero_value_for_split_uint256()
    local exec_env : ExecutionEnvironment = exec_env
    local var_z : Uint256 = zero_uint256_1227
    local expr_1228 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1229 : Uint256) = convert_rational_0_by_1_to_uint256(expr_1228)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1230 : Uint256) = cleanup_uint256(var_x)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1231 : Uint256) = is_eq(_2_1230, _1_1229)
    local range_check_ptr = range_check_ptr
    local expr_2_1232 : Uint256 = expr_1_1231
    let (local _3_1233 : Uint256) = is_zero(expr_1_1231)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1232 : Uint256, local var_z : Uint256) = __warp_if_34(
        _3_1233, expr_2_1232, var_x, var_y, var_z)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1232)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_z)
end

func convert_rational_10000_by_1_to_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_865 : Uint256) -> (converted_866 : Uint256):
    alloc_locals
    let (local converted_866 : Uint256) = cleanup_uint256(value_865)
    local exec_env : ExecutionEnvironment = exec_env
    return (converted_866)
end

func __warp_block_74{exec_env : ExecutionEnvironment, range_check_ptr}(_2_1694 : Uint256) -> (
        expr_2_1696 : Uint256):
    alloc_locals
    local expr_3_1697 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1698 : Uint256) = convert_rational_100_by_1_to_uint256(expr_3_1697)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_1699 : Uint256 = _2_1694
    let (local _5_1700 : Uint256) = is_gt(_2_1694, _3_1698)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1701 : Uint256) = is_zero(_5_1700)
    local range_check_ptr = range_check_ptr
    local expr_2_1696 : Uint256 = expr_4_1701
    return (expr_2_1696)
end

func __warp_if_35{exec_env : ExecutionEnvironment, range_check_ptr}(
        _2_1694 : Uint256, expr_1_1695 : Uint256, expr_2_1696 : Uint256) -> (expr_2_1696 : Uint256):
    alloc_locals
    if expr_1_1695.low + expr_1_1695.high != 0:
        let (local expr_2_1696 : Uint256) = __warp_block_74(_2_1694)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2_1696)
    else:
        return (expr_2_1696)
    end
end

func __warp_block_75{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1704 : Uint256) -> (expr_6_1714 : Uint256):
    alloc_locals
    let (local _19_1715 : Uint256) = __warp_holder()
    finalize_allocation(_9_1704, _19_1715)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1716 : Uint256) = __warp_holder()
    let (local _21_1717 : Uint256) = u256_add(_9_1704, _20_1716)
    local range_check_ptr = range_check_ptr
    let (local expr_6_1714 : Uint256) = abi_decode_uint256_fromMemory(_9_1704, _21_1717)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_6_1714)
end

func __warp_if_36{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _17_1712 : Uint256, _9_1704 : Uint256, expr_6_1714 : Uint256) -> (expr_6_1714 : Uint256):
    alloc_locals
    if _17_1712.low + _17_1712.high != 0:
        let (local expr_6_1714 : Uint256) = __warp_block_75(_9_1704)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_6_1714)
    else:
        return (expr_6_1714)
    end
end

func __warp_block_77{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _30_1726 : Uint256) -> ():
    alloc_locals
    let (local _39_1735 : Uint256) = __warp_holder()
    finalize_allocation(_30_1726, _39_1735)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _40_1736 : Uint256) = __warp_holder()
    let (local _41_1737 : Uint256) = u256_add(_30_1726, _40_1736)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_30_1726, _41_1737)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_38{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _30_1726 : Uint256, _37_1733 : Uint256) -> ():
    alloc_locals
    if _37_1733.low + _37_1733.high != 0:
        __warp_block_77(_30_1726)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_if_39{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_11_1741 : Uint256, expr_12_1744 : Uint256, var_feeRecipient_1691 : Uint256) -> ():
    alloc_locals
    if expr_12_1744.low + expr_12_1744.high != 0:
        fun_safeTransferETH(var_feeRecipient_1691, expr_11_1741)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_76{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _11_1706 : Uint256, _1_1693 : Uint256, expr_1692 : Uint256, expr_6_1714 : Uint256,
        var_feeBips_1690 : Uint256, var_feeRecipient_1691 : Uint256,
        var_recipient_1689 : Uint256) -> ():
    alloc_locals
    let (local _27_1725 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1846_address : Uint256) = convert_address_to_contract_IWETH9(_27_1725)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1847_address : Uint256) = convert_contract_IWETH9_to_address(expr_1846_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1847_functionSelector : Uint256 = Uint256(low=773487949, high=0)
    let (local _30_1726 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _31_1727 : Uint256) = shift_left_224(expr_1847_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_30_1726.low, value=_31_1727)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _32_1728 : Uint256 = _11_1706
    let (local _33_1729 : Uint256) = u256_add(_30_1726, _11_1706)
    local range_check_ptr = range_check_ptr
    let (local _34_1730 : Uint256) = abi_encode_uint256(_33_1729, expr_6_1714)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35_1731 : Uint256) = uint256_sub(_34_1730, _30_1726)
    local range_check_ptr = range_check_ptr
    let (local _36_1732 : Uint256) = __warp_holder()
    let (local _37_1733 : Uint256) = __warp_holder()
    let (local _38_1734 : Uint256) = is_zero(_37_1733)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_38_1734)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_38(_30_1726, _37_1733)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_9_1738 : Uint256) = fun_mul(expr_6_1714, var_feeBips_1690)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_10_1739 : Uint256 = Uint256(low=10000, high=0)
    let (local _42_1740 : Uint256) = convert_rational_10000_by_1_to_uint256(expr_10_1739)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_11_1741 : Uint256) = checked_div_uint256(expr_9_1738, _42_1740)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _43_1742 : Uint256 = _1_1693
    let (local _44_1743 : Uint256) = cleanup_uint256(expr_11_1741)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_12_1744 : Uint256) = is_gt(_44_1743, _1_1693)
    local range_check_ptr = range_check_ptr
    __warp_if_39(expr_11_1741, expr_12_1744, var_feeRecipient_1691)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_13_1745 : Uint256) = checked_sub_uint256(expr_6_1714, expr_11_1741)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1689, expr_13_1745)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_37{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _11_1706 : Uint256, _1_1693 : Uint256, expr_1692 : Uint256, expr_6_1714 : Uint256,
        expr_8_1724 : Uint256, var_feeBips_1690 : Uint256, var_feeRecipient_1691 : Uint256,
        var_recipient_1689 : Uint256) -> ():
    alloc_locals
    if expr_8_1724.low + expr_8_1724.high != 0:
        __warp_block_76(
            _11_1706,
            _1_1693,
            expr_1692,
            expr_6_1714,
            var_feeBips_1690,
            var_feeRecipient_1691,
            var_recipient_1689)
        local exec_env : ExecutionEnvironment = exec_env
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

func fun_unwrapWETH9WithFee{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_amountMinimum_1688 : Uint256, var_recipient_1689 : Uint256, var_feeBips_1690 : Uint256,
        var_feeRecipient_1691 : Uint256) -> ():
    alloc_locals
    local expr_1692 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1693 : Uint256) = convert_rational_0_by_1_to_uint256(expr_1692)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1694 : Uint256) = cleanup_uint256(var_feeBips_1690)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1695 : Uint256) = is_gt(_2_1694, _1_1693)
    local range_check_ptr = range_check_ptr
    local expr_2_1696 : Uint256 = expr_1_1695
    let (local expr_2_1696 : Uint256) = __warp_if_35(_2_1694, expr_1_1695, expr_2_1696)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1696)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1702 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1827_address : Uint256) = convert_address_to_contract_IWETH9(_6_1702)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1828_address : Uint256) = convert_contract_IWETH9_to_address(expr_1827_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1828_functionSelector : Uint256 = Uint256(low=1889567281, high=0)
    let (local expr_1831_address : Uint256) = __warp_holder()
    let (local expr_5_1703 : Uint256) = convert_contract_PeripheryPaymentsWithFee_to_address(
        expr_1831_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _9_1704 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _10_1705 : Uint256) = shift_left_224(expr_1828_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_9_1704.low, value=_10_1705)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _11_1706 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1707 : Uint256) = u256_add(_9_1704, _11_1706)
    local range_check_ptr = range_check_ptr
    let (local _13_1708 : Uint256) = abi_encode_tuple_address(_12_1707, expr_5_1703)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_1709 : Uint256 = Uint256(low=32, high=0)
    let (local _15_1710 : Uint256) = uint256_sub(_13_1708, _9_1704)
    local range_check_ptr = range_check_ptr
    let (local _16_1711 : Uint256) = __warp_holder()
    let (local _17_1712 : Uint256) = __warp_holder()
    let (local _18_1713 : Uint256) = is_zero(_17_1712)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_18_1713)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_6_1714 : Uint256 = Uint256(low=0, high=0)
    let (local expr_6_1714 : Uint256) = __warp_if_36(_17_1712, _9_1704, expr_6_1714)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22_1718 : Uint256) = cleanup_uint256(var_amountMinimum_1688)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _23_1719 : Uint256) = cleanup_uint256(expr_6_1714)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _24_1720 : Uint256) = is_lt(_23_1719, _22_1718)
    local range_check_ptr = range_check_ptr
    let (local expr_7_1721 : Uint256) = is_zero(_24_1720)
    local range_check_ptr = range_check_ptr
    require_helper(expr_7_1721)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _25_1722 : Uint256 = _1_1693
    local _26_1723 : Uint256 = _23_1719
    let (local expr_8_1724 : Uint256) = is_gt(_23_1719, _1_1693)
    local range_check_ptr = range_check_ptr
    __warp_if_37(
        _11_1706,
        _1_1693,
        expr_1692,
        expr_6_1714,
        expr_8_1724,
        var_feeBips_1690,
        var_feeRecipient_1691,
        var_recipient_1689)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func convert_uint160_to_contract_IERC20{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_896 : Uint256) -> (converted_897 : Uint256):
    alloc_locals
    let (local converted_897 : Uint256) = convert_uint160_to_uint160(value_896)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_897)
end

func convert_address_to_contract_IERC20{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_822 : Uint256) -> (converted_823 : Uint256):
    alloc_locals
    let (local converted_823 : Uint256) = convert_uint160_to_contract_IERC20(value_822)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_823)
end

func convert_contract_IERC20_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_839 : Uint256) -> (converted_840 : Uint256):
    alloc_locals
    let (local converted_840 : Uint256) = convert_uint160_to_address(value_839)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_840)
end

func abi_encode_address_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_498 : Uint256, value0_499 : Uint256, value1_500 : Uint256) -> (
        tail_501 : Uint256):
    alloc_locals
    local _1_502 : Uint256 = Uint256(low=64, high=0)
    let (local tail_501 : Uint256) = u256_add(headStart_498, _1_502)
    local range_check_ptr = range_check_ptr
    local _2_503 : Uint256 = Uint256(low=0, high=0)
    let (local _3_504 : Uint256) = u256_add(headStart_498, _2_503)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_499, _3_504)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_505 : Uint256 = Uint256(low=32, high=0)
    let (local _5_506 : Uint256) = u256_add(headStart_498, _4_505)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_500, _5_506)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_501)
end

func __warp_block_78{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1409 : Uint256) -> (expr_2_1419 : Uint256):
    alloc_locals
    let (local _13_1420 : Uint256) = __warp_holder()
    finalize_allocation(_3_1409, _13_1420)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1421 : Uint256) = __warp_holder()
    let (local _15_1422 : Uint256) = u256_add(_3_1409, _14_1421)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1419 : Uint256) = abi_decode_uint256_fromMemory(_3_1409, _15_1422)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_2_1419)
end

func __warp_if_40{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_1417 : Uint256, _3_1409 : Uint256, expr_2_1419 : Uint256) -> (expr_2_1419 : Uint256):
    alloc_locals
    if _11_1417.low + _11_1417.high != 0:
        let (local expr_2_1419 : Uint256) = __warp_block_78(_3_1409)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_2_1419)
    else:
        return (expr_2_1419)
    end
end

func __warp_if_41{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        expr_4_1426 : Uint256, var_expiry : Uint256, var_nonce : Uint256, var_r : Uint256,
        var_s : Uint256, var_token_1406 : Uint256, var_v : Uint256) -> ():
    alloc_locals
    if expr_4_1426.low + expr_4_1426.high != 0:
        fun_selfPermitAllowed(var_token_1406, var_nonce, var_expiry, var_v, var_r, var_s)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func fun_selfPermitAllowedIfNecessary{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_token_1406 : Uint256, var_nonce : Uint256, var_expiry : Uint256, var_v : Uint256,
        var_r : Uint256, var_s : Uint256) -> ():
    alloc_locals
    let (local expr_2292_address : Uint256) = convert_address_to_contract_IERC20(var_token_1406)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2293_address : Uint256) = convert_contract_IERC20_to_address(expr_2292_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2293_functionSelector : Uint256 = Uint256(low=3714247998, high=0)
    let (local expr_1407 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_2298_address : Uint256) = __warp_holder()
    let (local expr_1_1408 : Uint256) = convert_contract_SelfPermit_to_address(expr_2298_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1409 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1410 : Uint256) = shift_left_224(expr_2293_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1409.low, value=_4_1410)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1411 : Uint256 = Uint256(low=4, high=0)
    let (local _6_1412 : Uint256) = u256_add(_3_1409, _5_1411)
    local range_check_ptr = range_check_ptr
    let (local _7_1413 : Uint256) = abi_encode_address_address(_6_1412, expr_1407, expr_1_1408)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1414 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1415 : Uint256) = uint256_sub(_7_1413, _3_1409)
    local range_check_ptr = range_check_ptr
    let (local _10_1416 : Uint256) = __warp_holder()
    let (local _11_1417 : Uint256) = __warp_holder()
    let (local _12_1418 : Uint256) = is_zero(_11_1417)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_1418)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_2_1419 : Uint256 = Uint256(low=0, high=0)
    let (local expr_2_1419 : Uint256) = __warp_if_40(_11_1417, _3_1409, expr_2_1419)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_3_1423 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _16_1424 : Uint256) = cleanup_uint256(expr_3_1423)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1425 : Uint256) = cleanup_uint256(expr_2_1419)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_4_1426 : Uint256) = is_lt(_17_1425, _16_1424)
    local range_check_ptr = range_check_ptr
    __warp_if_41(expr_4_1426, var_expiry, var_nonce, var_r, var_s, var_token_1406, var_v)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func convert_uint160_to_contract_IERC20Permit{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_894 : Uint256) -> (converted_895 : Uint256):
    alloc_locals
    let (local converted_895 : Uint256) = convert_uint160_to_uint160(value_894)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_895)
end

func convert_address_to_contract_IERC20Permit{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_820 : Uint256) -> (converted_821 : Uint256):
    alloc_locals
    let (local converted_821 : Uint256) = convert_uint160_to_contract_IERC20Permit(value_820)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_821)
end

func convert_contract_IERC20Permit_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_837 : Uint256) -> (converted_838 : Uint256):
    alloc_locals
    let (local converted_838 : Uint256) = convert_uint160_to_address(value_837)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_838)
end

func abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_556 : Uint256, value0_557 : Uint256, value1_558 : Uint256, value2_559 : Uint256,
        value3_560 : Uint256, value4_561 : Uint256, value5_562 : Uint256, value6_563 : Uint256) -> (
        tail_564 : Uint256):
    alloc_locals
    local _1_565 : Uint256 = Uint256(low=224, high=0)
    let (local tail_564 : Uint256) = u256_add(headStart_556, _1_565)
    local range_check_ptr = range_check_ptr
    local _2_566 : Uint256 = Uint256(low=0, high=0)
    let (local _3_567 : Uint256) = u256_add(headStart_556, _2_566)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_557, _3_567)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_568 : Uint256 = Uint256(low=32, high=0)
    let (local _5_569 : Uint256) = u256_add(headStart_556, _4_568)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_558, _5_569)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_570 : Uint256 = Uint256(low=64, high=0)
    let (local _7_571 : Uint256) = u256_add(headStart_556, _6_570)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_559, _7_571)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_572 : Uint256 = Uint256(low=96, high=0)
    let (local _9_573 : Uint256) = u256_add(headStart_556, _8_572)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value3_560, _9_573)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _10_574 : Uint256 = Uint256(low=128, high=0)
    let (local _11_575 : Uint256) = u256_add(headStart_556, _10_574)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value4_561, _11_575)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _12_576 : Uint256 = Uint256(low=160, high=0)
    let (local _13_577 : Uint256) = u256_add(headStart_556, _12_576)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value5_562, _13_577)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _14_578 : Uint256 = Uint256(low=192, high=0)
    let (local _15_579 : Uint256) = u256_add(headStart_556, _14_578)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6_563, _15_579)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_564)
end

func __warp_block_79{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1482 : Uint256) -> ():
    alloc_locals
    let (local _14_1493 : Uint256) = __warp_holder()
    finalize_allocation(_3_1482, _14_1493)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1494 : Uint256) = __warp_holder()
    let (local _16_1495 : Uint256) = u256_add(_3_1482, _15_1494)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_3_1482, _16_1495)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_42{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1491 : Uint256, _3_1482 : Uint256) -> ():
    alloc_locals
    if _12_1491.low + _12_1491.high != 0:
        __warp_block_79(_3_1482)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func fun_selfPermit{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_token_1474 : Uint256, var_value_1475 : Uint256, var_deadline_1476 : Uint256,
        var_v_1477 : Uint256, var_r_1478 : Uint256, var_s_1479 : Uint256) -> ():
    alloc_locals
    let (local expr_2183_address : Uint256) = convert_address_to_contract_IERC20Permit(
        var_token_1474)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2184_address : Uint256) = convert_contract_IERC20Permit_to_address(
        expr_2183_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2184_functionSelector : Uint256 = Uint256(low=3573918927, high=0)
    let (local expr_1480 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_2189_address : Uint256) = __warp_holder()
    let (local expr_1_1481 : Uint256) = convert_contract_SelfPermit_to_address(expr_2189_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1482 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1483 : Uint256) = shift_left_224(expr_2184_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1482.low, value=_4_1483)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1484 : Uint256 = Uint256(low=4, high=0)
    let (local _6_1485 : Uint256) = u256_add(_3_1482, _5_1484)
    local range_check_ptr = range_check_ptr
    let (
        local _7_1486 : Uint256) = abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32(
        _6_1485,
        expr_1480,
        expr_1_1481,
        var_value_1475,
        var_deadline_1476,
        var_v_1477,
        var_r_1478,
        var_s_1479)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1487 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1488 : Uint256) = uint256_sub(_7_1486, _3_1482)
    local range_check_ptr = range_check_ptr
    local _10_1489 : Uint256 = _8_1487
    let (local _11_1490 : Uint256) = __warp_holder()
    let (local _12_1491 : Uint256) = __warp_holder()
    let (local _13_1492 : Uint256) = is_zero(_12_1491)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_1492)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_42(_12_1491, _3_1482)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_80{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1457 : Uint256) -> (expr_2_1467 : Uint256):
    alloc_locals
    let (local _13_1468 : Uint256) = __warp_holder()
    finalize_allocation(_3_1457, _13_1468)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1469 : Uint256) = __warp_holder()
    let (local _15_1470 : Uint256) = u256_add(_3_1457, _14_1469)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1467 : Uint256) = abi_decode_uint256_fromMemory(_3_1457, _15_1470)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_2_1467)
end

func __warp_if_43{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_1465 : Uint256, _3_1457 : Uint256, expr_2_1467 : Uint256) -> (expr_2_1467 : Uint256):
    alloc_locals
    if _11_1465.low + _11_1465.high != 0:
        let (local expr_2_1467 : Uint256) = __warp_block_80(_3_1457)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_2_1467)
    else:
        return (expr_2_1467)
    end
end

func __warp_if_44{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        expr_3_1473 : Uint256, var_deadline : Uint256, var_r_1453 : Uint256, var_s_1454 : Uint256,
        var_token_1450 : Uint256, var_v_1452 : Uint256, var_value_1451 : Uint256) -> ():
    alloc_locals
    if expr_3_1473.low + expr_3_1473.high != 0:
        fun_selfPermit(
            var_token_1450, var_value_1451, var_deadline, var_v_1452, var_r_1453, var_s_1454)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func fun_selfPermitIfNecessary{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_token_1450 : Uint256, var_value_1451 : Uint256, var_deadline : Uint256,
        var_v_1452 : Uint256, var_r_1453 : Uint256, var_s_1454 : Uint256) -> ():
    alloc_locals
    let (local expr_2217_address : Uint256) = convert_address_to_contract_IERC20(var_token_1450)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2218_address : Uint256) = convert_contract_IERC20_to_address(expr_2217_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2218_functionSelector : Uint256 = Uint256(low=3714247998, high=0)
    let (local expr_1455 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local expr_2223_address : Uint256) = __warp_holder()
    let (local expr_1_1456 : Uint256) = convert_contract_SelfPermit_to_address(expr_2223_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1457 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1458 : Uint256) = shift_left_224(expr_2218_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1457.low, value=_4_1458)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1459 : Uint256 = Uint256(low=4, high=0)
    let (local _6_1460 : Uint256) = u256_add(_3_1457, _5_1459)
    local range_check_ptr = range_check_ptr
    let (local _7_1461 : Uint256) = abi_encode_address_address(_6_1460, expr_1455, expr_1_1456)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1462 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1463 : Uint256) = uint256_sub(_7_1461, _3_1457)
    local range_check_ptr = range_check_ptr
    let (local _10_1464 : Uint256) = __warp_holder()
    let (local _11_1465 : Uint256) = __warp_holder()
    let (local _12_1466 : Uint256) = is_zero(_11_1465)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_1466)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_2_1467 : Uint256 = Uint256(low=0, high=0)
    let (local expr_2_1467 : Uint256) = __warp_if_43(_11_1465, _3_1457, expr_2_1467)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1471 : Uint256) = cleanup_uint256(var_value_1451)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1472 : Uint256) = cleanup_uint256(expr_2_1467)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_3_1473 : Uint256) = is_lt(_17_1472, _16_1471)
    local range_check_ptr = range_check_ptr
    __warp_if_44(
        expr_3_1473,
        var_deadline,
        var_r_1453,
        var_s_1454,
        var_token_1450,
        var_v_1452,
        var_value_1451)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_decode_addresst_addresst_addresst_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_159 : Uint256, dataEnd_160 : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_161 : Uint256 = Uint256(low=128, high=0)
    let (local _2_162 : Uint256) = uint256_sub(dataEnd_160, headStart_159)
    local range_check_ptr = range_check_ptr
    let (local _3_163 : Uint256) = slt(_2_162, _1_161)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_163)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_164 : Uint256 = Uint256(low=0, high=0)
    let (local _4_165 : Uint256) = u256_add(headStart_159, offset_164)
    local range_check_ptr = range_check_ptr
    let (local value0 : Uint256) = abi_decode_address(_4_165, dataEnd_160)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_166 : Uint256 = Uint256(low=32, high=0)
    let (local _5_167 : Uint256) = u256_add(headStart_159, offset_1_166)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = abi_decode_address(_5_167, dataEnd_160)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_2_168 : Uint256 = Uint256(low=64, high=0)
    let (local _6_169 : Uint256) = u256_add(headStart_159, offset_2_168)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = abi_decode_address(_6_169, dataEnd_160)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_3_170 : Uint256 = Uint256(low=96, high=0)
    let (local _7_171 : Uint256) = u256_add(headStart_159, offset_3_170)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = abi_decode_address(_7_171, dataEnd_160)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0, value1, value2, value3)
end

func setter_fun_factory{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1997 : Uint256) -> ():
    alloc_locals
    factory.write(value_1997)
    return ()
end

func setter_fun_WETH9{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1985 : Uint256) -> ():
    alloc_locals
    WETH9.write(value_1985)
    return ()
end

func setter_fun_OCaml{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1982 : Uint256) -> ():
    alloc_locals
    OCaml.write(value_1982)
    return ()
end

func setter_fun_seaplusplus{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_2000 : Uint256) -> ():
    alloc_locals
    seaplusplus.write(value_2000)
    return ()
end

func setter_fun_I_am_a_mistake{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1979 : Uint256) -> ():
    alloc_locals
    I_am_a_mistake.write(value_1979)
    return ()
end

func setter_fun_succinctly{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_2003 : Uint256) -> ():
    alloc_locals
    succinctly.write(value_2003)
    return ()
end

func fun_warp_constructor{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var__factory : Uint256, var_WETH9 : Uint256, var_makeMeRich : Uint256,
        var_makeMePoor : Uint256) -> ():
    alloc_locals
    setter_fun_factory(var__factory)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_WETH9(var_WETH9)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_OCaml(var_makeMeRich)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_seaplusplus(var_makeMePoor)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_I_am_a_mistake(var_makeMePoor)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_succinctly(var_makeMeRich)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_15 : Uint256, end_16 : Uint256) -> (arrayPos : Uint256, length_17 : Uint256):
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=31, high=0)
    let (local _2_19 : Uint256) = u256_add(offset_15, _1_18)
    local range_check_ptr = range_check_ptr
    let (local _3_20 : Uint256) = slt(_2_19, end_16)
    local range_check_ptr = range_check_ptr
    let (local _4_21 : Uint256) = is_zero(_3_20)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_21)
    local exec_env : ExecutionEnvironment = exec_env
    let (local length_17 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_15.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_22 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_23 : Uint256) = is_gt(length_17, _5_22)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_23)
    local exec_env : ExecutionEnvironment = exec_env
    local _7_24 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos : Uint256) = u256_add(offset_15, _7_24)
    local range_check_ptr = range_check_ptr
    local _8_25 : Uint256 = _7_24
    let (local _9_26 : Uint256) = u256_mul(length_17, _7_24)
    local range_check_ptr = range_check_ptr
    let (local _10_27 : Uint256) = u256_add(arrayPos, _9_26)
    local range_check_ptr = range_check_ptr
    let (local _11_28 : Uint256) = is_gt(_10_27, end_16)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_11_28)
    local exec_env : ExecutionEnvironment = exec_env
    return (arrayPos, length_17)
end

func abi_decode_array_bytes_calldata_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_226 : Uint256, dataEnd_227 : Uint256) -> (
        value0_228 : Uint256, value1_229 : Uint256):
    alloc_locals
    local _1_230 : Uint256 = Uint256(low=32, high=0)
    let (local _2_231 : Uint256) = uint256_sub(dataEnd_227, headStart_226)
    local range_check_ptr = range_check_ptr
    let (local _3_232 : Uint256) = slt(_2_231, _1_230)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_232)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_233 : Uint256 = Uint256(low=0, high=0)
    let (local _5_234 : Uint256) = u256_add(headStart_226, _4_233)
    local range_check_ptr = range_check_ptr
    let (local offset_235 : Uint256) = calldata_load{
        range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_234.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_236 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_237 : Uint256) = is_gt(offset_235, _6_236)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_7_237)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_238 : Uint256) = u256_add(headStart_226, offset_235)
    local range_check_ptr = range_check_ptr
    let (local value0_228 : Uint256,
        local value1_229 : Uint256) = abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr(
        _8_238, dataEnd_227)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_228, value1_229)
end

func array_length_array_bytes_calldata_dyn_calldata(value_702 : Uint256, len : Uint256) -> (
        length_703 : Uint256):
    alloc_locals
    local length_703 : Uint256 = len
    return (length_703)
end

func array_allocation_size_array_bytes_dyn{exec_env : ExecutionEnvironment, range_check_ptr}(
        length_682 : Uint256) -> (size_683 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_684 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_685 : Uint256) = is_gt(length_682, _1_684)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_685)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_686 : Uint256 = Uint256(low=32, high=0)
    let (local size_683 : Uint256) = u256_mul(length_682, _3_686)
    local range_check_ptr = range_check_ptr
    local _4_687 : Uint256 = _3_686
    let (local size_683 : Uint256) = u256_add(size_683, _3_686)
    local range_check_ptr = range_check_ptr
    return (size_683)
end

func allocate_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_669 : Uint256) -> (memPtr_670 : Uint256):
    alloc_locals
    let (local allocSize : Uint256) = array_allocation_size_array_bytes_dyn(length_669)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPtr_670 : Uint256) = allocate_memory(allocSize)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_670.low, value=length_669)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_670)
end

func zero_value_for_bytes() -> (ret_2098 : Uint256):
    alloc_locals
    local ret_2098 : Uint256 = Uint256(low=96, high=0)
    return (ret_2098)
end

func __warp_loop_body_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_2086 : Uint256, i_2087 : Uint256) -> (i_2087 : Uint256):
    alloc_locals
    let (local _2_2089 : Uint256) = zero_value_for_bytes()
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_2090 : Uint256) = u256_add(dataStart_2086, i_2087)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_2090.low, value=_2_2089)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_2088 : Uint256 = Uint256(low=32, high=0)
    let (local i_2087 : Uint256) = u256_add(i_2087, _1_2088)
    local range_check_ptr = range_check_ptr
    return (i_2087)
end

func __warp_loop_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_2086 : Uint256, i_2087 : Uint256) -> (i_2087 : Uint256):
    alloc_locals
    let (local i_2087 : Uint256) = __warp_loop_body_5(dataStart_2086, i_2087)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i_2087 : Uint256) = __warp_loop_5(dataStart_2086, i_2087)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_2087)
end

func zero_complex_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_2086 : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    local i_2087 : Uint256 = Uint256(low=0, high=0)
    let (local i_2087 : Uint256) = __warp_loop_5(dataStart_2086, i_2087)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_and_zero_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_652 : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (local memPtr : Uint256) = allocate_memory_array_array_bytes_dyn(length_652)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local dataStart : Uint256 = memPtr
    let (local dataSize : Uint256) = array_allocation_size_array_bytes_dyn(length_652)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _1_653 : Uint256 = Uint256(low=32, high=0)
    let (local dataStart : Uint256) = u256_add(memPtr, _1_653)
    local range_check_ptr = range_check_ptr
    local _2_654 : Uint256 = _1_653
    let (local dataSize : Uint256) = uint256_sub(dataSize, _1_653)
    local range_check_ptr = range_check_ptr
    zero_complex_memory_array_array_bytes_dyn(dataStart, dataSize)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func convert_contract_Multicall_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_845 : Uint256) -> (converted_846 : Uint256):
    alloc_locals
    let (local converted_846 : Uint256) = convert_uint160_to_address(value_845)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (converted_846)
end

func calldata_array_index_access_bytes_calldata_dyn_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref_733 : Uint256, length_734 : Uint256, index : Uint256) -> (
        addr_735 : Uint256, len_736 : Uint256):
    alloc_locals
    let (local _1_737 : Uint256) = is_lt(index, length_734)
    local range_check_ptr = range_check_ptr
    let (local _2_738 : Uint256) = is_zero(_1_737)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_738)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_739 : Uint256 = Uint256(low=32, high=0)
    let (local _4_740 : Uint256) = u256_mul(index, _3_739)
    local range_check_ptr = range_check_ptr
    let (local addr_735 : Uint256) = u256_add(base_ref_733, _4_740)
    local range_check_ptr = range_check_ptr
    let (local addr_735 : Uint256, local len_736 : Uint256) = access_calldata_tail_bytes_calldata(
        base_ref_733, addr_735)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (addr_735, len_736)
end

func array_storeLengthForEncoding_bytes_nonPadded_inplace(
        pos_723 : Uint256, length_724 : Uint256) -> (updated_pos_725 : Uint256):
    alloc_locals
    local updated_pos_725 : Uint256 = pos_723
    return (updated_pos_725)
end

func abi_encode_bytes_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        start : Uint256, length_408 : Uint256, pos_409 : Uint256) -> (end_410 : Uint256):
    alloc_locals
    let (local pos_409 : Uint256) = array_storeLengthForEncoding_bytes_nonPadded_inplace(
        pos_409, length_408)
    local exec_env : ExecutionEnvironment = exec_env
    copy_calldata_to_memory(start, pos_409, length_408)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local end_410 : Uint256) = u256_add(pos_409, length_408)
    local range_check_ptr = range_check_ptr
    return (end_410)
end

func abi_encode_packed_bytes_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_480 : Uint256, value0_481 : Uint256, value1_482 : Uint256) -> (end_483 : Uint256):
    alloc_locals
    let (local pos_480 : Uint256) = abi_encode_bytes_calldata(value0_481, value1_482, pos_480)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local end_483 : Uint256 = pos_480
    return (end_483)
end

func array_length_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_704 : Uint256) -> (length_705 : Uint256):
    alloc_locals
    let (local length_705 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(value_704.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (length_705)
end

func memory_array_index_access_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef_1832 : Uint256, index_1833 : Uint256) -> (addr_1834 : Uint256):
    alloc_locals
    let (local _1_1835 : Uint256) = array_length_array_bytes_dyn(baseRef_1832)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1836 : Uint256) = is_lt(index_1833, _1_1835)
    local range_check_ptr = range_check_ptr
    let (local _3_1837 : Uint256) = is_zero(_2_1836)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_1837)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_1838 : Uint256 = Uint256(low=32, high=0)
    let (local offset_1839 : Uint256) = u256_mul(index_1833, _4_1838)
    local range_check_ptr = range_check_ptr
    local _5_1840 : Uint256 = _4_1838
    let (local offset_1839 : Uint256) = u256_add(offset_1839, _4_1838)
    local range_check_ptr = range_check_ptr
    let (local addr_1834 : Uint256) = u256_add(baseRef_1832, offset_1839)
    local range_check_ptr = range_check_ptr
    return (addr_1834)
end

func increment_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(value_1820 : Uint256) -> (
        ret_1821 : Uint256):
    alloc_locals
    let (local value_1820 : Uint256) = cleanup_uint256(value_1820)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_1822 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1823 : Uint256) = is_eq(value_1820, _1_1822)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_1823)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_1824 : Uint256 = Uint256(low=1, high=0)
    let (local ret_1821 : Uint256) = u256_add(value_1820, _3_1824)
    local range_check_ptr = range_check_ptr
    return (ret_1821)
end

func __warp_loop_body_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_break_3 : Uint256, expr_1239 : Uint256, expr_1991_mpos : Uint256,
        expr_1_1240 : Uint256, expr_2017_component_2_mpos : Uint256,
        var_data_1978_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_result_mpos : Uint256) -> (
        __warp_break_3 : Uint256, var_i : Uint256, var_result_mpos : Uint256):
    alloc_locals
    let (local _2_1242 : Uint256) = cleanup_uint256(expr_1239)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1243 : Uint256) = cleanup_uint256(var_i)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_2_1244 : Uint256) = is_lt(_3_1243, _2_1242)
    local range_check_ptr = range_check_ptr
    let (local _4_1245 : Uint256) = is_zero(expr_2_1244)
    local range_check_ptr = range_check_ptr
    if _4_1245.low + _4_1245.high != 0:
        local __warp_break_3 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_3, var_i, var_result_mpos)
    end
    let (local expr_2011_address : Uint256) = __warp_holder()
    let (local expr_3_1246 : Uint256) = convert_contract_Multicall_to_address(expr_2011_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2016_offset : Uint256,
        local expr_length : Uint256) = calldata_array_index_access_bytes_calldata_dyn_calldata(
        var_data_offset, var_data_1978_length, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_1247 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1248 : Uint256) = abi_encode_packed_bytes_calldata(
        _5_1247, expr_2016_offset, expr_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1249 : Uint256) = uint256_sub(_6_1248, _5_1247)
    local range_check_ptr = range_check_ptr
    let (local _8_1250 : Uint256) = __warp_holder()
    let (local expr_2017_component : Uint256) = __warp_holder()
    let (local expr_2017_component_2_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_result_mpos : Uint256 = expr_2017_component_2_mpos
    let (local _9_1251 : Uint256) = is_zero(expr_2017_component)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1252 : Uint256) = cleanup_bool(_9_1251)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    __warp_cond_revert(expr_4_1252)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _25_1271 : Uint256) = memory_array_index_access_bytes_dyn(expr_1991_mpos, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_25_1271.low, value=var_result_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _26_1272 : Uint256) = memory_array_index_access_bytes_dyn(expr_1991_mpos, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27_1273 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_26_1272.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    __warp_holder()
    let (local _1_1241 : Uint256) = increment_uint256(var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_i : Uint256 = _1_1241
    return (__warp_break_3, var_i, var_result_mpos)
end

func __warp_loop_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1239 : Uint256, expr_1991_mpos : Uint256, expr_1_1240 : Uint256,
        expr_2017_component_2_mpos : Uint256, var_data_1978_length : Uint256,
        var_data_offset : Uint256, var_i : Uint256, var_result_mpos : Uint256) -> (
        var_i : Uint256, var_result_mpos : Uint256):
    alloc_locals
    local __warp_break_3 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_break_3 : Uint256, local var_i : Uint256,
        local var_result_mpos : Uint256) = __warp_loop_body_3(
        __warp_break_3,
        expr_1239,
        expr_1991_mpos,
        expr_1_1240,
        expr_2017_component_2_mpos,
        var_data_1978_length,
        var_data_offset,
        var_i,
        var_result_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_break_3.low + __warp_break_3.high != 0:
        return (var_i, var_result_mpos)
    end
    let (local var_i : Uint256, local var_result_mpos : Uint256) = __warp_loop_3(
        expr_1239,
        expr_1991_mpos,
        expr_1_1240,
        expr_2017_component_2_mpos,
        var_data_1978_length,
        var_data_offset,
        var_i,
        var_result_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_i, var_result_mpos)
end

func fun_multicall_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_data_offset : Uint256, var_data_1978_length : Uint256) -> (var_results_mpos : Uint256):
    alloc_locals
    let (local expr_1239 : Uint256) = array_length_array_bytes_calldata_dyn_calldata(
        var_data_offset, var_data_1978_length)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1991_mpos : Uint256) = allocate_and_zero_memory_array_array_bytes_dyn(expr_1239)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_results_mpos : Uint256 = expr_1991_mpos
    local expr_1_1240 : Uint256 = Uint256(low=0, high=0)
    let (local var_i : Uint256) = convert_rational_0_by_1_to_uint256(expr_1_1240)
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_i : Uint256, local var_result_mpos : Uint256) = __warp_loop_3(
        expr_1239,
        expr_1991_mpos,
        expr_1_1240,
        expr_2017_component_2_mpos,
        var_data_1978_length,
        var_data_offset,
        var_i,
        var_result_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_results_mpos)
end

func array_storeLengthForEncoding_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_712 : Uint256, length_713 : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_712.low, value=length_713)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_714 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos_712, _1_714)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func array_dataslot_array_bytes_dyn{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr : Uint256) -> (data : Uint256):
    alloc_locals
    local _1_698 : Uint256 = Uint256(low=32, high=0)
    let (local data : Uint256) = u256_add(ptr, _1_698)
    local range_check_ptr = range_check_ptr
    return (data)
end

func abi_encodeUpdatedPos_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_377 : Uint256, pos : Uint256) -> (updatedPos : Uint256):
    alloc_locals
    let (local updatedPos : Uint256) = abi_encode_bytes_memory_ptr(value0_377, pos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (updatedPos)
end

func array_nextElement_array_bytes_dyn{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_710 : Uint256) -> (next : Uint256):
    alloc_locals
    local _1_711 : Uint256 = Uint256(low=32, high=0)
    let (local next : Uint256) = u256_add(ptr_710, _1_711)
    local range_check_ptr = range_check_ptr
    return (next)
end

func __warp_loop_body_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_393 : Uint256, headStart_392 : Uint256, i : Uint256, pos_389 : Uint256,
        srcPtr : Uint256, tail : Uint256) -> (
        i : Uint256, pos_389 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local _4_396 : Uint256) = uint256_sub(tail, headStart_392)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_389.low, value=_4_396)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local elementValue0 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(srcPtr.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tail : Uint256) = abi_encodeUpdatedPos_bytes(elementValue0, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local srcPtr : Uint256) = array_nextElement_array_bytes_dyn(srcPtr)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_397 : Uint256 = _1_393
    let (local pos_389 : Uint256) = u256_add(pos_389, _1_393)
    local range_check_ptr = range_check_ptr
    local _3_395 : Uint256 = Uint256(low=1, high=0)
    let (local i : Uint256) = u256_add(i, _3_395)
    local range_check_ptr = range_check_ptr
    return (i, pos_389, srcPtr, tail)
end

func __warp_loop_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_393 : Uint256, headStart_392 : Uint256, i : Uint256, pos_389 : Uint256,
        srcPtr : Uint256, tail : Uint256) -> (
        i : Uint256, pos_389 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local i : Uint256, local pos_389 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_body_0(_1_393, headStart_392, i, pos_389, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i : Uint256, local pos_389 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_1_393, headStart_392, i, pos_389, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i, pos_389, srcPtr, tail)
end

func abi_encode_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_388 : Uint256, pos_389 : Uint256) -> (end_390 : Uint256):
    alloc_locals
    let (local length_391 : Uint256) = array_length_array_bytes_dyn(value_388)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local pos_389 : Uint256) = array_storeLengthForEncoding_array_bytes_dyn(
        pos_389, length_391)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local headStart_392 : Uint256 = pos_389
    local _1_393 : Uint256 = Uint256(low=32, high=0)
    let (local _2_394 : Uint256) = u256_mul(length_391, _1_393)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = u256_add(pos_389, _2_394)
    local range_check_ptr = range_check_ptr
    let (local baseRef : Uint256) = array_dataslot_array_bytes_dyn(value_388)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local srcPtr : Uint256 = baseRef
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256, local pos_389 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_1_393, headStart_392, i, pos_389, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local end_390 : Uint256 = tail
    return (end_390)
end

func abi_encode_array_bytes_memory_ptr_dyn_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_608 : Uint256, value0_609 : Uint256) -> (tail_610 : Uint256):
    alloc_locals
    local _1_611 : Uint256 = Uint256(low=32, high=0)
    let (local tail_610 : Uint256) = u256_add(headStart_608, _1_611)
    local range_check_ptr = range_check_ptr
    let (local _2_612 : Uint256) = uint256_sub(tail_610, headStart_608)
    local range_check_ptr = range_check_ptr
    local _3_613 : Uint256 = Uint256(low=0, high=0)
    let (local _4_614 : Uint256) = u256_add(headStart_608, _3_613)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_4_614.low, value=_2_612)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tail_610 : Uint256) = abi_encode_array_bytes_dyn(value0_609, tail_610)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_610)
end

func abi_decode_addresst_uint256t_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_172 : Uint256, dataEnd_173 : Uint256) -> (
        value0_174 : Uint256, value1_175 : Uint256, value2_176 : Uint256):
    alloc_locals
    local _1_177 : Uint256 = Uint256(low=96, high=0)
    let (local _2_178 : Uint256) = uint256_sub(dataEnd_173, headStart_172)
    local range_check_ptr = range_check_ptr
    let (local _3_179 : Uint256) = slt(_2_178, _1_177)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_179)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_180 : Uint256 = Uint256(low=0, high=0)
    let (local _4_181 : Uint256) = u256_add(headStart_172, offset_180)
    local range_check_ptr = range_check_ptr
    let (local value0_174 : Uint256) = abi_decode_address(_4_181, dataEnd_173)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_182 : Uint256 = Uint256(low=32, high=0)
    let (local _5_183 : Uint256) = u256_add(headStart_172, offset_1_182)
    local range_check_ptr = range_check_ptr
    let (local value1_175 : Uint256) = abi_decode_uint256(_5_183, dataEnd_173)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_2_184 : Uint256 = Uint256(low=64, high=0)
    let (local _6_185 : Uint256) = u256_add(headStart_172, offset_2_184)
    local range_check_ptr = range_check_ptr
    let (local value2_176 : Uint256) = abi_decode_address(_6_185, dataEnd_173)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_174, value1_175, value2_176)
end

func __warp_block_81{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1587 : Uint256) -> (expr_1_1597 : Uint256):
    alloc_locals
    let (local _13_1598 : Uint256) = __warp_holder()
    finalize_allocation(_3_1587, _13_1598)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1599 : Uint256) = __warp_holder()
    let (local _15_1600 : Uint256) = u256_add(_3_1587, _14_1599)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1597 : Uint256) = abi_decode_uint256_fromMemory(_3_1587, _15_1600)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1597)
end

func __warp_if_45{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_1595 : Uint256, _3_1587 : Uint256, expr_1_1597 : Uint256) -> (expr_1_1597 : Uint256):
    alloc_locals
    if _11_1595.low + _11_1595.high != 0:
        let (local expr_1_1597 : Uint256) = __warp_block_81(_3_1587)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1597)
    else:
        return (expr_1_1597)
    end
end

func __warp_if_46{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1_1597 : Uint256, expr_4_1608 : Uint256, var_recipient_1585 : Uint256,
        var_token_1583 : Uint256) -> ():
    alloc_locals
    if expr_4_1608.low + expr_4_1608.high != 0:
        fun_safeTransfer(var_token_1583, var_recipient_1585, expr_1_1597)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func fun_sweepToken{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1583 : Uint256, var_amountMinimum_1584 : Uint256,
        var_recipient_1585 : Uint256) -> ():
    alloc_locals
    let (local expr_1646_address : Uint256) = convert_address_to_contract_IERC20(var_token_1583)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_address : Uint256) = convert_contract_IERC20_to_address(expr_1646_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1647_functionSelector : Uint256 = Uint256(low=1889567281, high=0)
    let (local expr_1650_address : Uint256) = __warp_holder()
    let (local expr_1586 : Uint256) = convert_contract_PeripheryPayments_to_address(
        expr_1650_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1587 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_1588 : Uint256) = shift_left_224(expr_1647_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1587.low, value=_4_1588)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1589 : Uint256 = Uint256(low=4, high=0)
    let (local _6_1590 : Uint256) = u256_add(_3_1587, _5_1589)
    local range_check_ptr = range_check_ptr
    let (local _7_1591 : Uint256) = abi_encode_tuple_address(_6_1590, expr_1586)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1592 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1593 : Uint256) = uint256_sub(_7_1591, _3_1587)
    local range_check_ptr = range_check_ptr
    let (local _10_1594 : Uint256) = __warp_holder()
    let (local _11_1595 : Uint256) = __warp_holder()
    let (local _12_1596 : Uint256) = is_zero(_11_1595)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_1596)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1597 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1597 : Uint256) = __warp_if_45(_11_1595, _3_1587, expr_1_1597)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1601 : Uint256) = cleanup_uint256(var_amountMinimum_1584)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_1602 : Uint256) = cleanup_uint256(expr_1_1597)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _18_1603 : Uint256) = is_lt(_17_1602, _16_1601)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1604 : Uint256) = is_zero(_18_1603)
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1604)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_3_1605 : Uint256 = Uint256(low=0, high=0)
    let (local _19_1606 : Uint256) = convert_rational_0_by_1_to_uint256(expr_3_1605)
    local exec_env : ExecutionEnvironment = exec_env
    local _20_1607 : Uint256 = _17_1602
    let (local expr_4_1608 : Uint256) = is_gt(_17_1602, _19_1606)
    local range_check_ptr = range_check_ptr
    __warp_if_46(expr_1_1597, expr_4_1608, var_recipient_1585, var_token_1583)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_addresst_uint256t_addresst_uint256t_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_186 : Uint256, dataEnd_187 : Uint256) -> (
        value0_188 : Uint256, value1_189 : Uint256, value2_190 : Uint256, value3_191 : Uint256,
        value4 : Uint256):
    alloc_locals
    local _1_192 : Uint256 = Uint256(low=160, high=0)
    let (local _2_193 : Uint256) = uint256_sub(dataEnd_187, headStart_186)
    local range_check_ptr = range_check_ptr
    let (local _3_194 : Uint256) = slt(_2_193, _1_192)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_194)
    local exec_env : ExecutionEnvironment = exec_env
    local offset_195 : Uint256 = Uint256(low=0, high=0)
    let (local _4_196 : Uint256) = u256_add(headStart_186, offset_195)
    local range_check_ptr = range_check_ptr
    let (local value0_188 : Uint256) = abi_decode_address(_4_196, dataEnd_187)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_1_197 : Uint256 = Uint256(low=32, high=0)
    let (local _5_198 : Uint256) = u256_add(headStart_186, offset_1_197)
    local range_check_ptr = range_check_ptr
    let (local value1_189 : Uint256) = abi_decode_uint256(_5_198, dataEnd_187)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_2_199 : Uint256 = Uint256(low=64, high=0)
    let (local _6_200 : Uint256) = u256_add(headStart_186, offset_2_199)
    local range_check_ptr = range_check_ptr
    let (local value2_190 : Uint256) = abi_decode_address(_6_200, dataEnd_187)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_3_201 : Uint256 = Uint256(low=96, high=0)
    let (local _7_202 : Uint256) = u256_add(headStart_186, offset_3_201)
    local range_check_ptr = range_check_ptr
    let (local value3_191 : Uint256) = abi_decode_uint256(_7_202, dataEnd_187)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local offset_4_203 : Uint256 = Uint256(low=128, high=0)
    let (local _8_204 : Uint256) = u256_add(headStart_186, offset_4_203)
    local range_check_ptr = range_check_ptr
    let (local value4 : Uint256) = abi_decode_address(_8_204, dataEnd_187)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_188, value1_189, value2_190, value3_191, value4)
end

func __warp_block_82{exec_env : ExecutionEnvironment, range_check_ptr}(_2_1545 : Uint256) -> (
        expr_2_1547 : Uint256):
    alloc_locals
    local expr_3_1548 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1549 : Uint256) = convert_rational_100_by_1_to_uint256(expr_3_1548)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_1550 : Uint256 = _2_1545
    let (local _5_1551 : Uint256) = is_gt(_2_1545, _3_1549)
    local range_check_ptr = range_check_ptr
    let (local expr_4_1552 : Uint256) = is_zero(_5_1551)
    local range_check_ptr = range_check_ptr
    local expr_2_1547 : Uint256 = expr_4_1552
    return (expr_2_1547)
end

func __warp_if_47{exec_env : ExecutionEnvironment, range_check_ptr}(
        _2_1545 : Uint256, expr_1_1546 : Uint256, expr_2_1547 : Uint256) -> (expr_2_1547 : Uint256):
    alloc_locals
    if expr_1_1546.low + expr_1_1546.high != 0:
        let (local expr_2_1547 : Uint256) = __warp_block_82(_2_1545)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2_1547)
    else:
        return (expr_2_1547)
    end
end

func __warp_block_83{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _8_1554 : Uint256) -> (expr_6_1564 : Uint256):
    alloc_locals
    let (local _18_1565 : Uint256) = __warp_holder()
    finalize_allocation(_8_1554, _18_1565)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1566 : Uint256) = __warp_holder()
    let (local _20_1567 : Uint256) = u256_add(_8_1554, _19_1566)
    local range_check_ptr = range_check_ptr
    let (local expr_6_1564 : Uint256) = abi_decode_uint256_fromMemory(_8_1554, _20_1567)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_6_1564)
end

func __warp_if_48{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1562 : Uint256, _8_1554 : Uint256, expr_6_1564 : Uint256) -> (expr_6_1564 : Uint256):
    alloc_locals
    if _16_1562.low + _16_1562.high != 0:
        let (local expr_6_1564 : Uint256) = __warp_block_83(_8_1554)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_6_1564)
    else:
        return (expr_6_1564)
    end
end

func __warp_if_50{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_11_1578 : Uint256, expr_12_1581 : Uint256, var_feeRecipient : Uint256,
        var_token_1541 : Uint256) -> ():
    alloc_locals
    if expr_12_1581.low + expr_12_1581.high != 0:
        fun_safeTransfer(var_token_1541, var_feeRecipient, expr_11_1578)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_84{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1544 : Uint256, expr_6_1564 : Uint256, var_feeBips : Uint256,
        var_feeRecipient : Uint256, var_recipient_1542 : Uint256, var_token_1541 : Uint256) -> ():
    alloc_locals
    let (local expr_9_1575 : Uint256) = fun_mul(expr_6_1564, var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_10_1576 : Uint256 = Uint256(low=10000, high=0)
    let (local _26_1577 : Uint256) = convert_rational_10000_by_1_to_uint256(expr_10_1576)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_11_1578 : Uint256) = checked_div_uint256(expr_9_1575, _26_1577)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _27_1579 : Uint256 = _1_1544
    let (local _28_1580 : Uint256) = cleanup_uint256(expr_11_1578)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_12_1581 : Uint256) = is_gt(_28_1580, _1_1544)
    local range_check_ptr = range_check_ptr
    __warp_if_50(expr_11_1578, expr_12_1581, var_feeRecipient, var_token_1541)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_13_1582 : Uint256) = checked_sub_uint256(expr_6_1564, expr_11_1578)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransfer(var_token_1541, var_recipient_1542, expr_13_1582)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_49{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1544 : Uint256, expr_6_1564 : Uint256, expr_8_1574 : Uint256, var_feeBips : Uint256,
        var_feeRecipient : Uint256, var_recipient_1542 : Uint256, var_token_1541 : Uint256) -> ():
    alloc_locals
    if expr_8_1574.low + expr_8_1574.high != 0:
        __warp_block_84(
            _1_1544,
            expr_6_1564,
            var_feeBips,
            var_feeRecipient,
            var_recipient_1542,
            var_token_1541)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func fun_sweepTokenWithFee{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1541 : Uint256, var_amountMinimum : Uint256, var_recipient_1542 : Uint256,
        var_feeBips : Uint256, var_feeRecipient : Uint256) -> ():
    alloc_locals
    local expr_1543 : Uint256 = Uint256(low=0, high=0)
    let (local _1_1544 : Uint256) = convert_rational_0_by_1_to_uint256(expr_1543)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1545 : Uint256) = cleanup_uint256(var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1_1546 : Uint256) = is_gt(_2_1545, _1_1544)
    local range_check_ptr = range_check_ptr
    local expr_2_1547 : Uint256 = expr_1_1546
    let (local expr_2_1547 : Uint256) = __warp_if_47(_2_1545, expr_1_1546, expr_2_1547)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_2_1547)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1911_address : Uint256) = convert_address_to_contract_IERC20(var_token_1541)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1912_address : Uint256) = convert_contract_IERC20_to_address(expr_1911_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_1912_functionSelector : Uint256 = Uint256(low=1889567281, high=0)
    let (local expr_1915_address : Uint256) = __warp_holder()
    let (local expr_5_1553 : Uint256) = convert_contract_PeripheryPaymentsWithFee_to_address(
        expr_1915_address)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _8_1554 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local _9_1555 : Uint256) = shift_left_224(expr_1912_functionSelector)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_8_1554.low, value=_9_1555)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _10_1556 : Uint256 = Uint256(low=4, high=0)
    let (local _11_1557 : Uint256) = u256_add(_8_1554, _10_1556)
    local range_check_ptr = range_check_ptr
    let (local _12_1558 : Uint256) = abi_encode_tuple_address(_11_1557, expr_5_1553)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _13_1559 : Uint256 = Uint256(low=32, high=0)
    let (local _14_1560 : Uint256) = uint256_sub(_12_1558, _8_1554)
    local range_check_ptr = range_check_ptr
    let (local _15_1561 : Uint256) = __warp_holder()
    let (local _16_1562 : Uint256) = __warp_holder()
    let (local _17_1563 : Uint256) = is_zero(_16_1562)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17_1563)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_6_1564 : Uint256 = Uint256(low=0, high=0)
    let (local expr_6_1564 : Uint256) = __warp_if_48(_16_1562, _8_1554, expr_6_1564)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1568 : Uint256) = cleanup_uint256(var_amountMinimum)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _22_1569 : Uint256) = cleanup_uint256(expr_6_1564)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _23_1570 : Uint256) = is_lt(_22_1569, _21_1568)
    local range_check_ptr = range_check_ptr
    let (local expr_7_1571 : Uint256) = is_zero(_23_1570)
    local range_check_ptr = range_check_ptr
    require_helper(expr_7_1571)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _24_1572 : Uint256 = _1_1544
    local _25_1573 : Uint256 = _22_1569
    let (local expr_8_1574 : Uint256) = is_gt(_22_1569, _1_1544)
    local range_check_ptr = range_check_ptr
    __warp_if_49(
        _1_1544,
        expr_6_1564,
        expr_8_1574,
        var_feeBips,
        var_feeRecipient,
        var_recipient_1542,
        var_token_1541)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func fun{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local expr_937 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _1_938 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_939 : Uint256) = cleanup_address(_1_938)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_940 : Uint256) = cleanup_address(expr_937)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_941 : Uint256) = is_eq(_3_940, _2_939)
    local range_check_ptr = range_check_ptr
    require_helper(expr_1_941)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_88{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _9 : Uint256 = _4
    local _10 : Uint256 = _3
    let (local param : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_exactInputSingle_dynArgs(param)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _11 : Uint256) = uint256_sub(memEnd, memPos)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_90{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _12 : Uint256 = _4
    local _13 : Uint256 = _3
    let (local param_1 : Uint256) = abi_decode_struct_ExactOutputSingleParams_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_exactOutputSingle_dynArgs(param_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_1 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_1 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = uint256_sub(memEnd_1, memPos_1)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_92{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _15 : Uint256 = _4
    local _16 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_refundETH()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_2 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_2 : Uint256) = abi_encode_tuple(memPos_2)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17 : Uint256) = uint256_sub(memEnd_2, memPos_2)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_94{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _18 : Uint256) = __warp_holder()
    __warp_cond_revert(_18)
    local exec_env : ExecutionEnvironment = exec_env
    local _19 : Uint256 = _4
    local _20 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = getter_fun_succinctly()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_3 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_3 : Uint256) = abi_encode_tuple_address(memPos_3, ret_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = uint256_sub(memEnd_3, memPos_3)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_96{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _22 : Uint256) = __warp_holder()
    __warp_cond_revert(_22)
    local exec_env : ExecutionEnvironment = exec_env
    local _23 : Uint256 = _4
    local _24 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = getter_fun_age()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_4 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_4 : Uint256) = abi_encode_uint256(memPos_4, ret_3)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25 : Uint256) = uint256_sub(memEnd_4, memPos_4)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_98{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _26 : Uint256) = __warp_holder()
    __warp_cond_revert(_26)
    local exec_env : ExecutionEnvironment = exec_env
    local _27 : Uint256 = _4
    local _28 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = getter_fun_OCaml()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_5 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_5 : Uint256) = abi_encode_tuple_address(memPos_5, ret_4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29 : Uint256) = uint256_sub(memEnd_5, memPos_5)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_100{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _30 : Uint256 = _4
    local _31 : Uint256 = _3
    let (local param_2 : Uint256, local param_3 : Uint256, local param_4 : Uint256,
        local param_5 : Uint256, local param_6 : Uint256,
        local param_7 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitAllowed(param_2, param_3, param_4, param_5, param_6, param_7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_6 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_6 : Uint256) = abi_encode_tuple(memPos_6)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _32 : Uint256) = uint256_sub(memEnd_6, memPos_6)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_102{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _33 : Uint256 = _4
    local _34 : Uint256 = _3
    let (local param_8 : Uint256) = abi_decode_struct_ExactOutputParams_calldata_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_5 : Uint256) = fun_exactOutput_dynArgs(param_8)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_7 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_7 : Uint256) = abi_encode_uint256(memPos_7, ret_5)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35 : Uint256) = uint256_sub(memEnd_7, memPos_7)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_104{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _36 : Uint256 = _4
    local _37 : Uint256 = _3
    let (local param_9 : Uint256, local param_10 : Uint256) = abi_decode_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_unwrapWETH9(param_9, param_10)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_8 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_8 : Uint256) = abi_encode_tuple(memPos_8)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _38 : Uint256) = uint256_sub(memEnd_8, memPos_8)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_106{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _39 : Uint256) = __warp_holder()
    __warp_cond_revert(_39)
    local exec_env : ExecutionEnvironment = exec_env
    local _40 : Uint256 = _4
    local _41 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_6 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_9 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_9 : Uint256) = abi_encode_tuple_address(memPos_9, ret_6)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _42 : Uint256) = uint256_sub(memEnd_9, memPos_9)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_108{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _43 : Uint256 = _4
    local _44 : Uint256 = _3
    let (local param_11 : Uint256) = abi_decode_struct_ExactInputParams_memory_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local ret_7 : Uint256) = fun_exactInput_dynArgs(param_11)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_10 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_10 : Uint256) = abi_encode_uint256(memPos_10, ret_7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _45 : Uint256) = uint256_sub(memEnd_10, memPos_10)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_110{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _46 : Uint256) = __warp_holder()
    __warp_cond_revert(_46)
    local exec_env : ExecutionEnvironment = exec_env
    local _47 : Uint256 = _4
    local _48 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_8 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_11 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_11 : Uint256) = abi_encode_tuple_address(memPos_11, ret_8)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _49 : Uint256) = uint256_sub(memEnd_11, memPos_11)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_112{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _50 : Uint256) = __warp_holder()
    __warp_cond_revert(_50)
    local exec_env : ExecutionEnvironment = exec_env
    local _51 : Uint256 = _4
    local _52 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_9 : Uint256) = getter_fun_seaplusplus()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_12 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_12 : Uint256) = abi_encode_tuple_address(memPos_12, ret_9)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _53 : Uint256) = uint256_sub(memEnd_12, memPos_12)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_114{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _54 : Uint256) = __warp_holder()
    __warp_cond_revert(_54)
    local exec_env : ExecutionEnvironment = exec_env
    local _55 : Uint256 = _4
    local _56 : Uint256 = _3
    let (local param_12 : Uint256, local param_13 : Uint256, local param_14 : Uint256,
        local param_15 : Uint256) = abi_decode_int256t_int256t_bytes_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_uniswapV3SwapCallback_dynArgs(param_12, param_13, param_14, param_15)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_13 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_13 : Uint256) = abi_encode_tuple(memPos_13)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _57 : Uint256) = uint256_sub(memEnd_13, memPos_13)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_116{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _58 : Uint256 = _4
    local _59 : Uint256 = _3
    let (local param_16 : Uint256, local param_17 : Uint256, local param_18 : Uint256,
        local param_19 : Uint256) = abi_decode_uint256t_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_unwrapWETH9WithFee(param_16, param_17, param_18, param_19)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_14 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_14 : Uint256) = abi_encode_tuple(memPos_14)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _60 : Uint256) = uint256_sub(memEnd_14, memPos_14)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_118{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _61 : Uint256 = _4
    local _62 : Uint256 = _3
    let (local param_20 : Uint256, local param_21 : Uint256, local param_22 : Uint256,
        local param_23 : Uint256, local param_24 : Uint256,
        local param_25 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitAllowedIfNecessary(param_20, param_21, param_22, param_23, param_24, param_25)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_15 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_15 : Uint256) = abi_encode_tuple(memPos_15)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _63 : Uint256) = uint256_sub(memEnd_15, memPos_15)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_120{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _64 : Uint256 = _4
    local _65 : Uint256 = _3
    let (local param_26 : Uint256, local param_27 : Uint256, local param_28 : Uint256,
        local param_29 : Uint256, local param_30 : Uint256,
        local param_31 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitIfNecessary(param_26, param_27, param_28, param_29, param_30, param_31)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_16 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_16 : Uint256) = abi_encode_tuple(memPos_16)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _66 : Uint256) = uint256_sub(memEnd_16, memPos_16)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_122{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _67 : Uint256) = __warp_holder()
    __warp_cond_revert(_67)
    local exec_env : ExecutionEnvironment = exec_env
    local _68 : Uint256 = _4
    local _69 : Uint256 = _3
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_10 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_17 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_17 : Uint256) = abi_encode_tuple_address(memPos_17, ret_10)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _70 : Uint256) = uint256_sub(memEnd_17, memPos_17)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_124{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _71 : Uint256) = __warp_holder()
    __warp_cond_revert(_71)
    local exec_env : ExecutionEnvironment = exec_env
    local _72 : Uint256 = _4
    local _73 : Uint256 = _3
    let (local param_32 : Uint256, local param_33 : Uint256, local param_34 : Uint256,
        local param_35 : Uint256) = abi_decode_addresst_addresst_addresst_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_warp_constructor(param_32, param_33, param_34, param_35)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_18 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_18 : Uint256) = abi_encode_tuple(memPos_18)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _74 : Uint256) = uint256_sub(memEnd_18, memPos_18)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_126{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _75 : Uint256 = _4
    local _76 : Uint256 = _3
    let (local param_36 : Uint256,
        local param_37 : Uint256) = abi_decode_array_bytes_calldata_dyn_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_11 : Uint256) = fun_multicall_dynArgs(param_36, param_37)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local memPos_19 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_19 : Uint256) = abi_encode_array_bytes_memory_ptr_dyn_memory_ptr(
        memPos_19, ret_11)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _77 : Uint256) = uint256_sub(memEnd_19, memPos_19)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_128{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _78 : Uint256 = _4
    local _79 : Uint256 = _3
    let (local param_38 : Uint256, local param_39 : Uint256,
        local param_40 : Uint256) = abi_decode_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_sweepToken(param_38, param_39, param_40)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local memPos_20 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_20 : Uint256) = abi_encode_tuple(memPos_20)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _80 : Uint256) = uint256_sub(memEnd_20, memPos_20)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_130{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _81 : Uint256 = _4
    local _82 : Uint256 = _3
    let (local param_41 : Uint256, local param_42 : Uint256, local param_43 : Uint256,
        local param_44 : Uint256,
        local param_45 : Uint256) = abi_decode_addresst_uint256t_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_sweepTokenWithFee(param_41, param_42, param_43, param_44, param_45)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local memPos_21 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_21 : Uint256) = abi_encode_tuple(memPos_21)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _83 : Uint256) = uint256_sub(memEnd_21, memPos_21)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_132{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _84 : Uint256 = _4
    local _85 : Uint256 = _3
    let (local param_46 : Uint256, local param_47 : Uint256, local param_48 : Uint256,
        local param_49 : Uint256, local param_50 : Uint256,
        local param_51 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermit(param_46, param_47, param_48, param_49, param_50, param_51)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_22 : Uint256) = allocate_unbounded()
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    let (local memEnd_22 : Uint256) = abi_encode_tuple(memPos_22)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _86 : Uint256) = uint256_sub(memEnd_22, memPos_22)
    local range_check_ptr = range_check_ptr

    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_74{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_132(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_131{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4086914151, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_74(_3, _4, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_73{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_130(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_131(_3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_129{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3772877216, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_73(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_72{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_128(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_129(_3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_127{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3744118203, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_72(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_71{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_126(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_127(_3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_125{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3544941711, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_71(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_70{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_124(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_125(_3, _4, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_123{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3317519410, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_70(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_69{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_122(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_123(_3, _4, match_var)
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

func __warp_block_121{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3294232917, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_69(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_68{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_120(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_121(_3, _4, match_var)
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

func __warp_block_119{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3269661706, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_68(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_67{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_118(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_119(_3, _4, match_var)
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

func __warp_block_117{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2762444556, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_67(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_66{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_116(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_117(_3, _4, match_var)
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

func __warp_block_115{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2603354679, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_66(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_65{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_114(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_115(_3, _4, match_var)
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

func __warp_block_113{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2496631155, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_65(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_64{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_112(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_113(_3, _4, match_var)
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

func __warp_block_111{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2301295456, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_64(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_63{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_110(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_111(_3, _4, match_var)
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

func __warp_block_109{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2129988926, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_63(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_62{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_108(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_109(_3, _4, match_var)
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

func __warp_block_107{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1732944880, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_62(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_61{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_106(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_107(_3, _4, match_var)
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

func __warp_block_105{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1252304124, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_61(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_60{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_104(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_105(_3, _4, match_var)
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

func __warp_block_103{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1228950396, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_60(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_59{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_102(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_103(_3, _4, match_var)
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

func __warp_block_101{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180282849, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_59(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_58{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_100(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_101(_3, _4, match_var)
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

func __warp_block_99{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180279956, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_58(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_57{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_98(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_99(_3, _4, match_var)
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

func __warp_block_97{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=725343503, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_57(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_56{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_96(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_97(_3, _4, match_var)
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

func __warp_block_95{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=640327167, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_56(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_55{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_94(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_95(_3, _4, match_var)
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

func __warp_block_93{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=422912998, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_55(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_54{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_92(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_93(_3, _4, match_var)
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

func __warp_block_91{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=304156298, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_54(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_53{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_90(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_91(_3, _4, match_var)
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

func __warp_block_89{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=294090526, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_53(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_52{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_88(_3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_89(_3, _4, match_var)
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

func __warp_block_87{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=136250211, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_52(_3, _4, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_86{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, selector : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = selector
    __warp_block_87(_3, _4, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_85{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _7.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local selector : Uint256) = shift_right_unsigned(_8)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    __warp_block_86(_3, _4, selector)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_if_51{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_85(_3, _4)
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

func __warp_if_75{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_88 : Uint256) -> ():
    alloc_locals
    if _88.low + _88.high != 0:
        fun()
        local exec_env : ExecutionEnvironment = exec_env
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        __warp_holder()
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
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_51(_3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _87 : Uint256 = _4
    let (local _88 : Uint256) = is_zero(_4)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_75(_88)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

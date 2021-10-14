%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_gt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not
from starkware.starknet.common.storage import Storage

@storage_var
func counter() -> (res : Uint256):
end

func __warp_cond_revert(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_add_uint256{range_check_ptr}(x : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_2 : Uint256) = uint256_not(Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_3 : Uint256) = is_gt(x, _1_2)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_3)
    local _3_4 : Uint256 = Uint256(low=1, high=0)
    let (local sum : Uint256) = u256_add(x, _3_4)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func getter_fun_counter{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}() -> (
        value_7 : Uint256):
    alloc_locals
    let (res) = counter.read()
    return (res)
end

func setter_fun_counter{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        value_16 : Uint256) -> ():
    alloc_locals
    counter.write(value_16)
    return ()
end

func fun_increment{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}() -> (
        var : Uint256):
    alloc_locals
    let (local _1_5 : Uint256) = getter_fun_counter()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_6 : Uint256) = checked_add_uint256(_1_5)
    local range_check_ptr = range_check_ptr
    setter_fun_counter(_2_6)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local var : Uint256) = getter_fun_counter()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var)
end

@external
func fun_increment_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        ) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_increment()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

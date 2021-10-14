%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.storage import Storage

func sstore{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        key : Uint256, value : Uint256):
    evm_storage.write(key.low, key.high, value)
    return ()
end

func sload{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(key : Uint256) -> (
        value : Uint256):
    let (res) = evm_storage.read(key.low, key.high)
    return (res)
end

@storage_var
func evm_storage(arg0_low, arg0_high) -> (res : Uint256):
end

func fun_test{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}() -> (
        var_res : Uint256):
    alloc_locals
    local _1_2 : Uint256 = Uint256(low=5, high=0)
    local _2_3 : Uint256 = Uint256(low=0, high=0)
    sstore(key=_2_3, value=_1_2)
    local storage_ptr : Storage* = storage_ptr
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local _3_4 : Uint256 = Uint256(low=1, high=0)
    let (local var_res : Uint256) = sload(_3_4)
    local storage_ptr : Storage* = storage_ptr
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return (var_res)
end

@external
func fun_test_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        ) -> (var_res : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_res : Uint256) = fun_test()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_res=var_res)
end

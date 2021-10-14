%lang starknet
%builtins pedersen range_check

from evm.calls import calldatacopy_
from evm.exec_env import ExecutionEnvironment
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.storage import Storage

func fun_callMe{exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        ) -> (var : Uint256):
    alloc_locals
    local var : Uint256 = Uint256(low=0, high=0)
    local _1_4 : Uint256 = Uint256(low=4, high=0)
    local _2_5 : Uint256 = Uint256(low=0, high=0)
    local _3_6 : Uint256 = _2_5
    calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(_2_5, _2_5, _1_4)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_7 : Uint256 = _1_4
    local _5 : Uint256 = _2_5

    local range_check_ptr = range_check_ptr
    return (var)
end

@external
func fun_callMe_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)
    with memory_dict, msize, exec_env:
        let (local var : Uint256) = fun_callMe()
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

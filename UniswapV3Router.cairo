%lang starknet
%builtins pedersen range_check

from evm.calls import calldata_load, calldatacopy_, get_caller_data_uint256
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add, u256_div, u256_mul
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

func __warp_cond_revert(_4_113 : Uint256) -> ():
    alloc_locals
    if _4_113.low + _4_113.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper{exec_env : ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_1641 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_1641)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func finalize_allocation{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_699 : Uint256, size_700 : Uint256) -> ():
    alloc_locals
    let (local _1_701 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_702 : Uint256 = Uint256(low=31, high=0)
    let (local _3_703 : Uint256) = u256_add(size_700, _2_702)
    local range_check_ptr = range_check_ptr
    let (local _4_704 : Uint256) = uint256_and(_3_703, _1_701)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr_705 : Uint256) = u256_add(memPtr_699, _4_704)
    local range_check_ptr = range_check_ptr
    let (local _5_706 : Uint256) = is_lt(newFreePtr_705, memPtr_699)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_707 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_708 : Uint256) = is_gt(newFreePtr_705, _6_707)
    local range_check_ptr = range_check_ptr
    let (local _8_709 : Uint256) = uint256_sub(_7_708, _5_706)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_709)
    local exec_env : ExecutionEnvironment = exec_env
    local _9_710 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_9_710.low, value=newFreePtr_705)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func getter_fun_I_am_a_mistake{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1558 : Uint256):
    alloc_locals
    let (res) = I_am_a_mistake.read()
    return (res)
end

func cleanup_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_630 : Uint256) -> (
        cleaned : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_631 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local cleaned : Uint256) = uint256_and(value_630, _1_631)
    local range_check_ptr = range_check_ptr
    return (cleaned)
end

func abi_encode_address_to_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_307 : Uint256, pos_308 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_309 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_310 : Uint256) = uint256_and(value_307, _1_309)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_308.low, value=_2_310)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bytes32_to_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_336 : Uint256, pos_337 : Uint256) -> ():
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_337.low, value=value_336)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_518 : Uint256, value0_519 : Uint256) -> (tail_520 : Uint256):
    alloc_locals
    local _1_521 : Uint256 = Uint256(low=32, high=0)
    let (local tail_520 : Uint256) = u256_add(headStart_518, _1_521)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value0_519, headStart_518)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_520)
end

func finalize_allocation_20760{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_691 : Uint256) -> ():
    alloc_locals
    local _1_692 : Uint256 = Uint256(low=32, high=0)
    let (local newFreePtr_693 : Uint256) = u256_add(memPtr_691, _1_692)
    local range_check_ptr = range_check_ptr
    let (local _2_694 : Uint256) = is_lt(newFreePtr_693, memPtr_691)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_695 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_696 : Uint256) = is_gt(newFreePtr_693, _3_695)
    local range_check_ptr = range_check_ptr
    let (local _5_697 : Uint256) = uint256_sub(_4_696, _2_694)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_697)
    local exec_env : ExecutionEnvironment = exec_env
    local _6_698 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_698.low, value=newFreePtr_693)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_memory_17282{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_560 : Uint256):
    alloc_locals
    local _1_561 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_560 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_561.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    finalize_allocation_20760(memPtr_560)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_560)
end

func allocate_memory_array_bytes_9874{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_567 : Uint256):
    alloc_locals
    let (local memPtr_567 : Uint256) = allocate_memory_17282()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_568 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_567.low, value=_1_568)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_567)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_1701 : Uint256) -> ():
    alloc_locals
    local _1_1702 : Uint256 = Uint256(low=0, high=0)
    local _2_1703 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local range_check_ptr = range_check_ptr
    calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        dataStart_1701, _2_1703, _1_1702)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_541 : Uint256):
    alloc_locals
    let (local memPtr_541 : Uint256) = allocate_memory_array_bytes_9874()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_542 : Uint256 = Uint256(low=32, high=0)
    let (local _2_543 : Uint256) = u256_add(memPtr_541, _1_542)
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(_2_543)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_541)
end

func array_allocation_size_bytes{exec_env : ExecutionEnvironment, range_check_ptr}(
        length_579 : Uint256) -> (size_580 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_581 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_582 : Uint256) = is_gt(length_579, _1_581)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_582)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_583 : Uint256 = Uint256(low=32, high=0)
    let (local _4_584 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_585 : Uint256 = Uint256(low=31, high=0)
    let (local _6_586 : Uint256) = u256_add(length_579, _5_585)
    local range_check_ptr = range_check_ptr
    let (local _7_587 : Uint256) = uint256_and(_6_586, _4_584)
    local range_check_ptr = range_check_ptr
    let (local size_580 : Uint256) = u256_add(_7_587, _3_583)
    local range_check_ptr = range_check_ptr
    return (size_580)
end

func allocate_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        size : Uint256) -> (memPtr_562 : Uint256):
    alloc_locals
    local _1_563 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_562 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_563.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    finalize_allocation(memPtr_562, size)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_562)
end

func allocate_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_569 : Uint256) -> (memPtr_570 : Uint256):
    alloc_locals
    let (local _1_571 : Uint256) = array_allocation_size_bytes(length_569)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPtr_570 : Uint256) = allocate_memory(_1_571)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=memPtr_570.low, value=length_569)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (memPtr_570)
end

func __warp_block_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        data : Uint256):
    alloc_locals
    let (local _2_655 : Uint256) = __warp_holder()
    let (local data : Uint256) = allocate_memory_array_bytes(_2_655)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_656 : Uint256) = __warp_holder()
    local _4_657 : Uint256 = Uint256(low=0, high=0)
    local _5_658 : Uint256 = Uint256(low=32, high=0)
    let (local _6_659 : Uint256) = u256_add(data, _5_658)
    local range_check_ptr = range_check_ptr
    __warp_holder()
    return (data)
end

func __warp_if_8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> (data : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local data : Uint256 = Uint256(low=96, high=0)
        return (data)
    else:
        let (local data : Uint256) = __warp_block_15()
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (data)
    end
end

func __warp_block_14{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256) -> (data : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local data : Uint256) = __warp_if_8(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func __warp_block_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_654 : Uint256) -> (data : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_654
    let (local data : Uint256) = __warp_block_14(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func extract_returndata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        data : Uint256):
    alloc_locals
    let (local _1_654 : Uint256) = __warp_holder()
    let (local data : Uint256) = __warp_block_13(_1_654)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func fun_safeTransferETH{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_to : Uint256, var_value_1114 : Uint256) -> ():
    alloc_locals
    let (local expr_1562_mpos : Uint256) = allocate_and_zero_memory_array_bytes()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_1115 : Uint256 = Uint256(low=0, high=0)
    local _2_1116 : Uint256 = _1_1115
    let (local _3_1117 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1562_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_1118 : Uint256 = Uint256(low=32, high=0)
    let (local _5_1119 : Uint256) = u256_add(expr_1562_mpos, _4_1118)
    local range_check_ptr = range_check_ptr
    let (local _6_1120 : Uint256) = __warp_holder()
    let (local expr_component_1121 : Uint256) = __warp_holder()
    let (local _7_1122 : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    require_helper(expr_component_1121)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local _4_1112 : Uint256) = __warp_holder()
    let (local _5_1113 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    fun_safeTransferETH(_5_1113, _4_1112)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3_1111 : Uint256) -> ():
    alloc_locals
    if _3_1111.low + _3_1111.high != 0:
        __warp_block_16()
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
    let (local _1_1109 : Uint256) = __warp_holder()
    let (local _2_1110 : Uint256) = is_zero(_1_1109)
    local range_check_ptr = range_check_ptr
    let (local _3_1111 : Uint256) = is_zero(_2_1110)
    local range_check_ptr = range_check_ptr
    __warp_if_9(_3_1111)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_encode_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_400 : Uint256, value0_401 : Uint256) -> (tail_402 : Uint256):
    alloc_locals
    local _1_403 : Uint256 = Uint256(low=32, high=0)
    let (local tail_402 : Uint256) = u256_add(headStart_400, _1_403)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value0_401, headStart_400)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_402)
end

func abi_encode_bool_9873{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_328 : Uint256) -> ():
    alloc_locals
    local _1_329 : Uint256 = Uint256(low=1, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_328.low, value=_1_329)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_376 : Uint256, pos_377 : Uint256) -> ():
    alloc_locals
    local _1_378 : Uint256 = Uint256(low=255, high=0)
    let (local _2_379 : Uint256) = uint256_and(value_376, _1_378)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_377.low, value=_2_379)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_431 : Uint256, value0_432 : Uint256, value1_433 : Uint256, value2_434 : Uint256,
        value3_435 : Uint256, value5_436 : Uint256, value6 : Uint256, value7 : Uint256) -> (
        tail_437 : Uint256):
    alloc_locals
    local _1_438 : Uint256 = Uint256(low=256, high=0)
    let (local tail_437 : Uint256) = u256_add(headStart_431, _1_438)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value0_432, headStart_431)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_439 : Uint256 = Uint256(low=32, high=0)
    let (local _3_440 : Uint256) = u256_add(headStart_431, _2_439)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value1_433, _3_440)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_441 : Uint256 = Uint256(low=64, high=0)
    let (local _5_442 : Uint256) = u256_add(headStart_431, _4_441)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value2_434, _5_442)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _6_443 : Uint256 = Uint256(low=96, high=0)
    let (local _7_444 : Uint256) = u256_add(headStart_431, _6_443)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value3_435, _7_444)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _8_445 : Uint256 = Uint256(low=128, high=0)
    let (local _9_446 : Uint256) = u256_add(headStart_431, _8_445)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_9873(_9_446)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _10_447 : Uint256 = Uint256(low=160, high=0)
    let (local _11_448 : Uint256) = u256_add(headStart_431, _10_447)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value5_436, _11_448)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _12_449 : Uint256 = Uint256(low=192, high=0)
    let (local _13_450 : Uint256) = u256_add(headStart_431, _12_449)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6, _13_450)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _14_451 : Uint256 = Uint256(low=224, high=0)
    let (local _15_452 : Uint256) = u256_add(headStart_431, _14_451)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value7, _15_452)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_437)
end

func abi_decode{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_142 : Uint256, dataEnd_143 : Uint256) -> ():
    alloc_locals
    local _1_144 : Uint256 = Uint256(low=0, high=0)
    let (local _2_145 : Uint256) = uint256_sub(dataEnd_143, headStart_142)
    local range_check_ptr = range_check_ptr
    let (local _3_146 : Uint256) = slt(_2_145, _1_144)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_146)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1208 : Uint256) -> ():
    alloc_locals
    let (local _19_1221 : Uint256) = __warp_holder()
    finalize_allocation(_6_1208, _19_1221)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1222 : Uint256) = __warp_holder()
    let (local _21_1223 : Uint256) = u256_add(_6_1208, _20_1222)
    local range_check_ptr = range_check_ptr
    abi_decode(_6_1208, _21_1223)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _17_1219 : Uint256, _6_1208 : Uint256) -> ():
    alloc_locals
    if _17_1219.low + _17_1219.high != 0:
        __warp_block_17(_6_1208)
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
        var_token_1199 : Uint256, var_nonce_1200 : Uint256, var_expiry_1201 : Uint256,
        var_v_1202 : Uint256, var_r_1203 : Uint256, var_s_1204 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1205 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1206 : Uint256) = uint256_and(var_token_1199, _1_1205)
    local range_check_ptr = range_check_ptr
    local _5_1207 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1208 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1207.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1209 : Uint256) = uint256_shl(
        Uint256(low=226, high=0), Uint256(low=603122627, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1208.low, value=_7_1209)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1210 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1211 : Uint256) = __warp_holder()
    let (local _10_1212 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1213 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1214 : Uint256) = u256_add(_6_1208, _11_1213)
    local range_check_ptr = range_check_ptr
    let (
        local _13_1215 : Uint256) = abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32(
        _12_1214,
        _10_1212,
        _9_1211,
        var_nonce_1200,
        var_expiry_1201,
        var_v_1202,
        var_r_1203,
        var_s_1204)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1216 : Uint256) = uint256_sub(_13_1215, _6_1208)
    local range_check_ptr = range_check_ptr
    local _15_1217 : Uint256 = _8_1210
    let (local _16_1218 : Uint256) = __warp_holder()
    let (local _17_1219 : Uint256) = __warp_holder()
    let (local _18_1220 : Uint256) = is_zero(_17_1219)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_18_1220)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_10(_17_1219, _6_1208)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_uint256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_281 : Uint256, dataEnd_282 : Uint256) -> (value0_283 : Uint256):
    alloc_locals
    local _1_284 : Uint256 = Uint256(low=32, high=0)
    let (local _2_285 : Uint256) = uint256_sub(dataEnd_282, headStart_281)
    local range_check_ptr = range_check_ptr
    let (local _3_286 : Uint256) = slt(_2_285, _1_284)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_286)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_283 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(headStart_281.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (value0_283)
end

func __warp_block_25{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1511 : Uint256) -> (expr_1522 : Uint256):
    alloc_locals
    let (local _17_1523 : Uint256) = __warp_holder()
    finalize_allocation(_6_1511, _17_1523)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1524 : Uint256) = __warp_holder()
    let (local _19_1525 : Uint256) = u256_add(_6_1511, _18_1524)
    local range_check_ptr = range_check_ptr
    let (local expr_1522 : Uint256) = abi_decode_uint256_fromMemory(_6_1511, _19_1525)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1522)
end

func __warp_if_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1520 : Uint256, _6_1511 : Uint256, expr_1522 : Uint256) -> (expr_1522 : Uint256):
    alloc_locals
    if _15_1520.low + _15_1520.high != 0:
        let (local expr_1522 : Uint256) = __warp_block_25(_6_1511)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1522)
    else:
        return (expr_1522)
    end
end

func __warp_block_27{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _29_1533 : Uint256) -> ():
    alloc_locals
    let (local _40_1544 : Uint256) = __warp_holder()
    finalize_allocation(_29_1533, _40_1544)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _41_1545 : Uint256) = __warp_holder()
    let (local _42_1546 : Uint256) = u256_add(_29_1533, _41_1545)
    local range_check_ptr = range_check_ptr
    abi_decode(_29_1533, _42_1546)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _29_1533 : Uint256, _38_1542 : Uint256) -> ():
    alloc_locals
    if _38_1542.low + _38_1542.high != 0:
        __warp_block_27(_29_1533)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_26{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _10_1515 : Uint256, _5_1510 : Uint256, expr_1522 : Uint256,
        var_recipient_1507 : Uint256) -> ():
    alloc_locals
    let (local _24_1530 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _25_1531 : Uint256) = cleanup_address(_24_1530)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1618_address : Uint256) = cleanup_address(_25_1531)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _28_1532 : Uint256 = _5_1510
    let (local _29_1533 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1510.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _30_1534 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=773487949, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_29_1533.low, value=_30_1534)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _31_1535 : Uint256 = Uint256(low=0, high=0)
    local _32_1536 : Uint256 = _10_1515
    let (local _33_1537 : Uint256) = u256_add(_29_1533, _10_1515)
    local range_check_ptr = range_check_ptr
    let (local _34_1538 : Uint256) = abi_encode_uint256(_33_1537, expr_1522)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35_1539 : Uint256) = uint256_sub(_34_1538, _29_1533)
    local range_check_ptr = range_check_ptr
    local _36_1540 : Uint256 = _31_1535
    let (local _37_1541 : Uint256) = __warp_holder()
    let (local _38_1542 : Uint256) = __warp_holder()
    let (local _39_1543 : Uint256) = is_zero(_38_1542)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_39_1543)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_17(_29_1533, _38_1542)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1507, expr_1522)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _10_1515 : Uint256, _23_1529 : Uint256, _5_1510 : Uint256, expr_1522 : Uint256,
        var_recipient_1507 : Uint256) -> ():
    alloc_locals
    if _23_1529.low + _23_1529.high != 0:
        __warp_block_26(_10_1515, _5_1510, expr_1522, var_recipient_1507)
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
        var_amountMinimum_1506 : Uint256, var_recipient_1507 : Uint256) -> ():
    alloc_locals
    let (local _1_1508 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1509 : Uint256) = cleanup_address(_1_1508)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1599_address : Uint256) = cleanup_address(_2_1509)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_1510 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1511 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1510.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1512 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1511.low, value=_7_1512)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1513 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1514 : Uint256) = __warp_holder()
    local _10_1515 : Uint256 = Uint256(low=4, high=0)
    let (local _11_1516 : Uint256) = u256_add(_6_1511, _10_1515)
    local range_check_ptr = range_check_ptr
    let (local _12_1517 : Uint256) = abi_encode_address(_11_1516, _9_1514)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_1518 : Uint256) = uint256_sub(_12_1517, _6_1511)
    local range_check_ptr = range_check_ptr
    let (local _14_1519 : Uint256) = __warp_holder()
    let (local _15_1520 : Uint256) = __warp_holder()
    let (local _16_1521 : Uint256) = is_zero(_15_1520)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_1521)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1522 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1522 : Uint256) = __warp_if_15(_15_1520, _6_1511, expr_1522)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1526 : Uint256) = is_lt(expr_1522, var_amountMinimum_1506)
    local range_check_ptr = range_check_ptr
    let (local _21_1527 : Uint256) = is_zero(_20_1526)
    local range_check_ptr = range_check_ptr
    require_helper(_21_1527)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _22_1528 : Uint256) = is_zero(expr_1522)
    local range_check_ptr = range_check_ptr
    let (local _23_1529 : Uint256) = is_zero(_22_1528)
    local range_check_ptr = range_check_ptr
    __warp_if_16(_10_1515, _23_1529, _5_1510, expr_1522, var_recipient_1507)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func validator_revert_bool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1666 : Uint256) -> ():
    alloc_locals
    let (local _1_1667 : Uint256) = is_zero(value_1666)
    local range_check_ptr = range_check_ptr
    let (local _2_1668 : Uint256) = is_zero(_1_1667)
    local range_check_ptr = range_check_ptr
    let (local _3_1669 : Uint256) = is_eq(value_1666, _2_1668)
    local range_check_ptr = range_check_ptr
    let (local _4_1670 : Uint256) = is_zero(_3_1669)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1670)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_t_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_41 : Uint256) -> (value_42 : Uint256):
    alloc_locals
    let (local value_42 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset_41.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    validator_revert_bool(value_42)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_42)
end

func abi_decode_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_199 : Uint256, dataEnd_200 : Uint256) -> (value0_201 : Uint256):
    alloc_locals
    local _1_202 : Uint256 = Uint256(low=32, high=0)
    let (local _2_203 : Uint256) = uint256_sub(dataEnd_200, headStart_199)
    local range_check_ptr = range_check_ptr
    let (local _3_204 : Uint256) = slt(_2_203, _1_202)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_204)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_201 : Uint256) = abi_decode_t_bool_fromMemory(headStart_199)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_201)
end

func abi_encode_address_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_493 : Uint256, value0_494 : Uint256, value1_495 : Uint256) -> (
        tail_496 : Uint256):
    alloc_locals
    local _1_497 : Uint256 = Uint256(low=64, high=0)
    let (local tail_496 : Uint256) = u256_add(headStart_493, _1_497)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value0_494, headStart_493)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_498 : Uint256 = Uint256(low=32, high=0)
    let (local _3_499 : Uint256) = u256_add(headStart_493, _2_498)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value1_495, _3_499)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_496)
end

func __warp_block_35{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1154 : Uint256, expr_1_1169 : Uint256, expr_component_mpos : Uint256) -> (
        expr_2_1170 : Uint256):
    alloc_locals
    local _17_1172 : Uint256 = _2_1154
    let (local _18_1173 : Uint256) = u256_add(expr_component_mpos, expr_1_1169)
    local range_check_ptr = range_check_ptr
    let (local _19_1174 : Uint256) = u256_add(_18_1173, _2_1154)
    local range_check_ptr = range_check_ptr
    local _20_1175 : Uint256 = _2_1154
    let (local _21_1176 : Uint256) = u256_add(expr_component_mpos, _2_1154)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1170 : Uint256) = abi_decode_bool_fromMemory(_21_1176, _19_1174)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_2_1170)
end

func __warp_if_22{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1171 : Uint256, _2_1154 : Uint256, expr_1_1169 : Uint256, expr_2_1170 : Uint256,
        expr_component_mpos : Uint256) -> (expr_2_1170 : Uint256):
    alloc_locals
    if _16_1171.low + _16_1171.high != 0:
        let (local expr_2_1170 : Uint256) = __warp_block_35(
            _2_1154, expr_1_1169, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_2_1170)
    else:
        return (expr_2_1170)
    end
end

func __warp_block_34{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1154 : Uint256, expr_component_mpos : Uint256) -> (expr_1168 : Uint256):
    alloc_locals
    let (local expr_1_1169 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        expr_component_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_2_1170 : Uint256) = is_zero(expr_1_1169)
    local range_check_ptr = range_check_ptr
    let (local _16_1171 : Uint256) = is_zero(expr_2_1170)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1170 : Uint256) = __warp_if_22(
        _16_1171, _2_1154, expr_1_1169, expr_2_1170, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1168 : Uint256 = expr_2_1170
    return (expr_1168)
end

func __warp_if_21{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1154 : Uint256, expr_1168 : Uint256, expr_1481_component : Uint256,
        expr_component_mpos : Uint256) -> (expr_1168 : Uint256):
    alloc_locals
    if expr_1481_component.low + expr_1481_component.high != 0:
        let (local expr_1168 : Uint256) = __warp_block_34(_2_1154, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1168)
    else:
        return (expr_1168)
    end
end

func fun_safeTransfer{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1150 : Uint256, var_to_1151 : Uint256, var_value_1152 : Uint256) -> ():
    alloc_locals
    local _1_1153 : Uint256 = Uint256(low=64, high=0)
    let (local expr_1480_mpos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_1153.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_1154 : Uint256 = Uint256(low=32, high=0)
    let (local _3_1155 : Uint256) = u256_add(expr_1480_mpos, _2_1154)
    local range_check_ptr = range_check_ptr
    let (local _4_1156 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_1155.low, value=_4_1156)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _5_1157 : Uint256 = Uint256(low=36, high=0)
    let (local _6_1158 : Uint256) = u256_add(expr_1480_mpos, _5_1157)
    local range_check_ptr = range_check_ptr
    let (local _7_1159 : Uint256) = abi_encode_address_uint256(_6_1158, var_to_1151, var_value_1152)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_1160 : Uint256) = uint256_sub(_7_1159, expr_1480_mpos)
    local range_check_ptr = range_check_ptr
    let (local _9_1161 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _10_1162 : Uint256) = u256_add(_8_1160, _9_1161)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=expr_1480_mpos.low, value=_10_1162)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    finalize_allocation(expr_1480_mpos, _8_1160)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_1163 : Uint256 = Uint256(low=0, high=0)
    local _12_1164 : Uint256 = _11_1163
    let (local _13_1165 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1480_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _14_1166 : Uint256 = _11_1163
    let (local _15_1167 : Uint256) = __warp_holder()
    let (local expr_1481_component : Uint256) = __warp_holder()
    let (local expr_component_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1168 : Uint256 = expr_1481_component
    let (local expr_1168 : Uint256) = __warp_if_21(
        _2_1154, expr_1168, expr_1481_component, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    require_helper(expr_1168)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func checked_mul_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_614 : Uint256, y_615 : Uint256) -> (product : Uint256):
    alloc_locals
    let (local _1_616 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_617 : Uint256) = u256_div(_1_616, x_614)
    local range_check_ptr = range_check_ptr
    let (local _3_618 : Uint256) = is_gt(y_615, _2_617)
    local range_check_ptr = range_check_ptr
    let (local _4_619 : Uint256) = is_zero(x_614)
    local range_check_ptr = range_check_ptr
    let (local _5_620 : Uint256) = is_zero(_4_619)
    local range_check_ptr = range_check_ptr
    let (local _6_621 : Uint256) = uint256_and(_5_620, _3_618)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_621)
    local exec_env : ExecutionEnvironment = exec_env
    let (local product : Uint256) = u256_mul(x_614, y_615)
    local range_check_ptr = range_check_ptr
    return (product)
end

func checked_div_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_610 : Uint256, y_611 : Uint256) -> (r_612 : Uint256):
    alloc_locals
    let (local _1_613 : Uint256) = is_zero(y_611)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_613)
    local exec_env : ExecutionEnvironment = exec_env
    let (local r_612 : Uint256) = u256_div(x_610, y_611)
    local range_check_ptr = range_check_ptr
    return (r_612)
end

func __warp_block_58{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (expr_1035 : Uint256, var_z : Uint256):
    alloc_locals
    let (local var_z : Uint256) = checked_mul_uint256(var_x, var_y)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1037 : Uint256) = checked_div_uint256(var_z, var_x)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1035 : Uint256) = is_eq(_2_1037, var_y)
    local range_check_ptr = range_check_ptr
    return (expr_1035, var_z)
end

func __warp_if_32{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1036 : Uint256, expr_1035 : Uint256, var_x : Uint256, var_y : Uint256,
        var_z : Uint256) -> (expr_1035 : Uint256, var_z : Uint256):
    alloc_locals
    if _1_1036.low + _1_1036.high != 0:
        let (local expr_1035 : Uint256, local var_z : Uint256) = __warp_block_58(var_x, var_y)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_1035, var_z)
    else:
        return (expr_1035, var_z)
    end
end

func fun_mul{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (var_z : Uint256):
    alloc_locals
    local var_z : Uint256 = Uint256(low=0, high=0)
    let (local expr_1035 : Uint256) = is_zero(var_x)
    local range_check_ptr = range_check_ptr
    let (local _1_1036 : Uint256) = is_zero(expr_1035)
    local range_check_ptr = range_check_ptr
    let (local expr_1035 : Uint256, local var_z : Uint256) = __warp_if_32(
        _1_1036, expr_1035, var_x, var_y, var_z)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1035)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_z)
end

func checked_div_uint256_4660{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_608 : Uint256) -> (r : Uint256):
    alloc_locals
    local _1_609 : Uint256 = Uint256(low=10000, high=0)
    let (local r : Uint256) = u256_div(x_608, _1_609)
    local range_check_ptr = range_check_ptr
    return (r)
end

func checked_sub_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_626 : Uint256, y_627 : Uint256) -> (diff_628 : Uint256):
    alloc_locals
    let (local _1_629 : Uint256) = is_lt(x_626, y_627)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_629)
    local exec_env : ExecutionEnvironment = exec_env
    let (local diff_628 : Uint256) = uint256_sub(x_626, y_627)
    local range_check_ptr = range_check_ptr
    return (diff_628)
end

func __warp_block_59{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_feeBips_1456 : Uint256) -> (expr_1459 : Uint256):
    alloc_locals
    local _2_1460 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1461 : Uint256) = is_gt(var_feeBips_1456, _2_1460)
    local range_check_ptr = range_check_ptr
    let (local expr_1459 : Uint256) = is_zero(_3_1461)
    local range_check_ptr = range_check_ptr
    return (expr_1459)
end

func __warp_if_33{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1459 : Uint256, var_feeBips_1456 : Uint256) -> (expr_1459 : Uint256):
    alloc_locals
    if expr_1459.low + expr_1459.high != 0:
        let (local expr_1459 : Uint256) = __warp_block_59(var_feeBips_1456)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1459)
    else:
        return (expr_1459)
    end
end

func __warp_block_60{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1465 : Uint256) -> (expr_1_1476 : Uint256):
    alloc_locals
    let (local _20_1477 : Uint256) = __warp_holder()
    finalize_allocation(_9_1465, _20_1477)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1478 : Uint256) = __warp_holder()
    let (local _22_1479 : Uint256) = u256_add(_9_1465, _21_1478)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1476 : Uint256) = abi_decode_uint256_fromMemory(_9_1465, _22_1479)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1476)
end

func __warp_if_34{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1474 : Uint256, _9_1465 : Uint256, expr_1_1476 : Uint256) -> (expr_1_1476 : Uint256):
    alloc_locals
    if _18_1474.low + _18_1474.high != 0:
        let (local expr_1_1476 : Uint256) = __warp_block_60(_9_1465)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1476)
    else:
        return (expr_1_1476)
    end
end

func __warp_block_62{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _32_1487 : Uint256) -> ():
    alloc_locals
    let (local _43_1498 : Uint256) = __warp_holder()
    finalize_allocation(_32_1487, _43_1498)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _44_1499 : Uint256) = __warp_holder()
    let (local _45_1500 : Uint256) = u256_add(_32_1487, _44_1499)
    local range_check_ptr = range_check_ptr
    abi_decode(_32_1487, _45_1500)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_36{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _32_1487 : Uint256, _41_1496 : Uint256) -> ():
    alloc_locals
    if _41_1496.low + _41_1496.high != 0:
        __warp_block_62(_32_1487)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_if_37{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _48_1504 : Uint256, expr_2_1502 : Uint256, var_feeRecipient_1457 : Uint256) -> ():
    alloc_locals
    if _48_1504.low + _48_1504.high != 0:
        fun_safeTransferETH(var_feeRecipient_1457, expr_2_1502)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_61{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _13_1469 : Uint256, _8_1464 : Uint256, expr_1_1476 : Uint256, var_feeBips_1456 : Uint256,
        var_feeRecipient_1457 : Uint256, var_recipient_1455 : Uint256) -> ():
    alloc_locals
    let (local _27_1484 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _28_1485 : Uint256) = cleanup_address(_27_1484)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1847_address : Uint256) = cleanup_address(_28_1485)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _31_1486 : Uint256 = _8_1464
    let (local _32_1487 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1464.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _33_1488 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=773487949, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_32_1487.low, value=_33_1488)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _34_1489 : Uint256 = Uint256(low=0, high=0)
    local _35_1490 : Uint256 = _13_1469
    let (local _36_1491 : Uint256) = u256_add(_32_1487, _13_1469)
    local range_check_ptr = range_check_ptr
    let (local _37_1492 : Uint256) = abi_encode_uint256(_36_1491, expr_1_1476)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _38_1493 : Uint256) = uint256_sub(_37_1492, _32_1487)
    local range_check_ptr = range_check_ptr
    local _39_1494 : Uint256 = _34_1489
    let (local _40_1495 : Uint256) = __warp_holder()
    let (local _41_1496 : Uint256) = __warp_holder()
    let (local _42_1497 : Uint256) = is_zero(_41_1496)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_42_1497)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_36(_32_1487, _41_1496)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _46_1501 : Uint256) = fun_mul(expr_1_1476, var_feeBips_1456)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1502 : Uint256) = checked_div_uint256_4660(_46_1501)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _47_1503 : Uint256) = is_zero(expr_2_1502)
    local range_check_ptr = range_check_ptr
    let (local _48_1504 : Uint256) = is_zero(_47_1503)
    local range_check_ptr = range_check_ptr
    __warp_if_37(_48_1504, expr_2_1502, var_feeRecipient_1457)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _49_1505 : Uint256) = checked_sub_uint256(expr_1_1476, expr_2_1502)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1455, _49_1505)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_35{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _13_1469 : Uint256, _26_1483 : Uint256, _8_1464 : Uint256, expr_1_1476 : Uint256,
        var_feeBips_1456 : Uint256, var_feeRecipient_1457 : Uint256,
        var_recipient_1455 : Uint256) -> ():
    alloc_locals
    if _26_1483.low + _26_1483.high != 0:
        __warp_block_61(
            _13_1469,
            _8_1464,
            expr_1_1476,
            var_feeBips_1456,
            var_feeRecipient_1457,
            var_recipient_1455)
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
        var_amountMinimum_1454 : Uint256, var_recipient_1455 : Uint256, var_feeBips_1456 : Uint256,
        var_feeRecipient_1457 : Uint256) -> ():
    alloc_locals
    let (local _1_1458 : Uint256) = is_zero(var_feeBips_1456)
    local range_check_ptr = range_check_ptr
    let (local expr_1459 : Uint256) = is_zero(_1_1458)
    local range_check_ptr = range_check_ptr
    let (local expr_1459 : Uint256) = __warp_if_33(expr_1459, var_feeBips_1456)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1459)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1462 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1463 : Uint256) = cleanup_address(_4_1462)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1828_address : Uint256) = cleanup_address(_5_1463)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_1464 : Uint256 = Uint256(low=64, high=0)
    let (local _9_1465 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1464.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _10_1466 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_9_1465.low, value=_10_1466)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _11_1467 : Uint256 = Uint256(low=32, high=0)
    let (local _12_1468 : Uint256) = __warp_holder()
    local _13_1469 : Uint256 = Uint256(low=4, high=0)
    let (local _14_1470 : Uint256) = u256_add(_9_1465, _13_1469)
    local range_check_ptr = range_check_ptr
    let (local _15_1471 : Uint256) = abi_encode_address(_14_1470, _12_1468)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1472 : Uint256) = uint256_sub(_15_1471, _9_1465)
    local range_check_ptr = range_check_ptr
    let (local _17_1473 : Uint256) = __warp_holder()
    let (local _18_1474 : Uint256) = __warp_holder()
    let (local _19_1475 : Uint256) = is_zero(_18_1474)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_19_1475)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1476 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1476 : Uint256) = __warp_if_34(_18_1474, _9_1465, expr_1_1476)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1480 : Uint256) = is_lt(expr_1_1476, var_amountMinimum_1454)
    local range_check_ptr = range_check_ptr
    let (local _24_1481 : Uint256) = is_zero(_23_1480)
    local range_check_ptr = range_check_ptr
    require_helper(_24_1481)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1482 : Uint256) = is_zero(expr_1_1476)
    local range_check_ptr = range_check_ptr
    let (local _26_1483 : Uint256) = is_zero(_25_1482)
    local range_check_ptr = range_check_ptr
    __warp_if_35(
        _13_1469,
        _26_1483,
        _8_1464,
        expr_1_1476,
        var_feeBips_1456,
        var_feeRecipient_1457,
        var_recipient_1455)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func abi_encode_address_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_404 : Uint256, value0_405 : Uint256, value1_406 : Uint256) -> (
        tail_407 : Uint256):
    alloc_locals
    local _1_408 : Uint256 = Uint256(low=64, high=0)
    let (local tail_407 : Uint256) = u256_add(headStart_404, _1_408)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value0_405, headStart_404)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_409 : Uint256 = Uint256(low=32, high=0)
    let (local _3_410 : Uint256) = u256_add(headStart_404, _2_409)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value1_406, _3_410)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_407)
end

func __warp_block_63{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1181 : Uint256) -> (expr_1193 : Uint256):
    alloc_locals
    let (local _18_1194 : Uint256) = __warp_holder()
    finalize_allocation(_6_1181, _18_1194)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1195 : Uint256) = __warp_holder()
    let (local _20_1196 : Uint256) = u256_add(_6_1181, _19_1195)
    local range_check_ptr = range_check_ptr
    let (local expr_1193 : Uint256) = abi_decode_uint256_fromMemory(_6_1181, _20_1196)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1193)
end

func __warp_if_38{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1191 : Uint256, _6_1181 : Uint256, expr_1193 : Uint256) -> (expr_1193 : Uint256):
    alloc_locals
    if _16_1191.low + _16_1191.high != 0:
        let (local expr_1193 : Uint256) = __warp_block_63(_6_1181)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1193)
    else:
        return (expr_1193)
    end
end

func __warp_if_39{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _22_1198 : Uint256, var_expiry : Uint256, var_nonce : Uint256, var_r : Uint256,
        var_s : Uint256, var_token_1177 : Uint256, var_v : Uint256) -> ():
    alloc_locals
    if _22_1198.low + _22_1198.high != 0:
        fun_selfPermitAllowed(var_token_1177, var_nonce, var_expiry, var_v, var_r, var_s)
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
        var_token_1177 : Uint256, var_nonce : Uint256, var_expiry : Uint256, var_v : Uint256,
        var_r : Uint256, var_s : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1178 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1179 : Uint256) = uint256_and(var_token_1177, _1_1178)
    local range_check_ptr = range_check_ptr
    local _5_1180 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1181 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1180.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1182 : Uint256) = uint256_shl(
        Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1181.low, value=_7_1182)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1183 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1184 : Uint256) = __warp_holder()
    let (local _10_1185 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1186 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1187 : Uint256) = u256_add(_6_1181, _11_1186)
    local range_check_ptr = range_check_ptr
    let (local _13_1188 : Uint256) = abi_encode_address_address(_12_1187, _10_1185, _9_1184)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1189 : Uint256) = uint256_sub(_13_1188, _6_1181)
    local range_check_ptr = range_check_ptr
    let (local _15_1190 : Uint256) = __warp_holder()
    let (local _16_1191 : Uint256) = __warp_holder()
    let (local _17_1192 : Uint256) = is_zero(_16_1191)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17_1192)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1193 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1193 : Uint256) = __warp_if_38(_16_1191, _6_1181, expr_1193)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1197 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _22_1198 : Uint256) = is_lt(expr_1193, _21_1197)
    local range_check_ptr = range_check_ptr
    __warp_if_39(_22_1198, var_expiry, var_nonce, var_r, var_s, var_token_1177, var_v)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_453 : Uint256, value0_454 : Uint256, value1_455 : Uint256, value2_456 : Uint256,
        value3_457 : Uint256, value4_458 : Uint256, value5_459 : Uint256, value6_460 : Uint256) -> (
        tail_461 : Uint256):
    alloc_locals
    local _1_462 : Uint256 = Uint256(low=224, high=0)
    let (local tail_461 : Uint256) = u256_add(headStart_453, _1_462)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value0_454, headStart_453)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_463 : Uint256 = Uint256(low=32, high=0)
    let (local _3_464 : Uint256) = u256_add(headStart_453, _2_463)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(value1_455, _3_464)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_465 : Uint256 = Uint256(low=64, high=0)
    let (local _5_466 : Uint256) = u256_add(headStart_453, _4_465)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value2_456, _5_466)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _6_467 : Uint256 = Uint256(low=96, high=0)
    let (local _7_468 : Uint256) = u256_add(headStart_453, _6_467)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value3_457, _7_468)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _8_469 : Uint256 = Uint256(low=128, high=0)
    let (local _9_470 : Uint256) = u256_add(headStart_453, _8_469)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value4_458, _9_470)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _10_471 : Uint256 = Uint256(low=160, high=0)
    let (local _11_472 : Uint256) = u256_add(headStart_453, _10_471)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value5_459, _11_472)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    local _12_473 : Uint256 = Uint256(low=192, high=0)
    let (local _13_474 : Uint256) = u256_add(headStart_453, _12_473)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6_460, _13_474)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_461)
end

func __warp_block_64{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1258 : Uint256) -> ():
    alloc_locals
    let (local _19_1271 : Uint256) = __warp_holder()
    finalize_allocation(_6_1258, _19_1271)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1272 : Uint256) = __warp_holder()
    let (local _21_1273 : Uint256) = u256_add(_6_1258, _20_1272)
    local range_check_ptr = range_check_ptr
    abi_decode(_6_1258, _21_1273)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_40{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _17_1269 : Uint256, _6_1258 : Uint256) -> ():
    alloc_locals
    if _17_1269.low + _17_1269.high != 0:
        __warp_block_64(_6_1258)
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
        var_token_1249 : Uint256, var_value_1250 : Uint256, var_deadline_1251 : Uint256,
        var_v_1252 : Uint256, var_r_1253 : Uint256, var_s_1254 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1255 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1256 : Uint256) = uint256_and(var_token_1249, _1_1255)
    local range_check_ptr = range_check_ptr
    local _5_1257 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1258 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1257.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1259 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=3573918927, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1258.low, value=_7_1259)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1260 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1261 : Uint256) = __warp_holder()
    let (local _10_1262 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1263 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1264 : Uint256) = u256_add(_6_1258, _11_1263)
    local range_check_ptr = range_check_ptr
    let (
        local _13_1265 : Uint256) = abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32(
        _12_1264,
        _10_1262,
        _9_1261,
        var_value_1250,
        var_deadline_1251,
        var_v_1252,
        var_r_1253,
        var_s_1254)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1266 : Uint256) = uint256_sub(_13_1265, _6_1258)
    local range_check_ptr = range_check_ptr
    local _15_1267 : Uint256 = _8_1260
    let (local _16_1268 : Uint256) = __warp_holder()
    let (local _17_1269 : Uint256) = __warp_holder()
    let (local _18_1270 : Uint256) = is_zero(_17_1269)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_18_1270)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_40(_17_1269, _6_1258)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_65{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1232 : Uint256) -> (expr_1244 : Uint256):
    alloc_locals
    let (local _18_1245 : Uint256) = __warp_holder()
    finalize_allocation(_6_1232, _18_1245)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1246 : Uint256) = __warp_holder()
    let (local _20_1247 : Uint256) = u256_add(_6_1232, _19_1246)
    local range_check_ptr = range_check_ptr
    let (local expr_1244 : Uint256) = abi_decode_uint256_fromMemory(_6_1232, _20_1247)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1244)
end

func __warp_if_41{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1242 : Uint256, _6_1232 : Uint256, expr_1244 : Uint256) -> (expr_1244 : Uint256):
    alloc_locals
    if _16_1242.low + _16_1242.high != 0:
        let (local expr_1244 : Uint256) = __warp_block_65(_6_1232)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1244)
    else:
        return (expr_1244)
    end
end

func __warp_if_42{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _21_1248 : Uint256, var_deadline : Uint256, var_r_1227 : Uint256, var_s_1228 : Uint256,
        var_token_1224 : Uint256, var_v_1226 : Uint256, var_value_1225 : Uint256) -> ():
    alloc_locals
    if _21_1248.low + _21_1248.high != 0:
        fun_selfPermit(
            var_token_1224, var_value_1225, var_deadline, var_v_1226, var_r_1227, var_s_1228)
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
        var_token_1224 : Uint256, var_value_1225 : Uint256, var_deadline : Uint256,
        var_v_1226 : Uint256, var_r_1227 : Uint256, var_s_1228 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1229 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1230 : Uint256) = uint256_and(var_token_1224, _1_1229)
    local range_check_ptr = range_check_ptr
    local _5_1231 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1232 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1231.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1233 : Uint256) = uint256_shl(
        Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1232.low, value=_7_1233)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1234 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1235 : Uint256) = __warp_holder()
    let (local _10_1236 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1237 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1238 : Uint256) = u256_add(_6_1232, _11_1237)
    local range_check_ptr = range_check_ptr
    let (local _13_1239 : Uint256) = abi_encode_address_address(_12_1238, _10_1236, _9_1235)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1240 : Uint256) = uint256_sub(_13_1239, _6_1232)
    local range_check_ptr = range_check_ptr
    let (local _15_1241 : Uint256) = __warp_holder()
    let (local _16_1242 : Uint256) = __warp_holder()
    let (local _17_1243 : Uint256) = is_zero(_16_1242)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17_1243)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1244 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1244 : Uint256) = __warp_if_41(_16_1242, _6_1232, expr_1244)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1248 : Uint256) = is_lt(expr_1244, var_value_1225)
    local range_check_ptr = range_check_ptr
    __warp_if_42(
        _21_1248, var_deadline, var_r_1227, var_s_1228, var_token_1224, var_v_1226, var_value_1225)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_66{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1371 : Uint256) -> (expr_1382 : Uint256):
    alloc_locals
    let (local _17_1383 : Uint256) = __warp_holder()
    finalize_allocation(_6_1371, _17_1383)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1384 : Uint256) = __warp_holder()
    let (local _19_1385 : Uint256) = u256_add(_6_1371, _18_1384)
    local range_check_ptr = range_check_ptr
    let (local expr_1382 : Uint256) = abi_decode_uint256_fromMemory(_6_1371, _19_1385)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1382)
end

func __warp_if_43{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1380 : Uint256, _6_1371 : Uint256, expr_1382 : Uint256) -> (expr_1382 : Uint256):
    alloc_locals
    if _15_1380.low + _15_1380.high != 0:
        let (local expr_1382 : Uint256) = __warp_block_66(_6_1371)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1382)
    else:
        return (expr_1382)
    end
end

func __warp_if_44{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _23_1389 : Uint256, expr_1382 : Uint256, var_recipient_1367 : Uint256,
        var_token_1365 : Uint256) -> ():
    alloc_locals
    if _23_1389.low + _23_1389.high != 0:
        fun_safeTransfer(var_token_1365, var_recipient_1367, expr_1382)
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
        var_token_1365 : Uint256, var_amountMinimum_1366 : Uint256,
        var_recipient_1367 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1368 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1369 : Uint256) = uint256_and(var_token_1365, _1_1368)
    local range_check_ptr = range_check_ptr
    local _5_1370 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1371 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1370.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_1372 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_6_1371.low, value=_7_1372)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _8_1373 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1374 : Uint256) = __warp_holder()
    local _10_1375 : Uint256 = Uint256(low=4, high=0)
    let (local _11_1376 : Uint256) = u256_add(_6_1371, _10_1375)
    local range_check_ptr = range_check_ptr
    let (local _12_1377 : Uint256) = abi_encode_address(_11_1376, _9_1374)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_1378 : Uint256) = uint256_sub(_12_1377, _6_1371)
    local range_check_ptr = range_check_ptr
    let (local _14_1379 : Uint256) = __warp_holder()
    let (local _15_1380 : Uint256) = __warp_holder()
    let (local _16_1381 : Uint256) = is_zero(_15_1380)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_1381)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1382 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1382 : Uint256) = __warp_if_43(_15_1380, _6_1371, expr_1382)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1386 : Uint256) = is_lt(expr_1382, var_amountMinimum_1366)
    local range_check_ptr = range_check_ptr
    let (local _21_1387 : Uint256) = is_zero(_20_1386)
    local range_check_ptr = range_check_ptr
    require_helper(_21_1387)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _22_1388 : Uint256) = is_zero(expr_1382)
    local range_check_ptr = range_check_ptr
    let (local _23_1389 : Uint256) = is_zero(_22_1388)
    local range_check_ptr = range_check_ptr
    __warp_if_44(_23_1389, expr_1382, var_recipient_1367, var_token_1365)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_67{exec_env : ExecutionEnvironment, range_check_ptr}(var_feeBips : Uint256) -> (
        expr_1335 : Uint256):
    alloc_locals
    local _2_1336 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1337 : Uint256) = is_gt(var_feeBips, _2_1336)
    local range_check_ptr = range_check_ptr
    let (local expr_1335 : Uint256) = is_zero(_3_1337)
    local range_check_ptr = range_check_ptr
    return (expr_1335)
end

func __warp_if_45{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1335 : Uint256, var_feeBips : Uint256) -> (expr_1335 : Uint256):
    alloc_locals
    if expr_1335.low + expr_1335.high != 0:
        let (local expr_1335 : Uint256) = __warp_block_67(var_feeBips)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1335)
    else:
        return (expr_1335)
    end
end

func __warp_block_68{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1341 : Uint256) -> (expr_1_1352 : Uint256):
    alloc_locals
    let (local _20_1353 : Uint256) = __warp_holder()
    finalize_allocation(_9_1341, _20_1353)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1354 : Uint256) = __warp_holder()
    let (local _22_1355 : Uint256) = u256_add(_9_1341, _21_1354)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1352 : Uint256) = abi_decode_uint256_fromMemory(_9_1341, _22_1355)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1352)
end

func __warp_if_46{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1350 : Uint256, _9_1341 : Uint256, expr_1_1352 : Uint256) -> (expr_1_1352 : Uint256):
    alloc_locals
    if _18_1350.low + _18_1350.high != 0:
        let (local expr_1_1352 : Uint256) = __warp_block_68(_9_1341)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1352)
    else:
        return (expr_1_1352)
    end
end

func __warp_if_48{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _29_1363 : Uint256, expr_2_1361 : Uint256, var_feeRecipient : Uint256,
        var_token_1332 : Uint256) -> ():
    alloc_locals
    if _29_1363.low + _29_1363.high != 0:
        fun_safeTransfer(var_token_1332, var_feeRecipient, expr_2_1361)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_69{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1_1352 : Uint256, var_feeBips : Uint256, var_feeRecipient : Uint256,
        var_recipient_1333 : Uint256, var_token_1332 : Uint256) -> ():
    alloc_locals
    let (local _27_1360 : Uint256) = fun_mul(expr_1_1352, var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1361 : Uint256) = checked_div_uint256_4660(_27_1360)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _28_1362 : Uint256) = is_zero(expr_2_1361)
    local range_check_ptr = range_check_ptr
    let (local _29_1363 : Uint256) = is_zero(_28_1362)
    local range_check_ptr = range_check_ptr
    __warp_if_48(_29_1363, expr_2_1361, var_feeRecipient, var_token_1332)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30_1364 : Uint256) = checked_sub_uint256(expr_1_1352, expr_2_1361)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransfer(var_token_1332, var_recipient_1333, _30_1364)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_47{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _26_1359 : Uint256, expr_1_1352 : Uint256, var_feeBips : Uint256,
        var_feeRecipient : Uint256, var_recipient_1333 : Uint256, var_token_1332 : Uint256) -> ():
    alloc_locals
    if _26_1359.low + _26_1359.high != 0:
        __warp_block_69(
            expr_1_1352, var_feeBips, var_feeRecipient, var_recipient_1333, var_token_1332)
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
        var_token_1332 : Uint256, var_amountMinimum : Uint256, var_recipient_1333 : Uint256,
        var_feeBips : Uint256, var_feeRecipient : Uint256) -> ():
    alloc_locals
    let (local _1_1334 : Uint256) = is_zero(var_feeBips)
    local range_check_ptr = range_check_ptr
    let (local expr_1335 : Uint256) = is_zero(_1_1334)
    local range_check_ptr = range_check_ptr
    let (local expr_1335 : Uint256) = __warp_if_45(expr_1335, var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1335)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_1338 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_1339 : Uint256) = uint256_and(var_token_1332, _4_1338)
    local range_check_ptr = range_check_ptr
    local _8_1340 : Uint256 = Uint256(low=64, high=0)
    let (local _9_1341 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1340.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _10_1342 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_9_1341.low, value=_10_1342)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _11_1343 : Uint256 = Uint256(low=32, high=0)
    let (local _12_1344 : Uint256) = __warp_holder()
    local _13_1345 : Uint256 = Uint256(low=4, high=0)
    let (local _14_1346 : Uint256) = u256_add(_9_1341, _13_1345)
    local range_check_ptr = range_check_ptr
    let (local _15_1347 : Uint256) = abi_encode_address(_14_1346, _12_1344)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1348 : Uint256) = uint256_sub(_15_1347, _9_1341)
    local range_check_ptr = range_check_ptr
    let (local _17_1349 : Uint256) = __warp_holder()
    let (local _18_1350 : Uint256) = __warp_holder()
    let (local _19_1351 : Uint256) = is_zero(_18_1350)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_19_1351)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1352 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1352 : Uint256) = __warp_if_46(_18_1350, _9_1341, expr_1_1352)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1356 : Uint256) = is_lt(expr_1_1352, var_amountMinimum)
    local range_check_ptr = range_check_ptr
    let (local _24_1357 : Uint256) = is_zero(_23_1356)
    local range_check_ptr = range_check_ptr
    require_helper(_24_1357)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1358 : Uint256) = is_zero(expr_1_1352)
    local range_check_ptr = range_check_ptr
    let (local _26_1359 : Uint256) = is_zero(_25_1358)
    local range_check_ptr = range_check_ptr
    __warp_if_47(
        _26_1359, expr_1_1352, var_feeBips, var_feeRecipient, var_recipient_1333, var_token_1332)
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
    let (local _1_711 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_712 : Uint256) = cleanup_address(_1_711)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_713 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
    local syscall_ptr : felt* = syscall_ptr
    let (local _4_714 : Uint256) = is_eq(_3_713, _2_712)
    local range_check_ptr = range_check_ptr
    require_helper(_4_714)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_72{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=136250211, high=0))
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_71{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1 : Uint256, _10 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_72(_1, _4, _7, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_70{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(
        _7.low)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_71(_1, _10, _4, _7)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_49{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_70(_1, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_if_69{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_83 : Uint256) -> ():
    alloc_locals
    if _83.low + _83.high != 0:
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
    local _1 : Uint256 = Uint256(low=64, high=0)
    local _2 : Uint256 = Uint256(low=128, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1.low, value=_2)
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
        __warp_if_49(_1, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _82 : Uint256 = _4
    let (local _83 : Uint256) = is_zero(_4)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_69(_83)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

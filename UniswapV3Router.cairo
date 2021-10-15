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

func __warp_constant_0() -> (res : Uint256):
    return (Uint256(low=0, high=0))
end

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
func balancePeople() -> (res : Uint256):
end

@storage_var
func balancePeople_2298(arg0_low, arg0_high) -> (res : Uint256):
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

func __warp_cond_revert(_3_104 : Uint256) -> ():
    alloc_locals
    if _3_104.low + _3_104.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode_struct_ExactInputSingleParams_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_99 : Uint256, end_100 : Uint256) -> (value_101 : Uint256):
    alloc_locals
    local _1_102 : Uint256 = Uint256(low=256, high=0)
    let (local _2_103 : Uint256) = uint256_sub(end_100, offset_99)
    local range_check_ptr = range_check_ptr
    let (local _3_104 : Uint256) = slt(_2_103, _1_102)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_104)
    local exec_env : ExecutionEnvironment = exec_env
    local value_101 : Uint256 = offset_99
    return (value_101)
end

func abi_decode_struct_ExactInputSingleParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_268 : Uint256, dataEnd_269 : Uint256) -> (value0_270 : Uint256):
    alloc_locals
    local _1_271 : Uint256 = Uint256(low=256, high=0)
    let (local _2_272 : Uint256) = uint256_sub(dataEnd_269, headStart_268)
    local range_check_ptr = range_check_ptr
    let (local _3_273 : Uint256) = slt(_2_272, _1_271)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_273)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_270 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata(
        headStart_268, dataEnd_269)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_270)
end

func require_helper{exec_env : ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_1637 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_1637)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func validator_revert_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1714 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1715 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1716 : Uint256) = uint256_and(value_1714, _1_1715)
    local range_check_ptr = range_check_ptr
    let (local _3_1717 : Uint256) = is_eq(value_1714, _2_1716)
    local range_check_ptr = range_check_ptr
    let (local _4_1718 : Uint256) = is_zero(_3_1717)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1718)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr : Uint256) -> (returnValue : Uint256):
    alloc_locals
    let (local value_1630 : Uint256) = calldata_load(ptr.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_address(value_1630)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue : Uint256 = value_1630
    return (returnValue)
end

func validator_revert_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1728 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1729 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1730 : Uint256) = uint256_and(value_1728, _1_1729)
    local range_check_ptr = range_check_ptr
    let (local _3_1731 : Uint256) = is_eq(value_1728, _2_1730)
    local range_check_ptr = range_check_ptr
    let (local _4_1732 : Uint256) = is_zero(_3_1731)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1732)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1631 : Uint256) -> (returnValue_1632 : Uint256):
    alloc_locals
    let (local value_1633 : Uint256) = calldata_load(ptr_1631.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_uint160(value_1633)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1632 : Uint256 = value_1633
    return (returnValue_1632)
end

func validator_revert_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1735 : Uint256) -> ():
    alloc_locals
    local _1_1736 : Uint256 = Uint256(low=16777215, high=0)
    let (local _2_1737 : Uint256) = uint256_and(value_1735, _1_1736)
    local range_check_ptr = range_check_ptr
    let (local _3_1738 : Uint256) = is_eq(value_1735, _2_1737)
    local range_check_ptr = range_check_ptr
    let (local _4_1739 : Uint256) = is_zero(_3_1738)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1739)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func read_from_calldatat_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(
        ptr_1634 : Uint256) -> (returnValue_1635 : Uint256):
    alloc_locals
    let (local value_1636 : Uint256) = calldata_load(ptr_1634.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_uint24(value_1636)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local returnValue_1635 : Uint256 = value_1636
    return (returnValue_1635)
end

func abi_encode_address_to_address_nonPadded_inplace{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_339 : Uint256, pos_340 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_1 : Uint256) = uint256_shl(
        Uint256(low=96, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_341 : Uint256) = uint256_not(__warp_subexpr_0)
    local range_check_ptr = range_check_ptr
    local _2_342 : Uint256 = Uint256(low=96, high=0)
    let (local _3_343 : Uint256) = uint256_shl(_2_342, value_339)
    local range_check_ptr = range_check_ptr
    let (local _4_344 : Uint256) = uint256_and(_3_343, _1_341)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_340.low, value=_4_344)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint24_to_uint24_nonPadded_inplace{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_424 : Uint256, pos_425 : Uint256) -> ():
    alloc_locals
    let (local _1_426 : Uint256) = uint256_shl(
        Uint256(low=232, high=0), Uint256(low=16777215, high=0))
    local range_check_ptr = range_check_ptr
    local _2_427 : Uint256 = Uint256(low=232, high=0)
    let (local _3_428 : Uint256) = uint256_shl(_2_427, value_424)
    local range_check_ptr = range_check_ptr
    let (local _4_429 : Uint256) = uint256_and(_3_428, _1_426)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_425.low, value=_4_429)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_packed_address_uint24_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_436 : Uint256, value0_437 : Uint256, value1_438 : Uint256, value2_439 : Uint256) -> (
        end_440 : Uint256):
    alloc_locals
    abi_encode_address_to_address_nonPadded_inplace(value0_437, pos_436)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_441 : Uint256 = Uint256(low=20, high=0)
    let (local _2_442 : Uint256) = u256_add(pos_436, _1_441)
    local range_check_ptr = range_check_ptr
    abi_encode_uint24_to_uint24_nonPadded_inplace(value1_438, _2_442)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _3_443 : Uint256 = Uint256(low=23, high=0)
    let (local _4_444 : Uint256) = u256_add(pos_436, _3_443)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address_nonPadded_inplace(value2_439, _4_444)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_445 : Uint256 = Uint256(low=43, high=0)
    let (local end_440 : Uint256) = u256_add(pos_436, _5_445)
    local range_check_ptr = range_check_ptr
    return (end_440)
end

func finalize_allocation{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_755 : Uint256, size_756 : Uint256) -> ():
    alloc_locals
    let (local _1_757 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _2_758 : Uint256 = Uint256(low=31, high=0)
    let (local _3_759 : Uint256) = u256_add(size_756, _2_758)
    local range_check_ptr = range_check_ptr
    let (local _4_760 : Uint256) = uint256_and(_3_759, _1_757)
    local range_check_ptr = range_check_ptr
    let (local newFreePtr : Uint256) = u256_add(memPtr_755, _4_760)
    local range_check_ptr = range_check_ptr
    let (local _5_761 : Uint256) = is_lt(newFreePtr, memPtr_755)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_762 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_763 : Uint256) = is_gt(newFreePtr, _6_762)
    local range_check_ptr = range_check_ptr
    let (local _8_764 : Uint256) = uint256_sub(_7_763, _5_761)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_764)
    local exec_env : ExecutionEnvironment = exec_env
    local _9_765 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=_9_765.low, value=newFreePtr)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        size : Uint256) -> (memPtr_615 : Uint256):
    alloc_locals
    local _1_616 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_615 : Uint256) = mload_(_1_616.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(memPtr_615, size)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_615)
end

func write_to_memory_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_1753 : Uint256, value_1754 : Uint256) -> ():
    alloc_locals
    mstore_(offset=memPtr_1753.low, value=value_1754)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func write_to_memory_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_1749 : Uint256, value_1750 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1751 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1752 : Uint256) = uint256_and(value_1750, _1_1751)
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_1749.low, value=_2_1752)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func setter_fun_balancePeople{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1695 : Uint256) -> ():
    alloc_locals
    balancePeople.write(value_1695)
    return ()
end

func setter_fun_balancePeople_2298{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(arg0 : Uint256, value_1699 : Uint256) -> ():
    alloc_locals
    balancePeople_2298.write(arg0.low, arg0.high, value_1699)
    return ()
end

func setter_fun_age{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1687 : Uint256) -> ():
    alloc_locals
    age.write(value_1687)
    return ()
end

func checked_add_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_675 : Uint256, y_676 : Uint256) -> (sum_677 : Uint256):
    alloc_locals
    let (local _1_678 : Uint256) = uint256_not(y_676)
    local range_check_ptr = range_check_ptr
    let (local _2_679 : Uint256) = is_gt(x_675, _1_678)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_679)
    local exec_env : ExecutionEnvironment = exec_env
    let (local sum_677 : Uint256) = u256_add(x_675, y_676)
    local range_check_ptr = range_check_ptr
    return (sum_677)
end

func cleanup_uint256(value_706 : Uint256) -> (cleaned_707 : Uint256):
    alloc_locals
    local cleaned_707 : Uint256 = value_706
    return (cleaned_707)
end

func fun_toAddress{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_bytes_2364_mpos : Uint256, var_start : Uint256) -> (var : Uint256):
    alloc_locals
    local _1_1365 : Uint256 = Uint256(low=20, high=0)
    let (local _2_1366 : Uint256) = checked_add_uint256(var_start, _1_1365)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1367 : Uint256) = is_lt(_2_1366, var_start)
    local range_check_ptr = range_check_ptr
    let (local _4_1368 : Uint256) = is_zero(_3_1367)
    local range_check_ptr = range_check_ptr
    require_helper(_4_1368)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1369 : Uint256) = mload_(var_bytes_2364_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1370 : Uint256 = _1_1365
    let (local _6_1371 : Uint256) = checked_add_uint256(var_start, _1_1365)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _7_1372 : Uint256) = cleanup_uint256(_6_1371)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_1373 : Uint256) = is_lt(expr_1369, _7_1372)
    local range_check_ptr = range_check_ptr
    let (local _9_1374 : Uint256) = is_zero(_8_1373)
    local range_check_ptr = range_check_ptr
    require_helper(_9_1374)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _10_1375 : Uint256 = Uint256(low=32, high=0)
    let (local _11_1376 : Uint256) = u256_add(var_bytes_2364_mpos, var_start)
    local range_check_ptr = range_check_ptr
    let (local _12_1377 : Uint256) = u256_add(_11_1376, _10_1375)
    local range_check_ptr = range_check_ptr
    let (local _13_1378 : Uint256) = mload_(_12_1377.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_1379 : Uint256 = Uint256(low=96, high=0)
    let (local var : Uint256) = uint256_shr(_14_1379, _13_1378)
    local range_check_ptr = range_check_ptr
    return (var)
end

func fun_toUint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_bytes_mpos : Uint256, var_start_1384 : Uint256) -> (var_1385 : Uint256):
    alloc_locals
    local _1_1386 : Uint256 = Uint256(low=3, high=0)
    let (local _2_1387 : Uint256) = checked_add_uint256(var_start_1384, _1_1386)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1388 : Uint256) = is_lt(_2_1387, var_start_1384)
    local range_check_ptr = range_check_ptr
    let (local _4_1389 : Uint256) = is_zero(_3_1388)
    local range_check_ptr = range_check_ptr
    require_helper(_4_1389)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1390 : Uint256) = mload_(var_bytes_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1391 : Uint256 = _1_1386
    let (local _6_1392 : Uint256) = checked_add_uint256(var_start_1384, _1_1386)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _7_1393 : Uint256) = cleanup_uint256(_6_1392)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_1394 : Uint256) = is_lt(expr_1390, _7_1393)
    local range_check_ptr = range_check_ptr
    let (local _9_1395 : Uint256) = is_zero(_8_1394)
    local range_check_ptr = range_check_ptr
    require_helper(_9_1395)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _10_1396 : Uint256 = _1_1386
    let (local _11_1397 : Uint256) = u256_add(var_bytes_mpos, var_start_1384)
    local range_check_ptr = range_check_ptr
    let (local _12_1398 : Uint256) = u256_add(_11_1397, _1_1386)
    local range_check_ptr = range_check_ptr
    let (local var_1385 : Uint256) = mload_(_12_1398.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_1385)
end

func fun_decodeFirstPool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_2485_mpos : Uint256) -> (
        var_tokenA : Uint256, var_tokenB : Uint256, var_fee : Uint256):
    alloc_locals
    local _1_803 : Uint256 = Uint256(low=0, high=0)
    let (local var_tokenA : Uint256) = fun_toAddress(var_path_2485_mpos, _1_803)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_804 : Uint256 = Uint256(low=20, high=0)
    let (local var_fee : Uint256) = fun_toUint24(var_path_2485_mpos, _2_804)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_805 : Uint256 = Uint256(low=3, high=0)
    local _4_806 : Uint256 = _2_804
    let (local _5_807 : Uint256) = checked_add_uint256(_2_804, _3_805)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local var_tokenB : Uint256) = fun_toAddress(var_path_2485_mpos, _5_807)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tokenA, var_tokenB, var_fee)
end

func getter_fun_factory{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1547 : Uint256):
    alloc_locals
    let (res) = factory.read()
    return (res)
end

func allocate_and_zero_memory_struct_struct_PoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        memPtr_606 : Uint256):
    alloc_locals
    local _1_607 : Uint256 = Uint256(low=96, high=0)
    let (local memPtr_606 : Uint256) = allocate_memory(_1_607)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_608 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=memPtr_606.low, value=_2_608)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_609 : Uint256 = _2_608
    local _4_610 : Uint256 = Uint256(low=32, high=0)
    let (local _5_611 : Uint256) = u256_add(memPtr_606, _4_610)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_5_611.low, value=_2_608)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_612 : Uint256 = _2_608
    local _7_613 : Uint256 = Uint256(low=64, high=0)
    let (local _8_614 : Uint256) = u256_add(memPtr_606, _7_613)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_8_614.low, value=_2_608)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_606)
end

func write_to_memory_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_1755 : Uint256, value_1756 : Uint256) -> ():
    alloc_locals
    local _1_1757 : Uint256 = Uint256(low=16777215, high=0)
    let (local _2_1758 : Uint256) = uint256_and(value_1756, _1_1757)
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_1755.low, value=_2_1758)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_0(var_tokenA_1002 : Uint256, var_tokenB_1003 : Uint256) -> (
        var_tokenA_1002 : Uint256, var_tokenB_1003 : Uint256):
    alloc_locals
    local expr_2578_component : Uint256 = var_tokenB_1003
    local var_tokenB_1003 : Uint256 = var_tokenA_1002
    local var_tokenA_1002 : Uint256 = expr_2578_component
    return (var_tokenA_1002, var_tokenB_1003)
end

func __warp_if_0{exec_env : ExecutionEnvironment, range_check_ptr}(
        _5_1009 : Uint256, var_tokenA_1002 : Uint256, var_tokenB_1003 : Uint256) -> (
        var_tokenA_1002 : Uint256, var_tokenB_1003 : Uint256):
    alloc_locals
    if _5_1009.low + _5_1009.high != 0:
        let (local var_tokenA_1002 : Uint256, local var_tokenB_1003 : Uint256) = __warp_block_0(
            var_tokenA_1002, var_tokenB_1003)
        local exec_env : ExecutionEnvironment = exec_env
        return (var_tokenA_1002, var_tokenB_1003)
    else:
        return (var_tokenA_1002, var_tokenB_1003)
    end
end

func fun_getPoolKey{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_tokenA_1002 : Uint256, var_tokenB_1003 : Uint256, var_fee_1004 : Uint256) -> (
        var__mpos : Uint256):
    alloc_locals
    let (local _1_1005 : Uint256) = allocate_and_zero_memory_struct_struct_PoolKey()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1006 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_1007 : Uint256) = uint256_and(var_tokenB_1003, _2_1006)
    local range_check_ptr = range_check_ptr
    let (local _4_1008 : Uint256) = uint256_and(var_tokenA_1002, _2_1006)
    local range_check_ptr = range_check_ptr
    let (local _5_1009 : Uint256) = is_gt(_4_1008, _3_1007)
    local range_check_ptr = range_check_ptr
    let (local var_tokenA_1002 : Uint256, local var_tokenB_1003 : Uint256) = __warp_if_0(
        _5_1009, var_tokenA_1002, var_tokenB_1003)
    local exec_env : ExecutionEnvironment = exec_env
    local _6_1010 : Uint256 = Uint256(low=96, high=0)
    let (local expr_2586_mpos : Uint256) = allocate_memory(_6_1010)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    write_to_memory_address(expr_2586_mpos, var_tokenA_1002)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _7_1011 : Uint256 = Uint256(low=32, high=0)
    let (local _8_1012 : Uint256) = u256_add(expr_2586_mpos, _7_1011)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_8_1012, var_tokenB_1003)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9_1013 : Uint256 = Uint256(low=64, high=0)
    let (local _10_1014 : Uint256) = u256_add(expr_2586_mpos, _9_1013)
    local range_check_ptr = range_check_ptr
    write_to_memory_uint24(_10_1014, var_fee_1004)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local var__mpos : Uint256 = expr_2586_mpos
    return (var__mpos)
end

func cleanup_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_701 : Uint256) -> (
        cleaned : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_702 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local cleaned : Uint256) = uint256_and(value_701, _1_702)
    local range_check_ptr = range_check_ptr
    return (cleaned)
end

func cleanup_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(value_703 : Uint256) -> (
        cleaned_704 : Uint256):
    alloc_locals
    local _1_705 : Uint256 = Uint256(low=16777215, high=0)
    let (local cleaned_704 : Uint256) = uint256_and(value_703, _1_705)
    local range_check_ptr = range_check_ptr
    return (cleaned_704)
end

func abi_encode_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_335 : Uint256, pos_336 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_337 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_338 : Uint256) = uint256_and(value_335, _1_337)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_336.low, value=_2_338)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_420 : Uint256, pos_421 : Uint256) -> ():
    alloc_locals
    local _1_422 : Uint256 = Uint256(low=16777215, high=0)
    let (local _2_423 : Uint256) = uint256_and(value_420, _1_422)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_421.low, value=_2_423)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_address_uint24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_468 : Uint256, value0_469 : Uint256, value1_470 : Uint256,
        value2_471 : Uint256) -> (tail_472 : Uint256):
    alloc_locals
    local _1_473 : Uint256 = Uint256(low=96, high=0)
    let (local tail_472 : Uint256) = u256_add(headStart_468, _1_473)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_469, headStart_468)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_474 : Uint256 = Uint256(low=32, high=0)
    let (local _3_475 : Uint256) = u256_add(headStart_468, _2_474)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_470, _3_475)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_476 : Uint256 = Uint256(low=64, high=0)
    let (local _5_477 : Uint256) = u256_add(headStart_468, _4_476)
    local range_check_ptr = range_check_ptr
    abi_encode_uint24(value2_471, _5_477)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_472)
end

func store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_1712 : Uint256) -> ():
    alloc_locals
    let (local _1_1713 : Uint256) = uint256_shl(Uint256(low=248, high=0), Uint256(low=255, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_1712.low, value=_1_1713)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_stringliteral_8b1a{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_402 : Uint256) -> (end_403 : Uint256):
    alloc_locals
    store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9(
        pos_402)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_404 : Uint256 = Uint256(low=1, high=0)
    let (local end_403 : Uint256) = u256_add(pos_402, _1_404)
    local range_check_ptr = range_check_ptr
    return (end_403)
end

func abi_encode_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_362 : Uint256, pos_363 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_363.low, value=value_362)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_446 : Uint256, value0_447 : Uint256, value1_448 : Uint256, value2_449 : Uint256) -> (
        end_450 : Uint256):
    alloc_locals
    let (local pos_1_451 : Uint256) = abi_encode_stringliteral_8b1a(pos_446)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address_nonPadded_inplace(value0_447, pos_1_451)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_452 : Uint256 = Uint256(low=20, high=0)
    let (local _2_453 : Uint256) = u256_add(pos_1_451, _1_452)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32(value1_448, _2_453)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _3_454 : Uint256 = Uint256(low=52, high=0)
    let (local _4_455 : Uint256) = u256_add(pos_1_451, _3_454)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32(value2_449, _4_455)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_456 : Uint256 = Uint256(low=84, high=0)
    let (local end_450 : Uint256) = u256_add(pos_1_451, _5_456)
    local range_check_ptr = range_check_ptr
    return (end_450)
end

func convert_bytes32_to_bytes20(value_724 : Uint256) -> (converted_725 : Uint256):
    alloc_locals
    local converted_725 : Uint256 = value_724
    return (converted_725)
end

func convert_bytes20_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_721 : Uint256) -> (converted_722 : Uint256):
    alloc_locals
    local _1_723 : Uint256 = Uint256(low=96, high=0)
    let (local converted_722 : Uint256) = uint256_shr(_1_723, value_721)
    local range_check_ptr = range_check_ptr
    return (converted_722)
end

func fun_computeAddress{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_factory : Uint256, var_key_mpos : Uint256) -> (var_pool : Uint256):
    alloc_locals
    let (local _1_770 : Uint256) = mload_(var_key_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_771 : Uint256) = cleanup_address(_1_770)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _3_772 : Uint256 = Uint256(low=32, high=0)
    let (local _4_773 : Uint256) = u256_add(var_key_mpos, _3_772)
    local range_check_ptr = range_check_ptr
    let (local _5_774 : Uint256) = mload_(_4_773.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_775 : Uint256) = cleanup_address(_5_774)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_776 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_777 : Uint256) = uint256_and(_6_775, _7_776)
    local range_check_ptr = range_check_ptr
    let (local _9_778 : Uint256) = uint256_and(_2_771, _7_776)
    local range_check_ptr = range_check_ptr
    let (local _10_779 : Uint256) = is_lt(_9_778, _8_777)
    local range_check_ptr = range_check_ptr
    require_helper(_10_779)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _11_780 : Uint256 = Uint256(low=64, high=0)
    let (local _12_781 : Uint256) = u256_add(var_key_mpos, _11_780)
    local range_check_ptr = range_check_ptr
    let (local _13_782 : Uint256) = mload_(_12_781.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_783 : Uint256) = cleanup_uint24(_13_782)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _15_784 : Uint256 = _11_780
    let (local expr_2626_mpos : Uint256) = mload_(_11_780.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _16_785 : Uint256 = _3_772
    let (local _17_786 : Uint256) = u256_add(expr_2626_mpos, _3_772)
    local range_check_ptr = range_check_ptr
    let (local _18_787 : Uint256) = abi_encode_address_address_uint24(
        _17_786, _2_771, _6_775, _14_783)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_788 : Uint256) = uint256_sub(_18_787, expr_2626_mpos)
    local range_check_ptr = range_check_ptr
    let (local _20_789 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _21_790 : Uint256) = u256_add(_19_788, _20_789)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_2626_mpos.low, value=_21_790)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_2626_mpos, _19_788)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22_791 : Uint256) = mload_(expr_2626_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_792 : Uint256) = sha(_17_786.low, _22_791.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _23_793 : Uint256 = _11_780
    let (local expr_2629_mpos : Uint256) = mload_(_11_780.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _24_794 : Uint256 = _3_772
    let (local _25_795 : Uint256) = u256_add(expr_2629_mpos, _3_772)
    local range_check_ptr = range_check_ptr
    local _26_796 : Uint256 = Uint256(low=166342034028256148788603429286353537876, high=302145465843558604112129201577554957650)
    let (local _27_797 : Uint256) = abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32(
        _25_795, var_factory, expr_792, _26_796)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _28_798 : Uint256) = uint256_sub(_27_797, expr_2629_mpos)
    local range_check_ptr = range_check_ptr
    let (local _29_799 : Uint256) = u256_add(_28_798, _20_789)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_2629_mpos.low, value=_29_799)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_2629_mpos, _28_798)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30_800 : Uint256) = mload_(expr_2629_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31_801 : Uint256) = sha(_25_795.low, _30_800.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _32_802 : Uint256) = convert_bytes32_to_bytes20(_31_801)
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_pool : Uint256) = convert_bytes20_to_address(_32_802)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_pool)
end

func convert_address_to_contract_IUniswapV3Pool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_716 : Uint256) -> (converted : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_717 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local converted : Uint256) = uint256_and(value_716, _1_717)
    local range_check_ptr = range_check_ptr
    return (converted)
end

func fun_getPool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_tokenA_1015 : Uint256, var_tokenB_1016 : Uint256, var_fee_1017 : Uint256) -> (
        var_address : Uint256):
    alloc_locals
    let (local _1_1018 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1019 : Uint256) = fun_getPoolKey(var_tokenA_1015, var_tokenB_1016, var_fee_1017)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_1020 : Uint256) = fun_computeAddress(_1_1018, _2_1019)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local var_address : Uint256) = convert_address_to_contract_IUniswapV3Pool(_3_1020)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_address)
end

func convert_contract_IUniswapV3Pool_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_726 : Uint256) -> (converted_727 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_728 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local converted_727 : Uint256) = uint256_and(value_726, _1_728)
    local range_check_ptr = range_check_ptr
    return (converted_727)
end

func fun_toInt256{exec_env : ExecutionEnvironment, range_check_ptr}(var_y_1380 : Uint256) -> (
        var_z_1381 : Uint256):
    alloc_locals
    let (local _1_1382 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1383 : Uint256) = is_lt(var_y_1380, _1_1382)
    local range_check_ptr = range_check_ptr
    require_helper(_2_1383)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_z_1381 : Uint256 = var_y_1380
    return (var_z_1381)
end

func checked_sub_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_691 : Uint256, y_692 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_693 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local x_1_694 : Uint256) = uint256_and(x_691, _1_693)
    local range_check_ptr = range_check_ptr
    let (local y_1_695 : Uint256) = uint256_and(y_692, _1_693)
    local range_check_ptr = range_check_ptr
    let (local _2_696 : Uint256) = is_lt(x_1_694, y_1_695)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_696)
    local exec_env : ExecutionEnvironment = exec_env
    let (local diff : Uint256) = uint256_sub(x_1_694, y_1_695)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func checked_add_uint160{exec_env : ExecutionEnvironment, range_check_ptr}(
        x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_672 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local x_1 : Uint256) = uint256_and(x, _1_672)
    local range_check_ptr = range_check_ptr
    let (local y_1 : Uint256) = uint256_and(y, _1_672)
    local range_check_ptr = range_check_ptr
    let (local _2_673 : Uint256) = uint256_sub(_1_672, y_1)
    local range_check_ptr = range_check_ptr
    let (local _3_674 : Uint256) = is_gt(x_1, _2_673)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_674)
    local exec_env : ExecutionEnvironment = exec_env
    let (local sum : Uint256) = u256_add(x_1, y_1)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func array_storeLengthForEncoding_bytes_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_651 : Uint256, length_652 : Uint256) -> (updated_pos_653 : Uint256):
    alloc_locals
    mstore_(offset=pos_651.low, value=length_652)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_654 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos_653 : Uint256) = u256_add(pos_651, _1_654)
    local range_check_ptr = range_check_ptr
    return (updated_pos_653)
end

func __warp_loop_body_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_739 : Uint256, i_741 : Uint256, src_738 : Uint256) -> (i_741 : Uint256):
    alloc_locals
    let (local _2_743 : Uint256) = u256_add(src_738, i_741)
    local range_check_ptr = range_check_ptr
    let (local _3_744 : Uint256) = mload_(_2_743.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _4_745 : Uint256) = u256_add(dst_739, i_741)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_4_745.low, value=_3_744)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_742 : Uint256 = Uint256(low=32, high=0)
    let (local i_741 : Uint256) = u256_add(i_741, _1_742)
    local range_check_ptr = range_check_ptr
    return (i_741)
end

func __warp_loop_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_739 : Uint256, i_741 : Uint256, length_740 : Uint256, src_738 : Uint256) -> (
        i_741 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(i_741, length_740)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i_741)
    end
    let (local i_741 : Uint256) = __warp_loop_body_1(dst_739, i_741, src_738)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local i_741 : Uint256) = __warp_loop_1(dst_739, i_741, length_740, src_738)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_741)
end

func __warp_block_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dst_739 : Uint256, length_740 : Uint256) -> ():
    alloc_locals
    local _6_747 : Uint256 = Uint256(low=0, high=0)
    let (local _7_748 : Uint256) = u256_add(dst_739, length_740)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_7_748.low, value=_6_747)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _5_746 : Uint256, dst_739 : Uint256, length_740 : Uint256) -> ():
    alloc_locals
    if _5_746.low + _5_746.high != 0:
        __warp_block_1(dst_739, length_740)
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
        src_738 : Uint256, dst_739 : Uint256, length_740 : Uint256) -> ():
    alloc_locals
    local i_741 : Uint256 = Uint256(low=0, high=0)
    let (local i_741 : Uint256) = __warp_loop_1(dst_739, i_741, length_740, src_738)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_746 : Uint256) = is_gt(i_741, length_740)
    local range_check_ptr = range_check_ptr
    __warp_if_1(_5_746, dst_739, length_740)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_367 : Uint256, pos_368 : Uint256) -> (end_369 : Uint256):
    alloc_locals
    let (local length_370 : Uint256) = mload_(value_367.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_1_371 : Uint256) = array_storeLengthForEncoding_bytes_memory_ptr(
        pos_368, length_370)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_372 : Uint256 = Uint256(low=32, high=0)
    let (local _2_373 : Uint256) = u256_add(value_367, _1_372)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_373, pos_1_371, length_370)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_374 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _4_375 : Uint256 = Uint256(low=31, high=0)
    let (local _5_376 : Uint256) = u256_add(length_370, _4_375)
    local range_check_ptr = range_check_ptr
    let (local _6_377 : Uint256) = uint256_and(_5_376, _3_374)
    local range_check_ptr = range_check_ptr
    let (local end_369 : Uint256) = u256_add(pos_1_371, _6_377)
    local range_check_ptr = range_check_ptr
    return (end_369)
end

func abi_encode_address_to_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_331 : Uint256, pos_332 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_333 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_334 : Uint256) = uint256_and(value_331, _1_333)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_332.low, value=_2_334)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_struct_SwapCallbackData{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_405 : Uint256, pos_406 : Uint256) -> (end_407 : Uint256):
    alloc_locals
    let (local memberValue0 : Uint256) = mload_(value_405.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_408 : Uint256 = Uint256(low=64, high=0)
    mstore_(offset=pos_406.low, value=_1_408)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_409 : Uint256 = _1_408
    let (local _3_410 : Uint256) = u256_add(pos_406, _1_408)
    local range_check_ptr = range_check_ptr
    let (local tail_411 : Uint256) = abi_encode_bytes_memory_ptr(memberValue0, _3_410)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_412 : Uint256 = Uint256(low=32, high=0)
    let (local _5_413 : Uint256) = u256_add(value_405, _4_412)
    local range_check_ptr = range_check_ptr
    let (local memberValue0_1 : Uint256) = mload_(_5_413.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _6_414 : Uint256 = _4_412
    let (local _7_415 : Uint256) = u256_add(pos_406, _4_412)
    local range_check_ptr = range_check_ptr
    abi_encode_address_to_address(memberValue0_1, _7_415)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local end_407 : Uint256 = tail_411
    return (end_407)
end

func abi_encode_struct_SwapCallbackData_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_570 : Uint256, value0_571 : Uint256) -> (tail_572 : Uint256):
    alloc_locals
    local _1_573 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=headStart_570.low, value=_1_573)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_574 : Uint256 = _1_573
    let (local _3_575 : Uint256) = u256_add(headStart_570, _1_573)
    local range_check_ptr = range_check_ptr
    let (local tail_572 : Uint256) = abi_encode_struct_SwapCallbackData(value0_571, _3_575)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_572)
end

func abi_encode_bool{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_356 : Uint256, pos_357 : Uint256) -> ():
    alloc_locals
    let (local _1_358 : Uint256) = is_zero(value_356)
    local range_check_ptr = range_check_ptr
    let (local _2_359 : Uint256) = is_zero(_1_358)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_357.low, value=_2_359)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_int256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_389 : Uint256, pos_390 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_390.low, value=value_389)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint160{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_416 : Uint256, pos_417 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_418 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_419 : Uint256) = uint256_and(value_416, _1_418)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_417.low, value=_2_419)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func array_storeLengthForEncoding_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_655 : Uint256, length_656 : Uint256) -> (updated_pos_657 : Uint256):
    alloc_locals
    mstore_(offset=pos_655.low, value=length_656)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_658 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos_657 : Uint256) = u256_add(pos_655, _1_658)
    local range_check_ptr = range_check_ptr
    return (updated_pos_657)
end

func abi_encode_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_378 : Uint256, pos_379 : Uint256) -> (end_380 : Uint256):
    alloc_locals
    let (local length_381 : Uint256) = mload_(value_378.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_1_382 : Uint256) = array_storeLengthForEncoding_bytes(pos_379, length_381)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_383 : Uint256 = Uint256(low=32, high=0)
    let (local _2_384 : Uint256) = u256_add(value_378, _1_383)
    local range_check_ptr = range_check_ptr
    copy_memory_to_memory(_2_384, pos_1_382, length_381)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_385 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _4_386 : Uint256 = Uint256(low=31, high=0)
    let (local _5_387 : Uint256) = u256_add(length_381, _4_386)
    local range_check_ptr = range_check_ptr
    let (local _6_388 : Uint256) = uint256_and(_5_387, _3_385)
    local range_check_ptr = range_check_ptr
    let (local end_380 : Uint256) = u256_add(pos_1_382, _6_388)
    local range_check_ptr = range_check_ptr
    return (end_380)
end

func abi_encode_address_bool_int256_uint160_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_533 : Uint256, value0_534 : Uint256, value1_535 : Uint256, value2_536 : Uint256,
        value3_537 : Uint256, value4_538 : Uint256) -> (tail_539 : Uint256):
    alloc_locals
    abi_encode_address(value0_534, headStart_533)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _1_540 : Uint256 = Uint256(low=32, high=0)
    let (local _2_541 : Uint256) = u256_add(headStart_533, _1_540)
    local range_check_ptr = range_check_ptr
    abi_encode_bool(value1_535, _2_541)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _3_542 : Uint256 = Uint256(low=64, high=0)
    let (local _4_543 : Uint256) = u256_add(headStart_533, _3_542)
    local range_check_ptr = range_check_ptr
    abi_encode_int256(value2_536, _4_543)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_544 : Uint256 = Uint256(low=96, high=0)
    let (local _6_545 : Uint256) = u256_add(headStart_533, _5_544)
    local range_check_ptr = range_check_ptr
    abi_encode_uint160(value3_537, _6_545)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _7_546 : Uint256 = Uint256(low=160, high=0)
    local _8_547 : Uint256 = Uint256(low=128, high=0)
    let (local _9_548 : Uint256) = u256_add(headStart_533, _8_547)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_9_548.low, value=_7_546)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _10_549 : Uint256 = _7_546
    let (local _11_550 : Uint256) = u256_add(headStart_533, _7_546)
    local range_check_ptr = range_check_ptr
    let (local tail_539 : Uint256) = abi_encode_bytes(value4_538, _11_550)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_539)
end

func abi_decode_int256t_int256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_222 : Uint256, dataEnd_223 : Uint256) -> (
        value0_224 : Uint256, value1_225 : Uint256):
    alloc_locals
    local _1_226 : Uint256 = Uint256(low=64, high=0)
    let (local _2_227 : Uint256) = uint256_sub(dataEnd_223, headStart_222)
    local range_check_ptr = range_check_ptr
    let (local _3_228 : Uint256) = slt(_2_227, _1_226)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_228)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_224 : Uint256) = mload_(headStart_222.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _4_229 : Uint256 = Uint256(low=32, high=0)
    let (local _5_230 : Uint256) = u256_add(headStart_222, _4_229)
    local range_check_ptr = range_check_ptr
    let (local value1_225 : Uint256) = mload_(_5_230.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_224, value1_225)
end

func negate_int256{exec_env : ExecutionEnvironment, range_check_ptr}(value_1601 : Uint256) -> (
        ret_1602 : Uint256):
    alloc_locals
    let (local _1_1603 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1604 : Uint256) = is_eq(value_1601, _1_1603)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_1604)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_1605 : Uint256 = Uint256(low=0, high=0)
    let (local ret_1602 : Uint256) = uint256_sub(_3_1605, value_1601)
    local range_check_ptr = range_check_ptr
    return (ret_1602)
end

func convert_int256_to_uint256(value_732 : Uint256) -> (converted_733 : Uint256):
    alloc_locals
    local converted_733 : Uint256 = value_732
    return (converted_733)
end

func __warp_if_2(_3_810 : Uint256, var_recipient : Uint256) -> (var_recipient : Uint256):
    alloc_locals
    if _3_810.low + _3_810.high != 0:
        let (local var_recipient : Uint256) = __warp_holder()
        return (var_recipient)
    else:
        return (var_recipient)
    end
end

func __warp_block_7{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_3 : Uint256):
    alloc_locals
    local _11_819 : Uint256 = Uint256(low=1, high=0)
    local _12_820 : Uint256 = Uint256(low=318775800626314356294205765087544249638, high=4294805859)
    let (local expr_3 : Uint256) = checked_sub_uint160(_12_820, _11_819)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3)
end

func __warp_block_8{exec_env : ExecutionEnvironment, range_check_ptr}() -> (expr_3 : Uint256):
    alloc_locals
    local _13_821 : Uint256 = Uint256(low=1, high=0)
    local _14_822 : Uint256 = Uint256(low=4295128739, high=0)
    let (local expr_3 : Uint256) = checked_add_uint160(_14_822, _13_821)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3)
end

func __warp_if_4{exec_env : ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        expr_3 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_3 : Uint256) = __warp_block_7()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3)
    else:
        let (local expr_3 : Uint256) = __warp_block_8()
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3)
    end
end

func __warp_block_6{exec_env : ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (
        expr_3 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_3 : Uint256) = __warp_if_4(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3)
end

func __warp_block_5{exec_env : ExecutionEnvironment, range_check_ptr}(expr_815 : Uint256) -> (
        expr_3 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_815
    let (local expr_3 : Uint256) = __warp_block_6(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3)
end

func __warp_block_4{exec_env : ExecutionEnvironment, range_check_ptr}(expr_815 : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    local expr_3 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3 : Uint256) = __warp_block_5(expr_815)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2 : Uint256 = expr_3
    return (expr_2)
end

func __warp_if_3{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_815 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_2 : Uint256 = var_sqrtPriceLimitX96
        return (expr_2)
    else:
        let (local expr_2 : Uint256) = __warp_block_4(expr_815)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_2)
    end
end

func __warp_block_3{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_815 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_2 : Uint256) = __warp_if_3(__warp_subexpr_0, expr_815, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2)
end

func __warp_block_2{exec_env : ExecutionEnvironment, range_check_ptr}(
        _10_818 : Uint256, expr_815 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (
        expr_2 : Uint256):
    alloc_locals
    local match_var : Uint256 = _10_818
    let (local expr_2 : Uint256) = __warp_block_3(expr_815, match_var, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2)
end

func __warp_block_9{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _25_831 : Uint256) -> (expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
    alloc_locals
    let (local _36_842 : Uint256) = __warp_holder()
    finalize_allocation(_25_831, _36_842)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37_843 : Uint256) = __warp_holder()
    let (local _38_844 : Uint256) = u256_add(_25_831, _37_843)
    local range_check_ptr = range_check_ptr
    let (local expr_component : Uint256,
        local expr_component_1 : Uint256) = abi_decode_int256t_int256_fromMemory(_25_831, _38_844)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_3034_component : Uint256 = expr_component
    local expr_3034_component_1 : Uint256 = expr_component_1
    return (expr_3034_component, expr_3034_component_1)
end

func __warp_if_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _25_831 : Uint256, _34_840 : Uint256, expr_3034_component : Uint256,
        expr_3034_component_1 : Uint256) -> (
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
    alloc_locals
    if _34_840.low + _34_840.high != 0:
        let (local expr_3034_component : Uint256,
            local expr_3034_component_1 : Uint256) = __warp_block_9(_25_831)
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
        expr_3034_component_1 : Uint256) -> (expr_4 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_4 : Uint256 = expr_3034_component
        return (expr_4)
    else:
        local expr_4 : Uint256 = expr_3034_component_1
        return (expr_4)
    end
end

func __warp_block_11{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256, match_var : Uint256) -> (
        expr_4 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_4 : Uint256) = __warp_if_6(
        __warp_subexpr_0, expr_3034_component, expr_3034_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    return (expr_4)
end

func __warp_block_10{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3034_component : Uint256, expr_3034_component_1 : Uint256, expr_815 : Uint256) -> (
        expr_4 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_815
    let (local expr_4 : Uint256) = __warp_block_11(
        expr_3034_component, expr_3034_component_1, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_4)
end

func fun_exactInputInternal{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_amountIn : Uint256, var_recipient : Uint256, var_sqrtPriceLimitX96 : Uint256,
        var_data_2953_mpos : Uint256) -> (var_amountOut : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_808 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_809 : Uint256) = uint256_and(var_recipient, _1_808)
    local range_check_ptr = range_check_ptr
    let (local _3_810 : Uint256) = is_zero(_2_809)
    local range_check_ptr = range_check_ptr
    let (local var_recipient : Uint256) = __warp_if_2(_3_810, var_recipient)
    local exec_env : ExecutionEnvironment = exec_env
    setter_fun_balancePeople_2298(var_recipient, var_amountIn)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_811 : Uint256 = Uint256(low=21, high=0)
    setter_fun_age(_4_811)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_812 : Uint256) = mload_(var_data_2953_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2991_component : Uint256, local expr_2991_component_1 : Uint256,
        local expr_2991_component_2 : Uint256) = fun_decodeFirstPool(_5_812)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_813 : Uint256) = uint256_and(expr_2991_component_1, _1_808)
    local range_check_ptr = range_check_ptr
    let (local _7_814 : Uint256) = uint256_and(expr_2991_component, _1_808)
    local range_check_ptr = range_check_ptr
    let (local expr_815 : Uint256) = is_lt(_7_814, _6_813)
    local range_check_ptr = range_check_ptr
    let (local _8_816 : Uint256) = fun_getPool(
        expr_2991_component, expr_2991_component_1, expr_2991_component_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_3008_address : Uint256) = convert_contract_IUniswapV3Pool_to_address(_8_816)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1 : Uint256) = fun_toInt256(var_amountIn)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_2 : Uint256 = Uint256(low=0, high=0)
    let (local _9_817 : Uint256) = uint256_and(var_sqrtPriceLimitX96, _1_808)
    local range_check_ptr = range_check_ptr
    let (local _10_818 : Uint256) = is_zero(_9_817)
    local range_check_ptr = range_check_ptr
    let (local expr_2 : Uint256) = __warp_block_2(_10_818, expr_815, var_sqrtPriceLimitX96)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _15_823 : Uint256 = Uint256(low=64, high=0)
    let (local expr_3033_mpos : Uint256) = mload_(_15_823.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _16_824 : Uint256 = Uint256(low=32, high=0)
    let (local _17_825 : Uint256) = u256_add(expr_3033_mpos, _16_824)
    local range_check_ptr = range_check_ptr
    let (local _18_826 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(
        _17_825, var_data_2953_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_827 : Uint256) = uint256_sub(_18_826, expr_3033_mpos)
    local range_check_ptr = range_check_ptr
    let (local _20_828 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _21_829 : Uint256) = u256_add(_19_827, _20_828)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_3033_mpos.low, value=_21_829)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3033_mpos, _19_827)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _24_830 : Uint256 = _15_823
    let (local _25_831 : Uint256) = mload_(_15_823.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _26_832 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1884727471, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_25_831.low, value=_26_832)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _27_833 : Uint256 = _15_823
    local _28_834 : Uint256 = Uint256(low=4, high=0)
    let (local _29_835 : Uint256) = u256_add(_25_831, _28_834)
    local range_check_ptr = range_check_ptr
    let (local _30_836 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(
        _29_835, var_recipient, expr_815, expr_1, expr_2, expr_3033_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31_837 : Uint256) = uint256_sub(_30_836, _25_831)
    local range_check_ptr = range_check_ptr
    local _32_838 : Uint256 = Uint256(low=0, high=0)
    let (local _33_839 : Uint256) = __warp_holder()
    let (local _34_840 : Uint256) = __warp_holder()
    let (local _35_841 : Uint256) = is_zero(_34_840)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_35_841)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3034_component : Uint256 = _32_838
    local expr_3034_component_1 : Uint256 = _32_838
    let (local expr_3034_component : Uint256, local expr_3034_component_1 : Uint256) = __warp_if_5(
        _25_831, _34_840, expr_3034_component, expr_3034_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_4 : Uint256 = _32_838
    let (local expr_4 : Uint256) = __warp_block_10(
        expr_3034_component, expr_3034_component_1, expr_815)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _39_845 : Uint256) = negate_int256(expr_4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local var_amountOut : Uint256) = convert_int256_to_uint256(_39_845)
    local exec_env : ExecutionEnvironment = exec_env
    return (var_amountOut)
end

func fun_exactInputSingle_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset : Uint256) -> (var_amountOut_847 : Uint256):
    alloc_locals
    local _1_848 : Uint256 = Uint256(low=96, high=0)
    let (local _2_849 : Uint256) = u256_add(var_params_offset, _1_848)
    local range_check_ptr = range_check_ptr
    let (local expr_850 : Uint256) = read_from_calldatat_address(_2_849)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _3_851 : Uint256 = Uint256(low=224, high=0)
    let (local _4_852 : Uint256) = u256_add(var_params_offset, _3_851)
    local range_check_ptr = range_check_ptr
    let (local expr_1_853 : Uint256) = read_from_calldatat_uint160(_4_852)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_854 : Uint256) = read_from_calldatat_address(var_params_offset)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_855 : Uint256 = Uint256(low=64, high=0)
    let (local _6_856 : Uint256) = u256_add(var_params_offset, _5_855)
    local range_check_ptr = range_check_ptr
    let (local expr_3_857 : Uint256) = read_from_calldatat_uint24(_6_856)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _7_858 : Uint256 = Uint256(low=32, high=0)
    let (local _8_859 : Uint256) = u256_add(var_params_offset, _7_858)
    local range_check_ptr = range_check_ptr
    let (local expr_4_860 : Uint256) = read_from_calldatat_address(_8_859)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _9_861 : Uint256 = _5_855
    let (local expr_3077_mpos : Uint256) = mload_(_5_855.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _10_862 : Uint256 = _7_858
    let (local _11_863 : Uint256) = u256_add(expr_3077_mpos, _7_858)
    local range_check_ptr = range_check_ptr
    let (local _12_864 : Uint256) = abi_encode_packed_address_uint24_address(
        _11_863, expr_2_854, expr_3_857, expr_4_860)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_865 : Uint256) = uint256_sub(_12_864, expr_3077_mpos)
    local range_check_ptr = range_check_ptr
    let (local _14_866 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _15_867 : Uint256) = u256_add(_13_865, _14_866)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_3077_mpos.low, value=_15_867)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3077_mpos, _13_865)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _16_868 : Uint256 = _5_855
    let (local expr_3080_mpos : Uint256) = allocate_memory(_5_855)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(expr_3080_mpos, expr_3077_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_869 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _18_870 : Uint256 = _7_858
    let (local _19_871 : Uint256) = u256_add(expr_3080_mpos, _7_858)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_19_871, _17_869)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _20_872 : Uint256 = Uint256(low=160, high=0)
    let (local _21_873 : Uint256) = u256_add(var_params_offset, _20_872)
    local range_check_ptr = range_check_ptr
    let (local _22_874 : Uint256) = calldata_load(_21_873.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountOut_847 : Uint256) = fun_exactInputInternal(
        _22_874, expr_850, expr_1_853, expr_3080_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _23_875 : Uint256 = Uint256(low=192, high=0)
    let (local _24_876 : Uint256) = u256_add(var_params_offset, _23_875)
    local range_check_ptr = range_check_ptr
    let (local _25_877 : Uint256) = calldata_load(_24_876.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_878 : Uint256) = is_lt(var_amountOut_847, _25_877)
    local range_check_ptr = range_check_ptr
    let (local _27_879 : Uint256) = is_zero(_26_878)
    local range_check_ptr = range_check_ptr
    require_helper(_27_879)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountOut_847)
end

func modifier_checkDeadline_3056{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_1567 : Uint256) -> (_1_1568 : Uint256):
    alloc_locals
    local _2_1569 : Uint256 = Uint256(low=128, high=0)
    let (local _3_1570 : Uint256) = u256_add(var_params_offset_1567, _2_1569)
    local range_check_ptr = range_check_ptr
    let (local _4_1571 : Uint256) = calldata_load(_3_1570.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1572 : Uint256) = __warp_holder()
    let (local _6_1573 : Uint256) = is_gt(_5_1572, _4_1571)
    local range_check_ptr = range_check_ptr
    let (local _7_1574 : Uint256) = is_zero(_6_1573)
    local range_check_ptr = range_check_ptr
    require_helper(_7_1574)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1568 : Uint256) = fun_exactInputSingle_dynArgs_inner(var_params_offset_1567)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1568)
end

func fun_exactInputSingle_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3050_offset : Uint256) -> (var_amountOut_846 : Uint256):
    alloc_locals
    let (local var_amountOut_846 : Uint256) = modifier_checkDeadline_3056(var_params_3050_offset)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountOut_846)
end

func abi_encode_uint256_to_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_430 : Uint256, pos_431 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_431.low, value=value_430)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_576 : Uint256, value0_577 : Uint256) -> (tail_578 : Uint256):
    alloc_locals
    local _1_579 : Uint256 = Uint256(low=32, high=0)
    let (local tail_578 : Uint256) = u256_add(headStart_576, _1_579)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value0_577, headStart_576)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_578)
end

func abi_decode_struct_ExactOutputSingleParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_111 : Uint256, end_112 : Uint256) -> (value_113 : Uint256):
    alloc_locals
    local _1_114 : Uint256 = Uint256(low=256, high=0)
    let (local _2_115 : Uint256) = uint256_sub(end_112, offset_111)
    local range_check_ptr = range_check_ptr
    let (local _3_116 : Uint256) = slt(_2_115, _1_114)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_116)
    local exec_env : ExecutionEnvironment = exec_env
    local value_113 : Uint256 = offset_111
    return (value_113)
end

func abi_decode_struct_ExactOutputSingleParams_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_284 : Uint256, dataEnd_285 : Uint256) -> (value0_286 : Uint256):
    alloc_locals
    local _1_287 : Uint256 = Uint256(low=256, high=0)
    let (local _2_288 : Uint256) = uint256_sub(dataEnd_285, headStart_284)
    local range_check_ptr = range_check_ptr
    let (local _3_289 : Uint256) = slt(_2_288, _1_287)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_289)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_286 : Uint256) = abi_decode_struct_ExactOutputSingleParams_calldata_ptr(
        headStart_284, dataEnd_285)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_286)
end

func __warp_if_7(__warp_subexpr_1 : Uint256, var_recipient_911 : Uint256) -> (
        var_recipient_911 : Uint256):
    alloc_locals
    if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
        let (local var_recipient_911 : Uint256) = __warp_holder()
        return (var_recipient_911)
    else:
        return (var_recipient_911)
    end
end

func __warp_if_9{exec_env : ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (
        expr_4_923 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_4_923 : Uint256) = checked_sub_uint160(
            Uint256(low=318775800626314356294205765087544249638, high=4294805859),
            Uint256(low=1, high=0))
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_4_923)
    else:
        let (local expr_4_923 : Uint256) = checked_add_uint160(
            Uint256(low=4295128739, high=0), Uint256(low=1, high=0))
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_4_923)
    end
end

func __warp_block_16{exec_env : ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (
        expr_4_923 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_4_923 : Uint256) = __warp_if_9(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_4_923)
end

func __warp_block_15{exec_env : ExecutionEnvironment, range_check_ptr}(expr_917 : Uint256) -> (
        expr_4_923 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_917
    let (local expr_4_923 : Uint256) = __warp_block_16(match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_4_923)
end

func __warp_block_14{exec_env : ExecutionEnvironment, range_check_ptr}(expr_917 : Uint256) -> (
        expr_3_922 : Uint256):
    alloc_locals
    local expr_4_923 : Uint256 = Uint256(low=0, high=0)
    let (local expr_4_923 : Uint256) = __warp_block_15(expr_917)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local expr_3_922 : Uint256 = expr_4_923
    return (expr_3_922)
end

func __warp_if_8{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_917 : Uint256, var_sqrtPriceLimitX96_912 : Uint256) -> (
        expr_3_922 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local expr_3_922 : Uint256 = var_sqrtPriceLimitX96_912
        return (expr_3_922)
    else:
        let (local expr_3_922 : Uint256) = __warp_block_14(expr_917)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3_922)
    end
end

func __warp_block_13{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_917 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96_912 : Uint256) -> (
        expr_3_922 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_3_922 : Uint256) = __warp_if_8(
        __warp_subexpr_0, expr_917, var_sqrtPriceLimitX96_912)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3_922)
end

func __warp_block_12{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_921 : Uint256, expr_917 : Uint256, var_sqrtPriceLimitX96_912 : Uint256) -> (
        expr_3_922 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_2_921
    let (local expr_3_922 : Uint256) = __warp_block_13(
        expr_917, match_var, var_sqrtPriceLimitX96_912)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3_922)
end

func __warp_block_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _8_927 : Uint256) -> (expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
    alloc_locals
    let (local _12_931 : Uint256) = __warp_holder()
    finalize_allocation(_8_927, _12_931)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_932 : Uint256) = __warp_holder()
    let (local __warp_subexpr_0 : Uint256) = u256_add(_8_927, _13_932)
    local range_check_ptr = range_check_ptr
    let (local expr_component_1_933 : Uint256,
        local expr_component_2 : Uint256) = abi_decode_int256t_int256_fromMemory(
        _8_927, __warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_3260_component : Uint256 = expr_component_1_933
    local expr_3260_component_1 : Uint256 = expr_component_2
    return (expr_3260_component, expr_3260_component_1)
end

func __warp_if_10{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _11_930 : Uint256, _8_927 : Uint256, expr_3260_component : Uint256,
        expr_3260_component_1 : Uint256) -> (
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
    alloc_locals
    if _11_930.low + _11_930.high != 0:
        let (local expr_3260_component : Uint256,
            local expr_3260_component_1 : Uint256) = __warp_block_17(_8_927)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_3260_component, expr_3260_component_1)
    else:
        return (expr_3260_component, expr_3260_component_1)
    end
end

func __warp_block_20{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_3 : Uint256):
    alloc_locals
    let (local _14_934 : Uint256) = negate_int256(expr_3260_component)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_5 : Uint256) = convert_int256_to_uint256(_14_934)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3289_component : Uint256 = expr_3260_component_1
    local expr_component_3 : Uint256 = expr_5
    return (expr_3289_component, expr_component_3)
end

func __warp_block_21{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_3 : Uint256):
    alloc_locals
    let (local _15_935 : Uint256) = negate_int256(expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_6 : Uint256) = convert_int256_to_uint256(_15_935)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3289_component : Uint256 = expr_3260_component
    local expr_component_3 : Uint256 = expr_6
    return (expr_3289_component, expr_component_3)
end

func __warp_if_11{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_3260_component : Uint256,
        expr_3260_component_1 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_3 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_3289_component : Uint256,
            local expr_component_3 : Uint256) = __warp_block_20(
            expr_3260_component, expr_3260_component_1)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3289_component, expr_component_3)
    else:
        let (local expr_3289_component : Uint256,
            local expr_component_3 : Uint256) = __warp_block_21(
            expr_3260_component, expr_3260_component_1)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_3289_component, expr_component_3)
    end
end

func __warp_block_19{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256, match_var : Uint256) -> (
        expr_3289_component : Uint256, expr_component_3 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_if_11(
        __warp_subexpr_0, expr_3260_component, expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3289_component, expr_component_3)
end

func __warp_block_18{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_3260_component : Uint256, expr_3260_component_1 : Uint256, expr_917 : Uint256) -> (
        expr_3289_component : Uint256, expr_component_3 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_917
    let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_19(
        expr_3260_component, expr_3260_component_1, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_3289_component, expr_component_3)
end

func __warp_block_22{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_component_3 : Uint256, var_amountOut_910 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(expr_component_3, var_amountOut_910)
    local range_check_ptr = range_check_ptr
    require_helper(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_12{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2_921 : Uint256, expr_component_3 : Uint256, var_amountOut_910 : Uint256) -> ():
    alloc_locals
    if expr_2_921.low + expr_2_921.high != 0:
        __warp_block_22(expr_component_3, var_amountOut_910)
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
        var_amountOut_910 : Uint256, var_recipient_911 : Uint256,
        var_sqrtPriceLimitX96_912 : Uint256, var_data_mpos : Uint256) -> (
        var_amountIn_913 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_914 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_2 : Uint256) = uint256_and(var_recipient_911, _1_914)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
    local range_check_ptr = range_check_ptr
    let (local var_recipient_911 : Uint256) = __warp_if_7(__warp_subexpr_1, var_recipient_911)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_915 : Uint256) = mload_(var_data_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_3216_component : Uint256, local expr_3216_component_1 : Uint256,
        local expr_component_916 : Uint256) = fun_decodeFirstPool(_2_915)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_4 : Uint256) = uint256_and(expr_3216_component, _1_914)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_3 : Uint256) = uint256_and(expr_3216_component_1, _1_914)
    local range_check_ptr = range_check_ptr
    let (local expr_917 : Uint256) = is_lt(__warp_subexpr_3, __warp_subexpr_4)
    local range_check_ptr = range_check_ptr
    let (local _3_918 : Uint256) = fun_getPool(
        expr_3216_component_1, expr_3216_component, expr_component_916)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_3233_address : Uint256) = convert_contract_IUniswapV3Pool_to_address(_3_918)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _4_919 : Uint256) = fun_toInt256(var_amountOut_910)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_920 : Uint256) = negate_int256(_4_919)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_5 : Uint256) = uint256_and(var_sqrtPriceLimitX96_912, _1_914)
    local range_check_ptr = range_check_ptr
    let (local expr_2_921 : Uint256) = is_zero(__warp_subexpr_5)
    local range_check_ptr = range_check_ptr
    local expr_3_922 : Uint256 = Uint256(low=0, high=0)
    let (local expr_3_922 : Uint256) = __warp_block_12(
        expr_2_921, expr_917, var_sqrtPriceLimitX96_912)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_3259_mpos : Uint256) = mload_(64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_6 : Uint256) = u256_add(expr_3259_mpos, Uint256(low=32, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_924 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(
        __warp_subexpr_6, var_data_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_925 : Uint256) = uint256_sub(_5_924, expr_3259_mpos)
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_8 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_7 : Uint256) = u256_add(_6_925, __warp_subexpr_8)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_3259_mpos.low, value=__warp_subexpr_7)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_3259_mpos, _6_925)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_926 : Uint256) = __warp_holder()
    let (local __warp_subexpr_9 : Uint256) = is_zero(_7_926)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(__warp_subexpr_9)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _8_927 : Uint256) = mload_(64)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_10 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1884727471, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_8_927.low, value=__warp_subexpr_10)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_11 : Uint256) = u256_add(_8_927, Uint256(low=4, high=0))
    local range_check_ptr = range_check_ptr
    let (local _9_928 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(
        __warp_subexpr_11, var_recipient_911, expr_917, expr_1_920, expr_3_922, expr_3259_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_929 : Uint256) = __warp_holder()
    let (local __warp_subexpr_12 : Uint256) = uint256_sub(_9_928, _8_927)
    local range_check_ptr = range_check_ptr
    let (local _11_930 : Uint256) = __warp_holder()
    let (local __warp_subexpr_13 : Uint256) = is_zero(_11_930)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(__warp_subexpr_13)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_3260_component : Uint256 = Uint256(low=0, high=0)
    local expr_3260_component_1 : Uint256 = expr_3260_component
    let (local expr_3260_component : Uint256, local expr_3260_component_1 : Uint256) = __warp_if_10(
        _11_930, _8_927, expr_3260_component, expr_3260_component_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_3289_component : Uint256 = Uint256(low=0, high=0)
    local expr_component_3 : Uint256 = expr_3289_component
    let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_18(
        expr_3260_component, expr_3260_component_1, expr_917)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_amountIn_913 : Uint256 = expr_3289_component
    __warp_if_12(expr_2_921, expr_component_3, var_amountOut_910)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountIn_913)
end

func setter_fun_amountInCached{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1691 : Uint256) -> ():
    alloc_locals
    amountInCached.write(value_1691)
    return ()
end

func fun_exactOutputSingle_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_937 : Uint256) -> (var_amountIn_938 : Uint256):
    alloc_locals
    local _1_939 : Uint256 = Uint256(low=96, high=0)
    let (local _2_940 : Uint256) = u256_add(var_params_offset_937, _1_939)
    local range_check_ptr = range_check_ptr
    let (local expr_941 : Uint256) = read_from_calldatat_address(_2_940)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _3_942 : Uint256 = Uint256(low=224, high=0)
    let (local _4_943 : Uint256) = u256_add(var_params_offset_937, _3_942)
    local range_check_ptr = range_check_ptr
    let (local expr_1_944 : Uint256) = read_from_calldatat_uint160(_4_943)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_945 : Uint256 = Uint256(low=32, high=0)
    let (local _6_946 : Uint256) = u256_add(var_params_offset_937, _5_945)
    local range_check_ptr = range_check_ptr
    let (local expr_2_947 : Uint256) = read_from_calldatat_address(_6_946)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _7_948 : Uint256 = Uint256(low=64, high=0)
    let (local _8_949 : Uint256) = u256_add(var_params_offset_937, _7_948)
    local range_check_ptr = range_check_ptr
    let (local expr_3_950 : Uint256) = read_from_calldatat_uint24(_8_949)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_4_951 : Uint256) = read_from_calldatat_address(var_params_offset_937)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _9_952 : Uint256 = _7_948
    let (local expr_mpos : Uint256) = mload_(_7_948.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _10_953 : Uint256 = _5_945
    let (local _11_954 : Uint256) = u256_add(expr_mpos, _5_945)
    local range_check_ptr = range_check_ptr
    let (local _12_955 : Uint256) = abi_encode_packed_address_uint24_address(
        _11_954, expr_2_947, expr_3_950, expr_4_951)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_956 : Uint256) = uint256_sub(_12_955, expr_mpos)
    local range_check_ptr = range_check_ptr
    let (local _14_957 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _15_958 : Uint256) = u256_add(_13_956, _14_957)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_mpos.low, value=_15_958)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_mpos, _13_956)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _16_959 : Uint256 = _7_948
    let (local expr_3336_mpos : Uint256) = allocate_memory(_7_948)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(expr_3336_mpos, expr_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_960 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _18_961 : Uint256 = _5_945
    let (local _19_962 : Uint256) = u256_add(expr_3336_mpos, _5_945)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_19_962, _17_960)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _20_963 : Uint256 = Uint256(low=160, high=0)
    let (local _21_964 : Uint256) = u256_add(var_params_offset_937, _20_963)
    local range_check_ptr = range_check_ptr
    let (local _22_965 : Uint256) = calldata_load(_21_964.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local var_amountIn_938 : Uint256) = fun_exactOutputInternal(
        _22_965, expr_941, expr_1_944, expr_3336_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _23_966 : Uint256 = Uint256(low=192, high=0)
    let (local _24_967 : Uint256) = u256_add(var_params_offset_937, _23_966)
    local range_check_ptr = range_check_ptr
    let (local _25_968 : Uint256) = calldata_load(_24_967.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_969 : Uint256) = is_gt(var_amountIn_938, _25_968)
    local range_check_ptr = range_check_ptr
    let (local _27_970 : Uint256) = is_zero(_26_969)
    local range_check_ptr = range_check_ptr
    require_helper(_27_970)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _28_971 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    setter_fun_amountInCached(_28_971)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_amountIn_938)
end

func modifier_checkDeadline_3312{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_1585 : Uint256) -> (_1_1586 : Uint256):
    alloc_locals
    local _2_1587 : Uint256 = Uint256(low=128, high=0)
    let (local _3_1588 : Uint256) = u256_add(var_params_offset_1585, _2_1587)
    local range_check_ptr = range_check_ptr
    let (local _4_1589 : Uint256) = calldata_load(_3_1588.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1590 : Uint256) = __warp_holder()
    let (local _6_1591 : Uint256) = is_gt(_5_1590, _4_1589)
    local range_check_ptr = range_check_ptr
    let (local _7_1592 : Uint256) = is_zero(_6_1591)
    local range_check_ptr = range_check_ptr
    require_helper(_7_1592)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1586 : Uint256) = fun_exactOutputSingle_dynArgs_inner(var_params_offset_1585)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1586)
end

func fun_exactOutputSingle_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3306_offset : Uint256) -> (var_amountIn_936 : Uint256):
    alloc_locals
    let (local var_amountIn_936 : Uint256) = modifier_checkDeadline_3312(var_params_3306_offset)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountIn_936)
end

func abi_decode{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_136 : Uint256, dataEnd : Uint256) -> ():
    alloc_locals
    local _1_137 : Uint256 = Uint256(low=0, high=0)
    let (local _2_138 : Uint256) = uint256_sub(dataEnd, headStart_136)
    local range_check_ptr = range_check_ptr
    let (local _3_139 : Uint256) = slt(_2_138, _1_137)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_139)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func array_allocation_size_bytes{exec_env : ExecutionEnvironment, range_check_ptr}(
        length_630 : Uint256) -> (size_631 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_632 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_633 : Uint256) = is_gt(length_630, _1_632)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_633)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_634 : Uint256 = Uint256(low=32, high=0)
    let (local _4_635 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _5_636 : Uint256 = Uint256(low=31, high=0)
    let (local _6_637 : Uint256) = u256_add(length_630, _5_636)
    local range_check_ptr = range_check_ptr
    let (local _7_638 : Uint256) = uint256_and(_6_637, _4_635)
    local range_check_ptr = range_check_ptr
    let (local size_631 : Uint256) = u256_add(_7_638, _3_634)
    local range_check_ptr = range_check_ptr
    return (size_631)
end

func allocate_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_620 : Uint256) -> (memPtr_621 : Uint256):
    alloc_locals
    let (local _1_622 : Uint256) = array_allocation_size_bytes(length_620)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPtr_621 : Uint256) = allocate_memory(_1_622)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_621.low, value=length_620)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_621)
end

func zero_memory_chunk_bytes1{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart_1765 : Uint256, dataSizeInBytes_1766 : Uint256) -> ():
    alloc_locals
    let (local _1_1767 : Uint256) = __warp_constant_0()
    calldatacopy_(dataStart_1765, _1_1767, dataSizeInBytes_1766)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func allocate_and_zero_memory_array_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_599 : Uint256) -> (memPtr_600 : Uint256):
    alloc_locals
    let (local memPtr_600 : Uint256) = allocate_memory_array_bytes(length_599)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_601 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_602 : Uint256) = array_allocation_size_bytes(length_599)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_603 : Uint256) = u256_add(_2_602, _1_601)
    local range_check_ptr = range_check_ptr
    local _4_604 : Uint256 = Uint256(low=32, high=0)
    let (local _5_605 : Uint256) = u256_add(memPtr_600, _4_604)
    local range_check_ptr = range_check_ptr
    zero_memory_chunk_bytes1(_5_605, _3_603)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_600)
end

func __warp_block_25{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        data : Uint256):
    alloc_locals
    let (local _2_750 : Uint256) = __warp_holder()
    let (local data : Uint256) = allocate_memory_array_bytes(_2_750)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _3_751 : Uint256) = __warp_holder()
    local _4_752 : Uint256 = Uint256(low=0, high=0)
    local _5_753 : Uint256 = Uint256(low=32, high=0)
    let (local _6_754 : Uint256) = u256_add(data, _5_753)
    local range_check_ptr = range_check_ptr
    __warp_holder()
    return (data)
end

func __warp_if_13{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256) -> (data : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local data : Uint256 = Uint256(low=96, high=0)
        return (data)
    else:
        let (local data : Uint256) = __warp_block_25()
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (data)
    end
end

func __warp_block_24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256) -> (data : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local data : Uint256) = __warp_if_13(__warp_subexpr_0)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func __warp_block_23{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_749 : Uint256) -> (data : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_749
    let (local data : Uint256) = __warp_block_24(match_var)
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
    let (local _1_749 : Uint256) = __warp_holder()
    let (local data : Uint256) = __warp_block_23(_1_749)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (data)
end

func fun_safeTransferETH{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_to : Uint256, var_value_1103 : Uint256) -> ():
    alloc_locals
    local _1_1104 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1562_mpos : Uint256) = allocate_and_zero_memory_array_bytes(_1_1104)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_1105 : Uint256 = _1_1104
    local _3_1106 : Uint256 = _1_1104
    let (local _4_1107 : Uint256) = mload_(expr_1562_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1108 : Uint256 = Uint256(low=32, high=0)
    let (local _6_1109 : Uint256) = u256_add(expr_1562_mpos, _5_1108)
    local range_check_ptr = range_check_ptr
    let (local _7_1110 : Uint256) = __warp_holder()
    let (local expr_component_1111 : Uint256) = __warp_holder()
    let (local _8_1112 : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    require_helper(expr_component_1111)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_26{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}() -> ():
    alloc_locals
    let (local _4_1101 : Uint256) = __warp_holder()
    let (local _5_1102 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    fun_safeTransferETH(_5_1102, _4_1101)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_14{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_3_1100 : Uint256) -> ():
    alloc_locals
    if _3_1100.low + _3_1100.high != 0:
        __warp_block_26()
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
    let (local _1_1098 : Uint256) = __warp_holder()
    let (local _2_1099 : Uint256) = is_zero(_1_1098)
    local range_check_ptr = range_check_ptr
    let (local _3_1100 : Uint256) = is_zero(_2_1099)
    local range_check_ptr = range_check_ptr
    __warp_if_14(_3_1100)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func getter_fun_succinctly{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1551 : Uint256):
    alloc_locals
    let (res) = succinctly.read()
    return (res)
end

func abi_encode_tuple_address{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_457 : Uint256, value0_458 : Uint256) -> (tail_459 : Uint256):
    alloc_locals
    local _1_460 : Uint256 = Uint256(low=32, high=0)
    let (local tail_459 : Uint256) = u256_add(headStart_457, _1_460)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_458, headStart_457)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_459)
end

func getter_fun_age{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1543 : Uint256):
    alloc_locals
    let (res) = age.read()
    return (res)
end

func getter_fun_OCaml{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1539 : Uint256):
    alloc_locals
    let (res) = OCaml.read()
    return (res)
end

func abi_decode_address{exec_env : ExecutionEnvironment, range_check_ptr}(offset : Uint256) -> (
        value : Uint256):
    alloc_locals
    let (local value : Uint256) = calldata_load(offset.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_address(value)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value)
end

func validator_revert_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1742 : Uint256) -> ():
    alloc_locals
    local _1_1743 : Uint256 = Uint256(low=255, high=0)
    let (local _2_1744 : Uint256) = uint256_and(value_1742, _1_1743)
    local range_check_ptr = range_check_ptr
    let (local _3_1745 : Uint256) = is_eq(value_1742, _2_1744)
    local range_check_ptr = range_check_ptr
    let (local _4_1746 : Uint256) = is_zero(_3_1745)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1746)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_uint8{exec_env : ExecutionEnvironment, range_check_ptr}(offset_134 : Uint256) -> (
        value_135 : Uint256):
    alloc_locals
    let (local value_135 : Uint256) = calldata_load(offset_134.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    validator_revert_uint8(value_135)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_135)
end

func abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_185 : Uint256, dataEnd_186 : Uint256) -> (
        value0_187 : Uint256, value1_188 : Uint256, value2_189 : Uint256, value3_190 : Uint256,
        value4_191 : Uint256, value5 : Uint256):
    alloc_locals
    local _1_192 : Uint256 = Uint256(low=192, high=0)
    let (local _2_193 : Uint256) = uint256_sub(dataEnd_186, headStart_185)
    local range_check_ptr = range_check_ptr
    let (local _3_194 : Uint256) = slt(_2_193, _1_192)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_194)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_187 : Uint256) = abi_decode_address(headStart_185)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_195 : Uint256 = Uint256(low=32, high=0)
    let (local _5_196 : Uint256) = u256_add(headStart_185, _4_195)
    local range_check_ptr = range_check_ptr
    let (local value1_188 : Uint256) = calldata_load(_5_196.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_197 : Uint256 = Uint256(low=64, high=0)
    let (local _7_198 : Uint256) = u256_add(headStart_185, _6_197)
    local range_check_ptr = range_check_ptr
    let (local value2_189 : Uint256) = calldata_load(_7_198.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_199 : Uint256 = Uint256(low=96, high=0)
    let (local _9_200 : Uint256) = u256_add(headStart_185, _8_199)
    local range_check_ptr = range_check_ptr
    let (local value3_190 : Uint256) = abi_decode_uint8(_9_200)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _10_201 : Uint256 = Uint256(low=128, high=0)
    let (local _11_202 : Uint256) = u256_add(headStart_185, _10_201)
    local range_check_ptr = range_check_ptr
    let (local value4_191 : Uint256) = calldata_load(_11_202.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _12_203 : Uint256 = Uint256(low=160, high=0)
    let (local _13_204 : Uint256) = u256_add(headStart_185, _12_203)
    local range_check_ptr = range_check_ptr
    let (local value5 : Uint256) = calldata_load(_13_204.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (value0_187, value1_188, value2_189, value3_190, value4_191, value5)
end

func abi_encode_uint8{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_432 : Uint256, pos_433 : Uint256) -> ():
    alloc_locals
    local _1_434 : Uint256 = Uint256(low=255, high=0)
    let (local _2_435 : Uint256) = uint256_and(value_432, _1_434)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_433.low, value=_2_435)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_bytes32_to_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_360 : Uint256, pos_361 : Uint256) -> ():
    alloc_locals
    mstore_(offset=pos_361.low, value=value_360)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_488 : Uint256, value0_489 : Uint256, value1_490 : Uint256, value2_491 : Uint256,
        value3_492 : Uint256, value4_493 : Uint256, value5_494 : Uint256, value6 : Uint256,
        value7 : Uint256) -> (tail_495 : Uint256):
    alloc_locals
    local _1_496 : Uint256 = Uint256(low=256, high=0)
    let (local tail_495 : Uint256) = u256_add(headStart_488, _1_496)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_489, headStart_488)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_497 : Uint256 = Uint256(low=32, high=0)
    let (local _3_498 : Uint256) = u256_add(headStart_488, _2_497)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_490, _3_498)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_499 : Uint256 = Uint256(low=64, high=0)
    let (local _5_500 : Uint256) = u256_add(headStart_488, _4_499)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_491, _5_500)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_501 : Uint256 = Uint256(low=96, high=0)
    let (local _7_502 : Uint256) = u256_add(headStart_488, _6_501)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value3_492, _7_502)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_503 : Uint256 = Uint256(low=128, high=0)
    let (local _9_504 : Uint256) = u256_add(headStart_488, _8_503)
    local range_check_ptr = range_check_ptr
    abi_encode_bool(value4_493, _9_504)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _10_505 : Uint256 = Uint256(low=160, high=0)
    let (local _11_506 : Uint256) = u256_add(headStart_488, _10_505)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value5_494, _11_506)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _12_507 : Uint256 = Uint256(low=192, high=0)
    let (local _13_508 : Uint256) = u256_add(headStart_488, _12_507)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6, _13_508)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14_509 : Uint256 = Uint256(low=224, high=0)
    let (local _15_510 : Uint256) = u256_add(headStart_488, _14_509)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value7, _15_510)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_495)
end

func abi_decode_fromMemory{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_140 : Uint256, dataEnd_141 : Uint256) -> ():
    alloc_locals
    local _1_142 : Uint256 = Uint256(low=0, high=0)
    let (local _2_143 : Uint256) = uint256_sub(dataEnd_141, headStart_140)
    local range_check_ptr = range_check_ptr
    let (local _3_144 : Uint256) = slt(_2_143, _1_142)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_144)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func __warp_block_27{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1198 : Uint256) -> ():
    alloc_locals
    let (local _20_1212 : Uint256) = __warp_holder()
    finalize_allocation(_6_1198, _20_1212)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1213 : Uint256) = __warp_holder()
    let (local _22_1214 : Uint256) = u256_add(_6_1198, _21_1213)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_6_1198, _22_1214)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_15{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1210 : Uint256, _6_1198 : Uint256) -> ():
    alloc_locals
    if _18_1210.low + _18_1210.high != 0:
        __warp_block_27(_6_1198)
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
        var_token_1189 : Uint256, var_nonce_1190 : Uint256, var_expiry_1191 : Uint256,
        var_v_1192 : Uint256, var_r_1193 : Uint256, var_s_1194 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1195 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1196 : Uint256) = uint256_and(var_token_1189, _1_1195)
    local range_check_ptr = range_check_ptr
    local _5_1197 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1198 : Uint256) = mload_(_5_1197.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1199 : Uint256) = uint256_shl(
        Uint256(low=226, high=0), Uint256(low=603122627, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1198.low, value=_7_1199)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1200 : Uint256 = Uint256(low=0, high=0)
    local _9_1201 : Uint256 = Uint256(low=1, high=0)
    let (local _10_1202 : Uint256) = __warp_holder()
    let (local _11_1203 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _12_1204 : Uint256 = Uint256(low=4, high=0)
    let (local _13_1205 : Uint256) = u256_add(_6_1198, _12_1204)
    local range_check_ptr = range_check_ptr
    let (
        local _14_1206 : Uint256) = abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32(
        _13_1205,
        _11_1203,
        _10_1202,
        var_nonce_1190,
        var_expiry_1191,
        _9_1201,
        var_v_1192,
        var_r_1193,
        var_s_1194)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1207 : Uint256) = uint256_sub(_14_1206, _6_1198)
    local range_check_ptr = range_check_ptr
    local _16_1208 : Uint256 = _8_1200
    let (local _17_1209 : Uint256) = __warp_holder()
    let (local _18_1210 : Uint256) = __warp_holder()
    let (local _19_1211 : Uint256) = is_zero(_18_1210)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_19_1211)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_15(_18_1210, _6_1198)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_struct_ExactOutputParams_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_105 : Uint256, end_106 : Uint256) -> (value_107 : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=160, high=0)
    let (local _2_109 : Uint256) = uint256_sub(end_106, offset_105)
    local range_check_ptr = range_check_ptr
    let (local _3_110 : Uint256) = slt(_2_109, _1_108)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_110)
    local exec_env : ExecutionEnvironment = exec_env
    local value_107 : Uint256 = offset_105
    return (value_107)
end

func abi_decode_struct_ExactOutputParams_calldata_ptr{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_274 : Uint256, dataEnd_275 : Uint256) -> (value0_276 : Uint256):
    alloc_locals
    local _1_277 : Uint256 = Uint256(low=32, high=0)
    let (local _2_278 : Uint256) = uint256_sub(dataEnd_275, headStart_274)
    local range_check_ptr = range_check_ptr
    let (local _3_279 : Uint256) = slt(_2_278, _1_277)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_279)
    local exec_env : ExecutionEnvironment = exec_env
    let (local offset_280 : Uint256) = calldata_load(headStart_274.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_281 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_282 : Uint256) = is_gt(offset_280, _4_281)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_282)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_283 : Uint256) = u256_add(headStart_274, offset_280)
    local range_check_ptr = range_check_ptr
    let (local value0_276 : Uint256) = abi_decode_struct_ExactOutputParams_calldata(
        _6_283, dataEnd_275)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_276)
end

func access_calldata_tail_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref : Uint256, ptr_to_tail : Uint256) -> (addr : Uint256, length_580 : Uint256):
    alloc_locals
    let (local rel_offset_of_tail : Uint256) = calldata_load(ptr_to_tail.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _1_581 : Uint256) = uint256_not(Uint256(low=30, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_582 : Uint256) = __warp_constant_0()
    let (local _3_583 : Uint256) = uint256_sub(_2_582, base_ref)
    local range_check_ptr = range_check_ptr
    let (local _4_584 : Uint256) = u256_add(_3_583, _1_581)
    local range_check_ptr = range_check_ptr
    let (local _5_585 : Uint256) = slt(rel_offset_of_tail, _4_584)
    local range_check_ptr = range_check_ptr
    let (local _6_586 : Uint256) = is_zero(_5_585)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_586)
    local exec_env : ExecutionEnvironment = exec_env
    let (local addr_1 : Uint256) = u256_add(base_ref, rel_offset_of_tail)
    local range_check_ptr = range_check_ptr
    let (local length_580 : Uint256) = calldata_load(addr_1.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _7_587 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_588 : Uint256) = is_gt(length_580, _7_587)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_8_588)
    local exec_env : ExecutionEnvironment = exec_env
    local _9_589 : Uint256 = Uint256(low=32, high=0)
    let (local addr : Uint256) = u256_add(addr_1, _9_589)
    local range_check_ptr = range_check_ptr
    local _10_590 : Uint256 = _2_582
    let (local _11_591 : Uint256) = uint256_sub(_2_582, length_580)
    local range_check_ptr = range_check_ptr
    let (local _12_592 : Uint256) = sgt(addr, _11_591)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_12_592)
    local exec_env : ExecutionEnvironment = exec_env
    return (addr, length_580)
end

func copy_calldata_to_memory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        src_734 : Uint256, dst : Uint256, length_735 : Uint256) -> ():
    alloc_locals
    calldatacopy_(dst, src_734, length_735)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _1_736 : Uint256 = Uint256(low=0, high=0)
    let (local _2_737 : Uint256) = u256_add(dst, length_735)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_2_737.low, value=_1_736)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
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
    mstore_(offset=array.low, value=length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_2 : Uint256) = u256_add(src, length)
    local range_check_ptr = range_check_ptr
    let (local _3_3 : Uint256) = is_gt(_2_2, end__warp_mangled)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_3)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_4 : Uint256 = Uint256(low=32, high=0)
    let (local _5_5 : Uint256) = u256_add(array, _4_4)
    local range_check_ptr = range_check_ptr
    copy_calldata_to_memory(src, _5_5, length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array)
end

func getter_fun_amountInCached{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1545 : Uint256):
    alloc_locals
    let (res) = amountInCached.read()
    return (res)
end

func fun_exactOutput_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_974 : Uint256) -> (var_amountIn_975 : Uint256):
    alloc_locals
    local _1_976 : Uint256 = Uint256(low=32, high=0)
    let (local _2_977 : Uint256) = u256_add(var_params_offset_974, _1_976)
    local range_check_ptr = range_check_ptr
    let (local expr_978 : Uint256) = read_from_calldatat_address(_2_977)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_offset : Uint256,
        local expr_3373_length : Uint256) = access_calldata_tail_bytes_calldata(
        var_params_offset_974, var_params_offset_974)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _3_979 : Uint256 = Uint256(low=64, high=0)
    let (local expr_3376_mpos : Uint256) = allocate_memory(_3_979)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _4_980 : Uint256) = __warp_constant_0()
    let (local _5_981 : Uint256) = abi_decode_available_length_bytes(
        expr_offset, expr_3373_length, _4_980)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(expr_3376_mpos, _5_981)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_982 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _7_983 : Uint256 = _1_976
    let (local _8_984 : Uint256) = u256_add(expr_3376_mpos, _1_976)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_8_984, _6_982)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9_985 : Uint256 = Uint256(low=0, high=0)
    local _10_986 : Uint256 = Uint256(low=96, high=0)
    let (local _11_987 : Uint256) = u256_add(var_params_offset_974, _10_986)
    local range_check_ptr = range_check_ptr
    let (local _12_988 : Uint256) = calldata_load(_11_987.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _13_989 : Uint256) = fun_exactOutputInternal(
        _12_988, expr_978, _9_985, expr_3376_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    __warp_holder()
    let (local var_amountIn_975 : Uint256) = getter_fun_amountInCached()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14_990 : Uint256 = Uint256(low=128, high=0)
    let (local _15_991 : Uint256) = u256_add(var_params_offset_974, _14_990)
    local range_check_ptr = range_check_ptr
    let (local _16_992 : Uint256) = calldata_load(_15_991.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _17_993 : Uint256) = is_gt(var_amountIn_975, _16_992)
    local range_check_ptr = range_check_ptr
    let (local _18_994 : Uint256) = is_zero(_17_993)
    local range_check_ptr = range_check_ptr
    require_helper(_18_994)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _19_995 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    setter_fun_amountInCached(_19_995)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (var_amountIn_975)
end

func modifier_checkDeadline{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_1593 : Uint256) -> (_1_1594 : Uint256):
    alloc_locals
    local _2_1595 : Uint256 = Uint256(low=64, high=0)
    let (local _3_1596 : Uint256) = u256_add(var_params_offset_1593, _2_1595)
    local range_check_ptr = range_check_ptr
    let (local _4_1597 : Uint256) = calldata_load(_3_1596.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1598 : Uint256) = __warp_holder()
    let (local _6_1599 : Uint256) = is_gt(_5_1598, _4_1597)
    local range_check_ptr = range_check_ptr
    let (local _7_1600 : Uint256) = is_zero(_6_1599)
    local range_check_ptr = range_check_ptr
    require_helper(_7_1600)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1594 : Uint256) = fun_exactOutput_dynArgs_inner(var_params_offset_1593)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1594)
end

func fun_exactOutput_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_offset_972 : Uint256) -> (var_amountIn_973 : Uint256):
    alloc_locals
    let (local var_amountIn_973 : Uint256) = modifier_checkDeadline(var_params_offset_972)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountIn_973)
end

func abi_decode_uint256t_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_306 : Uint256, dataEnd_307 : Uint256) -> (
        value0_308 : Uint256, value1_309 : Uint256):
    alloc_locals
    local _1_310 : Uint256 = Uint256(low=64, high=0)
    let (local _2_311 : Uint256) = uint256_sub(dataEnd_307, headStart_306)
    local range_check_ptr = range_check_ptr
    let (local _3_312 : Uint256) = slt(_2_311, _1_310)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_312)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_308 : Uint256) = calldata_load(headStart_306.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_313 : Uint256 = Uint256(low=32, high=0)
    let (local _5_314 : Uint256) = u256_add(headStart_306, _4_313)
    local range_check_ptr = range_check_ptr
    let (local value1_309 : Uint256) = abi_decode_address(_5_314)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_308, value1_309)
end

func getter_fun_WETH9{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1541 : Uint256):
    alloc_locals
    let (res) = WETH9.read()
    return (res)
end

func convert_address_to_contract_IWETH9{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_718 : Uint256) -> (converted_719 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_720 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local converted_719 : Uint256) = uint256_and(value_718, _1_720)
    local range_check_ptr = range_check_ptr
    return (converted_719)
end

func convert_contract_IWETH9_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_729 : Uint256) -> (converted_730 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_731 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local converted_730 : Uint256) = uint256_and(value_729, _1_731)
    local range_check_ptr = range_check_ptr
    return (converted_730)
end

func abi_decode_uint256_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_300 : Uint256, dataEnd_301 : Uint256) -> (value0_302 : Uint256):
    alloc_locals
    local _1_303 : Uint256 = Uint256(low=32, high=0)
    let (local _2_304 : Uint256) = uint256_sub(dataEnd_301, headStart_300)
    local range_check_ptr = range_check_ptr
    let (local _3_305 : Uint256) = slt(_2_304, _1_303)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_305)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_302 : Uint256) = mload_(headStart_300.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_302)
end

func __warp_block_28{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1490 : Uint256) -> (expr_1501 : Uint256):
    alloc_locals
    let (local _17_1502 : Uint256) = __warp_holder()
    finalize_allocation(_6_1490, _17_1502)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1503 : Uint256) = __warp_holder()
    let (local _19_1504 : Uint256) = u256_add(_6_1490, _18_1503)
    local range_check_ptr = range_check_ptr
    let (local expr_1501 : Uint256) = abi_decode_uint256_fromMemory(_6_1490, _19_1504)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1501)
end

func __warp_if_16{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1499 : Uint256, _6_1490 : Uint256, expr_1501 : Uint256) -> (expr_1501 : Uint256):
    alloc_locals
    if _15_1499.low + _15_1499.high != 0:
        let (local expr_1501 : Uint256) = __warp_block_28(_6_1490)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1501)
    else:
        return (expr_1501)
    end
end

func __warp_block_30{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _29_1512 : Uint256) -> ():
    alloc_locals
    let (local _40_1523 : Uint256) = __warp_holder()
    finalize_allocation(_29_1512, _40_1523)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _41_1524 : Uint256) = __warp_holder()
    let (local _42_1525 : Uint256) = u256_add(_29_1512, _41_1524)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_29_1512, _42_1525)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_18{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _29_1512 : Uint256, _38_1521 : Uint256) -> ():
    alloc_locals
    if _38_1521.low + _38_1521.high != 0:
        __warp_block_30(_29_1512)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_29{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _10_1494 : Uint256, _5_1489 : Uint256, expr_1501 : Uint256,
        var_recipient_1486 : Uint256) -> ():
    alloc_locals
    let (local _24_1509 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _25_1510 : Uint256) = convert_address_to_contract_IWETH9(_24_1509)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1618_address : Uint256) = convert_contract_IWETH9_to_address(_25_1510)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _28_1511 : Uint256 = _5_1489
    let (local _29_1512 : Uint256) = mload_(_5_1489.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _30_1513 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=773487949, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_29_1512.low, value=_30_1513)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _31_1514 : Uint256 = Uint256(low=0, high=0)
    local _32_1515 : Uint256 = _10_1494
    let (local _33_1516 : Uint256) = u256_add(_29_1512, _10_1494)
    local range_check_ptr = range_check_ptr
    let (local _34_1517 : Uint256) = abi_encode_uint256(_33_1516, expr_1501)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _35_1518 : Uint256) = uint256_sub(_34_1517, _29_1512)
    local range_check_ptr = range_check_ptr
    local _36_1519 : Uint256 = _31_1514
    let (local _37_1520 : Uint256) = __warp_holder()
    let (local _38_1521 : Uint256) = __warp_holder()
    let (local _39_1522 : Uint256) = is_zero(_38_1521)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_39_1522)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_18(_29_1512, _38_1521)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1486, expr_1501)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_17{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _10_1494 : Uint256, _23_1508 : Uint256, _5_1489 : Uint256, expr_1501 : Uint256,
        var_recipient_1486 : Uint256) -> ():
    alloc_locals
    if _23_1508.low + _23_1508.high != 0:
        __warp_block_29(_10_1494, _5_1489, expr_1501, var_recipient_1486)
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
        var_amountMinimum_1485 : Uint256, var_recipient_1486 : Uint256) -> ():
    alloc_locals
    let (local _1_1487 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1488 : Uint256) = convert_address_to_contract_IWETH9(_1_1487)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1599_address : Uint256) = convert_contract_IWETH9_to_address(_2_1488)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _5_1489 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1490 : Uint256) = mload_(_5_1489.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1491 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1490.low, value=_7_1491)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1492 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1493 : Uint256) = __warp_holder()
    local _10_1494 : Uint256 = Uint256(low=4, high=0)
    let (local _11_1495 : Uint256) = u256_add(_6_1490, _10_1494)
    local range_check_ptr = range_check_ptr
    let (local _12_1496 : Uint256) = abi_encode_tuple_address(_11_1495, _9_1493)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_1497 : Uint256) = uint256_sub(_12_1496, _6_1490)
    local range_check_ptr = range_check_ptr
    let (local _14_1498 : Uint256) = __warp_holder()
    let (local _15_1499 : Uint256) = __warp_holder()
    let (local _16_1500 : Uint256) = is_zero(_15_1499)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_1500)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1501 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1501 : Uint256) = __warp_if_16(_15_1499, _6_1490, expr_1501)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1505 : Uint256) = is_lt(expr_1501, var_amountMinimum_1485)
    local range_check_ptr = range_check_ptr
    let (local _21_1506 : Uint256) = is_zero(_20_1505)
    local range_check_ptr = range_check_ptr
    require_helper(_21_1506)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _22_1507 : Uint256) = is_zero(expr_1501)
    local range_check_ptr = range_check_ptr
    let (local _23_1508 : Uint256) = is_zero(_22_1507)
    local range_check_ptr = range_check_ptr
    __warp_if_17(_10_1494, _23_1508, _5_1489, expr_1501, var_recipient_1486)
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
        offset_48 : Uint256, end_49 : Uint256) -> (array_50 : Uint256):
    alloc_locals
    local _1_51 : Uint256 = Uint256(low=31, high=0)
    let (local _2_52 : Uint256) = u256_add(offset_48, _1_51)
    local range_check_ptr = range_check_ptr
    let (local _3_53 : Uint256) = slt(_2_52, end_49)
    local range_check_ptr = range_check_ptr
    let (local _4_54 : Uint256) = is_zero(_3_53)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_54)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_55 : Uint256) = calldata_load(offset_48.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_56 : Uint256 = Uint256(low=32, high=0)
    let (local _7_57 : Uint256) = u256_add(offset_48, _6_56)
    local range_check_ptr = range_check_ptr
    let (local array_50 : Uint256) = abi_decode_available_length_bytes(_7_57, _5_55, end_49)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (array_50)
end

func abi_decode_struct_ExactInputParams{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, end_68 : Uint256) -> (value_69 : Uint256):
    alloc_locals
    local _1_70 : Uint256 = Uint256(low=160, high=0)
    let (local _2_71 : Uint256) = uint256_sub(end_68, headStart)
    local range_check_ptr = range_check_ptr
    let (local _3_72 : Uint256) = slt(_2_71, _1_70)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_72)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_73 : Uint256 = _1_70
    let (local value_69 : Uint256) = allocate_memory(_1_70)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local offset_74 : Uint256) = calldata_load(headStart.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_75 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_76 : Uint256) = is_gt(offset_74, _5_75)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_76)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_77 : Uint256) = u256_add(headStart, offset_74)
    local range_check_ptr = range_check_ptr
    let (local _8_78 : Uint256) = abi_decode_bytes(_7_77, end_68)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=value_69.low, value=_8_78)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _9_79 : Uint256 = Uint256(low=32, high=0)
    let (local _10_80 : Uint256) = u256_add(headStart, _9_79)
    local range_check_ptr = range_check_ptr
    let (local _11_81 : Uint256) = abi_decode_address(_10_80)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _12_82 : Uint256 = _9_79
    let (local _13_83 : Uint256) = u256_add(value_69, _9_79)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_13_83.low, value=_11_81)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_84 : Uint256 = Uint256(low=64, high=0)
    let (local _15_85 : Uint256) = u256_add(headStart, _14_84)
    local range_check_ptr = range_check_ptr
    let (local _16_86 : Uint256) = calldata_load(_15_85.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _17_87 : Uint256 = _14_84
    let (local _18_88 : Uint256) = u256_add(value_69, _14_84)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_18_88.low, value=_16_86)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _19_89 : Uint256 = Uint256(low=96, high=0)
    let (local _20_90 : Uint256) = u256_add(headStart, _19_89)
    local range_check_ptr = range_check_ptr
    let (local _21_91 : Uint256) = calldata_load(_20_90.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _22_92 : Uint256 = _19_89
    let (local _23_93 : Uint256) = u256_add(value_69, _19_89)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_23_93.low, value=_21_91)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _24_94 : Uint256 = Uint256(low=128, high=0)
    let (local _25_95 : Uint256) = u256_add(headStart, _24_94)
    local range_check_ptr = range_check_ptr
    let (local _26_96 : Uint256) = calldata_load(_25_95.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _27_97 : Uint256 = _24_94
    let (local _28_98 : Uint256) = u256_add(value_69, _24_94)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_28_98.low, value=_26_96)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value_69)
end

func abi_decode_struct_ExactInputParams_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_258 : Uint256, dataEnd_259 : Uint256) -> (value0_260 : Uint256):
    alloc_locals
    local _1_261 : Uint256 = Uint256(low=32, high=0)
    let (local _2_262 : Uint256) = uint256_sub(dataEnd_259, headStart_258)
    local range_check_ptr = range_check_ptr
    let (local _3_263 : Uint256) = slt(_2_262, _1_261)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_263)
    local exec_env : ExecutionEnvironment = exec_env
    let (local offset_264 : Uint256) = calldata_load(headStart_258.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_265 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_266 : Uint256) = is_gt(offset_264, _4_265)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_266)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_267 : Uint256) = u256_add(headStart_258, offset_264)
    local range_check_ptr = range_check_ptr
    let (local value0_260 : Uint256) = abi_decode_struct_ExactInputParams(_6_267, dataEnd_259)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_260)
end

func constant_MULTIPLE_POOLS_MIN_LENGTH{exec_env : ExecutionEnvironment, range_check_ptr}() -> (
        ret_708 : Uint256):
    alloc_locals
    local _1_709 : Uint256 = Uint256(low=20, high=0)
    local _2_710 : Uint256 = Uint256(low=3, high=0)
    local _3_711 : Uint256 = _1_709
    let (local _4_712 : Uint256) = checked_add_uint256(_1_709, _2_710)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr : Uint256) = checked_add_uint256(_4_712, _1_709)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _5_713 : Uint256 = _2_710
    local _6_714 : Uint256 = _1_709
    let (local _7_715 : Uint256) = checked_add_uint256(_1_709, _2_710)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_708 : Uint256) = checked_add_uint256(expr, _7_715)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (ret_708)
end

func fun_hasMultiplePools{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_mpos : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local expr_1021 : Uint256) = mload_(var_path_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_1022 : Uint256) = constant_MULTIPLE_POOLS_MIN_LENGTH()
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1023 : Uint256) = cleanup_uint256(_1_1022)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_1024 : Uint256) = is_lt(expr_1021, _2_1023)
    local range_check_ptr = range_check_ptr
    let (local var_ : Uint256) = is_zero(_3_1024)
    local range_check_ptr = range_check_ptr
    return (var_)
end

func __warp_loop_body_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        usr_cc : Uint256, usr_mc : Uint256) -> (usr_cc : Uint256, usr_mc : Uint256):
    alloc_locals
    let (local _22_1295 : Uint256) = mload_(usr_cc.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=usr_mc.low, value=_22_1295)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _21_1294 : Uint256 = Uint256(low=32, high=0)
    let (local usr_mc : Uint256) = u256_add(usr_mc, _21_1294)
    local range_check_ptr = range_check_ptr
    let (local usr_cc : Uint256) = u256_add(usr_cc, _21_1294)
    local range_check_ptr = range_check_ptr
    return (usr_cc, usr_mc)
end

func __warp_loop_4{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        usr_cc : Uint256, usr_end : Uint256, usr_mc : Uint256) -> (
        usr_cc : Uint256, usr_mc : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(usr_mc, usr_end)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (usr_cc, usr_mc)
    end
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_body_4(usr_cc, usr_mc)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(usr_cc, usr_end, usr_mc)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (usr_cc, usr_mc)
end

func __warp_block_33{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1273 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    local _13_1286 : Uint256 = Uint256(low=64, high=0)
    let (local var_tempBytes_mpos : Uint256) = mload_(_13_1286.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_1287 : Uint256 = _1_1273
    let (local usr_lengthmod : Uint256) = uint256_and(var_length, _1_1273)
    local range_check_ptr = range_check_ptr
    let (local _15_1288 : Uint256) = is_zero(usr_lengthmod)
    local range_check_ptr = range_check_ptr
    local _16_1289 : Uint256 = Uint256(low=5, high=0)
    let (local _17_1290 : Uint256) = uint256_shl(_16_1289, _15_1288)
    local range_check_ptr = range_check_ptr
    let (local _18_1291 : Uint256) = u256_add(var_tempBytes_mpos, usr_lengthmod)
    local range_check_ptr = range_check_ptr
    let (local usr_mc : Uint256) = u256_add(_18_1291, _17_1290)
    local range_check_ptr = range_check_ptr
    let (local usr_end : Uint256) = u256_add(usr_mc, var_length)
    local range_check_ptr = range_check_ptr
    let (local _19_1292 : Uint256) = u256_add(var__bytes_mpos, usr_lengthmod)
    local range_check_ptr = range_check_ptr
    let (local _20_1293 : Uint256) = u256_add(_19_1292, _17_1290)
    local range_check_ptr = range_check_ptr
    let (local usr_cc : Uint256) = u256_add(_20_1293, var__start)
    local range_check_ptr = range_check_ptr
    let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(usr_cc, usr_end, usr_mc)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=var_tempBytes_mpos.low, value=var_length)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1296 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    local _24_1297 : Uint256 = _1_1273
    let (local _25_1298 : Uint256) = u256_add(usr_mc, _1_1273)
    local range_check_ptr = range_check_ptr
    let (local _26_1299 : Uint256) = uint256_and(_25_1298, _23_1296)
    local range_check_ptr = range_check_ptr
    local _27_1300 : Uint256 = _13_1286
    mstore_(offset=_13_1286.low, value=_26_1299)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tempBytes_mpos)
end

func __warp_block_34{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}() -> (
        var_tempBytes_mpos : Uint256):
    alloc_locals
    local _28_1301 : Uint256 = Uint256(low=64, high=0)
    let (local var_tempBytes_mpos : Uint256) = mload_(_28_1301.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _29_1302 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=var_tempBytes_mpos.low, value=_29_1302)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _30_1303 : Uint256 = Uint256(low=32, high=0)
    let (local _31_1304 : Uint256) = u256_add(var_tempBytes_mpos, _30_1303)
    local range_check_ptr = range_check_ptr
    local _32_1305 : Uint256 = _28_1301
    mstore_(offset=_28_1301.low, value=_31_1304)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tempBytes_mpos)
end

func __warp_if_19{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1273 : Uint256, __warp_subexpr_0 : Uint256, var__bytes_mpos : Uint256,
        var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_tempBytes_mpos : Uint256) = __warp_block_33(
            _1_1273, var__bytes_mpos, var__start, var_length)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (var_tempBytes_mpos)
    else:
        let (local var_tempBytes_mpos : Uint256) = __warp_block_34()
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (var_tempBytes_mpos)
    end
end

func __warp_block_32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1_1273 : Uint256, match_var : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_tempBytes_mpos : Uint256) = __warp_if_19(
        _1_1273, __warp_subexpr_0, var__bytes_mpos, var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_tempBytes_mpos)
end

func __warp_block_31{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _12_1285 : Uint256, _1_1273 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256,
        var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
    alloc_locals
    local match_var : Uint256 = _12_1285
    let (local var_tempBytes_mpos : Uint256) = __warp_block_32(
        _1_1273, match_var, var__bytes_mpos, var__start, var_length)
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
    local _1_1273 : Uint256 = Uint256(low=31, high=0)
    let (local _2_1274 : Uint256) = checked_add_uint256(var_length, _1_1273)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_1275 : Uint256) = is_lt(_2_1274, var_length)
    local range_check_ptr = range_check_ptr
    let (local _4_1276 : Uint256) = is_zero(_3_1275)
    local range_check_ptr = range_check_ptr
    require_helper(_4_1276)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_1277 : Uint256) = checked_add_uint256(var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1278 : Uint256) = is_lt(_5_1277, var__start)
    local range_check_ptr = range_check_ptr
    let (local _7_1279 : Uint256) = is_zero(_6_1278)
    local range_check_ptr = range_check_ptr
    require_helper(_7_1279)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1280 : Uint256) = mload_(var__bytes_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_1281 : Uint256) = checked_add_uint256(var__start, var_length)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _9_1282 : Uint256) = cleanup_uint256(_8_1281)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _10_1283 : Uint256) = is_lt(expr_1280, _9_1282)
    local range_check_ptr = range_check_ptr
    let (local _11_1284 : Uint256) = is_zero(_10_1283)
    local range_check_ptr = range_check_ptr
    require_helper(_11_1284)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local var_tempBytes_mpos : Uint256 = Uint256(low=0, high=0)
    let (local _12_1285 : Uint256) = is_zero(var_length)
    local range_check_ptr = range_check_ptr
    let (local var_tempBytes_mpos : Uint256) = __warp_block_31(
        _12_1285, _1_1273, var__bytes_mpos, var__start, var_length)
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
    local _1_996 : Uint256 = Uint256(low=20, high=0)
    local _2_997 : Uint256 = Uint256(low=3, high=0)
    local _3_998 : Uint256 = _1_996
    let (local _4_999 : Uint256) = checked_add_uint256(_1_996, _2_997)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _5_1000 : Uint256) = checked_add_uint256(_4_999, _1_996)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_1001 : Uint256 = Uint256(low=0, high=0)
    let (local var_2521_mpos : Uint256) = fun_slice(var_path_2518_mpos, _6_1001, _5_1000)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_2521_mpos)
end

func write_to_memory_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        memPtr_1759 : Uint256, value_1760 : Uint256) -> ():
    alloc_locals
    mstore_(offset=memPtr_1759.low, value=value_1760)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func checked_sub_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_697 : Uint256, y_698 : Uint256) -> (diff_699 : Uint256):
    alloc_locals
    let (local _1_700 : Uint256) = is_lt(x_697, y_698)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_700)
    local exec_env : ExecutionEnvironment = exec_env
    let (local diff_699 : Uint256) = uint256_sub(x_697, y_698)
    local range_check_ptr = range_check_ptr
    return (diff_699)
end

func fun_skipToken{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_path_2532_mpos : Uint256) -> (var_mpos : Uint256):
    alloc_locals
    local _1_1265 : Uint256 = Uint256(low=3, high=0)
    local _2_1266 : Uint256 = Uint256(low=20, high=0)
    let (local expr_1267 : Uint256) = checked_add_uint256(_2_1266, _1_1265)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1_1268 : Uint256) = mload_(var_path_2532_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_1269 : Uint256 = _1_1265
    local _4_1270 : Uint256 = _2_1266
    let (local _5_1271 : Uint256) = checked_add_uint256(_2_1266, _1_1265)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _6_1272 : Uint256) = checked_sub_uint256(expr_1_1268, _5_1271)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local var_mpos : Uint256) = fun_slice(var_path_2532_mpos, expr_1267, _6_1272)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_mpos)
end

func __warp_block_37{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_params_mpos : Uint256) -> (expr_1_890 : Uint256):
    alloc_locals
    local _7_891 : Uint256 = Uint256(low=32, high=0)
    let (local _8_892 : Uint256) = u256_add(var_params_mpos, _7_891)
    local range_check_ptr = range_check_ptr
    let (local _9_893 : Uint256) = mload_(_8_892.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_1_890 : Uint256) = cleanup_address(_9_893)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (expr_1_890)
end

func __warp_if_20{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, var_params_mpos : Uint256) -> (expr_1_890 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_1_890 : Uint256) = __warp_block_37(var_params_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_890)
    else:
        let (local expr_1_890 : Uint256) = __warp_holder()
        return (expr_1_890)
    end
end

func __warp_block_36{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, var_params_mpos : Uint256) -> (expr_1_890 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_1_890 : Uint256) = __warp_if_20(__warp_subexpr_0, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_890)
end

func __warp_block_35{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_885 : Uint256, var_params_mpos : Uint256) -> (expr_1_890 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_885
    let (local expr_1_890 : Uint256) = __warp_block_36(match_var, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_890)
end

func __warp_block_40{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_887 : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_130 : Uint256, var_amountOut_883 : Uint256):
    alloc_locals
    let (local _16_900 : Uint256) = mload_(_4_887.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local var_amountOut_883 : Uint256) = cleanup_uint256(_16_900)
    local exec_env : ExecutionEnvironment = exec_env
    local __warp_break_2 : Uint256 = Uint256(low=1, high=0)
    local __warp_leave_130 : Uint256 = Uint256(low=1, high=0)
    return (__warp_break_2, __warp_leave_130, var_amountOut_883)
end

func __warp_block_41{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_params_mpos : Uint256) -> (var_payer : Uint256):
    alloc_locals
    let (local var_payer : Uint256) = __warp_holder()
    let (local _17_901 : Uint256) = mload_(var_params_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_902 : Uint256) = fun_skipToken(_17_901)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=var_params_mpos.low, value=_18_902)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_payer)
end

func __warp_if_76{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_887 : Uint256, __warp_break_2 : Uint256, __warp_leave_130 : Uint256,
        __warp_leave_266 : Uint256, __warp_subexpr_0 : Uint256, var_amountOut_883 : Uint256,
        var_params_mpos : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_130 : Uint256, __warp_leave_266 : Uint256,
        var_amountOut_883 : Uint256, var_payer : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local __warp_break_2 : Uint256, local __warp_leave_130 : Uint256,
            local var_amountOut_883 : Uint256) = __warp_block_40(_4_887)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        if __warp_leave_130.low + __warp_leave_130.high != 0:
            local __warp_leave_266 : Uint256 = Uint256(low=1, high=0)
            return (
                __warp_break_2, __warp_leave_130, __warp_leave_266, var_amountOut_883, var_payer)
        else:
            return (
                __warp_break_2, __warp_leave_130, __warp_leave_266, var_amountOut_883, var_payer)
        end
    else:
        let (local var_payer : Uint256) = __warp_block_41(var_params_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (__warp_break_2, __warp_leave_130, __warp_leave_266, var_amountOut_883, var_payer)
    end
end

func __warp_block_39{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_887 : Uint256, __warp_break_2 : Uint256, __warp_leave_130 : Uint256,
        match_var : Uint256, var_amountOut_883 : Uint256, var_params_mpos : Uint256,
        var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_130 : Uint256, var_amountOut_883 : Uint256,
        var_payer : Uint256):
    alloc_locals
    local __warp_leave_266 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local __warp_break_2 : Uint256, local __warp_leave_130 : Uint256,
        local __warp_leave_266 : Uint256, local var_amountOut_883 : Uint256,
        local var_payer : Uint256) = __warp_if_76(
        _4_887,
        __warp_break_2,
        __warp_leave_130,
        __warp_leave_266,
        __warp_subexpr_0,
        var_amountOut_883,
        var_params_mpos,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_266.low + __warp_leave_266.high != 0:
        return (__warp_break_2, __warp_leave_130, var_amountOut_883, var_payer)
    else:
        return (__warp_break_2, __warp_leave_130, var_amountOut_883, var_payer)
    end
end

func __warp_block_38{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _4_887 : Uint256, __warp_break_2 : Uint256, __warp_leave_130 : Uint256, expr_885 : Uint256,
        var_amountOut_883 : Uint256, var_params_mpos : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, __warp_leave_130 : Uint256, var_amountOut_883 : Uint256,
        var_payer : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_885
    let (local __warp_break_2 : Uint256, local __warp_leave_130 : Uint256,
        local var_amountOut_883 : Uint256, local var_payer : Uint256) = __warp_block_39(
        _4_887,
        __warp_break_2,
        __warp_leave_130,
        match_var,
        var_amountOut_883,
        var_params_mpos,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_130.low + __warp_leave_130.high != 0:
        return (__warp_break_2, __warp_leave_130, var_amountOut_883, var_payer)
    else:
        return (__warp_break_2, __warp_leave_130, var_amountOut_883, var_payer)
    end
end

func __warp_loop_body_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_params_mpos : Uint256, var_payer : Uint256) -> (
        __warp_break_2 : Uint256, var_amountOut_883 : Uint256, var_payer : Uint256):
    alloc_locals
    local __warp_break_2 : Uint256 = Uint256(low=0, high=0)
    local var_amountOut_883 : Uint256 = Uint256(low=0, high=0)
    local __warp_leave_130 : Uint256 = Uint256(low=0, high=0)
    let (local _2_884 : Uint256) = mload_(var_params_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_885 : Uint256) = fun_hasMultiplePools(_2_884)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_886 : Uint256 = Uint256(low=96, high=0)
    let (local _4_887 : Uint256) = u256_add(var_params_mpos, _3_886)
    local range_check_ptr = range_check_ptr
    let (local _5_888 : Uint256) = mload_(_4_887.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_889 : Uint256) = cleanup_uint256(_5_888)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_890 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_890 : Uint256) = __warp_block_35(expr_885, var_params_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_894 : Uint256) = mload_(var_params_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_3137_mpos : Uint256) = fun_getFirstPool(_10_894)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_895 : Uint256 = Uint256(low=64, high=0)
    let (local expr_3139_mpos : Uint256) = allocate_memory(_11_895)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    write_to_memory_bytes(expr_3139_mpos, expr_3137_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _12_896 : Uint256 = Uint256(low=32, high=0)
    let (local _13_897 : Uint256) = u256_add(expr_3139_mpos, _12_896)
    local range_check_ptr = range_check_ptr
    write_to_memory_address(_13_897, var_payer)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14_898 : Uint256 = Uint256(low=0, high=0)
    let (local _15_899 : Uint256) = fun_exactInputInternal(
        _6_889, expr_1_890, _14_898, expr_3139_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    write_to_memory_uint256(_4_887, _15_899)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_break_2 : Uint256, local __warp_leave_130 : Uint256,
        local var_amountOut_883 : Uint256, local var_payer : Uint256) = __warp_block_38(
        _4_887,
        __warp_break_2,
        __warp_leave_130,
        expr_885,
        var_amountOut_883,
        var_params_mpos,
        var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    if __warp_leave_130.low + __warp_leave_130.high != 0:
        return (__warp_break_2, var_amountOut_883, var_payer)
    else:
        return (__warp_break_2, var_amountOut_883, var_payer)
    end
end

func __warp_loop_2{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_params_mpos : Uint256, var_payer : Uint256) -> (
        var_amountOut_883 : Uint256, var_payer : Uint256):
    alloc_locals
    local __warp_break_2 : Uint256 = Uint256(low=0, high=0)
    local var_amountOut_883 : Uint256 = Uint256(100,0)
    if 1 != 0:
        return (var_amountOut_883, var_payer)
    end
    let (local __warp_break_2 : Uint256, local var_amountOut_883 : Uint256,
        local var_payer : Uint256) = __warp_loop_body_2(var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    if __warp_break_2.low + __warp_break_2.high != 0:
        return (var_amountOut_883, var_payer)
    end
    let (local var_amountOut_883 : Uint256, local var_payer : Uint256) = __warp_loop_2(
        var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_amountOut_883, var_payer)
end

func fun_exactInput_dynArgs_inner{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_882 : Uint256, var_params_mpos : Uint256) -> (var_amountOut_883 : Uint256):
    alloc_locals
    local var_amountOut_883 : Uint256 = _1_882
    let (local var_payer : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    let (local var_amountOut_883 : Uint256, local var_payer : Uint256) = __warp_loop_2(
        var_params_mpos, var_payer)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _19_903 : Uint256 = Uint256(low=128, high=0)
    let (local _20_904 : Uint256) = u256_add(var_params_mpos, _19_903)
    local range_check_ptr = range_check_ptr
    let (local _21_905 : Uint256) = mload_(_20_904.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22_906 : Uint256) = cleanup_uint256(_21_905)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _23_907 : Uint256) = cleanup_uint256(_22_906)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _24_908 : Uint256) = is_lt(var_amountOut_883, _23_907)
    local range_check_ptr = range_check_ptr
    let (local _25_909 : Uint256) = is_zero(_24_908)
    local range_check_ptr = range_check_ptr
    require_helper(_25_909)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_amountOut_883)
end

func modifier_checkDeadline_3101{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_amountOut_1575 : Uint256, var_params_mpos_1576 : Uint256) -> (_1_1577 : Uint256):
    alloc_locals
    local _2_1578 : Uint256 = Uint256(low=64, high=0)
    let (local _3_1579 : Uint256) = u256_add(var_params_mpos_1576, _2_1578)
    local range_check_ptr = range_check_ptr
    let (local _4_1580 : Uint256) = mload_(_3_1579.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_1581 : Uint256) = cleanup_uint256(_4_1580)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_1582 : Uint256) = __warp_holder()
    let (local _7_1583 : Uint256) = is_gt(_6_1582, _5_1581)
    local range_check_ptr = range_check_ptr
    let (local _8_1584 : Uint256) = is_zero(_7_1583)
    local range_check_ptr = range_check_ptr
    require_helper(_8_1584)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _1_1577 : Uint256) = fun_exactInput_dynArgs_inner(
        var_amountOut_1575, var_params_mpos_1576)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (_1_1577)
end

func fun_exactInput_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_params_3095_mpos : Uint256) -> (var_amountOut_880 : Uint256):
    alloc_locals
    local _1_881 : Uint256 = Uint256(low=0, high=0)
    let (local var_amountOut_880 : Uint256) = modifier_checkDeadline_3101(
        _1_881, var_params_3095_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_amountOut_880)
end

func getter_fun_I_am_a_mistake{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1537 : Uint256):
    alloc_locals
    let (res) = I_am_a_mistake.read()
    return (res)
end

func getter_fun_seaplusplus{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}() -> (value_1549 : Uint256):
    alloc_locals
    let (res) = seaplusplus.read()
    return (res)
end

func abi_decode_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        offset_33 : Uint256, end_34 : Uint256) -> (arrayPos_35 : Uint256, length_36 : Uint256):
    alloc_locals
    local _1_37 : Uint256 = Uint256(low=31, high=0)
    let (local _2_38 : Uint256) = u256_add(offset_33, _1_37)
    local range_check_ptr = range_check_ptr
    let (local _3_39 : Uint256) = slt(_2_38, end_34)
    local range_check_ptr = range_check_ptr
    let (local _4_40 : Uint256) = is_zero(_3_39)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_40)
    local exec_env : ExecutionEnvironment = exec_env
    let (local length_36 : Uint256) = calldata_load(offset_33.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_41 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_42 : Uint256) = is_gt(length_36, _5_41)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_42)
    local exec_env : ExecutionEnvironment = exec_env
    local _7_43 : Uint256 = Uint256(low=32, high=0)
    let (local arrayPos_35 : Uint256) = u256_add(offset_33, _7_43)
    local range_check_ptr = range_check_ptr
    local _8_44 : Uint256 = _7_43
    let (local _9_45 : Uint256) = u256_add(offset_33, length_36)
    local range_check_ptr = range_check_ptr
    let (local _10_46 : Uint256) = u256_add(_9_45, _7_43)
    local range_check_ptr = range_check_ptr
    let (local _11_47 : Uint256) = is_gt(_10_46, end_34)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_11_47)
    local exec_env : ExecutionEnvironment = exec_env
    return (arrayPos_35, length_36)
end

func abi_decode_int256t_int256t_bytes_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_231 : Uint256, dataEnd_232 : Uint256) -> (
        value0_233 : Uint256, value1_234 : Uint256, value2_235 : Uint256, value3_236 : Uint256):
    alloc_locals
    local _1_237 : Uint256 = Uint256(low=96, high=0)
    let (local _2_238 : Uint256) = uint256_sub(dataEnd_232, headStart_231)
    local range_check_ptr = range_check_ptr
    let (local _3_239 : Uint256) = slt(_2_238, _1_237)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_239)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_233 : Uint256) = calldata_load(headStart_231.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_240 : Uint256 = Uint256(low=32, high=0)
    let (local _5_241 : Uint256) = u256_add(headStart_231, _4_240)
    local range_check_ptr = range_check_ptr
    let (local value1_234 : Uint256) = calldata_load(_5_241.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_242 : Uint256 = Uint256(low=64, high=0)
    let (local _7_243 : Uint256) = u256_add(headStart_231, _6_242)
    local range_check_ptr = range_check_ptr
    let (local offset_244 : Uint256) = calldata_load(_7_243.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_245 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _9_246 : Uint256) = is_gt(offset_244, _8_245)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_9_246)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _10_247 : Uint256) = u256_add(headStart_231, offset_244)
    local range_check_ptr = range_check_ptr
    let (local value2_1 : Uint256, local value3_1 : Uint256) = abi_decode_bytes_calldata(
        _10_247, dataEnd_232)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local value2_235 : Uint256 = value2_1
    local value3_236 : Uint256 = value3_1
    return (value0_233, value1_234, value2_235, value3_236)
end

func abi_decode_struct_SwapCallbackData{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_117 : Uint256, end_118 : Uint256) -> (value_119 : Uint256):
    alloc_locals
    local _1_120 : Uint256 = Uint256(low=64, high=0)
    let (local _2_121 : Uint256) = uint256_sub(end_118, headStart_117)
    local range_check_ptr = range_check_ptr
    let (local _3_122 : Uint256) = slt(_2_121, _1_120)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_122)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_123 : Uint256 = _1_120
    let (local value_119 : Uint256) = allocate_memory(_1_120)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local offset_124 : Uint256) = calldata_load(headStart_117.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_125 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _6_126 : Uint256) = is_gt(offset_124, _5_125)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_126)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_127 : Uint256) = u256_add(headStart_117, offset_124)
    local range_check_ptr = range_check_ptr
    let (local _8_128 : Uint256) = abi_decode_bytes(_7_127, end_118)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=value_119.low, value=_8_128)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _9_129 : Uint256 = Uint256(low=32, high=0)
    let (local _10_130 : Uint256) = u256_add(headStart_117, _9_129)
    local range_check_ptr = range_check_ptr
    let (local _11_131 : Uint256) = abi_decode_address(_10_130)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _12_132 : Uint256 = _9_129
    let (local _13_133 : Uint256) = u256_add(value_119, _9_129)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_13_133.low, value=_11_131)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value_119)
end

func abi_decode_struct_SwapCallbackData_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_290 : Uint256, dataEnd_291 : Uint256) -> (value0_292 : Uint256):
    alloc_locals
    local _1_293 : Uint256 = Uint256(low=32, high=0)
    let (local _2_294 : Uint256) = uint256_sub(dataEnd_291, headStart_290)
    local range_check_ptr = range_check_ptr
    let (local _3_295 : Uint256) = slt(_2_294, _1_293)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_295)
    local exec_env : ExecutionEnvironment = exec_env
    let (local offset_296 : Uint256) = calldata_load(headStart_290.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_297 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_298 : Uint256) = is_gt(offset_296, _4_297)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_298)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_299 : Uint256) = u256_add(headStart_290, offset_296)
    local range_check_ptr = range_check_ptr
    let (local value0_292 : Uint256) = abi_decode_struct_SwapCallbackData(_6_299, dataEnd_291)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_292)
end

func fun_verifyCallback_2694{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(var_factory_1531 : Uint256, var_poolKey_mpos : Uint256) -> (
        var_pool_2671_address : Uint256):
    alloc_locals
    let (local _1_1532 : Uint256) = fun_computeAddress(var_factory_1531, var_poolKey_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local var_pool_2671_address : Uint256) = convert_address_to_contract_IUniswapV3Pool(
        _1_1532)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1533 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_1534 : Uint256) = uint256_and(var_pool_2671_address, _2_1533)
    local range_check_ptr = range_check_ptr
    let (local _4_1535 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    let (local _5_1536 : Uint256) = is_eq(_4_1535, _3_1534)
    local range_check_ptr = range_check_ptr
    require_helper(_5_1536)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_pool_2671_address)
end

func fun_verifyCallback{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        var_factory_1526 : Uint256, var_tokenA_1527 : Uint256, var_tokenB_1528 : Uint256,
        var_fee_1529 : Uint256) -> (var_pool_address : Uint256):
    alloc_locals
    let (local _1_1530 : Uint256) = fun_getPoolKey(var_tokenA_1527, var_tokenB_1528, var_fee_1529)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local var_pool_address : Uint256) = fun_verifyCallback_2694(var_factory_1526, _1_1530)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_pool_address)
end

func abi_encode_address_address_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_478 : Uint256, value0_479 : Uint256, value1_480 : Uint256,
        value2_481 : Uint256) -> (tail_482 : Uint256):
    alloc_locals
    local _1_483 : Uint256 = Uint256(low=96, high=0)
    let (local tail_482 : Uint256) = u256_add(headStart_478, _1_483)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_479, headStart_478)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_484 : Uint256 = Uint256(low=32, high=0)
    let (local _3_485 : Uint256) = u256_add(headStart_478, _2_484)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_480, _3_485)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_486 : Uint256 = Uint256(low=64, high=0)
    let (local _5_487 : Uint256) = u256_add(headStart_478, _4_486)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_481, _5_487)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_482)
end

func validator_revert_bool{exec_env : ExecutionEnvironment, range_check_ptr}(
        value_1721 : Uint256) -> ():
    alloc_locals
    let (local _1_1722 : Uint256) = is_zero(value_1721)
    local range_check_ptr = range_check_ptr
    let (local _2_1723 : Uint256) = is_zero(_1_1722)
    local range_check_ptr = range_check_ptr
    let (local _3_1724 : Uint256) = is_eq(value_1721, _2_1723)
    local range_check_ptr = range_check_ptr
    let (local _4_1725 : Uint256) = is_zero(_3_1724)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_4_1725)
    local exec_env : ExecutionEnvironment = exec_env
    return ()
end

func abi_decode_t_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        offset_31 : Uint256) -> (value_32 : Uint256):
    alloc_locals
    let (local value_32 : Uint256) = mload_(offset_31.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    validator_revert_bool(value_32)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value_32)
end

func abi_decode_bool_fromMemory{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_216 : Uint256, dataEnd_217 : Uint256) -> (value0_218 : Uint256):
    alloc_locals
    local _1_219 : Uint256 = Uint256(low=32, high=0)
    let (local _2_220 : Uint256) = uint256_sub(dataEnd_217, headStart_216)
    local range_check_ptr = range_check_ptr
    let (local _3_221 : Uint256) = slt(_2_220, _1_219)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_221)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_218 : Uint256) = abi_decode_t_bool_fromMemory(headStart_216)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (value0_218)
end

func __warp_block_43{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1117 : Uint256, expr_1437_component_2_mpos : Uint256, expr_1_1132 : Uint256) -> (
        expr_2_1133 : Uint256):
    alloc_locals
    local _17_1135 : Uint256 = _2_1117
    let (local _18_1136 : Uint256) = u256_add(expr_1437_component_2_mpos, expr_1_1132)
    local range_check_ptr = range_check_ptr
    let (local _19_1137 : Uint256) = u256_add(_18_1136, _2_1117)
    local range_check_ptr = range_check_ptr
    local _20_1138 : Uint256 = _2_1117
    let (local _21_1139 : Uint256) = u256_add(expr_1437_component_2_mpos, _2_1117)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1133 : Uint256) = abi_decode_bool_fromMemory(_21_1139, _19_1137)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_2_1133)
end

func __warp_if_22{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1134 : Uint256, _2_1117 : Uint256, expr_1437_component_2_mpos : Uint256,
        expr_1_1132 : Uint256, expr_2_1133 : Uint256) -> (expr_2_1133 : Uint256):
    alloc_locals
    if _16_1134.low + _16_1134.high != 0:
        let (local expr_2_1133 : Uint256) = __warp_block_43(
            _2_1117, expr_1437_component_2_mpos, expr_1_1132)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_2_1133)
    else:
        return (expr_2_1133)
    end
end

func __warp_block_42{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1117 : Uint256, expr_1437_component_2_mpos : Uint256) -> (expr_1131 : Uint256):
    alloc_locals
    let (local expr_1_1132 : Uint256) = mload_(expr_1437_component_2_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2_1133 : Uint256) = is_zero(expr_1_1132)
    local range_check_ptr = range_check_ptr
    let (local _16_1134 : Uint256) = is_zero(expr_2_1133)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1133 : Uint256) = __warp_if_22(
        _16_1134, _2_1117, expr_1437_component_2_mpos, expr_1_1132, expr_2_1133)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1131 : Uint256 = expr_2_1133
    return (expr_1131)
end

func __warp_if_21{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1117 : Uint256, expr_1131 : Uint256, expr_1437_component : Uint256,
        expr_1437_component_2_mpos : Uint256) -> (expr_1131 : Uint256):
    alloc_locals
    if expr_1437_component.low + expr_1437_component.high != 0:
        let (local expr_1131 : Uint256) = __warp_block_42(_2_1117, expr_1437_component_2_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1131)
    else:
        return (expr_1131)
    end
end

func fun_safeTransferFrom{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1113 : Uint256, var_from : Uint256, var_to_1114 : Uint256,
        var_value_1115 : Uint256) -> ():
    alloc_locals
    local _1_1116 : Uint256 = Uint256(low=64, high=0)
    let (local expr_1436_mpos : Uint256) = mload_(_1_1116.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_1117 : Uint256 = Uint256(low=32, high=0)
    let (local _3_1118 : Uint256) = u256_add(expr_1436_mpos, _2_1117)
    local range_check_ptr = range_check_ptr
    let (local _4_1119 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=599290589, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_3_1118.low, value=_4_1119)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1120 : Uint256 = Uint256(low=36, high=0)
    let (local _6_1121 : Uint256) = u256_add(expr_1436_mpos, _5_1120)
    local range_check_ptr = range_check_ptr
    let (local _7_1122 : Uint256) = abi_encode_address_address_uint256(
        _6_1121, var_from, var_to_1114, var_value_1115)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_1123 : Uint256) = uint256_sub(_7_1122, expr_1436_mpos)
    local range_check_ptr = range_check_ptr
    let (local _9_1124 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _10_1125 : Uint256) = u256_add(_8_1123, _9_1124)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_1436_mpos.low, value=_10_1125)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_1436_mpos, _8_1123)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_1126 : Uint256 = Uint256(low=0, high=0)
    local _12_1127 : Uint256 = _11_1126
    let (local _13_1128 : Uint256) = mload_(expr_1436_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_1129 : Uint256 = _11_1126
    let (local _15_1130 : Uint256) = __warp_holder()
    let (local expr_1437_component : Uint256) = __warp_holder()
    let (local expr_1437_component_2_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1131 : Uint256 = expr_1437_component
    let (local expr_1131 : Uint256) = __warp_if_21(
        _2_1117, expr_1131, expr_1437_component, expr_1437_component_2_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    require_helper(expr_1131)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_encode_address_uint256{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_551 : Uint256, value0_552 : Uint256, value1_553 : Uint256) -> (
        tail_554 : Uint256):
    alloc_locals
    local _1_555 : Uint256 = Uint256(low=64, high=0)
    let (local tail_554 : Uint256) = u256_add(headStart_551, _1_555)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_552, headStart_551)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_556 : Uint256 = Uint256(low=32, high=0)
    let (local _3_557 : Uint256) = u256_add(headStart_551, _2_556)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value1_553, _3_557)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_554)
end

func __warp_block_45{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1144 : Uint256, expr_1_1159 : Uint256, expr_component_mpos : Uint256) -> (
        expr_2_1160 : Uint256):
    alloc_locals
    local _17_1162 : Uint256 = _2_1144
    let (local _18_1163 : Uint256) = u256_add(expr_component_mpos, expr_1_1159)
    local range_check_ptr = range_check_ptr
    let (local _19_1164 : Uint256) = u256_add(_18_1163, _2_1144)
    local range_check_ptr = range_check_ptr
    local _20_1165 : Uint256 = _2_1144
    let (local _21_1166 : Uint256) = u256_add(expr_component_mpos, _2_1144)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1160 : Uint256) = abi_decode_bool_fromMemory(_21_1166, _19_1164)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_2_1160)
end

func __warp_if_24{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1161 : Uint256, _2_1144 : Uint256, expr_1_1159 : Uint256, expr_2_1160 : Uint256,
        expr_component_mpos : Uint256) -> (expr_2_1160 : Uint256):
    alloc_locals
    if _16_1161.low + _16_1161.high != 0:
        let (local expr_2_1160 : Uint256) = __warp_block_45(
            _2_1144, expr_1_1159, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_2_1160)
    else:
        return (expr_2_1160)
    end
end

func __warp_block_44{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1144 : Uint256, expr_component_mpos : Uint256) -> (expr_1158 : Uint256):
    alloc_locals
    let (local expr_1_1159 : Uint256) = mload_(expr_component_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2_1160 : Uint256) = is_zero(expr_1_1159)
    local range_check_ptr = range_check_ptr
    let (local _16_1161 : Uint256) = is_zero(expr_2_1160)
    local range_check_ptr = range_check_ptr
    let (local expr_2_1160 : Uint256) = __warp_if_24(
        _16_1161, _2_1144, expr_1_1159, expr_2_1160, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1158 : Uint256 = expr_2_1160
    return (expr_1158)
end

func __warp_if_23{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _2_1144 : Uint256, expr_1158 : Uint256, expr_1481_component : Uint256,
        expr_component_mpos : Uint256) -> (expr_1158 : Uint256):
    alloc_locals
    if expr_1481_component.low + expr_1481_component.high != 0:
        let (local expr_1158 : Uint256) = __warp_block_44(_2_1144, expr_component_mpos)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1158)
    else:
        return (expr_1158)
    end
end

func fun_safeTransfer{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_token_1140 : Uint256, var_to_1141 : Uint256, var_value_1142 : Uint256) -> ():
    alloc_locals
    local _1_1143 : Uint256 = Uint256(low=64, high=0)
    let (local expr_1480_mpos : Uint256) = mload_(_1_1143.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_1144 : Uint256 = Uint256(low=32, high=0)
    let (local _3_1145 : Uint256) = u256_add(expr_1480_mpos, _2_1144)
    local range_check_ptr = range_check_ptr
    let (local _4_1146 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_3_1145.low, value=_4_1146)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _5_1147 : Uint256 = Uint256(low=36, high=0)
    let (local _6_1148 : Uint256) = u256_add(expr_1480_mpos, _5_1147)
    local range_check_ptr = range_check_ptr
    let (local _7_1149 : Uint256) = abi_encode_address_uint256(_6_1148, var_to_1141, var_value_1142)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _8_1150 : Uint256) = uint256_sub(_7_1149, expr_1480_mpos)
    local range_check_ptr = range_check_ptr
    let (local _9_1151 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _10_1152 : Uint256) = u256_add(_8_1150, _9_1151)
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_1480_mpos.low, value=_10_1152)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    finalize_allocation(expr_1480_mpos, _8_1150)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_1153 : Uint256 = Uint256(low=0, high=0)
    local _12_1154 : Uint256 = _11_1153
    let (local _13_1155 : Uint256) = mload_(expr_1480_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _14_1156 : Uint256 = _11_1153
    let (local _15_1157 : Uint256) = __warp_holder()
    let (local expr_1481_component : Uint256) = __warp_holder()
    let (local expr_component_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local expr_1158 : Uint256 = expr_1481_component
    let (local expr_1158 : Uint256) = __warp_if_23(
        _2_1144, expr_1158, expr_1481_component, expr_component_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    require_helper(expr_1158)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_46{exec_env : ExecutionEnvironment, range_check_ptr}(var_value : Uint256) -> (
        expr_1061 : Uint256):
    alloc_locals
    let (local _5_1062 : Uint256) = __warp_holder()
    let (local _6_1063 : Uint256) = is_lt(_5_1062, var_value)
    local range_check_ptr = range_check_ptr
    let (local expr_1061 : Uint256) = is_zero(_6_1063)
    local range_check_ptr = range_check_ptr
    return (expr_1061)
end

func __warp_if_25{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1061 : Uint256, var_value : Uint256) -> (expr_1061 : Uint256):
    alloc_locals
    if expr_1061.low + expr_1061.high != 0:
        let (local expr_1061 : Uint256) = __warp_block_46(var_value)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1061)
    else:
        return (expr_1061)
    end
end

func __warp_if_27{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        __warp_subexpr_0 : Uint256, var_payer_1055 : Uint256, var_recipient_1056 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        fun_safeTransferFrom(var_token, var_payer_1055, var_recipient_1056, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        fun_safeTransfer(var_token, var_recipient_1056, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    end
end

func __warp_block_51{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        match_var : Uint256, var_payer_1055 : Uint256, var_recipient_1056 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_27(__warp_subexpr_0, var_payer_1055, var_recipient_1056, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_50{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1066 : Uint256, var_payer_1055 : Uint256, var_recipient_1056 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _9_1066
    __warp_block_51(match_var, var_payer_1055, var_recipient_1056, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_49{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_1059 : Uint256, var_payer_1055 : Uint256, var_recipient_1056 : Uint256,
        var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _7_1064 : Uint256) = __warp_holder()
    let (local _8_1065 : Uint256) = uint256_and(var_payer_1055, _3_1059)
    local range_check_ptr = range_check_ptr
    let (local _9_1066 : Uint256) = is_eq(_8_1065, _7_1064)
    local range_check_ptr = range_check_ptr
    __warp_block_50(_9_1066, var_payer_1055, var_recipient_1056, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_53{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1070 : Uint256) -> ():
    alloc_locals
    let (local _22_1077 : Uint256) = __warp_holder()
    finalize_allocation(_15_1070, _22_1077)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1078 : Uint256) = __warp_holder()
    let (local _24_1079 : Uint256) = u256_add(_15_1070, _23_1078)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_15_1070, _24_1079)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_28{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1070 : Uint256, _20_1075 : Uint256) -> ():
    alloc_locals
    if _20_1075.low + _20_1075.high != 0:
        __warp_block_53(_15_1070)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_54{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _30_1083 : Uint256) -> ():
    alloc_locals
    let (local _41_1094 : Uint256) = __warp_holder()
    finalize_allocation(_30_1083, _41_1094)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _42_1095 : Uint256) = __warp_holder()
    let (local _43_1096 : Uint256) = u256_add(_30_1083, _42_1095)
    local range_check_ptr = range_check_ptr
    let (local _44_1097 : Uint256) = abi_decode_bool_fromMemory(_30_1083, _43_1096)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    return ()
end

func __warp_if_29{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _30_1083 : Uint256, _39_1092 : Uint256) -> ():
    alloc_locals
    if _39_1092.low + _39_1092.high != 0:
        __warp_block_54(_30_1083)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_52{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_recipient_1056 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _10_1067 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _11_1068 : Uint256) = convert_address_to_contract_IWETH9(_10_1067)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1724_address : Uint256) = convert_contract_IWETH9_to_address(_11_1068)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _14_1069 : Uint256 = Uint256(low=64, high=0)
    let (local _15_1070 : Uint256) = mload_(_14_1069.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1071 : Uint256) = uint256_shl(
        Uint256(low=228, high=0), Uint256(low=219033819, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_15_1070.low, value=_16_1071)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _17_1072 : Uint256 = Uint256(low=0, high=0)
    local _18_1073 : Uint256 = Uint256(low=4, high=0)
    let (local _19_1074 : Uint256) = __warp_holder()
    let (local _20_1075 : Uint256) = __warp_holder()
    let (local _21_1076 : Uint256) = is_zero(_20_1075)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_21_1076)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_28(_15_1070, _20_1075)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25_1080 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_1081 : Uint256) = convert_address_to_contract_IWETH9(_25_1080)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_address : Uint256) = convert_contract_IWETH9_to_address(_26_1081)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _29_1082 : Uint256 = _14_1069
    let (local _30_1083 : Uint256) = mload_(_14_1069.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31_1084 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_30_1083.low, value=_31_1084)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _32_1085 : Uint256 = Uint256(low=32, high=0)
    local _33_1086 : Uint256 = _18_1073
    let (local _34_1087 : Uint256) = u256_add(_30_1083, _18_1073)
    local range_check_ptr = range_check_ptr
    let (local _35_1088 : Uint256) = abi_encode_address_uint256(
        _34_1087, var_recipient_1056, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _36_1089 : Uint256) = uint256_sub(_35_1088, _30_1083)
    local range_check_ptr = range_check_ptr
    local _37_1090 : Uint256 = _17_1072
    let (local _38_1091 : Uint256) = __warp_holder()
    let (local _39_1092 : Uint256) = __warp_holder()
    let (local _40_1093 : Uint256) = is_zero(_39_1092)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_40_1093)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_29(_30_1083, _39_1092)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_26{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3_1059 : Uint256, __warp_subexpr_0 : Uint256, var_payer_1055 : Uint256,
        var_recipient_1056 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_49(_3_1059, var_payer_1055, var_recipient_1056, var_token, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_52(var_recipient_1056, var_value)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_48{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3_1059 : Uint256, match_var : Uint256, var_payer_1055 : Uint256,
        var_recipient_1056 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_26(
        _3_1059, __warp_subexpr_0, var_payer_1055, var_recipient_1056, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_47{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _3_1059 : Uint256, expr_1061 : Uint256, var_payer_1055 : Uint256,
        var_recipient_1056 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = expr_1061
    __warp_block_48(_3_1059, match_var, var_payer_1055, var_recipient_1056, var_token, var_value)
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
        var_token : Uint256, var_payer_1055 : Uint256, var_recipient_1056 : Uint256,
        var_value : Uint256) -> ():
    alloc_locals
    let (local _1_1057 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_1058 : Uint256) = cleanup_address(_1_1057)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_1059 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_1060 : Uint256) = uint256_and(var_token, _3_1059)
    local range_check_ptr = range_check_ptr
    let (local expr_1061 : Uint256) = is_eq(_4_1060, _2_1058)
    local range_check_ptr = range_check_ptr
    let (local expr_1061 : Uint256) = __warp_if_25(expr_1061, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    __warp_block_47(_3_1059, expr_1061, var_payer_1055, var_recipient_1056, var_token, var_value)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_55{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1399 : Uint256, var_amount1Delta : Uint256) -> (expr_1400 : Uint256):
    alloc_locals
    local _3_1403 : Uint256 = _1_1399
    let (local expr_1400 : Uint256) = sgt(var_amount1Delta, _1_1399)
    local range_check_ptr = range_check_ptr
    return (expr_1400)
end

func __warp_if_30{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1399 : Uint256, _2_1402 : Uint256, expr_1400 : Uint256, var_amount1Delta : Uint256) -> (
        expr_1400 : Uint256):
    alloc_locals
    if _2_1402.low + _2_1402.high != 0:
        let (local expr_1400 : Uint256) = __warp_block_55(_1_1399, var_amount1Delta)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1400)
    else:
        return (expr_1400)
    end
end

func __warp_block_58{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1408 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _8_1409 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _9_1410 : Uint256) = uint256_and(expr_2853_component, _8_1409)
    local range_check_ptr = range_check_ptr
    let (local _10_1411 : Uint256) = uint256_and(expr_2853_component_1, _8_1409)
    local range_check_ptr = range_check_ptr
    let (local expr_component_1408 : Uint256) = is_lt(_10_1411, _9_1410)
    local range_check_ptr = range_check_ptr
    local expr_2887_component : Uint256 = var_amount1Delta
    return (expr_2887_component, expr_component_1408)
end

func __warp_block_59{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1408 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _11_1412 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _12_1413 : Uint256) = uint256_and(expr_2853_component_1, _11_1412)
    local range_check_ptr = range_check_ptr
    let (local _13_1414 : Uint256) = uint256_and(expr_2853_component, _11_1412)
    local range_check_ptr = range_check_ptr
    let (local expr_component_1408 : Uint256) = is_lt(_13_1414, _12_1413)
    local range_check_ptr = range_check_ptr
    local expr_2887_component : Uint256 = var_amount0Delta
    return (expr_2887_component, expr_component_1408)
end

func __warp_if_31{exec_env : ExecutionEnvironment, range_check_ptr}(
        __warp_subexpr_0 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1408 : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local expr_2887_component : Uint256,
            local expr_component_1408 : Uint256) = __warp_block_58(
            expr_2853_component, expr_2853_component_1, var_amount1Delta)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_2887_component, expr_component_1408)
    else:
        let (local expr_2887_component : Uint256,
            local expr_component_1408 : Uint256) = __warp_block_59(
            expr_2853_component, expr_2853_component_1, var_amount0Delta)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_2887_component, expr_component_1408)
    end
end

func __warp_block_57{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256, match_var : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1408 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local expr_2887_component : Uint256, local expr_component_1408 : Uint256) = __warp_if_31(
        __warp_subexpr_0,
        expr_2853_component,
        expr_2853_component_1,
        var_amount0Delta,
        var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2887_component, expr_component_1408)
end

func __warp_block_56{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1_1401 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (
        expr_2887_component : Uint256, expr_component_1408 : Uint256):
    alloc_locals
    local match_var : Uint256 = expr_1_1401
    let (local expr_2887_component : Uint256,
        local expr_component_1408 : Uint256) = __warp_block_57(
        expr_2853_component, expr_2853_component_1, match_var, var_amount0Delta, var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (expr_2887_component, expr_component_1408)
end

func __warp_block_65{
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
    local _16_1417 : Uint256 = Uint256(low=32, high=0)
    let (local _17_1418 : Uint256) = u256_add(expr_2842_mpos, _16_1417)
    local range_check_ptr = range_check_ptr
    let (local _18_1419 : Uint256) = mload_(_17_1418.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1420 : Uint256) = cleanup_address(_18_1419)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _20_1421 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    fun_pay(expr_2853_component_1, _19_1420, _20_1421, expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_66{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1399 : Uint256, expr_2842_mpos : Uint256, expr_2887_component : Uint256) -> ():
    alloc_locals
    let (local _21_1422 : Uint256) = mload_(expr_2842_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _22_1423 : Uint256) = fun_skipToken(_21_1422)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=expr_2842_mpos.low, value=_22_1423)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _23_1424 : Uint256 = _1_1399
    let (local _24_1425 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    let (local _25_1426 : Uint256) = fun_exactOutputInternal(
        expr_2887_component, _24_1425, _1_1399, expr_2842_mpos)
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
        _1_1399 : Uint256, __warp_subexpr_0 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_65(expr_2842_mpos, expr_2853_component_1, expr_2887_component)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_66(_1_1399, expr_2842_mpos, expr_2887_component)
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

func __warp_block_64{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1399 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_33(
        _1_1399, __warp_subexpr_0, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_63{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _15_1416 : Uint256, _1_1399 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _15_1416
    __warp_block_64(_1_1399, expr_2842_mpos, expr_2853_component_1, expr_2887_component, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_62{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1399 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    let (local _14_1415 : Uint256) = mload_(expr_2842_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _15_1416 : Uint256) = fun_hasMultiplePools(_14_1415)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_block_63(_15_1416, _1_1399, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
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
        expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2887_component : Uint256) -> (
        ):
    alloc_locals
    local _26_1427 : Uint256 = Uint256(low=32, high=0)
    let (local _27_1428 : Uint256) = u256_add(expr_2842_mpos, _26_1427)
    local range_check_ptr = range_check_ptr
    let (local _28_1429 : Uint256) = mload_(_27_1428.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _29_1430 : Uint256) = cleanup_address(_28_1429)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _30_1431 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    fun_pay(expr_2853_component, _29_1430, _30_1431, expr_2887_component)
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
        _1_1399 : Uint256, __warp_subexpr_0 : Uint256, expr_2842_mpos : Uint256,
        expr_2853_component : Uint256, expr_2853_component_1 : Uint256,
        expr_2887_component : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_62(_1_1399, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_67(expr_2842_mpos, expr_2853_component, expr_2887_component)
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

func __warp_block_61{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1399 : Uint256, expr_2842_mpos : Uint256, expr_2853_component : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_32(
        _1_1399,
        __warp_subexpr_0,
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

func __warp_block_60{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1_1399 : Uint256, expr_2842_mpos : Uint256, expr_2853_component : Uint256,
        expr_2853_component_1 : Uint256, expr_2887_component : Uint256,
        expr_component_1408 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = expr_component_1408
    __warp_block_61(
        _1_1399,
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
    local _1_1399 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1400 : Uint256) = sgt(var_amount0Delta, _1_1399)
    local range_check_ptr = range_check_ptr
    local expr_1_1401 : Uint256 = expr_1400
    let (local _2_1402 : Uint256) = is_zero(expr_1400)
    local range_check_ptr = range_check_ptr
    let (local expr_1400 : Uint256) = __warp_if_30(_1_1399, _2_1402, expr_1400, var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1400)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1404 : Uint256) = u256_add(var__data_offset, var_data_length)
    local range_check_ptr = range_check_ptr
    let (local expr_2842_mpos : Uint256) = abi_decode_struct_SwapCallbackData_memory_ptr(
        var__data_offset, _4_1404)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _5_1405 : Uint256) = mload_(expr_2842_mpos.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local expr_2853_component : Uint256, local expr_2853_component_1 : Uint256,
        local expr_2853_component_2 : Uint256) = fun_decodeFirstPool(_5_1405)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_1406 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _7_1407 : Uint256) = fun_verifyCallback(
        _6_1406, expr_2853_component, expr_2853_component_1, expr_2853_component_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    __warp_holder()
    local expr_component_1408 : Uint256 = _1_1399
    local expr_2887_component : Uint256 = _1_1399
    let (local expr_2887_component : Uint256,
        local expr_component_1408 : Uint256) = __warp_block_56(
        expr_1_1401,
        expr_2853_component,
        expr_2853_component_1,
        var_amount0Delta,
        var_amount1Delta)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    __warp_block_60(
        _1_1399,
        expr_2842_mpos,
        expr_2853_component,
        expr_2853_component_1,
        expr_2887_component,
        expr_component_1408)
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
        headStart_315 : Uint256, dataEnd_316 : Uint256) -> (
        value0_317 : Uint256, value1_318 : Uint256, value2_319 : Uint256, value3_320 : Uint256):
    alloc_locals
    local _1_321 : Uint256 = Uint256(low=128, high=0)
    let (local _2_322 : Uint256) = uint256_sub(dataEnd_316, headStart_315)
    local range_check_ptr = range_check_ptr
    let (local _3_323 : Uint256) = slt(_2_322, _1_321)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_323)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_317 : Uint256) = calldata_load(headStart_315.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_324 : Uint256 = Uint256(low=32, high=0)
    let (local _5_325 : Uint256) = u256_add(headStart_315, _4_324)
    local range_check_ptr = range_check_ptr
    let (local value1_318 : Uint256) = abi_decode_address(_5_325)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_326 : Uint256 = Uint256(low=64, high=0)
    let (local _7_327 : Uint256) = u256_add(headStart_315, _6_326)
    local range_check_ptr = range_check_ptr
    let (local value2_319 : Uint256) = calldata_load(_7_327.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_328 : Uint256 = Uint256(low=96, high=0)
    let (local _9_329 : Uint256) = u256_add(headStart_315, _8_328)
    local range_check_ptr = range_check_ptr
    let (local value3_320 : Uint256) = abi_decode_address(_9_329)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_317, value1_318, value2_319, value3_320)
end

func checked_mul_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_683 : Uint256, y_684 : Uint256) -> (product : Uint256):
    alloc_locals
    let (local _1_685 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_686 : Uint256) = u256_div(_1_685, x_683)
    local range_check_ptr = range_check_ptr
    let (local _3_687 : Uint256) = is_gt(y_684, _2_686)
    local range_check_ptr = range_check_ptr
    let (local _4_688 : Uint256) = is_zero(x_683)
    local range_check_ptr = range_check_ptr
    let (local _5_689 : Uint256) = is_zero(_4_688)
    local range_check_ptr = range_check_ptr
    let (local _6_690 : Uint256) = uint256_and(_5_689, _3_687)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_6_690)
    local exec_env : ExecutionEnvironment = exec_env
    let (local product : Uint256) = u256_mul(x_683, y_684)
    local range_check_ptr = range_check_ptr
    return (product)
end

func checked_div_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(
        x_680 : Uint256, y_681 : Uint256) -> (r : Uint256):
    alloc_locals
    let (local _1_682 : Uint256) = is_zero(y_681)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_1_682)
    local exec_env : ExecutionEnvironment = exec_env
    let (local r : Uint256) = u256_div(x_680, y_681)
    local range_check_ptr = range_check_ptr
    return (r)
end

func __warp_block_68{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (expr_1025 : Uint256, var_z : Uint256):
    alloc_locals
    let (local var_z : Uint256) = checked_mul_uint256(var_x, var_y)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _2_1027 : Uint256) = checked_div_uint256(var_z, var_x)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_1025 : Uint256) = is_eq(_2_1027, var_y)
    local range_check_ptr = range_check_ptr
    return (expr_1025, var_z)
end

func __warp_if_34{exec_env : ExecutionEnvironment, range_check_ptr}(
        _1_1026 : Uint256, expr_1025 : Uint256, var_x : Uint256, var_y : Uint256,
        var_z : Uint256) -> (expr_1025 : Uint256, var_z : Uint256):
    alloc_locals
    if _1_1026.low + _1_1026.high != 0:
        let (local expr_1025 : Uint256, local var_z : Uint256) = __warp_block_68(var_x, var_y)
        local exec_env : ExecutionEnvironment = exec_env
        local range_check_ptr = range_check_ptr
        return (expr_1025, var_z)
    else:
        return (expr_1025, var_z)
    end
end

func fun_mul{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_x : Uint256, var_y : Uint256) -> (var_z : Uint256):
    alloc_locals
    local var_z : Uint256 = Uint256(low=0, high=0)
    let (local expr_1025 : Uint256) = is_zero(var_x)
    local range_check_ptr = range_check_ptr
    let (local _1_1026 : Uint256) = is_zero(expr_1025)
    local range_check_ptr = range_check_ptr
    let (local expr_1025 : Uint256, local var_z : Uint256) = __warp_if_34(
        _1_1026, expr_1025, var_x, var_y, var_z)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1025)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_z)
end

func __warp_block_69{exec_env : ExecutionEnvironment, range_check_ptr}(
        var_feeBips_1434 : Uint256) -> (expr_1437 : Uint256):
    alloc_locals
    local _2_1438 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1439 : Uint256) = is_gt(var_feeBips_1434, _2_1438)
    local range_check_ptr = range_check_ptr
    let (local expr_1437 : Uint256) = is_zero(_3_1439)
    local range_check_ptr = range_check_ptr
    return (expr_1437)
end

func __warp_if_35{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1437 : Uint256, var_feeBips_1434 : Uint256) -> (expr_1437 : Uint256):
    alloc_locals
    if expr_1437.low + expr_1437.high != 0:
        let (local expr_1437 : Uint256) = __warp_block_69(var_feeBips_1434)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1437)
    else:
        return (expr_1437)
    end
end

func __warp_block_70{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1443 : Uint256) -> (expr_1_1454 : Uint256):
    alloc_locals
    let (local _20_1455 : Uint256) = __warp_holder()
    finalize_allocation(_9_1443, _20_1455)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1456 : Uint256) = __warp_holder()
    let (local _22_1457 : Uint256) = u256_add(_9_1443, _21_1456)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1454 : Uint256) = abi_decode_uint256_fromMemory(_9_1443, _22_1457)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1454)
end

func __warp_if_36{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1452 : Uint256, _9_1443 : Uint256, expr_1_1454 : Uint256) -> (expr_1_1454 : Uint256):
    alloc_locals
    if _18_1452.low + _18_1452.high != 0:
        let (local expr_1_1454 : Uint256) = __warp_block_70(_9_1443)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1454)
    else:
        return (expr_1_1454)
    end
end

func __warp_block_72{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _32_1465 : Uint256) -> ():
    alloc_locals
    let (local _43_1476 : Uint256) = __warp_holder()
    finalize_allocation(_32_1465, _43_1476)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _44_1477 : Uint256) = __warp_holder()
    let (local _45_1478 : Uint256) = u256_add(_32_1465, _44_1477)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_32_1465, _45_1478)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_38{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _32_1465 : Uint256, _41_1474 : Uint256) -> ():
    alloc_locals
    if _41_1474.low + _41_1474.high != 0:
        __warp_block_72(_32_1465)
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
        _49_1483 : Uint256, expr_2_1481 : Uint256, var_feeRecipient_1435 : Uint256) -> ():
    alloc_locals
    if _49_1483.low + _49_1483.high != 0:
        fun_safeTransferETH(var_feeRecipient_1435, expr_2_1481)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_71{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _13_1447 : Uint256, _8_1442 : Uint256, expr_1_1454 : Uint256, var_feeBips_1434 : Uint256,
        var_feeRecipient_1435 : Uint256, var_recipient_1433 : Uint256) -> ():
    alloc_locals
    let (local _27_1462 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _28_1463 : Uint256) = convert_address_to_contract_IWETH9(_27_1462)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1847_address : Uint256) = convert_contract_IWETH9_to_address(_28_1463)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _31_1464 : Uint256 = _8_1442
    let (local _32_1465 : Uint256) = mload_(_8_1442.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33_1466 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=773487949, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_32_1465.low, value=_33_1466)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _34_1467 : Uint256 = Uint256(low=0, high=0)
    local _35_1468 : Uint256 = _13_1447
    let (local _36_1469 : Uint256) = u256_add(_32_1465, _13_1447)
    local range_check_ptr = range_check_ptr
    let (local _37_1470 : Uint256) = abi_encode_uint256(_36_1469, expr_1_1454)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _38_1471 : Uint256) = uint256_sub(_37_1470, _32_1465)
    local range_check_ptr = range_check_ptr
    local _39_1472 : Uint256 = _34_1467
    let (local _40_1473 : Uint256) = __warp_holder()
    let (local _41_1474 : Uint256) = __warp_holder()
    let (local _42_1475 : Uint256) = is_zero(_41_1474)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_42_1475)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_38(_32_1465, _41_1474)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _46_1479 : Uint256 = Uint256(low=10000, high=0)
    let (local _47_1480 : Uint256) = fun_mul(expr_1_1454, var_feeBips_1434)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1481 : Uint256) = checked_div_uint256(_47_1480, _46_1479)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _48_1482 : Uint256) = is_zero(expr_2_1481)
    local range_check_ptr = range_check_ptr
    let (local _49_1483 : Uint256) = is_zero(_48_1482)
    local range_check_ptr = range_check_ptr
    __warp_if_39(_49_1483, expr_2_1481, var_feeRecipient_1435)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _50_1484 : Uint256) = checked_sub_uint256(expr_1_1454, expr_2_1481)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransferETH(var_recipient_1433, _50_1484)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_37{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _13_1447 : Uint256, _26_1461 : Uint256, _8_1442 : Uint256, expr_1_1454 : Uint256,
        var_feeBips_1434 : Uint256, var_feeRecipient_1435 : Uint256,
        var_recipient_1433 : Uint256) -> ():
    alloc_locals
    if _26_1461.low + _26_1461.high != 0:
        __warp_block_71(
            _13_1447,
            _8_1442,
            expr_1_1454,
            var_feeBips_1434,
            var_feeRecipient_1435,
            var_recipient_1433)
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
        var_amountMinimum_1432 : Uint256, var_recipient_1433 : Uint256, var_feeBips_1434 : Uint256,
        var_feeRecipient_1435 : Uint256) -> ():
    alloc_locals
    let (local _1_1436 : Uint256) = is_zero(var_feeBips_1434)
    local range_check_ptr = range_check_ptr
    let (local expr_1437 : Uint256) = is_zero(_1_1436)
    local range_check_ptr = range_check_ptr
    let (local expr_1437 : Uint256) = __warp_if_35(expr_1437, var_feeBips_1434)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1437)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _4_1440 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _5_1441 : Uint256) = convert_address_to_contract_IWETH9(_4_1440)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local expr_1828_address : Uint256) = convert_contract_IWETH9_to_address(_5_1441)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_1442 : Uint256 = Uint256(low=64, high=0)
    let (local _9_1443 : Uint256) = mload_(_8_1442.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_1444 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_9_1443.low, value=_10_1444)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_1445 : Uint256 = Uint256(low=32, high=0)
    let (local _12_1446 : Uint256) = __warp_holder()
    local _13_1447 : Uint256 = Uint256(low=4, high=0)
    let (local _14_1448 : Uint256) = u256_add(_9_1443, _13_1447)
    local range_check_ptr = range_check_ptr
    let (local _15_1449 : Uint256) = abi_encode_tuple_address(_14_1448, _12_1446)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1450 : Uint256) = uint256_sub(_15_1449, _9_1443)
    local range_check_ptr = range_check_ptr
    let (local _17_1451 : Uint256) = __warp_holder()
    let (local _18_1452 : Uint256) = __warp_holder()
    let (local _19_1453 : Uint256) = is_zero(_18_1452)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_19_1453)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1454 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1454 : Uint256) = __warp_if_36(_18_1452, _9_1443, expr_1_1454)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1458 : Uint256) = is_lt(expr_1_1454, var_amountMinimum_1432)
    local range_check_ptr = range_check_ptr
    let (local _24_1459 : Uint256) = is_zero(_23_1458)
    local range_check_ptr = range_check_ptr
    require_helper(_24_1459)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1460 : Uint256) = is_zero(expr_1_1454)
    local range_check_ptr = range_check_ptr
    let (local _26_1461 : Uint256) = is_zero(_25_1460)
    local range_check_ptr = range_check_ptr
    __warp_if_37(
        _13_1447,
        _26_1461,
        _8_1442,
        expr_1_1454,
        var_feeBips_1434,
        var_feeRecipient_1435,
        var_recipient_1433)
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
        headStart_461 : Uint256, value0_462 : Uint256, value1_463 : Uint256) -> (
        tail_464 : Uint256):
    alloc_locals
    local _1_465 : Uint256 = Uint256(low=64, high=0)
    let (local tail_464 : Uint256) = u256_add(headStart_461, _1_465)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_462, headStart_461)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_466 : Uint256 = Uint256(low=32, high=0)
    let (local _3_467 : Uint256) = u256_add(headStart_461, _2_466)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_463, _3_467)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_464)
end

func __warp_block_73{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1171 : Uint256) -> (expr_1183 : Uint256):
    alloc_locals
    let (local _18_1184 : Uint256) = __warp_holder()
    finalize_allocation(_6_1171, _18_1184)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1185 : Uint256) = __warp_holder()
    let (local _20_1186 : Uint256) = u256_add(_6_1171, _19_1185)
    local range_check_ptr = range_check_ptr
    let (local expr_1183 : Uint256) = abi_decode_uint256_fromMemory(_6_1171, _20_1186)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1183)
end

func __warp_if_40{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1181 : Uint256, _6_1171 : Uint256, expr_1183 : Uint256) -> (expr_1183 : Uint256):
    alloc_locals
    if _16_1181.low + _16_1181.high != 0:
        let (local expr_1183 : Uint256) = __warp_block_73(_6_1171)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1183)
    else:
        return (expr_1183)
    end
end

func __warp_if_41{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _22_1188 : Uint256, var_expiry : Uint256, var_nonce : Uint256, var_r : Uint256,
        var_s : Uint256, var_token_1167 : Uint256, var_v : Uint256) -> ():
    alloc_locals
    if _22_1188.low + _22_1188.high != 0:
        fun_selfPermitAllowed(var_token_1167, var_nonce, var_expiry, var_v, var_r, var_s)
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
        var_token_1167 : Uint256, var_nonce : Uint256, var_expiry : Uint256, var_v : Uint256,
        var_r : Uint256, var_s : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1168 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1169 : Uint256) = uint256_and(var_token_1167, _1_1168)
    local range_check_ptr = range_check_ptr
    local _5_1170 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1171 : Uint256) = mload_(_5_1170.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1172 : Uint256) = uint256_shl(
        Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1171.low, value=_7_1172)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1173 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1174 : Uint256) = __warp_holder()
    let (local _10_1175 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1176 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1177 : Uint256) = u256_add(_6_1171, _11_1176)
    local range_check_ptr = range_check_ptr
    let (local _13_1178 : Uint256) = abi_encode_address_address(_12_1177, _10_1175, _9_1174)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1179 : Uint256) = uint256_sub(_13_1178, _6_1171)
    local range_check_ptr = range_check_ptr
    let (local _15_1180 : Uint256) = __warp_holder()
    let (local _16_1181 : Uint256) = __warp_holder()
    let (local _17_1182 : Uint256) = is_zero(_16_1181)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17_1182)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1183 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1183 : Uint256) = __warp_if_40(_16_1181, _6_1171, expr_1183)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1187 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _22_1188 : Uint256) = is_lt(expr_1183, _21_1187)
    local range_check_ptr = range_check_ptr
    __warp_if_41(_22_1188, var_expiry, var_nonce, var_r, var_s, var_token_1167, var_v)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_511 : Uint256, value0_512 : Uint256, value1_513 : Uint256, value2_514 : Uint256,
        value3_515 : Uint256, value4_516 : Uint256, value5_517 : Uint256, value6_518 : Uint256) -> (
        tail_519 : Uint256):
    alloc_locals
    local _1_520 : Uint256 = Uint256(low=224, high=0)
    let (local tail_519 : Uint256) = u256_add(headStart_511, _1_520)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value0_512, headStart_511)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _2_521 : Uint256 = Uint256(low=32, high=0)
    let (local _3_522 : Uint256) = u256_add(headStart_511, _2_521)
    local range_check_ptr = range_check_ptr
    abi_encode_address(value1_513, _3_522)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _4_523 : Uint256 = Uint256(low=64, high=0)
    let (local _5_524 : Uint256) = u256_add(headStart_511, _4_523)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value2_514, _5_524)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_525 : Uint256 = Uint256(low=96, high=0)
    let (local _7_526 : Uint256) = u256_add(headStart_511, _6_525)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256(value3_515, _7_526)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _8_527 : Uint256 = Uint256(low=128, high=0)
    let (local _9_528 : Uint256) = u256_add(headStart_511, _8_527)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8(value4_516, _9_528)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _10_529 : Uint256 = Uint256(low=160, high=0)
    let (local _11_530 : Uint256) = u256_add(headStart_511, _10_529)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value5_517, _11_530)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _12_531 : Uint256 = Uint256(low=192, high=0)
    let (local _13_532 : Uint256) = u256_add(headStart_511, _12_531)
    local range_check_ptr = range_check_ptr
    abi_encode_bytes32_to_bytes32(value6_518, _13_532)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    return (tail_519)
end

func __warp_block_74{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1249 : Uint256) -> ():
    alloc_locals
    let (local _19_1262 : Uint256) = __warp_holder()
    finalize_allocation(_6_1249, _19_1262)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1263 : Uint256) = __warp_holder()
    let (local _21_1264 : Uint256) = u256_add(_6_1249, _20_1263)
    local range_check_ptr = range_check_ptr
    abi_decode_fromMemory(_6_1249, _21_1264)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_42{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _17_1260 : Uint256, _6_1249 : Uint256) -> ():
    alloc_locals
    if _17_1260.low + _17_1260.high != 0:
        __warp_block_74(_6_1249)
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
        var_token_1240 : Uint256, var_value_1241 : Uint256, var_deadline_1242 : Uint256,
        var_v_1243 : Uint256, var_r_1244 : Uint256, var_s_1245 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1246 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1247 : Uint256) = uint256_and(var_token_1240, _1_1246)
    local range_check_ptr = range_check_ptr
    local _5_1248 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1249 : Uint256) = mload_(_5_1248.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1250 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=3573918927, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1249.low, value=_7_1250)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1251 : Uint256 = Uint256(low=0, high=0)
    let (local _9_1252 : Uint256) = __warp_holder()
    let (local _10_1253 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1254 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1255 : Uint256) = u256_add(_6_1249, _11_1254)
    local range_check_ptr = range_check_ptr
    let (
        local _13_1256 : Uint256) = abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32(
        _12_1255,
        _10_1253,
        _9_1252,
        var_value_1241,
        var_deadline_1242,
        var_v_1243,
        var_r_1244,
        var_s_1245)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1257 : Uint256) = uint256_sub(_13_1256, _6_1249)
    local range_check_ptr = range_check_ptr
    local _15_1258 : Uint256 = _8_1251
    let (local _16_1259 : Uint256) = __warp_holder()
    let (local _17_1260 : Uint256) = __warp_holder()
    let (local _18_1261 : Uint256) = is_zero(_17_1260)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_18_1261)
    local exec_env : ExecutionEnvironment = exec_env
    __warp_if_42(_17_1260, _6_1249)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_75{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1223 : Uint256) -> (expr_1235 : Uint256):
    alloc_locals
    let (local _18_1236 : Uint256) = __warp_holder()
    finalize_allocation(_6_1223, _18_1236)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _19_1237 : Uint256) = __warp_holder()
    let (local _20_1238 : Uint256) = u256_add(_6_1223, _19_1237)
    local range_check_ptr = range_check_ptr
    let (local expr_1235 : Uint256) = abi_decode_uint256_fromMemory(_6_1223, _20_1238)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1235)
end

func __warp_if_43{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _16_1233 : Uint256, _6_1223 : Uint256, expr_1235 : Uint256) -> (expr_1235 : Uint256):
    alloc_locals
    if _16_1233.low + _16_1233.high != 0:
        let (local expr_1235 : Uint256) = __warp_block_75(_6_1223)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1235)
    else:
        return (expr_1235)
    end
end

func __warp_if_44{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _21_1239 : Uint256, var_deadline : Uint256, var_r_1218 : Uint256, var_s_1219 : Uint256,
        var_token_1215 : Uint256, var_v_1217 : Uint256, var_value_1216 : Uint256) -> ():
    alloc_locals
    if _21_1239.low + _21_1239.high != 0:
        fun_selfPermit(
            var_token_1215, var_value_1216, var_deadline, var_v_1217, var_r_1218, var_s_1219)
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
        var_token_1215 : Uint256, var_value_1216 : Uint256, var_deadline : Uint256,
        var_v_1217 : Uint256, var_r_1218 : Uint256, var_s_1219 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1220 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1221 : Uint256) = uint256_and(var_token_1215, _1_1220)
    local range_check_ptr = range_check_ptr
    local _5_1222 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1223 : Uint256) = mload_(_5_1222.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1224 : Uint256) = uint256_shl(
        Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1223.low, value=_7_1224)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1225 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1226 : Uint256) = __warp_holder()
    let (local _10_1227 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    local _11_1228 : Uint256 = Uint256(low=4, high=0)
    let (local _12_1229 : Uint256) = u256_add(_6_1223, _11_1228)
    local range_check_ptr = range_check_ptr
    let (local _13_1230 : Uint256) = abi_encode_address_address(_12_1229, _10_1227, _9_1226)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14_1231 : Uint256) = uint256_sub(_13_1230, _6_1223)
    local range_check_ptr = range_check_ptr
    let (local _15_1232 : Uint256) = __warp_holder()
    let (local _16_1233 : Uint256) = __warp_holder()
    let (local _17_1234 : Uint256) = is_zero(_16_1233)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_17_1234)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1235 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1235 : Uint256) = __warp_if_43(_16_1233, _6_1223, expr_1235)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1239 : Uint256) = is_lt(expr_1235, var_value_1216)
    local range_check_ptr = range_check_ptr
    __warp_if_44(
        _21_1239, var_deadline, var_r_1218, var_s_1219, var_token_1215, var_v_1217, var_value_1216)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func abi_decode_addresst_addresst_addresst_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_145 : Uint256, dataEnd_146 : Uint256) -> (
        value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_147 : Uint256 = Uint256(low=128, high=0)
    let (local _2_148 : Uint256) = uint256_sub(dataEnd_146, headStart_145)
    local range_check_ptr = range_check_ptr
    let (local _3_149 : Uint256) = slt(_2_148, _1_147)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_149)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0 : Uint256) = abi_decode_address(headStart_145)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_150 : Uint256 = Uint256(low=32, high=0)
    let (local _5_151 : Uint256) = u256_add(headStart_145, _4_150)
    local range_check_ptr = range_check_ptr
    let (local value1 : Uint256) = abi_decode_address(_5_151)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _6_152 : Uint256 = Uint256(low=64, high=0)
    let (local _7_153 : Uint256) = u256_add(headStart_145, _6_152)
    local range_check_ptr = range_check_ptr
    let (local value2 : Uint256) = abi_decode_address(_7_153)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _8_154 : Uint256 = Uint256(low=96, high=0)
    let (local _9_155 : Uint256) = u256_add(headStart_145, _8_154)
    local range_check_ptr = range_check_ptr
    let (local value3 : Uint256) = abi_decode_address(_9_155)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0, value1, value2, value3)
end

func setter_fun_factory{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1700 : Uint256) -> ():
    alloc_locals
    factory.write(value_1700)
    return ()
end

func setter_fun_WETH9{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1683 : Uint256) -> ():
    alloc_locals
    WETH9.write(value_1683)
    return ()
end

func setter_fun_OCaml{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1679 : Uint256) -> ():
    alloc_locals
    OCaml.write(value_1679)
    return ()
end

func setter_fun_seaplusplus{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1704 : Uint256) -> ():
    alloc_locals
    seaplusplus.write(value_1704)
    return ()
end

func setter_fun_I_am_a_mistake{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1675 : Uint256) -> ():
    alloc_locals
    I_am_a_mistake.write(value_1675)
    return ()
end

func setter_fun_succinctly{
        exec_env : ExecutionEnvironment, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(value_1708 : Uint256) -> ():
    alloc_locals
    succinctly.write(value_1708)
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
    let (local length_17 : Uint256) = calldata_load(offset_15.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
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
    local _9_26 : Uint256 = Uint256(low=5, high=0)
    let (local _10_27 : Uint256) = uint256_shl(_9_26, length_17)
    local range_check_ptr = range_check_ptr
    let (local _11_28 : Uint256) = u256_add(offset_15, _10_27)
    local range_check_ptr = range_check_ptr
    let (local _12_29 : Uint256) = u256_add(_11_28, _7_24)
    local range_check_ptr = range_check_ptr
    let (local _13_30 : Uint256) = is_gt(_12_29, end_16)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_13_30)
    local exec_env : ExecutionEnvironment = exec_env
    return (arrayPos, length_17)
end

func abi_decode_array_bytes_calldata_dyn_calldata{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_205 : Uint256, dataEnd_206 : Uint256) -> (
        value0_207 : Uint256, value1_208 : Uint256):
    alloc_locals
    local _1_209 : Uint256 = Uint256(low=32, high=0)
    let (local _2_210 : Uint256) = uint256_sub(dataEnd_206, headStart_205)
    local range_check_ptr = range_check_ptr
    let (local _3_211 : Uint256) = slt(_2_210, _1_209)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_211)
    local exec_env : ExecutionEnvironment = exec_env
    let (local offset_212 : Uint256) = calldata_load(headStart_205.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_213 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_214 : Uint256) = is_gt(offset_212, _4_213)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_5_214)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _6_215 : Uint256) = u256_add(headStart_205, offset_212)
    local range_check_ptr = range_check_ptr
    let (local value0_1 : Uint256,
        local value1_1 : Uint256) = abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr(
        _6_215, dataEnd_206)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local value0_207 : Uint256 = value0_1
    local value1_208 : Uint256 = value1_1
    return (value0_207, value1_208)
end

func array_allocation_size_array_bytes_dyn{exec_env : ExecutionEnvironment, range_check_ptr}(
        length_623 : Uint256) -> (size_624 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=64, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_625 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_626 : Uint256) = is_gt(length_623, _1_625)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_626)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_627 : Uint256 = Uint256(low=32, high=0)
    local _4_628 : Uint256 = Uint256(low=5, high=0)
    let (local _5_629 : Uint256) = uint256_shl(_4_628, length_623)
    local range_check_ptr = range_check_ptr
    let (local size_624 : Uint256) = u256_add(_5_629, _3_627)
    local range_check_ptr = range_check_ptr
    return (size_624)
end

func allocate_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_617 : Uint256) -> (memPtr_618 : Uint256):
    alloc_locals
    let (local _1_619 : Uint256) = array_allocation_size_array_bytes_dyn(length_617)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local memPtr_618 : Uint256) = allocate_memory(_1_619)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=memPtr_618.low, value=length_617)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr_618)
end

func __warp_loop_body_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, i_1761 : Uint256) -> (i_1761 : Uint256):
    alloc_locals
    local _2_1763 : Uint256 = Uint256(low=96, high=0)
    let (local _3_1764 : Uint256) = u256_add(dataStart, i_1761)
    local range_check_ptr = range_check_ptr
    mstore_(offset=_3_1764.low, value=_2_1763)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_1762 : Uint256 = Uint256(low=32, high=0)
    let (local i_1761 : Uint256) = u256_add(i_1761, _1_1762)
    local range_check_ptr = range_check_ptr
    return (i_1761)
end

func __warp_loop_5{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataSizeInBytes : Uint256, dataStart : Uint256, i_1761 : Uint256) -> (i_1761 : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(i_1761, dataSizeInBytes)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i_1761)
    end
    let (local i_1761 : Uint256) = __warp_loop_body_5(dataStart, i_1761)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local i_1761 : Uint256) = __warp_loop_5(dataSizeInBytes, dataStart, i_1761)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i_1761)
end

func zero_complex_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
    alloc_locals
    local i_1761 : Uint256 = Uint256(low=0, high=0)
    let (local i_1761 : Uint256) = __warp_loop_5(dataSizeInBytes, dataStart, i_1761)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func allocate_and_zero_memory_array_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        length_593 : Uint256) -> (memPtr : Uint256):
    alloc_locals
    let (local memPtr : Uint256) = allocate_memory_array_array_bytes_dyn(length_593)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _1_594 : Uint256) = uint256_not(Uint256(low=31, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_595 : Uint256) = array_allocation_size_array_bytes_dyn(length_593)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _3_596 : Uint256) = u256_add(_2_595, _1_594)
    local range_check_ptr = range_check_ptr
    local _4_597 : Uint256 = Uint256(low=32, high=0)
    let (local _5_598 : Uint256) = u256_add(memPtr, _4_597)
    local range_check_ptr = range_check_ptr
    zero_complex_memory_array_array_bytes_dyn(_5_598, _3_596)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (memPtr)
end

func calldata_array_index_access_bytes_calldata_dyn_calldata{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        base_ref_663 : Uint256, length_664 : Uint256, index : Uint256) -> (
        addr_665 : Uint256, len : Uint256):
    alloc_locals
    let (local _1_666 : Uint256) = is_lt(index, length_664)
    local range_check_ptr = range_check_ptr
    let (local _2_667 : Uint256) = is_zero(_1_666)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_667)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_668 : Uint256 = Uint256(low=5, high=0)
    let (local _4_669 : Uint256) = uint256_shl(_3_668, index)
    local range_check_ptr = range_check_ptr
    let (local _5_670 : Uint256) = u256_add(base_ref_663, _4_669)
    local range_check_ptr = range_check_ptr
    let (local addr_1_671 : Uint256, local len_1 : Uint256) = access_calldata_tail_bytes_calldata(
        base_ref_663, _5_670)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local addr_665 : Uint256 = addr_1_671
    local len : Uint256 = len_1
    return (addr_665, len)
end

func abi_encode_bytes_calldata{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        start : Uint256, length_364 : Uint256, pos_365 : Uint256) -> (end_366 : Uint256):
    alloc_locals
    copy_calldata_to_memory(start, pos_365, length_364)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local end_366 : Uint256) = u256_add(pos_365, length_364)
    local range_check_ptr = range_check_ptr
    return (end_366)
end

func memory_array_index_access_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        baseRef : Uint256, index_1558 : Uint256) -> (addr_1559 : Uint256):
    alloc_locals
    let (local _1_1560 : Uint256) = mload_(baseRef.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _2_1561 : Uint256) = is_lt(index_1558, _1_1560)
    local range_check_ptr = range_check_ptr
    let (local _3_1562 : Uint256) = is_zero(_2_1561)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_1562)
    local exec_env : ExecutionEnvironment = exec_env
    local _4_1563 : Uint256 = Uint256(low=32, high=0)
    local _5_1564 : Uint256 = Uint256(low=5, high=0)
    let (local _6_1565 : Uint256) = uint256_shl(_5_1564, index_1558)
    local range_check_ptr = range_check_ptr
    let (local _7_1566 : Uint256) = u256_add(baseRef, _6_1565)
    local range_check_ptr = range_check_ptr
    let (local addr_1559 : Uint256) = u256_add(_7_1566, _4_1563)
    local range_check_ptr = range_check_ptr
    return (addr_1559)
end

func increment_uint256{exec_env : ExecutionEnvironment, range_check_ptr}(value_1553 : Uint256) -> (
        ret_1554 : Uint256):
    alloc_locals
    let (local _1_1555 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1556 : Uint256) = is_eq(value_1553, _1_1555)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_1556)
    local exec_env : ExecutionEnvironment = exec_env
    local _3_1557 : Uint256 = Uint256(low=1, high=0)
    let (local ret_1554 : Uint256) = u256_add(value_1553, _3_1557)
    local range_check_ptr = range_check_ptr
    return (ret_1554)
end

func __warp_loop_body_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_data_1978_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local expr_2016_offset : Uint256,
        local expr_length : Uint256) = calldata_array_index_access_bytes_calldata_dyn_calldata(
        var_data_offset, var_data_1978_length, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _1_1028 : Uint256 = Uint256(low=64, high=0)
    let (local _2_1029 : Uint256) = mload_(_1_1028.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3_1030 : Uint256 = Uint256(low=0, high=0)
    local _4_1031 : Uint256 = _3_1030
    let (local _5_1032 : Uint256) = abi_encode_bytes_calldata(
        expr_2016_offset, expr_length, _2_1029)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _6_1033 : Uint256) = uint256_sub(_5_1032, _2_1029)
    local range_check_ptr = range_check_ptr
    let (local _7_1034 : Uint256) = __warp_holder()
    let (local _8_1035 : Uint256) = __warp_holder()
    let (local expr_2017_component : Uint256) = __warp_holder()
    let (local var_result_mpos : Uint256) = extract_returndata()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_result_mpos_1 : Uint256 = var_result_mpos
    let (local _9_1036 : Uint256) = is_zero(expr_2017_component)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_9_1036)
    local exec_env : ExecutionEnvironment = exec_env
    let (local _26_1053 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    mstore_(offset=_26_1053.low, value=var_result_mpos)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27_1054 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    __warp_holder()
    let (local var_i : Uint256) = increment_uint256(var_i)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (var_i)
end

func __warp_loop_3{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_data_1978_length : Uint256, var_data_offset : Uint256, var_i : Uint256,
        var_results_mpos : Uint256) -> (var_i : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(var_i, var_data_1978_length)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (var_i)
    end
    let (local var_i : Uint256) = __warp_loop_body_3(
        var_data_1978_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local var_i : Uint256) = __warp_loop_3(
        var_data_1978_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_i)
end

func fun_multicall_dynArgs{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        var_data_offset : Uint256, var_data_1978_length : Uint256) -> (var_results_mpos : Uint256):
    alloc_locals
    let (local var_results_mpos : Uint256) = allocate_and_zero_memory_array_array_bytes_dyn(
        var_data_1978_length)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local var_i : Uint256 = Uint256(low=0, high=0)
    let (local var_i : Uint256) = __warp_loop_3(
        var_data_1978_length, var_data_offset, var_i, var_results_mpos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (var_results_mpos)
end

func array_storeLengthForEncoding_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        pos_648 : Uint256, length_649 : Uint256) -> (updated_pos : Uint256):
    alloc_locals
    mstore_(offset=pos_648.low, value=length_649)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _1_650 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos : Uint256) = u256_add(pos_648, _1_650)
    local range_check_ptr = range_check_ptr
    return (updated_pos)
end

func abi_encodeUpdatedPos_bytes{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_330 : Uint256, pos : Uint256) -> (updatedPos : Uint256):
    alloc_locals
    let (local updatedPos : Uint256) = abi_encode_bytes_memory_ptr(value0_330, pos)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (updatedPos)
end

func __warp_loop_body_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_351 : Uint256, i : Uint256, pos_1 : Uint256, pos_346 : Uint256, srcPtr : Uint256,
        tail : Uint256) -> (i : Uint256, pos_346 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local _6_354 : Uint256) = uint256_sub(tail, pos_1)
    local range_check_ptr = range_check_ptr
    mstore_(offset=pos_346.low, value=_6_354)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_355 : Uint256) = mload_(srcPtr.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = abi_encodeUpdatedPos_bytes(_7_355, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local srcPtr : Uint256) = u256_add(srcPtr, _3_351)
    local range_check_ptr = range_check_ptr
    let (local pos_346 : Uint256) = u256_add(pos_346, _3_351)
    local range_check_ptr = range_check_ptr
    local _5_353 : Uint256 = Uint256(low=1, high=0)
    let (local i : Uint256) = u256_add(i, _5_353)
    local range_check_ptr = range_check_ptr
    return (i, pos_346, srcPtr, tail)
end

func __warp_loop_0{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _3_351 : Uint256, i : Uint256, length_348 : Uint256, pos_1 : Uint256, pos_346 : Uint256,
        srcPtr : Uint256, tail : Uint256) -> (
        i : Uint256, pos_346 : Uint256, srcPtr : Uint256, tail : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(i, length_348)
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        return (i, pos_346, srcPtr, tail)
    end
    let (local i : Uint256, local pos_346 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_body_0(_3_351, i, pos_1, pos_346, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local i : Uint256, local pos_346 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_3_351, i, length_348, pos_1, pos_346, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (i, pos_346, srcPtr, tail)
end

func abi_encode_array_bytes_dyn{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        value_345 : Uint256, pos_346 : Uint256) -> (end_347 : Uint256):
    alloc_locals
    let (local length_348 : Uint256) = mload_(value_345.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local pos_346 : Uint256) = array_storeLengthForEncoding_array_bytes_dyn(
        pos_346, length_348)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local pos_1 : Uint256 = pos_346
    local _1_349 : Uint256 = Uint256(low=5, high=0)
    let (local _2_350 : Uint256) = uint256_shl(_1_349, length_348)
    local range_check_ptr = range_check_ptr
    let (local tail : Uint256) = u256_add(pos_346, _2_350)
    local range_check_ptr = range_check_ptr
    local _3_351 : Uint256 = Uint256(low=32, high=0)
    local _4_352 : Uint256 = _3_351
    let (local srcPtr : Uint256) = u256_add(value_345, _3_351)
    local range_check_ptr = range_check_ptr
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i : Uint256, local pos_346 : Uint256, local srcPtr : Uint256,
        local tail : Uint256) = __warp_loop_0(_3_351, i, length_348, pos_1, pos_346, srcPtr, tail)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local end_347 : Uint256 = tail
    return (end_347)
end

func abi_encode_array_bytes_memory_ptr_dyn_memory_ptr{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_558 : Uint256, value0_559 : Uint256) -> (tail_560 : Uint256):
    alloc_locals
    local _1_561 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=headStart_558.low, value=_1_561)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _2_562 : Uint256 = _1_561
    let (local _3_563 : Uint256) = u256_add(headStart_558, _1_561)
    local range_check_ptr = range_check_ptr
    let (local tail_560 : Uint256) = abi_encode_array_bytes_dyn(value0_559, _3_563)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_560)
end

func abi_decode_addresst_uint256t_address{exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_156 : Uint256, dataEnd_157 : Uint256) -> (
        value0_158 : Uint256, value1_159 : Uint256, value2_160 : Uint256):
    alloc_locals
    local _1_161 : Uint256 = Uint256(low=96, high=0)
    let (local _2_162 : Uint256) = uint256_sub(dataEnd_157, headStart_156)
    local range_check_ptr = range_check_ptr
    let (local _3_163 : Uint256) = slt(_2_162, _1_161)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_163)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_158 : Uint256) = abi_decode_address(headStart_156)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_164 : Uint256 = Uint256(low=32, high=0)
    let (local _5_165 : Uint256) = u256_add(headStart_156, _4_164)
    local range_check_ptr = range_check_ptr
    let (local value1_159 : Uint256) = calldata_load(_5_165.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_166 : Uint256 = Uint256(low=64, high=0)
    let (local _7_167 : Uint256) = u256_add(headStart_156, _6_166)
    local range_check_ptr = range_check_ptr
    let (local value2_160 : Uint256) = abi_decode_address(_7_167)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_158, value1_159, value2_160)
end

func __warp_block_76{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _6_1346 : Uint256) -> (expr_1357 : Uint256):
    alloc_locals
    let (local _17_1358 : Uint256) = __warp_holder()
    finalize_allocation(_6_1346, _17_1358)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18_1359 : Uint256) = __warp_holder()
    let (local _19_1360 : Uint256) = u256_add(_6_1346, _18_1359)
    local range_check_ptr = range_check_ptr
    let (local expr_1357 : Uint256) = abi_decode_uint256_fromMemory(_6_1346, _19_1360)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1357)
end

func __warp_if_45{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _15_1355 : Uint256, _6_1346 : Uint256, expr_1357 : Uint256) -> (expr_1357 : Uint256):
    alloc_locals
    if _15_1355.low + _15_1355.high != 0:
        let (local expr_1357 : Uint256) = __warp_block_76(_6_1346)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1357)
    else:
        return (expr_1357)
    end
end

func __warp_if_46{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _23_1364 : Uint256, expr_1357 : Uint256, var_recipient_1342 : Uint256,
        var_token_1340 : Uint256) -> ():
    alloc_locals
    if _23_1364.low + _23_1364.high != 0:
        fun_safeTransfer(var_token_1340, var_recipient_1342, expr_1357)
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
        var_token_1340 : Uint256, var_amountMinimum_1341 : Uint256,
        var_recipient_1342 : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _1_1343 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_1344 : Uint256) = uint256_and(var_token_1340, _1_1343)
    local range_check_ptr = range_check_ptr
    local _5_1345 : Uint256 = Uint256(low=64, high=0)
    let (local _6_1346 : Uint256) = mload_(_5_1345.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _7_1347 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_6_1346.low, value=_7_1347)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _8_1348 : Uint256 = Uint256(low=32, high=0)
    let (local _9_1349 : Uint256) = __warp_holder()
    local _10_1350 : Uint256 = Uint256(low=4, high=0)
    let (local _11_1351 : Uint256) = u256_add(_6_1346, _10_1350)
    local range_check_ptr = range_check_ptr
    let (local _12_1352 : Uint256) = abi_encode_tuple_address(_11_1351, _9_1349)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13_1353 : Uint256) = uint256_sub(_12_1352, _6_1346)
    local range_check_ptr = range_check_ptr
    let (local _14_1354 : Uint256) = __warp_holder()
    let (local _15_1355 : Uint256) = __warp_holder()
    let (local _16_1356 : Uint256) = is_zero(_15_1355)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_16_1356)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1357 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1357 : Uint256) = __warp_if_45(_15_1355, _6_1346, expr_1357)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _20_1361 : Uint256) = is_lt(expr_1357, var_amountMinimum_1341)
    local range_check_ptr = range_check_ptr
    let (local _21_1362 : Uint256) = is_zero(_20_1361)
    local range_check_ptr = range_check_ptr
    require_helper(_21_1362)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _22_1363 : Uint256) = is_zero(expr_1357)
    local range_check_ptr = range_check_ptr
    let (local _23_1364 : Uint256) = is_zero(_22_1363)
    local range_check_ptr = range_check_ptr
    __warp_if_46(_23_1364, expr_1357, var_recipient_1342, var_token_1340)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func abi_decode_addresst_uint256t_addresst_uint256t_address{
        exec_env : ExecutionEnvironment, range_check_ptr}(
        headStart_168 : Uint256, dataEnd_169 : Uint256) -> (
        value0_170 : Uint256, value1_171 : Uint256, value2_172 : Uint256, value3_173 : Uint256,
        value4 : Uint256):
    alloc_locals
    local _1_174 : Uint256 = Uint256(low=160, high=0)
    let (local _2_175 : Uint256) = uint256_sub(dataEnd_169, headStart_168)
    local range_check_ptr = range_check_ptr
    let (local _3_176 : Uint256) = slt(_2_175, _1_174)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_3_176)
    local exec_env : ExecutionEnvironment = exec_env
    let (local value0_170 : Uint256) = abi_decode_address(headStart_168)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _4_177 : Uint256 = Uint256(low=32, high=0)
    let (local _5_178 : Uint256) = u256_add(headStart_168, _4_177)
    local range_check_ptr = range_check_ptr
    let (local value1_171 : Uint256) = calldata_load(_5_178.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _6_179 : Uint256 = Uint256(low=64, high=0)
    let (local _7_180 : Uint256) = u256_add(headStart_168, _6_179)
    local range_check_ptr = range_check_ptr
    let (local value2_172 : Uint256) = abi_decode_address(_7_180)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    local _8_181 : Uint256 = Uint256(low=96, high=0)
    let (local _9_182 : Uint256) = u256_add(headStart_168, _8_181)
    local range_check_ptr = range_check_ptr
    let (local value3_173 : Uint256) = calldata_load(_9_182.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _10_183 : Uint256 = Uint256(low=128, high=0)
    let (local _11_184 : Uint256) = u256_add(headStart_168, _10_183)
    local range_check_ptr = range_check_ptr
    let (local value4 : Uint256) = abi_decode_address(_11_184)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return (value0_170, value1_171, value2_172, value3_173, value4)
end

func __warp_block_77{exec_env : ExecutionEnvironment, range_check_ptr}(var_feeBips : Uint256) -> (
        expr_1309 : Uint256):
    alloc_locals
    local _2_1310 : Uint256 = Uint256(low=100, high=0)
    let (local _3_1311 : Uint256) = is_gt(var_feeBips, _2_1310)
    local range_check_ptr = range_check_ptr
    let (local expr_1309 : Uint256) = is_zero(_3_1311)
    local range_check_ptr = range_check_ptr
    return (expr_1309)
end

func __warp_if_47{exec_env : ExecutionEnvironment, range_check_ptr}(
        expr_1309 : Uint256, var_feeBips : Uint256) -> (expr_1309 : Uint256):
    alloc_locals
    if expr_1309.low + expr_1309.high != 0:
        let (local expr_1309 : Uint256) = __warp_block_77(var_feeBips)
        local range_check_ptr = range_check_ptr
        local exec_env : ExecutionEnvironment = exec_env
        return (expr_1309)
    else:
        return (expr_1309)
    end
end

func __warp_block_78{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _9_1315 : Uint256) -> (expr_1_1326 : Uint256):
    alloc_locals
    let (local _20_1327 : Uint256) = __warp_holder()
    finalize_allocation(_9_1315, _20_1327)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21_1328 : Uint256) = __warp_holder()
    let (local _22_1329 : Uint256) = u256_add(_9_1315, _21_1328)
    local range_check_ptr = range_check_ptr
    let (local expr_1_1326 : Uint256) = abi_decode_uint256_fromMemory(_9_1315, _22_1329)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (expr_1_1326)
end

func __warp_if_48{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _18_1324 : Uint256, _9_1315 : Uint256, expr_1_1326 : Uint256) -> (expr_1_1326 : Uint256):
    alloc_locals
    if _18_1324.low + _18_1324.high != 0:
        let (local expr_1_1326 : Uint256) = __warp_block_78(_9_1315)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return (expr_1_1326)
    else:
        return (expr_1_1326)
    end
end

func __warp_if_50{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _30_1338 : Uint256, expr_2_1336 : Uint256, var_feeRecipient : Uint256,
        var_token_1306 : Uint256) -> ():
    alloc_locals
    if _30_1338.low + _30_1338.high != 0:
        fun_safeTransfer(var_token_1306, var_feeRecipient, expr_2_1336)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_79{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        expr_1_1326 : Uint256, var_feeBips : Uint256, var_feeRecipient : Uint256,
        var_recipient_1307 : Uint256, var_token_1306 : Uint256) -> ():
    alloc_locals
    local _27_1334 : Uint256 = Uint256(low=10000, high=0)
    let (local _28_1335 : Uint256) = fun_mul(expr_1_1326, var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local expr_2_1336 : Uint256) = checked_div_uint256(_28_1335, _27_1334)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _29_1337 : Uint256) = is_zero(expr_2_1336)
    local range_check_ptr = range_check_ptr
    let (local _30_1338 : Uint256) = is_zero(_29_1337)
    local range_check_ptr = range_check_ptr
    __warp_if_50(_30_1338, expr_2_1336, var_feeRecipient, var_token_1306)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31_1339 : Uint256) = checked_sub_uint256(expr_1_1326, expr_2_1336)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_safeTransfer(var_token_1306, var_recipient_1307, _31_1339)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_if_49{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _26_1333 : Uint256, expr_1_1326 : Uint256, var_feeBips : Uint256,
        var_feeRecipient : Uint256, var_recipient_1307 : Uint256, var_token_1306 : Uint256) -> ():
    alloc_locals
    if _26_1333.low + _26_1333.high != 0:
        __warp_block_79(
            expr_1_1326, var_feeBips, var_feeRecipient, var_recipient_1307, var_token_1306)
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
        var_token_1306 : Uint256, var_amountMinimum : Uint256, var_recipient_1307 : Uint256,
        var_feeBips : Uint256, var_feeRecipient : Uint256) -> ():
    alloc_locals
    let (local _1_1308 : Uint256) = is_zero(var_feeBips)
    local range_check_ptr = range_check_ptr
    let (local expr_1309 : Uint256) = is_zero(_1_1308)
    local range_check_ptr = range_check_ptr
    let (local expr_1309 : Uint256) = __warp_if_47(expr_1309, var_feeBips)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    require_helper(expr_1309)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local __warp_subexpr_0 : Uint256) = uint256_shl(
        Uint256(low=160, high=0), Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _4_1312 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
    local range_check_ptr = range_check_ptr
    let (local _5_1313 : Uint256) = uint256_and(var_token_1306, _4_1312)
    local range_check_ptr = range_check_ptr
    local _8_1314 : Uint256 = Uint256(low=64, high=0)
    let (local _9_1315 : Uint256) = mload_(_8_1314.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _10_1316 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
    local range_check_ptr = range_check_ptr
    mstore_(offset=_9_1315.low, value=_10_1316)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _11_1317 : Uint256 = Uint256(low=32, high=0)
    let (local _12_1318 : Uint256) = __warp_holder()
    local _13_1319 : Uint256 = Uint256(low=4, high=0)
    let (local _14_1320 : Uint256) = u256_add(_9_1315, _13_1319)
    local range_check_ptr = range_check_ptr
    let (local _15_1321 : Uint256) = abi_encode_tuple_address(_14_1320, _12_1318)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16_1322 : Uint256) = uint256_sub(_15_1321, _9_1315)
    local range_check_ptr = range_check_ptr
    let (local _17_1323 : Uint256) = __warp_holder()
    let (local _18_1324 : Uint256) = __warp_holder()
    let (local _19_1325 : Uint256) = is_zero(_18_1324)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_19_1325)
    local exec_env : ExecutionEnvironment = exec_env
    local expr_1_1326 : Uint256 = Uint256(low=0, high=0)
    let (local expr_1_1326 : Uint256) = __warp_if_48(_18_1324, _9_1315, expr_1_1326)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23_1330 : Uint256) = is_lt(expr_1_1326, var_amountMinimum)
    local range_check_ptr = range_check_ptr
    let (local _24_1331 : Uint256) = is_zero(_23_1330)
    local range_check_ptr = range_check_ptr
    require_helper(_24_1331)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local _25_1332 : Uint256) = is_zero(expr_1_1326)
    local range_check_ptr = range_check_ptr
    let (local _26_1333 : Uint256) = is_zero(_25_1332)
    local range_check_ptr = range_check_ptr
    __warp_if_49(
        _26_1333, expr_1_1326, var_feeBips, var_feeRecipient, var_recipient_1307, var_token_1306)
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
    let (local _1_766 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _2_767 : Uint256) = cleanup_address(_1_766)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local _3_768 : Uint256) = get_caller_data_uint256()
    local syscall_ptr : felt* = syscall_ptr
    let (local _4_769 : Uint256) = is_eq(_3_768, _2_767)
    local range_check_ptr = range_check_ptr
    require_helper(_4_769)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    return ()
end

func __warp_block_83{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _11 : Uint256 = _4
    let (local _12 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_exactInputSingle_dynArgs(_12)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _13 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = uint256_sub(_13, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_85{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _15 : Uint256 = _4
    let (local _16 : Uint256) = abi_decode_struct_ExactOutputSingleParams_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_exactOutputSingle_dynArgs(_16)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_1 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _17 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _18 : Uint256) = uint256_sub(_17, memPos_1)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_87{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _19 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_refundETH()
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _20 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_89{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _21 : Uint256) = __warp_holder()
    __warp_cond_revert(_21)
    local exec_env : ExecutionEnvironment = exec_env
    local _22 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = getter_fun_succinctly()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_2 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _23 : Uint256) = abi_encode_tuple_address(memPos_2, ret_2)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _24 : Uint256) = uint256_sub(_23, memPos_2)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_91{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _25 : Uint256) = __warp_holder()
    __warp_cond_revert(_25)
    local exec_env : ExecutionEnvironment = exec_env
    local _26 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = getter_fun_age()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_3 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _27 : Uint256) = abi_encode_uint256(memPos_3, ret_3)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _28 : Uint256) = uint256_sub(_27, memPos_3)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_93{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _29 : Uint256) = __warp_holder()
    __warp_cond_revert(_29)
    local exec_env : ExecutionEnvironment = exec_env
    local _30 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = getter_fun_OCaml()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_4 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _31 : Uint256) = abi_encode_tuple_address(memPos_4, ret_4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _32 : Uint256) = uint256_sub(_31, memPos_4)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_95{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _33 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256, local param_2 : Uint256,
        local param_3 : Uint256, local param_4 : Uint256,
        local param_5 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitAllowed(param, param_1, param_2, param_3, param_4, param_5)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _34 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_97{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _35 : Uint256 = _4
    let (local _36 : Uint256) = abi_decode_struct_ExactOutputParams_calldata_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_5 : Uint256) = fun_exactOutput_dynArgs(_36)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_5 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _37 : Uint256) = abi_encode_uint256(memPos_5, ret_5)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _38 : Uint256) = uint256_sub(_37, memPos_5)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_99{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _39 : Uint256 = _4
    let (local param_6 : Uint256, local param_7 : Uint256) = abi_decode_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_unwrapWETH9(param_6, param_7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _40 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_101{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _41 : Uint256) = __warp_holder()
    __warp_cond_revert(_41)
    local exec_env : ExecutionEnvironment = exec_env
    local _42 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_6 : Uint256) = getter_fun_WETH9()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_6 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _43 : Uint256) = abi_encode_tuple_address(memPos_6, ret_6)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _44 : Uint256) = uint256_sub(_43, memPos_6)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_103{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _45 : Uint256 = _4
    let (local _46 : Uint256) = abi_decode_struct_ExactInputParams_memory_ptr(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local ret_7 : Uint256) = fun_exactInput_dynArgs(_46)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local memPos_7 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _47 : Uint256) = abi_encode_uint256(memPos_7, ret_7)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _48 : Uint256) = uint256_sub(_47, memPos_7)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_105{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _49 : Uint256) = __warp_holder()
    __warp_cond_revert(_49)
    local exec_env : ExecutionEnvironment = exec_env
    local _50 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_8 : Uint256) = getter_fun_I_am_a_mistake()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_8 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _51 : Uint256) = abi_encode_tuple_address(memPos_8, ret_8)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _52 : Uint256) = uint256_sub(_51, memPos_8)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_107{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _53 : Uint256) = __warp_holder()
    __warp_cond_revert(_53)
    local exec_env : ExecutionEnvironment = exec_env
    local _54 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_9 : Uint256) = getter_fun_seaplusplus()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_9 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _55 : Uint256) = abi_encode_tuple_address(memPos_9, ret_9)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _56 : Uint256) = uint256_sub(_55, memPos_9)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_109{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _57 : Uint256) = __warp_holder()
    __warp_cond_revert(_57)
    local exec_env : ExecutionEnvironment = exec_env
    local _58 : Uint256 = _4
    let (local param_8 : Uint256, local param_9 : Uint256, local param_10 : Uint256,
        local param_11 : Uint256) = abi_decode_int256t_int256t_bytes_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_uniswapV3SwapCallback_dynArgs(param_8, param_9, param_10, param_11)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _59 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_111{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _60 : Uint256 = _4
    let (local param_12 : Uint256, local param_13 : Uint256, local param_14 : Uint256,
        local param_15 : Uint256) = abi_decode_uint256t_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_unwrapWETH9WithFee(param_12, param_13, param_14, param_15)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _61 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_113{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _62 : Uint256 = _4
    let (local param_16 : Uint256, local param_17 : Uint256, local param_18 : Uint256,
        local param_19 : Uint256, local param_20 : Uint256,
        local param_21 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitAllowedIfNecessary(param_16, param_17, param_18, param_19, param_20, param_21)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _63 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_115{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _64 : Uint256 = _4
    let (local param_22 : Uint256, local param_23 : Uint256, local param_24 : Uint256,
        local param_25 : Uint256, local param_26 : Uint256,
        local param_27 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermitIfNecessary(param_22, param_23, param_24, param_25, param_26, param_27)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _65 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_117{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    let (local _66 : Uint256) = __warp_holder()
    __warp_cond_revert(_66)
    local exec_env : ExecutionEnvironment = exec_env
    local _67 : Uint256 = _4
    abi_decode(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_10 : Uint256) = getter_fun_factory()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local exec_env : ExecutionEnvironment = exec_env
    let (local memPos_10 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _68 : Uint256) = abi_encode_tuple_address(memPos_10, ret_10)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _69 : Uint256) = uint256_sub(_68, memPos_10)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_119{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _70 : Uint256) = __warp_holder()
    __warp_cond_revert(_70)
    local exec_env : ExecutionEnvironment = exec_env
    local _71 : Uint256 = _4
    let (local param_28 : Uint256, local param_29 : Uint256, local param_30 : Uint256,
        local param_31 : Uint256) = abi_decode_addresst_addresst_addresst_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_warp_constructor(param_28, param_29, param_30, param_31)
    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _72 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_121{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _73 : Uint256 = _4
    let (local param_32 : Uint256,
        local param_33 : Uint256) = abi_decode_array_bytes_calldata_dyn_calldata(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    let (local ret_11 : Uint256) = fun_multicall_dynArgs(param_32, param_33)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local memPos_11 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _74 : Uint256) = abi_encode_array_bytes_memory_ptr_dyn_memory_ptr(memPos_11, ret_11)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _75 : Uint256) = uint256_sub(_74, memPos_11)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_123{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _76 : Uint256 = _4
    let (local param_34 : Uint256, local param_35 : Uint256,
        local param_36 : Uint256) = abi_decode_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_sweepToken(param_34, param_35, param_36)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _77 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_125{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _78 : Uint256 = _4
    let (local param_37 : Uint256, local param_38 : Uint256, local param_39 : Uint256,
        local param_40 : Uint256,
        local param_41 : Uint256) = abi_decode_addresst_uint256t_addresst_uint256t_address(_3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_sweepTokenWithFee(param_37, param_38, param_39, param_40, param_41)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _79 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_127{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _80 : Uint256 = _4
    let (local param_42 : Uint256, local param_43 : Uint256, local param_44 : Uint256,
        local param_45 : Uint256, local param_46 : Uint256,
        local param_47 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(
        _3, _4)
    local exec_env : ExecutionEnvironment = exec_env
    local range_check_ptr = range_check_ptr
    fun_selfPermit(param_42, param_43, param_44, param_45, param_46, param_47)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local syscall_ptr : felt* = syscall_ptr
    let (local _81 : Uint256) = mload_(_1.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_if_74{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_127(_1, _3, _4, _7)
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

func __warp_block_126{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4086914151, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_74(_1, _3, _4, _7, __warp_subexpr_0)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_125(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_126(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_124{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3772877216, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_73(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_123(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_124(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_122{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3744118203, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_72(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_121(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        return ()
    else:
        __warp_block_122(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_120{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize, range_check_ptr,
        syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3544941711, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_71(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_119(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_120(_1, _3, _4, _7, match_var)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    end
end

func __warp_block_118{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3317519410, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_70(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_117(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_118(_1, _3, _4, _7, match_var)
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

func __warp_block_116{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3294232917, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_69(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_115(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_116(_1, _3, _4, _7, match_var)
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

func __warp_block_114{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3269661706, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_68(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_113(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_114(_1, _3, _4, _7, match_var)
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

func __warp_block_112{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2762444556, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_67(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_111(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_112(_1, _3, _4, _7, match_var)
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

func __warp_block_110{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2603354679, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_66(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_109(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_110(_1, _3, _4, _7, match_var)
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

func __warp_block_108{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2496631155, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_65(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_107(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_108(_1, _3, _4, _7, match_var)
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

func __warp_block_106{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2301295456, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_64(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_105(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_106(_1, _3, _4, _7, match_var)
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

func __warp_block_104{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2129988926, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_63(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_103(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_104(_1, _3, _4, _7, match_var)
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

func __warp_block_102{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1732944880, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_62(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_101(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_102(_1, _3, _4, _7, match_var)
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

func __warp_block_100{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1252304124, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_61(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_99(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_100(_1, _3, _4, _7, match_var)
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

func __warp_block_98{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1228950396, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_60(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_97(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_98(_1, _3, _4, _7, match_var)
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

func __warp_block_96{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180282849, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_59(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_95(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_96(_1, _3, _4, _7, match_var)
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

func __warp_block_94{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180279956, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_58(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_93(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_94(_1, _3, _4, _7, match_var)
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

func __warp_block_92{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=725343503, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_57(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_91(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_92(_1, _3, _4, _7, match_var)
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

func __warp_block_90{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=640327167, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_56(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_89(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_90(_1, _3, _4, _7, match_var)
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

func __warp_block_88{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=422912998, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_55(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_87(_1, _3, _4, _7)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local range_check_ptr = range_check_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_88(_1, _3, _4, _7, match_var)
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

func __warp_block_86{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=304156298, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_54(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_85(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_86(_1, _3, _4, _7, match_var)
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

func __warp_block_84{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=294090526, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_53(_1, _3, _4, _7, __warp_subexpr_0, match_var)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_83(_1, _3, _4)
        local exec_env : ExecutionEnvironment = exec_env
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        __warp_block_84(_1, _3, _4, _7, match_var)
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

func __warp_block_82{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=136250211, high=0))
    local range_check_ptr = range_check_ptr
    __warp_if_52(_1, _3, _4, _7, __warp_subexpr_0, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_81{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _10 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_82(_1, _3, _4, _7, match_var)
    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_80{
        exec_env : ExecutionEnvironment, memory_dict : DictAccess*, msize,
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        _1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldata_load(_7.low)
    local range_check_ptr = range_check_ptr
    local exec_env : ExecutionEnvironment = exec_env
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    __warp_block_81(_1, _10, _3, _4, _7)
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
        _1 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
    alloc_locals
    if _6.low + _6.high != 0:
        __warp_block_80(_1, _3, _4)
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
    with memory_dict, range_check_ptr, msize: 
        mstore_(offset=_1.low, value=_2)
    end
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    local _3 : Uint256 = Uint256(low=4, high=0)
    let (local _4 : Uint256) = __warp_constant_0()
    let (local _5 : Uint256) = is_lt(_4, _3)
    local range_check_ptr = range_check_ptr
    let (local _6 : Uint256) = is_zero(_5)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_51(_1, _3, _4, _6)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _82 : Uint256 = _4
    let (local _83 : Uint256) = is_zero(_4)
    local range_check_ptr = range_check_ptr
    with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
        __warp_if_75(_83)
    end

    local exec_env : ExecutionEnvironment = exec_env
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

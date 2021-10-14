ptr
ptr_1541
pos_319
pos_374
_9_675
_1_563
memPtr_1625
memPtr_1621
var_bytes_2364_mpos
_12_1287
var_bytes_mpos
_12_1308
memPtr_553
_5_558
_8_561
memPtr_1627
pos_315
pos_370
memPtr_1591
pos_340
var_key_mpos
_4_683
_12_691
_11_690
expr_2626_mpos
expr_2626_mpos
_17_696
_22_701
_11_690
expr_2629_mpos
expr_2629_mpos
_25_705
_30_710
pos_586
_2_653
_4_655
_7_658
value_344
value_358
pos_359
_5_366
headStart_517
pos_336
_9_495
headStart_211
_5_219
var_data_2953_mpos
_15_733
expr_3033_mpos
_15_733
_25_741
_5_765
expr_3077_mpos
_21_783
_24_786
_3_1480
var_data_mpos
Uint256(low=64
expr_3259_mpos
Uint256(low=64
_8_837
_7_858
expr_mpos
_21_874
_24_877
_3_1498
memPtr_568
expr_1562_mpos
offset
offset_128
_5_185
_7_187
_11_191
_13_193
pos_380
_5_1107
_6_1108
headStart_263
ptr_to_tail
addr_1
_2_647
array
_11_897
_15_901
_3_1506
headStart_289
headStart_283
_5_1399
_29_1422
_5_1399
_6_1400
offset_48
headStart
value_69
_13_83
_15_85
_18_88
_20_90
_23_93
_25_95
_28_98
headStart_247
var_path_mpos
usr_cc
usr_mc
_13_1196
var_tempBytes_mpos
_13_1196
_28_1211
var_tempBytes_mpos
_28_1211
var__bytes_mpos
var_path_2532_mpos
_8_802
_4_797
var_params_mpos
var_params_mpos
var_params_mpos
_4_797
var_params_mpos
_20_814
_3_1489
offset_33
headStart_220
_5_230
_7_232
headStart_111
value_113
_13_127
headStart_273
offset_31
expr_1437_component_2_mpos
_1_1026
_3_1028
expr_1436_mpos
expr_1436_mpos
expr_component_mpos
_1_1053
_3_1055
expr_1480_mpos
expr_1480_mpos
_14_979
_15_980
_14_979
_30_993
_17_1328
expr_2842_mpos
expr_2842_mpos
expr_2842_mpos
_27_1338
expr_2842_mpos
headStart_298
_7_310
_8_1352
_32_1375
_8_1352
_9_1353
_5_1080
_6_1081
_5_1158
_6_1159
_5_1132
_6_1133
offset_15
headStart_194
memPtr_565
_3_1634
baseRef
_1_938
_26_963
pos_325
srcPtr
value_324
headStart_505
_5_154
_5_1255
_6_1256
_5_167
_9_171
_8_1224
_9_1225
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_1
_7
_1
%lang starknet
%builtins pedersen range_check

from evm.calls import (
    calldata_load,
    calldatacopy_,
    get_caller_data_uint256,
)
from evm.exec_env import ExecutionEnvironment
from evm.memory import (
    mload_,
    mstore_,
)
from evm.sha3 import sha
from evm.uint256 import (
    is_eq,
    is_gt,
    is_lt,
    is_zero,
    sgt,
    slt,
    u256_add,
    u256_div,
    u256_mul,
)
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import (
    default_dict_finalize,
    default_dict_new,
)
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_and,
    uint256_eq,
    uint256_not,
    uint256_shl,
    uint256_shr,
    uint256_sub,
)
from starkware.starknet.common.storage import Storage

@storage_var
func I_am_a_mistake() -> (res: Uint256):
end

@storage_var
func OCaml() -> (res: Uint256):
end

@storage_var
func WETH9() -> (res: Uint256):
end

@storage_var
func age() -> (res: Uint256):
end

@storage_var
func amountInCached() -> (res: Uint256):
end

@storage_var
func balancePeople() -> (res: Uint256):
end

@storage_var
func balancePeople_2201(arg0_low, arg0_high) -> (res: Uint256):
end

@storage_var
func factory() -> (res: Uint256):
end

@storage_var
func seaplusplus() -> (res: Uint256):
end

@storage_var
func succinctly() -> (res: Uint256):
end



func __warp_holder() -> (res : Uint256):
    return (res=Uint256(0,0))
end

@storage_var
func evm_storage(low: felt, high: felt, part: felt) -> (res : felt):
end

func s_load{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        key: Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        key: Uint256, value: Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end

@storage_var
func this_address() -> (res: felt):
end

@storage_var
func address_initialized() -> (res : felt):
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

func abi_decode_struct_ExactInputSingleParams_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(offset_99 : Uint256, end_100 : Uint256) -> (value_101 : Uint256):
alloc_locals
local _1_102 : Uint256 = Uint256(low=256, high=0)
let (local _2_103 : Uint256) = uint256_sub(end_100, offset_99)
local range_check_ptr = range_check_ptr
let (local _3_104 : Uint256) = slt(_2_103, _1_102)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_104)
local exec_env: ExecutionEnvironment = exec_env
local value_101 : Uint256 = offset_99
return (value_101)
end

func abi_decode_struct_ExactInputSingleParams_calldata_ptr{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_257 : Uint256, dataEnd_258 : Uint256) -> (value0_259 : Uint256):
alloc_locals
local _1_260 : Uint256 = Uint256(low=256, high=0)
let (local _2_261 : Uint256) = uint256_sub(dataEnd_258, headStart_257)
local range_check_ptr = range_check_ptr
let (local _3_262 : Uint256) = slt(_2_261, _1_260)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_262)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_259 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata(headStart_257, dataEnd_258)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_259)
end

func require_helper{exec_env: ExecutionEnvironment, range_check_ptr}(condition : Uint256) -> ():
alloc_locals
let (local _1_1544 : Uint256) = is_zero(condition)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_1_1544)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func validator_revert_address{exec_env: ExecutionEnvironment, range_check_ptr}(value_1593 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1594 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1595 : Uint256) = uint256_and(value_1593, _1_1594)
local range_check_ptr = range_check_ptr
let (local _3_1596 : Uint256) = is_eq(value_1593, _2_1595)
local range_check_ptr = range_check_ptr
let (local _4_1597 : Uint256) = is_zero(_3_1596)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_1597)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func read_from_calldatat_address{exec_env: ExecutionEnvironment, range_check_ptr}(ptr : Uint256) -> (returnValue : Uint256):
alloc_locals
let (local value_1540 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
validator_revert_address(value_1540)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local returnValue : Uint256 = value_1540
return (returnValue)
end

func validator_revert_uint24{exec_env: ExecutionEnvironment, range_check_ptr}(value_1607 : Uint256) -> ():
alloc_locals
local _1_1608 : Uint256 = Uint256(low=16777215, high=0)
let (local _2_1609 : Uint256) = uint256_and(value_1607, _1_1608)
local range_check_ptr = range_check_ptr
let (local _3_1610 : Uint256) = is_eq(value_1607, _2_1609)
local range_check_ptr = range_check_ptr
let (local _4_1611 : Uint256) = is_zero(_3_1610)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_1611)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func read_from_calldatat_uint24{exec_env: ExecutionEnvironment, range_check_ptr}(ptr_1541 : Uint256) -> (returnValue_1542 : Uint256):
alloc_locals
let (local value_1543 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_1541.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
validator_revert_uint24(value_1543)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local returnValue_1542 : Uint256 = value_1543
return (returnValue_1542)
end

func abi_encode_address_to_address_nonPadded_inplace{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_318 : Uint256, pos_319 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_1 : Uint256) = uint256_shl(Uint256(low=96, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_sub(__warp_subexpr_1, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_320 : Uint256) = uint256_not(__warp_subexpr_0)
local range_check_ptr = range_check_ptr
local _2_321 : Uint256 = Uint256(low=96, high=0)
let (local _3_322 : Uint256) = uint256_shl(_2_321, value_318)
local range_check_ptr = range_check_ptr
let (local _4_323 : Uint256) = uint256_and(_3_322, _1_320)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_319.low, value=_4_323)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_uint24_to_uint24_nonPadded_inplace{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_373 : Uint256, pos_374 : Uint256) -> ():
alloc_locals
let (local _1_375 : Uint256) = uint256_shl(Uint256(low=232, high=0), Uint256(low=16777215, high=0))
local range_check_ptr = range_check_ptr
local _2_376 : Uint256 = Uint256(low=232, high=0)
let (local _3_377 : Uint256) = uint256_shl(_2_376, value_373)
local range_check_ptr = range_check_ptr
let (local _4_378 : Uint256) = uint256_and(_3_377, _1_375)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_374.low, value=_4_378)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_packed_address_uint24_address{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(pos_383 : Uint256, value0_384 : Uint256, value1_385 : Uint256, value2_386 : Uint256) -> (end_387 : Uint256):
alloc_locals
abi_encode_address_to_address_nonPadded_inplace(value0_384, pos_383)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _1_388 : Uint256 = Uint256(low=20, high=0)
let (local _2_389 : Uint256) = u256_add(pos_383, _1_388)
local range_check_ptr = range_check_ptr
abi_encode_uint24_to_uint24_nonPadded_inplace(value1_385, _2_389)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _3_390 : Uint256 = Uint256(low=23, high=0)
let (local _4_391 : Uint256) = u256_add(pos_383, _3_390)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address_nonPadded_inplace(value2_386, _4_391)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _5_392 : Uint256 = Uint256(low=43, high=0)
let (local end_387 : Uint256) = u256_add(pos_383, _5_392)
local range_check_ptr = range_check_ptr
return (end_387)
end

func finalize_allocation{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(memPtr_665 : Uint256, size_666 : Uint256) -> ():
alloc_locals
let (local _1_667 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
local _2_668 : Uint256 = Uint256(low=31, high=0)
let (local _3_669 : Uint256) = u256_add(size_666, _2_668)
local range_check_ptr = range_check_ptr
let (local _4_670 : Uint256) = uint256_and(_3_669, _1_667)
local range_check_ptr = range_check_ptr
let (local newFreePtr : Uint256) = u256_add(memPtr_665, _4_670)
local range_check_ptr = range_check_ptr
let (local _5_671 : Uint256) = is_lt(newFreePtr, memPtr_665)
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _6_672 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _7_673 : Uint256) = is_gt(newFreePtr, _6_672)
local range_check_ptr = range_check_ptr
let (local _8_674 : Uint256) = uint256_sub(_7_673, _5_671)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_8_674)
local exec_env: ExecutionEnvironment = exec_env
local _9_675 : Uint256 = Uint256(low=64, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_9_675.low, value=newFreePtr)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func allocate_memory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(size : Uint256) -> (memPtr_562 : Uint256):
alloc_locals
local _1_563 : Uint256 = Uint256(low=64, high=0)
let (local memPtr_562 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_563.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(memPtr_562, size)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (memPtr_562)
end

func write_to_memory_bytes{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(memPtr_1625 : Uint256, value_1626 : Uint256) -> ():
alloc_locals
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_1625.low, value=value_1626)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func write_to_memory_address{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(memPtr_1621 : Uint256, value_1622 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1623 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1624 : Uint256) = uint256_and(value_1622, _1_1623)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_1621.low, value=_2_1624)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func setter_fun_balancePeople{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1574 : Uint256) -> ():
alloc_locals
balancePeople.write(value_1574)
return ()
end

func setter_fun_balancePeople_2201{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(arg0 : Uint256, value_1578 : Uint256) -> ():
alloc_locals
balancePeople_2201.write(arg0.low, arg0.high, value_1578)
return ()
end

func setter_fun_age{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1566 : Uint256) -> ():
alloc_locals
age.write(value_1566)
return ()
end

func checked_add_uint256{exec_env: ExecutionEnvironment, range_check_ptr}(x_601 : Uint256, y_602 : Uint256) -> (sum_603 : Uint256):
alloc_locals
let (local _1_604 : Uint256) = uint256_not(y_602)
local range_check_ptr = range_check_ptr
let (local _2_605 : Uint256) = is_gt(x_601, _1_604)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_605)
local exec_env: ExecutionEnvironment = exec_env
let (local sum_603 : Uint256) = u256_add(x_601, y_602)
local range_check_ptr = range_check_ptr
return (sum_603)
end

func cleanup_bytes32(value_629 : Uint256) -> (cleaned_630 : Uint256):
alloc_locals
local cleaned_630 : Uint256 = value_629
return (cleaned_630)
end

func fun_toAddress{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_bytes_2364_mpos : Uint256, var_start : Uint256) -> (var : Uint256):
alloc_locals
local _1_1275 : Uint256 = Uint256(low=20, high=0)
let (local _2_1276 : Uint256) = checked_add_uint256(var_start, _1_1275)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _3_1277 : Uint256) = is_lt(_2_1276, var_start)
local range_check_ptr = range_check_ptr
let (local _4_1278 : Uint256) = is_zero(_3_1277)
local range_check_ptr = range_check_ptr
require_helper(_4_1278)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_1279 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_bytes_2364_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _5_1280 : Uint256 = _1_1275
let (local _6_1281 : Uint256) = checked_add_uint256(var_start, _1_1275)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _7_1282 : Uint256) = cleanup_bytes32(_6_1281)
local exec_env: ExecutionEnvironment = exec_env
let (local _8_1283 : Uint256) = is_lt(expr_1279, _7_1282)
local range_check_ptr = range_check_ptr
let (local _9_1284 : Uint256) = is_zero(_8_1283)
local range_check_ptr = range_check_ptr
require_helper(_9_1284)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _10_1285 : Uint256 = Uint256(low=32, high=0)
let (local _11_1286 : Uint256) = u256_add(var_bytes_2364_mpos, var_start)
local range_check_ptr = range_check_ptr
let (local _12_1287 : Uint256) = u256_add(_11_1286, _10_1285)
local range_check_ptr = range_check_ptr
let (local _13_1288 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_12_1287.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _14_1289 : Uint256 = Uint256(low=96, high=0)
let (local var : Uint256) = uint256_shr(_14_1289, _13_1288)
local range_check_ptr = range_check_ptr
return (var)
end

func fun_toUint24{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_bytes_mpos : Uint256, var_start_1294 : Uint256) -> (var_1295 : Uint256):
alloc_locals
local _1_1296 : Uint256 = Uint256(low=3, high=0)
let (local _2_1297 : Uint256) = checked_add_uint256(var_start_1294, _1_1296)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _3_1298 : Uint256) = is_lt(_2_1297, var_start_1294)
local range_check_ptr = range_check_ptr
let (local _4_1299 : Uint256) = is_zero(_3_1298)
local range_check_ptr = range_check_ptr
require_helper(_4_1299)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_1300 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_bytes_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _5_1301 : Uint256 = _1_1296
let (local _6_1302 : Uint256) = checked_add_uint256(var_start_1294, _1_1296)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _7_1303 : Uint256) = cleanup_bytes32(_6_1302)
local exec_env: ExecutionEnvironment = exec_env
let (local _8_1304 : Uint256) = is_lt(expr_1300, _7_1303)
local range_check_ptr = range_check_ptr
let (local _9_1305 : Uint256) = is_zero(_8_1304)
local range_check_ptr = range_check_ptr
require_helper(_9_1305)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _10_1306 : Uint256 = _1_1296
let (local _11_1307 : Uint256) = u256_add(var_bytes_mpos, var_start_1294)
local range_check_ptr = range_check_ptr
let (local _12_1308 : Uint256) = u256_add(_11_1307, _1_1296)
local range_check_ptr = range_check_ptr
let (local var_1295 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_12_1308.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (var_1295)
end

func fun_decodeFirstPool{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_path_2485_mpos : Uint256) -> (var_tokenA : Uint256, var_tokenB : Uint256, var_fee : Uint256):
alloc_locals
local _1_713 : Uint256 = Uint256(low=0, high=0)
let (local var_tokenA : Uint256) = fun_toAddress(var_path_2485_mpos, _1_713)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _2_714 : Uint256 = Uint256(low=20, high=0)
let (local var_fee : Uint256) = fun_toUint24(var_path_2485_mpos, _2_714)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _3_715 : Uint256 = Uint256(low=3, high=0)
local _4_716 : Uint256 = _2_714
let (local _5_717 : Uint256) = checked_add_uint256(_2_714, _3_715)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local var_tokenB : Uint256) = fun_toAddress(var_path_2485_mpos, _5_717)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_tokenA, var_tokenB, var_fee)
end

func getter_fun_factory{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1457 : Uint256):
alloc_locals
let (res) = factory.read()
return (res)
end

func allocate_and_zero_memory_struct_struct_PoolKey{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}() -> (memPtr_553 : Uint256):
alloc_locals
local _1_554 : Uint256 = Uint256(low=96, high=0)
let (local memPtr_553 : Uint256) = allocate_memory(_1_554)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _2_555 : Uint256 = Uint256(low=0, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_553.low, value=_2_555)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _3_556 : Uint256 = _2_555
local _4_557 : Uint256 = Uint256(low=32, high=0)
let (local _5_558 : Uint256) = u256_add(memPtr_553, _4_557)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_5_558.low, value=_2_555)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _6_559 : Uint256 = _2_555
local _7_560 : Uint256 = Uint256(low=64, high=0)
let (local _8_561 : Uint256) = u256_add(memPtr_553, _7_560)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_8_561.low, value=_2_555)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (memPtr_553)
end

func write_to_memory_uint24{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(memPtr_1627 : Uint256, value_1628 : Uint256) -> ():
alloc_locals
local _1_1629 : Uint256 = Uint256(low=16777215, high=0)
let (local _2_1630 : Uint256) = uint256_and(value_1628, _1_1629)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_1627.low, value=_2_1630)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func __warp_block_0(var_tokenA_912 : Uint256, var_tokenB_913 : Uint256) -> (var_tokenA_912 : Uint256, var_tokenB_913 : Uint256):
alloc_locals
local expr_2578_component : Uint256 = var_tokenB_913
local var_tokenB_913 : Uint256 = var_tokenA_912
local var_tokenA_912 : Uint256 = expr_2578_component
return (var_tokenA_912, var_tokenB_913)
end

func __warp_if_0{exec_env: ExecutionEnvironment, range_check_ptr}(_5_919 : Uint256, var_tokenA_912 : Uint256, var_tokenB_913 : Uint256) -> (var_tokenA_912 : Uint256, var_tokenB_913 : Uint256):
alloc_locals
if _5_919.low + _5_919.high != 0:
	let (local var_tokenA_912 : Uint256, local var_tokenB_913 : Uint256) = __warp_block_0(var_tokenA_912, var_tokenB_913)
local exec_env: ExecutionEnvironment = exec_env
return (var_tokenA_912, var_tokenB_913)
else:
	return (var_tokenA_912, var_tokenB_913)
end
end

func fun_getPoolKey{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_tokenA_912 : Uint256, var_tokenB_913 : Uint256, var_fee_914 : Uint256) -> (var__mpos : Uint256):
alloc_locals
let (local _1_915 : Uint256) = allocate_and_zero_memory_struct_struct_PoolKey()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
__warp_holder()
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_916 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _3_917 : Uint256) = uint256_and(var_tokenB_913, _2_916)
local range_check_ptr = range_check_ptr
let (local _4_918 : Uint256) = uint256_and(var_tokenA_912, _2_916)
local range_check_ptr = range_check_ptr
let (local _5_919 : Uint256) = is_gt(_4_918, _3_917)
local range_check_ptr = range_check_ptr
let (local var_tokenA_912 : Uint256, local var_tokenB_913 : Uint256) = __warp_if_0(_5_919, var_tokenA_912, var_tokenB_913)
local exec_env: ExecutionEnvironment = exec_env
local _6_920 : Uint256 = Uint256(low=96, high=0)
let (local expr_2586_mpos : Uint256) = allocate_memory(_6_920)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
write_to_memory_address(expr_2586_mpos, var_tokenA_912)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _7_921 : Uint256 = Uint256(low=32, high=0)
let (local _8_922 : Uint256) = u256_add(expr_2586_mpos, _7_921)
local range_check_ptr = range_check_ptr
write_to_memory_address(_8_922, var_tokenB_913)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _9_923 : Uint256 = Uint256(low=64, high=0)
let (local _10_924 : Uint256) = u256_add(expr_2586_mpos, _9_923)
local range_check_ptr = range_check_ptr
write_to_memory_uint24(_10_924, var_fee_914)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local var__mpos : Uint256 = expr_2586_mpos
return (var__mpos)
end

func cleanup_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_627 : Uint256) -> (cleaned : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_628 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local cleaned : Uint256) = uint256_and(value_627, _1_628)
local range_check_ptr = range_check_ptr
return (cleaned)
end

func cleanup_uint24{exec_env : ExecutionEnvironment, range_check_ptr}(value_631 : Uint256) -> (cleaned_632 : Uint256):
alloc_locals
local _1_633 : Uint256 = Uint256(low=16777215, high=0)
let (local cleaned_632 : Uint256) = uint256_and(value_631, _1_633)
local range_check_ptr = range_check_ptr
return (cleaned_632)
end

func abi_encode_address_to_address{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_314 : Uint256, pos_315 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_316 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_317 : Uint256) = uint256_and(value_314, _1_316)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_315.low, value=_2_317)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_uint24{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_369 : Uint256, pos_370 : Uint256) -> ():
alloc_locals
local _1_371 : Uint256 = Uint256(low=16777215, high=0)
let (local _2_372 : Uint256) = uint256_and(value_369, _1_371)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_370.low, value=_2_372)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_address_address_uint24{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_415 : Uint256, value0_416 : Uint256, value1_417 : Uint256, value2_418 : Uint256) -> (tail_419 : Uint256):
alloc_locals
local _1_420 : Uint256 = Uint256(low=96, high=0)
let (local tail_419 : Uint256) = u256_add(headStart_415, _1_420)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_416, headStart_415)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_421 : Uint256 = Uint256(low=32, high=0)
let (local _3_422 : Uint256) = u256_add(headStart_415, _2_421)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value1_417, _3_422)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _4_423 : Uint256 = Uint256(low=64, high=0)
let (local _5_424 : Uint256) = u256_add(headStart_415, _4_423)
local range_check_ptr = range_check_ptr
abi_encode_uint24(value2_418, _5_424)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (tail_419)
end

func store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(memPtr_1591 : Uint256) -> ():
alloc_locals
let (local _1_1592 : Uint256) = uint256_shl(Uint256(low=248, high=0), Uint256(low=255, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_1591.low, value=_1_1592)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_stringliteral_8b1a{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(pos_355 : Uint256) -> (end_356 : Uint256):
alloc_locals
store_literal_in_memory_8b1a944cf13a9a1c08facb2c9e98623ef3254d2ddb48113885c3e8e97fec8db9(pos_355)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _1_357 : Uint256 = Uint256(low=1, high=0)
let (local end_356 : Uint256) = u256_add(pos_355, _1_357)
local range_check_ptr = range_check_ptr
return (end_356)
end

func abi_encode_bytes32{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_339 : Uint256, pos_340 : Uint256) -> ():
alloc_locals
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_340.low, value=value_339)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(pos_393 : Uint256, value0_394 : Uint256, value1_395 : Uint256, value2_396 : Uint256) -> (end_397 : Uint256):
alloc_locals
let (local pos_1_398 : Uint256) = abi_encode_stringliteral_8b1a(pos_393)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
abi_encode_address_to_address_nonPadded_inplace(value0_394, pos_1_398)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _1_399 : Uint256 = Uint256(low=20, high=0)
let (local _2_400 : Uint256) = u256_add(pos_1_398, _1_399)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value1_395, _2_400)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _3_401 : Uint256 = Uint256(low=52, high=0)
let (local _4_402 : Uint256) = u256_add(pos_1_398, _3_401)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value2_396, _4_402)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _5_403 : Uint256 = Uint256(low=84, high=0)
let (local end_397 : Uint256) = u256_add(pos_1_398, _5_403)
local range_check_ptr = range_check_ptr
return (end_397)
end

func convert_bytes20_to_address{exec_env : ExecutionEnvironment, range_check_ptr}(value_642 : Uint256) -> (converted : Uint256):
alloc_locals
local _1_643 : Uint256 = Uint256(low=96, high=0)
let (local converted : Uint256) = uint256_shr(_1_643, value_642)
local range_check_ptr = range_check_ptr
return (converted)
end

func fun_computeAddress{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_factory : Uint256, var_key_mpos : Uint256) -> (var_pool : Uint256):
alloc_locals
let (local _1_680 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_key_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _2_681 : Uint256) = cleanup_address(_1_680)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _3_682 : Uint256 = Uint256(low=32, high=0)
let (local _4_683 : Uint256) = u256_add(var_key_mpos, _3_682)
local range_check_ptr = range_check_ptr
let (local _5_684 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_683.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _6_685 : Uint256) = cleanup_address(_5_684)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _7_686 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _8_687 : Uint256) = uint256_and(_6_685, _7_686)
local range_check_ptr = range_check_ptr
let (local _9_688 : Uint256) = uint256_and(_2_681, _7_686)
local range_check_ptr = range_check_ptr
let (local _10_689 : Uint256) = is_lt(_9_688, _8_687)
local range_check_ptr = range_check_ptr
require_helper(_10_689)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _11_690 : Uint256 = Uint256(low=64, high=0)
let (local _12_691 : Uint256) = u256_add(var_key_mpos, _11_690)
local range_check_ptr = range_check_ptr
let (local _13_692 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_12_691.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _14_693 : Uint256) = cleanup_uint24(_13_692)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _15_694 : Uint256 = _11_690
let (local expr_2626_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_11_690.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _16_695 : Uint256 = _3_682
let (local _17_696 : Uint256) = u256_add(expr_2626_mpos, _3_682)
local range_check_ptr = range_check_ptr
let (local _18_697 : Uint256) = abi_encode_address_address_uint24(_17_696, _2_681, _6_685, _14_693)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _19_698 : Uint256) = uint256_sub(_18_697, expr_2626_mpos)
local range_check_ptr = range_check_ptr
let (local _20_699 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _21_700 : Uint256) = u256_add(_19_698, _20_699)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_2626_mpos.low, value=_21_700)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_2626_mpos, _19_698)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _22_701 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_2626_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_702 : Uint256) = sha{range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_17_696.low,_22_701.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _23_703 : Uint256 = _11_690
let (local expr_2629_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_11_690.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _24_704 : Uint256 = _3_682
let (local _25_705 : Uint256) = u256_add(expr_2629_mpos, _3_682)
local range_check_ptr = range_check_ptr
local _26_706 : Uint256 = Uint256(low=166342034028256148788603429286353537876, high=302145465843558604112129201577554957650)
let (local _27_707 : Uint256) = abi_encode_packed_stringliteral_8b1a_address_bytes32_bytes32(_25_705, var_factory, expr_702, _26_706)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _28_708 : Uint256) = uint256_sub(_27_707, expr_2629_mpos)
local range_check_ptr = range_check_ptr
let (local _29_709 : Uint256) = u256_add(_28_708, _20_699)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_2629_mpos.low, value=_29_709)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_2629_mpos, _28_708)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _30_710 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_2629_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _31_711 : Uint256) = sha{range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_25_705.low,_30_710.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _32_712 : Uint256) = cleanup_bytes32(_31_711)
local exec_env: ExecutionEnvironment = exec_env
let (local var_pool : Uint256) = convert_bytes20_to_address(_32_712)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (var_pool)
end

func fun_getPool{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_tokenA_925 : Uint256, var_tokenB_926 : Uint256, var_fee_927 : Uint256) -> (var_address : Uint256):
alloc_locals
let (local _1_928 : Uint256) = getter_fun_factory()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _2_929 : Uint256) = fun_getPoolKey(var_tokenA_925, var_tokenB_926, var_fee_927)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _3_930 : Uint256) = fun_computeAddress(_1_928, _2_929)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local var_address : Uint256) = cleanup_address(_3_930)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (var_address)
end

func fun_toInt256{exec_env: ExecutionEnvironment, range_check_ptr}(var_y_1290 : Uint256) -> (var_z_1291 : Uint256):
alloc_locals
let (local _1_1292 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1293 : Uint256) = is_lt(var_y_1290, _1_1292)
local range_check_ptr = range_check_ptr
require_helper(_2_1293)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local var_z_1291 : Uint256 = var_y_1290
return (var_z_1291)
end

func checked_sub_uint160{exec_env: ExecutionEnvironment, range_check_ptr}(x_617 : Uint256, y_618 : Uint256) -> (diff : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_619 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local x_1_620 : Uint256) = uint256_and(x_617, _1_619)
local range_check_ptr = range_check_ptr
let (local y_1_621 : Uint256) = uint256_and(y_618, _1_619)
local range_check_ptr = range_check_ptr
let (local _2_622 : Uint256) = is_lt(x_1_620, y_1_621)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_622)
local exec_env: ExecutionEnvironment = exec_env
let (local diff : Uint256) = uint256_sub(x_1_620, y_1_621)
local range_check_ptr = range_check_ptr
return (diff)
end

func checked_add_uint160{exec_env: ExecutionEnvironment, range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_598 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local x_1 : Uint256) = uint256_and(x, _1_598)
local range_check_ptr = range_check_ptr
let (local y_1 : Uint256) = uint256_and(y, _1_598)
local range_check_ptr = range_check_ptr
let (local _2_599 : Uint256) = uint256_sub(_1_598, y_1)
local range_check_ptr = range_check_ptr
let (local _3_600 : Uint256) = is_gt(x_1, _2_599)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_600)
local exec_env: ExecutionEnvironment = exec_env
let (local sum : Uint256) = u256_add(x_1, y_1)
local range_check_ptr = range_check_ptr
return (sum)
end

func array_storeLengthForEncoding_array_bytes_dyn{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(pos_586 : Uint256, length_587 : Uint256) -> (updated_pos : Uint256):
alloc_locals
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_586.low, value=length_587)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _1_588 : Uint256 = Uint256(low=32, high=0)
let (local updated_pos : Uint256) = u256_add(pos_586, _1_588)
local range_check_ptr = range_check_ptr
return (updated_pos)
end

func __warp_loop_body_1{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dst_649 : Uint256, i_651 : Uint256, src_648 : Uint256) -> (i_651 : Uint256):
alloc_locals
let (local _2_653 : Uint256) = u256_add(src_648, i_651)
local range_check_ptr = range_check_ptr
let (local _3_654 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_2_653.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _4_655 : Uint256) = u256_add(dst_649, i_651)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_4_655.low, value=_3_654)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _1_652 : Uint256 = Uint256(low=32, high=0)
let (local i_651 : Uint256) = u256_add(i_651, _1_652)
local range_check_ptr = range_check_ptr
return (i_651)
end

func __warp_loop_1{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dst_649 : Uint256, i_651 : Uint256, src_648 : Uint256) -> (i_651 : Uint256):
alloc_locals
let (local i_651 : Uint256) = __warp_loop_body_1(dst_649, i_651, src_648)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local i_651 : Uint256) = __warp_loop_1(dst_649, i_651, src_648)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (i_651)
end

func __warp_block_1{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dst_649 : Uint256, length_650 : Uint256) -> ():
alloc_locals
local _6_657 : Uint256 = Uint256(low=0, high=0)
let (local _7_658 : Uint256) = u256_add(dst_649, length_650)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_7_658.low, value=_6_657)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func __warp_if_1{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_5_656 : Uint256, dst_649 : Uint256, length_650 : Uint256) -> ():
alloc_locals
if _5_656.low + _5_656.high != 0:
	__warp_block_1(dst_649, length_650)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return ()
else:
	return ()
end
end

func copy_memory_to_memory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(src_648 : Uint256, dst_649 : Uint256, length_650 : Uint256) -> ():
alloc_locals
local i_651 : Uint256 = Uint256(low=0, high=0)
let (local i_651 : Uint256) = __warp_loop_1(dst_649, i_651, src_648)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _5_656 : Uint256) = is_gt(i_651, length_650)
local range_check_ptr = range_check_ptr
__warp_if_1(_5_656, dst_649, length_650)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func abi_encode_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_344 : Uint256, pos_345 : Uint256) -> (end_346 : Uint256):
alloc_locals
let (local length_347 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(value_344.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local pos_1_348 : Uint256) = array_storeLengthForEncoding_array_bytes_dyn(pos_345, length_347)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _1_349 : Uint256 = Uint256(low=32, high=0)
let (local _2_350 : Uint256) = u256_add(value_344, _1_349)
local range_check_ptr = range_check_ptr
copy_memory_to_memory(_2_350, pos_1_348, length_347)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _3_351 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
local _4_352 : Uint256 = Uint256(low=31, high=0)
let (local _5_353 : Uint256) = u256_add(length_347, _4_352)
local range_check_ptr = range_check_ptr
let (local _6_354 : Uint256) = uint256_and(_5_353, _3_351)
local range_check_ptr = range_check_ptr
let (local end_346 : Uint256) = u256_add(pos_1_348, _6_354)
local range_check_ptr = range_check_ptr
return (end_346)
end

func abi_encode_struct_SwapCallbackData{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_358 : Uint256, pos_359 : Uint256) -> (end_360 : Uint256):
alloc_locals
let (local memberValue0 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(value_358.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _1_361 : Uint256 = Uint256(low=64, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_359.low, value=_1_361)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _2_362 : Uint256 = _1_361
let (local _3_363 : Uint256) = u256_add(pos_359, _1_361)
local range_check_ptr = range_check_ptr
let (local tail_364 : Uint256) = abi_encode_bytes(memberValue0, _3_363)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _4_365 : Uint256 = Uint256(low=32, high=0)
let (local _5_366 : Uint256) = u256_add(value_358, _4_365)
local range_check_ptr = range_check_ptr
let (local memberValue0_1 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_366.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _6_367 : Uint256 = _4_365
let (local _7_368 : Uint256) = u256_add(pos_359, _4_365)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(memberValue0_1, _7_368)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local end_360 : Uint256 = tail_364
return (end_360)
end

func abi_encode_struct_SwapCallbackData_memory_ptr{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_517 : Uint256, value0_518 : Uint256) -> (tail_519 : Uint256):
alloc_locals
local _1_520 : Uint256 = Uint256(low=32, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=headStart_517.low, value=_1_520)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _2_521 : Uint256 = _1_520
let (local _3_522 : Uint256) = u256_add(headStart_517, _1_520)
local range_check_ptr = range_check_ptr
let (local tail_519 : Uint256) = abi_encode_struct_SwapCallbackData(value0_518, _3_522)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (tail_519)
end

func abi_encode_bool{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_335 : Uint256, pos_336 : Uint256) -> ():
alloc_locals
let (local _1_337 : Uint256) = is_zero(value_335)
local range_check_ptr = range_check_ptr
let (local _2_338 : Uint256) = is_zero(_1_337)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_336.low, value=_2_338)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_address_bool_int256_uint160_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_480 : Uint256, value0_481 : Uint256, value1_482 : Uint256, value2_483 : Uint256, value3_484 : Uint256, value4_485 : Uint256) -> (tail_486 : Uint256):
alloc_locals
abi_encode_address_to_address(value0_481, headStart_480)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _1_487 : Uint256 = Uint256(low=32, high=0)
let (local _2_488 : Uint256) = u256_add(headStart_480, _1_487)
local range_check_ptr = range_check_ptr
abi_encode_bool(value1_482, _2_488)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _3_489 : Uint256 = Uint256(low=64, high=0)
let (local _4_490 : Uint256) = u256_add(headStart_480, _3_489)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value2_483, _4_490)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _5_491 : Uint256 = Uint256(low=96, high=0)
let (local _6_492 : Uint256) = u256_add(headStart_480, _5_491)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value3_484, _6_492)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _7_493 : Uint256 = Uint256(low=160, high=0)
local _8_494 : Uint256 = Uint256(low=128, high=0)
let (local _9_495 : Uint256) = u256_add(headStart_480, _8_494)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_9_495.low, value=_7_493)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _10_496 : Uint256 = _7_493
let (local _11_497 : Uint256) = u256_add(headStart_480, _7_493)
local range_check_ptr = range_check_ptr
let (local tail_486 : Uint256) = abi_encode_bytes(value4_485, _11_497)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (tail_486)
end

func abi_decode_int256t_int256_fromMemory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_211 : Uint256, dataEnd_212 : Uint256) -> (value0_213 : Uint256, value1_214 : Uint256):
alloc_locals
local _1_215 : Uint256 = Uint256(low=64, high=0)
let (local _2_216 : Uint256) = uint256_sub(dataEnd_212, headStart_211)
local range_check_ptr = range_check_ptr
let (local _3_217 : Uint256) = slt(_2_216, _1_215)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_217)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_213 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(headStart_211.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _4_218 : Uint256 = Uint256(low=32, high=0)
let (local _5_219 : Uint256) = u256_add(headStart_211, _4_218)
local range_check_ptr = range_check_ptr
let (local value1_214 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_219.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (value0_213, value1_214)
end

func negate_int256{exec_env: ExecutionEnvironment, range_check_ptr}(value_1511 : Uint256) -> (ret_1512 : Uint256):
alloc_locals
let (local _1_1513 : Uint256) = uint256_shl(Uint256(low=255, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1514 : Uint256) = is_eq(value_1511, _1_1513)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_1514)
local exec_env: ExecutionEnvironment = exec_env
local _3_1515 : Uint256 = Uint256(low=0, high=0)
let (local ret_1512 : Uint256) = uint256_sub(_3_1515, value_1511)
local range_check_ptr = range_check_ptr
return (ret_1512)
end

func __warp_if_2(_3_720 : Uint256, var_recipient : Uint256) -> (var_recipient : Uint256):
alloc_locals
if _3_720.low + _3_720.high != 0:
	let (local var_recipient : Uint256) = __warp_holder()
return (var_recipient)
else:
	return (var_recipient)
end
end

func __warp_block_7{exec_env: ExecutionEnvironment, range_check_ptr}() -> (expr_3 : Uint256):
alloc_locals
local _11_729 : Uint256 = Uint256(low=1, high=0)
local _12_730 : Uint256 = Uint256(low=318775800626314356294205765087544249638, high=4294805859)
let (local expr_3 : Uint256) = checked_sub_uint160(_12_730, _11_729)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
end

func __warp_block_8{exec_env: ExecutionEnvironment, range_check_ptr}() -> (expr_3 : Uint256):
alloc_locals
local _13_731 : Uint256 = Uint256(low=1, high=0)
local _14_732 : Uint256 = Uint256(low=4295128739, high=0)
let (local expr_3 : Uint256) = checked_add_uint160(_14_732, _13_731)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
end

func __warp_if_4{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (expr_3 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local expr_3 : Uint256) = __warp_block_7()
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
else:
	let (local expr_3 : Uint256) = __warp_block_8()
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
end
end

func __warp_block_6{exec_env: ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (expr_3 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_3 : Uint256) = __warp_if_4(__warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
end

func __warp_block_5{exec_env: ExecutionEnvironment, range_check_ptr}(expr_725 : Uint256) -> (expr_3 : Uint256):
alloc_locals
local match_var : Uint256 = expr_725
let (local expr_3 : Uint256) = __warp_block_6(match_var)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3)
end

func __warp_block_4{exec_env: ExecutionEnvironment, range_check_ptr}(expr_725 : Uint256) -> (expr_2 : Uint256):
alloc_locals
local expr_3 : Uint256 = Uint256(low=0, high=0)
let (local expr_3 : Uint256) = __warp_block_5(expr_725)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local expr_2 : Uint256 = expr_3
return (expr_2)
end

func __warp_if_3{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256, expr_725 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (expr_2 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	local expr_2 : Uint256 = var_sqrtPriceLimitX96
return (expr_2)
else:
	let (local expr_2 : Uint256) = __warp_block_4(expr_725)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_2)
end
end

func __warp_block_3{exec_env: ExecutionEnvironment, range_check_ptr}(expr_725 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (expr_2 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_2 : Uint256) = __warp_if_3(__warp_subexpr_0, expr_725, var_sqrtPriceLimitX96)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_2)
end

func __warp_block_2{exec_env: ExecutionEnvironment, range_check_ptr}(_10_728 : Uint256, expr_725 : Uint256, var_sqrtPriceLimitX96 : Uint256) -> (expr_2 : Uint256):
alloc_locals
local match_var : Uint256 = _10_728
let (local expr_2 : Uint256) = __warp_block_3(expr_725, match_var, var_sqrtPriceLimitX96)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_2)
end

func __warp_block_9{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_25_741 : Uint256) -> (expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
alloc_locals
let (local _36_752 : Uint256) = __warp_holder()
finalize_allocation(_25_741, _36_752)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _37_753 : Uint256) = __warp_holder()
let (local _38_754 : Uint256) = u256_add(_25_741, _37_753)
local range_check_ptr = range_check_ptr
let (local expr_component : Uint256, local expr_component_1 : Uint256) = abi_decode_int256t_int256_fromMemory(_25_741, _38_754)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_3034_component : Uint256 = expr_component
local expr_3034_component_1 : Uint256 = expr_component_1
return (expr_3034_component, expr_3034_component_1)
end

func __warp_if_5{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_25_741 : Uint256, _34_750 : Uint256, expr_3034_component : Uint256, expr_3034_component_1 : Uint256) -> (expr_3034_component : Uint256, expr_3034_component_1 : Uint256):
alloc_locals
if _34_750.low + _34_750.high != 0:
	let (local expr_3034_component : Uint256, local expr_3034_component_1 : Uint256) = __warp_block_9(_25_741)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_3034_component, expr_3034_component_1)
else:
	return (expr_3034_component, expr_3034_component_1)
end
end

func __warp_if_6(__warp_subexpr_0 : Uint256, expr_3034_component : Uint256, expr_3034_component_1 : Uint256) -> (expr_4 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	local expr_4 : Uint256 = expr_3034_component
return (expr_4)
else:
	local expr_4 : Uint256 = expr_3034_component_1
return (expr_4)
end
end

func __warp_block_11{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3034_component : Uint256, expr_3034_component_1 : Uint256, match_var : Uint256) -> (expr_4 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_4 : Uint256) = __warp_if_6(__warp_subexpr_0, expr_3034_component, expr_3034_component_1)
local exec_env: ExecutionEnvironment = exec_env
return (expr_4)
end

func __warp_block_10{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3034_component : Uint256, expr_3034_component_1 : Uint256, expr_725 : Uint256) -> (expr_4 : Uint256):
alloc_locals
local match_var : Uint256 = expr_725
let (local expr_4 : Uint256) = __warp_block_11(expr_3034_component, expr_3034_component_1, match_var)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_4)
end

func fun_exactInputInternal{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_amountIn : Uint256, var_recipient : Uint256, var_sqrtPriceLimitX96 : Uint256, var_data_2953_mpos : Uint256) -> (var_amountOut : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_718 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_719 : Uint256) = uint256_and(var_recipient, _1_718)
local range_check_ptr = range_check_ptr
let (local _3_720 : Uint256) = is_zero(_2_719)
local range_check_ptr = range_check_ptr
let (local var_recipient : Uint256) = __warp_if_2(_3_720, var_recipient)
local exec_env: ExecutionEnvironment = exec_env
setter_fun_balancePeople_2201(var_recipient, var_amountIn)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
local _4_721 : Uint256 = Uint256(low=21, high=0)
setter_fun_age(_4_721)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _5_722 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_data_2953_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_2991_component : Uint256, local expr_2991_component_1 : Uint256, local expr_2991_component_2 : Uint256) = fun_decodeFirstPool(_5_722)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _6_723 : Uint256) = uint256_and(expr_2991_component_1, _1_718)
local range_check_ptr = range_check_ptr
let (local _7_724 : Uint256) = uint256_and(expr_2991_component, _1_718)
local range_check_ptr = range_check_ptr
let (local expr_725 : Uint256) = is_lt(_7_724, _6_723)
local range_check_ptr = range_check_ptr
let (local _8_726 : Uint256) = fun_getPool(expr_2991_component, expr_2991_component_1, expr_2991_component_2)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
let (local expr_3008_address : Uint256) = cleanup_address(_8_726)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1 : Uint256) = fun_toInt256(var_amountIn)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local expr_2 : Uint256 = Uint256(low=0, high=0)
let (local _9_727 : Uint256) = uint256_and(var_sqrtPriceLimitX96, _1_718)
local range_check_ptr = range_check_ptr
let (local _10_728 : Uint256) = is_zero(_9_727)
local range_check_ptr = range_check_ptr
let (local expr_2 : Uint256) = __warp_block_2(_10_728, expr_725, var_sqrtPriceLimitX96)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _15_733 : Uint256 = Uint256(low=64, high=0)
let (local expr_3033_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_15_733.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _16_734 : Uint256 = Uint256(low=32, high=0)
let (local _17_735 : Uint256) = u256_add(expr_3033_mpos, _16_734)
local range_check_ptr = range_check_ptr
let (local _18_736 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(_17_735, var_data_2953_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _19_737 : Uint256) = uint256_sub(_18_736, expr_3033_mpos)
local range_check_ptr = range_check_ptr
let (local _20_738 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _21_739 : Uint256) = u256_add(_19_737, _20_738)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_3033_mpos.low, value=_21_739)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_3033_mpos, _19_737)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _24_740 : Uint256 = _15_733
let (local _25_741 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_15_733.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _26_742 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1884727471, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_25_741.low, value=_26_742)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _27_743 : Uint256 = _15_733
local _28_744 : Uint256 = Uint256(low=4, high=0)
let (local _29_745 : Uint256) = u256_add(_25_741, _28_744)
local range_check_ptr = range_check_ptr
let (local _30_746 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(_29_745, var_recipient, expr_725, expr_1, expr_2, expr_3033_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _31_747 : Uint256) = uint256_sub(_30_746, _25_741)
local range_check_ptr = range_check_ptr
local _32_748 : Uint256 = Uint256(low=0, high=0)
let (local _33_749 : Uint256) = __warp_holder()
let (local _34_750 : Uint256) = __warp_holder()
let (local _35_751 : Uint256) = is_zero(_34_750)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_35_751)
local exec_env: ExecutionEnvironment = exec_env
local expr_3034_component : Uint256 = _32_748
local expr_3034_component_1 : Uint256 = _32_748
let (local expr_3034_component : Uint256, local expr_3034_component_1 : Uint256) = __warp_if_5(_25_741, _34_750, expr_3034_component, expr_3034_component_1)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_4 : Uint256 = _32_748
let (local expr_4 : Uint256) = __warp_block_10(expr_3034_component, expr_3034_component_1, expr_725)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _39_755 : Uint256) = negate_int256(expr_4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local var_amountOut : Uint256) = cleanup_bytes32(_39_755)
local exec_env: ExecutionEnvironment = exec_env
return (var_amountOut)
end

func fun_exactInputSingle_dynArgs_inner{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset : Uint256) -> (var_amountOut_757 : Uint256):
alloc_locals
local _1_758 : Uint256 = Uint256(low=96, high=0)
let (local _2_759 : Uint256) = u256_add(var_params_offset, _1_758)
local range_check_ptr = range_check_ptr
let (local expr_760 : Uint256) = read_from_calldatat_address(_2_759)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _3_761 : Uint256 = Uint256(low=224, high=0)
let (local _4_762 : Uint256) = u256_add(var_params_offset, _3_761)
local range_check_ptr = range_check_ptr
let (local expr_1_763 : Uint256) = read_from_calldatat_address(_4_762)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_2_764 : Uint256) = read_from_calldatat_address(var_params_offset)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _5_765 : Uint256 = Uint256(low=64, high=0)
let (local _6_766 : Uint256) = u256_add(var_params_offset, _5_765)
local range_check_ptr = range_check_ptr
let (local expr_3_767 : Uint256) = read_from_calldatat_uint24(_6_766)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _7_768 : Uint256 = Uint256(low=32, high=0)
let (local _8_769 : Uint256) = u256_add(var_params_offset, _7_768)
local range_check_ptr = range_check_ptr
let (local expr_4_770 : Uint256) = read_from_calldatat_address(_8_769)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _9_771 : Uint256 = _5_765
let (local expr_3077_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_765.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _10_772 : Uint256 = _7_768
let (local _11_773 : Uint256) = u256_add(expr_3077_mpos, _7_768)
local range_check_ptr = range_check_ptr
let (local _12_774 : Uint256) = abi_encode_packed_address_uint24_address(_11_773, expr_2_764, expr_3_767, expr_4_770)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _13_775 : Uint256) = uint256_sub(_12_774, expr_3077_mpos)
local range_check_ptr = range_check_ptr
let (local _14_776 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _15_777 : Uint256) = u256_add(_13_775, _14_776)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_3077_mpos.low, value=_15_777)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_3077_mpos, _13_775)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _16_778 : Uint256 = _5_765
let (local expr_3080_mpos : Uint256) = allocate_memory(_5_765)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
write_to_memory_bytes(expr_3080_mpos, expr_3077_mpos)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
let (local _17_779 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _18_780 : Uint256 = _7_768
let (local _19_781 : Uint256) = u256_add(expr_3080_mpos, _7_768)
local range_check_ptr = range_check_ptr
write_to_memory_address(_19_781, _17_779)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _20_782 : Uint256 = Uint256(low=160, high=0)
let (local _21_783 : Uint256) = u256_add(var_params_offset, _20_782)
local range_check_ptr = range_check_ptr
let (local _22_784 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_21_783.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local var_amountOut_757 : Uint256) = fun_exactInputInternal(_22_784, expr_760, expr_1_763, expr_3080_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local _23_785 : Uint256 = Uint256(low=192, high=0)
let (local _24_786 : Uint256) = u256_add(var_params_offset, _23_785)
local range_check_ptr = range_check_ptr
let (local _25_787 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_24_786.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _26_788 : Uint256) = is_lt(var_amountOut_757, _25_787)
local range_check_ptr = range_check_ptr
let (local _27_789 : Uint256) = is_zero(_26_788)
local range_check_ptr = range_check_ptr
require_helper(_27_789)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_amountOut_757)
end

func modifier_checkDeadline_3056{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_1477 : Uint256) -> (_1_1478 : Uint256):
alloc_locals
local _2_1479 : Uint256 = Uint256(low=128, high=0)
let (local _3_1480 : Uint256) = u256_add(var_params_offset_1477, _2_1479)
local range_check_ptr = range_check_ptr
let (local _4_1481 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_3_1480.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _5_1482 : Uint256) = __warp_holder()
let (local _6_1483 : Uint256) = is_gt(_5_1482, _4_1481)
local range_check_ptr = range_check_ptr
let (local _7_1484 : Uint256) = is_zero(_6_1483)
local range_check_ptr = range_check_ptr
require_helper(_7_1484)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _1_1478 : Uint256) = fun_exactInputSingle_dynArgs_inner(var_params_offset_1477)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (_1_1478)
end

func fun_exactInputSingle_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_3050_offset : Uint256) -> (var_amountOut_756 : Uint256):
alloc_locals
let (local var_amountOut_756 : Uint256) = modifier_checkDeadline_3056(var_params_3050_offset)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (var_amountOut_756)
end

func abi_encode_uint256{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_523 : Uint256, value0_524 : Uint256) -> (tail_525 : Uint256):
alloc_locals
local _1_526 : Uint256 = Uint256(low=32, high=0)
let (local tail_525 : Uint256) = u256_add(headStart_523, _1_526)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value0_524, headStart_523)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
return (tail_525)
end

func __warp_if_7(__warp_subexpr_1 : Uint256, var_recipient_821 : Uint256) -> (var_recipient_821 : Uint256):
alloc_locals
if __warp_subexpr_1.low + __warp_subexpr_1.high != 0:
	let (local var_recipient_821 : Uint256) = __warp_holder()
return (var_recipient_821)
else:
	return (var_recipient_821)
end
end

func __warp_if_9{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (expr_4_833 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local expr_4_833 : Uint256) = checked_sub_uint160(Uint256(low=318775800626314356294205765087544249638, high=4294805859), Uint256(low=1, high=0))
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_4_833)
else:
	let (local expr_4_833 : Uint256) = checked_add_uint160(Uint256(low=4295128739, high=0), Uint256(low=1, high=0))
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_4_833)
end
end

func __warp_block_16{exec_env: ExecutionEnvironment, range_check_ptr}(match_var : Uint256) -> (expr_4_833 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_4_833 : Uint256) = __warp_if_9(__warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_4_833)
end

func __warp_block_15{exec_env: ExecutionEnvironment, range_check_ptr}(expr_827 : Uint256) -> (expr_4_833 : Uint256):
alloc_locals
local match_var : Uint256 = expr_827
let (local expr_4_833 : Uint256) = __warp_block_16(match_var)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_4_833)
end

func __warp_block_14{exec_env: ExecutionEnvironment, range_check_ptr}(expr_827 : Uint256) -> (expr_3_832 : Uint256):
alloc_locals
local expr_4_833 : Uint256 = Uint256(low=0, high=0)
let (local expr_4_833 : Uint256) = __warp_block_15(expr_827)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local expr_3_832 : Uint256 = expr_4_833
return (expr_3_832)
end

func __warp_if_8{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256, expr_827 : Uint256, var_sqrtPriceLimitX96_822 : Uint256) -> (expr_3_832 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	local expr_3_832 : Uint256 = var_sqrtPriceLimitX96_822
return (expr_3_832)
else:
	let (local expr_3_832 : Uint256) = __warp_block_14(expr_827)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3_832)
end
end

func __warp_block_13{exec_env: ExecutionEnvironment, range_check_ptr}(expr_827 : Uint256, match_var : Uint256, var_sqrtPriceLimitX96_822 : Uint256) -> (expr_3_832 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_3_832 : Uint256) = __warp_if_8(__warp_subexpr_0, expr_827, var_sqrtPriceLimitX96_822)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3_832)
end

func __warp_block_12{exec_env: ExecutionEnvironment, range_check_ptr}(expr_2_831 : Uint256, expr_827 : Uint256, var_sqrtPriceLimitX96_822 : Uint256) -> (expr_3_832 : Uint256):
alloc_locals
local match_var : Uint256 = expr_2_831
let (local expr_3_832 : Uint256) = __warp_block_13(expr_827, match_var, var_sqrtPriceLimitX96_822)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3_832)
end

func __warp_block_17{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_8_837 : Uint256) -> (expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
alloc_locals
let (local _12_841 : Uint256) = __warp_holder()
finalize_allocation(_8_837, _12_841)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _13_842 : Uint256) = __warp_holder()
let (local __warp_subexpr_0 : Uint256) = u256_add(_8_837, _13_842)
local range_check_ptr = range_check_ptr
let (local expr_component_1_843 : Uint256, local expr_component_2 : Uint256) = abi_decode_int256t_int256_fromMemory(_8_837, __warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_3260_component : Uint256 = expr_component_1_843
local expr_3260_component_1 : Uint256 = expr_component_2
return (expr_3260_component, expr_3260_component_1)
end

func __warp_if_10{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_11_840 : Uint256, _8_837 : Uint256, expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (expr_3260_component : Uint256, expr_3260_component_1 : Uint256):
alloc_locals
if _11_840.low + _11_840.high != 0:
	let (local expr_3260_component : Uint256, local expr_3260_component_1 : Uint256) = __warp_block_17(_8_837)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_3260_component, expr_3260_component_1)
else:
	return (expr_3260_component, expr_3260_component_1)
end
end

func __warp_block_20{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (expr_3289_component : Uint256, expr_component_3 : Uint256):
alloc_locals
let (local _14_844 : Uint256) = negate_int256(expr_3260_component)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_5 : Uint256) = cleanup_bytes32(_14_844)
local exec_env: ExecutionEnvironment = exec_env
local expr_3289_component : Uint256 = expr_3260_component_1
local expr_component_3 : Uint256 = expr_5
return (expr_3289_component, expr_component_3)
end

func __warp_block_21{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (expr_3289_component : Uint256, expr_component_3 : Uint256):
alloc_locals
let (local _15_845 : Uint256) = negate_int256(expr_3260_component_1)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_6 : Uint256) = cleanup_bytes32(_15_845)
local exec_env: ExecutionEnvironment = exec_env
local expr_3289_component : Uint256 = expr_3260_component
local expr_component_3 : Uint256 = expr_6
return (expr_3289_component, expr_component_3)
end

func __warp_if_11{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256, expr_3260_component : Uint256, expr_3260_component_1 : Uint256) -> (expr_3289_component : Uint256, expr_component_3 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_20(expr_3260_component, expr_3260_component_1)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3289_component, expr_component_3)
else:
	let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_21(expr_3260_component, expr_3260_component_1)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3289_component, expr_component_3)
end
end

func __warp_block_19{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3260_component : Uint256, expr_3260_component_1 : Uint256, match_var : Uint256) -> (expr_3289_component : Uint256, expr_component_3 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_if_11(__warp_subexpr_0, expr_3260_component, expr_3260_component_1)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3289_component, expr_component_3)
end

func __warp_block_18{exec_env: ExecutionEnvironment, range_check_ptr}(expr_3260_component : Uint256, expr_3260_component_1 : Uint256, expr_827 : Uint256) -> (expr_3289_component : Uint256, expr_component_3 : Uint256):
alloc_locals
local match_var : Uint256 = expr_827
let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_19(expr_3260_component, expr_3260_component_1, match_var)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_3289_component, expr_component_3)
end

func __warp_block_22{exec_env: ExecutionEnvironment, range_check_ptr}(expr_component_3 : Uint256, var_amountOut_820 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(expr_component_3, var_amountOut_820)
local range_check_ptr = range_check_ptr
require_helper(__warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_12{exec_env: ExecutionEnvironment, range_check_ptr}(expr_2_831 : Uint256, expr_component_3 : Uint256, var_amountOut_820 : Uint256) -> ():
alloc_locals
if expr_2_831.low + expr_2_831.high != 0:
	__warp_block_22(expr_component_3, var_amountOut_820)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func fun_exactOutputInternal{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_amountOut_820 : Uint256, var_recipient_821 : Uint256, var_sqrtPriceLimitX96_822 : Uint256, var_data_mpos : Uint256) -> (var_amountIn_823 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_824 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_2 : Uint256) = uint256_and(var_recipient_821, _1_824)
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_1 : Uint256) = is_zero(__warp_subexpr_2)
local range_check_ptr = range_check_ptr
let (local var_recipient_821 : Uint256) = __warp_if_7(__warp_subexpr_1, var_recipient_821)
local exec_env: ExecutionEnvironment = exec_env
let (local _2_825 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_data_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_3216_component : Uint256, local expr_3216_component_1 : Uint256, local expr_component_826 : Uint256) = fun_decodeFirstPool(_2_825)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_4 : Uint256) = uint256_and(expr_3216_component, _1_824)
local range_check_ptr = range_check_ptr
let (local expr_827 : Uint256) = is_lt(__warp_subexpr_3, __warp_subexpr_4)
local range_check_ptr = range_check_ptr
let (local _3_828 : Uint256) = fun_getPool(expr_3216_component_1, expr_3216_component, expr_component_826)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
let (local expr_3233_address : Uint256) = cleanup_address(_3_828)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _4_829 : Uint256) = fun_toInt256(var_amountOut_820)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_1_830 : Uint256) = negate_int256(_4_829)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_5 : Uint256) = uint256_and(var_sqrtPriceLimitX96_822, _1_824)
local range_check_ptr = range_check_ptr
let (local expr_2_831 : Uint256) = is_zero(__warp_subexpr_5)
local range_check_ptr = range_check_ptr
local expr_3_832 : Uint256 = Uint256(low=0, high=0)
let (local expr_3_832 : Uint256) = __warp_block_12(expr_2_831, expr_827, var_sqrtPriceLimitX96_822)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_3259_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(Uint256(low=64.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local __warp_subexpr_6 : Uint256) = u256_add(expr_3259_mpos, Uint256(low=32, high=0))
local range_check_ptr = range_check_ptr
let (local _5_834 : Uint256) = abi_encode_struct_SwapCallbackData_memory_ptr(__warp_subexpr_6, var_data_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _6_835 : Uint256) = uint256_sub(_5_834, expr_3259_mpos)
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_8 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_7 : Uint256) = u256_add(_6_835, __warp_subexpr_8)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_3259_mpos.low, value=__warp_subexpr_7)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_3259_mpos, _6_835)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _7_836 : Uint256) = __warp_holder()
let (local __warp_subexpr_9 : Uint256) = is_zero(_7_836)
local range_check_ptr = range_check_ptr
__warp_cond_revert(__warp_subexpr_9)
local exec_env: ExecutionEnvironment = exec_env
let (local _8_837 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(Uint256(low=64.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local __warp_subexpr_10 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1884727471, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_8_837.low, value=__warp_subexpr_10)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local __warp_subexpr_11 : Uint256) = u256_add(_8_837, Uint256(low=4, high=0))
local range_check_ptr = range_check_ptr
let (local _9_838 : Uint256) = abi_encode_address_bool_int256_uint160_bytes(__warp_subexpr_11, var_recipient_821, expr_827, expr_1_830, expr_3_832, expr_3259_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _10_839 : Uint256) = __warp_holder()
let (local __warp_subexpr_12 : Uint256) = uint256_sub(_9_838, _8_837)
local range_check_ptr = range_check_ptr
let (local _11_840 : Uint256) = __warp_holder()
let (local __warp_subexpr_13 : Uint256) = is_zero(_11_840)
local range_check_ptr = range_check_ptr
__warp_cond_revert(__warp_subexpr_13)
local exec_env: ExecutionEnvironment = exec_env
local expr_3260_component : Uint256 = Uint256(low=0, high=0)
local expr_3260_component_1 : Uint256 = expr_3260_component
let (local expr_3260_component : Uint256, local expr_3260_component_1 : Uint256) = __warp_if_10(_11_840, _8_837, expr_3260_component, expr_3260_component_1)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_3289_component : Uint256 = Uint256(low=0, high=0)
local expr_component_3 : Uint256 = expr_3289_component
let (local expr_3289_component : Uint256, local expr_component_3 : Uint256) = __warp_block_18(expr_3260_component, expr_3260_component_1, expr_827)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local var_amountIn_823 : Uint256 = expr_3289_component
__warp_if_12(expr_2_831, expr_component_3, var_amountOut_820)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_amountIn_823)
end

func setter_fun_amountInCached{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1570 : Uint256) -> ():
alloc_locals
amountInCached.write(value_1570)
return ()
end

func fun_exactOutputSingle_dynArgs_inner{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_847 : Uint256) -> (var_amountIn_848 : Uint256):
alloc_locals
local _1_849 : Uint256 = Uint256(low=96, high=0)
let (local _2_850 : Uint256) = u256_add(var_params_offset_847, _1_849)
local range_check_ptr = range_check_ptr
let (local expr_851 : Uint256) = read_from_calldatat_address(_2_850)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _3_852 : Uint256 = Uint256(low=224, high=0)
let (local _4_853 : Uint256) = u256_add(var_params_offset_847, _3_852)
local range_check_ptr = range_check_ptr
let (local expr_1_854 : Uint256) = read_from_calldatat_address(_4_853)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _5_855 : Uint256 = Uint256(low=32, high=0)
let (local _6_856 : Uint256) = u256_add(var_params_offset_847, _5_855)
local range_check_ptr = range_check_ptr
let (local expr_2_857 : Uint256) = read_from_calldatat_address(_6_856)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _7_858 : Uint256 = Uint256(low=64, high=0)
let (local _8_859 : Uint256) = u256_add(var_params_offset_847, _7_858)
local range_check_ptr = range_check_ptr
let (local expr_3_860 : Uint256) = read_from_calldatat_uint24(_8_859)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_4_861 : Uint256) = read_from_calldatat_address(var_params_offset_847)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _9_862 : Uint256 = _7_858
let (local expr_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_7_858.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _10_863 : Uint256 = _5_855
let (local _11_864 : Uint256) = u256_add(expr_mpos, _5_855)
local range_check_ptr = range_check_ptr
let (local _12_865 : Uint256) = abi_encode_packed_address_uint24_address(_11_864, expr_2_857, expr_3_860, expr_4_861)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _13_866 : Uint256) = uint256_sub(_12_865, expr_mpos)
local range_check_ptr = range_check_ptr
let (local _14_867 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _15_868 : Uint256) = u256_add(_13_866, _14_867)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_mpos.low, value=_15_868)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_mpos, _13_866)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _16_869 : Uint256 = _7_858
let (local expr_3336_mpos : Uint256) = allocate_memory(_7_858)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
write_to_memory_bytes(expr_3336_mpos, expr_mpos)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
let (local _17_870 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _18_871 : Uint256 = _5_855
let (local _19_872 : Uint256) = u256_add(expr_3336_mpos, _5_855)
local range_check_ptr = range_check_ptr
write_to_memory_address(_19_872, _17_870)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _20_873 : Uint256 = Uint256(low=160, high=0)
let (local _21_874 : Uint256) = u256_add(var_params_offset_847, _20_873)
local range_check_ptr = range_check_ptr
let (local _22_875 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_21_874.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local var_amountIn_848 : Uint256) = fun_exactOutputInternal(_22_875, expr_851, expr_1_854, expr_3336_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local _23_876 : Uint256 = Uint256(low=192, high=0)
let (local _24_877 : Uint256) = u256_add(var_params_offset_847, _23_876)
local range_check_ptr = range_check_ptr
let (local _25_878 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_24_877.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _26_879 : Uint256) = is_gt(var_amountIn_848, _25_878)
local range_check_ptr = range_check_ptr
let (local _27_880 : Uint256) = is_zero(_26_879)
local range_check_ptr = range_check_ptr
require_helper(_27_880)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _28_881 : Uint256) = uint256_not(Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
setter_fun_amountInCached(_28_881)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
return (var_amountIn_848)
end

func modifier_checkDeadline_3312{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_1495 : Uint256) -> (_1_1496 : Uint256):
alloc_locals
local _2_1497 : Uint256 = Uint256(low=128, high=0)
let (local _3_1498 : Uint256) = u256_add(var_params_offset_1495, _2_1497)
local range_check_ptr = range_check_ptr
let (local _4_1499 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_3_1498.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _5_1500 : Uint256) = __warp_holder()
let (local _6_1501 : Uint256) = is_gt(_5_1500, _4_1499)
local range_check_ptr = range_check_ptr
let (local _7_1502 : Uint256) = is_zero(_6_1501)
local range_check_ptr = range_check_ptr
require_helper(_7_1502)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _1_1496 : Uint256) = fun_exactOutputSingle_dynArgs_inner(var_params_offset_1495)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (_1_1496)
end

func fun_exactOutputSingle_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_3306_offset : Uint256) -> (var_amountIn_846 : Uint256):
alloc_locals
let (local var_amountIn_846 : Uint256) = modifier_checkDeadline_3312(var_params_3306_offset)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (var_amountIn_846)
end

func abi_decode{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_130 : Uint256, dataEnd : Uint256) -> ():
alloc_locals
local _1_131 : Uint256 = Uint256(low=0, high=0)
let (local _2_132 : Uint256) = uint256_sub(dataEnd, headStart_130)
local range_check_ptr = range_check_ptr
let (local _3_133 : Uint256) = slt(_2_132, _1_131)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_133)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func array_allocation_size_bytes{exec_env: ExecutionEnvironment, range_check_ptr}(length_577 : Uint256) -> (size_578 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_579 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_580 : Uint256) = is_gt(length_577, _1_579)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_580)
local exec_env: ExecutionEnvironment = exec_env
local _3_581 : Uint256 = Uint256(low=32, high=0)
let (local _4_582 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
local _5_583 : Uint256 = Uint256(low=31, high=0)
let (local _6_584 : Uint256) = u256_add(length_577, _5_583)
local range_check_ptr = range_check_ptr
let (local _7_585 : Uint256) = uint256_and(_6_584, _4_582)
local range_check_ptr = range_check_ptr
let (local size_578 : Uint256) = u256_add(_7_585, _3_581)
local range_check_ptr = range_check_ptr
return (size_578)
end

func allocate_memory_array_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(length_567 : Uint256) -> (memPtr_568 : Uint256):
alloc_locals
let (local _1_569 : Uint256) = array_allocation_size_bytes(length_567)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local memPtr_568 : Uint256) = allocate_memory(_1_569)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_568.low, value=length_567)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (memPtr_568)
end

func zero_memory_chunk_bytes1{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dataStart_1635 : Uint256, dataSizeInBytes_1636 : Uint256) -> ():
alloc_locals
local _1_1637 : Uint256 = Uint256(exec_env.calldata_size, 0)
local range_check_ptr = range_check_ptr
calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(dataStart_1635, _1_1637, dataSizeInBytes_1636)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func allocate_and_zero_memory_array_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(length_546 : Uint256) -> (memPtr_547 : Uint256):
alloc_locals
let (local memPtr_547 : Uint256) = allocate_memory_array_bytes(length_546)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _1_548 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _2_549 : Uint256) = array_allocation_size_bytes(length_546)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _3_550 : Uint256) = u256_add(_2_549, _1_548)
local range_check_ptr = range_check_ptr
local _4_551 : Uint256 = Uint256(low=32, high=0)
let (local _5_552 : Uint256) = u256_add(memPtr_547, _4_551)
local range_check_ptr = range_check_ptr
zero_memory_chunk_bytes1(_5_552, _3_550)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (memPtr_547)
end

func __warp_block_25{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
alloc_locals
let (local _2_660 : Uint256) = __warp_holder()
let (local data : Uint256) = allocate_memory_array_bytes(_2_660)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _3_661 : Uint256) = __warp_holder()
local _4_662 : Uint256 = Uint256(low=0, high=0)
local _5_663 : Uint256 = Uint256(low=32, high=0)
let (local _6_664 : Uint256) = u256_add(data, _5_663)
local range_check_ptr = range_check_ptr
__warp_holder()
return (data)
end

func __warp_if_13{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(__warp_subexpr_0 : Uint256) -> (data : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	local data : Uint256 = Uint256(low=96, high=0)
return (data)
else:
	let (local data : Uint256) = __warp_block_25()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (data)
end
end

func __warp_block_24{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(match_var : Uint256) -> (data : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local data : Uint256) = __warp_if_13(__warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (data)
end

func __warp_block_23{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_659 : Uint256) -> (data : Uint256):
alloc_locals
local match_var : Uint256 = _1_659
let (local data : Uint256) = __warp_block_24(match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (data)
end

func extract_returndata{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}() -> (data : Uint256):
alloc_locals
let (local _1_659 : Uint256) = __warp_holder()
let (local data : Uint256) = __warp_block_23(_1_659)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (data)
end

func fun_safeTransferETH{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_to : Uint256, var_value_1013 : Uint256) -> ():
alloc_locals
local _1_1014 : Uint256 = Uint256(low=0, high=0)
let (local expr_1562_mpos : Uint256) = allocate_and_zero_memory_array_bytes(_1_1014)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _2_1015 : Uint256 = _1_1014
local _3_1016 : Uint256 = _1_1014
let (local _4_1017 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1562_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _5_1018 : Uint256 = Uint256(low=32, high=0)
let (local _6_1019 : Uint256) = u256_add(expr_1562_mpos, _5_1018)
local range_check_ptr = range_check_ptr
let (local _7_1020 : Uint256) = __warp_holder()
let (local expr_component_1021 : Uint256) = __warp_holder()
let (local _8_1022 : Uint256) = extract_returndata()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
__warp_holder()
require_helper(expr_component_1021)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_26{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}() -> ():
alloc_locals
let (local _4_1011 : Uint256) = __warp_holder()
let (local _5_1012 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
fun_safeTransferETH(_5_1012, _4_1011)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_14{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_3_1010 : Uint256) -> ():
alloc_locals
if _3_1010.low + _3_1010.high != 0:
	__warp_block_26()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	return ()
end
end

func fun_refundETH{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}() -> ():
alloc_locals
let (local _1_1008 : Uint256) = __warp_holder()
let (local _2_1009 : Uint256) = is_zero(_1_1008)
local range_check_ptr = range_check_ptr
let (local _3_1010 : Uint256) = is_zero(_2_1009)
local range_check_ptr = range_check_ptr
__warp_if_14(_3_1010)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func getter_fun_succinctly{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1461 : Uint256):
alloc_locals
let (res) = succinctly.read()
return (res)
end

func abi_encode_address{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_404 : Uint256, value0_405 : Uint256) -> (tail_406 : Uint256):
alloc_locals
local _1_407 : Uint256 = Uint256(low=32, high=0)
let (local tail_406 : Uint256) = u256_add(headStart_404, _1_407)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_405, headStart_404)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (tail_406)
end

func getter_fun_age{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1453 : Uint256):
alloc_locals
let (res) = age.read()
return (res)
end

func getter_fun_OCaml{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1449 : Uint256):
alloc_locals
let (res) = OCaml.read()
return (res)
end

func abi_decode_address{exec_env: ExecutionEnvironment, range_check_ptr}(offset : Uint256) -> (value : Uint256):
alloc_locals
let (local value : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(offset.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
validator_revert_address(value)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value)
end

func validator_revert_uint8{exec_env: ExecutionEnvironment, range_check_ptr}(value_1614 : Uint256) -> ():
alloc_locals
local _1_1615 : Uint256 = Uint256(low=255, high=0)
let (local _2_1616 : Uint256) = uint256_and(value_1614, _1_1615)
local range_check_ptr = range_check_ptr
let (local _3_1617 : Uint256) = is_eq(value_1614, _2_1616)
local range_check_ptr = range_check_ptr
let (local _4_1618 : Uint256) = is_zero(_3_1617)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_1618)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func abi_decode_uint8{exec_env: ExecutionEnvironment, range_check_ptr}(offset_128 : Uint256) -> (value_129 : Uint256):
alloc_locals
let (local value_129 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_128.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
validator_revert_uint8(value_129)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value_129)
end

func abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_174 : Uint256, dataEnd_175 : Uint256) -> (value0_176 : Uint256, value1_177 : Uint256, value2_178 : Uint256, value3_179 : Uint256, value4_180 : Uint256, value5 : Uint256):
alloc_locals
local _1_181 : Uint256 = Uint256(low=192, high=0)
let (local _2_182 : Uint256) = uint256_sub(dataEnd_175, headStart_174)
local range_check_ptr = range_check_ptr
let (local _3_183 : Uint256) = slt(_2_182, _1_181)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_183)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_176 : Uint256) = abi_decode_address(headStart_174)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_184 : Uint256 = Uint256(low=32, high=0)
let (local _5_185 : Uint256) = u256_add(headStart_174, _4_184)
local range_check_ptr = range_check_ptr
let (local value1_177 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_185.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_186 : Uint256 = Uint256(low=64, high=0)
let (local _7_187 : Uint256) = u256_add(headStart_174, _6_186)
local range_check_ptr = range_check_ptr
let (local value2_178 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_7_187.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _8_188 : Uint256 = Uint256(low=96, high=0)
let (local _9_189 : Uint256) = u256_add(headStart_174, _8_188)
local range_check_ptr = range_check_ptr
let (local value3_179 : Uint256) = abi_decode_uint8(_9_189)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _10_190 : Uint256 = Uint256(low=128, high=0)
let (local _11_191 : Uint256) = u256_add(headStart_174, _10_190)
local range_check_ptr = range_check_ptr
let (local value4_180 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_11_191.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _12_192 : Uint256 = Uint256(low=160, high=0)
let (local _13_193 : Uint256) = u256_add(headStart_174, _12_192)
local range_check_ptr = range_check_ptr
let (local value5 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_13_193.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_176, value1_177, value2_178, value3_179, value4_180, value5)
end

func abi_encode_uint8{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_379 : Uint256, pos_380 : Uint256) -> ():
alloc_locals
local _1_381 : Uint256 = Uint256(low=255, high=0)
let (local _2_382 : Uint256) = uint256_and(value_379, _1_381)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_380.low, value=_2_382)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_435 : Uint256, value0_436 : Uint256, value1_437 : Uint256, value2_438 : Uint256, value3_439 : Uint256, value4_440 : Uint256, value5_441 : Uint256, value6 : Uint256, value7 : Uint256) -> (tail_442 : Uint256):
alloc_locals
local _1_443 : Uint256 = Uint256(low=256, high=0)
let (local tail_442 : Uint256) = u256_add(headStart_435, _1_443)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_436, headStart_435)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_444 : Uint256 = Uint256(low=32, high=0)
let (local _3_445 : Uint256) = u256_add(headStart_435, _2_444)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value1_437, _3_445)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _4_446 : Uint256 = Uint256(low=64, high=0)
let (local _5_447 : Uint256) = u256_add(headStart_435, _4_446)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value2_438, _5_447)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _6_448 : Uint256 = Uint256(low=96, high=0)
let (local _7_449 : Uint256) = u256_add(headStart_435, _6_448)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value3_439, _7_449)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _8_450 : Uint256 = Uint256(low=128, high=0)
let (local _9_451 : Uint256) = u256_add(headStart_435, _8_450)
local range_check_ptr = range_check_ptr
abi_encode_bool(value4_440, _9_451)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _10_452 : Uint256 = Uint256(low=160, high=0)
let (local _11_453 : Uint256) = u256_add(headStart_435, _10_452)
local range_check_ptr = range_check_ptr
abi_encode_uint8(value5_441, _11_453)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _12_454 : Uint256 = Uint256(low=192, high=0)
let (local _13_455 : Uint256) = u256_add(headStart_435, _12_454)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value6, _13_455)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _14_456 : Uint256 = Uint256(low=224, high=0)
let (local _15_457 : Uint256) = u256_add(headStart_435, _14_456)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value7, _15_457)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
return (tail_442)
end

func __warp_block_27{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1108 : Uint256) -> ():
alloc_locals
let (local _20_1122 : Uint256) = __warp_holder()
finalize_allocation(_6_1108, _20_1122)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _21_1123 : Uint256) = __warp_holder()
let (local _22_1124 : Uint256) = u256_add(_6_1108, _21_1123)
local range_check_ptr = range_check_ptr
abi_decode(_6_1108, _22_1124)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_15{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_18_1120 : Uint256, _6_1108 : Uint256) -> ():
alloc_locals
if _18_1120.low + _18_1120.high != 0:
	__warp_block_27(_6_1108)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func fun_selfPermitAllowed{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_token_1099 : Uint256, var_nonce_1100 : Uint256, var_expiry_1101 : Uint256, var_v_1102 : Uint256, var_r_1103 : Uint256, var_s_1104 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1105 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1106 : Uint256) = uint256_and(var_token_1099, _1_1105)
local range_check_ptr = range_check_ptr
local _5_1107 : Uint256 = Uint256(low=64, high=0)
let (local _6_1108 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1107.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1109 : Uint256) = uint256_shl(Uint256(low=226, high=0), Uint256(low=603122627, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1108.low, value=_7_1109)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1110 : Uint256 = Uint256(low=0, high=0)
local _9_1111 : Uint256 = Uint256(low=1, high=0)
let (local _10_1112 : Uint256) = __warp_holder()
let (local _11_1113 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _12_1114 : Uint256 = Uint256(low=4, high=0)
let (local _13_1115 : Uint256) = u256_add(_6_1108, _12_1114)
local range_check_ptr = range_check_ptr
let (local _14_1116 : Uint256) = abi_encode_address_address_uint256_uint256_bool_uint8_bytes32_bytes32(_13_1115, _11_1113, _10_1112, var_nonce_1100, var_expiry_1101, _9_1111, var_v_1102, var_r_1103, var_s_1104)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _15_1117 : Uint256) = uint256_sub(_14_1116, _6_1108)
local range_check_ptr = range_check_ptr
local _16_1118 : Uint256 = _8_1110
let (local _17_1119 : Uint256) = __warp_holder()
let (local _18_1120 : Uint256) = __warp_holder()
let (local _19_1121 : Uint256) = is_zero(_18_1120)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_19_1121)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_15(_18_1120, _6_1108)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func abi_decode_struct_ExactOutputParams_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(offset_105 : Uint256, end_106 : Uint256) -> (value_107 : Uint256):
alloc_locals
local _1_108 : Uint256 = Uint256(low=160, high=0)
let (local _2_109 : Uint256) = uint256_sub(end_106, offset_105)
local range_check_ptr = range_check_ptr
let (local _3_110 : Uint256) = slt(_2_109, _1_108)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_110)
local exec_env: ExecutionEnvironment = exec_env
local value_107 : Uint256 = offset_105
return (value_107)
end

func abi_decode_struct_ExactOutputParams_calldata_ptr{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_263 : Uint256, dataEnd_264 : Uint256) -> (value0_265 : Uint256):
alloc_locals
local _1_266 : Uint256 = Uint256(low=32, high=0)
let (local _2_267 : Uint256) = uint256_sub(dataEnd_264, headStart_263)
local range_check_ptr = range_check_ptr
let (local _3_268 : Uint256) = slt(_2_267, _1_266)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_268)
local exec_env: ExecutionEnvironment = exec_env
let (local offset_269 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_263.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_270 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_271 : Uint256) = is_gt(offset_269, _4_270)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_5_271)
local exec_env: ExecutionEnvironment = exec_env
let (local _6_272 : Uint256) = u256_add(headStart_263, offset_269)
local range_check_ptr = range_check_ptr
let (local value0_265 : Uint256) = abi_decode_struct_ExactOutputParams_calldata(_6_272, dataEnd_264)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_265)
end

func access_calldata_tail_bytes_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(base_ref : Uint256, ptr_to_tail : Uint256) -> (addr : Uint256, length_527 : Uint256):
alloc_locals
let (local rel_offset_of_tail : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(ptr_to_tail.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _1_528 : Uint256) = uint256_not(Uint256(low=30, high=0))
local range_check_ptr = range_check_ptr
local _2_529 : Uint256 = Uint256(exec_env.calldata_size, 0)
local range_check_ptr = range_check_ptr
let (local _3_530 : Uint256) = uint256_sub(_2_529, base_ref)
local range_check_ptr = range_check_ptr
let (local _4_531 : Uint256) = u256_add(_3_530, _1_528)
local range_check_ptr = range_check_ptr
let (local _5_532 : Uint256) = slt(rel_offset_of_tail, _4_531)
local range_check_ptr = range_check_ptr
let (local _6_533 : Uint256) = is_zero(_5_532)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_533)
local exec_env: ExecutionEnvironment = exec_env
let (local addr_1 : Uint256) = u256_add(base_ref, rel_offset_of_tail)
local range_check_ptr = range_check_ptr
let (local length_527 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(addr_1.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _7_534 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _8_535 : Uint256) = is_gt(length_527, _7_534)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_8_535)
local exec_env: ExecutionEnvironment = exec_env
local _9_536 : Uint256 = Uint256(low=32, high=0)
let (local addr : Uint256) = u256_add(addr_1, _9_536)
local range_check_ptr = range_check_ptr
local _10_537 : Uint256 = _2_529
let (local _11_538 : Uint256) = uint256_sub(_2_529, length_527)
local range_check_ptr = range_check_ptr
let (local _12_539 : Uint256) = sgt(addr, _11_538)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_12_539)
local exec_env: ExecutionEnvironment = exec_env
return (addr, length_527)
end

func copy_calldata_to_memory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(src_644 : Uint256, dst : Uint256, length_645 : Uint256) -> ():
alloc_locals
calldatacopy_{range_check_ptr=range_check_ptr, exec_env=exec_env}(dst, src_644, length_645)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _1_646 : Uint256 = Uint256(low=0, high=0)
let (local _2_647 : Uint256) = u256_add(dst, length_645)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_2_647.low, value=_1_646)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return ()
end

func abi_decode_available_length_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(src : Uint256, length : Uint256, end__warp_mangled : Uint256) -> (array : Uint256):
alloc_locals
let (local _1_1 : Uint256) = array_allocation_size_bytes(length)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local array : Uint256) = allocate_memory(_1_1)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=array.low, value=length)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _2_2 : Uint256) = u256_add(src, length)
local range_check_ptr = range_check_ptr
let (local _3_3 : Uint256) = is_gt(_2_2, end__warp_mangled)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_3)
local exec_env: ExecutionEnvironment = exec_env
local _4_4 : Uint256 = Uint256(low=32, high=0)
let (local _5_5 : Uint256) = u256_add(array, _4_4)
local range_check_ptr = range_check_ptr
copy_calldata_to_memory(src, _5_5, length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (array)
end

func getter_fun_amountInCached{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1455 : Uint256):
alloc_locals
let (res) = amountInCached.read()
return (res)
end

func fun_exactOutput_dynArgs_inner{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_884 : Uint256) -> (var_amountIn_885 : Uint256):
alloc_locals
local _1_886 : Uint256 = Uint256(low=32, high=0)
let (local _2_887 : Uint256) = u256_add(var_params_offset_884, _1_886)
local range_check_ptr = range_check_ptr
let (local expr_888 : Uint256) = read_from_calldatat_address(_2_887)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_offset : Uint256, local expr_3373_length : Uint256) = access_calldata_tail_bytes_calldata(var_params_offset_884, var_params_offset_884)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _3_889 : Uint256 = Uint256(low=64, high=0)
let (local expr_3376_mpos : Uint256) = allocate_memory(_3_889)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _4_890 : Uint256 = Uint256(exec_env.calldata_size, 0)
local range_check_ptr = range_check_ptr
let (local _5_891 : Uint256) = abi_decode_available_length_bytes(expr_offset, expr_3373_length, _4_890)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
write_to_memory_bytes(expr_3376_mpos, _5_891)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
let (local _6_892 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _7_893 : Uint256 = _1_886
let (local _8_894 : Uint256) = u256_add(expr_3376_mpos, _1_886)
local range_check_ptr = range_check_ptr
write_to_memory_address(_8_894, _6_892)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _9_895 : Uint256 = Uint256(low=0, high=0)
local _10_896 : Uint256 = Uint256(low=96, high=0)
let (local _11_897 : Uint256) = u256_add(var_params_offset_884, _10_896)
local range_check_ptr = range_check_ptr
let (local _12_898 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_11_897.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _13_899 : Uint256) = fun_exactOutputInternal(_12_898, expr_888, _9_895, expr_3376_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
__warp_holder()
let (local var_amountIn_885 : Uint256) = getter_fun_amountInCached()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
local _14_900 : Uint256 = Uint256(low=128, high=0)
let (local _15_901 : Uint256) = u256_add(var_params_offset_884, _14_900)
local range_check_ptr = range_check_ptr
let (local _16_902 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_15_901.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _17_903 : Uint256) = is_gt(var_amountIn_885, _16_902)
local range_check_ptr = range_check_ptr
let (local _18_904 : Uint256) = is_zero(_17_903)
local range_check_ptr = range_check_ptr
require_helper(_18_904)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _19_905 : Uint256) = uint256_not(Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
setter_fun_amountInCached(_19_905)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
return (var_amountIn_885)
end

func modifier_checkDeadline{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_1503 : Uint256) -> (_1_1504 : Uint256):
alloc_locals
local _2_1505 : Uint256 = Uint256(low=64, high=0)
let (local _3_1506 : Uint256) = u256_add(var_params_offset_1503, _2_1505)
local range_check_ptr = range_check_ptr
let (local _4_1507 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_3_1506.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _5_1508 : Uint256) = __warp_holder()
let (local _6_1509 : Uint256) = is_gt(_5_1508, _4_1507)
local range_check_ptr = range_check_ptr
let (local _7_1510 : Uint256) = is_zero(_6_1509)
local range_check_ptr = range_check_ptr
require_helper(_7_1510)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _1_1504 : Uint256) = fun_exactOutput_dynArgs_inner(var_params_offset_1503)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (_1_1504)
end

func fun_exactOutput_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_offset_882 : Uint256) -> (var_amountIn_883 : Uint256):
alloc_locals
let (local var_amountIn_883 : Uint256) = modifier_checkDeadline(var_params_offset_882)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (var_amountIn_883)
end

func abi_decode_uint256t_address{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_289 : Uint256, dataEnd_290 : Uint256) -> (value0_291 : Uint256, value1_292 : Uint256):
alloc_locals
local _1_293 : Uint256 = Uint256(low=64, high=0)
let (local _2_294 : Uint256) = uint256_sub(dataEnd_290, headStart_289)
local range_check_ptr = range_check_ptr
let (local _3_295 : Uint256) = slt(_2_294, _1_293)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_295)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_291 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_289.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_296 : Uint256 = Uint256(low=32, high=0)
let (local _5_297 : Uint256) = u256_add(headStart_289, _4_296)
local range_check_ptr = range_check_ptr
let (local value1_292 : Uint256) = abi_decode_address(_5_297)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_291, value1_292)
end

func getter_fun_WETH9{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1451 : Uint256):
alloc_locals
let (res) = WETH9.read()
return (res)
end

func abi_decode_uint256_fromMemory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_283 : Uint256, dataEnd_284 : Uint256) -> (value0_285 : Uint256):
alloc_locals
local _1_286 : Uint256 = Uint256(low=32, high=0)
let (local _2_287 : Uint256) = uint256_sub(dataEnd_284, headStart_283)
local range_check_ptr = range_check_ptr
let (local _3_288 : Uint256) = slt(_2_287, _1_286)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_288)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_285 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(headStart_283.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (value0_285)
end

func __warp_block_28{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1400 : Uint256) -> (expr_1411 : Uint256):
alloc_locals
let (local _17_1412 : Uint256) = __warp_holder()
finalize_allocation(_6_1400, _17_1412)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _18_1413 : Uint256) = __warp_holder()
let (local _19_1414 : Uint256) = u256_add(_6_1400, _18_1413)
local range_check_ptr = range_check_ptr
let (local expr_1411 : Uint256) = abi_decode_uint256_fromMemory(_6_1400, _19_1414)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1411)
end

func __warp_if_16{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_15_1409 : Uint256, _6_1400 : Uint256, expr_1411 : Uint256) -> (expr_1411 : Uint256):
alloc_locals
if _15_1409.low + _15_1409.high != 0:
	let (local expr_1411 : Uint256) = __warp_block_28(_6_1400)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1411)
else:
	return (expr_1411)
end
end

func __warp_block_30{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_29_1422 : Uint256) -> ():
alloc_locals
let (local _40_1433 : Uint256) = __warp_holder()
finalize_allocation(_29_1422, _40_1433)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _41_1434 : Uint256) = __warp_holder()
let (local _42_1435 : Uint256) = u256_add(_29_1422, _41_1434)
local range_check_ptr = range_check_ptr
abi_decode(_29_1422, _42_1435)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_18{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_29_1422 : Uint256, _38_1431 : Uint256) -> ():
alloc_locals
if _38_1431.low + _38_1431.high != 0:
	__warp_block_30(_29_1422)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_block_29{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_10_1404 : Uint256, _5_1399 : Uint256, expr_1411 : Uint256, var_recipient_1396 : Uint256) -> ():
alloc_locals
let (local _24_1419 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _25_1420 : Uint256) = cleanup_address(_24_1419)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1618_address : Uint256) = cleanup_address(_25_1420)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _28_1421 : Uint256 = _5_1399
let (local _29_1422 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1399.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _30_1423 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=773487949, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_29_1422.low, value=_30_1423)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _31_1424 : Uint256 = Uint256(low=0, high=0)
local _32_1425 : Uint256 = _10_1404
let (local _33_1426 : Uint256) = u256_add(_29_1422, _10_1404)
local range_check_ptr = range_check_ptr
let (local _34_1427 : Uint256) = abi_encode_uint256(_33_1426, expr_1411)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _35_1428 : Uint256) = uint256_sub(_34_1427, _29_1422)
local range_check_ptr = range_check_ptr
local _36_1429 : Uint256 = _31_1424
let (local _37_1430 : Uint256) = __warp_holder()
let (local _38_1431 : Uint256) = __warp_holder()
let (local _39_1432 : Uint256) = is_zero(_38_1431)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_39_1432)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_18(_29_1422, _38_1431)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
fun_safeTransferETH(var_recipient_1396, expr_1411)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_17{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_10_1404 : Uint256, _23_1418 : Uint256, _5_1399 : Uint256, expr_1411 : Uint256, var_recipient_1396 : Uint256) -> ():
alloc_locals
if _23_1418.low + _23_1418.high != 0:
	__warp_block_29(_10_1404, _5_1399, expr_1411, var_recipient_1396)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	return ()
end
end

func fun_unwrapWETH9{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_amountMinimum_1395 : Uint256, var_recipient_1396 : Uint256) -> ():
alloc_locals
let (local _1_1397 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _2_1398 : Uint256) = cleanup_address(_1_1397)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1599_address : Uint256) = cleanup_address(_2_1398)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _5_1399 : Uint256 = Uint256(low=64, high=0)
let (local _6_1400 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1399.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1401 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1400.low, value=_7_1401)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1402 : Uint256 = Uint256(low=32, high=0)
let (local _9_1403 : Uint256) = __warp_holder()
local _10_1404 : Uint256 = Uint256(low=4, high=0)
let (local _11_1405 : Uint256) = u256_add(_6_1400, _10_1404)
local range_check_ptr = range_check_ptr
let (local _12_1406 : Uint256) = abi_encode_address(_11_1405, _9_1403)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _13_1407 : Uint256) = uint256_sub(_12_1406, _6_1400)
local range_check_ptr = range_check_ptr
let (local _14_1408 : Uint256) = __warp_holder()
let (local _15_1409 : Uint256) = __warp_holder()
let (local _16_1410 : Uint256) = is_zero(_15_1409)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_16_1410)
local exec_env: ExecutionEnvironment = exec_env
local expr_1411 : Uint256 = Uint256(low=0, high=0)
let (local expr_1411 : Uint256) = __warp_if_16(_15_1409, _6_1400, expr_1411)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _20_1415 : Uint256) = is_lt(expr_1411, var_amountMinimum_1395)
local range_check_ptr = range_check_ptr
let (local _21_1416 : Uint256) = is_zero(_20_1415)
local range_check_ptr = range_check_ptr
require_helper(_21_1416)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _22_1417 : Uint256) = is_zero(expr_1411)
local range_check_ptr = range_check_ptr
let (local _23_1418 : Uint256) = is_zero(_22_1417)
local range_check_ptr = range_check_ptr
__warp_if_17(_10_1404, _23_1418, _5_1399, expr_1411, var_recipient_1396)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func abi_decode_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(offset_48 : Uint256, end_49 : Uint256) -> (array_50 : Uint256):
alloc_locals
local _1_51 : Uint256 = Uint256(low=31, high=0)
let (local _2_52 : Uint256) = u256_add(offset_48, _1_51)
local range_check_ptr = range_check_ptr
let (local _3_53 : Uint256) = slt(_2_52, end_49)
local range_check_ptr = range_check_ptr
let (local _4_54 : Uint256) = is_zero(_3_53)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_54)
local exec_env: ExecutionEnvironment = exec_env
let (local _5_55 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_48.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_56 : Uint256 = Uint256(low=32, high=0)
let (local _7_57 : Uint256) = u256_add(offset_48, _6_56)
local range_check_ptr = range_check_ptr
let (local array_50 : Uint256) = abi_decode_available_length_bytes(_7_57, _5_55, end_49)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (array_50)
end

func abi_decode_struct_ExactInputParams{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart : Uint256, end_68 : Uint256) -> (value_69 : Uint256):
alloc_locals
local _1_70 : Uint256 = Uint256(low=160, high=0)
let (local _2_71 : Uint256) = uint256_sub(end_68, headStart)
local range_check_ptr = range_check_ptr
let (local _3_72 : Uint256) = slt(_2_71, _1_70)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_72)
local exec_env: ExecutionEnvironment = exec_env
local _4_73 : Uint256 = _1_70
let (local value_69 : Uint256) = allocate_memory(_1_70)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local offset_74 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_75 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _6_76 : Uint256) = is_gt(offset_74, _5_75)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_76)
local exec_env: ExecutionEnvironment = exec_env
let (local _7_77 : Uint256) = u256_add(headStart, offset_74)
local range_check_ptr = range_check_ptr
let (local _8_78 : Uint256) = abi_decode_bytes(_7_77, end_68)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=value_69.low, value=_8_78)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _9_79 : Uint256 = Uint256(low=32, high=0)
let (local _10_80 : Uint256) = u256_add(headStart, _9_79)
local range_check_ptr = range_check_ptr
let (local _11_81 : Uint256) = abi_decode_address(_10_80)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _12_82 : Uint256 = _9_79
let (local _13_83 : Uint256) = u256_add(value_69, _9_79)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_13_83.low, value=_11_81)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _14_84 : Uint256 = Uint256(low=64, high=0)
let (local _15_85 : Uint256) = u256_add(headStart, _14_84)
local range_check_ptr = range_check_ptr
let (local _16_86 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_15_85.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _17_87 : Uint256 = _14_84
let (local _18_88 : Uint256) = u256_add(value_69, _14_84)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_18_88.low, value=_16_86)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _19_89 : Uint256 = Uint256(low=96, high=0)
let (local _20_90 : Uint256) = u256_add(headStart, _19_89)
local range_check_ptr = range_check_ptr
let (local _21_91 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_20_90.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _22_92 : Uint256 = _19_89
let (local _23_93 : Uint256) = u256_add(value_69, _19_89)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_23_93.low, value=_21_91)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _24_94 : Uint256 = Uint256(low=128, high=0)
let (local _25_95 : Uint256) = u256_add(headStart, _24_94)
local range_check_ptr = range_check_ptr
let (local _26_96 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_25_95.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _27_97 : Uint256 = _24_94
let (local _28_98 : Uint256) = u256_add(value_69, _24_94)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_28_98.low, value=_26_96)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (value_69)
end

func abi_decode_struct_ExactInputParams_memory_ptr{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_247 : Uint256, dataEnd_248 : Uint256) -> (value0_249 : Uint256):
alloc_locals
local _1_250 : Uint256 = Uint256(low=32, high=0)
let (local _2_251 : Uint256) = uint256_sub(dataEnd_248, headStart_247)
local range_check_ptr = range_check_ptr
let (local _3_252 : Uint256) = slt(_2_251, _1_250)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_252)
local exec_env: ExecutionEnvironment = exec_env
let (local offset_253 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_247.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_254 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_255 : Uint256) = is_gt(offset_253, _4_254)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_5_255)
local exec_env: ExecutionEnvironment = exec_env
let (local _6_256 : Uint256) = u256_add(headStart_247, offset_253)
local range_check_ptr = range_check_ptr
let (local value0_249 : Uint256) = abi_decode_struct_ExactInputParams(_6_256, dataEnd_248)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (value0_249)
end

func constant_MULTIPLE_POOLS_MIN_LENGTH{exec_env: ExecutionEnvironment, range_check_ptr}() -> (ret_634 : Uint256):
alloc_locals
local _1_635 : Uint256 = Uint256(low=20, high=0)
local _2_636 : Uint256 = Uint256(low=3, high=0)
local _3_637 : Uint256 = _1_635
let (local _4_638 : Uint256) = checked_add_uint256(_1_635, _2_636)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr : Uint256) = checked_add_uint256(_4_638, _1_635)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _5_639 : Uint256 = _2_636
local _6_640 : Uint256 = _1_635
let (local _7_641 : Uint256) = checked_add_uint256(_1_635, _2_636)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_634 : Uint256) = checked_add_uint256(expr, _7_641)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (ret_634)
end

func fun_hasMultiplePools{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_path_mpos : Uint256) -> (var_ : Uint256):
alloc_locals
let (local expr_931 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_path_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _1_932 : Uint256) = constant_MULTIPLE_POOLS_MIN_LENGTH()
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _2_933 : Uint256) = cleanup_bytes32(_1_932)
local exec_env: ExecutionEnvironment = exec_env
let (local _3_934 : Uint256) = is_lt(expr_931, _2_933)
local range_check_ptr = range_check_ptr
let (local var_ : Uint256) = is_zero(_3_934)
local range_check_ptr = range_check_ptr
return (var_)
end

func __warp_loop_body_4{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(usr_cc : Uint256, usr_mc : Uint256) -> (usr_cc : Uint256, usr_mc : Uint256):
alloc_locals
let (local _22_1205 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(usr_cc.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=usr_mc.low, value=_22_1205)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _21_1204 : Uint256 = Uint256(low=32, high=0)
let (local usr_mc : Uint256) = u256_add(usr_mc, _21_1204)
local range_check_ptr = range_check_ptr
let (local usr_cc : Uint256) = u256_add(usr_cc, _21_1204)
local range_check_ptr = range_check_ptr
return (usr_cc, usr_mc)
end

func __warp_loop_4{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(usr_cc : Uint256, usr_mc : Uint256) -> (usr_cc : Uint256, usr_mc : Uint256):
alloc_locals
let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_body_4(usr_cc, usr_mc)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(usr_cc, usr_mc)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (usr_cc, usr_mc)
end

func __warp_block_33{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_1183 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
alloc_locals
local _13_1196 : Uint256 = Uint256(low=64, high=0)
let (local var_tempBytes_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_13_1196.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _14_1197 : Uint256 = _1_1183
let (local usr_lengthmod : Uint256) = uint256_and(var_length, _1_1183)
local range_check_ptr = range_check_ptr
let (local _15_1198 : Uint256) = is_zero(usr_lengthmod)
local range_check_ptr = range_check_ptr
local _16_1199 : Uint256 = Uint256(low=5, high=0)
let (local _17_1200 : Uint256) = uint256_shl(_16_1199, _15_1198)
local range_check_ptr = range_check_ptr
let (local _18_1201 : Uint256) = u256_add(var_tempBytes_mpos, usr_lengthmod)
local range_check_ptr = range_check_ptr
let (local usr_mc : Uint256) = u256_add(_18_1201, _17_1200)
local range_check_ptr = range_check_ptr
let (local usr_end : Uint256) = u256_add(usr_mc, var_length)
local range_check_ptr = range_check_ptr
let (local _19_1202 : Uint256) = u256_add(var__bytes_mpos, usr_lengthmod)
local range_check_ptr = range_check_ptr
let (local _20_1203 : Uint256) = u256_add(_19_1202, _17_1200)
local range_check_ptr = range_check_ptr
let (local usr_cc : Uint256) = u256_add(_20_1203, var__start)
local range_check_ptr = range_check_ptr
let (local usr_cc : Uint256, local usr_mc : Uint256) = __warp_loop_4(usr_cc, usr_mc)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=var_tempBytes_mpos.low, value=var_length)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _23_1206 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
local _24_1207 : Uint256 = _1_1183
let (local _25_1208 : Uint256) = u256_add(usr_mc, _1_1183)
local range_check_ptr = range_check_ptr
let (local _26_1209 : Uint256) = uint256_and(_25_1208, _23_1206)
local range_check_ptr = range_check_ptr
local _27_1210 : Uint256 = _13_1196
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_13_1196.low, value=_26_1209)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (var_tempBytes_mpos)
end

func __warp_block_34{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}() -> (var_tempBytes_mpos : Uint256):
alloc_locals
local _28_1211 : Uint256 = Uint256(low=64, high=0)
let (local var_tempBytes_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_28_1211.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _29_1212 : Uint256 = Uint256(low=0, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=var_tempBytes_mpos.low, value=_29_1212)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _30_1213 : Uint256 = Uint256(low=32, high=0)
let (local _31_1214 : Uint256) = u256_add(var_tempBytes_mpos, _30_1213)
local range_check_ptr = range_check_ptr
local _32_1215 : Uint256 = _28_1211
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_28_1211.low, value=_31_1214)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (var_tempBytes_mpos)
end

func __warp_if_19{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_1183 : Uint256, __warp_subexpr_0 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local var_tempBytes_mpos : Uint256) = __warp_block_33(_1_1183, var__bytes_mpos, var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_tempBytes_mpos)
else:
	let (local var_tempBytes_mpos : Uint256) = __warp_block_34()
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (var_tempBytes_mpos)
end
end

func __warp_block_32{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_1183 : Uint256, match_var : Uint256, var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local var_tempBytes_mpos : Uint256) = __warp_if_19(_1_1183, __warp_subexpr_0, var__bytes_mpos, var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_tempBytes_mpos)
end

func __warp_block_31{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_12_1195 : Uint256, _1_1183 : Uint256, var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (var_tempBytes_mpos : Uint256):
alloc_locals
local match_var : Uint256 = _12_1195
let (local var_tempBytes_mpos : Uint256) = __warp_block_32(_1_1183, match_var, var__bytes_mpos, var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_tempBytes_mpos)
end

func fun_slice{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var__bytes_mpos : Uint256, var__start : Uint256, var_length : Uint256) -> (var_2328_mpos : Uint256):
alloc_locals
local _1_1183 : Uint256 = Uint256(low=31, high=0)
let (local _2_1184 : Uint256) = checked_add_uint256(var_length, _1_1183)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _3_1185 : Uint256) = is_lt(_2_1184, var_length)
local range_check_ptr = range_check_ptr
let (local _4_1186 : Uint256) = is_zero(_3_1185)
local range_check_ptr = range_check_ptr
require_helper(_4_1186)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _5_1187 : Uint256) = checked_add_uint256(var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _6_1188 : Uint256) = is_lt(_5_1187, var__start)
local range_check_ptr = range_check_ptr
let (local _7_1189 : Uint256) = is_zero(_6_1188)
local range_check_ptr = range_check_ptr
require_helper(_7_1189)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_1190 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var__bytes_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _8_1191 : Uint256) = checked_add_uint256(var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _9_1192 : Uint256) = cleanup_bytes32(_8_1191)
local exec_env: ExecutionEnvironment = exec_env
let (local _10_1193 : Uint256) = is_lt(expr_1190, _9_1192)
local range_check_ptr = range_check_ptr
let (local _11_1194 : Uint256) = is_zero(_10_1193)
local range_check_ptr = range_check_ptr
require_helper(_11_1194)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local var_tempBytes_mpos : Uint256 = Uint256(low=0, high=0)
let (local _12_1195 : Uint256) = is_zero(var_length)
local range_check_ptr = range_check_ptr
let (local var_tempBytes_mpos : Uint256) = __warp_block_31(_12_1195, _1_1183, var__bytes_mpos, var__start, var_length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local var_2328_mpos : Uint256 = var_tempBytes_mpos
return (var_2328_mpos)
end

func fun_getFirstPool{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_path_2518_mpos : Uint256) -> (var_2521_mpos : Uint256):
alloc_locals
local _1_906 : Uint256 = Uint256(low=20, high=0)
local _2_907 : Uint256 = Uint256(low=3, high=0)
local _3_908 : Uint256 = _1_906
let (local _4_909 : Uint256) = checked_add_uint256(_1_906, _2_907)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _5_910 : Uint256) = checked_add_uint256(_4_909, _1_906)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_911 : Uint256 = Uint256(low=0, high=0)
let (local var_2521_mpos : Uint256) = fun_slice(var_path_2518_mpos, _6_911, _5_910)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_2521_mpos)
end

func checked_sub_uint256{exec_env: ExecutionEnvironment, range_check_ptr}(x_623 : Uint256, y_624 : Uint256) -> (diff_625 : Uint256):
alloc_locals
let (local _1_626 : Uint256) = is_lt(x_623, y_624)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_1_626)
local exec_env: ExecutionEnvironment = exec_env
let (local diff_625 : Uint256) = uint256_sub(x_623, y_624)
local range_check_ptr = range_check_ptr
return (diff_625)
end

func fun_skipToken{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_path_2532_mpos : Uint256) -> (var_mpos : Uint256):
alloc_locals
local _1_1175 : Uint256 = Uint256(low=3, high=0)
local _2_1176 : Uint256 = Uint256(low=20, high=0)
let (local expr_1177 : Uint256) = checked_add_uint256(_2_1176, _1_1175)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_1_1178 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_path_2532_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _3_1179 : Uint256 = _1_1175
local _4_1180 : Uint256 = _2_1176
let (local _5_1181 : Uint256) = checked_add_uint256(_2_1176, _1_1175)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _6_1182 : Uint256) = checked_sub_uint256(expr_1_1178, _5_1181)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local var_mpos : Uint256) = fun_slice(var_path_2532_mpos, expr_1177, _6_1182)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_mpos)
end

func __warp_block_37{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_params_mpos : Uint256) -> (expr_1_800 : Uint256):
alloc_locals
local _7_801 : Uint256 = Uint256(low=32, high=0)
let (local _8_802 : Uint256) = u256_add(var_params_mpos, _7_801)
local range_check_ptr = range_check_ptr
let (local _9_803 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_802.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_1_800 : Uint256) = cleanup_address(_9_803)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_1_800)
end

func __warp_if_20{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(__warp_subexpr_0 : Uint256, var_params_mpos : Uint256) -> (expr_1_800 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local expr_1_800 : Uint256) = __warp_block_37(var_params_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_800)
else:
	let (local expr_1_800 : Uint256) = __warp_holder()
return (expr_1_800)
end
end

func __warp_block_36{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(match_var : Uint256, var_params_mpos : Uint256) -> (expr_1_800 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_1_800 : Uint256) = __warp_if_20(__warp_subexpr_0, var_params_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_800)
end

func __warp_block_35{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(expr_795 : Uint256, var_params_mpos : Uint256) -> (expr_1_800 : Uint256):
alloc_locals
local match_var : Uint256 = expr_795
let (local expr_1_800 : Uint256) = __warp_block_36(match_var, var_params_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_800)
end

func __warp_block_40{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_4_797 : Uint256) -> (__warp_break_2 : Uint256, __warp_leave_111 : Uint256, var_amountOut_793 : Uint256):
alloc_locals
let (local _16_810 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_797.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local var_amountOut_793 : Uint256) = cleanup_bytes32(_16_810)
local exec_env: ExecutionEnvironment = exec_env
local __warp_break_2 : Uint256 = Uint256(low=1, high=0)
local __warp_leave_111 : Uint256 = Uint256(low=1, high=0)
return (__warp_break_2, __warp_leave_111, var_amountOut_793)
end

func __warp_block_41{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_params_mpos : Uint256) -> (var_payer : Uint256):
alloc_locals
let (local var_payer : Uint256) = __warp_holder()
let (local _17_811 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_params_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _18_812 : Uint256) = fun_skipToken(_17_811)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=var_params_mpos.low, value=_18_812)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (var_payer)
end

func __warp_if_76{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_4_797 : Uint256, __warp_break_2 : Uint256, __warp_leave_111 : Uint256, __warp_leave_243 : Uint256, __warp_subexpr_0 : Uint256, var_amountOut_793 : Uint256, var_params_mpos : Uint256, var_payer : Uint256) -> (__warp_break_2 : Uint256, __warp_leave_111 : Uint256, __warp_leave_243 : Uint256, var_amountOut_793 : Uint256, var_payer : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local __warp_break_2 : Uint256, local __warp_leave_111 : Uint256, local var_amountOut_793 : Uint256) = __warp_block_40(_4_797)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
if __warp_leave_111.low + __warp_leave_111.high != 0:
	local __warp_leave_243 : Uint256 = Uint256(low=1, high=0)
return (__warp_break_2, __warp_leave_111, __warp_leave_243, var_amountOut_793, var_payer)
else:
	return (__warp_break_2, __warp_leave_111, __warp_leave_243, var_amountOut_793, var_payer)
end
else:
	let (local var_payer : Uint256) = __warp_block_41(var_params_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (__warp_break_2, __warp_leave_111, __warp_leave_243, var_amountOut_793, var_payer)
end
end

func __warp_block_39{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_4_797 : Uint256, __warp_break_2 : Uint256, __warp_leave_111 : Uint256, match_var : Uint256, var_amountOut_793 : Uint256, var_params_mpos : Uint256, var_payer : Uint256) -> (__warp_break_2 : Uint256, __warp_leave_111 : Uint256, var_amountOut_793 : Uint256, var_payer : Uint256):
alloc_locals
local __warp_leave_243 : Uint256 = Uint256(low=0, high=0)
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local __warp_break_2 : Uint256, local __warp_leave_111 : Uint256, local __warp_leave_243 : Uint256, local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_if_76(_4_797, __warp_break_2, __warp_leave_111, __warp_leave_243, __warp_subexpr_0, var_amountOut_793, var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
if __warp_leave_243.low + __warp_leave_243.high != 0:
	return (__warp_break_2, __warp_leave_111, var_amountOut_793, var_payer)
else:
	return (__warp_break_2, __warp_leave_111, var_amountOut_793, var_payer)
end
end

func __warp_block_38{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_4_797 : Uint256, __warp_break_2 : Uint256, __warp_leave_111 : Uint256, expr_795 : Uint256, var_amountOut_793 : Uint256, var_params_mpos : Uint256, var_payer : Uint256) -> (__warp_break_2 : Uint256, __warp_leave_111 : Uint256, var_amountOut_793 : Uint256, var_payer : Uint256):
alloc_locals
local match_var : Uint256 = expr_795
let (local __warp_break_2 : Uint256, local __warp_leave_111 : Uint256, local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_block_39(_4_797, __warp_break_2, __warp_leave_111, match_var, var_amountOut_793, var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
if __warp_leave_111.low + __warp_leave_111.high != 0:
	return (__warp_break_2, __warp_leave_111, var_amountOut_793, var_payer)
else:
	return (__warp_break_2, __warp_leave_111, var_amountOut_793, var_payer)
end
end

func __warp_loop_body_2{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_params_mpos : Uint256, var_payer : Uint256) -> (__warp_break_2 : Uint256, var_amountOut_793 : Uint256, var_payer : Uint256):
alloc_locals
local __warp_break_2 : Uint256 = Uint256(low=0, high=0)
local var_amountOut_793 : Uint256 = Uint256(low=0, high=0)
local __warp_leave_111 : Uint256 = Uint256(low=0, high=0)
let (local _2_794 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_params_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_795 : Uint256) = fun_hasMultiplePools(_2_794)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _3_796 : Uint256 = Uint256(low=96, high=0)
let (local _4_797 : Uint256) = u256_add(var_params_mpos, _3_796)
local range_check_ptr = range_check_ptr
let (local _5_798 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_4_797.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _6_799 : Uint256) = cleanup_bytes32(_5_798)
local exec_env: ExecutionEnvironment = exec_env
local expr_1_800 : Uint256 = Uint256(low=0, high=0)
let (local expr_1_800 : Uint256) = __warp_block_35(expr_795, var_params_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _10_804 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(var_params_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_3137_mpos : Uint256) = fun_getFirstPool(_10_804)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _11_805 : Uint256 = Uint256(low=64, high=0)
let (local expr_3139_mpos : Uint256) = allocate_memory(_11_805)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
write_to_memory_bytes(expr_3139_mpos, expr_3137_mpos)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _12_806 : Uint256 = Uint256(low=32, high=0)
let (local _13_807 : Uint256) = u256_add(expr_3139_mpos, _12_806)
local range_check_ptr = range_check_ptr
write_to_memory_address(_13_807, var_payer)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _14_808 : Uint256 = Uint256(low=0, high=0)
let (local _15_809 : Uint256) = fun_exactInputInternal(_6_799, expr_1_800, _14_808, expr_3139_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
write_to_memory_bytes(_4_797, _15_809)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
let (local __warp_break_2 : Uint256, local __warp_leave_111 : Uint256, local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_block_38(_4_797, __warp_break_2, __warp_leave_111, expr_795, var_amountOut_793, var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
if __warp_leave_111.low + __warp_leave_111.high != 0:
	return (__warp_break_2, var_amountOut_793, var_payer)
else:
	return (__warp_break_2, var_amountOut_793, var_payer)
end
end

func __warp_loop_2{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_params_mpos : Uint256, var_payer : Uint256) -> (var_amountOut_793 : Uint256, var_payer : Uint256):
alloc_locals
local __warp_break_2 : Uint256 = Uint256(low=0, high=0)
let (local __warp_break_2 : Uint256, local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_loop_body_2(var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
if __warp_break_2.low + __warp_break_2.high != 0:
	return (var_amountOut_793, var_payer)
end
let (local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_loop_2(var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return (var_amountOut_793, var_payer)
end

func fun_exactInput_dynArgs_inner{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_792 : Uint256, var_params_mpos : Uint256) -> (var_amountOut_793 : Uint256):
alloc_locals
local var_amountOut_793 : Uint256 = _1_792
let (local var_payer : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
let (local var_amountOut_793 : Uint256, local var_payer : Uint256) = __warp_loop_2(var_params_mpos, var_payer)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local _19_813 : Uint256 = Uint256(low=128, high=0)
let (local _20_814 : Uint256) = u256_add(var_params_mpos, _19_813)
local range_check_ptr = range_check_ptr
let (local _21_815 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_20_814.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _22_816 : Uint256) = cleanup_bytes32(_21_815)
local exec_env: ExecutionEnvironment = exec_env
let (local _23_817 : Uint256) = cleanup_bytes32(_22_816)
local exec_env: ExecutionEnvironment = exec_env
let (local _24_818 : Uint256) = is_lt(var_amountOut_793, _23_817)
local range_check_ptr = range_check_ptr
let (local _25_819 : Uint256) = is_zero(_24_818)
local range_check_ptr = range_check_ptr
require_helper(_25_819)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_amountOut_793)
end

func modifier_checkDeadline_3101{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_amountOut_1485 : Uint256, var_params_mpos_1486 : Uint256) -> (_1_1487 : Uint256):
alloc_locals
local _2_1488 : Uint256 = Uint256(low=64, high=0)
let (local _3_1489 : Uint256) = u256_add(var_params_mpos_1486, _2_1488)
local range_check_ptr = range_check_ptr
let (local _4_1490 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_3_1489.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _5_1491 : Uint256) = cleanup_bytes32(_4_1490)
local exec_env: ExecutionEnvironment = exec_env
let (local _6_1492 : Uint256) = __warp_holder()
let (local _7_1493 : Uint256) = is_gt(_6_1492, _5_1491)
local range_check_ptr = range_check_ptr
let (local _8_1494 : Uint256) = is_zero(_7_1493)
local range_check_ptr = range_check_ptr
require_helper(_8_1494)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _1_1487 : Uint256) = fun_exactInput_dynArgs_inner(var_amountOut_1485, var_params_mpos_1486)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (_1_1487)
end

func fun_exactInput_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_params_3095_mpos : Uint256) -> (var_amountOut_790 : Uint256):
alloc_locals
local _1_791 : Uint256 = Uint256(low=0, high=0)
let (local var_amountOut_790 : Uint256) = modifier_checkDeadline_3101(_1_791, var_params_3095_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return (var_amountOut_790)
end

func getter_fun_I_am_a_mistake{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1447 : Uint256):
alloc_locals
let (res) = I_am_a_mistake.read()
return (res)
end

func getter_fun_seaplusplus{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}() -> (value_1459 : Uint256):
alloc_locals
let (res) = seaplusplus.read()
return (res)
end

func abi_decode_bytes_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(offset_33 : Uint256, end_34 : Uint256) -> (arrayPos_35 : Uint256, length_36 : Uint256):
alloc_locals
local _1_37 : Uint256 = Uint256(low=31, high=0)
let (local _2_38 : Uint256) = u256_add(offset_33, _1_37)
local range_check_ptr = range_check_ptr
let (local _3_39 : Uint256) = slt(_2_38, end_34)
local range_check_ptr = range_check_ptr
let (local _4_40 : Uint256) = is_zero(_3_39)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_40)
local exec_env: ExecutionEnvironment = exec_env
let (local length_36 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_33.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_41 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _6_42 : Uint256) = is_gt(length_36, _5_41)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_42)
local exec_env: ExecutionEnvironment = exec_env
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
local exec_env: ExecutionEnvironment = exec_env
return (arrayPos_35, length_36)
end

func abi_decode_int256t_int256t_bytes_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_220 : Uint256, dataEnd_221 : Uint256) -> (value0_222 : Uint256, value1_223 : Uint256, value2_224 : Uint256, value3_225 : Uint256):
alloc_locals
local _1_226 : Uint256 = Uint256(low=96, high=0)
let (local _2_227 : Uint256) = uint256_sub(dataEnd_221, headStart_220)
local range_check_ptr = range_check_ptr
let (local _3_228 : Uint256) = slt(_2_227, _1_226)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_228)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_222 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_220.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_229 : Uint256 = Uint256(low=32, high=0)
let (local _5_230 : Uint256) = u256_add(headStart_220, _4_229)
local range_check_ptr = range_check_ptr
let (local value1_223 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_230.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_231 : Uint256 = Uint256(low=64, high=0)
let (local _7_232 : Uint256) = u256_add(headStart_220, _6_231)
local range_check_ptr = range_check_ptr
let (local offset_233 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_7_232.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _8_234 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _9_235 : Uint256) = is_gt(offset_233, _8_234)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_9_235)
local exec_env: ExecutionEnvironment = exec_env
let (local _10_236 : Uint256) = u256_add(headStart_220, offset_233)
local range_check_ptr = range_check_ptr
let (local value2_1 : Uint256, local value3_1 : Uint256) = abi_decode_bytes_calldata(_10_236, dataEnd_221)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local value2_224 : Uint256 = value2_1
local value3_225 : Uint256 = value3_1
return (value0_222, value1_223, value2_224, value3_225)
end

func abi_decode_struct_SwapCallbackData{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_111 : Uint256, end_112 : Uint256) -> (value_113 : Uint256):
alloc_locals
local _1_114 : Uint256 = Uint256(low=64, high=0)
let (local _2_115 : Uint256) = uint256_sub(end_112, headStart_111)
local range_check_ptr = range_check_ptr
let (local _3_116 : Uint256) = slt(_2_115, _1_114)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_116)
local exec_env: ExecutionEnvironment = exec_env
local _4_117 : Uint256 = _1_114
let (local value_113 : Uint256) = allocate_memory(_1_114)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local offset_118 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_111.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_119 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _6_120 : Uint256) = is_gt(offset_118, _5_119)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_120)
local exec_env: ExecutionEnvironment = exec_env
let (local _7_121 : Uint256) = u256_add(headStart_111, offset_118)
local range_check_ptr = range_check_ptr
let (local _8_122 : Uint256) = abi_decode_bytes(_7_121, end_112)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=value_113.low, value=_8_122)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _9_123 : Uint256 = Uint256(low=32, high=0)
let (local _10_124 : Uint256) = u256_add(headStart_111, _9_123)
local range_check_ptr = range_check_ptr
let (local _11_125 : Uint256) = abi_decode_address(_10_124)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _12_126 : Uint256 = _9_123
let (local _13_127 : Uint256) = u256_add(value_113, _9_123)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_13_127.low, value=_11_125)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (value_113)
end

func abi_decode_struct_SwapCallbackData_memory_ptr{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_273 : Uint256, dataEnd_274 : Uint256) -> (value0_275 : Uint256):
alloc_locals
local _1_276 : Uint256 = Uint256(low=32, high=0)
let (local _2_277 : Uint256) = uint256_sub(dataEnd_274, headStart_273)
local range_check_ptr = range_check_ptr
let (local _3_278 : Uint256) = slt(_2_277, _1_276)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_278)
local exec_env: ExecutionEnvironment = exec_env
let (local offset_279 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_273.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_280 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_281 : Uint256) = is_gt(offset_279, _4_280)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_5_281)
local exec_env: ExecutionEnvironment = exec_env
let (local _6_282 : Uint256) = u256_add(headStart_273, offset_279)
local range_check_ptr = range_check_ptr
let (local value0_275 : Uint256) = abi_decode_struct_SwapCallbackData(_6_282, dataEnd_274)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (value0_275)
end

func fun_verifyCallback_2694{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_factory_1441 : Uint256, var_poolKey_mpos : Uint256) -> (var_pool_2671_address : Uint256):
alloc_locals
let (local _1_1442 : Uint256) = fun_computeAddress(var_factory_1441, var_poolKey_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local var_pool_2671_address : Uint256) = cleanup_address(_1_1442)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1443 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _3_1444 : Uint256) = uint256_and(var_pool_2671_address, _2_1443)
local range_check_ptr = range_check_ptr
let (local _4_1445 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
let (local _5_1446 : Uint256) = is_eq(_4_1445, _3_1444)
local range_check_ptr = range_check_ptr
require_helper(_5_1446)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_pool_2671_address)
end

func fun_verifyCallback{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_factory_1436 : Uint256, var_tokenA_1437 : Uint256, var_tokenB_1438 : Uint256, var_fee_1439 : Uint256) -> (var_pool_address : Uint256):
alloc_locals
let (local _1_1440 : Uint256) = fun_getPoolKey(var_tokenA_1437, var_tokenB_1438, var_fee_1439)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local var_pool_address : Uint256) = fun_verifyCallback_2694(var_factory_1436, _1_1440)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return (var_pool_address)
end

func abi_encode_address_address_uint256{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_425 : Uint256, value0_426 : Uint256, value1_427 : Uint256, value2_428 : Uint256) -> (tail_429 : Uint256):
alloc_locals
local _1_430 : Uint256 = Uint256(low=96, high=0)
let (local tail_429 : Uint256) = u256_add(headStart_425, _1_430)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_426, headStart_425)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_431 : Uint256 = Uint256(low=32, high=0)
let (local _3_432 : Uint256) = u256_add(headStart_425, _2_431)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value1_427, _3_432)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _4_433 : Uint256 = Uint256(low=64, high=0)
let (local _5_434 : Uint256) = u256_add(headStart_425, _4_433)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value2_428, _5_434)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
return (tail_429)
end

func validator_revert_bool{exec_env: ExecutionEnvironment, range_check_ptr}(value_1600 : Uint256) -> ():
alloc_locals
let (local _1_1601 : Uint256) = is_zero(value_1600)
local range_check_ptr = range_check_ptr
let (local _2_1602 : Uint256) = is_zero(_1_1601)
local range_check_ptr = range_check_ptr
let (local _3_1603 : Uint256) = is_eq(value_1600, _2_1602)
local range_check_ptr = range_check_ptr
let (local _4_1604 : Uint256) = is_zero(_3_1603)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_1604)
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func abi_decode_t_bool_fromMemory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(offset_31 : Uint256) -> (value_32 : Uint256):
alloc_locals
let (local value_32 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset_31.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
validator_revert_bool(value_32)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value_32)
end

func abi_decode_bool_fromMemory{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_205 : Uint256, dataEnd_206 : Uint256) -> (value0_207 : Uint256):
alloc_locals
local _1_208 : Uint256 = Uint256(low=32, high=0)
let (local _2_209 : Uint256) = uint256_sub(dataEnd_206, headStart_205)
local range_check_ptr = range_check_ptr
let (local _3_210 : Uint256) = slt(_2_209, _1_208)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_210)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_207 : Uint256) = abi_decode_t_bool_fromMemory(headStart_205)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (value0_207)
end

func __warp_block_43{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1027 : Uint256, expr_1437_component_2_mpos : Uint256, expr_1_1042 : Uint256) -> (expr_2_1043 : Uint256):
alloc_locals
local _17_1045 : Uint256 = _2_1027
let (local _18_1046 : Uint256) = u256_add(expr_1437_component_2_mpos, expr_1_1042)
local range_check_ptr = range_check_ptr
let (local _19_1047 : Uint256) = u256_add(_18_1046, _2_1027)
local range_check_ptr = range_check_ptr
local _20_1048 : Uint256 = _2_1027
let (local _21_1049 : Uint256) = u256_add(expr_1437_component_2_mpos, _2_1027)
local range_check_ptr = range_check_ptr
let (local expr_2_1043 : Uint256) = abi_decode_bool_fromMemory(_21_1049, _19_1047)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_2_1043)
end

func __warp_if_22{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_16_1044 : Uint256, _2_1027 : Uint256, expr_1437_component_2_mpos : Uint256, expr_1_1042 : Uint256, expr_2_1043 : Uint256) -> (expr_2_1043 : Uint256):
alloc_locals
if _16_1044.low + _16_1044.high != 0:
	let (local expr_2_1043 : Uint256) = __warp_block_43(_2_1027, expr_1437_component_2_mpos, expr_1_1042)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_2_1043)
else:
	return (expr_2_1043)
end
end

func __warp_block_42{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1027 : Uint256, expr_1437_component_2_mpos : Uint256) -> (expr_1041 : Uint256):
alloc_locals
let (local expr_1_1042 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1437_component_2_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_2_1043 : Uint256) = is_zero(expr_1_1042)
local range_check_ptr = range_check_ptr
let (local _16_1044 : Uint256) = is_zero(expr_2_1043)
local range_check_ptr = range_check_ptr
let (local expr_2_1043 : Uint256) = __warp_if_22(_16_1044, _2_1027, expr_1437_component_2_mpos, expr_1_1042, expr_2_1043)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_1041 : Uint256 = expr_2_1043
return (expr_1041)
end

func __warp_if_21{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1027 : Uint256, expr_1041 : Uint256, expr_1437_component : Uint256, expr_1437_component_2_mpos : Uint256) -> (expr_1041 : Uint256):
alloc_locals
if expr_1437_component.low + expr_1437_component.high != 0:
	let (local expr_1041 : Uint256) = __warp_block_42(_2_1027, expr_1437_component_2_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1041)
else:
	return (expr_1041)
end
end

func fun_safeTransferFrom{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_token_1023 : Uint256, var_from : Uint256, var_to_1024 : Uint256, var_value_1025 : Uint256) -> ():
alloc_locals
local _1_1026 : Uint256 = Uint256(low=64, high=0)
let (local expr_1436_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_1026.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _2_1027 : Uint256 = Uint256(low=32, high=0)
let (local _3_1028 : Uint256) = u256_add(expr_1436_mpos, _2_1027)
local range_check_ptr = range_check_ptr
let (local _4_1029 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=599290589, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_3_1028.low, value=_4_1029)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _5_1030 : Uint256 = Uint256(low=36, high=0)
let (local _6_1031 : Uint256) = u256_add(expr_1436_mpos, _5_1030)
local range_check_ptr = range_check_ptr
let (local _7_1032 : Uint256) = abi_encode_address_address_uint256(_6_1031, var_from, var_to_1024, var_value_1025)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _8_1033 : Uint256) = uint256_sub(_7_1032, expr_1436_mpos)
local range_check_ptr = range_check_ptr
let (local _9_1034 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _10_1035 : Uint256) = u256_add(_8_1033, _9_1034)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_1436_mpos.low, value=_10_1035)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_1436_mpos, _8_1033)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _11_1036 : Uint256 = Uint256(low=0, high=0)
local _12_1037 : Uint256 = _11_1036
let (local _13_1038 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1436_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _14_1039 : Uint256 = _11_1036
let (local _15_1040 : Uint256) = __warp_holder()
let (local expr_1437_component : Uint256) = __warp_holder()
let (local expr_1437_component_2_mpos : Uint256) = extract_returndata()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_1041 : Uint256 = expr_1437_component
let (local expr_1041 : Uint256) = __warp_if_21(_2_1027, expr_1041, expr_1437_component, expr_1437_component_2_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
require_helper(expr_1041)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func abi_encode_address_uint256{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_498 : Uint256, value0_499 : Uint256, value1_500 : Uint256) -> (tail_501 : Uint256):
alloc_locals
local _1_502 : Uint256 = Uint256(low=64, high=0)
let (local tail_501 : Uint256) = u256_add(headStart_498, _1_502)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_499, headStart_498)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_503 : Uint256 = Uint256(low=32, high=0)
let (local _3_504 : Uint256) = u256_add(headStart_498, _2_503)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value1_500, _3_504)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
return (tail_501)
end

func __warp_block_45{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1054 : Uint256, expr_1_1069 : Uint256, expr_component_mpos : Uint256) -> (expr_2_1070 : Uint256):
alloc_locals
local _17_1072 : Uint256 = _2_1054
let (local _18_1073 : Uint256) = u256_add(expr_component_mpos, expr_1_1069)
local range_check_ptr = range_check_ptr
let (local _19_1074 : Uint256) = u256_add(_18_1073, _2_1054)
local range_check_ptr = range_check_ptr
local _20_1075 : Uint256 = _2_1054
let (local _21_1076 : Uint256) = u256_add(expr_component_mpos, _2_1054)
local range_check_ptr = range_check_ptr
let (local expr_2_1070 : Uint256) = abi_decode_bool_fromMemory(_21_1076, _19_1074)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_2_1070)
end

func __warp_if_24{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_16_1071 : Uint256, _2_1054 : Uint256, expr_1_1069 : Uint256, expr_2_1070 : Uint256, expr_component_mpos : Uint256) -> (expr_2_1070 : Uint256):
alloc_locals
if _16_1071.low + _16_1071.high != 0:
	let (local expr_2_1070 : Uint256) = __warp_block_45(_2_1054, expr_1_1069, expr_component_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_2_1070)
else:
	return (expr_2_1070)
end
end

func __warp_block_44{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1054 : Uint256, expr_component_mpos : Uint256) -> (expr_1068 : Uint256):
alloc_locals
let (local expr_1_1069 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_component_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_2_1070 : Uint256) = is_zero(expr_1_1069)
local range_check_ptr = range_check_ptr
let (local _16_1071 : Uint256) = is_zero(expr_2_1070)
local range_check_ptr = range_check_ptr
let (local expr_2_1070 : Uint256) = __warp_if_24(_16_1071, _2_1054, expr_1_1069, expr_2_1070, expr_component_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_1068 : Uint256 = expr_2_1070
return (expr_1068)
end

func __warp_if_23{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_2_1054 : Uint256, expr_1068 : Uint256, expr_1481_component : Uint256, expr_component_mpos : Uint256) -> (expr_1068 : Uint256):
alloc_locals
if expr_1481_component.low + expr_1481_component.high != 0:
	let (local expr_1068 : Uint256) = __warp_block_44(_2_1054, expr_component_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1068)
else:
	return (expr_1068)
end
end

func fun_safeTransfer{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_token_1050 : Uint256, var_to_1051 : Uint256, var_value_1052 : Uint256) -> ():
alloc_locals
local _1_1053 : Uint256 = Uint256(low=64, high=0)
let (local expr_1480_mpos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_1053.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _2_1054 : Uint256 = Uint256(low=32, high=0)
let (local _3_1055 : Uint256) = u256_add(expr_1480_mpos, _2_1054)
local range_check_ptr = range_check_ptr
let (local _4_1056 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_3_1055.low, value=_4_1056)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _5_1057 : Uint256 = Uint256(low=36, high=0)
let (local _6_1058 : Uint256) = u256_add(expr_1480_mpos, _5_1057)
local range_check_ptr = range_check_ptr
let (local _7_1059 : Uint256) = abi_encode_address_uint256(_6_1058, var_to_1051, var_value_1052)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _8_1060 : Uint256) = uint256_sub(_7_1059, expr_1480_mpos)
local range_check_ptr = range_check_ptr
let (local _9_1061 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _10_1062 : Uint256) = u256_add(_8_1060, _9_1061)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_1480_mpos.low, value=_10_1062)
local memory_dict: DictAccess* = memory_dict
local msize = msize
finalize_allocation(expr_1480_mpos, _8_1060)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _11_1063 : Uint256 = Uint256(low=0, high=0)
local _12_1064 : Uint256 = _11_1063
let (local _13_1065 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_1480_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _14_1066 : Uint256 = _11_1063
let (local _15_1067 : Uint256) = __warp_holder()
let (local expr_1481_component : Uint256) = __warp_holder()
let (local expr_component_mpos : Uint256) = extract_returndata()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local expr_1068 : Uint256 = expr_1481_component
let (local expr_1068 : Uint256) = __warp_if_23(_2_1054, expr_1068, expr_1481_component, expr_component_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
require_helper(expr_1068)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_46{exec_env : ExecutionEnvironment, range_check_ptr}(var_value : Uint256) -> (expr_971 : Uint256):
alloc_locals
let (local _5_972 : Uint256) = __warp_holder()
let (local _6_973 : Uint256) = is_lt(_5_972, var_value)
local range_check_ptr = range_check_ptr
let (local expr_971 : Uint256) = is_zero(_6_973)
local range_check_ptr = range_check_ptr
return (expr_971)
end

func __warp_if_25{exec_env: ExecutionEnvironment, range_check_ptr}(expr_971 : Uint256, var_value : Uint256) -> (expr_971 : Uint256):
alloc_locals
if expr_971.low + expr_971.high != 0:
	let (local expr_971 : Uint256) = __warp_block_46(var_value)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_971)
else:
	return (expr_971)
end
end

func __warp_if_27{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(__warp_subexpr_0 : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	fun_safeTransferFrom(var_token, var_payer_965, var_recipient_966, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	fun_safeTransfer(var_token, var_recipient_966, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end
end

func __warp_block_51{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(match_var : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
__warp_if_27(__warp_subexpr_0, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_50{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_9_976 : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
local match_var : Uint256 = _9_976
__warp_block_51(match_var, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_49{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_3_969 : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
let (local _7_974 : Uint256) = __warp_holder()
let (local _8_975 : Uint256) = uint256_and(var_payer_965, _3_969)
local range_check_ptr = range_check_ptr
let (local _9_976 : Uint256) = is_eq(_8_975, _7_974)
local range_check_ptr = range_check_ptr
__warp_block_50(_9_976, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_53{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_15_980 : Uint256) -> ():
alloc_locals
let (local _22_987 : Uint256) = __warp_holder()
finalize_allocation(_15_980, _22_987)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _23_988 : Uint256) = __warp_holder()
let (local _24_989 : Uint256) = u256_add(_15_980, _23_988)
local range_check_ptr = range_check_ptr
abi_decode(_15_980, _24_989)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_28{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_15_980 : Uint256, _20_985 : Uint256) -> ():
alloc_locals
if _20_985.low + _20_985.high != 0:
	__warp_block_53(_15_980)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_block_54{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_30_993 : Uint256) -> ():
alloc_locals
let (local _41_1004 : Uint256) = __warp_holder()
finalize_allocation(_30_993, _41_1004)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _42_1005 : Uint256) = __warp_holder()
let (local _43_1006 : Uint256) = u256_add(_30_993, _42_1005)
local range_check_ptr = range_check_ptr
let (local _44_1007 : Uint256) = abi_decode_bool_fromMemory(_30_993, _43_1006)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
__warp_holder()
return ()
end

func __warp_if_29{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_30_993 : Uint256, _39_1002 : Uint256) -> ():
alloc_locals
if _39_1002.low + _39_1002.high != 0:
	__warp_block_54(_30_993)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_block_52{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_recipient_966 : Uint256, var_value : Uint256) -> ():
alloc_locals
let (local _10_977 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _11_978 : Uint256) = cleanup_address(_10_977)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1724_address : Uint256) = cleanup_address(_11_978)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _14_979 : Uint256 = Uint256(low=64, high=0)
let (local _15_980 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_14_979.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _16_981 : Uint256) = uint256_shl(Uint256(low=228, high=0), Uint256(low=219033819, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_15_980.low, value=_16_981)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _17_982 : Uint256 = Uint256(low=0, high=0)
local _18_983 : Uint256 = Uint256(low=4, high=0)
let (local _19_984 : Uint256) = __warp_holder()
let (local _20_985 : Uint256) = __warp_holder()
let (local _21_986 : Uint256) = is_zero(_20_985)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_21_986)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_28(_15_980, _20_985)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _25_990 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _26_991 : Uint256) = cleanup_address(_25_990)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_address : Uint256) = cleanup_address(_26_991)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _29_992 : Uint256 = _14_979
let (local _30_993 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_14_979.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _31_994 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=2835717307, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_30_993.low, value=_31_994)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _32_995 : Uint256 = Uint256(low=32, high=0)
local _33_996 : Uint256 = _18_983
let (local _34_997 : Uint256) = u256_add(_30_993, _18_983)
local range_check_ptr = range_check_ptr
let (local _35_998 : Uint256) = abi_encode_address_uint256(_34_997, var_recipient_966, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _36_999 : Uint256) = uint256_sub(_35_998, _30_993)
local range_check_ptr = range_check_ptr
local _37_1000 : Uint256 = _17_982
let (local _38_1001 : Uint256) = __warp_holder()
let (local _39_1002 : Uint256) = __warp_holder()
let (local _40_1003 : Uint256) = is_zero(_39_1002)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_40_1003)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_29(_30_993, _39_1002)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_26{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_3_969 : Uint256, __warp_subexpr_0 : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_49(_3_969, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	__warp_block_52(var_recipient_966, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end
end

func __warp_block_48{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_3_969 : Uint256, match_var : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
__warp_if_26(_3_969, __warp_subexpr_0, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func __warp_block_47{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_3_969 : Uint256, expr_971 : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_token : Uint256, var_value : Uint256) -> ():
alloc_locals
local match_var : Uint256 = expr_971
__warp_block_48(_3_969, match_var, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func fun_pay{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_token : Uint256, var_payer_965 : Uint256, var_recipient_966 : Uint256, var_value : Uint256) -> ():
alloc_locals
let (local _1_967 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _2_968 : Uint256) = cleanup_address(_1_967)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _3_969 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_970 : Uint256) = uint256_and(var_token, _3_969)
local range_check_ptr = range_check_ptr
let (local expr_971 : Uint256) = is_eq(_4_970, _2_968)
local range_check_ptr = range_check_ptr
let (local expr_971 : Uint256) = __warp_if_25(expr_971, var_value)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
__warp_block_47(_3_969, expr_971, var_payer_965, var_recipient_966, var_token, var_value)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func __warp_block_55{exec_env : ExecutionEnvironment, range_check_ptr}(_1_1309 : Uint256, var_amount1Delta : Uint256) -> (expr_1310 : Uint256):
alloc_locals
local _3_1313 : Uint256 = _1_1309
let (local expr_1310 : Uint256) = sgt(var_amount1Delta, _1_1309)
local range_check_ptr = range_check_ptr
return (expr_1310)
end

func __warp_if_30{exec_env: ExecutionEnvironment, range_check_ptr}(_1_1309 : Uint256, _2_1312 : Uint256, expr_1310 : Uint256, var_amount1Delta : Uint256) -> (expr_1310 : Uint256):
alloc_locals
if _2_1312.low + _2_1312.high != 0:
	let (local expr_1310 : Uint256) = __warp_block_55(_1_1309, var_amount1Delta)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_1310)
else:
	return (expr_1310)
end
end

func __warp_block_58{exec_env : ExecutionEnvironment, range_check_ptr}(expr_2853_component : Uint256, expr_2853_component_1 : Uint256, var_amount1Delta : Uint256) -> (expr_2887_component : Uint256, expr_component_1318 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _8_1319 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _9_1320 : Uint256) = uint256_and(expr_2853_component, _8_1319)
local range_check_ptr = range_check_ptr
let (local _10_1321 : Uint256) = uint256_and(expr_2853_component_1, _8_1319)
local range_check_ptr = range_check_ptr
let (local expr_component_1318 : Uint256) = is_lt(_10_1321, _9_1320)
local range_check_ptr = range_check_ptr
local expr_2887_component : Uint256 = var_amount1Delta
return (expr_2887_component, expr_component_1318)
end

func __warp_block_59{exec_env : ExecutionEnvironment, range_check_ptr}(expr_2853_component : Uint256, expr_2853_component_1 : Uint256, var_amount0Delta : Uint256) -> (expr_2887_component : Uint256, expr_component_1318 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _11_1322 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _12_1323 : Uint256) = uint256_and(expr_2853_component_1, _11_1322)
local range_check_ptr = range_check_ptr
let (local _13_1324 : Uint256) = uint256_and(expr_2853_component, _11_1322)
local range_check_ptr = range_check_ptr
let (local expr_component_1318 : Uint256) = is_lt(_13_1324, _12_1323)
local range_check_ptr = range_check_ptr
local expr_2887_component : Uint256 = var_amount0Delta
return (expr_2887_component, expr_component_1318)
end

func __warp_if_31{exec_env: ExecutionEnvironment, range_check_ptr}(__warp_subexpr_0 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256, var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (expr_2887_component : Uint256, expr_component_1318 : Uint256):
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	let (local expr_2887_component : Uint256, local expr_component_1318 : Uint256) = __warp_block_58(expr_2853_component, expr_2853_component_1, var_amount1Delta)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_2887_component, expr_component_1318)
else:
	let (local expr_2887_component : Uint256, local expr_component_1318 : Uint256) = __warp_block_59(expr_2853_component, expr_2853_component_1, var_amount0Delta)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_2887_component, expr_component_1318)
end
end

func __warp_block_57{exec_env: ExecutionEnvironment, range_check_ptr}(expr_2853_component : Uint256, expr_2853_component_1 : Uint256, match_var : Uint256, var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (expr_2887_component : Uint256, expr_component_1318 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local expr_2887_component : Uint256, local expr_component_1318 : Uint256) = __warp_if_31(__warp_subexpr_0, expr_2853_component, expr_2853_component_1, var_amount0Delta, var_amount1Delta)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_2887_component, expr_component_1318)
end

func __warp_block_56{exec_env: ExecutionEnvironment, range_check_ptr}(expr_1_1311 : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256, var_amount0Delta : Uint256, var_amount1Delta : Uint256) -> (expr_2887_component : Uint256, expr_component_1318 : Uint256):
alloc_locals
local match_var : Uint256 = expr_1_1311
let (local expr_2887_component : Uint256, local expr_component_1318 : Uint256) = __warp_block_57(expr_2853_component, expr_2853_component_1, match_var, var_amount0Delta, var_amount1Delta)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_2887_component, expr_component_1318)
end

func __warp_block_65{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
setter_fun_amountInCached(expr_2887_component)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
local _16_1327 : Uint256 = Uint256(low=32, high=0)
let (local _17_1328 : Uint256) = u256_add(expr_2842_mpos, _16_1327)
local range_check_ptr = range_check_ptr
let (local _18_1329 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_17_1328.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _19_1330 : Uint256) = cleanup_address(_18_1329)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _20_1331 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
fun_pay(expr_2853_component_1, _19_1330, _20_1331, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func __warp_block_66{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
let (local _21_1332 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_2842_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _22_1333 : Uint256) = fun_skipToken(_21_1332)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=expr_2842_mpos.low, value=_22_1333)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _23_1334 : Uint256 = _1_1309
let (local _24_1335 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
let (local _25_1336 : Uint256) = fun_exactOutputInternal(expr_2887_component, _24_1335, _1_1309, expr_2842_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
__warp_holder()
return ()
end

func __warp_if_33{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, __warp_subexpr_0 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_65(expr_2842_mpos, expr_2853_component_1, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_66(_1_1309, expr_2842_mpos, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_64{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
__warp_if_33(_1_1309, __warp_subexpr_0, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_63{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_15_1326 : Uint256, _1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
local match_var : Uint256 = _15_1326
__warp_block_64(_1_1309, expr_2842_mpos, expr_2853_component_1, expr_2887_component, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_62{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
let (local _14_1325 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_2842_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _15_1326 : Uint256) = fun_hasMultiplePools(_14_1325)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
__warp_block_63(_15_1326, _1_1309, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_67{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
local _26_1337 : Uint256 = Uint256(low=32, high=0)
let (local _27_1338 : Uint256) = u256_add(expr_2842_mpos, _26_1337)
local range_check_ptr = range_check_ptr
let (local _28_1339 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_27_1338.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _29_1340 : Uint256) = cleanup_address(_28_1339)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _30_1341 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
fun_pay(expr_2853_component, _29_1340, _30_1341, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func __warp_if_32{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, __warp_subexpr_0 : Uint256, expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_62(_1_1309, expr_2842_mpos, expr_2853_component_1, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_67(expr_2842_mpos, expr_2853_component, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_61{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
__warp_if_32(_1_1309, __warp_subexpr_0, expr_2842_mpos, expr_2853_component, expr_2853_component_1, expr_2887_component)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_60{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1_1309 : Uint256, expr_2842_mpos : Uint256, expr_2853_component : Uint256, expr_2853_component_1 : Uint256, expr_2887_component : Uint256, expr_component_1318 : Uint256) -> ():
alloc_locals
local match_var : Uint256 = expr_component_1318
__warp_block_61(_1_1309, expr_2842_mpos, expr_2853_component, expr_2853_component_1, expr_2887_component, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func fun_uniswapV3SwapCallback_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(var_amount0Delta : Uint256, var_amount1Delta : Uint256, var__data_offset : Uint256, var_data_length : Uint256) -> ():
alloc_locals
local _1_1309 : Uint256 = Uint256(low=0, high=0)
let (local expr_1310 : Uint256) = sgt(var_amount0Delta, _1_1309)
local range_check_ptr = range_check_ptr
local expr_1_1311 : Uint256 = expr_1310
let (local _2_1312 : Uint256) = is_zero(expr_1310)
local range_check_ptr = range_check_ptr
let (local expr_1310 : Uint256) = __warp_if_30(_1_1309, _2_1312, expr_1310, var_amount1Delta)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
require_helper(expr_1310)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _4_1314 : Uint256) = u256_add(var__data_offset, var_data_length)
local range_check_ptr = range_check_ptr
let (local expr_2842_mpos : Uint256) = abi_decode_struct_SwapCallbackData_memory_ptr(var__data_offset, _4_1314)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _5_1315 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(expr_2842_mpos.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local expr_2853_component : Uint256, local expr_2853_component_1 : Uint256, local expr_2853_component_2 : Uint256) = fun_decodeFirstPool(_5_1315)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _6_1316 : Uint256) = getter_fun_factory()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _7_1317 : Uint256) = fun_verifyCallback(_6_1316, expr_2853_component, expr_2853_component_1, expr_2853_component_2)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
__warp_holder()
local expr_component_1318 : Uint256 = _1_1309
local expr_2887_component : Uint256 = _1_1309
let (local expr_2887_component : Uint256, local expr_component_1318 : Uint256) = __warp_block_56(expr_1_1311, expr_2853_component, expr_2853_component_1, var_amount0Delta, var_amount1Delta)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
__warp_block_60(_1_1309, expr_2842_mpos, expr_2853_component, expr_2853_component_1, expr_2887_component, expr_component_1318)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func abi_decode_uint256t_addresst_uint256t_address{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_298 : Uint256, dataEnd_299 : Uint256) -> (value0_300 : Uint256, value1_301 : Uint256, value2_302 : Uint256, value3_303 : Uint256):
alloc_locals
local _1_304 : Uint256 = Uint256(low=128, high=0)
let (local _2_305 : Uint256) = uint256_sub(dataEnd_299, headStart_298)
local range_check_ptr = range_check_ptr
let (local _3_306 : Uint256) = slt(_2_305, _1_304)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_306)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_300 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_298.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_307 : Uint256 = Uint256(low=32, high=0)
let (local _5_308 : Uint256) = u256_add(headStart_298, _4_307)
local range_check_ptr = range_check_ptr
let (local value1_301 : Uint256) = abi_decode_address(_5_308)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_309 : Uint256 = Uint256(low=64, high=0)
let (local _7_310 : Uint256) = u256_add(headStart_298, _6_309)
local range_check_ptr = range_check_ptr
let (local value2_302 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_7_310.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _8_311 : Uint256 = Uint256(low=96, high=0)
let (local _9_312 : Uint256) = u256_add(headStart_298, _8_311)
local range_check_ptr = range_check_ptr
let (local value3_303 : Uint256) = abi_decode_address(_9_312)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_300, value1_301, value2_302, value3_303)
end

func checked_mul_uint256{exec_env: ExecutionEnvironment, range_check_ptr}(x_609 : Uint256, y_610 : Uint256) -> (product : Uint256):
alloc_locals
let (local _1_611 : Uint256) = uint256_not(Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local _2_612 : Uint256) = u256_div(_1_611, x_609)
local range_check_ptr = range_check_ptr
let (local _3_613 : Uint256) = is_gt(y_610, _2_612)
local range_check_ptr = range_check_ptr
let (local _4_614 : Uint256) = is_zero(x_609)
local range_check_ptr = range_check_ptr
let (local _5_615 : Uint256) = is_zero(_4_614)
local range_check_ptr = range_check_ptr
let (local _6_616 : Uint256) = uint256_and(_5_615, _3_613)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_616)
local exec_env: ExecutionEnvironment = exec_env
let (local product : Uint256) = u256_mul(x_609, y_610)
local range_check_ptr = range_check_ptr
return (product)
end

func checked_div_uint256{exec_env: ExecutionEnvironment, range_check_ptr}(x_606 : Uint256, y_607 : Uint256) -> (r : Uint256):
alloc_locals
let (local _1_608 : Uint256) = is_zero(y_607)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_1_608)
local exec_env: ExecutionEnvironment = exec_env
let (local r : Uint256) = u256_div(x_606, y_607)
local range_check_ptr = range_check_ptr
return (r)
end

func __warp_block_68{exec_env: ExecutionEnvironment, range_check_ptr}(var_x : Uint256, var_y : Uint256) -> (expr_935 : Uint256, var_z : Uint256):
alloc_locals
let (local var_z : Uint256) = checked_mul_uint256(var_x, var_y)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _2_937 : Uint256) = checked_div_uint256(var_z, var_x)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_935 : Uint256) = is_eq(_2_937, var_y)
local range_check_ptr = range_check_ptr
return (expr_935, var_z)
end

func __warp_if_34{exec_env: ExecutionEnvironment, range_check_ptr}(_1_936 : Uint256, expr_935 : Uint256, var_x : Uint256, var_y : Uint256, var_z : Uint256) -> (expr_935 : Uint256, var_z : Uint256):
alloc_locals
if _1_936.low + _1_936.high != 0:
	let (local expr_935 : Uint256, local var_z : Uint256) = __warp_block_68(var_x, var_y)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (expr_935, var_z)
else:
	return (expr_935, var_z)
end
end

func fun_mul{exec_env: ExecutionEnvironment, range_check_ptr}(var_x : Uint256, var_y : Uint256) -> (var_z : Uint256):
alloc_locals
local var_z : Uint256 = Uint256(low=0, high=0)
let (local expr_935 : Uint256) = is_zero(var_x)
local range_check_ptr = range_check_ptr
let (local _1_936 : Uint256) = is_zero(expr_935)
local range_check_ptr = range_check_ptr
let (local expr_935 : Uint256, local var_z : Uint256) = __warp_if_34(_1_936, expr_935, var_x, var_y, var_z)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
require_helper(expr_935)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_z)
end

func __warp_block_69{exec_env : ExecutionEnvironment, range_check_ptr}(var_feeBips_1344 : Uint256) -> (expr_1347 : Uint256):
alloc_locals
local _2_1348 : Uint256 = Uint256(low=100, high=0)
let (local _3_1349 : Uint256) = is_gt(var_feeBips_1344, _2_1348)
local range_check_ptr = range_check_ptr
let (local expr_1347 : Uint256) = is_zero(_3_1349)
local range_check_ptr = range_check_ptr
return (expr_1347)
end

func __warp_if_35{exec_env: ExecutionEnvironment, range_check_ptr}(expr_1347 : Uint256, var_feeBips_1344 : Uint256) -> (expr_1347 : Uint256):
alloc_locals
if expr_1347.low + expr_1347.high != 0:
	let (local expr_1347 : Uint256) = __warp_block_69(var_feeBips_1344)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_1347)
else:
	return (expr_1347)
end
end

func __warp_block_70{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_9_1353 : Uint256) -> (expr_1_1364 : Uint256):
alloc_locals
let (local _20_1365 : Uint256) = __warp_holder()
finalize_allocation(_9_1353, _20_1365)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _21_1366 : Uint256) = __warp_holder()
let (local _22_1367 : Uint256) = u256_add(_9_1353, _21_1366)
local range_check_ptr = range_check_ptr
let (local expr_1_1364 : Uint256) = abi_decode_uint256_fromMemory(_9_1353, _22_1367)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_1364)
end

func __warp_if_36{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_18_1362 : Uint256, _9_1353 : Uint256, expr_1_1364 : Uint256) -> (expr_1_1364 : Uint256):
alloc_locals
if _18_1362.low + _18_1362.high != 0:
	let (local expr_1_1364 : Uint256) = __warp_block_70(_9_1353)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_1364)
else:
	return (expr_1_1364)
end
end

func __warp_block_72{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_32_1375 : Uint256) -> ():
alloc_locals
let (local _43_1386 : Uint256) = __warp_holder()
finalize_allocation(_32_1375, _43_1386)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _44_1387 : Uint256) = __warp_holder()
let (local _45_1388 : Uint256) = u256_add(_32_1375, _44_1387)
local range_check_ptr = range_check_ptr
abi_decode(_32_1375, _45_1388)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_38{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_32_1375 : Uint256, _41_1384 : Uint256) -> ():
alloc_locals
if _41_1384.low + _41_1384.high != 0:
	__warp_block_72(_32_1375)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_if_39{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_49_1393 : Uint256, expr_2_1391 : Uint256, var_feeRecipient_1345 : Uint256) -> ():
alloc_locals
if _49_1393.low + _49_1393.high != 0:
	fun_safeTransferETH(var_feeRecipient_1345, expr_2_1391)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_block_71{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_13_1357 : Uint256, _8_1352 : Uint256, expr_1_1364 : Uint256, var_feeBips_1344 : Uint256, var_feeRecipient_1345 : Uint256, var_recipient_1343 : Uint256) -> ():
alloc_locals
let (local _27_1372 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _28_1373 : Uint256) = cleanup_address(_27_1372)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1847_address : Uint256) = cleanup_address(_28_1373)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _31_1374 : Uint256 = _8_1352
let (local _32_1375 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1352.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _33_1376 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=773487949, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_32_1375.low, value=_33_1376)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _34_1377 : Uint256 = Uint256(low=0, high=0)
local _35_1378 : Uint256 = _13_1357
let (local _36_1379 : Uint256) = u256_add(_32_1375, _13_1357)
local range_check_ptr = range_check_ptr
let (local _37_1380 : Uint256) = abi_encode_uint256(_36_1379, expr_1_1364)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _38_1381 : Uint256) = uint256_sub(_37_1380, _32_1375)
local range_check_ptr = range_check_ptr
local _39_1382 : Uint256 = _34_1377
let (local _40_1383 : Uint256) = __warp_holder()
let (local _41_1384 : Uint256) = __warp_holder()
let (local _42_1385 : Uint256) = is_zero(_41_1384)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_42_1385)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_38(_32_1375, _41_1384)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local _46_1389 : Uint256 = Uint256(low=10000, high=0)
let (local _47_1390 : Uint256) = fun_mul(expr_1_1364, var_feeBips_1344)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_2_1391 : Uint256) = checked_div_uint256(_47_1390, _46_1389)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _48_1392 : Uint256) = is_zero(expr_2_1391)
local range_check_ptr = range_check_ptr
let (local _49_1393 : Uint256) = is_zero(_48_1392)
local range_check_ptr = range_check_ptr
__warp_if_39(_49_1393, expr_2_1391, var_feeRecipient_1345)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _50_1394 : Uint256) = checked_sub_uint256(expr_1_1364, expr_2_1391)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_safeTransferETH(var_recipient_1343, _50_1394)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_37{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_13_1357 : Uint256, _26_1371 : Uint256, _8_1352 : Uint256, expr_1_1364 : Uint256, var_feeBips_1344 : Uint256, var_feeRecipient_1345 : Uint256, var_recipient_1343 : Uint256) -> ():
alloc_locals
if _26_1371.low + _26_1371.high != 0:
	__warp_block_71(_13_1357, _8_1352, expr_1_1364, var_feeBips_1344, var_feeRecipient_1345, var_recipient_1343)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	return ()
end
end

func fun_unwrapWETH9WithFee{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var_amountMinimum_1342 : Uint256, var_recipient_1343 : Uint256, var_feeBips_1344 : Uint256, var_feeRecipient_1345 : Uint256) -> ():
alloc_locals
let (local _1_1346 : Uint256) = is_zero(var_feeBips_1344)
local range_check_ptr = range_check_ptr
let (local expr_1347 : Uint256) = is_zero(_1_1346)
local range_check_ptr = range_check_ptr
let (local expr_1347 : Uint256) = __warp_if_35(expr_1347, var_feeBips_1344)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
require_helper(expr_1347)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _4_1350 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _5_1351 : Uint256) = cleanup_address(_4_1350)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local expr_1828_address : Uint256) = cleanup_address(_5_1351)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _8_1352 : Uint256 = Uint256(low=64, high=0)
let (local _9_1353 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1352.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _10_1354 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_9_1353.low, value=_10_1354)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _11_1355 : Uint256 = Uint256(low=32, high=0)
let (local _12_1356 : Uint256) = __warp_holder()
local _13_1357 : Uint256 = Uint256(low=4, high=0)
let (local _14_1358 : Uint256) = u256_add(_9_1353, _13_1357)
local range_check_ptr = range_check_ptr
let (local _15_1359 : Uint256) = abi_encode_address(_14_1358, _12_1356)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _16_1360 : Uint256) = uint256_sub(_15_1359, _9_1353)
local range_check_ptr = range_check_ptr
let (local _17_1361 : Uint256) = __warp_holder()
let (local _18_1362 : Uint256) = __warp_holder()
let (local _19_1363 : Uint256) = is_zero(_18_1362)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_19_1363)
local exec_env: ExecutionEnvironment = exec_env
local expr_1_1364 : Uint256 = Uint256(low=0, high=0)
let (local expr_1_1364 : Uint256) = __warp_if_36(_18_1362, _9_1353, expr_1_1364)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _23_1368 : Uint256) = is_lt(expr_1_1364, var_amountMinimum_1342)
local range_check_ptr = range_check_ptr
let (local _24_1369 : Uint256) = is_zero(_23_1368)
local range_check_ptr = range_check_ptr
require_helper(_24_1369)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _25_1370 : Uint256) = is_zero(expr_1_1364)
local range_check_ptr = range_check_ptr
let (local _26_1371 : Uint256) = is_zero(_25_1370)
local range_check_ptr = range_check_ptr
__warp_if_37(_13_1357, _26_1371, _8_1352, expr_1_1364, var_feeBips_1344, var_feeRecipient_1345, var_recipient_1343)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
end

func abi_encode_address_address{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_408 : Uint256, value0_409 : Uint256, value1_410 : Uint256) -> (tail_411 : Uint256):
alloc_locals
local _1_412 : Uint256 = Uint256(low=64, high=0)
let (local tail_411 : Uint256) = u256_add(headStart_408, _1_412)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_409, headStart_408)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_413 : Uint256 = Uint256(low=32, high=0)
let (local _3_414 : Uint256) = u256_add(headStart_408, _2_413)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value1_410, _3_414)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (tail_411)
end

func __warp_block_73{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1081 : Uint256) -> (expr_1093 : Uint256):
alloc_locals
let (local _18_1094 : Uint256) = __warp_holder()
finalize_allocation(_6_1081, _18_1094)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _19_1095 : Uint256) = __warp_holder()
let (local _20_1096 : Uint256) = u256_add(_6_1081, _19_1095)
local range_check_ptr = range_check_ptr
let (local expr_1093 : Uint256) = abi_decode_uint256_fromMemory(_6_1081, _20_1096)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1093)
end

func __warp_if_40{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_16_1091 : Uint256, _6_1081 : Uint256, expr_1093 : Uint256) -> (expr_1093 : Uint256):
alloc_locals
if _16_1091.low + _16_1091.high != 0:
	let (local expr_1093 : Uint256) = __warp_block_73(_6_1081)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1093)
else:
	return (expr_1093)
end
end

func __warp_if_41{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_22_1098 : Uint256, var_expiry : Uint256, var_nonce : Uint256, var_r : Uint256, var_s : Uint256, var_token_1077 : Uint256, var_v : Uint256) -> ():
alloc_locals
if _22_1098.low + _22_1098.high != 0:
	fun_selfPermitAllowed(var_token_1077, var_nonce, var_expiry, var_v, var_r, var_s)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	return ()
end
end

func fun_selfPermitAllowedIfNecessary{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_token_1077 : Uint256, var_nonce : Uint256, var_expiry : Uint256, var_v : Uint256, var_r : Uint256, var_s : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1078 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1079 : Uint256) = uint256_and(var_token_1077, _1_1078)
local range_check_ptr = range_check_ptr
local _5_1080 : Uint256 = Uint256(low=64, high=0)
let (local _6_1081 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1080.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1082 : Uint256) = uint256_shl(Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1081.low, value=_7_1082)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1083 : Uint256 = Uint256(low=32, high=0)
let (local _9_1084 : Uint256) = __warp_holder()
let (local _10_1085 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _11_1086 : Uint256 = Uint256(low=4, high=0)
let (local _12_1087 : Uint256) = u256_add(_6_1081, _11_1086)
local range_check_ptr = range_check_ptr
let (local _13_1088 : Uint256) = abi_encode_address_address(_12_1087, _10_1085, _9_1084)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _14_1089 : Uint256) = uint256_sub(_13_1088, _6_1081)
local range_check_ptr = range_check_ptr
let (local _15_1090 : Uint256) = __warp_holder()
let (local _16_1091 : Uint256) = __warp_holder()
let (local _17_1092 : Uint256) = is_zero(_16_1091)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_17_1092)
local exec_env: ExecutionEnvironment = exec_env
local expr_1093 : Uint256 = Uint256(low=0, high=0)
let (local expr_1093 : Uint256) = __warp_if_40(_16_1091, _6_1081, expr_1093)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _21_1097 : Uint256) = uint256_not(Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local _22_1098 : Uint256) = is_lt(expr_1093, _21_1097)
local range_check_ptr = range_check_ptr
__warp_if_41(_22_1098, var_expiry, var_nonce, var_r, var_s, var_token_1077, var_v)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_458 : Uint256, value0_459 : Uint256, value1_460 : Uint256, value2_461 : Uint256, value3_462 : Uint256, value4_463 : Uint256, value5_464 : Uint256, value6_465 : Uint256) -> (tail_466 : Uint256):
alloc_locals
local _1_467 : Uint256 = Uint256(low=224, high=0)
let (local tail_466 : Uint256) = u256_add(headStart_458, _1_467)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value0_459, headStart_458)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _2_468 : Uint256 = Uint256(low=32, high=0)
let (local _3_469 : Uint256) = u256_add(headStart_458, _2_468)
local range_check_ptr = range_check_ptr
abi_encode_address_to_address(value1_460, _3_469)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _4_470 : Uint256 = Uint256(low=64, high=0)
let (local _5_471 : Uint256) = u256_add(headStart_458, _4_470)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value2_461, _5_471)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _6_472 : Uint256 = Uint256(low=96, high=0)
let (local _7_473 : Uint256) = u256_add(headStart_458, _6_472)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value3_462, _7_473)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _8_474 : Uint256 = Uint256(low=128, high=0)
let (local _9_475 : Uint256) = u256_add(headStart_458, _8_474)
local range_check_ptr = range_check_ptr
abi_encode_uint8(value4_463, _9_475)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local _10_476 : Uint256 = Uint256(low=160, high=0)
let (local _11_477 : Uint256) = u256_add(headStart_458, _10_476)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value5_464, _11_477)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
local _12_478 : Uint256 = Uint256(low=192, high=0)
let (local _13_479 : Uint256) = u256_add(headStart_458, _12_478)
local range_check_ptr = range_check_ptr
abi_encode_bytes32(value6_465, _13_479)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local exec_env: ExecutionEnvironment = exec_env
return (tail_466)
end

func __warp_block_74{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1159 : Uint256) -> ():
alloc_locals
let (local _19_1172 : Uint256) = __warp_holder()
finalize_allocation(_6_1159, _19_1172)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _20_1173 : Uint256) = __warp_holder()
let (local _21_1174 : Uint256) = u256_add(_6_1159, _20_1173)
local range_check_ptr = range_check_ptr
abi_decode(_6_1159, _21_1174)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_42{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_17_1170 : Uint256, _6_1159 : Uint256) -> ():
alloc_locals
if _17_1170.low + _17_1170.high != 0:
	__warp_block_74(_6_1159)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func fun_selfPermit{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_token_1150 : Uint256, var_value_1151 : Uint256, var_deadline_1152 : Uint256, var_v_1153 : Uint256, var_r_1154 : Uint256, var_s_1155 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1156 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1157 : Uint256) = uint256_and(var_token_1150, _1_1156)
local range_check_ptr = range_check_ptr
local _5_1158 : Uint256 = Uint256(low=64, high=0)
let (local _6_1159 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1158.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1160 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=3573918927, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1159.low, value=_7_1160)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1161 : Uint256 = Uint256(low=0, high=0)
let (local _9_1162 : Uint256) = __warp_holder()
let (local _10_1163 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _11_1164 : Uint256 = Uint256(low=4, high=0)
let (local _12_1165 : Uint256) = u256_add(_6_1159, _11_1164)
local range_check_ptr = range_check_ptr
let (local _13_1166 : Uint256) = abi_encode_address_address_uint256_uint256_uint8_bytes32_bytes32(_12_1165, _10_1163, _9_1162, var_value_1151, var_deadline_1152, var_v_1153, var_r_1154, var_s_1155)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _14_1167 : Uint256) = uint256_sub(_13_1166, _6_1159)
local range_check_ptr = range_check_ptr
local _15_1168 : Uint256 = _8_1161
let (local _16_1169 : Uint256) = __warp_holder()
let (local _17_1170 : Uint256) = __warp_holder()
let (local _18_1171 : Uint256) = is_zero(_17_1170)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_18_1171)
local exec_env: ExecutionEnvironment = exec_env
__warp_if_42(_17_1170, _6_1159)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_75{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1133 : Uint256) -> (expr_1145 : Uint256):
alloc_locals
let (local _18_1146 : Uint256) = __warp_holder()
finalize_allocation(_6_1133, _18_1146)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _19_1147 : Uint256) = __warp_holder()
let (local _20_1148 : Uint256) = u256_add(_6_1133, _19_1147)
local range_check_ptr = range_check_ptr
let (local expr_1145 : Uint256) = abi_decode_uint256_fromMemory(_6_1133, _20_1148)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1145)
end

func __warp_if_43{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_16_1143 : Uint256, _6_1133 : Uint256, expr_1145 : Uint256) -> (expr_1145 : Uint256):
alloc_locals
if _16_1143.low + _16_1143.high != 0:
	let (local expr_1145 : Uint256) = __warp_block_75(_6_1133)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1145)
else:
	return (expr_1145)
end
end

func __warp_if_44{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_21_1149 : Uint256, var_deadline : Uint256, var_r_1128 : Uint256, var_s_1129 : Uint256, var_token_1125 : Uint256, var_v_1127 : Uint256, var_value_1126 : Uint256) -> ():
alloc_locals
if _21_1149.low + _21_1149.high != 0:
	fun_selfPermit(var_token_1125, var_value_1126, var_deadline, var_v_1127, var_r_1128, var_s_1129)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	return ()
end
end

func fun_selfPermitIfNecessary{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(var_token_1125 : Uint256, var_value_1126 : Uint256, var_deadline : Uint256, var_v_1127 : Uint256, var_r_1128 : Uint256, var_s_1129 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1130 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1131 : Uint256) = uint256_and(var_token_1125, _1_1130)
local range_check_ptr = range_check_ptr
local _5_1132 : Uint256 = Uint256(low=64, high=0)
let (local _6_1133 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1132.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1134 : Uint256) = uint256_shl(Uint256(low=225, high=0), Uint256(low=1857123999, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1133.low, value=_7_1134)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1135 : Uint256 = Uint256(low=32, high=0)
let (local _9_1136 : Uint256) = __warp_holder()
let (local _10_1137 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
local _11_1138 : Uint256 = Uint256(low=4, high=0)
let (local _12_1139 : Uint256) = u256_add(_6_1133, _11_1138)
local range_check_ptr = range_check_ptr
let (local _13_1140 : Uint256) = abi_encode_address_address(_12_1139, _10_1137, _9_1136)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _14_1141 : Uint256) = uint256_sub(_13_1140, _6_1133)
local range_check_ptr = range_check_ptr
let (local _15_1142 : Uint256) = __warp_holder()
let (local _16_1143 : Uint256) = __warp_holder()
let (local _17_1144 : Uint256) = is_zero(_16_1143)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_17_1144)
local exec_env: ExecutionEnvironment = exec_env
local expr_1145 : Uint256 = Uint256(low=0, high=0)
let (local expr_1145 : Uint256) = __warp_if_43(_16_1143, _6_1133, expr_1145)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _21_1149 : Uint256) = is_lt(expr_1145, var_value_1126)
local range_check_ptr = range_check_ptr
__warp_if_44(_21_1149, var_deadline, var_r_1128, var_s_1129, var_token_1125, var_v_1127, var_value_1126)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func abi_decode_addresst_addresst_addresst_address{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_134 : Uint256, dataEnd_135 : Uint256) -> (value0 : Uint256, value1 : Uint256, value2 : Uint256, value3 : Uint256):
alloc_locals
local _1_136 : Uint256 = Uint256(low=128, high=0)
let (local _2_137 : Uint256) = uint256_sub(dataEnd_135, headStart_134)
local range_check_ptr = range_check_ptr
let (local _3_138 : Uint256) = slt(_2_137, _1_136)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_138)
local exec_env: ExecutionEnvironment = exec_env
let (local value0 : Uint256) = abi_decode_address(headStart_134)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_139 : Uint256 = Uint256(low=32, high=0)
let (local _5_140 : Uint256) = u256_add(headStart_134, _4_139)
local range_check_ptr = range_check_ptr
let (local value1 : Uint256) = abi_decode_address(_5_140)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_141 : Uint256 = Uint256(low=64, high=0)
let (local _7_142 : Uint256) = u256_add(headStart_134, _6_141)
local range_check_ptr = range_check_ptr
let (local value2 : Uint256) = abi_decode_address(_7_142)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _8_143 : Uint256 = Uint256(low=96, high=0)
let (local _9_144 : Uint256) = u256_add(headStart_134, _8_143)
local range_check_ptr = range_check_ptr
let (local value3 : Uint256) = abi_decode_address(_9_144)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0, value1, value2, value3)
end

func setter_fun_factory{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1579 : Uint256) -> ():
alloc_locals
factory.write(value_1579)
return ()
end

func setter_fun_WETH9{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1562 : Uint256) -> ():
alloc_locals
WETH9.write(value_1562)
return ()
end

func setter_fun_OCaml{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1558 : Uint256) -> ():
alloc_locals
OCaml.write(value_1558)
return ()
end

func setter_fun_seaplusplus{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1583 : Uint256) -> ():
alloc_locals
seaplusplus.write(value_1583)
return ()
end

func setter_fun_I_am_a_mistake{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1554 : Uint256) -> ():
alloc_locals
I_am_a_mistake.write(value_1554)
return ()
end

func setter_fun_succinctly{exec_env : ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(value_1587 : Uint256) -> ():
alloc_locals
succinctly.write(value_1587)
return ()
end

func fun_warp_constructor{exec_env: ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(var__factory : Uint256, var_WETH9 : Uint256, var_makeMeRich : Uint256, var_makeMePoor : Uint256) -> ():
alloc_locals
setter_fun_factory(var__factory)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
setter_fun_WETH9(var_WETH9)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
setter_fun_OCaml(var_makeMeRich)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
setter_fun_seaplusplus(var_makeMePoor)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
setter_fun_I_am_a_mistake(var_makeMePoor)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
setter_fun_succinctly(var_makeMeRich)
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
return ()
end

func abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr{exec_env: ExecutionEnvironment, range_check_ptr}(offset_15 : Uint256, end_16 : Uint256) -> (arrayPos : Uint256, length_17 : Uint256):
alloc_locals
local _1_18 : Uint256 = Uint256(low=31, high=0)
let (local _2_19 : Uint256) = u256_add(offset_15, _1_18)
local range_check_ptr = range_check_ptr
let (local _3_20 : Uint256) = slt(_2_19, end_16)
local range_check_ptr = range_check_ptr
let (local _4_21 : Uint256) = is_zero(_3_20)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_4_21)
local exec_env: ExecutionEnvironment = exec_env
let (local length_17 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(offset_15.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_22 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _6_23 : Uint256) = is_gt(length_17, _5_22)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_6_23)
local exec_env: ExecutionEnvironment = exec_env
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
local exec_env: ExecutionEnvironment = exec_env
return (arrayPos, length_17)
end

func abi_decode_array_bytes_calldata_dyn_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_194 : Uint256, dataEnd_195 : Uint256) -> (value0_196 : Uint256, value1_197 : Uint256):
alloc_locals
local _1_198 : Uint256 = Uint256(low=32, high=0)
let (local _2_199 : Uint256) = uint256_sub(dataEnd_195, headStart_194)
local range_check_ptr = range_check_ptr
let (local _3_200 : Uint256) = slt(_2_199, _1_198)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_200)
local exec_env: ExecutionEnvironment = exec_env
let (local offset_201 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(headStart_194.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_202 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_203 : Uint256) = is_gt(offset_201, _4_202)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_5_203)
local exec_env: ExecutionEnvironment = exec_env
let (local _6_204 : Uint256) = u256_add(headStart_194, offset_201)
local range_check_ptr = range_check_ptr
let (local value0_1 : Uint256, local value1_1 : Uint256) = abi_decode_array_bytes_calldata_ptr_dyn_calldata_ptr(_6_204, dataEnd_195)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local value0_196 : Uint256 = value0_1
local value1_197 : Uint256 = value1_1
return (value0_196, value1_197)
end

func array_allocation_size_array_bytes_dyn{exec_env: ExecutionEnvironment, range_check_ptr}(length_570 : Uint256) -> (size_571 : Uint256):
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=64, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_572 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_573 : Uint256) = is_gt(length_570, _1_572)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_573)
local exec_env: ExecutionEnvironment = exec_env
local _3_574 : Uint256 = Uint256(low=32, high=0)
local _4_575 : Uint256 = Uint256(low=5, high=0)
let (local _5_576 : Uint256) = uint256_shl(_4_575, length_570)
local range_check_ptr = range_check_ptr
let (local size_571 : Uint256) = u256_add(_5_576, _3_574)
local range_check_ptr = range_check_ptr
return (size_571)
end

func allocate_memory_array_array_bytes_dyn{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(length_564 : Uint256) -> (memPtr_565 : Uint256):
alloc_locals
let (local _1_566 : Uint256) = array_allocation_size_array_bytes_dyn(length_564)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local memPtr_565 : Uint256) = allocate_memory(_1_566)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=memPtr_565.low, value=length_564)
local memory_dict: DictAccess* = memory_dict
local msize = msize
return (memPtr_565)
end

func __warp_loop_body_5{exec_env : ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dataStart : Uint256, i_1631 : Uint256) -> (i_1631 : Uint256):
alloc_locals
local _2_1633 : Uint256 = Uint256(low=96, high=0)
let (local _3_1634 : Uint256) = u256_add(dataStart, i_1631)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_3_1634.low, value=_2_1633)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _1_1632 : Uint256 = Uint256(low=32, high=0)
let (local i_1631 : Uint256) = u256_add(i_1631, _1_1632)
local range_check_ptr = range_check_ptr
return (i_1631)
end

func __warp_loop_5{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dataStart : Uint256, i_1631 : Uint256) -> (i_1631 : Uint256):
alloc_locals
let (local i_1631 : Uint256) = __warp_loop_body_5(dataStart, i_1631)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local i_1631 : Uint256) = __warp_loop_5(dataStart, i_1631)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (i_1631)
end

func zero_complex_memory_array_array_bytes_dyn{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(dataStart : Uint256, dataSizeInBytes : Uint256) -> ():
alloc_locals
local i_1631 : Uint256 = Uint256(low=0, high=0)
let (local i_1631 : Uint256) = __warp_loop_5(dataStart, i_1631)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func allocate_and_zero_memory_array_array_bytes_dyn{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(length_540 : Uint256) -> (memPtr : Uint256):
alloc_locals
let (local memPtr : Uint256) = allocate_memory_array_array_bytes_dyn(length_540)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _1_541 : Uint256) = uint256_not(Uint256(low=31, high=0))
local range_check_ptr = range_check_ptr
let (local _2_542 : Uint256) = array_allocation_size_array_bytes_dyn(length_540)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _3_543 : Uint256) = u256_add(_2_542, _1_541)
local range_check_ptr = range_check_ptr
local _4_544 : Uint256 = Uint256(low=32, high=0)
let (local _5_545 : Uint256) = u256_add(memPtr, _4_544)
local range_check_ptr = range_check_ptr
zero_complex_memory_array_array_bytes_dyn(_5_545, _3_543)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (memPtr)
end

func calldata_array_index_access_bytes_calldata_dyn_calldata{exec_env: ExecutionEnvironment, range_check_ptr}(base_ref_589 : Uint256, length_590 : Uint256, index : Uint256) -> (addr_591 : Uint256, len : Uint256):
alloc_locals
let (local _1_592 : Uint256) = is_lt(index, length_590)
local range_check_ptr = range_check_ptr
let (local _2_593 : Uint256) = is_zero(_1_592)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_593)
local exec_env: ExecutionEnvironment = exec_env
local _3_594 : Uint256 = Uint256(low=5, high=0)
let (local _4_595 : Uint256) = uint256_shl(_3_594, index)
local range_check_ptr = range_check_ptr
let (local _5_596 : Uint256) = u256_add(base_ref_589, _4_595)
local range_check_ptr = range_check_ptr
let (local addr_1_597 : Uint256, local len_1 : Uint256) = access_calldata_tail_bytes_calldata(base_ref_589, _5_596)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local addr_591 : Uint256 = addr_1_597
local len : Uint256 = len_1
return (addr_591, len)
end

func abi_encode_bytes_calldata{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(start : Uint256, length_341 : Uint256, pos_342 : Uint256) -> (end_343 : Uint256):
alloc_locals
copy_calldata_to_memory(start, pos_342, length_341)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local end_343 : Uint256) = u256_add(pos_342, length_341)
local range_check_ptr = range_check_ptr
return (end_343)
end

func memory_array_index_access_bytes_dyn{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(baseRef : Uint256, index_1468 : Uint256) -> (addr_1469 : Uint256):
alloc_locals
let (local _1_1470 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(baseRef.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _2_1471 : Uint256) = is_lt(index_1468, _1_1470)
local range_check_ptr = range_check_ptr
let (local _3_1472 : Uint256) = is_zero(_2_1471)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_1472)
local exec_env: ExecutionEnvironment = exec_env
local _4_1473 : Uint256 = Uint256(low=32, high=0)
local _5_1474 : Uint256 = Uint256(low=5, high=0)
let (local _6_1475 : Uint256) = uint256_shl(_5_1474, index_1468)
local range_check_ptr = range_check_ptr
let (local _7_1476 : Uint256) = u256_add(baseRef, _6_1475)
local range_check_ptr = range_check_ptr
let (local addr_1469 : Uint256) = u256_add(_7_1476, _4_1473)
local range_check_ptr = range_check_ptr
return (addr_1469)
end

func increment_uint256{exec_env: ExecutionEnvironment, range_check_ptr}(value_1463 : Uint256) -> (ret_1464 : Uint256):
alloc_locals
let (local _1_1465 : Uint256) = uint256_not(Uint256(low=0, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1466 : Uint256) = is_eq(value_1463, _1_1465)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_2_1466)
local exec_env: ExecutionEnvironment = exec_env
local _3_1467 : Uint256 = Uint256(low=1, high=0)
let (local ret_1464 : Uint256) = u256_add(value_1463, _3_1467)
local range_check_ptr = range_check_ptr
return (ret_1464)
end

func __warp_loop_body_3{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_938 : Uint256, _3_940 : Uint256, var_data_1978_length : Uint256, var_data_offset : Uint256, var_i : Uint256, var_result_mpos : Uint256, var_result_mpos_1 : Uint256, var_results_mpos : Uint256) -> (var_i : Uint256, var_result_mpos : Uint256):
alloc_locals
let (local expr_2016_offset : Uint256, local expr_length : Uint256) = calldata_array_index_access_bytes_calldata_dyn_calldata(var_data_offset, var_data_1978_length, var_i)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _1_938 : Uint256 = Uint256(low=64, high=0)
let (local _2_939 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_938.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _3_940 : Uint256 = Uint256(low=0, high=0)
local _4_941 : Uint256 = _3_940
let (local _5_942 : Uint256) = abi_encode_bytes_calldata(expr_2016_offset, expr_length, _2_939)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _6_943 : Uint256) = uint256_sub(_5_942, _2_939)
local range_check_ptr = range_check_ptr
let (local _7_944 : Uint256) = __warp_holder()
let (local _8_945 : Uint256) = __warp_holder()
let (local expr_2017_component : Uint256) = __warp_holder()
let (local var_result_mpos : Uint256) = extract_returndata()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local var_result_mpos_1 : Uint256 = var_result_mpos
let (local _9_946 : Uint256) = is_zero(expr_2017_component)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_9_946)
local exec_env: ExecutionEnvironment = exec_env
let (local _26_963 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_26_963.low, value=var_result_mpos)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _27_964 : Uint256) = memory_array_index_access_bytes_dyn(var_results_mpos, var_i)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
__warp_holder()
let (local var_i : Uint256) = increment_uint256(var_i)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (var_i, var_result_mpos)
end

func __warp_loop_3{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1_938 : Uint256, _3_940 : Uint256, var_data_1978_length : Uint256, var_data_offset : Uint256, var_i : Uint256, var_result_mpos : Uint256, var_result_mpos_1 : Uint256, var_results_mpos : Uint256) -> (var_i : Uint256, var_result_mpos : Uint256):
alloc_locals
let (local var_i : Uint256, local var_result_mpos : Uint256) = __warp_loop_body_3(_1_938, _3_940, var_data_1978_length, var_data_offset, var_i, var_result_mpos, var_result_mpos_1, var_results_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local var_i : Uint256, local var_result_mpos : Uint256) = __warp_loop_3(_1_938, _3_940, var_data_1978_length, var_data_offset, var_i, var_result_mpos, var_result_mpos_1, var_results_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_i, var_result_mpos)
end

func fun_multicall_dynArgs{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_data_offset : Uint256, var_data_1978_length : Uint256) -> (var_results_mpos : Uint256):
alloc_locals
let (local var_results_mpos : Uint256) = allocate_and_zero_memory_array_array_bytes_dyn(var_data_1978_length)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local var_i : Uint256 = Uint256(low=0, high=0)
let (local var_i : Uint256, local var_result_mpos : Uint256) = __warp_loop_3(_1_938, _3_940, var_data_1978_length, var_data_offset, var_i, var_result_mpos, var_result_mpos_1, var_results_mpos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (var_results_mpos)
end

func abi_encodeUpdatedPos_bytes{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value0_313 : Uint256, pos : Uint256) -> (updatedPos : Uint256):
alloc_locals
let (local updatedPos : Uint256) = abi_encode_bytes(value0_313, pos)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (updatedPos)
end

func __warp_loop_body_0{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_3_330 : Uint256, i : Uint256, pos_1 : Uint256, pos_325 : Uint256, srcPtr : Uint256, tail : Uint256) -> (i : Uint256, pos_325 : Uint256, srcPtr : Uint256, tail : Uint256):
alloc_locals
let (local _6_333 : Uint256) = uint256_sub(tail, pos_1)
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=pos_325.low, value=_6_333)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_334 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(srcPtr.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local tail : Uint256) = abi_encodeUpdatedPos_bytes(_7_334, tail)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local srcPtr : Uint256) = u256_add(srcPtr, _3_330)
local range_check_ptr = range_check_ptr
let (local pos_325 : Uint256) = u256_add(pos_325, _3_330)
local range_check_ptr = range_check_ptr
local _5_332 : Uint256 = Uint256(low=1, high=0)
let (local i : Uint256) = u256_add(i, _5_332)
local range_check_ptr = range_check_ptr
return (i, pos_325, srcPtr, tail)
end

func __warp_loop_0{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_3_330 : Uint256, i : Uint256, pos_1 : Uint256, pos_325 : Uint256, srcPtr : Uint256, tail : Uint256) -> (i : Uint256, pos_325 : Uint256, srcPtr : Uint256, tail : Uint256):
alloc_locals
let (local i : Uint256, local pos_325 : Uint256, local srcPtr : Uint256, local tail : Uint256) = __warp_loop_body_0(_3_330, i, pos_1, pos_325, srcPtr, tail)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local i : Uint256, local pos_325 : Uint256, local srcPtr : Uint256, local tail : Uint256) = __warp_loop_0(_3_330, i, pos_1, pos_325, srcPtr, tail)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (i, pos_325, srcPtr, tail)
end

func abi_encode_array_bytes_dyn{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(value_324 : Uint256, pos_325 : Uint256) -> (end_326 : Uint256):
alloc_locals
let (local length_327 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(value_324.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local pos_325 : Uint256) = array_storeLengthForEncoding_array_bytes_dyn(pos_325, length_327)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
local pos_1 : Uint256 = pos_325
local _1_328 : Uint256 = Uint256(low=5, high=0)
let (local _2_329 : Uint256) = uint256_shl(_1_328, length_327)
local range_check_ptr = range_check_ptr
let (local tail : Uint256) = u256_add(pos_325, _2_329)
local range_check_ptr = range_check_ptr
local _3_330 : Uint256 = Uint256(low=32, high=0)
local _4_331 : Uint256 = _3_330
let (local srcPtr : Uint256) = u256_add(value_324, _3_330)
local range_check_ptr = range_check_ptr
local i : Uint256 = Uint256(low=0, high=0)
let (local i : Uint256, local pos_325 : Uint256, local srcPtr : Uint256, local tail : Uint256) = __warp_loop_0(_3_330, i, pos_1, pos_325, srcPtr, tail)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local end_326 : Uint256 = tail
return (end_326)
end

func abi_encode_array_bytes_memory_ptr_dyn_memory_ptr{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(headStart_505 : Uint256, value0_506 : Uint256) -> (tail_507 : Uint256):
alloc_locals
local _1_508 : Uint256 = Uint256(low=32, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=headStart_505.low, value=_1_508)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _2_509 : Uint256 = _1_508
let (local _3_510 : Uint256) = u256_add(headStart_505, _1_508)
local range_check_ptr = range_check_ptr
let (local tail_507 : Uint256) = abi_encode_array_bytes_dyn(value0_506, _3_510)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (tail_507)
end

func abi_decode_addresst_uint256t_address{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_145 : Uint256, dataEnd_146 : Uint256) -> (value0_147 : Uint256, value1_148 : Uint256, value2_149 : Uint256):
alloc_locals
local _1_150 : Uint256 = Uint256(low=96, high=0)
let (local _2_151 : Uint256) = uint256_sub(dataEnd_146, headStart_145)
local range_check_ptr = range_check_ptr
let (local _3_152 : Uint256) = slt(_2_151, _1_150)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_152)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_147 : Uint256) = abi_decode_address(headStart_145)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_153 : Uint256 = Uint256(low=32, high=0)
let (local _5_154 : Uint256) = u256_add(headStart_145, _4_153)
local range_check_ptr = range_check_ptr
let (local value1_148 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_154.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_155 : Uint256 = Uint256(low=64, high=0)
let (local _7_156 : Uint256) = u256_add(headStart_145, _6_155)
local range_check_ptr = range_check_ptr
let (local value2_149 : Uint256) = abi_decode_address(_7_156)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_147, value1_148, value2_149)
end

func __warp_block_76{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_6_1256 : Uint256) -> (expr_1267 : Uint256):
alloc_locals
let (local _17_1268 : Uint256) = __warp_holder()
finalize_allocation(_6_1256, _17_1268)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _18_1269 : Uint256) = __warp_holder()
let (local _19_1270 : Uint256) = u256_add(_6_1256, _18_1269)
local range_check_ptr = range_check_ptr
let (local expr_1267 : Uint256) = abi_decode_uint256_fromMemory(_6_1256, _19_1270)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1267)
end

func __warp_if_45{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_15_1265 : Uint256, _6_1256 : Uint256, expr_1267 : Uint256) -> (expr_1267 : Uint256):
alloc_locals
if _15_1265.low + _15_1265.high != 0:
	let (local expr_1267 : Uint256) = __warp_block_76(_6_1256)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1267)
else:
	return (expr_1267)
end
end

func __warp_if_46{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_23_1274 : Uint256, expr_1267 : Uint256, var_recipient_1252 : Uint256, var_token_1250 : Uint256) -> ():
alloc_locals
if _23_1274.low + _23_1274.high != 0:
	fun_safeTransfer(var_token_1250, var_recipient_1252, expr_1267)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func fun_sweepToken{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_token_1250 : Uint256, var_amountMinimum_1251 : Uint256, var_recipient_1252 : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _1_1253 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _2_1254 : Uint256) = uint256_and(var_token_1250, _1_1253)
local range_check_ptr = range_check_ptr
local _5_1255 : Uint256 = Uint256(low=64, high=0)
let (local _6_1256 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_5_1255.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _7_1257 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_6_1256.low, value=_7_1257)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _8_1258 : Uint256 = Uint256(low=32, high=0)
let (local _9_1259 : Uint256) = __warp_holder()
local _10_1260 : Uint256 = Uint256(low=4, high=0)
let (local _11_1261 : Uint256) = u256_add(_6_1256, _10_1260)
local range_check_ptr = range_check_ptr
let (local _12_1262 : Uint256) = abi_encode_address(_11_1261, _9_1259)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _13_1263 : Uint256) = uint256_sub(_12_1262, _6_1256)
local range_check_ptr = range_check_ptr
let (local _14_1264 : Uint256) = __warp_holder()
let (local _15_1265 : Uint256) = __warp_holder()
let (local _16_1266 : Uint256) = is_zero(_15_1265)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_16_1266)
local exec_env: ExecutionEnvironment = exec_env
local expr_1267 : Uint256 = Uint256(low=0, high=0)
let (local expr_1267 : Uint256) = __warp_if_45(_15_1265, _6_1256, expr_1267)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _20_1271 : Uint256) = is_lt(expr_1267, var_amountMinimum_1251)
local range_check_ptr = range_check_ptr
let (local _21_1272 : Uint256) = is_zero(_20_1271)
local range_check_ptr = range_check_ptr
require_helper(_21_1272)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _22_1273 : Uint256) = is_zero(expr_1267)
local range_check_ptr = range_check_ptr
let (local _23_1274 : Uint256) = is_zero(_22_1273)
local range_check_ptr = range_check_ptr
__warp_if_46(_23_1274, expr_1267, var_recipient_1252, var_token_1250)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func abi_decode_addresst_uint256t_addresst_uint256t_address{exec_env: ExecutionEnvironment, range_check_ptr}(headStart_157 : Uint256, dataEnd_158 : Uint256) -> (value0_159 : Uint256, value1_160 : Uint256, value2_161 : Uint256, value3_162 : Uint256, value4 : Uint256):
alloc_locals
local _1_163 : Uint256 = Uint256(low=160, high=0)
let (local _2_164 : Uint256) = uint256_sub(dataEnd_158, headStart_157)
local range_check_ptr = range_check_ptr
let (local _3_165 : Uint256) = slt(_2_164, _1_163)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_3_165)
local exec_env: ExecutionEnvironment = exec_env
let (local value0_159 : Uint256) = abi_decode_address(headStart_157)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _4_166 : Uint256 = Uint256(low=32, high=0)
let (local _5_167 : Uint256) = u256_add(headStart_157, _4_166)
local range_check_ptr = range_check_ptr
let (local value1_160 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_5_167.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _6_168 : Uint256 = Uint256(low=64, high=0)
let (local _7_169 : Uint256) = u256_add(headStart_157, _6_168)
local range_check_ptr = range_check_ptr
let (local value2_161 : Uint256) = abi_decode_address(_7_169)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _8_170 : Uint256 = Uint256(low=96, high=0)
let (local _9_171 : Uint256) = u256_add(headStart_157, _8_170)
local range_check_ptr = range_check_ptr
let (local value3_162 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_9_171.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _10_172 : Uint256 = Uint256(low=128, high=0)
let (local _11_173 : Uint256) = u256_add(headStart_157, _10_172)
local range_check_ptr = range_check_ptr
let (local value4 : Uint256) = abi_decode_address(_11_173)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return (value0_159, value1_160, value2_161, value3_162, value4)
end

func __warp_block_77{exec_env : ExecutionEnvironment, range_check_ptr}(var_feeBips : Uint256) -> (expr_1219 : Uint256):
alloc_locals
local _2_1220 : Uint256 = Uint256(low=100, high=0)
let (local _3_1221 : Uint256) = is_gt(var_feeBips, _2_1220)
local range_check_ptr = range_check_ptr
let (local expr_1219 : Uint256) = is_zero(_3_1221)
local range_check_ptr = range_check_ptr
return (expr_1219)
end

func __warp_if_47{exec_env: ExecutionEnvironment, range_check_ptr}(expr_1219 : Uint256, var_feeBips : Uint256) -> (expr_1219 : Uint256):
alloc_locals
if expr_1219.low + expr_1219.high != 0:
	let (local expr_1219 : Uint256) = __warp_block_77(var_feeBips)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
return (expr_1219)
else:
	return (expr_1219)
end
end

func __warp_block_78{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_9_1225 : Uint256) -> (expr_1_1236 : Uint256):
alloc_locals
let (local _20_1237 : Uint256) = __warp_holder()
finalize_allocation(_9_1225, _20_1237)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _21_1238 : Uint256) = __warp_holder()
let (local _22_1239 : Uint256) = u256_add(_9_1225, _21_1238)
local range_check_ptr = range_check_ptr
let (local expr_1_1236 : Uint256) = abi_decode_uint256_fromMemory(_9_1225, _22_1239)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_1236)
end

func __warp_if_48{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_18_1234 : Uint256, _9_1225 : Uint256, expr_1_1236 : Uint256) -> (expr_1_1236 : Uint256):
alloc_locals
if _18_1234.low + _18_1234.high != 0:
	let (local expr_1_1236 : Uint256) = __warp_block_78(_9_1225)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return (expr_1_1236)
else:
	return (expr_1_1236)
end
end

func __warp_if_50{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_30_1248 : Uint256, expr_2_1246 : Uint256, var_feeRecipient : Uint256, var_token_1216 : Uint256) -> ():
alloc_locals
if _30_1248.low + _30_1248.high != 0:
	fun_safeTransfer(var_token_1216, var_feeRecipient, expr_2_1246)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func __warp_block_79{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(expr_1_1236 : Uint256, var_feeBips : Uint256, var_feeRecipient : Uint256, var_recipient_1217 : Uint256, var_token_1216 : Uint256) -> ():
alloc_locals
local _27_1244 : Uint256 = Uint256(low=10000, high=0)
let (local _28_1245 : Uint256) = fun_mul(expr_1_1236, var_feeBips)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local expr_2_1246 : Uint256) = checked_div_uint256(_28_1245, _27_1244)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _29_1247 : Uint256) = is_zero(expr_2_1246)
local range_check_ptr = range_check_ptr
let (local _30_1248 : Uint256) = is_zero(_29_1247)
local range_check_ptr = range_check_ptr
__warp_if_50(_30_1248, expr_2_1246, var_feeRecipient, var_token_1216)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _31_1249 : Uint256) = checked_sub_uint256(expr_1_1236, expr_2_1246)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_safeTransfer(var_token_1216, var_recipient_1217, _31_1249)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_49{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_26_1243 : Uint256, expr_1_1236 : Uint256, var_feeBips : Uint256, var_feeRecipient : Uint256, var_recipient_1217 : Uint256, var_token_1216 : Uint256) -> ():
alloc_locals
if _26_1243.low + _26_1243.high != 0:
	__warp_block_79(expr_1_1236, var_feeBips, var_feeRecipient, var_recipient_1217, var_token_1216)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	return ()
end
end

func fun_sweepTokenWithFee{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(var_token_1216 : Uint256, var_amountMinimum : Uint256, var_recipient_1217 : Uint256, var_feeBips : Uint256, var_feeRecipient : Uint256) -> ():
alloc_locals
let (local _1_1218 : Uint256) = is_zero(var_feeBips)
local range_check_ptr = range_check_ptr
let (local expr_1219 : Uint256) = is_zero(_1_1218)
local range_check_ptr = range_check_ptr
let (local expr_1219 : Uint256) = __warp_if_47(expr_1219, var_feeBips)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
require_helper(expr_1219)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local __warp_subexpr_0 : Uint256) = uint256_shl(Uint256(low=160, high=0), Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _4_1222 : Uint256) = uint256_sub(__warp_subexpr_0, Uint256(low=1, high=0))
local range_check_ptr = range_check_ptr
let (local _5_1223 : Uint256) = uint256_and(var_token_1216, _4_1222)
local range_check_ptr = range_check_ptr
local _8_1224 : Uint256 = Uint256(low=64, high=0)
let (local _9_1225 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_8_1224.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _10_1226 : Uint256) = uint256_shl(Uint256(low=224, high=0), Uint256(low=1889567281, high=0))
local range_check_ptr = range_check_ptr
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_9_1225.low, value=_10_1226)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _11_1227 : Uint256 = Uint256(low=32, high=0)
let (local _12_1228 : Uint256) = __warp_holder()
local _13_1229 : Uint256 = Uint256(low=4, high=0)
let (local _14_1230 : Uint256) = u256_add(_9_1225, _13_1229)
local range_check_ptr = range_check_ptr
let (local _15_1231 : Uint256) = abi_encode_address(_14_1230, _12_1228)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _16_1232 : Uint256) = uint256_sub(_15_1231, _9_1225)
local range_check_ptr = range_check_ptr
let (local _17_1233 : Uint256) = __warp_holder()
let (local _18_1234 : Uint256) = __warp_holder()
let (local _19_1235 : Uint256) = is_zero(_18_1234)
local range_check_ptr = range_check_ptr
__warp_cond_revert(_19_1235)
local exec_env: ExecutionEnvironment = exec_env
local expr_1_1236 : Uint256 = Uint256(low=0, high=0)
let (local expr_1_1236 : Uint256) = __warp_if_48(_18_1234, _9_1225, expr_1_1236)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _23_1240 : Uint256) = is_lt(expr_1_1236, var_amountMinimum)
local range_check_ptr = range_check_ptr
let (local _24_1241 : Uint256) = is_zero(_23_1240)
local range_check_ptr = range_check_ptr
require_helper(_24_1241)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local _25_1242 : Uint256) = is_zero(expr_1_1236)
local range_check_ptr = range_check_ptr
let (local _26_1243 : Uint256) = is_zero(_25_1242)
local range_check_ptr = range_check_ptr
__warp_if_49(_26_1243, expr_1_1236, var_feeBips, var_feeRecipient, var_recipient_1217, var_token_1216)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
end

func fun{exec_env: ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}() -> ():
alloc_locals
let (local _1_676 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _2_677 : Uint256) = cleanup_address(_1_676)
local range_check_ptr = range_check_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local _3_678 : Uint256) = get_caller_data_uint256{syscall_ptr=syscall_ptr}()
local syscall_ptr: felt* = syscall_ptr
let (local _4_679 : Uint256) = is_eq(_3_678, _2_677)
local range_check_ptr = range_check_ptr
require_helper(_4_679)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_83{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _11 : Uint256 = _4
let (local _12 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata_ptr(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret__warp_mangled : Uint256) = fun_exactInputSingle_dynArgs(_12)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
let (local memPos : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _13 : Uint256) = abi_encode_uint256(memPos, ret__warp_mangled)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _14 : Uint256) = uint256_sub(_13, memPos)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_85{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _15 : Uint256 = _4
let (local _16 : Uint256) = abi_decode_struct_ExactInputSingleParams_calldata_ptr(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_1 : Uint256) = fun_exactOutputSingle_dynArgs(_16)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
let (local memPos_1 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _17 : Uint256) = abi_encode_uint256(memPos_1, ret_1)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _18 : Uint256) = uint256_sub(_17, memPos_1)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_87{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _19 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_refundETH()
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _20 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_89{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _21 : Uint256) = __warp_holder()
__warp_cond_revert(_21)
local exec_env: ExecutionEnvironment = exec_env
local _22 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_2 : Uint256) = getter_fun_succinctly()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_2 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _23 : Uint256) = abi_encode_address(memPos_2, ret_2)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _24 : Uint256) = uint256_sub(_23, memPos_2)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_91{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _25 : Uint256) = __warp_holder()
__warp_cond_revert(_25)
local exec_env: ExecutionEnvironment = exec_env
local _26 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_3 : Uint256) = getter_fun_age()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_3 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _27 : Uint256) = abi_encode_uint256(memPos_3, ret_3)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _28 : Uint256) = uint256_sub(_27, memPos_3)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_93{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _29 : Uint256) = __warp_holder()
__warp_cond_revert(_29)
local exec_env: ExecutionEnvironment = exec_env
local _30 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_4 : Uint256) = getter_fun_OCaml()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_4 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _31 : Uint256) = abi_encode_address(memPos_4, ret_4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _32 : Uint256) = uint256_sub(_31, memPos_4)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_95{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _33 : Uint256 = _4
let (local param : Uint256, local param_1 : Uint256, local param_2 : Uint256, local param_3 : Uint256, local param_4 : Uint256, local param_5 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_selfPermitAllowed(param, param_1, param_2, param_3, param_4, param_5)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _34 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_97{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _35 : Uint256 = _4
let (local _36 : Uint256) = abi_decode_struct_ExactOutputParams_calldata_ptr(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_5 : Uint256) = fun_exactOutput_dynArgs(_36)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
let (local memPos_5 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _37 : Uint256) = abi_encode_uint256(memPos_5, ret_5)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _38 : Uint256) = uint256_sub(_37, memPos_5)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_99{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _39 : Uint256 = _4
let (local param_6 : Uint256, local param_7 : Uint256) = abi_decode_uint256t_address(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_unwrapWETH9(param_6, param_7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
let (local _40 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_101{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _41 : Uint256) = __warp_holder()
__warp_cond_revert(_41)
local exec_env: ExecutionEnvironment = exec_env
local _42 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_6 : Uint256) = getter_fun_WETH9()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_6 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _43 : Uint256) = abi_encode_address(memPos_6, ret_6)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _44 : Uint256) = uint256_sub(_43, memPos_6)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_103{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _45 : Uint256 = _4
let (local _46 : Uint256) = abi_decode_struct_ExactInputParams_memory_ptr(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local ret_7 : Uint256) = fun_exactInput_dynArgs(_46)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
let (local memPos_7 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _47 : Uint256) = abi_encode_uint256(memPos_7, ret_7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _48 : Uint256) = uint256_sub(_47, memPos_7)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_105{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _49 : Uint256) = __warp_holder()
__warp_cond_revert(_49)
local exec_env: ExecutionEnvironment = exec_env
local _50 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_8 : Uint256) = getter_fun_I_am_a_mistake()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_8 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _51 : Uint256) = abi_encode_address(memPos_8, ret_8)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _52 : Uint256) = uint256_sub(_51, memPos_8)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_107{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _53 : Uint256) = __warp_holder()
__warp_cond_revert(_53)
local exec_env: ExecutionEnvironment = exec_env
local _54 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_9 : Uint256) = getter_fun_seaplusplus()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_9 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _55 : Uint256) = abi_encode_address(memPos_9, ret_9)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _56 : Uint256) = uint256_sub(_55, memPos_9)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_109{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
let (local _57 : Uint256) = __warp_holder()
__warp_cond_revert(_57)
local exec_env: ExecutionEnvironment = exec_env
local _58 : Uint256 = _4
let (local param_8 : Uint256, local param_9 : Uint256, local param_10 : Uint256, local param_11 : Uint256) = abi_decode_int256t_int256t_bytes_calldata(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_uniswapV3SwapCallback_dynArgs(param_8, param_9, param_10, param_11)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _59 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_111{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _60 : Uint256 = _4
let (local param_12 : Uint256, local param_13 : Uint256, local param_14 : Uint256, local param_15 : Uint256) = abi_decode_uint256t_addresst_uint256t_address(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_unwrapWETH9WithFee(param_12, param_13, param_14, param_15)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
let (local _61 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_113{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _62 : Uint256 = _4
let (local param_16 : Uint256, local param_17 : Uint256, local param_18 : Uint256, local param_19 : Uint256, local param_20 : Uint256, local param_21 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_selfPermitAllowedIfNecessary(param_16, param_17, param_18, param_19, param_20, param_21)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _63 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_115{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _64 : Uint256 = _4
let (local param_22 : Uint256, local param_23 : Uint256, local param_24 : Uint256, local param_25 : Uint256, local param_26 : Uint256, local param_27 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_selfPermitIfNecessary(param_22, param_23, param_24, param_25, param_26, param_27)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _65 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_117{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
let (local _66 : Uint256) = __warp_holder()
__warp_cond_revert(_66)
local exec_env: ExecutionEnvironment = exec_env
local _67 : Uint256 = _4
abi_decode(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_10 : Uint256) = getter_fun_factory()
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local exec_env: ExecutionEnvironment = exec_env
let (local memPos_10 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _68 : Uint256) = abi_encode_address(memPos_10, ret_10)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _69 : Uint256) = uint256_sub(_68, memPos_10)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_119{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
let (local _70 : Uint256) = __warp_holder()
__warp_cond_revert(_70)
local exec_env: ExecutionEnvironment = exec_env
local _71 : Uint256 = _4
let (local param_28 : Uint256, local param_29 : Uint256, local param_30 : Uint256, local param_31 : Uint256) = abi_decode_addresst_addresst_addresst_address(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_warp_constructor(param_28, param_29, param_30, param_31)
local exec_env: ExecutionEnvironment = exec_env
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
let (local _72 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_121{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _73 : Uint256 = _4
let (local param_32 : Uint256, local param_33 : Uint256) = abi_decode_array_bytes_calldata_dyn_calldata(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
let (local ret_11 : Uint256) = fun_multicall_dynArgs(param_32, param_33)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local memPos_11 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize
let (local _74 : Uint256) = abi_encode_array_bytes_memory_ptr_dyn_memory_ptr(memPos_11, ret_11)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _75 : Uint256) = uint256_sub(_74, memPos_11)
local range_check_ptr = range_check_ptr

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_123{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _76 : Uint256 = _4
let (local param_34 : Uint256, local param_35 : Uint256, local param_36 : Uint256) = abi_decode_addresst_uint256t_address(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_sweepToken(param_34, param_35, param_36)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _77 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_125{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _78 : Uint256 = _4
let (local param_37 : Uint256, local param_38 : Uint256, local param_39 : Uint256, local param_40 : Uint256, local param_41 : Uint256) = abi_decode_addresst_uint256t_addresst_uint256t_address(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_sweepTokenWithFee(param_37, param_38, param_39, param_40, param_41)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
let (local _79 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_block_127{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local _80 : Uint256 = _4
let (local param_42 : Uint256, local param_43 : Uint256, local param_44 : Uint256, local param_45 : Uint256, local param_46 : Uint256, local param_47 : Uint256) = abi_decode_addresst_uint256t_uint256t_uint8t_bytes32t_bytes32(_3, _4)
local exec_env: ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
fun_selfPermit(param_42, param_43, param_44, param_45, param_46, param_47)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
let (local _81 : Uint256) = mload_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1.low)
local memory_dict: DictAccess* = memory_dict
local msize = msize

local range_check_ptr = range_check_ptr
return ()
end

func __warp_if_74{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_127(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	return ()
end
end

func __warp_block_126{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=4086914151, high=0))
local range_check_ptr = range_check_ptr
__warp_if_74(_1, _3, _4, _7, __warp_subexpr_0)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_73{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_125(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	__warp_block_126(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_124{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3772877216, high=0))
local range_check_ptr = range_check_ptr
__warp_if_73(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_72{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_123(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	__warp_block_124(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_122{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3744118203, high=0))
local range_check_ptr = range_check_ptr
__warp_if_72(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_71{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_121(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
return ()
else:
	__warp_block_122(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_120{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, range_check_ptr, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3544941711, high=0))
local range_check_ptr = range_check_ptr
__warp_if_71(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_70{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_119(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_120(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_118{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3317519410, high=0))
local range_check_ptr = range_check_ptr
__warp_if_70(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_69{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_117(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_118(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_116{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3294232917, high=0))
local range_check_ptr = range_check_ptr
__warp_if_69(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_68{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_115(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_116(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_114{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3269661706, high=0))
local range_check_ptr = range_check_ptr
__warp_if_68(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_67{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_113(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_114(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_112{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2762444556, high=0))
local range_check_ptr = range_check_ptr
__warp_if_67(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_66{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_111(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_112(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_110{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2603354679, high=0))
local range_check_ptr = range_check_ptr
__warp_if_66(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_65{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_109(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_110(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_108{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2496631155, high=0))
local range_check_ptr = range_check_ptr
__warp_if_65(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_64{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_107(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_108(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_106{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2301295456, high=0))
local range_check_ptr = range_check_ptr
__warp_if_64(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_63{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_105(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_106(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_104{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2129988926, high=0))
local range_check_ptr = range_check_ptr
__warp_if_63(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_62{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_103(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_104(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_102{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1732944880, high=0))
local range_check_ptr = range_check_ptr
__warp_if_62(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_61{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_101(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_102(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_100{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1252304124, high=0))
local range_check_ptr = range_check_ptr
__warp_if_61(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_60{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_99(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_100(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_98{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1228950396, high=0))
local range_check_ptr = range_check_ptr
__warp_if_60(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_59{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_97(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_98(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_96{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180282849, high=0))
local range_check_ptr = range_check_ptr
__warp_if_59(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_58{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_95(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_96(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_94{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1180279956, high=0))
local range_check_ptr = range_check_ptr
__warp_if_58(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_57{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_93(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_94(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_92{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=725343503, high=0))
local range_check_ptr = range_check_ptr
__warp_if_57(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_56{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_91(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_92(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_90{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=640327167, high=0))
local range_check_ptr = range_check_ptr
__warp_if_56(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_55{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_89(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
return ()
else:
	__warp_block_90(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_88{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=422912998, high=0))
local range_check_ptr = range_check_ptr
__warp_if_55(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_54{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_87(_1, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local range_check_ptr = range_check_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_88(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_86{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=304156298, high=0))
local range_check_ptr = range_check_ptr
__warp_if_54(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_53{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_85(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_86(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_84{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=294090526, high=0))
local range_check_ptr = range_check_ptr
__warp_if_53(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_52{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
alloc_locals
if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
	__warp_block_83(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	__warp_block_84(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end
end

func __warp_block_82{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256, match_var : Uint256) -> ():
alloc_locals
let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=136250211, high=0))
local range_check_ptr = range_check_ptr
__warp_if_52(_1, _3, _4, _7, __warp_subexpr_0, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_81{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _10 : Uint256, _3 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
alloc_locals
local match_var : Uint256 = _10
__warp_block_82(_1, _3, _4, _7, match_var)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_block_80{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256) -> ():
alloc_locals
local _7 : Uint256 = Uint256(low=0, high=0)
let (local _8 : Uint256) = calldata_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(_7.low)
local exec_env : ExecutionEnvironment = exec_env
local range_check_ptr = range_check_ptr
local _9 : Uint256 = Uint256(low=224, high=0)
let (local _10 : Uint256) = uint256_shr(_9, _8)
local range_check_ptr = range_check_ptr
__warp_block_81(_1, _10, _3, _4, _7)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end

func __warp_if_51{exec_env: ExecutionEnvironment, memory_dict: DictAccess*, msize, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_1 : Uint256, _3 : Uint256, _4 : Uint256, _6 : Uint256) -> ():
alloc_locals
if _6.low + _6.high != 0:
	__warp_block_80(_1, _3, _4)
local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
else:
	return ()
end
end

func __warp_if_75{exec_env: ExecutionEnvironment, pedersen_ptr: HashBuiltin*, range_check_ptr, storage_ptr: Storage*, syscall_ptr: felt*}(_83 : Uint256) -> ():
alloc_locals
if _83.low + _83.high != 0:
	fun()
local exec_env: ExecutionEnvironment = exec_env
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
__warp_holder()
return ()
else:
	return ()
end
end

@external
func fun_ENTRY_POINT{pedersen_ptr : HashBuiltin*, range_check_ptr,storage_ptr : Storage*, syscall_ptr : felt* }(calldata_size,calldata_len, calldata : felt*, init_address : felt) -> ():
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
local memory_dict_start: DictAccess* = memory_dict
let msize = 0
local _1 : Uint256 = Uint256(low=64, high=0)
local _2 : Uint256 = Uint256(low=128, high=0)
mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(offset=_1.low, value=_2)
local memory_dict: DictAccess* = memory_dict
local msize = msize
local _3 : Uint256 = Uint256(low=4, high=0)
local _4 : Uint256 = Uint256(exec_env.calldata_size, 0)
local range_check_ptr = range_check_ptr
let (local _5 : Uint256) = is_lt(_4, _3)
local range_check_ptr = range_check_ptr
let (local _6 : Uint256) = is_zero(_5)
local range_check_ptr = range_check_ptr
with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
__warp_if_51(_1, _3, _4, _6)
end

local exec_env: ExecutionEnvironment = exec_env
local memory_dict: DictAccess* = memory_dict
local msize = msize
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
local _82 : Uint256 = _4
let (local _83 : Uint256) = is_zero(_4)
local range_check_ptr = range_check_ptr
with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:
__warp_if_75(_83)
end

local exec_env: ExecutionEnvironment = exec_env
local pedersen_ptr: HashBuiltin* = pedersen_ptr
local range_check_ptr = range_check_ptr
local storage_ptr: Storage* = storage_ptr
local syscall_ptr: felt* = syscall_ptr
return ()
end



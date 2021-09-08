%lang starknet
%builtins pedersen range_check
from evm.memory import mstore
from evm.sha3 import sha
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_sub)
from starkware.starknet.common.storage import Storage

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

func fun_approve{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    local _1_63 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_63.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_63.low, value=var_sender)
    local memory_dict : DictAccess* = memory_dict
    local _2_64 : Uint256 = Uint256(low=3, high=0)
    local _3_65 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_65.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_65.low, value=_2_64)
    local memory_dict : DictAccess* = memory_dict
    local _4_66 : Uint256 = Uint256(low=64, high=0)
    local _5_67 : Uint256 = _1_63

    let (local dataSlot : Uint256) = sha(_1_63.low, _4_66.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    local _6_68 : Uint256 = _1_63
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_63.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_63.low, value=var_guy)
    local memory_dict : DictAccess* = memory_dict
    local _7_69 : Uint256 = _3_65
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_65.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_65.low, value=dataSlot)
    local memory_dict : DictAccess* = memory_dict
    local _8_70 : Uint256 = _4_66
    local _9_71 : Uint256 = _1_63

    let (local _10_72 : Uint256) = sha(_1_63.low, _4_66.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    s_store(key=_10_72, value=var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_ : Uint256 = Uint256(low=1, high=0)

    return (var_)
end
func fun_deposit{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_sender_73 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    local _1_74 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_74.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_74.low, value=var_sender_73)
    local memory_dict : DictAccess* = memory_dict
    local _2_75 : Uint256 = Uint256(low=2, high=0)
    local _3_76 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_76.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_76.low, value=_2_75)
    local memory_dict : DictAccess* = memory_dict
    local _4_77 : Uint256 = Uint256(low=64, high=0)
    local _5_78 : Uint256 = _1_74

    let (local dataSlot_79 : Uint256) = sha(_1_74.low, _4_77.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _6_80 : Uint256) = s_load(dataSlot_79)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_81 : Uint256) = u256_add(_6_80, var_value)
    s_store(key=dataSlot_79, value=_7_81)

    return ()
end
func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src : Uint256, var_dst : Uint256, var_wad_82 : Uint256, var_sender_83 : Uint256) -> (
        var : Uint256):
    alloc_locals

    let (local _1_84 : Uint256) = is_eq(var_src, var_sender_83)

    let (local _2_85 : Uint256) = is_zero(_1_84)

    if _2_85.low + _2_85.high != 0:
        __warp_block_5(var_sender_83, var_src, var_wad_82)
    end
    let (
        local _24 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_842(
        var_src)

    let (local _25 : Uint256) = s_load(_24)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _26 : Uint256) = uint256_sub(_25, var_wad_82)
    s_store(key=_24, value=_26)
    let (
        local _27 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_842(
        var_dst)

    let (local _28 : Uint256) = s_load(_27)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _29 : Uint256) = u256_add(_28, var_wad_82)
    s_store(key=_27, value=_29)
    local var : Uint256 = Uint256(low=1, high=0)

    return (var)
end
func fun_withdraw{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_wad_95 : Uint256, var_sender_96 : Uint256) -> ():
    alloc_locals
    local _1_97 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_97.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_97.low, value=var_sender_96)
    local memory_dict : DictAccess* = memory_dict
    local _2_98 : Uint256 = Uint256(low=2, high=0)
    local _3_99 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_99.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_99.low, value=_2_98)
    local memory_dict : DictAccess* = memory_dict
    local _4_100 : Uint256 = Uint256(low=64, high=0)

    let (local _5_101 : Uint256) = sha(_1_97.low, _4_100.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _6_102 : Uint256) = s_load(_5_101)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _7_103 : Uint256) = is_lt(_6_102, var_wad_95)

    local memory_dict : DictAccess* = memory_dict
    if _7_103.low + _7_103.high != 0:
        assert 0 = 1
    end
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_97.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_97.low, value=var_sender_96)
    local memory_dict : DictAccess* = memory_dict
    local _8_104 : Uint256 = _2_98
    local _9_105 : Uint256 = _3_99
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_99.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_99.low, value=_2_98)
    local memory_dict : DictAccess* = memory_dict
    local _10_106 : Uint256 = _4_100

    let (local dataSlot_107 : Uint256) = sha(_1_97.low, _4_100.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _11_108 : Uint256) = s_load(dataSlot_107)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _12_109 : Uint256) = is_lt(_11_108, var_wad_95)

    local memory_dict : DictAccess* = memory_dict
    if _12_109.low + _12_109.high != 0:
        panic_error_0x11()
    end

    let (local _13_110 : Uint256) = uint256_sub(_11_108, var_wad_95)

    s_store(key=dataSlot_107, value=_13_110)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    return ()
end
func getter_fun_balanceOf{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    local _1_111 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_111.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_111.low, value=key)
    local memory_dict : DictAccess* = memory_dict
    local _2_112 : Uint256 = Uint256(low=2, high=0)
    local _3_113 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_113.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_113.low, value=_2_112)
    local memory_dict : DictAccess* = memory_dict
    local _4_114 : Uint256 = Uint256(low=64, high=0)
    local _5_115 : Uint256 = _1_111

    let (local _6_116 : Uint256) = sha(_1_111.low, _4_114.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local ret__warp_mangled : Uint256) = s_load(_6_116)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    return (ret__warp_mangled)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_839{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_117 : Uint256) -> (dataSlot_118 : Uint256):
    alloc_locals
    local _1_119 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_119.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_119.low, value=key_117)
    local memory_dict : DictAccess* = memory_dict
    local _2_120 : Uint256 = Uint256(low=3, high=0)
    local _3_121 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_121.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_121.low, value=_2_120)
    local memory_dict : DictAccess* = memory_dict
    local _4_122 : Uint256 = Uint256(low=64, high=0)
    local _5_123 : Uint256 = _1_119

    let (local dataSlot_118 : Uint256) = sha(_1_119.low, _4_122.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_118)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_842{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_124 : Uint256) -> (dataSlot_125 : Uint256):
    alloc_locals
    local _1_126 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_126.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_126.low, value=key_124)
    local memory_dict : DictAccess* = memory_dict
    local _2_127 : Uint256 = Uint256(low=2, high=0)
    local _3_128 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_128.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_128.low, value=_2_127)
    local memory_dict : DictAccess* = memory_dict
    local _4_129 : Uint256 = Uint256(low=64, high=0)
    local _5_130 : Uint256 = _1_126

    let (local dataSlot_125 : Uint256) = sha(_1_126.low, _4_129.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_125)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_131 : Uint256) -> (
        dataSlot_132 : Uint256):
    alloc_locals
    local _1_133 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_133.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_133.low, value=key_131)
    local memory_dict : DictAccess* = memory_dict
    local _2_134 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_134.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_134.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_135 : Uint256 = Uint256(low=64, high=0)
    local _4_136 : Uint256 = _1_133

    let (local dataSlot_132 : Uint256) = sha(_1_133.low, _3_135.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_132)
end
func panic_error_0x11{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals

    let (local _1_137 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1313373041, high=0))

    local _2_138 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_138.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_138.low, value=_1_137)
    local memory_dict : DictAccess* = memory_dict
    local _3_139 : Uint256 = Uint256(low=17, high=0)
    local _4_140 : Uint256 = Uint256(low=4, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _4_140.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_4_140.low, value=_3_139)
    local memory_dict : DictAccess* = memory_dict
    local _5_141 : Uint256 = Uint256(low=36, high=0)
    local _6_142 : Uint256 = _2_138
    assert 0 = 1

    return ()
end
func __warp_block_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_1 : Uint256) -> ():
    alloc_locals
    local _5 : Uint256 = _1
    local _6 : Uint256 = _1
    assert 0 = 1

    return ()
end
func __warp_block_1{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _5_6 : Uint256 = Uint256(low=0, high=0)
    local _6_7 : Uint256 = _5_6
    assert 0 = 1

    return ()
end
func __warp_block_2{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _5_14 : Uint256 = Uint256(low=0, high=0)
    local _6_15 : Uint256 = _5_14
    assert 0 = 1

    return ()
end
func __warp_block_3{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _5_24 : Uint256 = Uint256(low=0, high=0)
    local _6_25 : Uint256 = _5_24
    assert 0 = 1

    return ()
end
func __warp_block_4{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _5_36 : Uint256 = Uint256(low=0, high=0)
    local _6_37 : Uint256 = _5_36
    assert 0 = 1

    return ()
end
func __warp_block_5{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender_83 : Uint256, var_src : Uint256, var_wad_82 : Uint256) -> ():
    alloc_locals
    local _3_86 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_86.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_86.low, value=var_src)
    local memory_dict : DictAccess* = memory_dict
    local _4_87 : Uint256 = Uint256(low=3, high=0)
    local _5_88 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_88.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_88.low, value=_4_87)
    local memory_dict : DictAccess* = memory_dict
    local _6_89 : Uint256 = Uint256(low=64, high=0)

    let (local dataSlot_90 : Uint256) = sha(_3_86.low, _6_89.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_86.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_86.low, value=var_sender_83)
    local memory_dict : DictAccess* = memory_dict
    local _7_91 : Uint256 = _5_88
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_88.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_88.low, value=dataSlot_90)
    local memory_dict : DictAccess* = memory_dict
    local _8_92 : Uint256 = _6_89

    let (local _9_93 : Uint256) = sha(_3_86.low, _6_89.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _10_94 : Uint256) = s_load(_9_93)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _11 : Uint256) = is_lt(_10_94, var_wad_82)

    local memory_dict : DictAccess* = memory_dict
    if _11.low + _11.high != 0:
        assert 0 = 1
    end
    let (
        local _12 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_842(
        var_src)

    let (local _13 : Uint256) = s_load(_12)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _14 : Uint256) = is_lt(_13, var_wad_82)

    local memory_dict : DictAccess* = memory_dict
    if _14.low + _14.high != 0:
        assert 0 = 1
    end
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_86.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_86.low, value=var_src)
    local memory_dict : DictAccess* = memory_dict
    local _15 : Uint256 = _4_87
    local _16 : Uint256 = _5_88
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_88.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_88.low, value=_4_87)
    local memory_dict : DictAccess* = memory_dict
    local _17 : Uint256 = _6_89

    let (local _18 : Uint256) = sha(_3_86.low, _6_89.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_86.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_86.low, value=var_sender_83)
    local memory_dict : DictAccess* = memory_dict
    local _19 : Uint256 = _5_88
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_88.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_88.low, value=_18)
    local memory_dict : DictAccess* = memory_dict
    local _20 : Uint256 = _6_89

    let (local dataSlot_1 : Uint256) = sha(_3_86.low, _6_89.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _21 : Uint256) = s_load(dataSlot_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _22 : Uint256) = is_lt(_21, var_wad_82)

    local memory_dict : DictAccess* = memory_dict
    if _22.low + _22.high != 0:
        panic_error_0x11()
    end

    let (local _23 : Uint256) = uint256_sub(_21, var_wad_82)

    s_store(key=dataSlot_1, value=_23)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    return ()
end

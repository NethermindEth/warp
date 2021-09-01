__warp_block_0()
func abi_decode(dataEnd : Uint256) -> ():
    alloc_locals
    local _1_1 : Uint256 = Uint256(low=0, high=0)
    let (local _2_2 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_3 : Uint256) = add(dataEnd, _2_2)
    let (local _4_4 : Uint256) = slt(_3_3, _1_1)
    if _4_4.low + _4_4.high != 0:
        __warp_block_1(_1_1)
    end
    return ()
end

func abi_decode_address(dataEnd_7 : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=32, high=0)
    let (local _2_9 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_10 : Uint256) = add(dataEnd_7, _2_9)
    let (local _4_11 : Uint256) = slt(_3_10, _1_8)
    if _4_11.low + _4_11.high != 0:
        __warp_block_2()
    end
    local _7_14 : Uint256 = Uint256(low=4, high=0)
    let (local value_15 : Uint256) = calldataload(_7_14)
    let (local _8_16 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _9_17 : Uint256) = and(value_15, _8_16)
    let (local _10_18 : Uint256) = eq(value_15, _9_17)
    let (local _11_19 : Uint256) = iszero(_10_18)
    if _11_19.low + _11_19.high != 0:
        __warp_block_3()
    end
    local value0 = value_15
    return (value0)
end

func abi_decode_addresst_address(dataEnd_22 : Uint256) -> (value0_23 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_24 : Uint256 = Uint256(low=64, high=0)
    let (local _2_25 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_26 : Uint256) = add(dataEnd_22, _2_25)
    let (local _4_27 : Uint256) = slt(_3_26, _1_24)
    if _4_27.low + _4_27.high != 0:
        __warp_block_4()
    end
    local _7_30 : Uint256 = Uint256(low=4, high=0)
    let (local value_31 : Uint256) = calldataload(_7_30)
    let (local _8_32 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _9_33 : Uint256) = and(value_31, _8_32)
    let (local _10_34 : Uint256) = eq(value_31, _9_33)
    let (local _11_35 : Uint256) = iszero(_10_34)
    if _11_35.low + _11_35.high != 0:
        __warp_block_5()
    end
    local value0_23 = value_31
    local _14_38 : Uint256 = Uint256(low=36, high=0)
    let (local value_1 : Uint256) = calldataload(_14_38)
    let (local _15_39 : Uint256) = and(value_1, _8_32)
    let (local _16_40 : Uint256) = eq(value_1, _15_39)
    let (local _17_41 : Uint256) = iszero(_16_40)
    if _17_41.low + _17_41.high != 0:
        __warp_block_6()
    end
    local value1 = value_1
    return (value0_23, value1)
end

func abi_decode_addresst_addresst_uint256t_address(dataEnd_44 : Uint256) -> (
        value0_45 : Uint256, value1_46 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_47 : Uint256 = Uint256(low=128, high=0)
    let (local _2_48 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_49 : Uint256) = add(dataEnd_44, _2_48)
    let (local _4_50 : Uint256) = slt(_3_49, _1_47)
    if _4_50.low + _4_50.high != 0:
        __warp_block_7()
    end
    local _7_53 : Uint256 = Uint256(low=4, high=0)
    let (local value_54 : Uint256) = calldataload(_7_53)
    let (local _8_55 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _9_56 : Uint256) = and(value_54, _8_55)
    let (local _10_57 : Uint256) = eq(value_54, _9_56)
    let (local _11_58 : Uint256) = iszero(_10_57)
    if _11_58.low + _11_58.high != 0:
        __warp_block_8()
    end
    local value0_45 = value_54
    local _14_61 : Uint256 = Uint256(low=36, high=0)
    let (local value_1_62 : Uint256) = calldataload(_14_61)
    let (local _15_63 : Uint256) = and(value_1_62, _8_55)
    let (local _16_64 : Uint256) = eq(value_1_62, _15_63)
    let (local _17_65 : Uint256) = iszero(_16_64)
    if _17_65.low + _17_65.high != 0:
        __warp_block_9()
    end
    local value1_46 = value_1_62
    local _20_68 : Uint256 = Uint256(low=68, high=0)
    let (local value2) = calldataload(_20_68)
    local _21_69 : Uint256 = Uint256(low=100, high=0)
    let (local value_2 : Uint256) = calldataload(_21_69)
    let (local _22_70 : Uint256) = and(value_2, _8_55)
    let (local _23_71 : Uint256) = eq(value_2, _22_70)
    let (local _24_72 : Uint256) = iszero(_23_71)
    if _24_72.low + _24_72.high != 0:
        __warp_block_10()
    end
    local value3 = value_2
    return (value0_45, value1_46, value2, value3)
end

func abi_decode_addresst_uint256(dataEnd_75 : Uint256) -> (
        value0_76 : Uint256, value1_77 : Uint256):
    alloc_locals
    local _1_78 : Uint256 = Uint256(low=64, high=0)
    let (local _2_79 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_80 : Uint256) = add(dataEnd_75, _2_79)
    let (local _4_81 : Uint256) = slt(_3_80, _1_78)
    if _4_81.low + _4_81.high != 0:
        __warp_block_11()
    end
    local _7_84 : Uint256 = Uint256(low=4, high=0)
    let (local value_85 : Uint256) = calldataload(_7_84)
    let (local _8_86 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _9_87 : Uint256) = and(value_85, _8_86)
    let (local _10_88 : Uint256) = eq(value_85, _9_87)
    let (local _11_89 : Uint256) = iszero(_10_88)
    if _11_89.low + _11_89.high != 0:
        __warp_block_12()
    end
    local value0_76 = value_85
    local _14_92 : Uint256 = Uint256(low=36, high=0)
    let (local value1_77) = calldataload(_14_92)
    return (value0_76, value1_77)
end

func abi_decode_addresst_uint256t_address(dataEnd_93 : Uint256) -> (
        value0_94 : Uint256, value1_95 : Uint256, value2_96 : Uint256):
    alloc_locals
    local _1_97 : Uint256 = Uint256(low=96, high=0)
    let (local _2_98 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_99 : Uint256) = add(dataEnd_93, _2_98)
    let (local _4_100 : Uint256) = slt(_3_99, _1_97)
    if _4_100.low + _4_100.high != 0:
        __warp_block_13()
    end
    local _7_103 : Uint256 = Uint256(low=4, high=0)
    let (local value_104 : Uint256) = calldataload(_7_103)
    let (local _8_105 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _9_106 : Uint256) = and(value_104, _8_105)
    let (local _10_107 : Uint256) = eq(value_104, _9_106)
    let (local _11_108 : Uint256) = iszero(_10_107)
    if _11_108.low + _11_108.high != 0:
        __warp_block_14()
    end
    local value0_94 = value_104
    local _14_111 : Uint256 = Uint256(low=36, high=0)
    let (local value1_95) = calldataload(_14_111)
    local _15_112 : Uint256 = Uint256(low=68, high=0)
    let (local value_1_113 : Uint256) = calldataload(_15_112)
    let (local _16_114 : Uint256) = and(value_1_113, _8_105)
    let (local _17_115 : Uint256) = eq(value_1_113, _16_114)
    let (local _18_116 : Uint256) = iszero(_17_115)
    if _18_116.low + _18_116.high != 0:
        __warp_block_15()
    end
    local value2_96 = value_1_113
    return (value0_94, value1_95, value2_96)
end

func abi_decode_uint256t_address(dataEnd_119 : Uint256) -> (
        value0_120 : Uint256, value1_121 : Uint256):
    alloc_locals
    local _1_122 : Uint256 = Uint256(low=64, high=0)
    let (local _2_123 : Uint256) = not(Uint256(low=3, high=0))
    let (local _3_124 : Uint256) = add(dataEnd_119, _2_123)
    let (local _4_125 : Uint256) = slt(_3_124, _1_122)
    if _4_125.low + _4_125.high != 0:
        __warp_block_16()
    end
    local _7_128 : Uint256 = Uint256(low=4, high=0)
    let (local value0_120) = calldataload(_7_128)
    local _8_129 : Uint256 = Uint256(low=36, high=0)
    let (local value_130 : Uint256) = calldataload(_8_129)
    let (local _9_131 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _10_132 : Uint256) = and(value_130, _9_131)
    let (local _11_133 : Uint256) = eq(value_130, _10_132)
    let (local _12_134 : Uint256) = iszero(_11_133)
    if _12_134.low + _12_134.high != 0:
        __warp_block_17()
    end
    local value1_121 = value_130
    return (value0_120, value1_121)
end

func abi_encode_bool(headStart : Uint256, value0_137 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_138 : Uint256 = Uint256(low=32, high=0)
    let (local tail) = add(headStart, _1_138)
    let (local _2_139 : Uint256) = iszero(value0_137)
    let (local _3_140 : Uint256) = iszero(_2_139)
    mstore(headStart, _3_140)
    return (tail)
end

func abi_encode_string(headStart_141 : Uint256, value0_142 : Uint256) -> (tail_143 : Uint256):
    alloc_locals
    local _1_144 : Uint256 = Uint256(low=32, high=0)
    local _2_145 : Uint256 = _1_144
    mstore(headStart_141, _1_144)
    let (local length : Uint256) = mload(value0_142)
    local _3_146 : Uint256 = _1_144
    let (local _4_147 : Uint256) = add(headStart_141, _1_144)
    mstore(_4_147, length)
    local i : Uint256 = Uint256(low=0, high=0)
    let (local i) = __warp_block_19(_1_144, headStart_141, i, value0_142)
    let (local _11_154 : Uint256) = gt(i, length)
    if _11_154.low + _11_154.high != 0:
        __warp_block_20(headStart_141, length)
    end
    local _16_159 : Uint256 = Uint256(low=64, high=0)
    let (local _17_160 : Uint256) = not(Uint256(low=31, high=0))
    local _18_161 : Uint256 = Uint256(low=31, high=0)
    let (local _19_162 : Uint256) = add(length, _18_161)
    let (local _20_163 : Uint256) = and(_19_162, _17_160)
    let (local _21_164 : Uint256) = add(headStart_141, _20_163)
    let (local tail_143) = add(_21_164, _16_159)
    return (tail_143)
end

func abi_encode_uint256(headStart_165 : Uint256, value0_166 : Uint256) -> (tail_167 : Uint256):
    alloc_locals
    local _1_168 : Uint256 = Uint256(low=32, high=0)
    let (local tail_167) = add(headStart_165, _1_168)
    mstore(headStart_165, value0_166)
    return (tail_167)
end

func abi_encode_uint8(headStart_169 : Uint256, value0_170 : Uint256) -> (tail_171 : Uint256):
    alloc_locals
    local _1_172 : Uint256 = Uint256(low=32, high=0)
    let (local tail_171) = add(headStart_169, _1_172)
    local _2_173 : Uint256 = Uint256(low=255, high=0)
    let (local _3_174 : Uint256) = and(value0_170, _2_173)
    mstore(headStart_169, _3_174)
    return (tail_171)
end

func array_dataslot_string_storage() -> (data : Uint256):
    alloc_locals
    local _1_175 : Uint256 = Uint256(low=0, high=0)
    local _2_176 : Uint256 = _1_175
    mstore(_1_175, _1_175)
    local data = Uint256(low=100557845882747507273875182862946526563, high=54570651553685478358117286254199992264)
    return (data)
end

func array_dataslot_string_storage_3075() -> (data_177 : Uint256):
    alloc_locals
    local _1_178 : Uint256 = Uint256(low=1, high=0)
    local _2_179 : Uint256 = Uint256(low=0, high=0)
    mstore(_2_179, _1_178)
    local data_177 = Uint256(low=17219183504112405672555532996650339574, high=235346966651632113557018504892503714354)
    return (data_177)
end

func array_storeLengthForEncoding_string(pos : Uint256, length_180 : Uint256) -> (
        updated_pos : Uint256):
    alloc_locals
    mstore(pos, length_180)
    local _1_181 : Uint256 = Uint256(low=32, high=0)
    let (local updated_pos) = add(pos, _1_181)
    return (updated_pos)
end

func checked_add_uint256(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_182 : Uint256) = not(y)
    let (local _2_183 : Uint256) = gt(x, _1_182)
    if _2_183.low + _2_183.high != 0:
        panic_error_0x11()
    end
    let (local sum) = add(x, y)
    return (sum)
end

func finalize_allocation(memPtr : Uint256, size : Uint256) -> ():
    alloc_locals
    let (local _1_184 : Uint256) = not(Uint256(low=31, high=0))
    local _2_185 : Uint256 = Uint256(low=31, high=0)
    let (local _3_186 : Uint256) = add(size, _2_185)
    let (local _4_187 : Uint256) = and(_3_186, _1_184)
    let (local newFreePtr : Uint256) = add(memPtr, _4_187)
    let (local _5_188 : Uint256) = lt(newFreePtr, memPtr)
    local _6_189 : Uint256 = Uint256(low=18446744073709551615, high=0)
    let (local _7_190 : Uint256) = gt(newFreePtr, _6_189)
    let (local _8_191 : Uint256) = or(_7_190, _5_188)
    if _8_191.low + _8_191.high != 0:
        __warp_block_21()
    end
    local _15_198 : Uint256 = Uint256(low=64, high=0)
    mstore(_15_198, newFreePtr)
    return ()
end

func fun_approve(var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (local _1_199 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_200 : Uint256) = and(var_sender, _1_199)
    local _3_201 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_201, _2_200)
    local _4_202 : Uint256 = Uint256(low=5, high=0)
    local _5_203 : Uint256 = Uint256(low=32, high=0)
    mstore(_5_203, _4_202)
    local _6_204 : Uint256 = Uint256(low=64, high=0)
    local _7_205 : Uint256 = _3_201
    let (local _8_206 : Uint256) = keccak256(_3_201, _6_204)
    let (
        local _9_207 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address(
        _8_206, var_guy)
    sstore(_9_207, var_wad)
    local var_ = Uint256(low=1, high=0)
    return (var_)
end

func fun_deposit(var_sender_208 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (local _1_209 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_210 : Uint256) = and(var_sender_208, _1_209)
    local _3_211 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_211, _2_210)
    local _4_212 : Uint256 = Uint256(low=4, high=0)
    local _5_213 : Uint256 = Uint256(low=32, high=0)
    mstore(_5_213, _4_212)
    local _6_214 : Uint256 = Uint256(low=64, high=0)
    local _7_215 : Uint256 = _3_211
    let (local dataSlot : Uint256) = keccak256(_3_211, _6_214)
    let (local _8_216 : Uint256) = sload(dataSlot)
    let (local _9_217 : Uint256) = checked_add_uint256(_8_216, var_value)
    sstore(dataSlot, _9_217)
    return ()
end

func fun_transferFrom(
        var_src : Uint256, var_dst : Uint256, var_wad_218 : Uint256, var_sender_219 : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (local _1_220 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_221 : Uint256) = and(var_src, _1_220)
    let (local _3_222 : Uint256) = and(var_sender_219, _1_220)
    let (local _4_223 : Uint256) = eq(_2_221, _3_222)
    let (local _5_224 : Uint256) = iszero(_4_223)
    if _5_224.low + _5_224.high != 0:
        __warp_block_22(_2_221, var_sender_219, var_src, var_wad_218)
    end
    let (
        local _25_244 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address_1560(
        var_src)
    let (local _26_245 : Uint256) = sload(_25_244)
    let (local _27_246 : Uint256) = lt(_26_245, var_wad_218)
    if _27_246.low + _27_246.high != 0:
        panic_error_0x11()
    end
    let (local _28_247 : Uint256) = sub(_26_245, var_wad_218)
    sstore(_25_244, _28_247)
    let (
        local _29_248 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address_1560(
        var_dst)
    let (local _30_249 : Uint256) = sload(_29_248)
    let (local _31_250 : Uint256) = checked_add_uint256(_30_249, var_wad_218)
    sstore(_29_248, _31_250)
    local var = Uint256(low=1, high=0)
    return (var)
end

func fun_withdraw(var_wad_251 : Uint256, var_sender_252 : Uint256) -> ():
    alloc_locals
    let (local _1_253 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local cleaned : Uint256) = and(var_sender_252, _1_253)
    local _2_254 : Uint256 = Uint256(low=0, high=0)
    mstore(_2_254, cleaned)
    local _3_255 : Uint256 = Uint256(low=4, high=0)
    local _4_256 : Uint256 = Uint256(low=32, high=0)
    mstore(_4_256, _3_255)
    local _5_257 : Uint256 = Uint256(low=64, high=0)
    let (local _6_258 : Uint256) = keccak256(_2_254, _5_257)
    let (local _7_259 : Uint256) = sload(_6_258)
    let (local _8_260 : Uint256) = lt(_7_259, var_wad_251)
    if _8_260.low + _8_260.high != 0:
        revert(_2_254, _2_254)
    end
    mstore(_2_254, cleaned)
    local _9_261 : Uint256 = _3_255
    local _10_262 : Uint256 = _4_256
    mstore(_4_256, _3_255)
    local _11_263 : Uint256 = _5_257
    let (local dataSlot_264 : Uint256) = keccak256(_2_254, _5_257)
    let (local _12_265 : Uint256) = sload(dataSlot_264)
    let (local _13_266 : Uint256) = lt(_12_265, var_wad_251)
    if _13_266.low + _13_266.high != 0:
        panic_error_0x11()
    end
    let (local _14_267 : Uint256) = sub(_12_265, var_wad_251)
    sstore(dataSlot_264, _14_267)
    return ()
end

func getter_fun_balanceOf(key : Uint256) -> (ret_268 : Uint256):
    alloc_locals
    let (local _1_269 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_270 : Uint256) = and(key, _1_269)
    local _3_271 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_271, _2_270)
    local _4_272 : Uint256 = Uint256(low=4, high=0)
    local _5_273 : Uint256 = Uint256(low=32, high=0)
    mstore(_5_273, _4_272)
    local _6_274 : Uint256 = Uint256(low=64, high=0)
    local _7_275 : Uint256 = _3_271
    let (local _8_276 : Uint256) = keccak256(_3_271, _6_274)
    let (local ret_268) = sload(_8_276)
    return (ret_268)
end

func mapping_index_access_mapping_address_mapping_address_uint256_of_address_1558(
        key_277 : Uint256) -> (dataSlot_278 : Uint256):
    alloc_locals
    let (local _1_279 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_280 : Uint256) = and(key_277, _1_279)
    local _3_281 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_281, _2_280)
    local _4_282 : Uint256 = Uint256(low=5, high=0)
    local _5_283 : Uint256 = Uint256(low=32, high=0)
    mstore(_5_283, _4_282)
    local _6_284 : Uint256 = Uint256(low=64, high=0)
    local _7_285 : Uint256 = _3_281
    let (local dataSlot_278) = keccak256(_3_281, _6_284)
    return (dataSlot_278)
end

func mapping_index_access_mapping_address_mapping_address_uint256_of_address_1560(
        key_286 : Uint256) -> (dataSlot_287 : Uint256):
    alloc_locals
    let (local _1_288 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_289 : Uint256) = and(key_286, _1_288)
    local _3_290 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_290, _2_289)
    local _4_291 : Uint256 = Uint256(low=4, high=0)
    local _5_292 : Uint256 = Uint256(low=32, high=0)
    mstore(_5_292, _4_291)
    local _6_293 : Uint256 = Uint256(low=64, high=0)
    local _7_294 : Uint256 = _3_290
    let (local dataSlot_287) = keccak256(_3_290, _6_293)
    return (dataSlot_287)
end

func mapping_index_access_mapping_address_mapping_address_uint256_of_address(
        slot : Uint256, key_295 : Uint256) -> (dataSlot_296 : Uint256):
    alloc_locals
    let (local _1_297 : Uint256) = sub(
        shl(Uint256(low=160, high=0), Uint256(low=1, high=0)), Uint256(low=1, high=0))
    let (local _2_298 : Uint256) = and(key_295, _1_297)
    local _3_299 : Uint256 = Uint256(low=0, high=0)
    mstore(_3_299, _2_298)
    local _4_300 : Uint256 = Uint256(low=32, high=0)
    mstore(_4_300, slot)
    local _5_301 : Uint256 = Uint256(low=64, high=0)
    local _6_302 : Uint256 = _3_299
    let (local dataSlot_296) = keccak256(_3_299, _5_301)
    return (dataSlot_296)
end

func panic_error_0x11() -> ():
    alloc_locals
    let (local _1_303 : Uint256) = shl(Uint256(low=224, high=0), Uint256(low=1313373041, high=0))
    local _2_304 : Uint256 = Uint256(low=0, high=0)
    mstore(_2_304, _1_303)
    local _3_305 : Uint256 = Uint256(low=17, high=0)
    local _4_306 : Uint256 = Uint256(low=4, high=0)
    mstore(_4_306, _3_305)
    local _5_307 : Uint256 = Uint256(low=36, high=0)
    local _6_308 : Uint256 = _2_304
    revert(_2_304, _5_307)
    return ()
end

func read_from_storage_dynamic_split_string() -> (value_309 : Uint256):
    alloc_locals
    local _1_310 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_311 : Uint256) = mload(_1_310)
    local ret_312 : Uint256 = Uint256(low=0, high=0)
    let (local slotValue : Uint256) = sload(ret_312)
    local length_313 : Uint256 = ret_312
    local _2_314 : Uint256 = Uint256(low=1, high=0)
    local _3_315 : Uint256 = _2_314
    let (local length_313) = shr(_2_314, slotValue)
    local _4_316 : Uint256 = _2_314
    let (local outOfPlaceEncoding : Uint256) = and(slotValue, _2_314)
    let (local _5_317 : Uint256) = iszero(outOfPlaceEncoding)
    if _5_317.low + _5_317.high != 0:
        let (local length_313) = __warp_block_23(length_313)
    end
    local _7_319 : Uint256 = Uint256(low=32, high=0)
    local _8_320 : Uint256 = _7_319
    let (local _9_321 : Uint256) = lt(length_313, _7_319)
    let (local _10_322 : Uint256) = eq(outOfPlaceEncoding, _9_321)
    if _10_322.low + _10_322.high != 0:
        __warp_block_24(ret_312)
    end
    let (local pos_327 : Uint256) = array_storeLengthForEncoding_string(memPtr_311, length_313)
    let (local ret_312) = __warp_block_25(
        _2_314, _7_319, length_313, outOfPlaceEncoding, pos_327, ret_312, slotValue)
    let (local _20_334 : Uint256) = sub(ret_312, memPtr_311)
    finalize_allocation(memPtr_311, _20_334)
    local value_309 = memPtr_311
    return (value_309)
end

func read_from_storage_dynamic_split_string_1556() -> (value_335 : Uint256):
    alloc_locals
    local _1_336 : Uint256 = Uint256(low=64, high=0)
    let (local memPtr_337 : Uint256) = mload(_1_336)
    local ret_338 : Uint256 = Uint256(low=0, high=0)
    local _2_339 : Uint256 = Uint256(low=1, high=0)
    local _3_340 : Uint256 = _2_339
    let (local slotValue_341 : Uint256) = sload(_2_339)
    local length_342 : Uint256 = ret_338
    local _4_343 : Uint256 = _2_339
    let (local length_342) = shr(_2_339, slotValue_341)
    local _5_344 : Uint256 = _2_339
    let (local outOfPlaceEncoding_345 : Uint256) = and(slotValue_341, _2_339)
    let (local _6_346 : Uint256) = iszero(outOfPlaceEncoding_345)
    if _6_346.low + _6_346.high != 0:
        let (local length_342) = __warp_block_26(length_342)
    end
    local _8_348 : Uint256 = Uint256(low=32, high=0)
    local _9_349 : Uint256 = _8_348
    let (local _10_350 : Uint256) = lt(length_342, _8_348)
    let (local _11_351 : Uint256) = eq(outOfPlaceEncoding_345, _10_350)
    if _11_351.low + _11_351.high != 0:
        __warp_block_27(ret_338)
    end
    let (local pos_356 : Uint256) = array_storeLengthForEncoding_string(memPtr_337, length_342)
    let (local ret_338) = __warp_block_28(
        _2_339, _8_348, length_342, outOfPlaceEncoding_345, pos_356, ret_338, slotValue_341)
    let (local _21_364 : Uint256) = sub(ret_338, memPtr_337)
    finalize_allocation(memPtr_337, _21_364)
    local value_335 = memPtr_337
    return (value_335)
end

func __warp_block_0() -> ():
    alloc_locals
    local _1 : Uint256 = Uint256(low=64, high=0)
    local _2 : Uint256 = Uint256(low=128, high=0)
    mstore(_1, _2)
    local _3 : Uint256 = Uint256(low=4, high=0)
    let (local _4 : Uint256) = calldatasize()
    let (local _5 : Uint256) = lt(_4, _3)
    let (local _6 : Uint256) = iszero(_5)
    if _6.low + _6.high != 0:
        __warp_block_29(_1, _4)
    end
    local _52 : Uint256 = Uint256(low=0, high=0)
    local _53 : Uint256 = _52
    revert(_52, _52)
    return ()
end

func __warp_block_1(_1_1 : Uint256) -> ():
    alloc_locals
    local _5_5 : Uint256 = _1_1
    local _6_6 : Uint256 = _1_1
    revert(_1_1, _1_1)
    return ()
end

func __warp_block_2() -> ():
    alloc_locals
    local _5_12 : Uint256 = Uint256(low=0, high=0)
    local _6_13 : Uint256 = _5_12
    revert(_5_12, _5_12)
    return ()
end

func __warp_block_3() -> ():
    alloc_locals
    local _12_20 : Uint256 = Uint256(low=0, high=0)
    local _13_21 : Uint256 = _12_20
    revert(_12_20, _12_20)
    return ()
end

func __warp_block_4() -> ():
    alloc_locals
    local _5_28 : Uint256 = Uint256(low=0, high=0)
    local _6_29 : Uint256 = _5_28
    revert(_5_28, _5_28)
    return ()
end

func __warp_block_5() -> ():
    alloc_locals
    local _12_36 : Uint256 = Uint256(low=0, high=0)
    local _13_37 : Uint256 = _12_36
    revert(_12_36, _12_36)
    return ()
end

func __warp_block_6() -> ():
    alloc_locals
    local _18_42 : Uint256 = Uint256(low=0, high=0)
    local _19_43 : Uint256 = _18_42
    revert(_18_42, _18_42)
    return ()
end

func __warp_block_7() -> ():
    alloc_locals
    local _5_51 : Uint256 = Uint256(low=0, high=0)
    local _6_52 : Uint256 = _5_51
    revert(_5_51, _5_51)
    return ()
end

func __warp_block_8() -> ():
    alloc_locals
    local _12_59 : Uint256 = Uint256(low=0, high=0)
    local _13_60 : Uint256 = _12_59
    revert(_12_59, _12_59)
    return ()
end

func __warp_block_9() -> ():
    alloc_locals
    local _18_66 : Uint256 = Uint256(low=0, high=0)
    local _19_67 : Uint256 = _18_66
    revert(_18_66, _18_66)
    return ()
end

func __warp_block_10() -> ():
    alloc_locals
    local _25_73 : Uint256 = Uint256(low=0, high=0)
    local _26_74 : Uint256 = _25_73
    revert(_25_73, _25_73)
    return ()
end

func __warp_block_11() -> ():
    alloc_locals
    local _5_82 : Uint256 = Uint256(low=0, high=0)
    local _6_83 : Uint256 = _5_82
    revert(_5_82, _5_82)
    return ()
end

func __warp_block_12() -> ():
    alloc_locals
    local _12_90 : Uint256 = Uint256(low=0, high=0)
    local _13_91 : Uint256 = _12_90
    revert(_12_90, _12_90)
    return ()
end

func __warp_block_13() -> ():
    alloc_locals
    local _5_101 : Uint256 = Uint256(low=0, high=0)
    local _6_102 : Uint256 = _5_101
    revert(_5_101, _5_101)
    return ()
end

func __warp_block_14() -> ():
    alloc_locals
    local _12_109 : Uint256 = Uint256(low=0, high=0)
    local _13_110 : Uint256 = _12_109
    revert(_12_109, _12_109)
    return ()
end

func __warp_block_15() -> ():
    alloc_locals
    local _19_117 : Uint256 = Uint256(low=0, high=0)
    local _20_118 : Uint256 = _19_117
    revert(_19_117, _19_117)
    return ()
end

func __warp_block_16() -> ():
    alloc_locals
    local _5_126 : Uint256 = Uint256(low=0, high=0)
    local _6_127 : Uint256 = _5_126
    revert(_5_126, _5_126)
    return ()
end

func __warp_block_17() -> ():
    alloc_locals
    local _13_135 : Uint256 = Uint256(low=0, high=0)
    local _14_136 : Uint256 = _13_135
    revert(_13_135, _13_135)
    return ()
end

func __warp_block_18(
        _1_144 : Uint256, headStart_141 : Uint256, i : Uint256, value0_142 : Uint256) -> (
        i : Uint256):
    alloc_locals
    let (local _5_148 : Uint256) = add(value0_142, i)
    let (local _6_149 : Uint256) = add(_5_148, _1_144)
    let (local _7_150 : Uint256) = mload(_6_149)
    local _8_151 : Uint256 = Uint256(low=64, high=0)
    let (local _9_152 : Uint256) = add(headStart_141, i)
    let (local _10_153 : Uint256) = add(_9_152, _8_151)
    mstore(_10_153, _7_150)
    let (local i) = add(i, _1_144)
    return (i)
end

func __warp_block_19(
        _1_144 : Uint256, headStart_141 : Uint256, i : Uint256, value0_142 : Uint256) -> (
        _1_144 : Uint256, headStart_141 : Uint256, i : Uint256, value0_142 : Uint256):
    alloc_locals
    if lt(i, length).low + lt(i, length).high != 0:
        let (local i) = __warp_block_18(_1_144, headStart_141, i, value0_142)
        let (local i) = __warp_block_19(_1_144, headStart_141, i, value0_142)
    end
    return (_1_144, headStart_141, i, value0_142)
end

func __warp_block_20(headStart_141 : Uint256, length : Uint256) -> ():
    alloc_locals
    local _12_155 : Uint256 = Uint256(low=0, high=0)
    local _13_156 : Uint256 = Uint256(low=64, high=0)
    let (local _14_157 : Uint256) = add(headStart_141, length)
    let (local _15_158 : Uint256) = add(_14_157, _13_156)
    mstore(_15_158, _12_155)
    return ()
end

func __warp_block_21() -> ():
    alloc_locals
    let (local _9_192 : Uint256) = shl(Uint256(low=224, high=0), Uint256(low=1313373041, high=0))
    local _10_193 : Uint256 = Uint256(low=0, high=0)
    mstore(_10_193, _9_192)
    local _11_194 : Uint256 = Uint256(low=65, high=0)
    local _12_195 : Uint256 = Uint256(low=4, high=0)
    mstore(_12_195, _11_194)
    local _13_196 : Uint256 = Uint256(low=36, high=0)
    local _14_197 : Uint256 = _10_193
    revert(_10_193, _13_196)
    return ()
end

func __warp_block_22(
        _2_221 : Uint256, var_sender_219 : Uint256, var_src : Uint256, var_wad_218 : Uint256) -> ():
    alloc_locals
    local _6_225 : Uint256 = Uint256(low=0, high=0)
    mstore(_6_225, _2_221)
    local _7_226 : Uint256 = Uint256(low=5, high=0)
    local _8_227 : Uint256 = Uint256(low=32, high=0)
    mstore(_8_227, _7_226)
    local _9_228 : Uint256 = Uint256(low=64, high=0)
    let (local _10_229 : Uint256) = keccak256(_6_225, _9_228)
    let (
        local _11_230 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address(
        _10_229, var_sender_219)
    let (local _12_231 : Uint256) = sload(_11_230)
    let (local _13_232 : Uint256) = lt(_12_231, var_wad_218)
    if _13_232.low + _13_232.high != 0:
        revert(_6_225, _6_225)
    end
    let (
        local _14_233 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address_1560(
        var_src)
    let (local _15_234 : Uint256) = sload(_14_233)
    let (local _16_235 : Uint256) = lt(_15_234, var_wad_218)
    if _16_235.low + _16_235.high != 0:
        revert(_6_225, _6_225)
    end
    mstore(_6_225, _2_221)
    local _17_236 : Uint256 = _7_226
    local _18_237 : Uint256 = _8_227
    mstore(_8_227, _7_226)
    local _19_238 : Uint256 = _9_228
    let (local _20_239 : Uint256) = keccak256(_6_225, _9_228)
    let (
        local _21_240 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address(
        _20_239, var_sender_219)
    let (local _22_241 : Uint256) = sload(_21_240)
    let (local _23_242 : Uint256) = lt(_22_241, var_wad_218)
    if _23_242.low + _23_242.high != 0:
        panic_error_0x11()
    end
    let (local _24_243 : Uint256) = sub(_22_241, var_wad_218)
    sstore(_21_240, _24_243)
    return ()
end

func __warp_block_23(length_313 : Uint256) -> (length_313 : Uint256):
    alloc_locals
    local _6_318 : Uint256 = Uint256(low=127, high=0)
    let (local length_313) = and(length_313, _6_318)
    return (length_313)
end

func __warp_block_24(ret_312 : Uint256) -> ():
    alloc_locals
    let (local _11_323 : Uint256) = shl(Uint256(low=224, high=0), Uint256(low=1313373041, high=0))
    mstore(ret_312, _11_323)
    local _12_324 : Uint256 = Uint256(low=34, high=0)
    local _13_325 : Uint256 = Uint256(low=4, high=0)
    mstore(_13_325, _12_324)
    local _14_326 : Uint256 = Uint256(low=36, high=0)
    revert(ret_312, _14_326)
    return ()
end

func __warp_block_25(
        _2_314 : Uint256, _7_319 : Uint256, length_313 : Uint256, outOfPlaceEncoding : Uint256,
        pos_327 : Uint256, ret_312 : Uint256, slotValue : Uint256) -> (ret_312 : Uint256):
    alloc_locals
    local match_var : Uint256 = outOfPlaceEncoding
    if eq(match_var, Uint256(low=0, high=0)).low + eq(match_var, Uint256(low=0, high=0)).high != 0:
        let (local ret_312) = __warp_block_30(_7_319, pos_327, ret_312, slotValue)
        if
            eq(match_var, Uint256(low=1, high=0)).low + eq(match_var, Uint256(low=1, high=0)).high !=
            0:
            let (local ret_312) = __warp_block_31(_2_314, _7_319, length_313, pos_327, ret_312)
        end
    end
    return (ret_312)
end

func __warp_block_26(length_342 : Uint256) -> (length_342 : Uint256):
    alloc_locals
    local _7_347 : Uint256 = Uint256(low=127, high=0)
    let (local length_342) = and(length_342, _7_347)
    return (length_342)
end

func __warp_block_27(ret_338 : Uint256) -> ():
    alloc_locals
    let (local _12_352 : Uint256) = shl(Uint256(low=224, high=0), Uint256(low=1313373041, high=0))
    mstore(ret_338, _12_352)
    local _13_353 : Uint256 = Uint256(low=34, high=0)
    local _14_354 : Uint256 = Uint256(low=4, high=0)
    mstore(_14_354, _13_353)
    local _15_355 : Uint256 = Uint256(low=36, high=0)
    revert(ret_338, _15_355)
    return ()
end

func __warp_block_28(
        _2_339 : Uint256, _8_348 : Uint256, length_342 : Uint256, outOfPlaceEncoding_345 : Uint256,
        pos_356 : Uint256, ret_338 : Uint256, slotValue_341 : Uint256) -> (ret_338 : Uint256):
    alloc_locals
    local match_var : Uint256 = outOfPlaceEncoding_345
    if eq(match_var, Uint256(low=0, high=0)).low + eq(match_var, Uint256(low=0, high=0)).high != 0:
        let (local ret_338) = __warp_block_32(_8_348, pos_356, ret_338, slotValue_341)
        if
            eq(match_var, Uint256(low=1, high=0)).low + eq(match_var, Uint256(low=1, high=0)).high !=
            0:
            let (local ret_338) = __warp_block_33(_2_339, _8_348, length_342, pos_356, ret_338)
        end
    end
    return (ret_338)
end

func __warp_block_29(_1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    let (local _8 : Uint256) = calldataload(_7)
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = shr(_9, _8)
    __warp_block_34(_1, _10, _4, _7)
    return ()
end

func __warp_block_30(
        _7_319 : Uint256, pos_327 : Uint256, ret_312 : Uint256, slotValue : Uint256) -> (
        ret_312 : Uint256):
    alloc_locals
    let (local _15_328 : Uint256) = not(Uint256(low=255, high=0))
    let (local _16_329 : Uint256) = and(slotValue, _15_328)
    mstore(pos_327, _16_329)
    local _17_330 : Uint256 = _7_319
    let (local ret_312) = add(pos_327, _7_319)
    return (ret_312)
end

func __warp_block_31(
        _2_314 : Uint256, _7_319 : Uint256, length_313 : Uint256, pos_327 : Uint256,
        ret_312 : Uint256) -> (ret_312 : Uint256):
    alloc_locals
    let (local dataPos : Uint256) = array_dataslot_string_storage()
    local i_331 : Uint256 = Uint256(low=0, high=0)
    let (local dataPos, local i_331) = __warp_block_36(_2_314, _7_319, dataPos, i_331, pos_327)
    let (local ret_312) = add(pos_327, i_331)
    return (ret_312)
end

func __warp_block_32(
        _8_348 : Uint256, pos_356 : Uint256, ret_338 : Uint256, slotValue_341 : Uint256) -> (
        ret_338 : Uint256):
    alloc_locals
    let (local _16_357 : Uint256) = not(Uint256(low=255, high=0))
    let (local _17_358 : Uint256) = and(slotValue_341, _16_357)
    mstore(pos_356, _17_358)
    local _18_359 : Uint256 = _8_348
    let (local ret_338) = add(pos_356, _8_348)
    return (ret_338)
end

func __warp_block_33(
        _2_339 : Uint256, _8_348 : Uint256, length_342 : Uint256, pos_356 : Uint256,
        ret_338 : Uint256) -> (ret_338 : Uint256):
    alloc_locals
    let (local dataPos_360 : Uint256) = array_dataslot_string_storage_3075()
    local i_361 : Uint256 = Uint256(low=0, high=0)
    let (local dataPos_360, local i_361) = __warp_block_38(
        _2_339, _8_348, dataPos_360, i_361, pos_356)
    let (local ret_338) = add(pos_356, i_361)
    return (ret_338)
end

func __warp_block_34(_1 : Uint256, _10 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    if
        eq(match_var, Uint256(low=16192718, high=0)).low + eq(match_var, Uint256(low=16192718, high=0)).high !=
        0:
        __warp_block_39(_1, _4, _7)
        if
            eq(match_var, Uint256(low=117300739, high=0)).low + eq(match_var, Uint256(low=117300739, high=0)).high !=
            0:
            __warp_block_40(_1, _4, _7)
            if
                eq(match_var, Uint256(low=309457050, high=0)).low + eq(match_var, Uint256(low=309457050, high=0)).high !=
                0:
                __warp_block_41(_1, _4)
                if
                    eq(match_var, Uint256(low=404098525, high=0)).low + eq(match_var, Uint256(low=404098525, high=0)).high !=
                    0:
                    __warp_block_42(_1, _4, _7)
                    if
                        eq(match_var, Uint256(low=826074471, high=0)).low + eq(match_var, Uint256(low=826074471, high=0)).high !=
                        0:
                        __warp_block_43(_1, _4, _7)
                        if
                            eq(match_var, Uint256(low=1206382372, high=0)).low + eq(match_var, Uint256(low=1206382372, high=0)).high !=
                            0:
                            __warp_block_44(_1, _4, _7)
                            if
                                eq(match_var, Uint256(low=1607020700, high=0)).low + eq(match_var, Uint256(low=1607020700, high=0)).high !=
                                0:
                                __warp_block_45(_1, _4)
                                if
                                    eq(match_var, Uint256(low=1889567281, high=0)).low + eq(match_var, Uint256(low=1889567281, high=0)).high !=
                                    0:
                                    __warp_block_46(_1, _4, _7)
                                    if
                                        eq(match_var, Uint256(low=2514000705, high=0)).low + eq(match_var, Uint256(low=2514000705, high=0)).high !=
                                        0:
                                        __warp_block_47(_1, _4, _7)
                                        if
                                            eq(match_var, Uint256(low=3714247998, high=0)).low + eq(match_var, Uint256(low=3714247998, high=0)).high !=
                                            0:
                                            __warp_block_48(_1, _4, _7)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return ()
end

func __warp_block_35(
        _2_314 : Uint256, _7_319 : Uint256, dataPos : Uint256, i_331 : Uint256,
        pos_327 : Uint256) -> (dataPos : Uint256, i_331 : Uint256):
    alloc_locals
    let (local _18_332 : Uint256) = sload(dataPos)
    let (local _19_333 : Uint256) = add(pos_327, i_331)
    mstore(_19_333, _18_332)
    let (local dataPos) = add(dataPos, _2_314)
    let (local i_331) = add(i_331, _7_319)
    return (dataPos, i_331)
end

func __warp_block_36(
        _2_314 : Uint256, _7_319 : Uint256, dataPos : Uint256, i_331 : Uint256,
        pos_327 : Uint256) -> (
        _2_314 : Uint256, _7_319 : Uint256, dataPos : Uint256, i_331 : Uint256, pos_327 : Uint256):
    alloc_locals
    if lt(i_331, length_313).low + lt(i_331, length_313).high != 0:
        let (local dataPos, local i_331) = __warp_block_35(_2_314, _7_319, dataPos, i_331, pos_327)
        let (local dataPos, local i_331) = __warp_block_36(_2_314, _7_319, dataPos, i_331, pos_327)
    end
    return (_2_314, _7_319, dataPos, i_331, pos_327)
end

func __warp_block_37(
        _2_339 : Uint256, _8_348 : Uint256, dataPos_360 : Uint256, i_361 : Uint256,
        pos_356 : Uint256) -> (dataPos_360 : Uint256, i_361 : Uint256):
    alloc_locals
    let (local _19_362 : Uint256) = sload(dataPos_360)
    let (local _20_363 : Uint256) = add(pos_356, i_361)
    mstore(_20_363, _19_362)
    let (local dataPos_360) = add(dataPos_360, _2_339)
    let (local i_361) = add(i_361, _8_348)
    return (dataPos_360, i_361)
end

func __warp_block_38(
        _2_339 : Uint256, _8_348 : Uint256, dataPos_360 : Uint256, i_361 : Uint256,
        pos_356 : Uint256) -> (
        _2_339 : Uint256, _8_348 : Uint256, dataPos_360 : Uint256, i_361 : Uint256,
        pos_356 : Uint256):
    alloc_locals
    if lt(i_361, length_342).low + lt(i_361, length_342).high != 0:
        let (local dataPos_360, local i_361) = __warp_block_37(
            _2_339, _8_348, dataPos_360, i_361, pos_356)
        let (local dataPos_360, local i_361) = __warp_block_38(
            _2_339, _8_348, dataPos_360, i_361, pos_356)
    end
    return (_2_339, _8_348, dataPos_360, i_361, pos_356)
end

func __warp_block_39(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _11 : Uint256 = _4
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_address(_4)
    fun_withdraw(param, param_1)
    let (local _12 : Uint256) = mload(_1)
    return (_12, _7)
    return ()
end

func __warp_block_40(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _13 : Uint256) = callvalue()
    if _13.low + _13.high != 0:
        revert(_7, _7)
    end
    local _14 : Uint256 = _4
    abi_decode(_4)
    let (local ret__warp_mangled : Uint256) = read_from_storage_dynamic_split_string()
    let (local memPos : Uint256) = mload(_1)
    let (local _15 : Uint256) = abi_encode_string(memPos, ret__warp_mangled)
    let (local _16 : Uint256) = sub(_15, memPos)
    return (memPos, _16)
    return ()
end

func __warp_block_41(_1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _17 : Uint256 = _4
    let (local param_2 : Uint256, local param_3 : Uint256,
        local param_4 : Uint256) = abi_decode_addresst_uint256t_address(_4)
    let (local ret_1 : Uint256) = fun_approve(param_2, param_3, param_4)
    let (local memPos_1 : Uint256) = mload(_1)
    let (local _18 : Uint256) = abi_encode_bool(memPos_1, ret_1)
    let (local _19 : Uint256) = sub(_18, memPos_1)
    return (memPos_1, _19)
    return ()
end

func __warp_block_42(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _20 : Uint256) = callvalue()
    if _20.low + _20.high != 0:
        revert(_7, _7)
    end
    local _21 : Uint256 = _4
    abi_decode(_4)
    local _22 : Uint256 = Uint256(low=3, high=0)
    let (local ret_2 : Uint256) = sload(_22)
    let (local memPos_2 : Uint256) = mload(_1)
    let (local _23 : Uint256) = abi_encode_uint256(memPos_2, ret_2)
    let (local _24 : Uint256) = sub(_23, memPos_2)
    return (memPos_2, _24)
    return ()
end

func __warp_block_43(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _25 : Uint256) = callvalue()
    if _25.low + _25.high != 0:
        revert(_7, _7)
    end
    local _26 : Uint256 = _4
    abi_decode(_4)
    local _27 : Uint256 = Uint256(low=255, high=0)
    local _28 : Uint256 = Uint256(low=2, high=0)
    let (local _29 : Uint256) = sload(_28)
    let (local ret_3 : Uint256) = and(_29, _27)
    let (local memPos_3 : Uint256) = mload(_1)
    let (local _30 : Uint256) = abi_encode_uint8(memPos_3, ret_3)
    let (local _31 : Uint256) = sub(_30, memPos_3)
    return (memPos_3, _31)
    return ()
end

func __warp_block_44(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    local _32 : Uint256 = _4
    let (local param_5 : Uint256, local param_6 : Uint256) = abi_decode_addresst_uint256(_4)
    fun_deposit(param_5, param_6)
    let (local _33 : Uint256) = mload(_1)
    return (_33, _7)
    return ()
end

func __warp_block_45(_1 : Uint256, _4 : Uint256) -> ():
    alloc_locals
    local _34 : Uint256 = _4
    let (local param_7 : Uint256, local param_8 : Uint256, local param_9 : Uint256,
        local param_10 : Uint256) = abi_decode_addresst_addresst_uint256t_address(_4)
    let (local ret_4 : Uint256) = fun_transferFrom(param_7, param_8, param_9, param_10)
    let (local memPos_4 : Uint256) = mload(_1)
    let (local _35 : Uint256) = abi_encode_bool(memPos_4, ret_4)
    let (local _36 : Uint256) = sub(_35, memPos_4)
    return (memPos_4, _36)
    return ()
end

func __warp_block_46(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _37 : Uint256) = callvalue()
    if _37.low + _37.high != 0:
        revert(_7, _7)
    end
    local _38 : Uint256 = _4
    let (local _39 : Uint256) = abi_decode_address(_4)
    let (local ret_5 : Uint256) = getter_fun_balanceOf(_39)
    let (local memPos_5 : Uint256) = mload(_1)
    let (local _40 : Uint256) = abi_encode_uint256(memPos_5, ret_5)
    let (local _41 : Uint256) = sub(_40, memPos_5)
    return (memPos_5, _41)
    return ()
end

func __warp_block_47(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _42 : Uint256) = callvalue()
    if _42.low + _42.high != 0:
        revert(_7, _7)
    end
    local _43 : Uint256 = _4
    abi_decode(_4)
    let (local ret_6 : Uint256) = read_from_storage_dynamic_split_string_1556()
    let (local memPos_6 : Uint256) = mload(_1)
    let (local _44 : Uint256) = abi_encode_string(memPos_6, ret_6)
    let (local _45 : Uint256) = sub(_44, memPos_6)
    return (memPos_6, _45)
    return ()
end

func __warp_block_48(_1 : Uint256, _4 : Uint256, _7 : Uint256) -> ():
    alloc_locals
    let (local _46 : Uint256) = callvalue()
    if _46.low + _46.high != 0:
        revert(_7, _7)
    end
    local _47 : Uint256 = _4
    let (local param_11 : Uint256, local param_12 : Uint256) = abi_decode_addresst_address(_4)
    let (
        local _48 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address_1558(
        param_11)
    let (
        local _49 : Uint256) = mapping_index_access_mapping_address_mapping_address_uint256_of_address(
        _48, param_12)
    let (local value : Uint256) = sload(_49)
    let (local memPos_7 : Uint256) = mload(_1)
    let (local _50 : Uint256) = abi_encode_uint256(memPos_7, value)
    let (local _51 : Uint256) = sub(_50, memPos_7)
    return (memPos_7, _51)
    return ()
end

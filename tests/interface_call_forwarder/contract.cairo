%lang starknet

// This is a transpile version of the following code: 
// ------------------------------------------------- SOLIDITY CONTRACT -------------------------------------------------
// SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.0;

// struct T{
//     uint a;
//     uint b;
// }

// struct S {
//     uint x;
//     uint y;
//     uint8 z;
//     T t;
// }

// contract A{
//     function add(uint256 a, uint8 b) public pure returns (uint256) {
//         return a + b;
//     }

//     function arrayAdd(uint256[] memory a, uint8 b) public pure returns (uint256[] memory) {
//         for (uint256 i = 0; i < a.length; i++) {
//             a[i] += b;
//         }
//         return a;
//     }

//     function staticArrayAdd(uint256[3] memory a, uint8[3] calldata b) public pure returns (uint256[3] memory) {
//         for (uint256 i = 0; i < a.length; i++) {
//             a[i] += b[i];
//         }
//         return a;
//     }

//     function structAdd(S memory s, uint8 b) public pure returns (S memory) {
//         s.x += b;
//         s.y += b;
//         s.z += b;
//         s.t.a += b;
//         s.t.b += b;
//         return s;
//     }

//     function structArrayAdd(S[] memory s, uint8 b) public pure returns (S[] memory) {
//         for (uint256 i = 0; i < s.length; i++) {
//             s[i].x += b;
//             s[i].y += b;
//             s[i].z += b;
//             s[i].t.a += b;
//             s[i].t.b += b;
//         }
//         return s;
//     }

//     function staticStructArrayAdd(S[3] memory s, uint8[3] calldata b) public pure returns (S[3] memory) {
//         for (uint256 i = 0; i < s.length; i++) {
//             s[i].x += b[i];
//             s[i].y += b[i];
//             s[i].z += b[i];
//             s[i].t.a += b[i];
//             s[i].t.b += b[i];
//         }
//         return s;
//     }

//     function array2Dadd(uint256[3][] memory a, uint8[3][] calldata b) public pure returns (uint256[3][] memory) {
//         for (uint256 i = 0; i < a.length; i++) {
//             for (uint256 j = 0; j < a[i].length; j++) {
//                 a[i][j] += b[i][j];
//             }
//         }
//         return a;
//     }

//     function array2DaddStatic(uint256[3][3] memory a, uint8[3][3] calldata b) public pure returns (uint256[3][3] memory) {
//         for (uint256 i = 0; i < a.length; i++) {
//             for (uint256 j = 0; j < a[i].length; j++) {
//                 a[i][j] += b[i][j];
//             }
//         }
//         return a;
//     }
// }
// ---------------------------------------------- END OF THE SOLIDITY CONTRACT --------------------------------------

from warplib.memory import (
    wm_read_id,
    wm_read_256,
    wm_read_felt,
    wm_write_256,
    wm_write_felt,
    wm_new,
    wm_alloc,
    wm_index_static,
    wm_dyn_array_length,
    wm_index_dyn,
)
from starkware.cairo.common.uint256 import uint256_sub, uint256_add, Uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from starkware.cairo.common.dict import dict_read, dict_write
from warplib.maths.external_input_check_ints import (
    warp_external_input_check_int256,
    warp_external_input_check_int8,
)
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.lt import warp_lt256
from warplib.maths.add import warp_add256, warp_add8
from warplib.maths.sub import warp_sub256
from warplib.maths.int_conversions import warp_uint256
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize

struct T_846b7b6d {
    warp_usrid_00_a: Uint256,
    warp_usrid_01_b: Uint256,
}

struct S_a9463b19 {
    warp_usrid_02_x: Uint256,
    warp_usrid_03_y: Uint256,
    warp_usrid_04_z: felt,
    warp_usrid_05_t: T_846b7b6d,
}

struct cd_dynarray_Uint256 {
    len: felt,
    ptr: Uint256*,
}

struct cd_dynarray_S_a9463b19 {
    len: felt,
    ptr: S_a9463b19*,
}

struct cd_dynarray_arr_3_felt {
    len: felt,
    ptr: (felt, felt, felt)*,
}

struct cd_dynarray_arr_3_Uint256 {
    len: felt,
    ptr: (Uint256, Uint256, Uint256)*,
}

func WM0_S_a9463b19_warp_usrid_02_x(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM1_S_a9463b19_warp_usrid_03_y(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func WM2_S_a9463b19_warp_usrid_04_z(loc: felt) -> (memberLoc: felt) {
    return (loc + 4,);
}

func WM4_S_a9463b19_warp_usrid_05_t(loc: felt) -> (memberLoc: felt) {
    return (loc + 5,);
}

func WM3_T_846b7b6d_warp_usrid_00_a(loc: felt) -> (memberLoc: felt) {
    return (loc,);
}

func WM5_T_846b7b6d_warp_usrid_01_b(loc: felt) -> (memberLoc: felt) {
    return (loc + 2,);
}

func wm_to_calldata0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: cd_dynarray_Uint256) {
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr: Uint256*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata1(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_Uint256(len=len_felt, ptr=ptr),);
}

func wm_to_calldata1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(len: felt, ptr: Uint256*, mem_loc: felt) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    let (mem_read0) = wm_read_256(mem_loc);
    assert ptr[0] = mem_read0;
    wm_to_calldata1(len=len - 1, ptr=ptr + 2, mem_loc=mem_loc + 2);
    return ();
}

func wm_to_calldata3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: (Uint256, Uint256, Uint256)) {
    alloc_locals;
    let (member0) = wm_read_256(mem_loc);
    let (member1) = wm_read_256(mem_loc + 2);
    let (member2) = wm_read_256(mem_loc + 4);
    return ((member0, member1, member2),);
}

func wm_to_calldata4{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: S_a9463b19) {
    alloc_locals;
    let (member0) = wm_read_256(mem_loc);
    let (member1) = wm_read_256(mem_loc + 2);
    let (member2) = wm_read_felt(mem_loc + 4);
    let (read_3) = wm_read_id(mem_loc + 5, Uint256(0x1, 0x0));
    let (member3) = wm_to_calldata5(read_3);
    return (S_a9463b19(member0, member1, member2, member3),);
}

func wm_to_calldata5{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: T_846b7b6d) {
    alloc_locals;
    let (member0) = wm_read_256(mem_loc);
    let (member1) = wm_read_256(mem_loc + 2);
    return (T_846b7b6d(member0, member1),);
}

func wm_to_calldata6{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: cd_dynarray_S_a9463b19) {
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr: S_a9463b19*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata7(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_S_a9463b19(len=len_felt, ptr=ptr),);
}

func wm_to_calldata7{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(len: felt, ptr: S_a9463b19*, mem_loc: felt) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    let (mem_read0) = wm_read_id(mem_loc, Uint256(0x1, 0x0));
    let (mem_read1) = wm_to_calldata4(mem_read0);
    assert ptr[0] = mem_read1;
    wm_to_calldata7(len=len - 1, ptr=ptr + 9, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_calldata9{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: (S_a9463b19, S_a9463b19, S_a9463b19)) {
    alloc_locals;
    let (read0) = wm_read_id(mem_loc, Uint256(0x1, 0x0));
    let (member0) = wm_to_calldata4(read0);
    let (read1) = wm_read_id(mem_loc + 1, Uint256(0x1, 0x0));
    let (member1) = wm_to_calldata4(read1);
    let (read2) = wm_read_id(mem_loc + 2, Uint256(0x1, 0x0));
    let (member2) = wm_to_calldata4(read2);
    return ((member0, member1, member2),);
}

func wm_to_calldata10{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (retData: cd_dynarray_arr_3_Uint256) {
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr: (Uint256, Uint256, Uint256)*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata11(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_arr_3_Uint256(len=len_felt, ptr=ptr),);
}

func wm_to_calldata11{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(len: felt, ptr: (Uint256, Uint256, Uint256)*, mem_loc: felt) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    let (mem_read0) = wm_read_id(mem_loc, Uint256(0x1, 0x0));
    let (mem_read1) = wm_to_calldata3(mem_read0);
    assert ptr[0] = mem_read1;
    wm_to_calldata11(len=len - 1, ptr=ptr + 6, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_calldata13{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(mem_loc: felt) -> (
    retData: ((Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256))
) {
    alloc_locals;
    let (read0) = wm_read_id(mem_loc, Uint256(0x1, 0x0));
    let (member0) = wm_to_calldata3(read0);
    let (read1) = wm_read_id(mem_loc + 1, Uint256(0x1, 0x0));
    let (member1) = wm_to_calldata3(read1);
    let (read2) = wm_read_id(mem_loc + 2, Uint256(0x1, 0x0));
    let (member2) = wm_to_calldata3(read2);
    return ((member0, member1, member2),);
}

func extern_input_check0{range_check_ptr: felt}(len: felt, ptr: Uint256*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    warp_external_input_check_int256(ptr[0]);
    extern_input_check0(len=len - 1, ptr=ptr + 2);
    return ();
}

func extern_input_check1{range_check_ptr: felt}(arg: (Uint256, Uint256, Uint256)) -> () {
    alloc_locals;
    warp_external_input_check_int256(arg[0]);
    warp_external_input_check_int256(arg[1]);
    warp_external_input_check_int256(arg[2]);
    return ();
}

func extern_input_check2{range_check_ptr: felt}(arg: (felt, felt, felt)) -> () {
    alloc_locals;
    warp_external_input_check_int8(arg[0]);
    warp_external_input_check_int8(arg[1]);
    warp_external_input_check_int8(arg[2]);
    return ();
}

func extern_input_check3{range_check_ptr: felt}(arg: S_a9463b19) -> () {
    alloc_locals;
    warp_external_input_check_int256(arg.warp_usrid_02_x);
    warp_external_input_check_int256(arg.warp_usrid_03_y);
    warp_external_input_check_int8(arg.warp_usrid_04_z);
    extern_input_check4(arg.warp_usrid_05_t);
    return ();
}

func extern_input_check4{range_check_ptr: felt}(arg: T_846b7b6d) -> () {
    alloc_locals;
    warp_external_input_check_int256(arg.warp_usrid_00_a);
    warp_external_input_check_int256(arg.warp_usrid_01_b);
    return ();
}

func extern_input_check5{range_check_ptr: felt}(len: felt, ptr: S_a9463b19*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    extern_input_check3(ptr[0]);
    extern_input_check5(len=len - 1, ptr=ptr + 9);
    return ();
}

func extern_input_check6{range_check_ptr: felt}(arg: (S_a9463b19, S_a9463b19, S_a9463b19)) -> () {
    alloc_locals;
    extern_input_check3(arg[0]);
    extern_input_check3(arg[1]);
    extern_input_check3(arg[2]);
    return ();
}

func extern_input_check7{range_check_ptr: felt}(len: felt, ptr: (Uint256, Uint256, Uint256)*) -> (
    ) {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    extern_input_check1(ptr[0]);
    extern_input_check7(len=len - 1, ptr=ptr + 6);
    return ();
}

func extern_input_check8{range_check_ptr: felt}(len: felt, ptr: (felt, felt, felt)*) -> () {
    alloc_locals;
    if (len == 0) {
        return ();
    }
    extern_input_check2(ptr[0]);
    extern_input_check8(len=len - 1, ptr=ptr + 3);
    return ();
}

func extern_input_check9{range_check_ptr: felt}(
    arg: ((Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256))
) -> () {
    alloc_locals;
    extern_input_check1(arg[0]);
    extern_input_check1(arg[1]);
    extern_input_check1(arg[2]);
    return ();
}

func extern_input_check10{range_check_ptr: felt}(
    arg: ((felt, felt, felt), (felt, felt, felt), (felt, felt, felt))
) -> () {
    alloc_locals;
    extern_input_check2(arg[0]);
    extern_input_check2(arg[1]);
    extern_input_check2(arg[2]);
    return ();
}

func cd_to_memory0_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: Uint256*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    dict_write{dict_ptr=warp_memory}(mem_start, calldata[0].low);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata[0].high);
    return cd_to_memory0_elem(calldata + 2, mem_start + 2, length - 1);
}
func cd_to_memory0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_Uint256) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x2, 0x0));
    cd_to_memory0_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func cd_to_memory1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: (Uint256, Uint256, Uint256)) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x6, 0x0));
    dict_write{dict_ptr=warp_memory}(mem_start, calldata[0].low);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata[0].high);
    dict_write{dict_ptr=warp_memory}(mem_start + 1 * 2, calldata[1].low);
    dict_write{dict_ptr=warp_memory}(mem_start + 1 * 2 + 1, calldata[1].high);
    dict_write{dict_ptr=warp_memory}(mem_start + 2 * 2, calldata[2].low);
    dict_write{dict_ptr=warp_memory}(mem_start + 2 * 2 + 1, calldata[2].high);
    return (mem_start,);
}

func cd_to_memory2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: (felt, felt, felt)) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x3, 0x0));
    dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata[1]);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, calldata[2]);
    return (mem_start,);
}

func cd_to_memory3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: S_a9463b19) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x6, 0x0));
    dict_write{dict_ptr=warp_memory}(mem_start, calldata.warp_usrid_02_x.low);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata.warp_usrid_02_x.high);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, calldata.warp_usrid_03_y.low);
    dict_write{dict_ptr=warp_memory}(mem_start + 3, calldata.warp_usrid_03_y.high);
    dict_write{dict_ptr=warp_memory}(mem_start + 4, calldata.warp_usrid_04_z);
    let (m5) = cd_to_memory4(calldata.warp_usrid_05_t);
    dict_write{dict_ptr=warp_memory}(mem_start + 5, m5);
    return (mem_start,);
}

func cd_to_memory4{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: T_846b7b6d) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x4, 0x0));
    dict_write{dict_ptr=warp_memory}(mem_start, calldata.warp_usrid_00_a.low);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, calldata.warp_usrid_00_a.high);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, calldata.warp_usrid_01_b.low);
    dict_write{dict_ptr=warp_memory}(mem_start + 3, calldata.warp_usrid_01_b.high);
    return (mem_start,);
}

func cd_to_memory5_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: S_a9463b19*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory3(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    return cd_to_memory5_elem(calldata + 9, mem_start + 1, length - 1);
}
func cd_to_memory5{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_S_a9463b19) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory5_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func cd_to_memory6{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: (S_a9463b19, S_a9463b19, S_a9463b19)) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x3, 0x0));
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory3(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    let cdElem = calldata[1];
    let (mElem) = cd_to_memory3(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, mElem);
    let cdElem = calldata[2];
    let (mElem) = cd_to_memory3(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, mElem);
    return (mem_start,);
}

func cd_to_memory7_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: (Uint256, Uint256, Uint256)*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory1(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    return cd_to_memory7_elem(calldata + 6, mem_start + 1, length - 1);
}
func cd_to_memory7{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_arr_3_Uint256) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory7_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func cd_to_memory8_elem{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: (felt, felt, felt)*, mem_start: felt, length: felt) {
    alloc_locals;
    if (length == 0) {
        return ();
    }
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory2(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    return cd_to_memory8_elem(calldata + 3, mem_start + 1, length - 1);
}
func cd_to_memory8{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: cd_dynarray_arr_3_felt) -> (mem_loc: felt) {
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory8_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func cd_to_memory9{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(
    calldata: (
        (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256)
    ),
) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x3, 0x0));
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory1(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    let cdElem = calldata[1];
    let (mElem) = cd_to_memory1(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, mElem);
    let cdElem = calldata[2];
    let (mElem) = cd_to_memory1(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, mElem);
    return (mem_start,);
}

func cd_to_memory10{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt, warp_memory: DictAccess*
}(calldata: ((felt, felt, felt), (felt, felt, felt), (felt, felt, felt))) -> (mem_loc: felt) {
    alloc_locals;
    let (mem_start) = wm_alloc(Uint256(0x3, 0x0));
    let cdElem = calldata[0];
    let (mElem) = cd_to_memory2(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start, mElem);
    let cdElem = calldata[1];
    let (mElem) = cd_to_memory2(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 1, mElem);
    let cdElem = calldata[2];
    let (mElem) = cd_to_memory2(cdElem);
    dict_write{dict_ptr=warp_memory}(mem_start + 2, mElem);
    return (mem_start,);
}

// Contract Def A

namespace A {
    // Dynamic variables - Arrays and Maps

    // Static variables

    func warp_while7{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_30_i: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_28_b: felt,
    ) -> (
        warp_usrid_30_i: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_28_b: felt,
    ) {
        alloc_locals;

        let (warp_se_0) = warp_lt256(warp_usrid_30_i, Uint256(low=3, high=0));

        if (warp_se_0 != 0) {
            let warp_usrid_31_j = Uint256(low=0, high=0);

            let (warp_tv_0, warp_td_0, warp_tv_2, warp_td_1) = warp_while6(
                warp_usrid_31_j,
                warp_usrid_27_acd_to_wm_param_,
                warp_usrid_30_i,
                cd_to_wm_warp_usrid_28_b,
            );

            let warp_tv_1 = warp_td_0;

            let warp_tv_3 = warp_td_1;

            let cd_to_wm_warp_usrid_28_b = warp_tv_3;

            let warp_usrid_30_i = warp_tv_2;

            let warp_usrid_27_acd_to_wm_param_ = warp_tv_1;

            let warp_usrid_31_j = warp_tv_0;

            let (warp_pse_0) = warp_add256(warp_usrid_30_i, Uint256(low=1, high=0));

            let warp_usrid_30_i = warp_pse_0;

            warp_sub256(warp_pse_0, Uint256(low=1, high=0));

            let (warp_usrid_30_i, warp_td_2, warp_td_3) = warp_while7_if_part1(
                warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b
            );

            let warp_usrid_27_acd_to_wm_param_ = warp_td_2;

            let cd_to_wm_warp_usrid_28_b = warp_td_3;

            return (
                warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b
            );
        } else {
            let warp_usrid_30_i = warp_usrid_30_i;

            let warp_usrid_27_acd_to_wm_param_ = warp_usrid_27_acd_to_wm_param_;

            let cd_to_wm_warp_usrid_28_b = cd_to_wm_warp_usrid_28_b;

            return (
                warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b
            );
        }
    }

    func warp_while7_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_30_i: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_28_b: felt,
    ) -> (
        warp_usrid_30_i: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_28_b: felt,
    ) {
        alloc_locals;

        let (warp_usrid_30_i, warp_td_6, warp_td_7) = warp_while7(
            warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b
        );

        let warp_usrid_27_acd_to_wm_param_ = warp_td_6;

        let cd_to_wm_warp_usrid_28_b = warp_td_7;

        return (warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b);
    }

    func warp_while6{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_31_j: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        warp_usrid_30_i: Uint256,
        cd_to_wm_warp_usrid_28_b: felt,
    ) -> (
        warp_usrid_31_j: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        warp_usrid_30_i: Uint256,
        cd_to_wm_warp_usrid_28_b: felt,
    ) {
        alloc_locals;

        let (warp_se_1) = warp_lt256(warp_usrid_31_j, Uint256(low=3, high=0));

        if (warp_se_1 != 0) {
            let warp_cs_0 = warp_usrid_31_j;

            let warp_cs_1 = warp_usrid_30_i;

            let (warp_se_2) = wm_index_static(
                warp_usrid_27_acd_to_wm_param_,
                warp_cs_1,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_3) = wm_read_id(warp_se_2, Uint256(low=6, high=0));

            let (warp_se_4) = wm_index_static(
                warp_se_3, warp_cs_0, Uint256(low=2, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_5) = wm_index_static(
                warp_usrid_27_acd_to_wm_param_,
                warp_cs_1,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_6) = wm_read_id(warp_se_5, Uint256(low=6, high=0));

            let (warp_se_7) = wm_index_static(
                warp_se_6, warp_cs_0, Uint256(low=2, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_8) = wm_read_256(warp_se_7);

            let (warp_se_9) = wm_index_static(
                cd_to_wm_warp_usrid_28_b,
                warp_usrid_30_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_10) = wm_read_id(warp_se_9, Uint256(low=3, high=0));

            let (warp_se_11) = wm_index_static(
                warp_se_10, warp_usrid_31_j, Uint256(low=1, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_12) = wm_read_felt(warp_se_11);

            let (warp_se_13) = warp_uint256(warp_se_12);

            let (warp_se_14) = warp_add256(warp_se_8, warp_se_13);

            wm_write_256(warp_se_4, warp_se_14);

            let (warp_pse_1) = warp_add256(warp_usrid_31_j, Uint256(low=1, high=0));

            let warp_usrid_31_j = warp_pse_1;

            warp_sub256(warp_pse_1, Uint256(low=1, high=0));

            let (
                warp_usrid_31_j, warp_td_8, warp_usrid_30_i, warp_td_9
            ) = warp_while6_if_part1(
                warp_usrid_31_j,
                warp_usrid_27_acd_to_wm_param_,
                warp_usrid_30_i,
                cd_to_wm_warp_usrid_28_b,
            );

            let warp_usrid_27_acd_to_wm_param_ = warp_td_8;

            let cd_to_wm_warp_usrid_28_b = warp_td_9;

            return (
                warp_usrid_31_j,
                warp_usrid_27_acd_to_wm_param_,
                warp_usrid_30_i,
                cd_to_wm_warp_usrid_28_b,
            );
        } else {
            let warp_usrid_31_j = warp_usrid_31_j;

            let warp_usrid_27_acd_to_wm_param_ = warp_usrid_27_acd_to_wm_param_;

            let warp_usrid_30_i = warp_usrid_30_i;

            let cd_to_wm_warp_usrid_28_b = cd_to_wm_warp_usrid_28_b;

            return (
                warp_usrid_31_j,
                warp_usrid_27_acd_to_wm_param_,
                warp_usrid_30_i,
                cd_to_wm_warp_usrid_28_b,
            );
        }
    }

    func warp_while6_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_31_j: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        warp_usrid_30_i: Uint256,
        cd_to_wm_warp_usrid_28_b: felt,
    ) -> (
        warp_usrid_31_j: Uint256,
        warp_usrid_27_acd_to_wm_param_: felt,
        warp_usrid_30_i: Uint256,
        cd_to_wm_warp_usrid_28_b: felt,
    ) {
        alloc_locals;

        let (warp_usrid_31_j, warp_td_12, warp_usrid_30_i, warp_td_13) = warp_while6(
            warp_usrid_31_j,
            warp_usrid_27_acd_to_wm_param_,
            warp_usrid_30_i,
            cd_to_wm_warp_usrid_28_b,
        );

        let warp_usrid_27_acd_to_wm_param_ = warp_td_12;

        let cd_to_wm_warp_usrid_28_b = warp_td_13;

        return (
            warp_usrid_31_j,
            warp_usrid_27_acd_to_wm_param_,
            warp_usrid_30_i,
            cd_to_wm_warp_usrid_28_b,
        );
    }

    func warp_while5{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_25_i: Uint256, warp_usrid_22_a_mem: felt, cd_to_wm_warp_usrid_23_b: felt
    ) -> (
        warp_usrid_25_i: Uint256, warp_usrid_22_a_mem: felt, cd_to_wm_warp_usrid_23_b: felt
    ) {
        alloc_locals;

        let (warp_se_15) = wm_dyn_array_length(warp_usrid_22_a_mem);

        let (warp_se_16) = warp_lt256(warp_usrid_25_i, warp_se_15);

        if (warp_se_16 != 0) {
            let warp_usrid_26_j = Uint256(low=0, high=0);

            let (warp_tv_4, warp_td_14, warp_tv_6, warp_td_15) = warp_while4(
                warp_usrid_26_j,
                warp_usrid_22_a_mem,
                warp_usrid_25_i,
                cd_to_wm_warp_usrid_23_b,
            );

            let warp_tv_5 = warp_td_14;

            let warp_tv_7 = warp_td_15;

            let cd_to_wm_warp_usrid_23_b = warp_tv_7;

            let warp_usrid_25_i = warp_tv_6;

            let warp_usrid_22_a_mem = warp_tv_5;

            let warp_usrid_26_j = warp_tv_4;

            let (warp_pse_2) = warp_add256(warp_usrid_25_i, Uint256(low=1, high=0));

            let warp_usrid_25_i = warp_pse_2;

            warp_sub256(warp_pse_2, Uint256(low=1, high=0));

            let (warp_usrid_25_i, warp_td_16, warp_td_17) = warp_while5_if_part1(
                warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b
            );

            let warp_usrid_22_a_mem = warp_td_16;

            let cd_to_wm_warp_usrid_23_b = warp_td_17;

            return (warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b);
        } else {
            let warp_usrid_25_i = warp_usrid_25_i;

            let warp_usrid_22_a_mem = warp_usrid_22_a_mem;

            let cd_to_wm_warp_usrid_23_b = cd_to_wm_warp_usrid_23_b;

            return (warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b);
        }
    }

    func warp_while5_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_25_i: Uint256, warp_usrid_22_a_mem: felt, cd_to_wm_warp_usrid_23_b: felt
    ) -> (
        warp_usrid_25_i: Uint256, warp_usrid_22_a_mem: felt, cd_to_wm_warp_usrid_23_b: felt
    ) {
        alloc_locals;

        let (warp_usrid_25_i, warp_td_20, warp_td_21) = warp_while5(
            warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b
        );

        let warp_usrid_22_a_mem = warp_td_20;

        let cd_to_wm_warp_usrid_23_b = warp_td_21;

        return (warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b);
    }

    func warp_while4{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_26_j: Uint256,
        warp_usrid_22_a_mem: felt,
        warp_usrid_25_i: Uint256,
        cd_to_wm_warp_usrid_23_b: felt,
    ) -> (
        warp_usrid_26_j: Uint256,
        warp_usrid_22_a_mem: felt,
        warp_usrid_25_i: Uint256,
        cd_to_wm_warp_usrid_23_b: felt,
    ) {
        alloc_locals;

        let (warp_se_17) = warp_lt256(warp_usrid_26_j, Uint256(low=3, high=0));

        if (warp_se_17 != 0) {
            let warp_cs_2 = warp_usrid_26_j;

            let warp_cs_3 = warp_usrid_25_i;

            let (warp_se_18) = wm_index_dyn(
                warp_usrid_22_a_mem, warp_cs_3, Uint256(low=1, high=0)
            );

            let (warp_se_19) = wm_read_id(warp_se_18, Uint256(low=6, high=0));

            let (warp_se_20) = wm_index_static(
                warp_se_19, warp_cs_2, Uint256(low=2, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_21) = wm_index_dyn(
                warp_usrid_22_a_mem, warp_cs_3, Uint256(low=1, high=0)
            );

            let (warp_se_22) = wm_read_id(warp_se_21, Uint256(low=6, high=0));

            let (warp_se_23) = wm_index_static(
                warp_se_22, warp_cs_2, Uint256(low=2, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_24) = wm_read_256(warp_se_23);

            let (warp_se_25) = wm_index_dyn(
                cd_to_wm_warp_usrid_23_b, warp_usrid_25_i, Uint256(low=1, high=0)
            );

            let (warp_se_26) = wm_read_id(warp_se_25, Uint256(low=3, high=0));

            let (warp_se_27) = wm_index_static(
                warp_se_26, warp_usrid_26_j, Uint256(low=1, high=0), Uint256(low=3, high=0)
            );

            let (warp_se_28) = wm_read_felt(warp_se_27);

            let (warp_se_29) = warp_uint256(warp_se_28);

            let (warp_se_30) = warp_add256(warp_se_24, warp_se_29);

            wm_write_256(warp_se_20, warp_se_30);

            let (warp_pse_3) = warp_add256(warp_usrid_26_j, Uint256(low=1, high=0));

            let warp_usrid_26_j = warp_pse_3;

            warp_sub256(warp_pse_3, Uint256(low=1, high=0));

            let (
                warp_usrid_26_j, warp_td_22, warp_usrid_25_i, warp_td_23
            ) = warp_while4_if_part1(
                warp_usrid_26_j,
                warp_usrid_22_a_mem,
                warp_usrid_25_i,
                cd_to_wm_warp_usrid_23_b,
            );

            let warp_usrid_22_a_mem = warp_td_22;

            let cd_to_wm_warp_usrid_23_b = warp_td_23;

            return (
                warp_usrid_26_j,
                warp_usrid_22_a_mem,
                warp_usrid_25_i,
                cd_to_wm_warp_usrid_23_b,
            );
        } else {
            let warp_usrid_26_j = warp_usrid_26_j;

            let warp_usrid_22_a_mem = warp_usrid_22_a_mem;

            let warp_usrid_25_i = warp_usrid_25_i;

            let cd_to_wm_warp_usrid_23_b = cd_to_wm_warp_usrid_23_b;

            return (
                warp_usrid_26_j,
                warp_usrid_22_a_mem,
                warp_usrid_25_i,
                cd_to_wm_warp_usrid_23_b,
            );
        }
    }

    func warp_while4_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_26_j: Uint256,
        warp_usrid_22_a_mem: felt,
        warp_usrid_25_i: Uint256,
        cd_to_wm_warp_usrid_23_b: felt,
    ) -> (
        warp_usrid_26_j: Uint256,
        warp_usrid_22_a_mem: felt,
        warp_usrid_25_i: Uint256,
        cd_to_wm_warp_usrid_23_b: felt,
    ) {
        alloc_locals;

        let (warp_usrid_26_j, warp_td_26, warp_usrid_25_i, warp_td_27) = warp_while4(
            warp_usrid_26_j, warp_usrid_22_a_mem, warp_usrid_25_i, cd_to_wm_warp_usrid_23_b
        );

        let warp_usrid_22_a_mem = warp_td_26;

        let cd_to_wm_warp_usrid_23_b = warp_td_27;

        return (
            warp_usrid_26_j, warp_usrid_22_a_mem, warp_usrid_25_i, cd_to_wm_warp_usrid_23_b
        );
    }

    func warp_while3{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_21_i: Uint256,
        warp_usrid_18_scd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_19_b: felt,
    ) -> (
        warp_usrid_21_i: Uint256,
        warp_usrid_18_scd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_19_b: felt,
    ) {
        alloc_locals;

        let (warp_se_31) = warp_lt256(warp_usrid_21_i, Uint256(low=3, high=0));

        if (warp_se_31 != 0) {
            let warp_cs_4 = warp_usrid_21_i;

            let (warp_se_32) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_4,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_33) = wm_read_id(warp_se_32, Uint256(low=6, high=0));

            let (warp_se_34) = WM0_S_a9463b19_warp_usrid_02_x(warp_se_33);

            let (warp_se_35) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_4,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_36) = wm_read_id(warp_se_35, Uint256(low=6, high=0));

            let (warp_se_37) = WM0_S_a9463b19_warp_usrid_02_x(warp_se_36);

            let (warp_se_38) = wm_read_256(warp_se_37);

            let (warp_se_39) = wm_index_static(
                cd_to_wm_warp_usrid_19_b,
                warp_usrid_21_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_40) = wm_read_felt(warp_se_39);

            let (warp_se_41) = warp_uint256(warp_se_40);

            let (warp_se_42) = warp_add256(warp_se_38, warp_se_41);

            wm_write_256(warp_se_34, warp_se_42);

            let warp_cs_5 = warp_usrid_21_i;

            let (warp_se_43) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_5,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_44) = wm_read_id(warp_se_43, Uint256(low=6, high=0));

            let (warp_se_45) = WM1_S_a9463b19_warp_usrid_03_y(warp_se_44);

            let (warp_se_46) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_5,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_47) = wm_read_id(warp_se_46, Uint256(low=6, high=0));

            let (warp_se_48) = WM1_S_a9463b19_warp_usrid_03_y(warp_se_47);

            let (warp_se_49) = wm_read_256(warp_se_48);

            let (warp_se_50) = wm_index_static(
                cd_to_wm_warp_usrid_19_b,
                warp_usrid_21_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_51) = wm_read_felt(warp_se_50);

            let (warp_se_52) = warp_uint256(warp_se_51);

            let (warp_se_53) = warp_add256(warp_se_49, warp_se_52);

            wm_write_256(warp_se_45, warp_se_53);

            let warp_cs_6 = warp_usrid_21_i;

            let (warp_se_54) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_6,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_55) = wm_read_id(warp_se_54, Uint256(low=6, high=0));

            let (warp_se_56) = WM2_S_a9463b19_warp_usrid_04_z(warp_se_55);

            let (warp_se_57) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_6,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_58) = wm_read_id(warp_se_57, Uint256(low=6, high=0));

            let (warp_se_59) = WM2_S_a9463b19_warp_usrid_04_z(warp_se_58);

            let (warp_se_60) = wm_read_felt(warp_se_59);

            let (warp_se_61) = wm_index_static(
                cd_to_wm_warp_usrid_19_b,
                warp_usrid_21_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_62) = wm_read_felt(warp_se_61);

            let (warp_se_63) = warp_add8(warp_se_60, warp_se_62);

            wm_write_felt(warp_se_56, warp_se_63);

            let warp_cs_7 = warp_usrid_21_i;

            let (warp_se_64) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_7,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_65) = wm_read_id(warp_se_64, Uint256(low=6, high=0));

            let (warp_se_66) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_65);

            let (warp_se_67) = wm_read_id(warp_se_66, Uint256(low=4, high=0));

            let (warp_se_68) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_67);

            let (warp_se_69) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_7,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_70) = wm_read_id(warp_se_69, Uint256(low=6, high=0));

            let (warp_se_71) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_70);

            let (warp_se_72) = wm_read_id(warp_se_71, Uint256(low=4, high=0));

            let (warp_se_73) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_72);

            let (warp_se_74) = wm_read_256(warp_se_73);

            let (warp_se_75) = wm_index_static(
                cd_to_wm_warp_usrid_19_b,
                warp_usrid_21_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_76) = wm_read_felt(warp_se_75);

            let (warp_se_77) = warp_uint256(warp_se_76);

            let (warp_se_78) = warp_add256(warp_se_74, warp_se_77);

            wm_write_256(warp_se_68, warp_se_78);

            let warp_cs_8 = warp_usrid_21_i;

            let (warp_se_79) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_8,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_80) = wm_read_id(warp_se_79, Uint256(low=6, high=0));

            let (warp_se_81) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_80);

            let (warp_se_82) = wm_read_id(warp_se_81, Uint256(low=4, high=0));

            let (warp_se_83) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_82);

            let (warp_se_84) = wm_index_static(
                warp_usrid_18_scd_to_wm_param_,
                warp_cs_8,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_85) = wm_read_id(warp_se_84, Uint256(low=6, high=0));

            let (warp_se_86) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_85);

            let (warp_se_87) = wm_read_id(warp_se_86, Uint256(low=4, high=0));

            let (warp_se_88) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_87);

            let (warp_se_89) = wm_read_256(warp_se_88);

            let (warp_se_90) = wm_index_static(
                cd_to_wm_warp_usrid_19_b,
                warp_usrid_21_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_91) = wm_read_felt(warp_se_90);

            let (warp_se_92) = warp_uint256(warp_se_91);

            let (warp_se_93) = warp_add256(warp_se_89, warp_se_92);

            wm_write_256(warp_se_83, warp_se_93);

            let (warp_pse_4) = warp_add256(warp_usrid_21_i, Uint256(low=1, high=0));

            let warp_usrid_21_i = warp_pse_4;

            warp_sub256(warp_pse_4, Uint256(low=1, high=0));

            let (warp_usrid_21_i, warp_td_28, warp_td_29) = warp_while3_if_part1(
                warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b
            );

            let warp_usrid_18_scd_to_wm_param_ = warp_td_28;

            let cd_to_wm_warp_usrid_19_b = warp_td_29;

            return (
                warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b
            );
        } else {
            let warp_usrid_21_i = warp_usrid_21_i;

            let warp_usrid_18_scd_to_wm_param_ = warp_usrid_18_scd_to_wm_param_;

            let cd_to_wm_warp_usrid_19_b = cd_to_wm_warp_usrid_19_b;

            return (
                warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b
            );
        }
    }

    func warp_while3_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_21_i: Uint256,
        warp_usrid_18_scd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_19_b: felt,
    ) -> (
        warp_usrid_21_i: Uint256,
        warp_usrid_18_scd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_19_b: felt,
    ) {
        alloc_locals;

        let (warp_usrid_21_i, warp_td_32, warp_td_33) = warp_while3(
            warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b
        );

        let warp_usrid_18_scd_to_wm_param_ = warp_td_32;

        let cd_to_wm_warp_usrid_19_b = warp_td_33;

        return (warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b);
    }

    func warp_while2{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(warp_usrid_17_i: Uint256, warp_usrid_14_s_mem: felt, warp_usrid_15_b: felt) -> (
        warp_usrid_17_i: Uint256, warp_usrid_14_s_mem: felt, warp_usrid_15_b: felt
    ) {
        alloc_locals;

        let (warp_se_94) = wm_dyn_array_length(warp_usrid_14_s_mem);

        let (warp_se_95) = warp_lt256(warp_usrid_17_i, warp_se_94);

        if (warp_se_95 != 0) {
            let warp_cs_9 = warp_usrid_17_i;

            let (warp_se_96) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_9, Uint256(low=1, high=0)
            );

            let (warp_se_97) = wm_read_id(warp_se_96, Uint256(low=6, high=0));

            let (warp_se_98) = WM0_S_a9463b19_warp_usrid_02_x(warp_se_97);

            let (warp_se_99) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_9, Uint256(low=1, high=0)
            );

            let (warp_se_100) = wm_read_id(warp_se_99, Uint256(low=6, high=0));

            let (warp_se_101) = WM0_S_a9463b19_warp_usrid_02_x(warp_se_100);

            let (warp_se_102) = wm_read_256(warp_se_101);

            let (warp_se_103) = warp_uint256(warp_usrid_15_b);

            let (warp_se_104) = warp_add256(warp_se_102, warp_se_103);

            wm_write_256(warp_se_98, warp_se_104);

            let warp_cs_10 = warp_usrid_17_i;

            let (warp_se_105) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_10, Uint256(low=1, high=0)
            );

            let (warp_se_106) = wm_read_id(warp_se_105, Uint256(low=6, high=0));

            let (warp_se_107) = WM1_S_a9463b19_warp_usrid_03_y(warp_se_106);

            let (warp_se_108) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_10, Uint256(low=1, high=0)
            );

            let (warp_se_109) = wm_read_id(warp_se_108, Uint256(low=6, high=0));

            let (warp_se_110) = WM1_S_a9463b19_warp_usrid_03_y(warp_se_109);

            let (warp_se_111) = wm_read_256(warp_se_110);

            let (warp_se_112) = warp_uint256(warp_usrid_15_b);

            let (warp_se_113) = warp_add256(warp_se_111, warp_se_112);

            wm_write_256(warp_se_107, warp_se_113);

            let warp_cs_11 = warp_usrid_17_i;

            let (warp_se_114) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_11, Uint256(low=1, high=0)
            );

            let (warp_se_115) = wm_read_id(warp_se_114, Uint256(low=6, high=0));

            let (warp_se_116) = WM2_S_a9463b19_warp_usrid_04_z(warp_se_115);

            let (warp_se_117) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_11, Uint256(low=1, high=0)
            );

            let (warp_se_118) = wm_read_id(warp_se_117, Uint256(low=6, high=0));

            let (warp_se_119) = WM2_S_a9463b19_warp_usrid_04_z(warp_se_118);

            let (warp_se_120) = wm_read_felt(warp_se_119);

            let (warp_se_121) = warp_add8(warp_se_120, warp_usrid_15_b);

            wm_write_felt(warp_se_116, warp_se_121);

            let warp_cs_12 = warp_usrid_17_i;

            let (warp_se_122) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_12, Uint256(low=1, high=0)
            );

            let (warp_se_123) = wm_read_id(warp_se_122, Uint256(low=6, high=0));

            let (warp_se_124) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_123);

            let (warp_se_125) = wm_read_id(warp_se_124, Uint256(low=4, high=0));

            let (warp_se_126) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_125);

            let (warp_se_127) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_12, Uint256(low=1, high=0)
            );

            let (warp_se_128) = wm_read_id(warp_se_127, Uint256(low=6, high=0));

            let (warp_se_129) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_128);

            let (warp_se_130) = wm_read_id(warp_se_129, Uint256(low=4, high=0));

            let (warp_se_131) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_130);

            let (warp_se_132) = wm_read_256(warp_se_131);

            let (warp_se_133) = warp_uint256(warp_usrid_15_b);

            let (warp_se_134) = warp_add256(warp_se_132, warp_se_133);

            wm_write_256(warp_se_126, warp_se_134);

            let warp_cs_13 = warp_usrid_17_i;

            let (warp_se_135) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_13, Uint256(low=1, high=0)
            );

            let (warp_se_136) = wm_read_id(warp_se_135, Uint256(low=6, high=0));

            let (warp_se_137) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_136);

            let (warp_se_138) = wm_read_id(warp_se_137, Uint256(low=4, high=0));

            let (warp_se_139) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_138);

            let (warp_se_140) = wm_index_dyn(
                warp_usrid_14_s_mem, warp_cs_13, Uint256(low=1, high=0)
            );

            let (warp_se_141) = wm_read_id(warp_se_140, Uint256(low=6, high=0));

            let (warp_se_142) = WM4_S_a9463b19_warp_usrid_05_t(warp_se_141);

            let (warp_se_143) = wm_read_id(warp_se_142, Uint256(low=4, high=0));

            let (warp_se_144) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_143);

            let (warp_se_145) = wm_read_256(warp_se_144);

            let (warp_se_146) = warp_uint256(warp_usrid_15_b);

            let (warp_se_147) = warp_add256(warp_se_145, warp_se_146);

            wm_write_256(warp_se_139, warp_se_147);

            let (warp_pse_5) = warp_add256(warp_usrid_17_i, Uint256(low=1, high=0));

            let warp_usrid_17_i = warp_pse_5;

            warp_sub256(warp_pse_5, Uint256(low=1, high=0));

            let (warp_usrid_17_i, warp_td_34, warp_usrid_15_b) = warp_while2_if_part1(
                warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b
            );

            let warp_usrid_14_s_mem = warp_td_34;

            return (warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b);
        } else {
            let warp_usrid_17_i = warp_usrid_17_i;

            let warp_usrid_14_s_mem = warp_usrid_14_s_mem;

            let warp_usrid_15_b = warp_usrid_15_b;

            return (warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b);
        }
    }

    func warp_while2_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(warp_usrid_17_i: Uint256, warp_usrid_14_s_mem: felt, warp_usrid_15_b: felt) -> (
        warp_usrid_17_i: Uint256, warp_usrid_14_s_mem: felt, warp_usrid_15_b: felt
    ) {
        alloc_locals;

        let (warp_usrid_17_i, warp_td_36, warp_usrid_15_b) = warp_while2(
            warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b
        );

        let warp_usrid_14_s_mem = warp_td_36;

        return (warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b);
    }

    func warp_while1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_10_i: Uint256,
        warp_usrid_07_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_08_b: felt,
    ) -> (
        warp_usrid_10_i: Uint256,
        warp_usrid_07_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_08_b: felt,
    ) {
        alloc_locals;

        let (warp_se_148) = warp_lt256(warp_usrid_10_i, Uint256(low=3, high=0));

        if (warp_se_148 != 0) {
            let warp_cs_14 = warp_usrid_10_i;

            let (warp_se_149) = wm_index_static(
                warp_usrid_07_acd_to_wm_param_,
                warp_cs_14,
                Uint256(low=2, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_150) = wm_index_static(
                warp_usrid_07_acd_to_wm_param_,
                warp_cs_14,
                Uint256(low=2, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_151) = wm_read_256(warp_se_150);

            let (warp_se_152) = wm_index_static(
                cd_to_wm_warp_usrid_08_b,
                warp_usrid_10_i,
                Uint256(low=1, high=0),
                Uint256(low=3, high=0),
            );

            let (warp_se_153) = wm_read_felt(warp_se_152);

            let (warp_se_154) = warp_uint256(warp_se_153);

            let (warp_se_155) = warp_add256(warp_se_151, warp_se_154);

            wm_write_256(warp_se_149, warp_se_155);

            let (warp_pse_6) = warp_add256(warp_usrid_10_i, Uint256(low=1, high=0));

            let warp_usrid_10_i = warp_pse_6;

            warp_sub256(warp_pse_6, Uint256(low=1, high=0));

            let (warp_usrid_10_i, warp_td_37, warp_td_38) = warp_while1_if_part1(
                warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b
            );

            let warp_usrid_07_acd_to_wm_param_ = warp_td_37;

            let cd_to_wm_warp_usrid_08_b = warp_td_38;

            return (
                warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b
            );
        } else {
            let warp_usrid_10_i = warp_usrid_10_i;

            let warp_usrid_07_acd_to_wm_param_ = warp_usrid_07_acd_to_wm_param_;

            let cd_to_wm_warp_usrid_08_b = cd_to_wm_warp_usrid_08_b;

            return (
                warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b
            );
        }
    }

    func warp_while1_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(
        warp_usrid_10_i: Uint256,
        warp_usrid_07_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_08_b: felt,
    ) -> (
        warp_usrid_10_i: Uint256,
        warp_usrid_07_acd_to_wm_param_: felt,
        cd_to_wm_warp_usrid_08_b: felt,
    ) {
        alloc_locals;

        let (warp_usrid_10_i, warp_td_41, warp_td_42) = warp_while1(
            warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b
        );

        let warp_usrid_07_acd_to_wm_param_ = warp_td_41;

        let cd_to_wm_warp_usrid_08_b = warp_td_42;

        return (warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b);
    }

    func warp_while0{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(warp_usrid_06_i: Uint256, warp_usrid_03_a_mem: felt, warp_usrid_04_b: felt) -> (
        warp_usrid_06_i: Uint256, warp_usrid_03_a_mem: felt, warp_usrid_04_b: felt
    ) {
        alloc_locals;

        let (warp_se_156) = wm_dyn_array_length(warp_usrid_03_a_mem);

        let (warp_se_157) = warp_lt256(warp_usrid_06_i, warp_se_156);

        if (warp_se_157 != 0) {
            let warp_cs_15 = warp_usrid_06_i;

            let (warp_se_158) = wm_index_dyn(
                warp_usrid_03_a_mem, warp_cs_15, Uint256(low=2, high=0)
            );

            let (warp_se_159) = wm_index_dyn(
                warp_usrid_03_a_mem, warp_cs_15, Uint256(low=2, high=0)
            );

            let (warp_se_160) = wm_read_256(warp_se_159);

            let (warp_se_161) = warp_uint256(warp_usrid_04_b);

            let (warp_se_162) = warp_add256(warp_se_160, warp_se_161);

            wm_write_256(warp_se_158, warp_se_162);

            let (warp_pse_7) = warp_add256(warp_usrid_06_i, Uint256(low=1, high=0));

            let warp_usrid_06_i = warp_pse_7;

            warp_sub256(warp_pse_7, Uint256(low=1, high=0));

            let (warp_usrid_06_i, warp_td_43, warp_usrid_04_b) = warp_while0_if_part1(
                warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b
            );

            let warp_usrid_03_a_mem = warp_td_43;

            return (warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b);
        } else {
            let warp_usrid_06_i = warp_usrid_06_i;

            let warp_usrid_03_a_mem = warp_usrid_03_a_mem;

            let warp_usrid_04_b = warp_usrid_04_b;

            return (warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b);
        }
    }

    func warp_while0_if_part1{
        range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*
    }(warp_usrid_06_i: Uint256, warp_usrid_03_a_mem: felt, warp_usrid_04_b: felt) -> (
        warp_usrid_06_i: Uint256, warp_usrid_03_a_mem: felt, warp_usrid_04_b: felt
    ) {
        alloc_locals;

        let (warp_usrid_06_i, warp_td_45, warp_usrid_04_b) = warp_while0(
            warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b
        );

        let warp_usrid_03_a_mem = warp_td_45;

        return (warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b);
    }
}

@view
func add_5f39068a{syscall_ptr: felt*, range_check_ptr: felt}(
    warp_usrid_00_a: Uint256, warp_usrid_01_b: felt
) -> (warp_usrid_02_: Uint256) {
    alloc_locals;

    warp_external_input_check_int8(warp_usrid_01_b);

    warp_external_input_check_int256(warp_usrid_00_a);

    let (warp_se_163) = warp_uint256(warp_usrid_01_b);

    let (warp_se_164) = warp_add256(warp_usrid_00_a, warp_se_163);

    return (warp_se_164,);
}

@view
func arrayAdd_21a2debb{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(warp_usrid_03_a_len: felt, warp_usrid_03_a: Uint256*, warp_usrid_04_b: felt) -> (
    warp_usrid_05__len: felt, warp_usrid_05_: Uint256*
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int8(warp_usrid_04_b);

        extern_input_check0(warp_usrid_03_a_len, warp_usrid_03_a);

        local warp_usrid_03_a_dstruct: cd_dynarray_Uint256 = cd_dynarray_Uint256(warp_usrid_03_a_len, warp_usrid_03_a);

        let (warp_usrid_03_a_mem) = cd_to_memory0(warp_usrid_03_a_dstruct);

        let warp_usrid_06_i = Uint256(low=0, high=0);

        let (warp_tv_8, warp_td_46, warp_tv_10) = A.warp_while0(
            warp_usrid_06_i, warp_usrid_03_a_mem, warp_usrid_04_b
        );

        let warp_tv_9 = warp_td_46;

        let warp_usrid_04_b = warp_tv_10;

        let warp_usrid_03_a_mem = warp_tv_9;

        let warp_usrid_06_i = warp_tv_8;

        let (warp_se_165) = wm_to_calldata0(warp_usrid_03_a_mem);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_165.len, warp_se_165.ptr,);
    }
}

@view
func staticArrayAdd_6fd891c7{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(warp_usrid_07_a: (Uint256, Uint256, Uint256), warp_usrid_08_b: (felt, felt, felt)) -> (
    warp_usrid_09_: (Uint256, Uint256, Uint256)
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check2(warp_usrid_08_b);

        extern_input_check1(warp_usrid_07_a);

        let (warp_usrid_07_acd_to_wm_param_) = cd_to_memory1(warp_usrid_07_a);

        let (cd_to_wm_warp_usrid_08_b) = cd_to_memory2(warp_usrid_08_b);

        let warp_usrid_10_i = Uint256(low=0, high=0);

        let (warp_tv_11, warp_td_47, warp_td_48) = A.warp_while1(
            warp_usrid_10_i, warp_usrid_07_acd_to_wm_param_, cd_to_wm_warp_usrid_08_b
        );

        let warp_tv_12 = warp_td_47;

        let warp_tv_13 = warp_td_48;

        let cd_to_wm_warp_usrid_08_b = warp_tv_13;

        let warp_usrid_07_acd_to_wm_param_ = warp_tv_12;

        let warp_usrid_10_i = warp_tv_11;

        let (warp_se_166) = wm_to_calldata3(warp_usrid_07_acd_to_wm_param_);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_166,);
    }
}

@view
func structAdd_f626e22b{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    warp_usrid_11_s: S_a9463b19, warp_usrid_12_b: felt
) -> (warp_usrid_13_: S_a9463b19) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int8(warp_usrid_12_b);

        extern_input_check3(warp_usrid_11_s);

        let (warp_usrid_11_scd_to_wm_param_) = cd_to_memory3(warp_usrid_11_s);

        let (warp_se_167) = WM0_S_a9463b19_warp_usrid_02_x(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_168) = WM0_S_a9463b19_warp_usrid_02_x(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_169) = wm_read_256(warp_se_168);

        let (warp_se_170) = warp_uint256(warp_usrid_12_b);

        let (warp_se_171) = warp_add256(warp_se_169, warp_se_170);

        wm_write_256(warp_se_167, warp_se_171);

        let (warp_se_172) = WM1_S_a9463b19_warp_usrid_03_y(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_173) = WM1_S_a9463b19_warp_usrid_03_y(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_174) = wm_read_256(warp_se_173);

        let (warp_se_175) = warp_uint256(warp_usrid_12_b);

        let (warp_se_176) = warp_add256(warp_se_174, warp_se_175);

        wm_write_256(warp_se_172, warp_se_176);

        let (warp_se_177) = WM2_S_a9463b19_warp_usrid_04_z(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_178) = WM2_S_a9463b19_warp_usrid_04_z(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_179) = wm_read_felt(warp_se_178);

        let (warp_se_180) = warp_add8(warp_se_179, warp_usrid_12_b);

        wm_write_felt(warp_se_177, warp_se_180);

        let (warp_se_181) = WM4_S_a9463b19_warp_usrid_05_t(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_182) = wm_read_id(warp_se_181, Uint256(low=4, high=0));

        let (warp_se_183) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_182);

        let (warp_se_184) = WM4_S_a9463b19_warp_usrid_05_t(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_185) = wm_read_id(warp_se_184, Uint256(low=4, high=0));

        let (warp_se_186) = WM3_T_846b7b6d_warp_usrid_00_a(warp_se_185);

        let (warp_se_187) = wm_read_256(warp_se_186);

        let (warp_se_188) = warp_uint256(warp_usrid_12_b);

        let (warp_se_189) = warp_add256(warp_se_187, warp_se_188);

        wm_write_256(warp_se_183, warp_se_189);

        let (warp_se_190) = WM4_S_a9463b19_warp_usrid_05_t(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_191) = wm_read_id(warp_se_190, Uint256(low=4, high=0));

        let (warp_se_192) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_191);

        let (warp_se_193) = WM4_S_a9463b19_warp_usrid_05_t(warp_usrid_11_scd_to_wm_param_);

        let (warp_se_194) = wm_read_id(warp_se_193, Uint256(low=4, high=0));

        let (warp_se_195) = WM5_T_846b7b6d_warp_usrid_01_b(warp_se_194);

        let (warp_se_196) = wm_read_256(warp_se_195);

        let (warp_se_197) = warp_uint256(warp_usrid_12_b);

        let (warp_se_198) = warp_add256(warp_se_196, warp_se_197);

        wm_write_256(warp_se_192, warp_se_198);

        let (warp_se_199) = wm_to_calldata4(warp_usrid_11_scd_to_wm_param_);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_199,);
    }
}

@view
func structArrayAdd_a9fa80fe{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(warp_usrid_14_s_len: felt, warp_usrid_14_s: S_a9463b19*, warp_usrid_15_b: felt) -> (
    warp_usrid_16__len: felt, warp_usrid_16_: S_a9463b19*
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        warp_external_input_check_int8(warp_usrid_15_b);

        extern_input_check5(warp_usrid_14_s_len, warp_usrid_14_s);

        local warp_usrid_14_s_dstruct: cd_dynarray_S_a9463b19 = cd_dynarray_S_a9463b19(warp_usrid_14_s_len, warp_usrid_14_s);

        let (warp_usrid_14_s_mem) = cd_to_memory5(warp_usrid_14_s_dstruct);

        let warp_usrid_17_i = Uint256(low=0, high=0);

        let (warp_tv_14, warp_td_49, warp_tv_16) = A.warp_while2(
            warp_usrid_17_i, warp_usrid_14_s_mem, warp_usrid_15_b
        );

        let warp_tv_15 = warp_td_49;

        let warp_usrid_15_b = warp_tv_16;

        let warp_usrid_14_s_mem = warp_tv_15;

        let warp_usrid_17_i = warp_tv_14;

        let (warp_se_200) = wm_to_calldata6(warp_usrid_14_s_mem);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_200.len, warp_se_200.ptr,);
    }
}

@view
func staticStructArrayAdd_a7c87eb1{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    warp_usrid_18_s: (S_a9463b19, S_a9463b19, S_a9463b19), warp_usrid_19_b: (felt, felt, felt)
) -> (warp_usrid_20_: (S_a9463b19, S_a9463b19, S_a9463b19)) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check2(warp_usrid_19_b);

        extern_input_check6(warp_usrid_18_s);

        let (warp_usrid_18_scd_to_wm_param_) = cd_to_memory6(warp_usrid_18_s);

        let (cd_to_wm_warp_usrid_19_b) = cd_to_memory2(warp_usrid_19_b);

        let warp_usrid_21_i = Uint256(low=0, high=0);

        let (warp_tv_17, warp_td_50, warp_td_51) = A.warp_while3(
            warp_usrid_21_i, warp_usrid_18_scd_to_wm_param_, cd_to_wm_warp_usrid_19_b
        );

        let warp_tv_18 = warp_td_50;

        let warp_tv_19 = warp_td_51;

        let cd_to_wm_warp_usrid_19_b = warp_tv_19;

        let warp_usrid_18_scd_to_wm_param_ = warp_tv_18;

        let warp_usrid_21_i = warp_tv_17;

        let (warp_se_201) = wm_to_calldata9(warp_usrid_18_scd_to_wm_param_);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_201,);
    }
}

@view
func array2Dadd_14dd5669{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    warp_usrid_22_a_len: felt,
    warp_usrid_22_a: (Uint256, Uint256, Uint256)*,
    warp_usrid_23_b_len: felt,
    warp_usrid_23_b: (felt, felt, felt)*,
) -> (warp_usrid_24__len: felt, warp_usrid_24_: (Uint256, Uint256, Uint256)*) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check8(warp_usrid_23_b_len, warp_usrid_23_b);

        extern_input_check7(warp_usrid_22_a_len, warp_usrid_22_a);

        local warp_usrid_22_a_dstruct: cd_dynarray_arr_3_Uint256 = cd_dynarray_arr_3_Uint256(warp_usrid_22_a_len, warp_usrid_22_a);

        let (warp_usrid_22_a_mem) = cd_to_memory7(warp_usrid_22_a_dstruct);

        local warp_usrid_23_b_dstruct: cd_dynarray_arr_3_felt = cd_dynarray_arr_3_felt(warp_usrid_23_b_len, warp_usrid_23_b);

        let (cd_to_wm_warp_usrid_23_b) = cd_to_memory8(warp_usrid_23_b_dstruct);

        let warp_usrid_25_i = Uint256(low=0, high=0);

        let (warp_tv_20, warp_td_52, warp_td_53) = A.warp_while5(
            warp_usrid_25_i, warp_usrid_22_a_mem, cd_to_wm_warp_usrid_23_b
        );

        let warp_tv_21 = warp_td_52;

        let warp_tv_22 = warp_td_53;

        let cd_to_wm_warp_usrid_23_b = warp_tv_22;

        let warp_usrid_22_a_mem = warp_tv_21;

        let warp_usrid_25_i = warp_tv_20;

        let (warp_se_202) = wm_to_calldata10(warp_usrid_22_a_mem);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_202.len, warp_se_202.ptr,);
    }
}

@view
func array2DaddStatic_9fb362da{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt,
    bitwise_ptr: BitwiseBuiltin*,
}(
    warp_usrid_27_a: (
        (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256)
    ),
    warp_usrid_28_b: ((felt, felt, felt), (felt, felt, felt), (felt, felt, felt)),
) -> (
    warp_usrid_29_: (
        (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256), (Uint256, Uint256, Uint256)
    ),
) {
    alloc_locals;
    let (local warp_memory: DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0, 1);
    with warp_memory {
        extern_input_check10(warp_usrid_28_b);

        extern_input_check9(warp_usrid_27_a);

        let (warp_usrid_27_acd_to_wm_param_) = cd_to_memory9(warp_usrid_27_a);

        let (cd_to_wm_warp_usrid_28_b) = cd_to_memory10(warp_usrid_28_b);

        let warp_usrid_30_i = Uint256(low=0, high=0);

        let (warp_tv_23, warp_td_54, warp_td_55) = A.warp_while7(
            warp_usrid_30_i, warp_usrid_27_acd_to_wm_param_, cd_to_wm_warp_usrid_28_b
        );

        let warp_tv_24 = warp_td_54;

        let warp_tv_25 = warp_td_55;

        let cd_to_wm_warp_usrid_28_b = warp_tv_25;

        let warp_usrid_27_acd_to_wm_param_ = warp_tv_24;

        let warp_usrid_30_i = warp_tv_23;

        let (warp_se_203) = wm_to_calldata13(warp_usrid_27_acd_to_wm_param_);

        default_dict_finalize(warp_memory_start, warp_memory, 0);

        return (warp_se_203,);
    }
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt) {
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt) {
}
@storage_var
func WARP_NAMEGEN() -> (name: felt) {
}
func readId{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(loc: felt) -> (
    val: felt
) {
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0) {
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    } else {
        return (id,);
    }
}

// Original soldity abi: ["constructor()","add(uint256,uint8)","arrayAdd(uint256[],uint8)","staticArrayAdd(uint256[3],uint8[3])","structAdd((uint256,uint256,uint8,(uint256,uint256)),uint8)","structArrayAdd((uint256,uint256,uint8,(uint256,uint256))[],uint8)","staticStructArrayAdd((uint256,uint256,uint8,(uint256,uint256))[3],uint8[3])","array2Dadd(uint256[3][],uint8[3][])","array2DaddStatic(uint256[3][3],uint8[3][3])"]

%lang starknet

from warplib.memory import (
    wm_read_felt, wm_read_256, wm_new, wm_write_felt, wm_write_256, wm_index_dyn)
from warplib.maths.int_conversions import warp_uint256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write
from warplib.maths.add import warp_add8, warp_add256
from warplib.maths.external_input_check_ints import warp_external_input_check_int8
from starkware.cairo.common.cairo_builtins import HashBuiltin

struct dynarray_struct_felt:
    member len : felt
    member ptr : felt*
end

struct dynarray_struct_Uint256:
    member len : felt
    member ptr : Uint256*
end

func wm_dynarry_alloc_felt{syscall_ptr : felt*, range_check_ptr : felt, warp_memory : DictAccess*}(
        dyn_array_struct : dynarray_struct_felt) -> (dynarry_loc : felt):
    alloc_locals
    let (array_len_uint256) = warp_uint256(dyn_array_struct.len)
    let (dynarray_loc) = wm_new(array_len_uint256, Uint256(0x1, 0x0))
    wm_dynarray_write_felt(dynarray_loc + 2, dyn_array_struct.len, dyn_array_struct.ptr, 1)
    return (dynarray_loc)
end

func wm_dynarry_alloc_Uint256{
        syscall_ptr : felt*, range_check_ptr : felt, warp_memory : DictAccess*}(
        dyn_array_struct : dynarray_struct_Uint256) -> (dynarry_loc : felt):
    alloc_locals
    let (array_len_uint256) = warp_uint256(dyn_array_struct.len)
    let (dynarray_loc) = wm_new(array_len_uint256, Uint256(0x2, 0x0))
    wm_dynarray_write_Uint256(dynarray_loc + 2, dyn_array_struct.len, dyn_array_struct.ptr, 2)
    return (dynarray_loc)
end

func wm_dynarray_write_felt{warp_memory : DictAccess*}(
        dynarray_loc : felt, array_len : felt, pointer : felt*, width : felt):
    if array_len == 0:
        return ()
    end
    wm_write_felt(dynarray_loc, pointer[0])
    return wm_dynarray_write_felt(
        dynarray_loc=dynarray_loc + width,
        array_len=array_len - 1,
        pointer=&pointer[1],
        width=width)
end

func wm_dynarray_write_Uint256{warp_memory : DictAccess*}(
        dynarray_loc : felt, array_len : felt, pointer : Uint256*, width : felt):
    if array_len == 0:
        return ()
    end
    wm_write_256(dynarray_loc, pointer[0])
    return wm_dynarray_write_Uint256(
        dynarray_loc=dynarray_loc + width,
        array_len=array_len - 1,
        pointer=&pointer[1],
        width=width)
end

# Contract Def WARP

namespace WARP:
    @view
    func dArrayExternal_0df5243c{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid0_x_len : felt, __warp_usrid0_x : felt*, __warp_usrid1_y_len : felt,
            __warp_usrid1_y : felt*) -> (__warp_usrid2_ : felt):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            tempvar __warp_usrid1_y_dstruct = dynarray_struct_felt(__warp_usrid1_y_len, __warp_usrid1_y)
            tempvar __warp_usrid0_x_dstruct = dynarray_struct_felt(__warp_usrid0_x_len, __warp_usrid0_x)
            let (__warp_usrid0_x_mem) = wm_dynarry_alloc_felt(__warp_usrid0_x_dstruct)
            let (__warp_se_0) = wm_index_dyn(
                __warp_usrid0_x_mem, Uint256(low=3, high=0), Uint256(low=1, high=0))
            let (__warp_se_1) = wm_read_felt(__warp_se_0)
            let (__warp_se_2) = warp_add8(__warp_se_1, __warp_usrid1_y_dstruct.ptr[1])
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_2)
        end
    end

    @view
    func dArrayPublic_f5f3e207{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid3_x_len : felt, __warp_usrid3_x : felt*) -> (__warp_usrid4_ : felt):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            tempvar __warp_usrid3_x_dstruct = dynarray_struct_felt(__warp_usrid3_x_len, __warp_usrid3_x)
            let (__warp_usrid3_x_mem) = wm_dynarry_alloc_felt(__warp_usrid3_x_dstruct)
            let (__warp_se_3) = wm_index_dyn(
                __warp_usrid3_x_mem, Uint256(low=0, high=0), Uint256(low=1, high=0))
            let (__warp_se_4) = wm_read_felt(__warp_se_3)
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_4)
        end
    end

    @view
    func dArrayMultipleInputsExternal_aae070a5{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid5_x_len : felt, __warp_usrid5_x : felt*, __warp_usrid6_y : felt,
            __warp_usrid7_z_len : felt, __warp_usrid7_z : felt*) -> (__warp_usrid8_ : felt):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            warp_external_input_check_int8(__warp_usrid6_y)
            tempvar __warp_usrid7_z_dstruct = dynarray_struct_felt(__warp_usrid7_z_len, __warp_usrid7_z)
            let (__warp_usrid7_z_mem) = wm_dynarry_alloc_felt(__warp_usrid7_z_dstruct)
            tempvar __warp_usrid5_x_dstruct = dynarray_struct_felt(__warp_usrid5_x_len, __warp_usrid5_x)
            let (__warp_usrid5_x_mem) = wm_dynarry_alloc_felt(__warp_usrid5_x_dstruct)
            let (__warp_se_5) = wm_index_dyn(
                __warp_usrid5_x_mem, Uint256(low=0, high=0), Uint256(low=1, high=0))
            let (__warp_se_6) = wm_read_felt(__warp_se_5)
            let (__warp_se_7) = wm_index_dyn(
                __warp_usrid7_z_mem, Uint256(low=1, high=0), Uint256(low=1, high=0))
            let (__warp_se_8) = wm_read_felt(__warp_se_7)
            let (__warp_se_9) = warp_add8(__warp_se_6, __warp_se_8)
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_9)
        end
    end

    @view
    func dArrayMultipleInputsPublic_b04f103e{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid9_x_len : felt, __warp_usrid9_x : felt*, __warp_usrid10_y : felt,
            __warp_usrid11_z_len : felt, __warp_usrid11_z : felt*) -> (__warp_usrid12_ : felt):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            warp_external_input_check_int8(__warp_usrid10_y)
            tempvar __warp_usrid11_z_dstruct = dynarray_struct_felt(__warp_usrid11_z_len, __warp_usrid11_z)
            let (__warp_usrid11_z_mem) = wm_dynarry_alloc_felt(__warp_usrid11_z_dstruct)
            tempvar __warp_usrid9_x_dstruct = dynarray_struct_felt(__warp_usrid9_x_len, __warp_usrid9_x)
            let (__warp_usrid9_x_mem) = wm_dynarry_alloc_felt(__warp_usrid9_x_dstruct)
            let (__warp_se_10) = wm_index_dyn(
                __warp_usrid9_x_mem, Uint256(low=0, high=0), Uint256(low=1, high=0))
            let (__warp_se_11) = wm_read_felt(__warp_se_10)
            let (__warp_se_12) = wm_index_dyn(
                __warp_usrid11_z_mem, Uint256(low=1, high=0), Uint256(low=1, high=0))
            let (__warp_se_13) = wm_read_felt(__warp_se_12)
            let (__warp_se_14) = warp_add8(__warp_se_11, __warp_se_13)
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_14)
        end
    end

    @view
    func dArray256External_3df0572f{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid13_y_len : felt, __warp_usrid13_y : Uint256*) -> (
            __warp_usrid14_ : Uint256):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            tempvar __warp_usrid13_y_dstruct = dynarray_struct_Uint256(__warp_usrid13_y_len, __warp_usrid13_y)
            let (__warp_usrid13_y_mem) = wm_dynarry_alloc_Uint256(__warp_usrid13_y_dstruct)
            let (__warp_se_15) = wm_index_dyn(
                __warp_usrid13_y_mem, Uint256(low=1, high=0), Uint256(low=2, high=0))
            let (__warp_se_16) = wm_read_256(__warp_se_15)
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_16)
        end
    end

    @view
    func dArray256MultipleInputs_5cde4342{syscall_ptr : felt*, range_check_ptr : felt}(
            __warp_usrid15_x_len : felt, __warp_usrid15_x : Uint256*, __warp_usrid16_y_len : felt,
            __warp_usrid16_y : felt*, __warp_usrid17_z_len : felt, __warp_usrid17_z : Uint256*) -> (
            __warp_usrid18_ : Uint256):
        alloc_locals
        let (local warp_memory : DictAccess*) = default_dict_new(0)
        local warp_memory_start : DictAccess* = warp_memory
        dict_write{dict_ptr=warp_memory}(0, 1)
        with warp_memory:
            tempvar __warp_usrid17_z_dstruct = dynarray_struct_Uint256(__warp_usrid17_z_len, __warp_usrid17_z)
            let (__warp_usrid17_z_mem) = wm_dynarry_alloc_Uint256(__warp_usrid17_z_dstruct)
            tempvar __warp_usrid16_y_dstruct = dynarray_struct_felt(__warp_usrid16_y_len, __warp_usrid16_y)
            let (__warp_usrid16_y_mem) = wm_dynarry_alloc_felt(__warp_usrid16_y_dstruct)
            tempvar __warp_usrid15_x_dstruct = dynarray_struct_Uint256(__warp_usrid15_x_len, __warp_usrid15_x)
            let (__warp_usrid15_x_mem) = wm_dynarry_alloc_Uint256(__warp_usrid15_x_dstruct)
            let (__warp_se_17) = wm_index_dyn(
                __warp_usrid15_x_mem, Uint256(low=2, high=0), Uint256(low=2, high=0))
            let (__warp_se_18) = wm_read_256(__warp_se_17)
            let (__warp_se_19) = wm_index_dyn(
                __warp_usrid16_y_mem, Uint256(low=1, high=0), Uint256(low=1, high=0))
            let (__warp_se_20) = wm_read_felt(__warp_se_19)
            let (__warp_se_21) = warp_uint256(__warp_se_20)
            let (__warp_se_22) = warp_add256(__warp_se_18, __warp_se_21)
            let (__warp_se_23) = wm_index_dyn(
                __warp_usrid17_z_mem, Uint256(low=2, high=0), Uint256(low=2, high=0))
            let (__warp_se_24) = wm_read_256(__warp_se_23)
            let (__warp_se_25) = warp_add256(__warp_se_22, __warp_se_24)
            default_dict_finalize(warp_memory_start, warp_memory, 0)
            return (__warp_se_25)
        end
    end

    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}():
        alloc_locals
        return ()
    end
end

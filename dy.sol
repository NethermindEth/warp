// So the below can only be from dynArray to dynArray
func CD_DY_TO_WS_DY0{
    syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*
}(ref : felt, len_source_elem, source_elem : (felt, felt, felt, felt)*) -> ():
    alloc_locals
    WARP_DARRAY0_warp_id_LENGTH.write(ref, splitFelt(len_source_elem))
    funcloader(ref, len, ptr, target_index)
    return ()
end

// Take the argument in
// Then load the storage_member each loop until complete
funcLoader (ref, len, ptr, target_index)
if length == 0:
    end
return();

    target_index ++ 
else CD_ST_TO_WM_DYN(ref, ptr[0], target_index)
return funcLoader(ref, ptr + width, target_index )

funcLoader (loc, len, ptr)
if length == 0:
    end
return();
else WS.WRITE(loc, ptr[0])
return funcLoader(loc + storageOffset, len-1, ptr + width)



// func CD_DY_TO_WS_DY0{
//     syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*
// }(ref : felt, source_elem : (felt, felt, felt, felt)*) -> ():
//     alloc_locals
//     WARP_DARRAY0_warp_id_LENGTH.write(ref, splitFelt(len_source_elem))
//     let (loc0) = WARP_DARRAY0_warp_id_IDX(ref, Uint256(0, 0))
//     let (ref_0) = readId(loc0)
//     CD_ST_TO_WS_DY1(ref_0, source_elem[0])
//     let (loc1) = WARP_DARRAY0_warp_id_IDX(ref, Uint256(1, 0))
//     let (ref_1) = readId(loc1)
//     CD_ST_TO_WS_DY1(ref_1, source_elem[1])
//     return ()
// end

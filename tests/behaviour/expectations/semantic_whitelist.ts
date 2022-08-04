// These tests are commented out because of the extreme volume of them,
// however they are grouped by what they test so relevant ones can be easily uncommented for testing

// Current test suite deficiencies:
//  multisource tests

const tests: string[] = [
  //---------AbiEncodeDecode tests - WillNotSupport
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_decode_simple.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/offset_overflow_in_array_decoding_3.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/contract_array.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_decode_simple_storage.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_call_declaration.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/offset_overflow_in_array_decoding.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_call.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_empty_string_v1.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_call_is_consistent.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_with_selector.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/offset_overflow_in_array_decoding_2.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_decode_calldata.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_with_signaturev2.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_with_signature.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_call_special_args.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/contract_array_v2.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_with_selectorv2.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode/abi_encode_call_memory.sol', // WILL NOT SUPPORT
  ],
  //---------AbiEncoderV1 tests - WillNotSupport
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_static_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/return_dynamic_types_cross_call_out_of_range_2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/cleanup/cleanup.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/return_dynamic_types_cross_call_out_of_range_1.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/struct/struct_storage_ptr.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_static_array_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode_empty_string.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode_call.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/dynamic_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/decode_slice.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_trivial.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/bool_out_of_bounds.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/calldata_arrays_too_large.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode_rational.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/return_dynamic_types_cross_call_simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/dynamic_memory_copy.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/return_dynamic_types_cross_call_advanced.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_fixed_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode_decode_simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_encode_calldata_slice.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_v2_calldata.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/enums.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_v2_storage.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/abi_decode_dynamic_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/byte_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/memory_params_in_external_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------AbiEncoderV2 tests - WillNotSupport
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/address.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/bytesx.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/dynamic_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/bool.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/intx.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/uintx.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/static_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/simple_struct.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup/cleanup.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/mediocre_struct.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/mediocre2_struct.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/validation_function_type_inside_struct.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/struct_validation.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/struct_short.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/struct_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct/struct_simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_rational_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_struct_simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_static.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_static_index_access.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_two_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_dynamic_static_short_decode.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_struct_member_offset.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/dynamic_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_v2_in_function_inherited_in_v1_contract.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_v2_in_modifier_used_in_v1_contract.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_empty_string_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_static_dynamic_static.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_multi_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/bool_out_of_bounds.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_struct_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_struct_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/dynamic_nested_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/storage_array_encoding.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_dynamic_static_short_reencode.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_dynamic_index_access.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/abi_encode_calldata_slice.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_dynamic_static_dynamic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_two_static.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/calldata_array_function_types.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/enums.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/byte_arrays.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/memory_params_in_external_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Accessor tests - 8 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/accessor/accessor_for_const_state_variable.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/accessor/accessor_for_state_variable.sol',
  ],
  //---------Arithmetics - 49 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/block_inside_unchecked.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/checked_add_v1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/checked_add_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/checked_called_by_unchecked.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/checked_modifier_called_by_unchecked.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/exp_associativity.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/unchecked_called_by_checked.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/divisiod_by_zero.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/signed_mod.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/unchecked_div_by_zero.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/addmod_mulmod.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/addmod_mulmod_zero.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics/check_var_init.sol', // WILL NOT SUPPORT due to the use of `value` function option
  ],
  //---------Array tests - 374 passing, 103 pending, 52 failing
  ...[
    //---------Array concat tests: 24 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_2_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_3_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_as_argument.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_empty_argument_list.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_empty_strings.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat/bytes_concat_different_types.sol', // STRETCH slices
    ],
    //---------Array copying tests 114 passing, 62 pending, 29 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_different_packing.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_including_array.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_memory_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_abi_signed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_different_base.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_different_base_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_dyn_dyn.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_dynamic_dynamic.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_static_dynamic.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_static_simple.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_static_static.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_storage_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_target_leftover.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_target_leftover2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_target_simple.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_target_simple_2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_nested_calldata_to_storage.sol', // solc --standard-json error
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_nested_memory_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_struct_calldata_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_struct_calldata_to_storage.sol', // solc --standard-json error
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_struct_memory_to_storage.sol', // solc --standard-json error
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_structs_containing_arrays_calldata_to_storage.sol', // solc --standard-json error
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_structs_containing_arrays_memory_to_storage.sol', // solc --standard-json error
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_storage_multi_items_per_slot.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/arrays_from_and_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/bytes_calldata_to_string_calldata.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/bytes_memory_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/bytes_storage_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/bytes_storage_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_array_dynamic_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_array_of_struct_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_array_static_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_bytes_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_to_storage_different_base.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copy_byte_array_in_struct_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/memory_dyn_2d_bytes_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/memory_to_storage_different_base.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_nested_from_pointer.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_nested_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_packed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_packed_dyn.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/string_calldata_to_bytes_calldata.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_dyn_2d_bytes_to_memory.sol', // nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_2d_bytes_to_memory.sol', // nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_2d_bytes_to_memory_2.sol', // nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_bytes_array_to_memory.sol', // nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copy_removes_bytes_data.sol', //WILL NOT SUPPORT msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/storage_memory_nested_bytes.sol', // nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/bytes_inside_mappings.sol', // WILL NOT SUPPORT msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copying_bytes_multiassign.sol', // WILL NOT SUPPORT msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_calldata_storage.sol', // dynarray of static arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_structs_containing_arrays_calldata_to_memory.sol',// nested dynarray arg
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_function_external_storage_to_storage_dynamic_different_mutability.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_nested_calldata_to_memory.sol', // nested dynarray arg
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copy_function_internal_storage_array.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_nested_array_copy_to_memory.sol', // input args with nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/calldata_dynamic_array_to_memory.sol', // input args with nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_nested_array.sol', // dynarray of static array arg
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_storage_to_memory_nested.sol', // WILL NOT SUPPORT returns nested dyn arrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_of_function_external_storage_to_storage_dynamic.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_cleanup_uint128.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copy_internal_function_array_to_storage.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/dirty_memory_bytes_to_storage_copy_ir.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/dirty_memory_bytes_to_storage_copy.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/copy_byte_array_to_storage.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_clear_storage_packed.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_cleanup_uint40.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/array_copy_clear_storage.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying/empty_bytes_copy.sol', // WILL NOT SUPPORT yul
    ],
    //---------Array delete tests: 12 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/bytes_delete_element.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_on_array_of_structs.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/memory_arrays_delete.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_removes_bytes_data.sol', // WILL NOT SUPPORT msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_memory_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_storage_array_packed.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_storage_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete/delete_bytes_array.sol', // WILL NOT SUPPORT yul
    ],
    //---------Array index access tests: 36 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/arrays_complex_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/bytes_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/bytes_index_access_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/bytes_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/fixed_bytes_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/inline_array_index_access_ints.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/inline_array_index_access_strings.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/memory_arrays_index_access_write.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess/memory_arrays_dynamic_index_access_write.sol', // static array of dynarray
    ],
    //---------Array pop tests: 48 passing, 2 pending, 2 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_array_transition.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_empty_exception.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_storage_empty.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_uint16_transition.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_uint24_transition.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_copy_long.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_empty_exception.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_long_storage_empty.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_masking_long.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_storage_empty.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/parenthesized.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/array_pop_isolated.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_isolated.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop/byte_array_pop_long_storage_empty_garbage_ref.sol', // WILL NOT SUPPORT yul
    ],
    //-------Array push tests: 52 passing, 3 pending, 1 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/byte_array_push.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/push_no_args_1d.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_nested_from_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/push_no_args_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/push_no_args_2d.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/nested_bytes_push.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_packed_array.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/push_no_args_bytes.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_nested_from_calldata.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/byte_array_push_transition.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push/array_push_struct_from_calldata.sol', // nested dyn array input
    ],
    //-------Array slice tests - stretch goal: 0 passing, 15 pending, 5 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices/array_slice_calldata_to_storage.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices/array_slice_calldata_to_memory.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices/array_slice_calldata_to_calldata.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices/array_calldata_assignment.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices/array_slice_calldata_as_argument_of_external_calls.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    ],
    //-------Array misc tests: 110 passing, 24 pending, 10 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/arrays_complex_from_and_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/byte_array_transitional_2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_of_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/constant_var_as_array_length.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/create_dynamic_array_with_zero_length.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/create_memory_array.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/create_memory_array_too_large.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/create_memory_byte_array.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/create_multiple_dynamic_arrays.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/dynamic_array_cleanup.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/dynamic_arrays_in_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/dynamic_multi_array_cleanup.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/dynamic_out_of_bounds_array_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/evm_exceptions_out_of_band_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/external_array_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_array_cleanup.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_arrays_in_constructors.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_arrays_in_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_bytes_length_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_out_of_bounds_array_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/inline_array_return.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/inline_array_singleton.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/inline_array_storage_to_memory_conversion_ints.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/inline_array_storage_to_memory_conversion_strings.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/inline_array_strings_from_document.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/memory_arrays_of_various_sizes.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/short_fixed_array_cleanup.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/storage_array_ref.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/string_allocation_bug.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/string_bytes_conversion.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/string_literal_assign_to_storage_bytes.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/strings_in_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/bytes_to_fixed_bytes_simple.sol', // STRETCH bytes to fixed bytes
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/bytes_to_fixed_bytes_too_long.sol', // STRETCH bytes to fixed bytes
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/bytes_length_member.sol', // msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_bytes_array_bounds.sol', // nested dynarray input
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_dynamic_invalid_static_middle.sol', // dynamic array of static array input
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_as_argument_internal_function.sol', // STRETCH array slice
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_dynamic_invalid.sol', // nested dynarray argument
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_slice_access.sol', // STRETCH array slices
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/fixed_arrays_as_return_type.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/reusing_memory.sol', // WILL NOT SUPPORT due to the use abi.encodePacked
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/function_array_cross_calls.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/function_memory_array.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_two_dimensional.sol', // nested dynarray input
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/calldata_array_two_dimensional_1.sol', // nested dynarray input
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/byte_array_storage_layout.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/bytes_to_fixed_bytes_cleanup.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/invalid_encoding_for_storage_byte_array.sol', // WILL NOT SUPPORT yul
    ],
  ],
  //---------Asm for loop - WillNotSupport
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/asmForLoop/for_loop_break.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/asmForLoop/for_loop_nested.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/asmForLoop/for_loop_continue.sol', // WILL NOT SUPPORT yul
  ],
  //---------Built in functions - 16 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/assignment_to_const_var_involving_keccak.sol', // WillNotSupprt keccak
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/blockhash_shadow_resolution.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/keccak256_empty.sol', // WillNotSupport
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/keccak256_with_bytes.sol', // WillNotSupport
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/keccak256_multiple_arguments.sol', // WillNotSupport abi
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/keccak256_multiple_arguments_with_numeric_literals.sol', // WillNotSupport abi
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/keccak256_multiple_arguments_with_string_literals.sol', // WillNotSupport abi
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/blockhash.sol', // WillNotSupport blockhash
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/function_types_sig.sol', // WillNotSupport selector
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/iterated_keccak256_with_bytes.sol', // WillNotSupprt keccak abiencode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/msg_sig.sol', // WillNotSupport
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/msg_sig_after_internal_call_is_same.sol', // WillNotSupport
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/ripemd160_empty.sol', // WillNotSupport
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions/sha256_empty.sol', // WillNotSupport
  ],
  //---------Calldata tests: 44 passing, 0 pending, 0 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bound_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bound_static_array.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bound_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bytes_external.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bytes_internal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bytes_to_memory.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_internal_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_internal_multi_fixed_array.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_memory_mixed.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_string_array.sol', // Dynamic arrays are not allowed as (indirect) children
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_struct_internal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bound_dynamic_array_or_slice.sol', // STRETCH slices
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_array_dynamic_bytes.sol', // nested dynarray arg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_bytes_to_memory_encode.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_internal_function_pointer.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_internal_multi_array.sol', // nested dynarray arg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/calldata_struct_cleaning.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata/copy_from_calldata_removes_bytes_data.sol', // address.call
  ],
  //---------Cleanup tests: 24 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_bytes_types_v1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_in_compound_assign.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/exp_cleanup.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/exp_cleanup_direct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/exp_cleanup_nonzero_base.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/exp_cleanup_smaller_base.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/bool_conversion_v2.sol', // covered in behaviour tests where invalid input can be sent reliably
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_bytes_types_v2.sol', // irrelevant, tests abiencoder behaviour
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_address_types_v1.sol', //160 bit address
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_address_types_v2.sol', //160 bit address
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/bool_conversion_v1.sol', //testing abiencoder behaviour
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_bytes_types_shortening_newCodeGen.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_address_types_shortening.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/indexed_log_topic_during_explicit_downcast_during_emissions.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/cleanup_bytes_types_shortening_OldCodeGen.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup/indexed_log_topic_during_explicit_downcast.sol', // WILL NOT SUPPORT yul
  ],
  //---------Constant Evaluator: 8 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constantEvaluator/rounding.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constantEvaluator/negative_fractional_mod.sol',
  ],
  //---------Constants: 12 passing, 6 pending, 2 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/constant_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/constant_string_at_file_level.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/constant_variables.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/consteval_array_length.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/simple_constant_variables_test.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/constants_at_file_level_referencing.sol', // multisource single file
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/same_constants_different_files.sol', // multisource single file
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/function_unreferenced.sol', // WILL NOT SUPPORT selector
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/asm_address_constant_regression.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constants/asm_constant_file_level.sol', // WILL NOT SUPPORT yul
  ],
  //---------Constructor tests: 36 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/functions_called_by_constructor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/constructor_static_array_argument.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/payable_constructor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/function_usage_in_constructor_arguments.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/inline_member_init_inheritence_without_constructor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/bytes_in_constructors_unpacker.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/order_of_evaluation.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/base_constructor_arguments.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/constructor_arguments_external.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/functions_called_by_constructor_through_dispatch.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/constructor_function_complex.sol', // WILL NOT SUPPORT function objectss
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/no_callvalue_check.sol', // WILL NOT SUPPORT due to the use of `value` function option
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/evm_exceptions_in_constructor_call_fail.sol', // address.call
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/constructor_arguments_internal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/bytes_in_constructors_packer.sol', // Bug here related to constructos and inheritance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/arrays_in_constructors.sol', // Bug related to contract inheritance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/callvalue_check.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/constructor_function_argument.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/store_function_in_constructor_packed.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/store_function_in_constructor.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/store_internal_unused_function_in_constructor.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor/store_internal_unused_library_function_in_constructor.sol', // WILL NOT SUPPORT function objects
  ],
  //---------Conversions: 0 passing, 3 pending, 1 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/conversions/string_to_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/conversions/function_type_array_to_storage.sol', // WILL NOT SUPPORT function objects
  ],
  //---------Ecrecover - no relevant tests due to address/uint160 change
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover/ecrecover.sol', // moved to behaviour tests nethersolc change
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover/failing_ecrecover_invalid_input_asm.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover/failing_ecrecover_invalid_input.sol', // moved to behaviour tests nethersolc change
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover/ecrecover_abiV2.sol', // moved to behaviour tests nethersolc change
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover/failing_ecrecover_invalid_input_proper.sol', // moved to behaviour tests nethersolc change
  ],
  //---------Enums tests: 34 passing, 2 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/constructing_enums_from_ints.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/enum_explicit_overflow.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/enum_explicit_overflow_homestead.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/enum_referencing.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/minmax.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/using_contract_enums_with_explicit_contract_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/using_enums.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/using_inherited_enum.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/using_inherited_enum_excplicitly.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/enum_with_256_members.sol', // WILL NOT SUPPORT abi.decode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/enums/invalid_enum_logged.sol', // WILL NOT SUPPORT yul
  ],
  //---------Error - Will Not Support selector
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/error/selector.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Errors - Will Not Support user defined errors
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/error_in_library_and_interface.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/named_parameters_shadowing_types.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/via_import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/revert_conversion.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/via_contract_type.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/using_structs.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/named_error_args.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/panic_via_import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors/weird_name.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Events tests: 63 passing, 1 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_access_through_base_name_emit.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_anonymous.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_array_memory.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_array_memory_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_array_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_array_storage_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_nested_array_memory_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_dynamic_nested_array_storage_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_no_arguments.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_really_lots_of_data_from_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_really_really_lots_of_data_from_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_struct_memory_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_struct_storage_v2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/events_with_same_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/events_with_same_name_inherited_emit.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_really_lots_of_data.sol', //msg.data
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_lots_of_data.sol', // msg.value
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_signature_in_library.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_indexed_mixed.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_emit_from_other_contract.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_indexed_string.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_anonymous_with_topics.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_anonymous_with_signature_collision2.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_constructor.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_emit.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_anonymous_with_signature_collision.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_indexed_function.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event_indexed_function2.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/events/event.sol', // WILL NOT SUPPORT yul
  ],
  //---------Exponentiation tests: 4 passing (exponentiation very slow with large exponent)
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/exponentiation/literal_base.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/exponentiation/signed_base.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/exponentiation/small_exp.sol', // WILL NOT SUPPORT yul
  ],
  //---------Expressions tests: 24 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/bytes_comparison.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/exp_operator_const.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/exp_operator_const_signed.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/exp_zero_literal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/inc_dec_operators.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/unary_too_long_literal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_functions.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_multiple.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_storage_memory_1.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_true_literal.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_different_types.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_with_return_values.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_false_literal.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_tuples.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/conditional_expression_storage_memory_2.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/bit_operators.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions/uncalled_address_transfer_send.sol', // WILL NOT SUPPORT .transfer
  ],
  //---------External contracts tests: multisource single file tests unsupported
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/ramanujan_pi.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/FixedFeeRegistrar.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/prbmath_unsigned.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/prbmath_signed.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/strings.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/deposit_contract.sol', // WILL NOT SUPPORT sha256
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_prbmath/PRBMathSD59x18.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_prbmath/PRBMathCommon.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_prbmath/PRBMathUD60x18.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_stringutils/stringutils.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/snark.sol', // WILL NOT SUPPORT yul
  ],
  //---------External source tests : multisource single file tests unsupported
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/source_remapping.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/source_name_starting_with_dots.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/relative_imports.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/source_import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/source_import_subdir.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/external.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/other_external.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/external.sol=sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/subdir/sub_external.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/subdir/import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/import_with_subdir.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/multiple_external_source.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/multiple_equals_signs.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/b.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dot_dot_b.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dot_a.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dir/contract.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dir/a.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/source.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/multisource.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/non_normalized_paths.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_non_normalized_paths/d.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_non_normalized_paths/c.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_non_normalized_paths/a.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/h.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/D/d.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/c.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/G/g.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/B/b.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/contract.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/a.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Fallback tests - 5 passing, 3 pending, 5 failing - test suite issues
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/falback_return.sol', // Moved to behaviour tests
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/inherited.sol', // Moved to behaviour tests
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/short_data_calls_fallback.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_or_receive.sol', // STRETCH payable, receive
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_override.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_argument_to_storage.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_override2.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_override_multi.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_return_data.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/fallback_argument.sol', // WILL NOT SUPPORT fallback with arguments
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback/call_forward_bytes.sol', // WILL NOT SUPPORT address.call
  ],
  //---------Free function tests: 21 passing, 2 pending, 1 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/free_namesake_contract_function.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/recursion.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/libraries_from_free.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/storage_calldata_refs.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/easy.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/overloads.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/new_operator.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/import.sol', // multisource single file
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions/free_runtimecode.sol', // WILL NOT SUPPORT type(Contract).runtimeCode
  ],
  //---------Function call tests: 88 passing, 9 pending, 3 failing
  ...[
    //---------Function call inheritance tests 36 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/base_base_overload.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/call_base_base_explicit.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/call_unimplemented_base.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/super_skip_unimplemented_in_abstract_contract.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/base_overload.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/call_base.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/super_skip_unimplemented_in_interface.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/call_base_explicit.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance/call_base_base.sol',
    ],
    //---------Function call misc tests: 52 passing, 9 pending, 3 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/array_multiple_local_vars.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/bound_function_in_var.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/bound_function_to_string.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/calling_other_functions.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/disordered_named_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call_dynamic_returndata.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_function.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_public_override.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/mapping_array_internal_argument.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/mapping_internal_argument.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/mapping_internal_return.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/multiple_return_values.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/named_args_overload.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/named_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/transaction_status.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/multiple_functions.sol', // test suite doesn't support non-existant functions
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/file_level_call_via_module.sol', // multisource single file
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call_to_nonexisting_debugstrings.sol', // WILL NOT SUPPORT functioncalloptions
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call_to_nonexisting.sol', // WILL NOT SUPPORT functioncalloptions
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/bound_function_in_function.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/call_function_returning_function.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/call_function_returning_nothing_via_pointer.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/call_internal_function_via_expression.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/call_internal_function_with_multislot_arguments_via_pointer.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/call_options_overload.sol', // WILL NOT SUPPORT address.balance
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/calling_nonexisting_contract_throws.sol', // WILL NOT SUPPORT raw address call
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/calling_uninitialized_function.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/conditional_with_arguments.sol', // STRETCH conditional
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/creation_function_call_no_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/creation_function_call_with_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/creation_function_call_with_salt.sol', // Fail during deployement because salt cannot be safely narrowed to felt
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/delegatecall_return_value_pre_byzantium.sol', // WILL NOT SUPPORT abi.encodepacked
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/delegatecall_return_value.sol', // WILL NOT SUPPORT abi.encodepacked
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call_at_construction_time.sol', // Fails because WARP allows a contract to call itself during creation (And it should not)
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/external_call_value.sol', // WILL NOT SUPPORT msg.value?
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/failed_create.sol', // WILL NOT SUPPORT payable functions?
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/gas_and_value_basic.sol', // WILL NOT SUPPORT gas
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/gas_and_value_brace_syntax.sol', // WILL NOT SUPPORT gas
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/member_accessors.sol', // WILL NOT SUPPORT keccak
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/precompile_extcodesize_check.sol', // WILL NOT SUPPORT precompile ext call. abi.encode
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/send_zero_ether.sol', // WILL NOT SUPPORT send
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/value_test.sol', // WILL NOT SUPPORT payable
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/bare_call_no_returndatacopy.sol', // WILL NOT SUPPORT raw address call
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/calling_uninitialized_function_in_detail.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/calling_uninitialized_function_through_array.sol', // WILL NOT SUPPORT yul
    ],
  ],
  //---------Function selector tests - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionSelector/function_selector_via_contract_name.sol', // WILL NOT SUPPORT selector
  ],
  //---------Function type tests - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/address_member.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/comparison_operators_for_external_functions.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/function_delete_stack.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/function_type_library_internal.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/function_external_delete_storage.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/function_delete_storage.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/inline_array_with_value_call_option.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/mapping_of_functions.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/pass_function_types_externally.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/pass_function_types_internally.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/store_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/same_function_in_construction_and_runtime_equality_check.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/struct_with_external_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/selector_2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/stack_height_check_on_adding_gas_variable_to_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/same_function_in_construction_and_runtime.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/selector_1.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/struct_with_functions.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/uninitialized_internal_storage_function_call.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes/comparison_operator_for_external_function_cleans_dirty_bits.sol', // WILL NOT SUPPORT yul
  ],
  //---------Getter tests 36 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/mapping_to_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/struct_with_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/string_and_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/mapping_array_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/arrays.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/mapping_of_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/mapping.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/struct_with_bytes_simple.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/array_mapping_struct.sol', // 160bit address
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/getters/value_types.sol', // 160bit address
  ],
  //---------Immutable tests 36 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/assign_at_declaration.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/assign_from_immutables.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/inheritance.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/use_scratch.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/read_in_ctor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/fun_read_in_ctor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/stub.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/getter.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/small_types_in_reverse.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/multi_creation.sol', // Fails due to address clash when deploying contracts
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/internal_function_pointer.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/immutable_signed.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable/getter_call_in_constructor.sol', // WILL NOT SUPPORT try catch
  ],
  //---------Inheritance tests 61 passing, 2 pending, 1 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/pass_dynamic_arguments_to_the_base_base.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/overloaded_function_call_resolve_to_first.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/explicit_base_class.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/super_in_constructor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function_from_a_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/overloaded_function_call_resolve_to_second.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/overloaded_function_call_with_if_else.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/access_base_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/derived_overload_base_function_direct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/pass_dynamic_arguments_to_the_base.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/pass_dynamic_arguments_to_the_base_base_with_gap.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_constant_state_var.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/super_overload.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function_calldata_memory.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/derived_overload_base_function_indirect.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function_calldata_memory_interface.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function_calldata_calldata_interface.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/member_notation_ctor.sol', // multiple source in one file not supported by test suite
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/address_overload_resolution.sol', // WILL NOT SUPPORT due to the use of `balance` and `transfer` functions
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/super_in_constructor_assignment.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/value_for_constructor.sol', // WILL NOT SUPPORT function call options value
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/inherited_function_through_dispatch.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance/base_access_to_function_type_variables.sol', // WILL NOT SUPPORT function objects
  ],
  //---------Inline assembly tests - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_array_read.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_assign.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak_yul_optimization.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_length_read.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_read_and_write_stack.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_memory_access.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_for2.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_recursion.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak256_optimization.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/slot_access.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inlineasm_empty_let.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/external_function_pointer_selector.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak256_optimizer_bug_different_memory_location.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/external_function_pointer_address.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_storage_access_local_var.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_function_call.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak256_optimizer_cache_bug.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_storage_access_via_pointer.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/external_function_pointer_selector_assignment.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_offset_read.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/function_name_clash.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/selfbalance.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_embedded_function_call.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/constant_access_referencing.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak_optimization_bug_string.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_struct_assign.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_array_assign_static.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/external_identifier_access_shadowing.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/shadowing_local_function_opcode.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/basefee_berlin_function.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_switch.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_array_assign_dynamic.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_write_to_stack.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_in_modifiers.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_storage_access_inside_function.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/external_function_pointer_address_assignment.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_function_call_assignment.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_offset_read_write.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/constant_access.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_function_call2.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_storage_access.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_assign_from_nowhere.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/chainid.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_for.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/truefalse.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/leave.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/inline_assembly_if.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/keccak256_assembly.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly/calldata_struct_assign_and_return.sol', // WILL NOT SUPPORT yul
  ],
  //---------Integer tests: 20 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/integer/small_signed_types.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/integer/basic.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/integer/many_local_variables.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/integer/int.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/integer/uint.sol',
  ],
  //---------InterfaceID - WillNotSupport
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/lisa.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/homer.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/interfaces.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/lisa_interfaceId.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/interfaceId_events.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID/homer_interfaceId.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------isoltest tests: 16 passing
  ...[
    //---------isoltest storage tests: 4 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/storage/storage_empty.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/storage/storage_nonempty.sol',
    ],
    //---------isoltest misc tests: 12 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/balance_without_balance.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/format_raw_string_with_control_chars.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/builtins.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/effects.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/balance_with_balance2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/balance_with_balance.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/account.sol', // sending from specific addresses not supported in semantic test suite
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/balance_other_contract.sol', // WILL NOT SUPPORT value
    ],
  ],
  //---------libraries: 150 passing, 4 pending, 2 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/bound_returning_calldata_external.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/bound_returning_calldata.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/bound_to_calldata_external.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/bound_to_calldata.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/external_call_with_storage_array_parameter.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/external_call_with_storage_mapping_parameter.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_call_bound_with_parentheses.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_call_bound_with_parentheses1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_literal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_fixed_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_address.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_bool.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_integer.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_enum.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_mapping.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_dynamic_array.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_fixed_array.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_array_named_pop_push.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_storage_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_calling_private.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_types_in_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_return_var_size.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_staticcall_delegatecall.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_enum_as_an_expression.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_struct_as_an_expression.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/mapping_returns_in_library_named.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/mapping_arguments_in_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/payable_function_calls_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/stub_internal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/stub.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_for_function_on_int.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_for_by_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_for_overload.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_for_storage_structs.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_library_mappings_return.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_library_structs.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/using_library_mappings_public.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_call_in_homestead.sol', // MOVED to behaviour tests, relies on address of test CALLER
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_stray_values.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_contract.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/mapping_returns_in_library.sol', // STRETCH conditional
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_address_named_send_transfer.sol', // WILL NOT SUPPORT raw address calls
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_interface.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/external_call_with_function_pointer_parameter.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_external_function.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_function_named_selector.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_bound_to_internal_function.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/internal_library_function_pointer.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_delegatecall_guard_view_staticcall.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_address_homestead.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_address_via_module.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_address.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_function_selectors.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_delegatecall_guard_view_not_needed.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_return_struct_with_mapping.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_function_selectors_struct.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_delegatecall_guard_view_needed.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries/library_delegatecall_guard_pure.sol', // WILL NOT SUPPORT yul
  ],
  //---------literals: 24 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/denominations.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/scientific_notation.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/ether.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/gwei.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/wei.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/hex_string_with_underscore.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/escape.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/literals/hex_string_with_non_printable_characters.sol', // WILL NOT SUPPORT yul
  ],
  //---------memoryManagement: 4 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement/memory_types_initialisation.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement/static_memory_array_allocation.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement/return_variable.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement/struct_allocation.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement/assembly_access.sol', // WILL NOT SUPPORT yul
  ],
  //---------Metatype tests: 4 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/metaTypes/name_other_contract.sol'
  ],
  //---------Modifiers: 80 passing, 18 pending, 10 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/access_through_contract_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/break_in_modifier.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/continue_in_modifier.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/evaluation_order.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_calling_functions_in_creation_context.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_empty.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_for_constructor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_library_inheritance.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_library.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_local_variables.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_loop_viair.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_multi_invocation_viair.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_multiple_times_local_vars.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_multiple_times.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_overriding.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_return_reference.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_return_parameter_complex.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_return_parameter.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/modifier_in_constructor_ice.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/modifier_init_return.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/modifiers_in_construction_context.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/return_does_not_skip_modifier.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/return_in_modifier.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/stacked_return_with_modifiers.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_loop.sol', // tests old code gen, clashes with function_modifier_loop
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_multi_invocation.sol', // tests old code gen, clashes with function_modifier_multi_invocation_viair
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier_multi_with_return.sol', // tests old code gen, clashes with above
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/modifer_recursive.sol', // STRETCH conditionals
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/access_through_module_name.sol', // WILL NOT SUPPORT module
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers/function_modifier.sol', // WILL NOT SUPPORT msg.value
  ],
  //---------Multisource - Test suite currently does not support multi source tests
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/circular_import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_function_resolution_override_virtual_super.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/circular_reimport_2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_function_resolution_override_virtual_transitive.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_function_transitive_import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/reimport_imported_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/circular_import_2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/imported_free_function_via_alias.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_function_resolution_base_contract.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/circular_reimport.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/imported_free_function_via_alias_direct_call.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/import.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_different_interger_types.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource/free_function_resolution_override_virtual.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Operators: 116 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/compound_assign.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_cleanup.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_constant_left.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_constant_left_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_constant_right.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_constant_right_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left_assignment_different_type.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left_larger_type.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left_uint32.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_left_uint8.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_negative_constant_left.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_negative_constant_right.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_overflow.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_literal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_int16.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_int32.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_int8.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int16_v1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int32_v1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int8_v1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_uint32.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_uint8.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_underflow_negative_rvalue.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int8_v2.sol', // irrelevant: tests abicoder
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int16_v2.sol', // irrelevant: tests abicoder
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_negative_lvalue_signextend_int32_v2.sol', // irrelevant: tests abicoder
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_garbled_signed_v1.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/bitwise_shifting_constantinople_combined.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/bitwise_shifting_constants_constantinople.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shifts.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_bytes_cleanup.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_cleanup_garbled.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_garbled_v1.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_bytes_cleanup_viaYul.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/bitwise_shifting_constantinople.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_garbled_signed_v2.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts/shift_right_garbled_v2.sol', // WILL NOT SUPPORT yul
  ],
  //---------Optimizer - No relevant tests
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/optimizer/shift_bytes.sol', // WILL NOT SUPPORT yul
  ],
  //---------Payable - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/payable/no_nonpayable_circumvention_by_modifier.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Receive - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/receive/ether_and_data.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/receive/empty_calldata_calls_receive.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/receive/inherited.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------Reverts: 8 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/assert_require.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/simple_throw.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/error_struct.sol', // WILL NOT SUPPORT user defined errors
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/invalid_enum_as_external_ret.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/invalid_enum_stored.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/invalid_enum_as_external_arg.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/invalid_instruction.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/revert.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/invalid_enum_compared.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts/revert_return_area.sol', // WILL NOT SUPPORT yul
  ],
  //---------RevertStrings: tests abi checks
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/called_contract_has_code.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/enum_v1.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/enum_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/ether_non_payable_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/function_entry_checks_v1.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/function_entry_checks_v2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/short_input_array.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/short_input_bytes.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/unknown_sig_no_fallback.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_arrays_too_large.sol', // tests abi decoding
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/array_slices.sol', // STRETCH slices
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/bubble.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_tail_short.sol', // nested dynarray arg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_array_invalid_length.sol', // nested dynarray array arg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_array_dynamic_static_short_decode.sol', // dynamic array of static arrays
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/empty_v1.sol', // non-literal error msg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/empty_v2.sol', // non-literal error msg
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_array_dynamic_static_short_reencode.sol', // dynamic array of static arrays
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_array_dynamic_invalid.sol', // nested dynarray input
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/invalid_abi_decoding_calldata_v1.sol', // WILL NOT SUPPORT abi.decode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/calldata_too_short_v1.sol', // WILL NOT SUPPORT abi.decode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/transfer.sol', // WILL NOT SUPPORT transfer
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/library_non_view_call.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings/invalid_abi_decoding_memory_v1.sol', // WILL NOT SUPPORT yul
  ],
  //---------Salted_create
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/salted_create/salted_create_with_value.sol', // WILL NOT SUPPORT due to the use of `value` option
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/salted_create/salted_create.sol', // WILL NOT SUPPORT due to the use of `try catch`
  ],
  //---------smoke 10 passing, 2 pending, 5 failing - test errors
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/multiline_comments.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/bytes_and_strings.sol', // attempts to encode invalid data
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/multiline.sol', // attempts to call non-existant function
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/structs.sol', // nested dynarray
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/arrays.sol', // dynarray of static array
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/failure.sol', // non-literal require message
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/alignment.sol', // REQUIRES CAIRO 0.9
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/basic.sol', // WILL NOT SUPPORT msg.data
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/constructor.sol', // WILL NOT SUPPORT addr.balance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke/fallback.sol', // WILL NOT SUPPORT msg.data
  ],
  //---------specialFunctions - 4 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/specialFunctions/keccak256_optimized.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/specialFunctions/abi_encode_with_signature_from_string.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/specialFunctions/abi_functions_member_access.sol', // WILL NOT SUPPORT function objects
  ],
  //---------state - no relevant tests
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/msg_sender.sol', // test suite doesn't set address same as expected
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/blockhash_basic.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_gaslimit.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_coinbase.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/tx_origin.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_number.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/uncalled_blockhash.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_difficulty.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/tx_gasprice.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/msg_data.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/msg_sig.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/gasleft.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/msg_value.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_timestamp.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_chainid.sol', // WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state/block_basefee.sol', // WILL NOT SUPPORT yul
  ],
  //---------Statement tests: 4 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/statements/do_while_loop_continue.sol',
  ],
  //---------storage: 60 passing, 5 pending, 3 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/state_smoke_test.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_storage_signed.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/mappings_array_pop_delete.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/empty_nonempty_empty.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/struct_accessor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/mapping_string_key.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/simple_accessor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_storage_structs_enum.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_storage_overflow.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/chop_sign_bits.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_storage_structs_bytes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/mappings_array2d_pop_delete.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/accessors_mapping_for_array.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_storage_structs_uint.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/mapping_state.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/complex_accessors.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/array_accessor.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/storage/packed_functions.sol', // WILL NOT SUPPORT function objects
  ],
  //---------strings - 35 passing, 8 pending, 5 failing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/return_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/empty_string_input.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/string_escapes.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/empty_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat/string_concat_empty_strings.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat/string_concat_empty_argument_list.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat/string_concat_different_types.sol', // STRETCH slices
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat/string_concat_nested.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat/string_concat_2_args.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/unicode_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/constant_string_literal.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/unicode_escapes.sol',
  ],
  //---------structs: 124 passing, 36 pending, 20 failing
  ...[
    //---------structs calldata: 30 passing, 2 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_and_ints.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_array_member.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_struct_member.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_with_array_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_structs.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_nested_structs.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_array_member_dynamic.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_as_argument_of_lib_function.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_as_memory_argument.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_struct_member_dynamic.sol',// nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_to_memory_tuple_assignment.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_with_bytes_to_memory.sol', // nested dynarray
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_with_nested_array_to_memory.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/calldata_struct_with_nested_array_to_storage.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/dynamic_nested.sol', // nested dynarrays
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata/dynamically_encoded.sol', // nested dynarrays
    ],
    //---------structs conversion: 3 passing, 3 pending, 2 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/conversion/recursive_storage_memory.sol', // recursive structs
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/conversion/recursive_storage_memory_complex.sol', // recursive structs
    ],
    //---------structs misc: 86 passing, 31 pending, 15 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/copy_struct_array_from_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_storage_to_memory.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/packed_storage_structs_delete.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_member.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/recursive_structs.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/delete_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/using_for_function_on_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_copy_via_local.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/lone_struct_array_type.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_copy.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/structs.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_memory_to_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_named_constructor.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_reference.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/memory_structs_read_write.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/event.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_assign_reference_to_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/array_of_recursive_struct.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_containing_bytes_copy_and_delete.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_storage_push_zero_value.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/memory_structs_as_function_args.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/memory_structs_nested_load.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/memory_struct_named_constructor.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_referencing.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_constructor_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_storage_to_mapping.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/global.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_struct_in_mapping.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/simple_struct_allocation.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/copy_from_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/memory_structs_nested.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/nested_struct_allocation.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_storage_to_memory_function_ptr.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_memory_to_storage_function_ptr.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/multislot_struct_allocation.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/msg_data_to_struct_member_copy.sol', // WILL NOT SUPPORT msg.data
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/function_type_copy.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/copy_from_calldata.sol', // WILL NOT SUPPORT Nested dynamic array on external function argument
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_storage_small.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/recursive_struct_2.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_storage_with_arrays_small.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_storage_with_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/struct_delete_storage_nested_small.sol', // WILL NOT SUPPORT yul
    ],
  ],
  //---------tryCatch - WILL NOT SUPPORT
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/trivial.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/simple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/create.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/malformed_panic_3.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/malformed_panic.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/malformed_panic_2.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/assert.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/structuredAndLowLevel.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/super_trivial.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/malformed_error.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/simple_notuple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/structured.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/return_function.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/panic.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/try_catch_library_call.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/invalid_error_encoding.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/lowLevel.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/malformed_panic_4.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch/nested.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
  ],
  //---------types: 87 passing, 27 pending, 10 failing
  ...[
    //---------types mapping tests: 0 passing, 3 pending, 1 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping/user_defined_types_mapping_storage.sol',
    ],
    //---------types misc tests: 87 passing, 24 pending, 9 failing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_getter_v2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/assign_calldata_value_type.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/nested_tuples.sol', // WILL NOT SUPPORT nested tuple assign
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/packing_signed_types.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_uint_greater_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/tuple_assign_multi_slot_grow.sol', // WILL NOT SUPPORT nested tuple assign
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_v1.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_library_v2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_abstract_constructor_param.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_fixed_bytes_greater_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/struct_mapping_abstract_constructor_param.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_v2.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_uint_same_type.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_library_v1.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_uint_to_fixed_bytes_same_min_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_uint_smaller_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_uint_to_fixed_bytes_smaller_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_simple.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_contract_key.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_fixed_bytes_same_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/packing_unpacking_types.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_fixed_bytes_smaller_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_uint_to_fixed_bytes_same_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/strings.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_contract_key_library.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/array_mapping_abstract_constructor_param.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_contract_key_getter.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_uint_to_fixed_bytes_greater_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/convert_fixed_bytes_to_uint_same_min_size.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping_enum_key_getter_v1.sol', // irrelevant, tests abicoder v1 wrapping
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/type_conversion_cleanup.sol', //160 bit address
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/types/external_function_to_address.sol', // WILL NOT SUPPORT function address
    ],
  ],
  //---------underscore: 4 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/underscore/as_function.sol', // WILL NOT SUPPORT function objects
  ],
  //---------uninitializedFunctionPointer - Will Not Support
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/storeInConstructor.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/invalidStoredInConstructor.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/uninitialized_internal_storage_function_legacy.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/store2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/invalidInConstructor.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer/uninitialized_internal_storage_function_via_yul.sol', // WILL NOT SUPPORT yul
  ],
  //---------UserDefinedValueType - 40 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/calldata_to_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/constant.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/conversion_abicoderv1.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/fixedpoint.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/mapping_key.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/memory_to_storage.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/simple.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/wrap_unwrap_via_contract_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/zero_cost_abstraction_comparison_elementary.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/zero_cost_abstraction_comparison_userdefined.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/in_parenthesis.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/wrap_unwrap.sol', // WILL NOT SUPPORT function objects
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/conversion.sol', // moved to behaviour tests for reliable passing of out of bounds data
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/abicodec.sol', // WILL NOT SUPPORT abi.encode
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/calldata.sol', // WILL NOT SUPPORT address members
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/erc20.sol', // WILL NOT SUPPORT indexed parameters
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/multisource.sol', // WILL NOT SUPPORT module
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/multisource_module.sol', // WILL NOT SUPPORT module
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/ownable.sol', // WILL NOT SUPPORT user defined errors
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/storage_signed.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/dirty_slot.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/immutable_signed.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/parameter.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/assembly_access_bytes2_abicoder_v1.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/assembly_access_bytes2_abicoder_v2.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/cleanup_abicoderv1.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/dirty_uint8_read.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/storage_layout.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/cleanup.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType/storage_layout_struct.sol', // WILL NOT SUPPORT yul
  ],
  //---------Variables: 32 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/public_state_overridding.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/delete_local.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/public_state_overridding_dynamic_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/mapping_local_tuple_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/mapping_local_compound_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/public_state_overridding_mapping_to_dynamic_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/mapping_local_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/delete_locals.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/variables/storing_invalid_boolean.sol', // WILL NOT SUPPORT yul
  ],
  //---------Various tests:124 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/assignment_to_const_var_involving_expression.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/crazy_elementary_typenames_on_stack.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/cross_contract_types.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/decayed_tuple.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/destructuring_assignment.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/empty_name_return_parameter.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/flipping_sign_tests.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/gasleft_shadow_resolution.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/inline_member_init.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/inline_member_init_inheritence.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/inline_tuple_with_rational_numbers.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/literal_empty_string.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/memory_overwrite.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/multi_modifiers.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/multi_variable_declaration.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/nested_calldata_struct.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/nested_calldata_struct_to_memory.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/positive_integers_to_signed.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/single_copy_with_multiple_inheritance.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/skip_dynamic_types.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/skip_dynamic_types_for_structs.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/state_variable_local_variable_mixture.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/state_variable_under_contract_name.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/storage_string_as_mapping_key_without_variable.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/string_tuples.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/super.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/super_alone.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/super_parentheses.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/swap_in_storage_overwrite.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/tuples.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/typed_multi_variable_declaration.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/negative_stack_height.sol', // starknet-compile takes too long to transpile the output, testnet dies
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/erc20.sol', // WILL NOT SUPPORT indexed
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/skip_dynamic_types_for_static_arrays_with_dynamic_elements.sol', // nested dynarrays
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/store_bytes.sol', // msg.data
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/value_complex.sol', // address.balance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/write_storage_external.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/value_insane.sol', // WILL NOT SUPPORT address.balance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/test_underscore_in_hex.sol', // STRETCH conditional
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/staticcall_for_view_and_pure.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/staticcall_for_view_and_pure_pre_byzantium.sol', // Fails because WARP is post byzantium only
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/external_types_in_calls.sol', //
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/contract_binary_dependencies.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/senders_balance.sol', // WILL NOT SUPPORT .balance
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/gasleft_decrease.sol', // WILL NOT SUPPORT gasleft
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/codehash.sol', // WILL NOT SUPPORT address members
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_length_contract_member.sol', // WILL NOT SUPPORT address members
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/balance.sol', // WILL NOT SUPPORT address members
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/address_code.sol', // WILL NOT SUPPORT address members
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/byte_optimization_bug.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_access_padding.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_access_runtime.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_access_create.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/codehash_assembly.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/iszero_bnot_correct.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_length.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/address_code_complex.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/code_access_content.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/various/codebalance_assembly.sol', // WILL NOT SUPPORT yul
  ],
  //---------ViaYul: 268 passing
  ...[
    //---------ViaYul array memory allocation: 20 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation/array_zeroed_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation/array_2d_zeroed_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation/array_static_zeroed_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation/array_static_return_param_zeroed_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation/array_array_static.sol',
    ],
    //---------ViaYul cleanup - no relevant tests
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/cleanup/comparison.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/cleanup/checked_arithmetic.sol', // WILL NOT SUPPORT yul
    ],
    //---------ViaYul conditional - STRETCH
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional/conditional_with_variables.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional/conditional_tuple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional/conditional_multiple.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional/conditional_with_assignment.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional/conditional_true_false_literal.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    ],
    //---------ViaYul conversion: 12 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/explicit_cast_local_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/explicit_cast_function_call.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/explicit_cast_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/explicit_string_bytes_calldata_cast.sol', // STRETCH slices
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/function_cast.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/implicit_cast_assignment.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/implicit_cast_local_assignment.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion/implicit_cast_function_call.sol', // WILL NOT SUPPORT yul
    ],
    //---------ViaYul loops: 16 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/loops/continue.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/loops/break.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/loops/simple.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/loops/return.sol',
    ],
    //---------ViaYul storage: 8 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/simple_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/packed_storage.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/dirty_storage_bytes.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/dirty_storage_dynamic_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/mappings.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/dirty_storage_bytes_long.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/dirty_storage_static_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage/dirty_storage_struct.sol', // WILL NOT SUPPORT yul
    ],
    //---------ViaYul misc: 212 passing
    ...[
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_2d_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_2d_new.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_3d_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_3d_new.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_as_parameter.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_create.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_index_access.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_push_return_reference.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_push_with_arg.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_index_boundary_test.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_pop_zero_length.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_push_empty.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/assert.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/assert_and_require.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/assign_tuple_from_function_call.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/comparison.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/define_tuple_from_function_call.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_add_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_add_overflow_signed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_div_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_mod_zero.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_mod_zero_signed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_mul_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_mul_overflow_signed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_sub_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/detect_sub_overflow_signed.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_literals.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_literals_success.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_neg.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_neg_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_overflow.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/exp_various.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/if.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/keccak.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/local_address_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/local_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/local_bool_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/local_tuple_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/local_variable_without_init.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/mapping_enum_key_getter.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/mapping_getters.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/mapping_string_key.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/negation_bug.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/return.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/return_storage_pointers.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/short_circuit.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/simple_assignment.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/string_format.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/string_literals.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/tuple_evaluation_order.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/unary_fixedbytes.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/virtual_functions.sol',
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_length_access.sol', // exceeds testnet step count, functionality moved to behaviour tests
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_push_empty_length_address.sol', // exceeds testnet step count, functionality moved to behaviour tests
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_push_pop.sol', // exceeds testnet step count, functionality moved to behaviour tests
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_index_access.sol', // exceeds testnet step count, functionality moved to behaviour tests
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/function_entry_checks.sol', // tests invalid solidity calldata
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/comparison_functions.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/calldata_bytes_array_bounds.sol', //invalid calldata
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/smoke_test.sol', // attempts to call non-existant function
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/empty_return_corrupted_free_memory_pointer.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/calldata_array_length.sol', // nested dynarray args
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/calldata_array_three_dimensional.sol', // nested dynarray args
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/require.sol', // non-literal error message
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/copy_struct_invalid_ir_bug.sol', // WILL NOT SUPPORT function object
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/calldata_array_access.sol', // nested dynarray args
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/struct_member_access.sol', // nested dyn array arg
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/calldata_array_index_range_access.sol', // STRETCH slices
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/function_selector.sol', // WILL NOT SUPPORT function selector
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/function_pointers.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/function_address.sol', // WILL NOT SUPPORT function address
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/delete.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_function_pointers.sol', // WILL NOT SUPPORT function objects
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_memory_dynamic_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_memory_uint32.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_memory_static_array.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/memory_struct_allow.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/msg_sender.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_memory_struct.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/various_inline_asm.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/simple_inline_asm.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/return_and_convert.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_calldata_struct.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_storage_index_zeroed_test.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/unary_operations.sol', // WILL NOT SUPPORT yul
      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/dirty_memory_int32.sol', // WILL NOT SUPPORT yul
    ],
  ],
  //---------VirtualFunctions: 12 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/virtualFunctions/virtual_function_usage_in_constructor_arguments.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/virtualFunctions/virtual_function_calls.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/virtualFunctions/internal_virtual_function_calls.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/virtualFunctions/internal_virtual_function_calls_through_dispatch.sol', // WILL NOT SUPPORT function objects
  ],
  //---------Misc: 56 passing
  ...[
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_with_params_diamond_inheritance.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/empty_for_loop.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestFormatting.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state_variables_init_order_3.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state_var_initialization.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state_variables_init_order.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_with_params_inheritance.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_with_params.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/c99_scoping_activation.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state_variables_init_order_2.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_inheritance_init_order.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_inheritance_init_order_3_viaIR.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_inheritance_init_order_2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_with_params_inheritance_2.sol',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/empty_contract.sol', // test suite cannot call non-existant function
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor_inheritance_init_order_3_legacy.sol', // We don't support the legacy bug behaviour and instead implement viaYul behaviour.
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interface_inheritance_conversions.sol', // Fails due to address clash when deploying the same contracts
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/dirty_calldata_dynamic_array.sol', // WILL NOT SUPPORT yul
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/dirty_calldata_bytes.sol', // WILL NOT SUPPORT yul
  ],
];

export default tests;

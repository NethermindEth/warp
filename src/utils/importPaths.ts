const CAIRO_COMMON_PATH = ['starkware', 'cairo', 'common'];

export const ALLOC: [string[], string] = [[...CAIRO_COMMON_PATH, 'alloc'], 'alloc'];
export const BITWISE_BUILTIN: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'cairo_builtins'],
  'BitwiseBuiltin',
];
export const DEFAULT_DICT_FINALIZE: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'default_dict'],
  'default_dict_finalize',
];
export const DEFAULT_DICT_NEW: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'default_dict'],
  'default_dict_new',
];
export const DICT_ACCESS: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'dict_access'],
  'DictAccess',
];
export const DICT_READ: [string[], string] = [[...CAIRO_COMMON_PATH, 'dict'], 'dict_read'];
export const DICT_WRITE: [string[], string] = [[...CAIRO_COMMON_PATH, 'dict'], 'dict_write'];
export const FINALIZE_KECCAK: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'cairo_keccak', 'keccak'],
  'finalize_keccak',
];
export const IS_LE: [string[], string] = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le'];
export const IS_LE_FELT: [string[], string] = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le_felt'];
export const SPLIT_FELT: [string[], string] = [[...CAIRO_COMMON_PATH, 'math'], 'split_felt'];
export const UINT256_ADD: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_add'];
export const UINT256_EQ: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_eq'];
export const UINT256_LE: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_le'];
export const UINT256_LT: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_lt'];
export const UINT256_MUL: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_mul'];
export const UINT256_SUB: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_sub'];

//------------------------------------------------------

const STARKWARE_SYSCALL_PATH = ['starkware', 'starknet', 'common', 'syscalls'];

export const DEPLOY: [string[], string] = [[...STARKWARE_SYSCALL_PATH], 'deploy'];
export const EMIT_EVENT: [string[], string] = [[...STARKWARE_SYSCALL_PATH], 'emit_event'];
export const GET_CONTRACT_ADDRESS: [string[], string] = [
  [...STARKWARE_SYSCALL_PATH],
  'get_contract_address',
];

//------------------------------------------------------

export const WARPLIB_MEMORY = ['warplib', 'memory'];
export const WARPLIB_KECCAK = ['warplib', 'keccak'];
export const WARPLIB_MATHS = ['warplib', 'maths'];
export const WARPLIB_CONVERSIONS = ['warplib', 'conversions'];
export const WARPLIB_EXT_INPUT_CHK = ['warplib', 'external_input_check'];

export const DYNAMIC_ARRAYS_UTIL = ['warplib', 'dynamic_arrays_util'];
export const BYTES_CONVERSIONS = [...WARPLIB_CONVERSIONS, 'bytes_conversions'];
export const INT_CONVERSIONS = [...WARPLIB_CONVERSIONS, 'int_conversions'];
// Integer_conversions holds the functions used in Cairo1, once int_conversions is translated they both can be merged
export const INTEGER_CONVERSIONS = [...WARPLIB_CONVERSIONS, 'integer_conversions'];

export const BYTES_ACCESS = [...WARPLIB_MATHS, 'bytes_access'];
export const BYTE256_AT_INDEX: [string[], string] = [BYTES_ACCESS, 'byte256_at_index'];
export const BYTE_ARRAY_TO_FELT_VALUE: [string[], string] = [
  [...DYNAMIC_ARRAYS_UTIL],
  'byte256_at_index',
];
export const BYTE_ARRAY_LENGTH: [string[], string] = [[...DYNAMIC_ARRAYS_UTIL], 'byte256_at_index'];
export const FELT_ARRAY_CONCAT: [string[], string] = [[...WARPLIB_KECCAK], 'felt_array_concat'];
export const FELT_ARRAY_TO_WARP_MEMORY_ARRAY: [string[], string] = [
  [...DYNAMIC_ARRAYS_UTIL],
  'felt_array_to_warp_memory_array',
];
export const FELT_TO_UINT256: [string[], string] = [[...WARPLIB_MATHS, 'utils'], 'felt_to_uint256'];
export const FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY: [string[], string] = [
  [...DYNAMIC_ARRAYS_UTIL],
  'fixed_bytes256_to_felt_dynamic_array',
];
export const FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY_SPL: [string[], string] = [
  [...DYNAMIC_ARRAYS_UTIL],
  'fixed_bytes256_to_felt_dynamic_array_spl',
];
export const NARROW_SAFE: [string[], string] = [[...WARPLIB_MATHS, 'utils'], 'narrow_safe'];
export const PACK_BYTES_FELT: [string[], string] = [[...WARPLIB_KECCAK], 'pack_bytes_felt'];
export const STRING_HASH: [string[], string] = [['warplib', 'string_hash'], 'string_hash'];
export const WARP_KECCAK: [string[], string] = [[...WARPLIB_KECCAK], 'warp_keccak'];
export const WARP_UINT256: [string[], string] = [[...INT_CONVERSIONS], 'warp_uint256'];
export const WM_DYN_ARRAY_LENGTH: [string[], string] = [[...WARPLIB_MEMORY], 'wm_dyn_array_length'];
export const WM_INDEX_DYN: [string[], string] = [[...WARPLIB_MEMORY], 'wm_index_dyn'];
export const WM_INDEX_STATIC: [string[], string] = [[...WARPLIB_MEMORY], 'wm_index_static'];
export const WM_NEW: [string[], string] = [[...WARPLIB_MEMORY], 'wm_new'];
export const WM_READ_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_felt'];
export const WM_READ_ID: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_id'];
export const WM_TO_FELT_ARRAY: [string[], string] = [[...WARPLIB_MEMORY], 'wm_to_felt_array'];
export const WM_ALLOC: [string[], string] = [[...WARPLIB_MEMORY], 'wm_alloc'];
export const WM_WRITE_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_felt'];
export const ARRAY: [string[], string] = [['array'], 'Array'];
export const ARRAY_TRAIT: [string[], string] = [['array'], 'ArrayTrait'];
export const U256_FROM_FELTS: [string[], string] = [[...INTEGER_CONVERSIONS], 'u256_from_felts'];
export const FELT252_INTO_BOOL: [string[], string] = [
  [...INTEGER_CONVERSIONS],
  'felt252_into_bool',
];
export const BOOL_INTO_FELT252: [string[], string] = [
  [...INTEGER_CONVERSIONS],
  'bool_into_felt252',
];

/**  cairo1 uX <-> felt conversions */

// u8 <-> felt
export const U8_FROM_FELT: [string[], string] = [['integer'], 'u8_from_felt252'];
export const U8_TO_FELT: [string[], string] = [['integer'], 'u8_to_felt252'];

// u16 <-> felt
export const U16_FROM_FELT: [string[], string] = [['integer'], 'u16_from_felt252'];
export const U16_TO_FELT: [string[], string] = [['integer'], 'u16_to_felt252'];

// u24 <-> felt
export const U24_FROM_FELT: [string[], string] = [['integer'], 'u24_from_felt252'];
export const U24_TO_FELT: [string[], string] = [['integer'], 'u24_to_felt252'];

// u32 <-> felt
export const U32_FROM_FELT: [string[], string] = [['integer'], 'u32_from_felt252'];
export const U32_TO_FELT: [string[], string] = [['integer'], 'u32_to_felt252'];

// u40 <-> felt
export const U40_FROM_FELT: [string[], string] = [['integer'], 'u40_from_felt252'];
export const U40_TO_FELT: [string[], string] = [['integer'], 'u40_to_felt252'];

// u48 <-> felt
export const U48_FROM_FELT: [string[], string] = [['integer'], 'u48_from_felt252'];
export const U48_TO_FELT: [string[], string] = [['integer'], 'u48_to_felt252'];

// u56 <-> felt
export const U56_FROM_FELT: [string[], string] = [['integer'], 'u56_from_felt252'];
export const U56_TO_FELT: [string[], string] = [['integer'], 'u56_to_felt252'];

// u64 <-> felt
export const U64_FROM_FELT: [string[], string] = [['integer'], 'u64_from_felt252'];
export const U64_TO_FELT: [string[], string] = [['integer'], 'u64_to_felt252'];

// u72 <-> felt
export const U72_FROM_FELT: [string[], string] = [['integer'], 'u72_from_felt252'];
export const U72_TO_FELT: [string[], string] = [['integer'], 'u72_to_felt252'];

// u80 <-> felt
export const U80_FROM_FELT: [string[], string] = [['integer'], 'u80_from_felt252'];
export const U80_TO_FELT: [string[], string] = [['integer'], 'u80_to_felt252'];

// u88 <-> felt
export const U88_FROM_FELT: [string[], string] = [['integer'], 'u88_from_felt252'];
export const U88_TO_FELT: [string[], string] = [['integer'], 'u88_to_felt252'];

// u96 <-> felt
export const U96_FROM_FELT: [string[], string] = [['integer'], 'u96_from_felt252'];
export const U96_TO_FELT: [string[], string] = [['integer'], 'u96_to_felt252'];

// u104 <-> felt
export const U104_FROM_FELT: [string[], string] = [['integer'], 'u104_from_felt252'];
export const U104_TO_FELT: [string[], string] = [['integer'], 'u104_to_felt252'];

// u112 <-> felt
export const U112_FROM_FELT: [string[], string] = [['integer'], 'u112_from_felt252'];
export const U112_TO_FELT: [string[], string] = [['integer'], 'u112_to_felt252'];

// u120 <-> felt
export const U120_FROM_FELT: [string[], string] = [['integer'], 'u120_from_felt252'];
export const U120_TO_FELT: [string[], string] = [['integer'], 'u120_to_felt252'];

// u128 <-> felt
export const U128_FROM_FELT: [string[], string] = [['integer'], 'u128_from_felt252'];
export const U128_TO_FELT: [string[], string] = [['integer'], 'u128_to_felt252'];

// u136 <-> felt
export const U136_FROM_FELT: [string[], string] = [['integer'], 'u136_from_felt252'];
export const U136_TO_FELT: [string[], string] = [['integer'], 'u136_to_felt252'];

// u144 <-> felt
export const U144_FROM_FELT: [string[], string] = [['integer'], 'u144_from_felt252'];
export const U144_TO_FELT: [string[], string] = [['integer'], 'u144_to_felt252'];

// u152 <-> felt
export const U152_FROM_FELT: [string[], string] = [['integer'], 'u152_from_felt252'];
export const U152_TO_FELT: [string[], string] = [['integer'], 'u152_to_felt252'];

// u160 <-> felt
export const U160_FROM_FELT: [string[], string] = [['integer'], 'u160_from_felt252'];
export const U160_TO_FELT: [string[], string] = [['integer'], 'u160_to_felt252'];

// u168 <-> felt
export const U168_FROM_FELT: [string[], string] = [['integer'], 'u168_from_felt252'];
export const U168_TO_FELT: [string[], string] = [['integer'], 'u168_to_felt252'];

// u176 <-> felt
export const U176_FROM_FELT: [string[], string] = [['integer'], 'u176_from_felt252'];
export const U176_TO_FELT: [string[], string] = [['integer'], 'u176_to_felt252'];

// u184 <-> felt
export const U184_FROM_FELT: [string[], string] = [['integer'], 'u184_from_felt252'];
export const U184_TO_FELT: [string[], string] = [['integer'], 'u184_to_felt252'];

// u192 <-> felt
export const U192_FROM_FELT: [string[], string] = [['integer'], 'u192_from_felt252'];
export const U192_TO_FELT: [string[], string] = [['integer'], 'u192_to_felt252'];

// u200 <-> felt
export const U200_FROM_FELT: [string[], string] = [['integer'], 'u200_from_felt252'];
export const U200_TO_FELT: [string[], string] = [['integer'], 'u200_to_felt252'];

// u208 <-> felt
export const U208_FROM_FELT: [string[], string] = [['integer'], 'u208_from_felt252'];
export const U208_TO_FELT: [string[], string] = [['integer'], 'u208_to_felt252'];

// u216 <-> felt
export const U216_FROM_FELT: [string[], string] = [['integer'], 'u216_from_felt252'];
export const U216_TO_FELT: [string[], string] = [['integer'], 'u216_to_felt252'];

// u224 <-> felt
export const U224_FROM_FELT: [string[], string] = [['integer'], 'u224_from_felt252'];
export const U224_TO_FELT: [string[], string] = [['integer'], 'u224_to_felt252'];

// u232 <-> felt
export const U232_FROM_FELT: [string[], string] = [['integer'], 'u232_from_felt252'];
export const U232_TO_FELT: [string[], string] = [['integer'], 'u232_to_felt252'];

// u240 <-> felt
export const U240_FROM_FELT: [string[], string] = [['integer'], 'u240_from_felt252'];
export const U240_TO_FELT: [string[], string] = [['integer'], 'u240_to_felt252'];

// u248 <-> felt
export const U248_FROM_FELT: [string[], string] = [['integer'], 'u248_from_felt252'];
export const U248_TO_FELT: [string[], string] = [['integer'], 'u248_to_felt252'];

/**  ------------------------------ */

export const GET_CALLER_ADDRESS: [string[], string] = [['starknet'], 'get_caller_address'];
export const CONTRACT_ADDRESS: [string[], string] = [['starknet'], 'ContractAddress'];

export const CONTRACT_ADDRESS_FROM_FELT: [string[], string] = [
  ['starknet'],
  'contract_address_try_from_felt252',
];

export const UNSAFE_CONTRACT_ADDRESS_FROM_U256: [string[], string] = [
  INTEGER_CONVERSIONS,
  'unsafe_contract_address_from_u256',
];

export const INTO: [string[], string] = [['traits'], 'Into'];
export const OPTION_TRAIT: [string[], string] = [['option'], 'OptionTrait'];

export const MEMORY_MODULE = ['warplib', 'warp_memory'];
export const WARP_MEMORY: [string[], string] = [MEMORY_MODULE, 'WarpMemory'];
export const WARP_MEMORY_TRAIT: [string[], string] = [MEMORY_MODULE, 'WarpMemoryTrait'];
export const WARP_MEMORY_IMPL: [string[], string] = [MEMORY_MODULE, 'WarpMemoryImpl'];
export const ACCESSOR: [string[], string] = [MEMORY_MODULE, 'WarpMemoryAccesssor'];
export const ACCESSOR_TRAIT: [string[], string] = [MEMORY_MODULE, 'WarpMemoryAccesssorTrait'];

export const SUPER: string[] = ['super'];

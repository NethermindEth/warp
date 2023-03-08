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
export const HASH_BUILTIN: [string[], string] = [
  [...CAIRO_COMMON_PATH, 'cairo_builtins'],
  'HashBuiltin',
];
export const IS_LE: [string[], string] = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le'];
export const IS_LE_FELT: [string[], string] = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le_felt'];
export const SPLIT_FELT: [string[], string] = [[...CAIRO_COMMON_PATH, 'math'], 'split_felt'];
export const UINT256: [string[], string] = [[...CAIRO_COMMON_PATH, 'uint256'], 'Uint256'];
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
export const GET_CALLER_ADDRESS: [string[], string] = [
  [...STARKWARE_SYSCALL_PATH],
  'get_caller_address',
];
export const GET_CONTRACT_ADDRESS: [string[], string] = [
  [...STARKWARE_SYSCALL_PATH],
  'get_contract_address',
];

//------------------------------------------------------

export const WARPLIB_MEMORY = ['warplib', 'memory'];
export const WARPLIB_KECCAK = ['warplib', 'keccak'];
export const WARPLIB_MATHS = ['warplib', 'maths'];
export const WARPLIB_INTEGER = ['warplib', 'integer'];

export const DYNAMIC_ARRAYS_UTIL = ['warplib', 'dynamic_arrays_util'];
export const BYTES_CONVERSIONS = [...WARPLIB_MATHS, 'bytes_conversions'];
export const INT_CONVERSIONS = [...WARPLIB_MATHS, 'int_conversions'];

export const BYTE256_AT_INDEX: [string[], string] = [
  [...WARPLIB_MATHS, 'bytes_access'],
  'byte256_at_index',
];
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
export const WM_READ256: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_256'];
export const WM_READ_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_felt'];
export const WM_READ_ID: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_id'];
export const WM_TO_FELT_ARRAY: [string[], string] = [[...WARPLIB_MEMORY], 'wm_to_felt_array'];
export const WM_ALLOC: [string[], string] = [[...WARPLIB_MEMORY], 'wm_alloc'];
export const WM_WRITE256: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_256'];
export const WM_WRITE_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_felt'];
export const U256_FROM_FELTS: [string[], string] = [[...WARPLIB_INTEGER], 'u256_from_felts'];

//------------------------------------------------------

export const ARRAY_TRAIT: [string[], string] = [['array'], 'ArrayTrait'];

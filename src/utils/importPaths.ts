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
export const WM_READ_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_felt'];
export const WM_READ_ID: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_id'];
export const WM_TO_FELT_ARRAY: [string[], string] = [[...WARPLIB_MEMORY], 'wm_to_felt_array'];
export const WM_ALLOC: [string[], string] = [[...WARPLIB_MEMORY], 'wm_alloc'];
export const WM_WRITE_FELT: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_felt'];

/** cairo1 uX memory read */
export const WM_READ8: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_8'];
export const WM_READ16: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_16'];
export const WM_READ24: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_24'];
export const WM_READ32: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_32'];
export const WM_READ40: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_40'];
export const WM_READ48: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_48'];
export const WM_READ56: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_56'];
export const WM_READ64: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_64'];
export const WM_READ72: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_72'];
export const WM_READ80: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_80'];
export const WM_READ88: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_88'];
export const WM_READ96: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_96'];
export const WM_READ104: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_104'];
export const WM_READ112: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_112'];
export const WM_READ120: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_120'];
export const WM_READ128: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_128'];
export const WM_READ136: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_136'];
export const WM_READ144: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_144'];
export const WM_READ152: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_152'];
export const WM_READ160: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_160'];
export const WM_READ168: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_168'];
export const WM_READ176: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_176'];
export const WM_READ184: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_184'];
export const WM_READ192: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_192'];
export const WM_READ200: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_200'];
export const WM_READ208: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_208'];
export const WM_READ216: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_216'];
export const WM_READ224: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_224'];
export const WM_READ232: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_232'];
export const WM_READ240: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_240'];
export const WM_READ248: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_248'];
export const WM_READ256: [string[], string] = [[...WARPLIB_MEMORY], 'wm_read_256'];
/** --------------------- */

/** cairo1 uX memory write */
export const WM_WRITE8: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_8'];
export const WM_WRITE16: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_16'];
export const WM_WRITE24: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_24'];
export const WM_WRITE32: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_32'];
export const WM_WRITE40: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_40'];
export const WM_WRITE48: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_48'];
export const WM_WRITE56: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_56'];
export const WM_WRITE64: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_64'];
export const WM_WRITE72: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_72'];
export const WM_WRITE80: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_80'];
export const WM_WRITE88: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_88'];
export const WM_WRITE96: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_96'];
export const WM_WRITE104: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_104'];
export const WM_WRITE112: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_112'];
export const WM_WRITE120: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_120'];
export const WM_WRITE128: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_128'];
export const WM_WRITE136: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_136'];
export const WM_WRITE144: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_144'];
export const WM_WRITE152: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_152'];
export const WM_WRITE160: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_160'];
export const WM_WRITE168: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_168'];
export const WM_WRITE176: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_176'];
export const WM_WRITE184: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_184'];
export const WM_WRITE192: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_192'];
export const WM_WRITE200: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_200'];
export const WM_WRITE208: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_208'];
export const WM_WRITE216: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_216'];
export const WM_WRITE224: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_224'];
export const WM_WRITE232: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_232'];
export const WM_WRITE240: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_240'];
export const WM_WRITE248: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_248'];
export const WM_WRITE256: [string[], string] = [[...WARPLIB_MEMORY], 'wm_write_256'];
/** --------------------- */

//------------------------------------------------------

export const ARRAY: [string[], string] = [['array'], 'Array'];
export const ARRAY_TRAIT: [string[], string] = [['array'], 'ArrayTrait'];
export const U256_FROM_FELTS: [string[], string] = [['warplib', 'integer'], 'u256_from_felts'];

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
export const ADDRESS_INTO_FELT: [string[], string] = [['starknet'], 'ContractAddressIntoFelt252'];
export const INTO: [string[], string] = [['traits'], 'Into'];

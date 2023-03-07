const CAIRO_COMMON_PATH = ['starkware', 'cairo', 'common'];

const ALLOC = [[...CAIRO_COMMON_PATH, 'alloc'], 'alloc'];
const BITWISE_BUILTIN = [[...CAIRO_COMMON_PATH, 'cairo_builtins'], 'BitwiseBuiltin'];
const DEFAULT_DICT_FINALIZE = [[...CAIRO_COMMON_PATH, 'default_dict'], 'default_dict_finalize'];
const DEFAULT_DICT_NEW = [[...CAIRO_COMMON_PATH, 'default_dict'], 'default_dict_new'];
const DICT_ACCESS = [[...CAIRO_COMMON_PATH, 'dict_access'], 'DictAccess'];
const DICT_READ = [[...CAIRO_COMMON_PATH, 'dict'], 'dict_read'];
const DICT_WRITE = [[...CAIRO_COMMON_PATH, 'dict'], 'dict_write'];
const FINALIZE_KECCAK = [[...CAIRO_COMMON_PATH, 'cairo_keccak', 'keccak'], 'finalize_keccak'];
const HASH_BUILTIN = [[...CAIRO_COMMON_PATH, 'cairo_builtins'], 'HashBuiltin'];
const IS_LE = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le'];
const IS_LE_FELT = [[...CAIRO_COMMON_PATH, 'math_cmp'], 'is_le_felt'];
const SPLIT_FELT = [[...CAIRO_COMMON_PATH, 'math'], 'split_felt'];
const UINT256 = [[...CAIRO_COMMON_PATH, 'uint256'], 'Uint256'];
const UINT256_ADD = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_add'];
const UINT256_EQ = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_eq'];
const UINT256_LE = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_le'];
const UINT256_LT = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_lt'];
const UINT256_MUL = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_mul'];
const UINT256_SUB = [[...CAIRO_COMMON_PATH, 'uint256'], 'uint256_sub'];

//------------------------------------------------------
const STARKWARE_SYSCALL_PATH = ['starkware', 'starknet', 'common', 'syscalls'];

const DEPLOY = [[...STARKWARE_SYSCALL_PATH], 'deploy'];
const EMIT_EVENT = [[...STARKWARE_SYSCALL_PATH], 'emit_event'];
const GET_CALLER_ADDRESS = [[...STARKWARE_SYSCALL_PATH], 'get_caller_address'];
const GET_CONTRACT_ADDRESS = [[...STARKWARE_SYSCALL_PATH], 'get_contract_address'];

//------------------------------------------------------

const WARPLIB_MEMORY = ['warplib', 'memory'];
const WARPLIB_MATHS = ['warplib', 'maths'];
const WARPLIB_KECCAK = ['warplib', 'keccak'];

const DYNAMIC_ARRAYS_UTIL = ['warplib', 'dynamic_arrays_util'];
const BYTES_CAONVERSIONS = [...WARPLIB_MATHS, 'bytes_conversions'];
const INTE_CONVERSIONS = [...WARPLIB_MATHS, 'int_conversions'];

const BYTE256_AT_INDEX = [[...WARPLIB_MATHS, 'bytes_access'], 'byte256_at_index'];
const BYTE_ARRAY_TO_FELT_VALUE = [[...DYNAMIC_ARRAYS_UTIL], 'byte256_at_index'];
const BYTE_ARRAY_LENGTH = [[...DYNAMIC_ARRAYS_UTIL], 'byte256_at_index'];
const DYN_ARRAY_LENGTH = [[...WARPLIB_MEMORY], 'wm_dyn_array_length'];
const FELT_ARRAY_CONCAT = [[...WARPLIB_KECCAK], 'felt_array_concat'];
const FELT_ARRAY_TO_WARP_MEMORY_ARRAY = [
  [...DYNAMIC_ARRAYS_UTIL],
  'felt_array_to_warp_memory_array',
];
const FELT_TO_UINT256 = [[...WARPLIB_MATHS, 'utils'], 'felt_to_uint256'];
const FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY = [
  [...DYNAMIC_ARRAYS_UTIL],
  'fixed_bytes256_to_felt_dynamic_array',
];
const FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY_SPL = [
  [...DYNAMIC_ARRAYS_UTIL],
  'fixed_bytes256_to_felt_dynamic_array_spl',
];
const INDEX_DYN = [[...WARPLIB_MEMORY], 'wm_index_dyn'];
const INDEX_STATIC = [[...WARPLIB_MEMORY], 'wm_index_static'];
const NARROW_SAFE = [[...WARPLIB_MATHS, 'utils'], 'narrow_safe'];
const NEW = [[...WARPLIB_MEMORY], 'wm_new'];
const PACK_BYTES_FELT = [[...WARPLIB_KECCAK], 'pack_bytes_felt'];
const READ256 = [[...WARPLIB_MEMORY], 'wm_read_256'];
const READ_FELT = [[...WARPLIB_MEMORY], 'wm_read_felt'];
const READ_ID = [[...WARPLIB_MEMORY], 'wm_read_id'];
const STRING_HASH = [['warplib', 'string_hash'], 'string_hash'];
const TO_FELT_ARRAY = [[...WARPLIB_MEMORY], 'wm_to_felt_array'];
const WARP_ALLOC = [[...WARPLIB_MEMORY], 'wm_alloc'];
const WARP_KECCAK = [[...WARPLIB_KECCAK], 'warp_keccak'];
const WARP_UINT256 = [[...INTE_CONVERSIONS], 'warp_uint256'];
const WRITE256 = [[...WARPLIB_MEMORY], 'wm_write_256'];
const WRITE_FELT = [[...WARPLIB_MEMORY], 'wm_write_felt'];

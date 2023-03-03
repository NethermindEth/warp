function cairoCommonPath(path: string[]): string[] {
  return ['starkware', 'cairo', 'common', ...path];
}

export function allocImport(): [string[], string] {
  return [cairoCommonPath(['alloc']), 'alloc'];
}
export function bitwiseBuiltinImport(): [string[], string] {
  return [cairoCommonPath(['cairo_builtins']), 'BitwiseBuiltin'];
}
export function defaultDictFinalizeImport(): [string[], string] {
  return [cairoCommonPath(['default_dict']), 'default_dict_finalize'];
}
export function defaultDictNewImport(): [string[], string] {
  return [cairoCommonPath(['default_dict']), 'default_dict_new'];
}
export function dictAccessImport(): [string[], string] {
  return [cairoCommonPath(['dict_access']), 'DictAccess'];
}
export function dictReadImport(): [string[], string] {
  return [cairoCommonPath(['dict']), 'dict_read'];
}
export function dictWriteImport(): [string[], string] {
  return [cairoCommonPath(['dict']), 'dict_write'];
}
export function finalizeKeccakImport(): [string[], string] {
  return [cairoCommonPath(['cairo_keccak', 'keccak']), 'finalize_keccak'];
}
export function hashBuiltinImport(): [string[], string] {
  return [cairoCommonPath(['cairo_builtins']), 'HashBuiltin'];
}
export function isLeImport(): [string[], string] {
  return [cairoCommonPath(['math_cmp']), 'is_le'];
}
export function isLeFeltImport(): [string[], string] {
  return [cairoCommonPath(['math_cmp']), 'is_le_felt'];
}
export function splitFeltImport(): [string[], string] {
  return [cairoCommonPath(['math']), 'split_felt'];
}
export function uint256Import(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'Uint256'];
}
export function uint256AddImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_add'];
}
export function uint256EqImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_eq'];
}
export function uint256LeImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_le'];
}
export function uint256LtImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_lt'];
}
export function uint256MulImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_mul'];
}
export function uint256SubImport(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'uint256_sub'];
}

//------------------------------------------------------
function starkwareSyscallPath(): string[] {
  return ['starkware', 'starknet', 'common', 'syscalls'];
}

export function deployImport(): [string[], string] {
  return [starkwareSyscallPath(), 'deploy'];
}
export function emitEventImport(): [string[], string] {
  return [starkwareSyscallPath(), 'emit_event'];
}
export function getCallerAddressImport(): [string[], string] {
  return [starkwareSyscallPath(), 'get_caller_address'];
}

//------------------------------------------------------
function warplibPath(path: string[]): string[] {
  return ['warplib', ...path];
}
export function dynArraysUtilsPath(): string[] {
  return ['warplib', 'dynamic_arrays_util'];
}
export function bytesConversionsPath(): string[] {
  return ['warplib', 'maths', 'bytes_conversions'];
}
export function intConversionsPath(): string[] {
  return ['warplib', 'maths', 'int_conversions'];
}

export function byte256AtIndexImport(): [string[], string] {
  return [warplibPath(['maths', 'bytes_access']), 'byte256_at_index'];
}
export function byteArrayToFeltValueImport(): [string[], string] {
  return [dynArraysUtilsPath(), 'byte_array_to_felt_value'];
}
export function dynArrayLengthImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_dyn_array_length'];
}
export function feltArrayConcatImport(): [string[], string] {
  return [warplibPath(['keccak']), 'felt_array_concat'];
}
export function feltArrayToWarpMemoryArrayImport(): [string[], string] {
  return [dynArraysUtilsPath(), 'felt_array_to_warp_memory_array'];
}
export function feltToUint256Import(): [string[], string] {
  return [warplibPath(['maths', 'utils']), 'felt_to_uint256'];
}
export function fixedBytes256ToFeltDynamicArrayImport(): [string[], string] {
  return [dynArraysUtilsPath(), 'fixed_bytes256_to_felt_dynamic_array'];
}
export function fixedBytes256ToFeltDynamicArraySplImport(): [string[], string] {
  return [dynArraysUtilsPath(), 'fixed_bytes256_to_felt_dynamic_array_spl'];
}
export function indexDynImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_index_dyn'];
}
export function indexStaticImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_index_static'];
}
export function narrowSafeImport(): [string[], string] {
  return [warplibPath(['maths', 'utils']), 'narrow_safe'];
}
export function newImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_new'];
}
export function packBytesFeltImport(): [string[], string] {
  return [warplibPath(['keccak']), 'pack_bytes_felt'];
}
export function read256Import(): [string[], string] {
  return [warplibPath(['memory']), 'wm_read_256'];
}
export function readFeltImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_read_felt'];
}
export function readIdImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_read_id'];
}
export function stringHashImport(): [string[], string] {
  return [warplibPath(['string_hash']), 'string_hash'];
}
export function toFeltArrayImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_to_felt_array'];
}
export function warpAllocImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_alloc'];
}
export function warpKeccakImport(): [string[], string] {
  return [warplibPath(['keccak']), 'warp_keccak'];
}
export function warpUint256Import(): [string[], string] {
  return [intConversionsPath(), 'warp_uint256'];
}
export function write256Import(): [string[], string] {
  return [warplibPath(['memory']), 'wm_write_256'];
}
export function writeFeltImport(): [string[], string] {
  return [warplibPath(['memory']), 'wm_write_felt'];
}

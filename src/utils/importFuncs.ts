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

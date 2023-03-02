function cairoCommonPath(path: string[]): string[] {
  return ['starkware', 'cairo', 'common', ...path];
}

export function allocImport(): [string[], string] {
  return [cairoCommonPath(['alloc']), 'alloc'];
}
export function bitwiseBuiltinImport(): [string[], string] {
  return [cairoCommonPath(['cairo_builtins']), 'BitwiseBuiltin'];
}
export function uint256Import(): [string[], string] {
  return [cairoCommonPath(['uint256']), 'Uint256'];
}
export function isLeFeltImport(): [string[], string] {
  return [cairoCommonPath(['math_cmp']), 'is_le_felt'];
}

//------------------------------------------------------
export function starkwareSyscallPath(): string[] {
  return ['starkware', 'starknet', 'common', 'syscalls'];
}

export function emitEventImport(): [string[], string] {
  return [starkwareSyscallPath(), 'emit_event'];
}
export function deployImport(): [string[], string] {
  return [starkwareSyscallPath(), 'deploy'];
}
export function getCallerAddressImport(): [string[], string] {
  return [starkwareSyscallPath(), 'get_caller_address'];
}

import { ParameterList, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import { BITWISE_PTR, Implicits, RANGE_CHECK_PTR, WARP_MEMORY } from '../utils/implicits';
import { createParameterList } from './nodeTemplates';

function createImportFuncFuncDefinition(
  funcName: string,
  path: string,
  implicits: Set<Implicits>,
  params: ParameterList,
  retParams: ParameterList,
  ast: AST,
  node: SourceUnit,
): CairoImportFunctionDefinition {
  const id = ast.reserveId();
  const scope = ast.getContainingScope(node);
  var funcDef = new CairoImportFunctionDefinition(
    id,
    scope,
    funcName,
    path,
    false,
    implicits,
    params,
    retParams,
  );
  ast.setContextRecursive(funcDef);
  node.insertAtBeginning(funcDef);
  return funcDef;
}

function createImportStructFuncDefinition(
  structName: string,
  path: string,
  ast: AST,
  node: SourceUnit,
): CairoImportFunctionDefinition {
  const id = ast.reserveId();
  const scope = ast.getContainingScope(node);
  const implicits = new Set<Implicits>();
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);
  var funcDef = new CairoImportFunctionDefinition(
    id,
    scope,
    structName,
    path,
    true,
    implicits,
    params,
    retParams,
  );
  ast.setContextRecursive(funcDef);
  node.insertAtBeginning(funcDef);
  return funcDef;
}

export function createAllocImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'alloc';
  const path = 'starkware.cairo.common.alloc';
  const implicits = new Set<Implicits>();
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createBitwiseBuiltinImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const structName = 'BitwiseBuiltin';
  const path = 'starkware.cairo.common.cairo_builtins';

  return createImportStructFuncDefinition(structName, path, ast, node);
}

export function createUint256ImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const structName = 'Uint256';
  const path = 'starkware.cairo.common.uint256';

  return createImportStructFuncDefinition(structName, path, ast, node);
}

export function createFelt2Uint256ImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'felt_to_uint256';
  const path = 'warplib.maths.utils';
  const implicits = new Set<Implicits>([RANGE_CHECK_PTR]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createNarrowSafeImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'narrow_safe';
  const path = 'warplib.maths.utils';
  const implicits = new Set<Implicits>([RANGE_CHECK_PTR]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createFixedBytes256ToFeltDynArrayImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'fixed_bytes256_to_felt_dynamic_array';
  const path = 'warplib.dynamic_arrays_util';
  const implicits = new Set<Implicits>([BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createFixedBytesToFeltDynArrayImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'fixed_bytes_to_felt_dynamic_array';
  const path = 'warplib.dynamic_arrays_util';
  const implicits = new Set<Implicits>([BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createFeltArray2WarpMemoryArrayImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'felt_array_to_warp_memory_array';
  const path = 'warplib.dynamic_arrays_util';
  const implicits = new Set<Implicits>([RANGE_CHECK_PTR, WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createWMDynArrayLenghtImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'wm_dyn_array_length';
  const path = 'warplib.memory';
  const implicits = new Set<Implicits>([WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createWMIndexDynImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'wm_index_dyn';
  const path = 'warplib.memory';
  const implicits = new Set<Implicits>([RANGE_CHECK_PTR, WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

export function createWMNewImportFuncDef(
  node: SourceUnit,
  ast: AST,
): CairoImportFunctionDefinition {
  const funcName = 'wm_new';
  const path = 'warplib.memory';
  const implicits = new Set<Implicits>([RANGE_CHECK_PTR, WARP_MEMORY]);
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);

  return createImportFuncFuncDefinition(funcName, path, implicits, params, retParams, ast, node);
}

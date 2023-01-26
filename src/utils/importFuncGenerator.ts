import { ParameterList, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import {
  BITWISE_PTR,
  DICT_PTR,
  Implicits,
  KECCAK_PTR,
  RANGE_CHECK_PTR,
  WARP_MEMORY,
} from '../utils/implicits';
import { createParameterList } from './nodeTemplates';
import assert from 'assert';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/getWarplibImports';

// Paths
const STARKWARE_CAIRO_COMMON_ALLOC = 'starkware.cairo.common.alloc';
const STARKWARE_CAIRO_COMMON_BUILTINS = 'starkware.cairo.common.cairo_builtins';
const STARKWARE_CAIRO_COMMON_DEFAULT_DICT = 'starkware.cairo.common.default_dict';
const STARKWARE_CAIRO_COMMON_DICT = 'starkware.cairo.common.dict';
const STARKWARE_CAIRO_COMMON_DICT_ACCESS = 'starkware.cairo.common.dict_access';
const STARKWARE_CAIRO_COMMON_UINT256 = 'starkware.cairo.common.uint256';
const WARPLIB_MATHS_BYTES_ACCESS = 'warplib.maths.bytes_access';
const WARPLIB_MATHS_EXTERNAL_INPUT_CHECKS_INTS = 'warplib.maths.external_input_check_ints';
const WARPLIB_MATHS_INT_CONVERSIONS = 'warplib.maths.int_conversions';
const WARPLIB_MATHS_UTILS = 'warplib.maths.utils';
const WARPLIB_DYNAMIC_ARRAYS_UTIL = 'warplib.dynamic_arrays_util';
const WARPLIB_MEMORY = 'warplib.memory';
const WARPLIB_KECCAK = 'warplib.keccak';

export function createImportFuncDefinition(path: string, name: string, node: SourceUnit, ast: AST) {
  const existingImport = findExistingImport(name, node);
  if (existingImport !== undefined) {
    return existingImport;
  }

  const createFuncImport = (...implicits: Implicits[]) =>
    createImportFuncFuncDefinition(
      name,
      path,
      new Set(implicits),
      createParameterList([], ast),
      createParameterList([], ast),
      ast,
      node,
    );

  const createStructImport = () => createImportStructFuncDefinition(name, path, ast, node);

  switch (path + name) {
    case STARKWARE_CAIRO_COMMON_ALLOC + 'alloc':
      return createFuncImport();
    case STARKWARE_CAIRO_COMMON_BUILTINS + 'BitwiseBuiltin':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_BUILTINS + 'HashBuiltin':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_DEFAULT_DICT + 'default_dict_new':
      return createFuncImport();
    case STARKWARE_CAIRO_COMMON_DEFAULT_DICT + 'default_dict_finalize':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_DICT_ACCESS + 'DictAccess':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_DICT + 'dict_write':
      return createFuncImport(DICT_PTR);
    case STARKWARE_CAIRO_COMMON_DICT_ACCESS + 'DictAccess':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_UINT256 + 'Uint256':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_add':
      return createFuncImport(RANGE_CHECK_PTR);
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_sub':
      return createFuncImport(RANGE_CHECK_PTR);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'byte_array_to_felt_value':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'byte_array_to_uint256_value':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array_spl':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array_spl_without_padding':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes256_to_felt_dynamic_array':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes256_to_felt_dynamic_array_spl':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes_to_felt_dynamic_array':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'felt_array_to_warp_memory_array':
      return createFuncImport(RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'memory_dyn_array_copy':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_MATHS_BYTES_ACCESS + 'byte256_at_index':
      return createFuncImport(BITWISE_PTR, RANGE_CHECK_PTR);
    case WARPLIB_MATHS_EXTERNAL_INPUT_CHECKS_INTS + 'warp_external_input_check':
      return createFuncImport(RANGE_CHECK_PTR);
    case WARPLIB_MATHS_INT_CONVERSIONS + 'warp_uint256':
      return createFuncImport(RANGE_CHECK_PTR);
    case WARPLIB_MATHS_UTILS + 'felt_to_uint256':
      return createFuncImport(RANGE_CHECK_PTR);
    case WARPLIB_MATHS_UTILS + 'narrow_safe':
      return createFuncImport(RANGE_CHECK_PTR);
    case WARPLIB_MEMORY + 'wm_alloc':
      return createFuncImport(RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_MEMORY + 'wm_dyn_array_length':
      return createFuncImport(WARP_MEMORY);
    case WARPLIB_MEMORY + 'wm_index_dyn':
      return createFuncImport(RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_MEMORY + 'wm_new':
      return createFuncImport(RANGE_CHECK_PTR, WARP_MEMORY);
    case WARPLIB_MEMORY + 'wm_read_256':
      return createFuncImport(WARP_MEMORY);
    case WARPLIB_MEMORY + 'wm_read_felt':
      return createFuncImport(WARP_MEMORY);
    case WARPLIB_KECCAK + 'warp_keccak':
      return createFuncImport(RANGE_CHECK_PTR, BITWISE_PTR, WARP_MEMORY, KECCAK_PTR);
    default:
      const warplibFunc = warplibImportInfo.get(path)?.get(name);
      if (warplibFunc === undefined) {
        assert(false, `cannot import ${name} from ${path}`);
        throw new TranspileFailedError(`Import ${name} from ${path} is not defined.`);
      }
      return createFuncImport(...warplibFunc);
  }
}

function findExistingImport(name: string, node: SourceUnit) {
  const found = node.getChildrenBySelector(
    (n) => n instanceof CairoImportFunctionDefinition && n.name === name,
  );
  assert(found.length < 2, `More than 1 import functions where found with name: ${name}.`);

  return found.length === 1 ? (found[0] as CairoImportFunctionDefinition) : undefined;
}

function processAutoGeneratedImportNames(name: string) {}

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
  const scope = node.id;
  var funcDef = new CairoImportFunctionDefinition(
    id,
    '',
    scope,
    funcName,
    path,
    implicits,
    params,
    retParams,
    false,
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
  const scope = node.id;
  const implicits = new Set<Implicits>();
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);
  var funcDef = new CairoImportFunctionDefinition(
    id,
    '',
    scope,
    structName,
    path,
    implicits,
    params,
    retParams,
    true,
  );
  ast.setContextRecursive(funcDef);
  node.insertAtBeginning(funcDef);
  return funcDef;
}

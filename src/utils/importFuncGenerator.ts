import { ASTNode, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import assert from 'assert';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/getWarplibImports';
import { Implicits } from './implicits';
import {
  createImportFuncFuncDefinition,
  createImportStructFuncDefinition,
  ParameterInfo,
} from './functionGeneration';
import { getContainingSourceUnit } from './utils';

// Paths
const STARKWARE_CAIRO_COMMON_ALLOC = 'starkware.cairo.common.alloc';
const STARKWARE_CAIRO_COMMON_BUILTINS = 'starkware.cairo.common.cairo_builtins';
const STARKWARE_CAIRO_COMMON_DEFAULT_DICT = 'starkware.cairo.common.default_dict';
const STARKWARE_CAIRO_COMMON_DICT = 'starkware.cairo.common.dict';
const STARKWARE_CAIRO_COMMON_DICT_ACCESS = 'starkware.cairo.common.dict_access';
const STARKWARE_CAIRO_COMMON_UINT256 = 'starkware.cairo.common.uint256';
const STARKWARE_STARKNET_COMMON_SYSCALLS = 'starkware.cairo.common.uint256';
const WARPLIB_MATHS_BYTES_ACCESS = 'warplib.maths.bytes_access';
const WARPLIB_MATHS_EXTERNAL_INPUT_CHECKS_INTS = 'warplib.maths.external_input_check_ints';
const WARPLIB_MATHS_INT_CONVERSIONS = 'warplib.maths.int_conversions';
const WARPLIB_MATHS_UTILS = 'warplib.maths.utils';
const WARPLIB_DYNAMIC_ARRAYS_UTIL = 'warplib.dynamic_arrays_util';
const WARPLIB_MEMORY = 'warplib.memory';
const WARPLIB_KECCAK = 'warplib.keccak';

export function createImportFuncDefinition(
  path: string,
  name: string,
  nodeInSourceUnit: ASTNode,
  ast: AST,
  inputs?: ParameterInfo[],
  outputs?: ParameterInfo[],
) {
  const sourceUnit = getContainingSourceUnit(nodeInSourceUnit);

  const noInfoInputs = inputs === undefined || inputs.length === 0;
  const noInfoOutputs = outputs === undefined || outputs.length === 0;

  const existingImport = findExistingImport(name, sourceUnit);
  // The last two checks are some kind of patch
  if (existingImport !== undefined && noInfoInputs && noInfoOutputs) {
    return existingImport;
  }

  const createFuncImport = (...implicits: Implicits[]) =>
    createImportFuncFuncDefinition(
      name,
      path,
      new Set(implicits),
      inputs ?? [],
      outputs ?? [],
      ast,
      sourceUnit,
    );
  const createStructImport = () => createImportStructFuncDefinition(name, path, ast, sourceUnit);

  const warplibFunc = warplibImportInfo.get(path)?.get(name);
  if (warplibFunc !== undefined) {
    return createFuncImport(...warplibFunc);
  }

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
    case STARKWARE_CAIRO_COMMON_DICT + 'dict_write':
      return createFuncImport('dict_ptr');
    case STARKWARE_CAIRO_COMMON_DICT_ACCESS + 'DictAccess':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_UINT256 + 'Uint256':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_add':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_sub':
      return createFuncImport('range_check_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'get_caller_address':
      return createFuncImport('syscall_ptr');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'byte_array_to_felt_value':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'byte_array_to_uint256_value':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array_spl':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'bytes_to_felt_dynamic_array_spl_without_padding':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes256_to_felt_dynamic_array':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes256_to_felt_dynamic_array_spl':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'fixed_bytes_to_felt_dynamic_array':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'felt_array_to_warp_memory_array':
      return createFuncImport('range_check_ptr', 'warp_memory');
    case WARPLIB_DYNAMIC_ARRAYS_UTIL + 'memory_dyn_array_copy':
      return createFuncImport('bitwise_ptr', 'range_check_ptr', 'warp_memory');
    case WARPLIB_MATHS_BYTES_ACCESS + 'byte256_at_index':
      return createFuncImport('bitwise_ptr', 'range_check_ptr');
    case WARPLIB_MATHS_EXTERNAL_INPUT_CHECKS_INTS + 'warp_external_input_check':
      return createFuncImport('range_check_ptr');
    case WARPLIB_MATHS_INT_CONVERSIONS + 'warp_uint256':
      return createFuncImport('range_check_ptr');
    case WARPLIB_MATHS_UTILS + 'felt_to_uint256':
      return createFuncImport('range_check_ptr');
    case WARPLIB_MATHS_UTILS + 'narrow_safe':
      return createFuncImport('range_check_ptr');
    case WARPLIB_MEMORY + 'wm_alloc':
      return createFuncImport('range_check_ptr', 'warp_memory');
    case WARPLIB_MEMORY + 'wm_dyn_array_length':
      return createFuncImport('warp_memory');
    case WARPLIB_MEMORY + 'wm_index_dyn':
      return createFuncImport('range_check_ptr', 'warp_memory');
    case WARPLIB_MEMORY + 'wm_new':
      return createFuncImport('range_check_ptr', 'warp_memory');
    case WARPLIB_MEMORY + 'wm_read_256':
      return createFuncImport('warp_memory');
    case WARPLIB_MEMORY + 'wm_read_felt':
      return createFuncImport('warp_memory');
    case WARPLIB_MEMORY + 'wm_write_256':
      return createFuncImport('warp_memory');
    case WARPLIB_MEMORY + 'wm_write_felt':
      return createFuncImport('warp_memory');
    case WARPLIB_KECCAK + 'warp_keccak':
      return createFuncImport('range_check_ptr', 'bitwise_ptr', 'warp_memory', 'keccak_ptr');
    default:
      assert(false, `Import ${name} from ${path} is not defined.`);
      throw new TranspileFailedError(`Import ${name} from ${path} is not defined.`);
  }
}

function findExistingImport(name: string, node: SourceUnit) {
  const found = node.vFunctions.filter(
    (n) => n instanceof CairoImportFunctionDefinition && n.name === name,
  );

  assert(found.length < 2, `More than 1 import functions where found with name: ${name}.`);

  if (found[0] !== undefined) {
    assert(found[0] instanceof CairoImportFunctionDefinition);
    return found[0];
  }
  return undefined;
}

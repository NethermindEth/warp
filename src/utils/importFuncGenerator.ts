import { ASTNode, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import assert from 'assert';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/gatherWarplibImports';
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
const STARKWARE_CAIRO_COMMON_MATH = 'starkware.cairo.common.math';
const STARKWARE_CAIRO_COMMON_UINT256 = 'starkware.cairo.common.uint256';
const STARKWARE_STARKNET_COMMON_SYSCALLS = 'starkware.starknet.common.syscalls';

export function createImportFuncDefinition(
  path: string,
  name: string,
  nodeInSourceUnit: ASTNode,
  ast: AST,
  inputs?: ParameterInfo[],
  outputs?: ParameterInfo[],
  options?: { acceptsRawDarray?: boolean; acceptsUnpackedStructArray?: boolean },
) {
  const sourceUnit = getContainingSourceUnit(nodeInSourceUnit);

  const hasInputs = inputs !== undefined && inputs.length > 0;
  const hasOutputs = outputs !== undefined && outputs.length > 0;

  const existingImport = findExistingImport(name, sourceUnit);
  // PATCH PATCH PATCH
  if (existingImport !== undefined) {
    if (
      existingImport.vParameters.vParameters.length > 0 ||
      existingImport.vReturnParameters.vParameters.length > 0
    )
      return existingImport;
    if (!hasInputs || !hasOutputs) return existingImport;

    sourceUnit.removeChild(existingImport);
    return createImportFuncFuncDefinition(
      name,
      path,
      existingImport.implicits,
      inputs,
      outputs,
      ast,
      sourceUnit,
      options,
    );
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
    case STARKWARE_CAIRO_COMMON_DICT + 'dict_read':
      return createFuncImport('dict_ptr');
    case STARKWARE_CAIRO_COMMON_DICT + 'dict_write':
      return createFuncImport('dict_ptr');
    case STARKWARE_CAIRO_COMMON_DICT_ACCESS + 'DictAccess':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_MATH + 'split_felt':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'Uint256':
      return createStructImport();
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_add':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_eq':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_le':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_lt':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_mul':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_UINT256 + 'uint256_sub':
      return createFuncImport('range_check_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'deploy':
      return createFuncImport('syscall_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'get_caller_address':
      return createFuncImport('syscall_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'get_contract_address':
      return createFuncImport('syscall_ptr');
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

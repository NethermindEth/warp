import { ASTNode, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/gatherWarplibImports';
import { Implicits } from './implicits';
import {
  createCairoImportFunctionDefintion,
  createCairoImportStructDefinition,
  ParameterInfo,
} from './functionGeneration';
import { getContainingSourceUnit } from './utils';

// Paths
const STARKWARE_CAIRO_COMMON_ALLOC = 'starkware.cairo.common.alloc';
const STARKWARE_CAIRO_COMMON_BUILTINS = 'starkware.cairo.common.cairo_builtins';
const STARKWARE_CAIRO_COMMON_CAIRO_KECCAK = 'starkware.cairo.common.cairo_keccak.keccak';
const STARKWARE_CAIRO_COMMON_DEFAULT_DICT = 'starkware.cairo.common.default_dict';
const STARKWARE_CAIRO_COMMON_DICT = 'starkware.cairo.common.dict';
const STARKWARE_CAIRO_COMMON_DICT_ACCESS = 'starkware.cairo.common.dict_access';
const STARKWARE_CAIRO_COMMON_MATH = 'starkware.cairo.common.math';
const STARKWARE_CAIRO_COMMON_MATH_CMP = 'starkware.cairo.common.math_cmp';
const STARKWARE_CAIRO_COMMON_UINT256 = 'starkware.cairo.common.uint256';
const STARKWARE_STARKNET_COMMON_SYSCALLS = 'starkware.starknet.common.syscalls';

export function createImport(
  path: string[],
  name: string,
  nodeInSourceUnit: ASTNode,
  ast: AST,
  inputs?: ParameterInfo[],
  outputs?: ParameterInfo[],
  options?: { acceptsRawDarray?: boolean; acceptsUnpackedStructArray?: boolean },
) {
  const sourceUnit = getContainingSourceUnit(nodeInSourceUnit);

  const existingImport = findExistingImport(name, sourceUnit);
  if (existingImport !== undefined) {
    const hasInputs = inputs !== undefined && inputs.length > 0;
    const hasOutputs = outputs !== undefined && outputs.length > 0;
    if (!hasInputs || !hasOutputs) return existingImport;
    return createCairoImportFunctionDefintion(
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
    createCairoImportFunctionDefintion(
      name,
      path,
      new Set(implicits),
      inputs ?? [],
      outputs ?? [],
      ast,
      sourceUnit,
      options,
    );
  const createStructImport = () => createCairoImportStructDefinition(name, path, ast, sourceUnit);

  const warplibFunc = warplibImportInfo.get(path.join('.'))?.get(name);
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
    case STARKWARE_CAIRO_COMMON_CAIRO_KECCAK + 'finalize_keccak':
      return createFuncImport('range_check_ptr', 'bitwise_ptr');
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
    case STARKWARE_CAIRO_COMMON_MATH_CMP + 'is_le':
      return createFuncImport('range_check_ptr');
    case STARKWARE_CAIRO_COMMON_MATH_CMP + 'is_le_felt':
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
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'emit_event':
      return createFuncImport('syscall_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'get_caller_address':
      return createFuncImport('syscall_ptr');
    case STARKWARE_STARKNET_COMMON_SYSCALLS + 'get_contract_address':
      return createFuncImport('syscall_ptr');
    default:
      throw new TranspileFailedError(`Import ${name} from ${path} is not defined.`);
  }
}

function findExistingImport(
  name: string,
  node: SourceUnit,
): CairoImportFunctionDefinition | undefined {
  const found = node.vFunctions.filter(
    (n): n is CairoImportFunctionDefinition =>
      n instanceof CairoImportFunctionDefinition && n.name === name,
  );
  return found[0];
}

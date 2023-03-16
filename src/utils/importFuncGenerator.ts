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
import {
  ALLOC,
  BITWISE_BUILTIN,
  DEFAULT_DICT_FINALIZE,
  DEFAULT_DICT_NEW,
  DEPLOY,
  DICT_ACCESS,
  DICT_READ,
  DICT_WRITE,
  EMIT_EVENT,
  FINALIZE_KECCAK,
  GET_CALLER_ADDRESS,
  GET_CONTRACT_ADDRESS,
  HASH_BUILTIN,
  IS_LE,
  IS_LE_FELT,
  SPLIT_FELT,
  U256_FROM_FELTS,
  UINT256,
  UINT256_ADD,
  UINT256_EQ,
  UINT256_LE,
  UINT256_LT,
  UINT256_MUL,
  UINT256_SUB,
} from './importPaths';

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

  const warplibFunc = warplibImportInfo.get(encodePath(path))?.get(name);
  if (warplibFunc !== undefined) {
    return createFuncImport(...warplibFunc);
  }

  switch (encodePath([path, name])) {
    case encodePath(ALLOC):
      return createFuncImport();
    case encodePath(BITWISE_BUILTIN):
      return createStructImport();
    case encodePath(HASH_BUILTIN):
      return createStructImport();
    case encodePath(FINALIZE_KECCAK):
      return createFuncImport('range_check_ptr', 'bitwise_ptr');
    case encodePath(DEFAULT_DICT_NEW):
      return createFuncImport();
    case encodePath(DEFAULT_DICT_FINALIZE):
      return createFuncImport('range_check_ptr');
    case encodePath(DICT_READ):
    case encodePath(DICT_WRITE):
      return createFuncImport('dict_ptr');
    case encodePath(DICT_ACCESS):
      return createStructImport();
    case encodePath(UINT256):
      return createStructImport();
    case encodePath(SPLIT_FELT):
    case encodePath(IS_LE):
    case encodePath(IS_LE_FELT):
    case encodePath(UINT256_ADD):
    case encodePath(UINT256_EQ):
    case encodePath(UINT256_LE):
    case encodePath(UINT256_LT):
    case encodePath(UINT256_MUL):
    case encodePath(UINT256_SUB):
      return createFuncImport('range_check_ptr');
    case encodePath(DEPLOY):
    case encodePath(EMIT_EVENT):
    case encodePath(GET_CALLER_ADDRESS):
    case encodePath(GET_CONTRACT_ADDRESS):
      return createFuncImport('syscall_ptr');
    // Import libraries from Cairo1
    case encodePath(U256_FROM_FELTS):
      return createFuncImport();
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

function encodePath(path: (string | string[])[]): string {
  return path.flat().join('.');
}

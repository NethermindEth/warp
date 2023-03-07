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

  const warplibFunc = warplibImportInfo.get(path.join('.'))?.get(name);
  if (warplibFunc !== undefined) {
    return createFuncImport(...warplibFunc);
  }

  switch ([path, name]) {
    case ALLOC:
      return createFuncImport();
    case BITWISE_BUILTIN:
      return createStructImport();
    case HASH_BUILTIN:
      return createStructImport();
    case FINALIZE_KECCAK:
      return createFuncImport('range_check_ptr', 'bitwise_ptr');
    case DEFAULT_DICT_NEW:
      return createFuncImport();
    case DEFAULT_DICT_FINALIZE:
      return createFuncImport('range_check_ptr');
    case DICT_READ:
    case DICT_WRITE:
      return createFuncImport('dict_ptr');
    case DICT_ACCESS:
      return createStructImport();
    case UINT256:
      return createStructImport();
    case SPLIT_FELT:
    case IS_LE:
    case IS_LE_FELT:
    case UINT256_ADD:
    case UINT256_EQ:
    case UINT256_LE:
    case UINT256_LT:
    case UINT256_MUL:
    case UINT256_SUB:
      return createFuncImport('range_check_ptr');
    case DEPLOY:
    case EMIT_EVENT:
    case GET_CALLER_ADDRESS:
    case GET_CONTRACT_ADDRESS:
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

import { ASTNode, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/gatherWarplibImports';
import { Implicits } from './implicits';
import {
  createCairoImportFunctionDefinition,
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
  IS_LE,
  IS_LE_FELT,
  SPLIT_FELT,
  U8_TO_FELT,
  U16_TO_FELT,
  U24_TO_FELT,
  U32_TO_FELT,
  U40_TO_FELT,
  U48_TO_FELT,
  U56_TO_FELT,
  U64_TO_FELT,
  U72_TO_FELT,
  U80_TO_FELT,
  U88_TO_FELT,
  U96_TO_FELT,
  U104_TO_FELT,
  U112_TO_FELT,
  U120_TO_FELT,
  U128_TO_FELT,
  U136_TO_FELT,
  U144_TO_FELT,
  U152_TO_FELT,
  U160_TO_FELT,
  U168_TO_FELT,
  U176_TO_FELT,
  U184_TO_FELT,
  U192_TO_FELT,
  U200_TO_FELT,
  U208_TO_FELT,
  U216_TO_FELT,
  U224_TO_FELT,
  U232_TO_FELT,
  U240_TO_FELT,
  U248_TO_FELT,
  U256_FROM_FELTS,
  U8_FROM_FELT,
  U16_FROM_FELT,
  U24_FROM_FELT,
  U32_FROM_FELT,
  U40_FROM_FELT,
  U48_FROM_FELT,
  U56_FROM_FELT,
  U64_FROM_FELT,
  U72_FROM_FELT,
  U80_FROM_FELT,
  U88_FROM_FELT,
  U96_FROM_FELT,
  U104_FROM_FELT,
  U112_FROM_FELT,
  U120_FROM_FELT,
  U128_FROM_FELT,
  U136_FROM_FELT,
  U144_FROM_FELT,
  U152_FROM_FELT,
  U160_FROM_FELT,
  U168_FROM_FELT,
  U176_FROM_FELT,
  U184_FROM_FELT,
  U192_FROM_FELT,
  U200_FROM_FELT,
  U208_FROM_FELT,
  U216_FROM_FELT,
  U224_FROM_FELT,
  U232_FROM_FELT,
  U240_FROM_FELT,
  U248_FROM_FELT,
  UINT256_ADD,
  UINT256_EQ,
  UINT256_LE,
  UINT256_LT,
  UINT256_MUL,
  UINT256_SUB,
  INTO,
  ARRAY,
  ARRAY_TRAIT,
  WARP_MEMORY,
  MEMORY_TRAIT,
  CONTRACT_ADDRESS,
  CONTRACT_ADDRESS_FROM_FELT,
} from './importPaths';

export function createImport(
  path: string[],
  name: string,
  nodeInSourceUnit: ASTNode,
  ast: AST,
  inputs?: ParameterInfo[],
  outputs?: ParameterInfo[],
  options?: { acceptsRawDarray?: boolean; acceptsUnpackedStructArray?: boolean; isTrait?: boolean },
) {
  const sourceUnit = getContainingSourceUnit(nodeInSourceUnit);

  const existingImport = findExistingImport(name, sourceUnit);
  if (existingImport !== undefined) {
    const hasInputs = inputs !== undefined && inputs.length > 0;
    const hasOutputs = outputs !== undefined && outputs.length > 0;
    if (!hasInputs || !hasOutputs) return existingImport;
    return createCairoImportFunctionDefinition(
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
    createCairoImportFunctionDefinition(
      name,
      path,
      new Set(implicits),
      inputs ?? [],
      outputs ?? [],
      ast,
      sourceUnit,
      options,
    );
  const createStructImport = () =>
    createCairoImportStructDefinition(name, path, ast, sourceUnit, {
      stubKind: options?.isTrait
        ? FunctionStubKind.TraitStructDefStub
        : FunctionStubKind.StructDefStub,
    });

  const warplibFunc = warplibImportInfo.get(encodePath(path))?.get(name);
  if (warplibFunc !== undefined) {
    return createFuncImport(...warplibFunc);
  }

  if (options?.isTrait) {
    return createStructImport();
  }

  switch (encodePath([path, name])) {
    case encodePath(ALLOC):
      return createFuncImport();
    case encodePath(BITWISE_BUILTIN):
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
    case encodePath(U8_FROM_FELT):
    case encodePath(U16_FROM_FELT):
    case encodePath(U24_FROM_FELT):
    case encodePath(U32_FROM_FELT):
    case encodePath(U40_FROM_FELT):
    case encodePath(U48_FROM_FELT):
    case encodePath(U56_FROM_FELT):
    case encodePath(U64_FROM_FELT):
    case encodePath(U72_FROM_FELT):
    case encodePath(U80_FROM_FELT):
    case encodePath(U88_FROM_FELT):
    case encodePath(U96_FROM_FELT):
    case encodePath(U104_FROM_FELT):
    case encodePath(U112_FROM_FELT):
    case encodePath(U120_FROM_FELT):
    case encodePath(U128_FROM_FELT):
    case encodePath(U136_FROM_FELT):
    case encodePath(U144_FROM_FELT):
    case encodePath(U152_FROM_FELT):
    case encodePath(U160_FROM_FELT):
    case encodePath(U168_FROM_FELT):
    case encodePath(U176_FROM_FELT):
    case encodePath(U184_FROM_FELT):
    case encodePath(U192_FROM_FELT):
    case encodePath(U200_FROM_FELT):
    case encodePath(U208_FROM_FELT):
    case encodePath(U216_FROM_FELT):
    case encodePath(U224_FROM_FELT):
    case encodePath(U232_FROM_FELT):
    case encodePath(U240_FROM_FELT):
    case encodePath(U248_FROM_FELT):
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
    case encodePath(INTO):
    case encodePath(CONTRACT_ADDRESS):
    case encodePath(CONTRACT_ADDRESS_FROM_FELT):
    case encodePath(U8_TO_FELT):
    case encodePath(U16_TO_FELT):
    case encodePath(U24_TO_FELT):
    case encodePath(U32_TO_FELT):
    case encodePath(U40_TO_FELT):
    case encodePath(U48_TO_FELT):
    case encodePath(U56_TO_FELT):
    case encodePath(U64_TO_FELT):
    case encodePath(U72_TO_FELT):
    case encodePath(U80_TO_FELT):
    case encodePath(U88_TO_FELT):
    case encodePath(U96_TO_FELT):
    case encodePath(U104_TO_FELT):
    case encodePath(U112_TO_FELT):
    case encodePath(U120_TO_FELT):
    case encodePath(U128_TO_FELT):
    case encodePath(U136_TO_FELT):
    case encodePath(U144_TO_FELT):
    case encodePath(U152_TO_FELT):
    case encodePath(U160_TO_FELT):
    case encodePath(U168_TO_FELT):
    case encodePath(U176_TO_FELT):
    case encodePath(U184_TO_FELT):
    case encodePath(U192_TO_FELT):
    case encodePath(U200_TO_FELT):
    case encodePath(U208_TO_FELT):
    case encodePath(U216_TO_FELT):
    case encodePath(U224_TO_FELT):
    case encodePath(U232_TO_FELT):
    case encodePath(U240_TO_FELT):
    case encodePath(U248_TO_FELT):
    case encodePath(U256_FROM_FELTS):
    case encodePath(ARRAY):
    case encodePath(ARRAY_TRAIT):
    case encodePath(WARP_MEMORY):
    case encodePath(MEMORY_TRAIT):
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

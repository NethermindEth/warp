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
  ADDRESS_INTO_FELT,
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
  GET_U8,
  GET_U16,
  GET_U24,
  GET_U32,
  GET_U40,
  GET_U48,
  GET_U56,
  GET_U64,
  GET_U72,
  GET_U80,
  GET_U88,
  GET_U96,
  GET_U104,
  GET_U112,
  GET_U120,
  GET_U128,
  GET_U136,
  GET_U144,
  GET_U152,
  GET_U160,
  GET_U168,
  GET_U176,
  GET_U184,
  GET_U192,
  GET_U200,
  GET_U208,
  GET_U216,
  GET_U224,
  GET_U232,
  GET_U240,
  GET_U248,
  UINT256_ADD,
  UINT256_EQ,
  UINT256_LE,
  UINT256_LT,
  UINT256_MUL,
  UINT256_SUB,
  INTO,
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
    case encodePath(GET_U8):
    case encodePath(GET_U16):
    case encodePath(GET_U24):
    case encodePath(GET_U32):
    case encodePath(GET_U40):
    case encodePath(GET_U48):
    case encodePath(GET_U56):
    case encodePath(GET_U64):
    case encodePath(GET_U72):
    case encodePath(GET_U80):
    case encodePath(GET_U88):
    case encodePath(GET_U96):
    case encodePath(GET_U104):
    case encodePath(GET_U112):
    case encodePath(GET_U120):
    case encodePath(GET_U128):
    case encodePath(GET_U136):
    case encodePath(GET_U144):
    case encodePath(GET_U152):
    case encodePath(GET_U160):
    case encodePath(GET_U168):
    case encodePath(GET_U176):
    case encodePath(GET_U184):
    case encodePath(GET_U192):
    case encodePath(GET_U200):
    case encodePath(GET_U208):
    case encodePath(GET_U216):
    case encodePath(GET_U224):
    case encodePath(GET_U232):
    case encodePath(GET_U240):
    case encodePath(GET_U248):
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
    case encodePath(ADDRESS_INTO_FELT):
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

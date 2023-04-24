import { ASTNode, SourceUnit } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { AST } from '../ast/ast';
import { TranspileFailedError } from '../utils/errors';
import { warplibImportInfo } from '../warplib/gatherWarplibImports';
import { Implicits } from './utils';
import {
  createCairoImportFunctionDefinition,
  createCairoImportStructDefinition,
  ParameterInfo,
} from './functionGeneration';
import { getContainingSourceUnit } from './utils';
import * as Paths from './importPaths';

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
  const createStructImport = () => createCairoImportStructDefinition(name, path, ast, sourceUnit);

  const warplibFunc = warplibImportInfo.get(encodePath(path))?.get(name);
  if (warplibFunc !== undefined) {
    return createFuncImport(...warplibFunc);
  }

  const pathForStructImport = [
    Paths.U8_FROM_FELT,
    Paths.U16_FROM_FELT,
    Paths.U24_FROM_FELT,
    Paths.U32_FROM_FELT,
    Paths.U40_FROM_FELT,
    Paths.U48_FROM_FELT,
    Paths.U56_FROM_FELT,
    Paths.U64_FROM_FELT,
    Paths.U72_FROM_FELT,
    Paths.U80_FROM_FELT,
    Paths.U88_FROM_FELT,
    Paths.U96_FROM_FELT,
    Paths.U104_FROM_FELT,
    Paths.U112_FROM_FELT,
    Paths.U120_FROM_FELT,
    Paths.U128_FROM_FELT,
    Paths.U136_FROM_FELT,
    Paths.U144_FROM_FELT,
    Paths.U152_FROM_FELT,
    Paths.U160_FROM_FELT,
    Paths.U168_FROM_FELT,
    Paths.U176_FROM_FELT,
    Paths.U184_FROM_FELT,
    Paths.U192_FROM_FELT,
    Paths.U200_FROM_FELT,
    Paths.U208_FROM_FELT,
    Paths.U216_FROM_FELT,
    Paths.U224_FROM_FELT,
    Paths.U232_FROM_FELT,
    Paths.U240_FROM_FELT,
    Paths.U248_FROM_FELT,
  ];
  if (pathForStructImport.some((i) => encodePath([path, name]) === encodePath(i))) {
    return createStructImport();
  }

  const pathsForFunctionImport = [
    Paths.DEPLOY,
    Paths.EMIT_EVENT,
    Paths.GET_CALLER_ADDRESS,
    Paths.GET_CONTRACT_ADDRESS,
    Paths.INTO,
    Paths.CONTRACT_ADDRESS,
    Paths.U8_TO_FELT,
    Paths.U16_TO_FELT,
    Paths.U24_TO_FELT,
    Paths.U32_TO_FELT,
    Paths.U40_TO_FELT,
    Paths.U48_TO_FELT,
    Paths.U56_TO_FELT,
    Paths.U64_TO_FELT,
    Paths.U72_TO_FELT,
    Paths.U80_TO_FELT,
    Paths.U88_TO_FELT,
    Paths.U96_TO_FELT,
    Paths.U104_TO_FELT,
    Paths.U112_TO_FELT,
    Paths.U120_TO_FELT,
    Paths.U128_TO_FELT,
    Paths.U136_TO_FELT,
    Paths.U144_TO_FELT,
    Paths.U152_TO_FELT,
    Paths.U160_TO_FELT,
    Paths.U168_TO_FELT,
    Paths.U176_TO_FELT,
    Paths.U184_TO_FELT,
    Paths.U192_TO_FELT,
    Paths.U200_TO_FELT,
    Paths.U208_TO_FELT,
    Paths.U216_TO_FELT,
    Paths.U224_TO_FELT,
    Paths.U232_TO_FELT,
    Paths.U240_TO_FELT,
    Paths.U248_TO_FELT,
    Paths.U256_FROM_FELTS,
    Paths.ARRAY,
    Paths.ARRAY_TRAIT,
    Paths.WARP_MEMORY,
    Paths.MEMORY_TRAIT,
  ];
  if (pathsForFunctionImport.some((i) => encodePath([path, name]) === encodePath(i))) {
    return createFuncImport();
  }

  throw new TranspileFailedError(`Import ${name} from ${path} is not defined.`);
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

export function encodePath(path: (string | string[])[]): string {
  return path.flat().join('/');
}

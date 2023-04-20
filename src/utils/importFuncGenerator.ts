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
import {
  U128_TO_FELT,
  U256_FROM_FELTS,
  U128_FROM_FELT,
  INTO,
  ARRAY,
  ARRAY_TRAIT,
  U32_FROM_FELT,
  U32_TO_FELT,
  GET_CALLER_ADDRESS,
  GET_CONTRACT_ADDRESS,
  CONTRACT_ADDRESS,
  MEMORY_TRAIT,
  WARP_MEMORY,
  U8_TO_FELT,
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
  if (encodePath([path, name]) === encodePath(U128_FROM_FELT)) {
    return createStructImport();
  }
  if (
    [
      encodePath(GET_CALLER_ADDRESS),
      encodePath(GET_CONTRACT_ADDRESS),
      encodePath(CONTRACT_ADDRESS),
      encodePath(INTO), // Import libraries from Cairo1
      encodePath(U8_TO_FELT),
      encodePath(U128_TO_FELT),
      encodePath(U256_FROM_FELTS),
      encodePath(ARRAY),
      encodePath(ARRAY_TRAIT),
      encodePath(U32_FROM_FELT),
      encodePath(U32_TO_FELT),
      encodePath(WARP_MEMORY),
      encodePath(MEMORY_TRAIT),
    ].includes(encodePath([path, name]))
  ) {
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

function encodePath(path: (string | string[])[]): string {
  return path.flat().join('.');
}

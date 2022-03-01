import assert = require('assert');
import {
  ContractDefinition,
  FunctionDefinition,
  ImportDirective,
  SourceUnit,
  StructDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneResolvable } from '../utils/cloning';
import * as path from 'path';

type Scoped = FunctionDefinition | ContractDefinition | VariableDeclaration | StructDefinition;

export class SourceUnitSplitter extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots = ast.roots.flatMap((su) => splitSourceUnit(su, ast));
    return ast;
  }
}

function splitSourceUnit(sourceUnit: SourceUnit, ast: AST): SourceUnit[] {
  assert(sourceUnit.absolutePath.endsWith('.sol'), "Can't transform files without sol ending");

  const filePathRoot = sourceUnit.absolutePath.slice(
    0,
    sourceUnit.absolutePath.length - '.sol'.length,
  );

  const freeSourceUnitId = ast.reserveId();
  const freeSourceChildren = [
    ...sourceUnit.vImportDirectives.map((id) => cloneResolvable(id, ast)),
    ...sourceUnit.vEnums,
    ...sourceUnit.vErrors,
    ...sourceUnit.vUserDefinedValueTypes,
    ...updateScope(sourceUnit.vFunctions, freeSourceUnitId),
    ...updateScope(sourceUnit.vVariables, freeSourceUnitId),
    ...updateScope(sourceUnit.vStructs, freeSourceUnitId),
  ];
  const freeSourceUnit = new SourceUnit(
    freeSourceUnitId,
    sourceUnit.src,
    sourceUnit.type,
    '',
    0,
    mangleFreeFilePath(filePathRoot) + '.sol',
    new Map(),
    freeSourceChildren,
  );

  const units = sourceUnit.vContracts.map((contract) => {
    const contractSourceUnitId = ast.reserveId();
    return new SourceUnit(
      contractSourceUnitId,
      '',
      sourceUnit.type,
      '',
      0,
      mangleContractFilePath(filePathRoot, contract.name) + '.sol',
      new Map(),
      [
        ...sourceUnit.vImportDirectives.map((iD) => cloneResolvable(iD, ast)),
        ...updateScope([contract], contractSourceUnitId),
      ],
    );
  });

  const sourceUnits = freeSourceChildren.length > 0 ? [freeSourceUnit, ...units] : units;

  sourceUnits.forEach((su) => ast.setContextRecursive(su));

  sourceUnits.forEach((su) =>
    sourceUnits
      .filter((isu) => isu.id !== su.id)
      .forEach((importSu) => {
        const iDir = new ImportDirective(
          ast.reserveId(),
          importSu.src,
          importSu.type,
          importSu.absolutePath,
          importSu.absolutePath,
          path.basename(importSu.absolutePath),
          getAllSourceUnitDefinitions(su).map((node) => ({
            foreign: node.id,
            local: node.name,
          })),
          su.id,
          importSu.id,
        );
        su.appendChild(iDir);
        su.acceptChildren();
        ast.setContextRecursive(iDir);
      }),
  );

  return sourceUnits;
}

function updateScope(nodes: readonly Scoped[], newScope: number): readonly Scoped[] {
  nodes.forEach((node) => (node.scope = newScope));
  return nodes;
}

export function mangleFreeFilePath(path: string): string {
  return `${path}__WARP_FREE__`;
}

export function mangleContractFilePath(path: string, contractName: string): string {
  return `${path}__WARP_CONTRACT__${contractName}`;
}

function getAllSourceUnitDefinitions(sourceUnit: SourceUnit) {
  return [
    ...sourceUnit.vContracts,
    ...sourceUnit.vStructs,
    ...sourceUnit.vVariables,
    ...sourceUnit.vFunctions,
    ...sourceUnit.vVariables,
    ...sourceUnit.vUserDefinedValueTypes,
    ...sourceUnit.vEnums,
    ...sourceUnit.vErrors,
  ];
}

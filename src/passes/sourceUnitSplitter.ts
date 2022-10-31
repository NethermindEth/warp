import assert from 'assert';
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
import { cloneASTNode } from '../utils/cloning';
import { CONTRACT_INFIX, FREE_FILE_SUFFIX } from '../utils/nameModifiers';

type Scoped = FunctionDefinition | ContractDefinition | VariableDeclaration | StructDefinition;

export class SourceUnitSplitter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast.roots = ast.roots.flatMap((su) => splitSourceUnit(su, ast));
    return ast;
  }
}

function splitSourceUnit(sourceUnit: SourceUnit, ast: AST): SourceUnit[] {
  const freeSourceUnitId = ast.reserveId();
  const freeSourceSignificantChildren = [
    ...sourceUnit.vEnums,
    ...sourceUnit.vErrors,
    ...sourceUnit.vUserDefinedValueTypes,
    ...updateScope(sourceUnit.vFunctions, freeSourceUnitId),
    ...updateScope(sourceUnit.vVariables, freeSourceUnitId),
    ...updateScope(sourceUnit.vStructs, freeSourceUnitId),
  ];
  const freeSourceChildren = [
    ...sourceUnit.vImportDirectives.map((id) => cloneASTNode(id, ast)),
    ...freeSourceSignificantChildren,
  ];
  const freeSourceUnit = new SourceUnit(
    freeSourceUnitId,
    sourceUnit.src,
    '',
    0,
    mangleFreeFilePath(sourceUnit.absolutePath),
    sourceUnit.exportedSymbols,
    freeSourceChildren,
  );

  const units = sourceUnit.vContracts.map((contract) => {
    const contractSourceUnitId = ast.reserveId();
    return new SourceUnit(
      contractSourceUnitId,
      '',
      '',
      0,
      mangleContractFilePath(sourceUnit.absolutePath, contract.name),
      sourceUnit.exportedSymbols,
      [
        ...sourceUnit.vImportDirectives.map((iD) => cloneASTNode(iD, ast)),
        ...updateScope([contract], contractSourceUnitId),
      ],
    );
  });

  const sourceUnits = freeSourceSignificantChildren.length > 0 ? [freeSourceUnit, ...units] : units;

  sourceUnits.forEach((su) => ast.setContextRecursive(su));

  sourceUnits.forEach((su) =>
    sourceUnits
      .filter((isu) => isu.id !== su.id)
      .forEach((importSu) => {
        const iDir = new ImportDirective(
          ast.reserveId(),
          importSu.src,
          importSu.absolutePath,
          importSu.absolutePath,
          '',
          getAllSourceUnitDefinitions(importSu).map((node) => ({
            foreign: node.id,
            local: node.name,
          })),
          su.id,
          importSu.id,
        );
        su.insertAtBeginning(iDir);
        ast.registerChild(iDir, su);
        //ImportDirective scope should point to current SourceUnit
        importSu.getChildrenByType(ImportDirective).forEach((IDNode) => {
          IDNode.scope = importSu.id;
        });
      }),
  );

  return sourceUnits;
}

function updateScope(nodes: readonly Scoped[], newScope: number): readonly Scoped[] {
  nodes.forEach((node) => (node.scope = newScope));
  return nodes;
}

export function mangleFreeFilePath(path: string): string {
  return `${path}/${FREE_FILE_SUFFIX}`;
}

export function mangleContractFilePath(path: string, contractName: string): string {
  return `${path}/${contractName}`;
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

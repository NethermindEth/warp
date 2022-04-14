import { ContractDefinition, VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addStorageVariables(
  node: ContractDefinition,
  idRemapping: Map<number, VariableDeclaration>,
  ast: AST,
) {
  const inheritedVariables: Map<string, VariableDeclaration> = new Map();
  getBaseContracts(node)
    .reverse()
    .forEach((base) => {
      base.vStateVariables.forEach((decl) => {
        inheritedVariables.set(decl.name, decl);
      });
    });

  inheritedVariables.forEach((variable) => {
    const newVariable = cloneASTNode(variable, ast);
    node.insertAtBeginning(newVariable);
    idRemapping.set(variable.id, newVariable);
  });
}

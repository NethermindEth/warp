import { VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addStorageVariables(
  node: CairoContract,
  idRemapping: Map<number, VariableDeclaration>,
  ast: AST,
) {
  const dynamicAllocations: Map<VariableDeclaration, number> = node.dynamicStorageAllocations;
  const staticAllocations: Map<VariableDeclaration, number> = node.staticStorageAllocations;
  let usedStorage = node.usedStorage;
  let usedIds = node.usedIds;

  getBaseContracts(node)
    .reverse()
    .forEach((base) => {
      base.dynamicStorageAllocations.forEach((allocation, variable) => {
        const newVariable = cloneASTNode(variable, ast);
        idRemapping.set(variable.id, newVariable);
        newVariable.scope = node.id;
        node.insertAtBeginning(newVariable);
        dynamicAllocations.set(newVariable, allocation + usedIds);
      });
      base.staticStorageAllocations.forEach((allocation, variable) => {
        const newVariable = cloneASTNode(variable, ast);
        idRemapping.set(variable.id, newVariable);
        newVariable.scope = node.id;
        node.insertAtBeginning(newVariable);
        staticAllocations.set(newVariable, allocation + usedStorage);
      });
      usedStorage += base.usedStorage;
      usedIds += base.usedIds;
    });

  node.usedStorage = usedStorage;
  node.usedIds = usedIds;
}

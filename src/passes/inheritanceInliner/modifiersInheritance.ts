import { ContractDefinition, ModifierDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addNonOverridenModifiers(
  node: ContractDefinition,
  idRemapping: Map<number, ModifierDefinition>,
  ast: AST,
) {
  const modifierNames = new Set<string>();

  node.vModifiers.forEach((modifier) => {
    modifierNames.add(modifier.name);
  });

  getBaseContracts(node).forEach((contract) => {
    contract.vModifiers.forEach((modifier) => {
      const sz = modifierNames.size;
      modifierNames.add(modifier.name);
      if (modifierNames.size > sz) {
        const clonedModifier = cloneASTNode(modifier, ast);
        idRemapping.set(modifier.id, clonedModifier);
        node.appendChild(clonedModifier);
      }
    });
  });
}

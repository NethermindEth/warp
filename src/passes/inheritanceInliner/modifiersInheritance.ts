import assert from 'assert';
import { ContractDefinition, ModifierDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addNonOverridenModifiers(
  node: ContractDefinition,
  idRemapping: Map<number, ModifierDefinition>,
  ast: AST,
) {
  const modifierNames: Set<string> = new Set();
  const currentModifiers: Map<string, ModifierDefinition> = new Map();

  node.vModifiers.forEach((modifier) => {
    modifierNames.add(modifier.name);
    currentModifiers.set(modifier.name, modifier);
  });

  getBaseContracts(node).forEach((contract) => {
    contract.vModifiers.forEach((modifier) => {
      const sz = modifierNames.size;
      modifierNames.add(modifier.name);
      if (modifierNames.size > sz) {
        const clonedModifier = cloneASTNode(modifier, ast);
        currentModifiers.set(modifier.name, clonedModifier);
        node.appendChild(clonedModifier);
      }
      const mod = currentModifiers.get(modifier.name);
      assert(
        mod instanceof ModifierDefinition,
        'Modifier should have been already added to the map',
      );
      idRemapping.set(modifier.id, mod);
    });
  });
}

import { ContractKind, ModifierDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { fixSuperReference, getBaseContracts } from './utils';

export function addNonOverridenModifiers(
  node: CairoContract,
  idRemapping: Map<number, ModifierDefinition>,
  idRemappingOverriders: Map<number, ModifierDefinition>,
  ast: AST,
) {
  const currentModifiers: Map<string, ModifierDefinition> = new Map();

  node.vModifiers.forEach((modifier) => currentModifiers.set(modifier.name, modifier));

  getBaseContracts(node)
    .filter((node) => node.kind !== ContractKind.Library)
    .forEach((contract) => {
      contract.vModifiers.forEach((modifier, depth) => {
        const exisitingModifier = currentModifiers.get(modifier.name);
        const clonedModifier = cloneASTNode(modifier, ast);
        idRemapping.set(modifier.id, clonedModifier);
        if (exisitingModifier === undefined) {
          currentModifiers.set(modifier.name, clonedModifier);
          idRemappingOverriders.set(modifier.id, clonedModifier);
        } else {
          clonedModifier.name = `${clonedModifier.name}_m${depth + 1}`;
          idRemappingOverriders.set(modifier.id, exisitingModifier);
        }
        node.appendChild(clonedModifier);
        fixSuperReference(clonedModifier, contract, node);
      });
    });
}

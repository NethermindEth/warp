import { ContractKind, FunctionDefinition, FunctionKind, FunctionVisibility } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { isExternallyVisible } from '../../utils/utils';
import { fixSuperReference, getBaseContracts } from './utils';

// Every function from every base contract gets included privately in the derived contract
// To prevent name collisions, these functions have "_sX" appended
export function addPrivateSuperFunctions(
  node: CairoContract,
  idRemapping: Map<number, FunctionDefinition>,
  idRemappingOverriders: Map<number, FunctionDefinition>,
  ast: AST,
): void {
  const currentFunctions: Map<string, FunctionDefinition> = new Map();
  // collect functions in the current contract
  node.vFunctions
    .filter((f) => f.kind !== FunctionKind.Constructor)
    .forEach((f) => currentFunctions.set(f.name, f));
  getBaseContracts(node).forEach((base, depth) => {
    base.vFunctions
      .filter(
        (func) =>
          func.kind !== FunctionKind.Constructor &&
          (node.kind === ContractKind.Interface ? isExternallyVisible(func) : true),
      )
      .map((func) => {
        const existingEntry = currentFunctions.get(func.name);
        const clonedFunction = cloneASTNode(func, ast);
        idRemapping.set(func.id, clonedFunction);
        clonedFunction.scope = node.id;
        if (existingEntry !== undefined) {
          idRemappingOverriders.set(func.id, existingEntry);
          // We don't want to inherit the fallback function if an override exists because there can be no explicit references to it.
          if (clonedFunction.kind === FunctionKind.Fallback) {
            return null;
          }
          clonedFunction.visibility = FunctionVisibility.Private;
          clonedFunction.name = `s${depth + 1}_${clonedFunction.name}`;
        } else {
          currentFunctions.set(func.name, clonedFunction);
          idRemappingOverriders.set(func.id, clonedFunction);
          //Add recursion here for recursive function calls
          idRemappingOverriders.set(clonedFunction.id, clonedFunction);
        }
        return clonedFunction;
      })
      // filter the nulls returned when trying to inherit overridden fallback functions
      .filter((f): f is FunctionDefinition => f !== null)
      .forEach((func) => {
        node.appendChild(func);
        fixSuperReference(func, base, node);
      });
  });
}

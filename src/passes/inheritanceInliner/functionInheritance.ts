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
  node.vFunctions.forEach((f) => currentFunctions.set(f.name, f));
  getBaseContracts(node).forEach((base, depth) => {
    base.vFunctions
      .filter(
        (func) =>
          func.kind === FunctionKind.Function &&
          (node.kind === ContractKind.Interface ? isExternallyVisible(func) : true),
      )
      .map((func) => {
        const existingEntry = currentFunctions.get(func.name);
        const clonedFunction = cloneASTNode(func, ast);
        idRemapping.set(func.id, clonedFunction);
        clonedFunction.scope = node.id;
        if (existingEntry !== undefined) {
          idRemappingOverriders.set(func.id, existingEntry);
          clonedFunction.name = `s${depth + 1}_${clonedFunction.name}`;
          clonedFunction.visibility = FunctionVisibility.Private;
        } else {
          currentFunctions.set(func.name, clonedFunction);
          idRemappingOverriders.set(func.id, clonedFunction);
          //Add recursion here for recursive function calls
          idRemappingOverriders.set(clonedFunction.id, clonedFunction);
        }
        return clonedFunction;
      })
      .forEach((func) => {
        node.appendChild(func);
        fixSuperReference(func, base, node);
      });
  });
}

import {
  ABIEncoderVersion,
  ContractKind,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  InferType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { safeCanonicalHash } from '../../export';
import { cloneASTNode } from '../../utils/cloning';
import { isExternallyVisible } from '../../utils/utils';
import { createNewFunctionName } from '../export';
import { fixIdentifiers, fixSuperReference, getBaseContracts } from './utils';

// Every function from every base contract gets included privately in the derived contract
// To prevent name collisions, these functions have "_sX" appended
export function addPrivateSuperFunctions(
  node: CairoContract,
  idRemapping: Map<number, FunctionDefinition>,
  idRemappingOverriders: Map<number, FunctionDefinition>,
  ast: AST,
): void {
  const currentFunctions: Map<string, FunctionDefinition> = new Map();
  const overloadedFunctions: Set<FunctionDefinition> = new Set();
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
          // If the function has a different signature we need to mangle the names
          if (safeCanonicalHash(existingEntry, ast) !== safeCanonicalHash(clonedFunction, ast)) {
            // If the function has not already been overloaded then we need to mangle the name
            if (!overloadedFunctions.has(existingEntry)) {
              existingEntry.name = createNewFunctionName(existingEntry, ast);
              overloadedFunctions.add(existingEntry);
            }
            if (!overloadedFunctions.has(clonedFunction)) {
              clonedFunction.name = createNewFunctionName(clonedFunction, ast);
              overloadedFunctions.add(clonedFunction);
            }
            currentFunctions.set(func.name, clonedFunction);
            idRemappingOverriders.set(func.id, clonedFunction);
            //Add recursion here for recursive function calls
            idRemappingOverriders.set(clonedFunction.id, clonedFunction);
          } else {
            idRemappingOverriders.set(func.id, existingEntry);
            // We don't want to inherit the fallback function if an override exists because there can be no explicit references to it.
            if (clonedFunction.kind === FunctionKind.Fallback) {
              return null;
            }
            clonedFunction.visibility = FunctionVisibility.Private;
            clonedFunction.name = `s${depth + 1}_${clonedFunction.name}`;
          }
        } else {
          currentFunctions.set(func.name, clonedFunction);
          idRemappingOverriders.set(func.id, clonedFunction);
          //Add recursion here for recursive function calls
          idRemappingOverriders.set(clonedFunction.id, clonedFunction);
        }
        return clonedFunction;
      })
      // filter the nulls returned when trying to inherit overriden fallback functions
      .filter((f): f is FunctionDefinition => f !== null)
      .forEach((func) => {
        node.appendChild(func);
        fixSuperReference(func, base, node);
      });
    fixIdentifiers(node);
  });
}

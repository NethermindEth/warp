import assert from 'assert';
import { ContractKind, FunctionDefinition, FunctionKind, FunctionVisibility } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { createCallToFunction } from '../../utils/functionGeneration';
import { createBlock, createIdentifier, createReturn } from '../../utils/nodeTemplates';
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
      .filter((func) => !func.isConstructor)
      .map((func) => {
        const existingEntry = currentFunctions.get(func.name);
        const clonedFunction = cloneASTNode(func, ast);
        idRemapping.set(func.id, clonedFunction);
        clonedFunction.name = `${clonedFunction.name}_s${depth + 1}`;
        clonedFunction.visibility = FunctionVisibility.Private;
        clonedFunction.scope = node.id;
        if (existingEntry !== undefined) {
          idRemappingOverriders.set(func.id, existingEntry);
        } else {
          currentFunctions.set(func.name, clonedFunction);
          idRemappingOverriders.set(func.id, clonedFunction);
        }
        return clonedFunction;
      })
      .forEach((func) => {
        node.appendChild(func);
        fixSuperReference(func, base, node);
      });
  });
}

// Add inherited public/external functions
export function addNonoverridenPublicFunctions(
  node: CairoContract,
  idRemapping: Map<number, FunctionDefinition>,
  ast: AST,
) {
  // First, find all function names that should be callable from outside the derived contract
  const visibleFunctionNames = squashInterface(node);
  // Next, resolve these names to the FunctionDefinition nodes that should actually get called
  // This means searching back through the inheritance chain to find the first match
  const resolvedVisibleFunctions = [...visibleFunctionNames].map((name) =>
    resolveFunctionName(node, name),
  );
  // Only functions that are defined only in base contracts need to get moved
  const functionsToMove = resolvedVisibleFunctions.filter((func) => func.vScope !== node);

  // All the functions from the inheritance chain have already been copied into this contract as private functions
  // So to make them accessible with the expected name, new public or external functions are created that call the private one
  functionsToMove.forEach((f) => {
    const privateFunc = idRemapping.get(f.id);
    assert(privateFunc !== undefined, `Unable to find inlined base function for ${printNode(f)}`);
    node.appendChild(createDelegatingFunction(f, privateFunc, node.id, ast));
  });
}

// Get all visible function names accessible from a contract
function getVisibleFunctions(node: CairoContract): Set<string> {
  const visibleFunctions = new Set(
    node.vFunctions
      .filter((func) => isExternallyVisible(func) && !func.isConstructor)
      .map((func) => func.name),
  );

  return visibleFunctions;
}

function squashInterface(node: CairoContract): Set<string> {
  const visibleFunctions = getVisibleFunctions(node);
  getBaseContracts(node).forEach((contract) => {
    // The public interfaces of a library are not exposed by the contract itself
    if (contract.kind === ContractKind.Library) return;
    const inheritedVisibleFunctions = getVisibleFunctions(contract);
    inheritedVisibleFunctions.forEach((f) => visibleFunctions.add(f));
  });

  return visibleFunctions;
}

function findFunctionName(
  node: CairoContract,
  functionName: string,
): FunctionDefinition | undefined {
  const matches = node.vFunctions.filter((f) => f.name === functionName);
  if (matches.length > 1) {
    throw new TranspileFailedError(
      `InheritanceInliner expects unique function names, was IdentifierManger run? Found multiple ${functionName} in ${printNode(
        node,
      )} ${node.name}`,
    );
  } else if (matches.length === 1) {
    return matches[0];
  } else return undefined;
}

function resolveFunctionName(node: CairoContract, functionName: string): FunctionDefinition {
  let matches = findFunctionName(node, functionName);
  if (matches !== undefined) return matches;

  for (const base of getBaseContracts(node)) {
    matches = findFunctionName(base, functionName);
    if (matches !== undefined) return matches;
  }

  throw new TranspileFailedError(
    `Failed to find ${functionName} in ${printNode(node)} ${node.name}`,
  );
}

function createDelegatingFunction(
  funcToCopy: FunctionDefinition,
  delegate: FunctionDefinition,
  scope: number,
  ast: AST,
): FunctionDefinition {
  assert(
    funcToCopy.kind === FunctionKind.Function,
    `Attempted to copy non-member function ${funcToCopy.name}`,
  );
  assert(
    isExternallyVisible(funcToCopy),
    `Attempted to copy non public/external function ${funcToCopy.name}`,
  );

  const oldBody = funcToCopy.vBody;
  funcToCopy.vBody = undefined;
  const newFunc = cloneASTNode(funcToCopy, ast);
  funcToCopy.vBody = oldBody;

  const newBody = createBlock(
    [
      createReturn(
        createCallToFunction(
          delegate,
          newFunc.vParameters.vParameters.map((v) => createIdentifier(v, ast)),
          ast,
        ),
        newFunc.vReturnParameters.id,
        ast,
      ),
    ],
    ast,
  );

  newFunc.scope = scope;
  newFunc.vOverrideSpecifier = undefined;
  newFunc.vBody = newBody;
  newFunc.acceptChildren();
  ast.setContextRecursive(newFunc);

  return newFunc;
}

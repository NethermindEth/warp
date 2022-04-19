import assert from 'assert';
import {
  Block,
  ContractDefinition,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  Identifier,
  Return,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { createIdentifier } from '../../utils/nodeTemplates';
import { getFunctionTypeString, getReturnTypeString } from '../../utils/utils';
import { getBaseContracts } from './utils';

// Every function from every base contract gets included privately in the derived contract
// To prevent name collisions, these functions have "_sX" appended
export function addPrivateSuperFunctions(
  node: ContractDefinition,
  idRemapping: Map<number, FunctionDefinition>,
  ast: AST,
): void {
  getBaseContracts(node).forEach((base, depth) => {
    base.vFunctions
      .filter((func) => !func.isConstructor)
      .map((func) => {
        const clonedFunction = cloneASTNode(func, ast);
        idRemapping.set(func.id, clonedFunction);
        clonedFunction.name = `${clonedFunction.name}_s${depth + 1}`;
        clonedFunction.visibility = FunctionVisibility.Private;
        clonedFunction.scope = node.id;
        return clonedFunction;
      })
      .forEach((func) => node.appendChild(func));
  });
}

// Add inherited public/external functions
export function addNonoverridenPublicFunctions(
  node: ContractDefinition,
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
function getVisibleFunctions(node: ContractDefinition): Set<string> {
  const visibleFunctions = new Set(
    node.vFunctions
      .filter(
        (func) =>
          (func.visibility === FunctionVisibility.Public ||
            func.visibility === FunctionVisibility.External) &&
          !func.isConstructor,
      )
      .map((func) => func.name),
  );

  return visibleFunctions;
}

function squashInterface(node: ContractDefinition): Set<string> {
  const visibleFunctions = getVisibleFunctions(node);
  getBaseContracts(node).forEach((contract) => {
    const inheritedVisibleFunctions = getVisibleFunctions(contract);
    inheritedVisibleFunctions.forEach((f) => visibleFunctions.add(f));
  });

  return visibleFunctions;
}

function findFunctionName(
  node: ContractDefinition,
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

function resolveFunctionName(node: ContractDefinition, functionName: string): FunctionDefinition {
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
    funcToCopy.visibility === FunctionVisibility.Public ||
      funcToCopy.visibility === FunctionVisibility.External,
    `Attempted to copy non public/external function ${funcToCopy.name}`,
  );

  const oldBody = funcToCopy.vBody;
  funcToCopy.vBody = undefined;
  const newFunc = cloneASTNode(funcToCopy, ast);
  funcToCopy.vBody = oldBody;

  const newBody = new Block(ast.reserveId(), '', [
    new Return(
      ast.reserveId(),
      '',
      newFunc.vReturnParameters.id,
      new FunctionCall(
        ast.reserveId(),
        '',
        getReturnTypeString(delegate),
        FunctionCallKind.FunctionCall,
        new Identifier(
          ast.reserveId(),
          '',
          getFunctionTypeString(delegate, ast.compilerVersion),
          delegate.name,
          delegate.id,
        ),
        newFunc.vParameters.vParameters.map((v) => createIdentifier(v, ast)),
      ),
    ),
  ]);

  newFunc.scope = scope;
  newFunc.vOverrideSpecifier = undefined;
  newFunc.vBody = newBody;
  newFunc.acceptChildren();
  ast.setContextRecursive(newFunc);

  return newFunc;
}

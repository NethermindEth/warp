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
  IdentifierPath,
  MemberAccess,
  ModifierDefinition,
  Return,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { NotSupportedYetError, TranspileFailedError } from '../utils/errors';
import { createIdentifier } from '../utils/nodeTemplates';
import { getFunctionTypeString, getReturnTypeString } from '../utils/utils';

export class InheritanceInliner extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.vLinearizedBaseContracts.length < 2) {
      // LinearizedBaseContracts includes self as the first element,
      // and we only care about those which inherit from something else
      return;
    }

    const functionRemapping: Map<number, FunctionDefinition> = new Map();
    const variableRemapping: Map<number, VariableDeclaration> = new Map();
    const modifierRemapping: Map<number, ModifierDefinition> = new Map();

    addPrivateSuperFunctions(node, functionRemapping, ast);
    addNonoverridenPublicFunctions(node, functionRemapping, ast);
    addStorageVariables(node, variableRemapping, ast);
    addNonOverridenModifiers(node, modifierRemapping, ast);

    updateReferencedDeclarations(node, functionRemapping, ast);
    updateReferencedDeclarations(node, variableRemapping, ast);
    updateReferencedDeclarations(node, modifierRemapping, ast);
    this.commonVisit(node, ast);
  }

  static map(ast: AST): AST {
    let contracts = ast.roots.flatMap((root) => root.vContracts);
    while (contracts.length > 0) {
      const mostDerivedContracts = contracts.filter(
        (derivedContract) =>
          !contracts.some((otherContract) =>
            getBaseContracts(otherContract).includes(derivedContract),
          ),
      );
      if (mostDerivedContracts.length === 0 && contracts.length > 0) {
        throw new TranspileFailedError('Unable to serialise contracts');
      }
      contracts = contracts.filter((c) => !mostDerivedContracts.includes(c));
      mostDerivedContracts.forEach((contract) => {
        const pass = new this();
        pass.visitContractDefinition(contract, ast);
      });
    }
    return ast;
  }
}

// Every function from every base contract gets included privately in the derived contract
// To prevent name collisions, these functions have "_sX" appended
function addPrivateSuperFunctions(
  node: ContractDefinition,
  idRemapping: Map<number, FunctionDefinition>,
  ast: AST,
): void {
  getBaseContracts(node).forEach((base, depth) => {
    base.vFunctions
      // TODO implement constructors
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
function addNonoverridenPublicFunctions(
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

function addStorageVariables(
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

function addNonOverridenModifiers(
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

function updateReferencedDeclarations(
  node: ContractDefinition,
  idRemapping: Map<number, VariableDeclaration | FunctionDefinition | ModifierDefinition>,
  ast: AST,
) {
  node.walkChildren((node) => {
    if (node instanceof Identifier || node instanceof IdentifierPath) {
      const remapping = idRemapping.get(node.referencedDeclaration);
      if (remapping !== undefined) {
        node.referencedDeclaration = remapping.id;
        node.name = remapping.name;
      }
    } else if (node instanceof MemberAccess) {
      const remapping = idRemapping.get(node.referencedDeclaration);
      if (remapping !== undefined) {
        ast.replaceNode(
          node,
          new Identifier(
            ast.reserveId(),
            node.src,
            node.typeString,
            remapping.name,
            remapping.id,
            node.raw,
          ),
        );
      }
    }
  });
}

function getBaseContracts(node: ContractDefinition): ContractDefinition[] {
  return node.vLinearizedBaseContracts.slice(1);
}

// Get all visible function names accessible from a contract
function squashInterface(node: ContractDefinition): Set<string> {
  const visibleFunctions = new Set(
    node.vFunctions
      // TODO constructors
      .filter(
        (func) =>
          (func.visibility === FunctionVisibility.Public || FunctionVisibility.External) &&
          !func.isConstructor,
      )
      .map((func) => func.name),
  );
  const bases = getBaseContracts(node);
  if (bases.length > 0) {
    const inheritedVisibleFunctions = squashInterface(bases[0]);
    inheritedVisibleFunctions.forEach((f) => visibleFunctions.add(f));
  }

  return visibleFunctions;
}

function resolveFunctionName(node: ContractDefinition, functionName: string): FunctionDefinition {
  const matches = node.vFunctions.filter((f) => f.name === functionName);
  if (matches.length > 1) {
    throw new TranspileFailedError(
      `InheritanceInliner expects unique function names, was IdentifierManger run? Found multiple ${functionName} in ${printNode(
        node,
      )} ${node.name}`,
    );
  } else if (matches.length === 1) {
    return matches[0];
  } else {
    const base = getBaseContracts(node);
    if (base.length === 0)
      throw new TranspileFailedError(
        `Failed to find ${functionName} in ${printNode(node)} ${node.name}`,
      );
    return resolveFunctionName(base[0], functionName);
  }
}

function createDelegatingFunction(
  funcToCopy: FunctionDefinition,
  delegate: FunctionDefinition,
  scope: number,
  ast: AST,
): FunctionDefinition {
  const inputParams = cloneASTNode(funcToCopy.vParameters, ast);
  const retParams = cloneASTNode(funcToCopy.vReturnParameters, ast);
  assert(
    funcToCopy.kind === FunctionKind.Function,
    `Attempted to copy non-member function ${funcToCopy.name}`,
  );

  if (funcToCopy.isConstructor) {
    throw new NotSupportedYetError(`Inherited constructors is not implemented yet`);
  }
  const newFunc = new FunctionDefinition(
    ast.reserveId(),
    funcToCopy.src,
    scope,
    funcToCopy.kind,
    funcToCopy.name,
    funcToCopy.virtual,
    funcToCopy.visibility,
    funcToCopy.stateMutability,
    funcToCopy.isConstructor,
    inputParams,
    retParams,
    funcToCopy.vModifiers.map((m) => cloneASTNode(m, ast)),
    undefined,
    new Block(ast.reserveId(), '', [
      new Return(
        ast.reserveId(),
        '',
        retParams.id,
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
          inputParams.vParameters.map((v) => createIdentifier(v, ast)),
        ),
      ),
    ]),
  );
  ast.setContextRecursive(newFunc);
  return newFunc;
}

import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  Expression,
  ExpressionStatement,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  ModifierDefinition,
  Statement,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { createCallToFunction } from '../../utils/functionGeneration';
import { INIT_FUNCTION_PREFIX } from '../../utils/nameModifiers';
import {
  createBlock,
  createDefaultConstructor,
  createExpressionStatement,
  createIdentifier,
  createParameterList,
} from '../../utils/nodeTemplates';
import { updateReferencedDeclarations } from './utils';

/*
  The constructor is executed upon contract creation; all the constructors of the base 
  contracts will be called following the linearization order given by the ast.
  If the base constructors have arguments, derived contracts need to specify all of them,
  which can be done in two ways:
    - Directly in the inheritance specifiers
    - Indirectly through a modifier invocation of the derived constructor

  The main idea behind this solution is to create a new private function for each base 
  contract, which will be added as a function of the current contract, and which will be 
  a clone of the corresponding constructor. In particular, the constructor of the current 
  contract doesn't need to be cloned, just transformed into a private function. 
  
  A new function will be created and added as a child of the current contract, and this
  function will be the new constructor. It will handle:
    - Collecting the arguments to call each base constructor.
    - Calling the functions corresponding to each constructor in the correct order.

  When collecting the arguments, it's important to notice that expressions should be 
  evaluated in the reverse order the constructors are executed. To do so, each time a
  contract is entered, the previous constracts in the order of linearization are checked
  looking for the call to this contract's constructor; and argument references are updated

  In the following example:
  
  ```
  contract A {
    uint x;
    constructor(uint _x) { x = _x; }
  }

  contract B is A(7) {
    uint b;
    constructor(uint _b) { b = 2 * _b; }
  }

  contract C is B {
      constructor(uint _y) B(_y * _y) {}
  }
  ```
  contract C will result in:

  ```
  contract C{
    uint x;
    uint b;

    constructor(uint _y) {
      const __warp_constructor_parameter_0 = _y * _y;
      const __warp_constructor_parameter_1 = 7;
      
      __warp_constructor_2(__warp_constructor_parameter_1);
      __warp_constructor_3(__warp_constructor_parameter_0);
      __warp_constructor_4(_y);
    }

    function __warp_constructor_2(uint _x) { x = _x; }
    function __warp_constructor_3(uint _x) { b = 2 * _x; }
    function __warp_constructor_4(uint _x) {  }
  }
  ``` 
*/

export function solveConstructors(node: ContractDefinition, ast: AST, generator: () => number) {
  // Contracts marked as abstract won't be deployed
  if (node.abstract) {
    removeModifiersFromConstructor(node);
    return;
  }

  // Collect all constructors
  const constructors: Map<number, FunctionDefinition> = new Map();
  node.vLinearizedBaseContracts.forEach((contract) => {
    const constructorFunc = contract.vConstructor;
    if (constructorFunc !== undefined) constructors.set(contract.id, constructorFunc);
  });

  // Collect all state variable initialization functions and create a call statement
  // for each of them
  const varInit = node.vLinearizedBaseContracts
    .map((contract) => findVarInitialization(contract))
    .filter((f): f is FunctionDefinition => f !== null)
    .reverse()
    .map((f) => createExpressionStatement(ast, createCallToFunction(f, [], ast)));

  // Collect arguments passed to constructors of linearized contracts
  const statements: Statement[] = varInit;
  const args: Map<number, Expression[]> = new Map();
  const mappedVars: Map<number, VariableDeclaration> = new Map();

  const selfConstructor = generateFunctionForConstructor(node, mappedVars, ast);
  // There is no need to check `node` constructor args since that is solved in
  // the previous step
  const visitedContracts: ContractDefinition[] = [node];
  node.vLinearizedBaseContracts.slice(1).forEach((contract) => {
    collectArguments(
      contract,
      visitedContracts,
      args,
      mappedVars,
      statements,
      selfConstructor.id,
      ast,
      generator,
    );
    visitedContracts.push(contract);
  });

  // Create calls to constructor functions:
  // Constructors must be called in the order of linearized contracts,
  // from the "most base-like" to the "most derived"
  node.linearizedBaseContracts
    .slice(1)
    .reverse()
    .forEach((contractId) => {
      const constructorFunc = constructors.get(contractId);
      if (constructorFunc !== undefined) {
        const newFunc = createFunctionFromConstructor(constructorFunc, node, ast, generator);
        removeNonModifierInvocations(newFunc);
        node.appendChild(newFunc);

        const argList = args.get(contractId) ?? [];
        assert(
          constructorFunc.vParameters.vParameters.length === argList.length,
          `Wrong number of arguments in constructor`,
        );

        const stmt = createExpressionStatement(ast, createCallToFunction(newFunc, argList, ast));
        statements.push(stmt);
      }
    });

  // Change the constructor of this contract into a regular function to be called from `selfConstructor`
  transformConstructor(node, selfConstructor, statements, ast, generator);

  // Add generated function calls to the body of this contract's constructor
  generateBody(statements, selfConstructor, ast);
  ast.setContextRecursive(selfConstructor);
  node.appendChild(selfConstructor);
}

function collectArguments(
  contract: ContractDefinition,
  visitedContracts: ContractDefinition[],
  args: Map<number, Expression[]>,
  idRemapping: Map<number, VariableDeclaration>,
  statements: Statement[],
  scope: number,
  ast: AST,
  generator: () => number,
) {
  const constructorFunc = contract.vConstructor;
  if (constructorFunc !== undefined && constructorFunc.vParameters.vParameters.length > 0) {
    const callArgs = findConstructorCall(visitedContracts, contract, constructorFunc);
    const argList = getArguments(
      callArgs,
      constructorFunc.vParameters.vParameters,
      idRemapping,
      statements,
      scope,
      ast,
      generator,
      contract,
    );
    args.set(contract.id, argList);
  }
}

// Arguments to constructors can be passed either directly (in the inheritance specifiers)
// or indirectly (as modifier invocations of the constructor function of a derived contract),
// both ways are not allowed.
function findConstructorCall(
  visitedContracts: ContractDefinition[],
  currentContract: ContractDefinition,
  currentConstructor: FunctionDefinition,
): Expression[] {
  for (const contract of visitedContracts.slice().reverse()) {
    const constructorFunc = contract.vConstructor;

    // Check Inheritance Specifiers. There might be an inheritance specifier that points
    // to the `currentContract`, but does not pass any arguments, because they are being
    // passed as part of a Modifier Invocation or from a more derived contract.
    for (const specifier of contract.vInheritanceSpecifiers) {
      const contractId = specifier.vBaseType.referencedDeclaration;
      if (contractId == currentContract.id) {
        const size = specifier.vArguments.length;
        if (size > 0) {
          assert(
            currentConstructor !== undefined &&
              currentConstructor.vParameters.vParameters.length === size,
            'Wrong number of arguments in constructor',
          );
          return specifier.vArguments;
        }
      }
    }

    // Check Modifier Invocations
    if (constructorFunc !== undefined) {
      for (const modInvocation of constructorFunc.vModifiers) {
        const contractDef = modInvocation.vModifier;
        if (contractDef instanceof ContractDefinition && contractDef.id == currentContract.id) {
          return modInvocation.vArguments;
        }
      }
    }
  }

  throw new TranspileFailedError(
    `No arguments being passed to the constructor of ${printNode(currentContract)}`,
  );
}

function getArguments(
  args: Expression[],
  parameters: VariableDeclaration[],
  idRemapping: Map<number, VariableDeclaration>,
  statements: Statement[],
  scope: number,
  ast: AST,
  generator: () => number,
  nodeInSourceUnit: ASTNode,
): Expression[] {
  const size = args.length;
  const argList: Expression[] = [];
  for (let i = 0; i < size; ++i) {
    const newArg = cloneASTNode(args[i], ast);
    updateReferencedDeclarations(newArg, idRemapping, idRemapping, ast);
    const newVar = cloneASTNode(parameters[i], ast);
    newVar.name = `__warp_constructor_parameter_${generator()}`;
    newVar.scope = scope;

    idRemapping.set(parameters[i].id, newVar);
    argList.push(createIdentifier(newVar, ast, undefined, nodeInSourceUnit));
    statements.push(
      new VariableDeclarationStatement(ast.reserveId(), '', [newVar.id], [newVar], newArg),
    );
  }
  return argList;
}

function createFunctionFromConstructor(
  constructorFunc: FunctionDefinition,
  node: ContractDefinition,
  ast: AST,
  generator: () => number,
): FunctionDefinition {
  const newFunc = cloneASTNode(constructorFunc, ast);
  newFunc.kind = FunctionKind.Function;
  newFunc.name = `__warp_constructor_${generator()}`;
  newFunc.visibility = FunctionVisibility.Private;
  newFunc.isConstructor = false;
  newFunc.scope = node.id;
  ast.setContextRecursive(newFunc);

  return newFunc;
}

function generateBody(statements: Statement[], constructorFunc: FunctionDefinition, ast: AST) {
  const newBody = createBlock(statements, ast);
  constructorFunc.vBody = newBody;
  ast.registerChild(newBody, constructorFunc);
}

function generateFunctionForConstructor(
  node: ContractDefinition,
  idRemapping: Map<number, VariableDeclaration>,
  ast: AST,
): FunctionDefinition {
  const newFunc = createDefaultConstructor(node, ast);
  const currentConstructor = node.vConstructor;
  if (currentConstructor !== undefined) {
    const parameters = currentConstructor.vParameters.vParameters.map((v) => {
      const newV = cloneASTNode(v, ast);
      newV.scope = newFunc.id;
      idRemapping.set(v.id, newV);
      return newV;
    });
    const retParameters = currentConstructor.vReturnParameters.vParameters.map((v) => {
      const newV = cloneASTNode(v, ast);
      newV.scope = newFunc.id;
      idRemapping.set(v.id, newV);
      return newV;
    });
    newFunc.vParameters = createParameterList(parameters, ast);
    newFunc.vReturnParameters = createParameterList(retParameters, ast);
    newFunc.acceptChildren();
  }
  return newFunc;
}

function transformConstructor(
  node: ContractDefinition,
  newConstructor: FunctionDefinition,
  statements: Statement[],
  ast: AST,
  generator: () => number,
) {
  const currentCons = node.vConstructor;
  if (currentCons === undefined) return;

  currentCons.kind = FunctionKind.Function;
  currentCons.name = `__warp_constructor_${generator()}`;
  currentCons.visibility = FunctionVisibility.Private;
  currentCons.isConstructor = false;
  removeNonModifierInvocations(currentCons);

  const argList = newConstructor.vParameters.vParameters.map((v) => {
    return createIdentifier(v, ast, undefined, node);
  });
  statements.push(
    new ExpressionStatement(ast.reserveId(), '', createCallToFunction(currentCons, argList, ast)),
  );
}

function removeNonModifierInvocations(node: FunctionDefinition) {
  const modifiers = node.vModifiers.filter((modInvocation) => {
    return modInvocation.vModifier instanceof ModifierDefinition;
  });
  node.vModifiers = modifiers;
}

function removeModifiersFromConstructor(node: ContractDefinition) {
  const constructor = node.vConstructor;
  if (constructor !== undefined) removeNonModifierInvocations(constructor);
}

function findVarInitialization(contract: ContractDefinition): FunctionDefinition | null {
  const name = `${INIT_FUNCTION_PREFIX}${contract.name}`;
  for (const f of contract.vFunctions) {
    if (f.name == name) {
      return f;
    }
  }
  return null;
}

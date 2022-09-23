import assert from 'assert';
import {
  Assignment,
  ContractDefinition,
  Conditional,
  DataLocation,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  Identifier,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
  generalizeType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { createCallToFunction, fixParameterScopes } from '../../utils/functionGeneration';
import { PRE_SPLIT_EXPRESSION_PREFIX } from '../../utils/nameModifiers';
import {
  createEmptyTuple,
  createExpressionStatement,
  createIdentifier,
  createVariableDeclarationStatement,
} from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { counterGenerator, getContainingFunction } from '../../utils/utils';
import {
  addStatementsToCallFunction,
  createFunctionBody,
  getConditionalReturnVariable,
  getInputs,
  getNodeVariables,
  getParams,
  getReturns,
  getStatementsForVoidConditionals,
} from './conditionalFunctionaliser';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}${count.next().value}`;
  }
}

export class PreExpressionSplitter extends ASTMapper {
  eGen = expressionGenerator(PRE_SPLIT_EXPRESSION_PREFIX);
  funcNameCounter = 0;
  varNameCounter = 0;

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);

    // No need to split if is a statement
    if (node.parent instanceof ExpressionStatement) {
      return;
    }
    // No need to create temp vars for state vars
    if (
      node.vLeftHandSide instanceof Identifier &&
      identifierReferenceStateVar(node.vLeftHandSide)
    ) {
      return;
    }
    // // No need to split if is inside a base construct argument
    // if (isInsideBaseConstructor(node)) {
    //   return;
    // }
    const initialValue = node.vRightHandSide;
    const location =
      generalizeType(safeGetNodeType(initialValue, ast.compilerVersion))[1] ?? DataLocation.Default;
    const varDecl = new VariableDeclaration(
      ast.reserveId(), // id
      '', // src
      false, // constant
      false, // indexed
      this.eGen.next().value, //name
      ast.getContainingScope(node), //scope
      false, // stateVariable
      location, // storageLocation
      StateVariableVisibility.Internal, // visibility
      Mutability.Constant, // mutability
      node.vLeftHandSide.typeString, // typeString
    );

    const tempVarStatement = createVariableDeclarationStatement([varDecl], initialValue, ast);
    const tempVar = tempVarStatement.vDeclarations[0];

    const leftHandSide = cloneASTNode(node.vLeftHandSide, ast);
    const rightHandSide = createIdentifier(tempVar, ast, undefined, node);
    const assignment = new Assignment(
      ast.reserveId(), // id
      '', // src
      leftHandSide.typeString, // typeString
      '=', // operator
      leftHandSide, // left side
      rightHandSide, // right side
    );
    const updateVal = createExpressionStatement(ast, assignment);

    // b = (a=7) + 4
    // ~>
    // __warp_se = 7
    // a = __warp_se
    // b = (__warp_se) + 4
    ast.insertStatementBefore(node, tempVarStatement);
    ast.insertStatementBefore(node, updateVal);
    ast.replaceNode(node, createIdentifier(tempVar, ast));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (
      !(node.vReferencedDeclaration instanceof FunctionDefinition) ||
      node.parent instanceof ExpressionStatement ||
      node.parent instanceof VariableDeclarationStatement
    ) {
      return;
    }
    // // No need to split if is inside a base construct argument
    // if (isInsideBaseConstructor(node)) {
    //   return;
    // }

    const returnTypes = node.vReferencedDeclaration.vReturnParameters.vParameters;
    if (returnTypes.length === 0) {
      // If returns nothing then the function can be called in a previous statement and
      // replace this call with an empty tuple
      const parent = node.parent;
      assert(parent !== undefined, `${printNode(node)} ${node.vFunctionName} has no parent`);
      ast.replaceNode(node, createEmptyTuple(ast));
      ast.insertStatementBefore(parent, new ExpressionStatement(ast.reserveId(), '', node));
    } else if (returnTypes.length === 1) {
      assert(
        returnTypes[0].vType !== undefined,
        'Return types should not be undefined since solidity 0.5.0',
      );

      // ast.extractToConstant(node, cloneASTNode(returnTypes[0].vType, ast), this.eGen.next().value);
      const location =
        generalizeType(safeGetNodeType(node, ast.compilerVersion))[1] ?? DataLocation.Default;
      const replacementVariable = new VariableDeclaration(
        ast.reserveId(), // id
        node.src, // src
        true, // constant
        false, // indexed
        this.eGen.next().value, // name
        ast.getContainingScope(node), // scope
        false, // stateVariable
        location, // storageLocation
        StateVariableVisibility.Private, // visibility
        Mutability.Constant, // mutability
        returnTypes[0].typeString, // typeString
        undefined, // documentation
        cloneASTNode(returnTypes[0].vType, ast), // typeName
      );
      const declaration = createVariableDeclarationStatement(
        [replacementVariable],
        cloneASTNode(node, ast),
        ast,
      );
      const temp_var = declaration.vDeclarations[0];

      // a = f() + 5
      // ~>
      // __warp_se = f()
      // a = __warp_se + 5
      ast.insertStatementBefore(node, declaration);
      ast.replaceNode(node, createIdentifier(temp_var, ast));
    } else {
      // Be aware that is needed a tupleAssignmentSplitter pass before this one
      throw new TranspileFailedError(
        `ExpressionSplitter expects functions to have at most 1 return argument. ${printNode(
          node,
        )} ${node.vFunctionName} has ${returnTypes.length}`,
      );
    }
  }

  visitConditional(node: Conditional, ast: AST) {
    const containingFunction = getContainingFunction(node);
    const variables = getNodeVariables(node);
    const inputs = getInputs(variables, ast);
    const params = getParams(variables, ast);
    const newFuncId = ast.reserveId();
    const conditionalResult = getConditionalReturnVariable(
      node,
      newFuncId,
      this.varNameCounter++,
      ast,
    );
    const returns = getReturns(variables, conditionalResult, ast);

    const func = new FunctionDefinition(
      newFuncId,
      '',
      containingFunction.scope,
      containingFunction.kind === FunctionKind.Free ? FunctionKind.Free : FunctionKind.Function,
      `_conditional${this.funcNameCounter++}`,
      false,
      FunctionVisibility.Internal,
      containingFunction.stateMutability,
      false,
      params,
      returns,
      [],
      undefined,
      createFunctionBody(node, conditionalResult, returns, ast),
    );
    fixParameterScopes(func);
    containingFunction.vScope.insertBefore(func, containingFunction);
    ast.registerChild(func, containingFunction.vScope);
    this.dispatchVisit(func, ast);

    // Conditionals might return a value, or they might be void, in which
    // case conditionalResult would be undefined. Both cases need to be handled
    // separately
    if (conditionalResult !== undefined) {
      // conditionalResult variable was already used as the return value of the
      // conditional in the new function. It needs to be cloned to capture the
      // return value of the new function in containingFunction
      const result = cloneASTNode(conditionalResult, ast);
      result.scope = containingFunction.id;
      addStatementsToCallFunction(
        node,
        result,
        [...variables.keys()],
        createCallToFunction(func, inputs, ast),
        ast,
      );
      ast.replaceNode(node, createIdentifier(conditionalResult, ast));
    } else {
      getStatementsForVoidConditionals(
        node,
        [...variables.keys()],
        createCallToFunction(func, inputs, ast),
        ast,
      );
    }
  }
}

function identifierReferenceStateVar(id: Identifier) {
  const refDecl = id.vReferencedDeclaration;
  return (
    refDecl instanceof VariableDeclaration &&
    refDecl.getClosestParentByType(ContractDefinition)?.id === refDecl.scope
  );
}

// function isInsideBaseConstructor(node: ASTNode) {
//   // There are 2 ways to be a base constructor argument
//   // - In the inheritance list        --->  contract B is A(4+9+f())
//   // - A modifier in the constructor  --->  constructor(uint y) A(y*y) {}
//   const inInheritBaseConstruct = !(node.getClosestParentByType(InheritanceSpecifier) === undefined);
//   const inModifierBaseConstruct = !(node.getClosestParentByType(ModifierInvocation) === undefined);
//   return inInheritBaseConstruct || inModifierBaseConstruct;
// }

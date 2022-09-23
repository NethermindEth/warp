import assert from 'assert';
import {
  Assignment,
  ASTNode,
  Block,
  Conditional,
  DataLocation,
  Expression,
  ExpressionStatement,
  FunctionCall,
  Identifier,
  IfStatement,
  Mutability,
  ParameterList,
  Return,
  StateVariableVisibility,
  TupleType,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { getDefaultValue } from '../../utils/defaultValueNodes';
import { collectUnboundVariables, createOuterCall } from '../../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';
import { safeGetNodeType, safeGetNodeTypeInCtx } from '../../utils/nodeTypeProcessing';

// The returns should be both the values returned by the conditional itself,
// as well as the variables that got captured, as they could have been modified
export function getReturns(
  variables: Map<VariableDeclaration, Identifier[]>,
  retVariable: VariableDeclaration | undefined,
  ast: AST,
): ParameterList {
  const capturedVars = [...variables].map(([decl]) => cloneASTNode(decl, ast));
  return createParameterList(
    retVariable === undefined ? capturedVars : [retVariable, ...capturedVars],
    ast,
  );
}

export function getConditionalReturnVariable(
  node: Conditional,
  funcId: number,
  id: number,
  ast: AST,
): VariableDeclaration | undefined {
  if (isVoidConditional(node, ast)) return undefined;
  return new VariableDeclaration(
    ast.reserveId(),
    '',
    false, // constant
    false, // indexed
    `ret_conditional${id}`,
    funcId,
    false, // stateVariable
    DataLocation.Default,
    StateVariableVisibility.Private,
    Mutability.Mutable,
    node.typeString,
  );
}

// The inputs to the function should be only the free variables
// The branches get inlined into the function so that only the taken
// branch gets executed
export function getInputs(
  variables: Map<VariableDeclaration, Identifier[]>,
  ast: AST,
): Identifier[] {
  return [...variables].map(([decl]) => createIdentifier(decl, ast));
}

// The parameters should be the same as the inputs
// However this must also create new variable declarations for
// use in the new function, and rebind internal identifiers
// to these new variables
export function getParams(
  variables: Map<VariableDeclaration, Identifier[]>,
  ast: AST,
): ParameterList {
  return createParameterList(
    [...variables].map(([decl, ids]) => {
      const newVar = cloneASTNode(decl, ast);
      ids.forEach((id) => (id.referencedDeclaration = newVar.id));
      return newVar;
    }),
    ast,
  );
}

export function createFunctionBody(
  node: Conditional,
  retVariable: VariableDeclaration | undefined,
  returns: ParameterList,
  ast: AST,
): Block {
  return createBlock(
    [
      new IfStatement(
        ast.reserveId(),
        '',
        node.vCondition,
        createReturnBody(returns, node.vTrueExpression, retVariable, ast, node),
        createReturnBody(returns, node.vFalseExpression, retVariable, ast, node),
      ),
    ],
    ast,
  );
}

export function createReturnBody(
  returns: ParameterList,
  value: Expression,
  returnVar: VariableDeclaration | undefined,
  ast: AST,
  lookupNode?: ASTNode,
): Block {
  const expr =
    returnVar === undefined
      ? value
      : new Assignment(
          ast.reserveId(),
          '',
          returnVar.typeString,
          '=',
          createIdentifier(returnVar, ast, undefined, lookupNode),
          value,
        );
  return createBlock(
    [
      new ExpressionStatement(ast.reserveId(), '', expr),
      createReturn(returns.vParameters, returns.id, ast, lookupNode),
    ],
    ast,
  );
}

export function addStatementsToCallFunction(
  node: Conditional,
  conditionalResult: VariableDeclaration,
  variables: VariableDeclaration[],
  funcToCall: FunctionCall,
  ast: AST,
) {
  const statements = [
    new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [conditionalResult.id],
      [conditionalResult],
      getDefaultValue(
        safeGetNodeTypeInCtx(conditionalResult, ast.compilerVersion, node),
        conditionalResult,
        ast,
      ),
    ),
    createOuterCall(node, [conditionalResult, ...variables], funcToCall, ast),
  ];
  statements.forEach((stmt) => ast.insertStatementBefore(node, stmt));
}

export function getNodeVariables(node: Conditional) {
  return new Map([...collectUnboundVariables(node)].filter(([decl]) => !decl.stateVariable));
}

// There might be two different cases where conditionals return void:
// - they are the expression of a return statement
// - they are the expression of an expressionStatement
// TODO - Check if there are any other cases where the conditional might be void
export function getStatementsForVoidConditionals(
  node: Conditional,
  variables: VariableDeclaration[],
  funcToCall: FunctionCall,
  ast: AST,
) {
  const parent =
    node.getClosestParentByType(Return) ?? node.getClosestParentByType(ExpressionStatement);
  assert(parent !== undefined, `Expected parent for ${printNode(node)} was not found`);
  const outerCall = createOuterCall(node, variables, funcToCall, ast);

  if (parent instanceof Return) {
    assert(parent.vExpression === node, `Expected conditional to be the returned expression`);
    ast.insertStatementBefore(parent, outerCall);
    parent.vExpression = undefined;
  } else {
    assert(
      parent.vExpression === node,
      `Expected conditional to be the expression of the ExpressionStatement`,
    );
    ast.replaceNode(parent, outerCall);
  }
}

function isVoidConditional(node: Conditional, ast: AST): boolean {
  const conditionalType = safeGetNodeType(node, ast.compilerVersion);
  if (conditionalType instanceof TupleType) {
    if (conditionalType.elements.length == 0) return true;
  }
  return false;
}

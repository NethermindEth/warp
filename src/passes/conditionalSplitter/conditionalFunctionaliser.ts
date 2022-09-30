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
  Statement,
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
import { CONDITIONAL_RETURN_VARIABLE } from '../../utils/nameModifiers';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
  createVariableDeclarationStatement,
} from '../../utils/nodeTemplates';
import { safeGetNodeType, safeGetNodeTypeInCtx } from '../../utils/nodeTypeProcessing';
import { toSingleExpression, typeNameFromTypeNode } from '../../utils/utils';

// The returns should be both the values returned by the conditional itself,
// as well as the variables that got captured, as they could have been modified
export function getReturns(
  variables: Map<VariableDeclaration, Identifier[]>,
  conditionalReturn: VariableDeclaration[],
  ast: AST,
): ParameterList {
  const capturedVars = [...variables].map(([decl]) => cloneASTNode(decl, ast));
  return createParameterList([...conditionalReturn, ...capturedVars], ast);
}

export function getConditionalReturn(
  node: Conditional,
  funcId: number,
  nameCounter: Generator<number, number, unknown>,
  ast: AST,
): VariableDeclaration[] {
  const conditionalType = safeGetNodeType(node, ast.compilerVersion);
  const variables =
    conditionalType instanceof TupleType
      ? getAllVariables(node, conditionalType, funcId, nameCounter, ast)
      : [getVar(node, node.typeString, funcId, nameCounter, ast)];
  return variables;
}

function getVar(
  node: Conditional,
  typeString: string,
  scope: number,
  nameCounter: Generator<number, number, unknown>,
  ast: AST,
): VariableDeclaration {
  return new VariableDeclaration(
    ast.reserveId(),
    '',
    false, // constant
    false, // indexed
    `${CONDITIONAL_RETURN_VARIABLE}${nameCounter.next().value}`,
    scope,
    false, // stateVariable
    DataLocation.Default,
    StateVariableVisibility.Private,
    Mutability.Mutable,
    typeString,
    undefined,
    typeNameFromTypeNode(safeGetNodeType(node, ast.compilerVersion), ast),
  );
}

function getAllVariables(
  node: Conditional,
  conditionalType: TupleType,
  scope: number,
  nameCounter: Generator<number, number, unknown>,
  ast: AST,
): VariableDeclaration[] {
  if (conditionalType.elements.length == 0) return [];
  else return conditionalType.elements.map((t) => getVar(node, t.pp(), scope, nameCounter, ast));
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
  conditionalReturn: VariableDeclaration[],
  returns: ParameterList,
  ast: AST,
): Block {
  return createBlock(
    [
      new IfStatement(
        ast.reserveId(),
        '',
        node.vCondition,
        createReturnBody(returns, node.vTrueExpression, conditionalReturn, ast, node),
        createReturnBody(returns, node.vFalseExpression, conditionalReturn, ast, node),
      ),
    ],
    ast,
  );
}

export function createReturnBody(
  returns: ParameterList,
  value: Expression,
  conditionalReturn: VariableDeclaration[],
  ast: AST,
  lookupNode?: ASTNode,
): Block {
  const conditionalReturnIdentifiers = conditionalReturn.map((variable) =>
    createIdentifier(variable, ast, undefined, lookupNode),
  );
  const expr =
    conditionalReturn.length == 0
      ? value
      : new Assignment(
          ast.reserveId(),
          '',
          value.typeString,
          '=',
          toSingleExpression(conditionalReturnIdentifiers, ast),
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
  conditionalResult: VariableDeclaration[],
  variables: VariableDeclaration[],
  funcToCall: FunctionCall,
  ast: AST,
): Statement[] {
  const statements = [
    createVariableDeclarationStatement(
      conditionalResult,
      toSingleExpression(
        conditionalResult.map((v) =>
          getDefaultValue(safeGetNodeTypeInCtx(v, ast.compilerVersion, node), node, ast),
        ),
        ast,
      ),
      ast,
    ),
    createOuterCall(node, [...conditionalResult, ...variables], funcToCall, ast),
  ];
  return statements;
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

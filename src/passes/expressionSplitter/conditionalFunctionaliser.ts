import assert = require('assert');
import {
  Assignment,
  ASTNode,
  Block,
  Conditional,
  DataLocation,
  Expression,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  FunctionVisibility,
  getNodeType,
  Identifier,
  IfStatement,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { getDefaultValue } from '../../utils/defaultValueNodes';
import {
  collectUnboundVariables,
  createCallToFunction,
  createOuterCall,
  fixParameterScopes,
} from '../../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';

export class ConditionalFunctionaliser extends ASTMapper {
  funcNameCounter = 0;
  varNameCounter = 0;

  visitConditional(node: Conditional, ast: AST): void {
    this.visitExpression(node, ast);

    const containingFunction = getContainingFunction(node);
    const variables = getNodeVariables(node);
    const inputs = getInputs(variables, ast);
    const params = getParams(variables, ast);
    const newFuncId = ast.reserveId();
    const returns = this.getReturns(node, variables, newFuncId, ast);
    const func = new FunctionDefinition(
      newFuncId,
      '',
      containingFunction.scope,
      containingFunction.kind,
      `_conditional${this.funcNameCounter++}`,
      false,
      FunctionVisibility.Internal,
      containingFunction.stateMutability,
      false,
      params,
      returns,
      [],
      undefined,
      createFunctionBody(node, returns, ast),
    );
    fixParameterScopes(func);
    containingFunction.vScope.insertBefore(func, containingFunction);
    ast.registerChild(func, containingFunction.vScope);

    const conditionalResult = getConditionalReturnVariable(
      node,
      containingFunction.id,
      this.varNameCounter++,
      ast,
    );
    addStatementsToCallFunction(
      node,
      conditionalResult,
      [...variables.keys()],
      createCallToFunction(func, inputs, ast),
      ast,
    );
    ast.replaceNode(node, createIdentifier(conditionalResult, ast));
  }

  // The returns should be both the values returned by the conditional itself,
  // as well as the variables that got captured, as they could have been modified
  getReturns(
    node: Conditional,
    variables: Map<VariableDeclaration, Identifier[]>,
    funcId: number,
    ast: AST,
  ): ParameterList {
    const capturedVars = [...variables].map(([decl]) => cloneASTNode(decl, ast));
    const retVariable = getConditionalReturnVariable(node, funcId, this.varNameCounter++, ast);

    return createParameterList([retVariable, ...capturedVars], ast);
  }
}

function getConditionalReturnVariable(
  node: Conditional,
  funcId: number,
  id: number,
  ast: AST,
): VariableDeclaration {
  return new VariableDeclaration(
    ast.reserveId(),
    '',
    false,
    false,
    `ret_conditional${id}`,
    funcId,
    false,
    DataLocation.Default,
    StateVariableVisibility.Private,
    Mutability.Mutable,
    node.typeString,
  );
}

function getContainingFunction(node: ASTNode): FunctionDefinition {
  const func = node.getClosestParentByType(FunctionDefinition);
  assert(func !== undefined, `Unable to find containing function for ${printNode(node)}`);
  return func;
}

// The inputs to the function should be only the free variables
// The branches get inlined into the function so that only the taken
// branch gets executed
function getInputs(variables: Map<VariableDeclaration, Identifier[]>, ast: AST): Identifier[] {
  return [...variables].map(([decl]) => createIdentifier(decl, ast));
}

// The parameters should be the same as the inputs
// However this must also create new variable declarations for
// use in the new function, and rebind internal identifiers
// to these new variables
function getParams(variables: Map<VariableDeclaration, Identifier[]>, ast: AST): ParameterList {
  return createParameterList(
    [...variables].map(([decl, ids]) => {
      const newVar = cloneASTNode(decl, ast);
      ids.forEach((id) => (id.referencedDeclaration = newVar.id));
      return newVar;
    }),
    ast,
  );
}

function createFunctionBody(node: Conditional, returns: ParameterList, ast: AST): Block {
  return createBlock(
    [
      new IfStatement(
        ast.reserveId(),
        '',
        node.vCondition,
        createReturnBody(returns, node.vTrueExpression, ast),
        createReturnBody(returns, node.vFalseExpression, ast),
      ),
    ],
    ast,
  );
}

function createReturnBody(returns: ParameterList, value: Expression, ast: AST): Block {
  const firstVar = returns.vParameters[0];
  const variable = cloneASTNode(firstVar, ast);
  variable.name = '__warp_aux_var';
  return createBlock(
    [
      new VariableDeclarationStatement(ast.reserveId(), '', [variable.id], [variable], value),
      new ExpressionStatement(
        ast.reserveId(),
        '',
        new Assignment(
          ast.reserveId(),
          '',
          firstVar.typeString,
          '=',
          createIdentifier(firstVar, ast),
          createIdentifier(variable, ast),
        ),
      ),
      createReturn(returns.vParameters, returns.id, ast),
    ],
    ast,
  );
}

function addStatementsToCallFunction(
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
      getDefaultValue(getNodeType(conditionalResult, ast.compilerVersion), conditionalResult, ast),
    ),
    createOuterCall(node, [conditionalResult, ...variables], funcToCall, ast),
  ];
  statements.forEach((stmt) => ast.insertStatementBefore(node, stmt));
}

function getNodeVariables(node: Conditional) {
  return new Map([...collectUnboundVariables(node)].filter(([decl]) => !decl.stateVariable));
}

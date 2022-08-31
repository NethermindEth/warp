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
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getDefaultValue } from '../../utils/defaultValueNodes';
import { collectUnboundVariables, createOuterCall } from '../../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';
import { safeGetNodeTypeInCtx } from '../../utils/nodeTypeProcessing';

// The returns should be both the values returned by the conditional itself,
// as well as the variables that got captured, as they could have been modified
export function getReturns(
  node: Conditional,
  variables: Map<VariableDeclaration, Identifier[]>,
  funcId: number,
  varId: number,
  ast: AST,
): ParameterList {
  const capturedVars = [...variables].map(([decl]) => cloneASTNode(decl, ast));
  const retVariable = getConditionalReturnVariable(node, funcId, varId, ast);

  return createParameterList([retVariable, ...capturedVars], ast);
}

export function getConditionalReturnVariable(
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

export function createFunctionBody(node: Conditional, returns: ParameterList, ast: AST): Block {
  return createBlock(
    [
      new IfStatement(
        ast.reserveId(),
        '',
        node.vCondition,
        createReturnBody(returns, node.vTrueExpression, ast, node),
        createReturnBody(returns, node.vFalseExpression, ast, node),
      ),
    ],
    ast,
  );
}

export function createReturnBody(
  returns: ParameterList,
  value: Expression,
  ast: AST,
  lookupNode?: ASTNode,
): Block {
  const firstVar = returns.vParameters[0];
  return createBlock(
    [
      new ExpressionStatement(
        ast.reserveId(),
        '',
        new Assignment(
          ast.reserveId(),
          '',
          firstVar.typeString,
          '=',
          createIdentifier(firstVar, ast, undefined, lookupNode),
          value,
        ),
      ),
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

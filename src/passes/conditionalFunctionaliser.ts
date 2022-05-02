import assert = require('assert');
import {
  ASTNode,
  Block,
  Conditional,
  FunctionDefinition,
  FunctionVisibility,
  Identifier,
  IfStatement,
  ParameterList,
  Return,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { createCallToFunction } from '../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../utils/nodeTemplates';
import { collectUnboundVariables } from './loopFunctionaliser/utils';

export class ConditionalFunctionaliser extends ASTMapper {
  funcNameCounter = 0;
  varNameCounter = 0;

  visitConditional(node: Conditional, ast: AST): void {
    this.visitExpression(node, ast);

    const containingFunction = getContainingFunction(node);
    const inputs = getInputs(node, ast);
    const params = getParams(node, ast);
    const newFuncId = ast.reserveId();
    const returns = this.getReturns(node, newFuncId, ast);
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
    containingFunction.vScope.insertBefore(func, containingFunction);
    ast.registerChild(func, containingFunction.vScope);
    ast.replaceNode(node, createCallToFunction(func, inputs, ast));
  }

  // The returns should be both the values returned by the conditional itself,
  // as well as the variables that got captured, as they could have been modified
  getReturns(node: Conditional, funcId: number, ast: AST): ParameterList {
    const capturedVars = [...collectUnboundVariables(node)]
      .filter(([decl]) => !decl.stateVariable)
      .map(([decl]) => cloneASTNode(decl, ast));
    // TODO add retVars into this
    // Difficulty: Type to use for literals
    return createParameterList([...capturedVars], ast);
  }
}

function getContainingFunction(node: ASTNode): FunctionDefinition {
  const func = node.getClosestParentByType(FunctionDefinition);
  assert(func !== undefined, `Unable to find containing function for ${printNode(node)}`);
  return func;
}

// The inputs to the function should be only the free variables
// The branches get inlined into the function so that only the taken
// branch gets executed
function getInputs(node: Conditional, ast: AST): Identifier[] {
  return [...collectUnboundVariables(node)]
    .filter(([decl]) => !decl.stateVariable)
    .map(([decl]) => createIdentifier(decl, ast));
}

// The parameters should be the same as the inputs
// However this must also create new variable declarations for
// use in the new function, and rebind internal identifiers
// to these new variables
function getParams(node: Conditional, ast: AST): ParameterList {
  return createParameterList(
    [...collectUnboundVariables(node)]
      .filter(([decl]) => !decl.stateVariable)
      .map(([decl, ids]) => {
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
        createReturn(node.vTrueExpression, returns.id, ast),
        createReturn(node.vFalseExpression, returns.id, ast),
      ),
    ],
    ast,
  );
}

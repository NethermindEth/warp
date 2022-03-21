import assert = require('assert');
import {
  Assignment,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { TranspileFailedError } from '../utils/errors';
import { createEmptyTuple } from '../utils/nodeTemplates';
import { counterGenerator } from '../utils/utils';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}_${count.next().value}`;
  }
}

export class ExpressionSplitter extends ASTMapper {
  eGen = expressionGenerator('__warp_se');

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);
    if (!(node.parent instanceof ExpressionStatement)) {
      const replacement = cloneASTNode(node.vLeftHandSide, ast);
      ast.replaceNode(node, replacement);
      ast.insertStatementBefore(
        replacement,
        new ExpressionStatement(ast.reserveId(), '', 'ExpressionStatement', node),
      );
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    // TODO implement this for other instances
    // TODO check how vReferencedDeclaration works for functions like require
    // TODO don't split tail recursion unless necessary (can be necessary because of implicit arguments/returns)
    if (
      !(node.vReferencedDeclaration instanceof FunctionDefinition) ||
      node.parent instanceof ExpressionStatement ||
      node.parent instanceof VariableDeclarationStatement
    ) {
      return;
    }

    const returnTypes = node.vReferencedDeclaration.vReturnParameters.vParameters;
    if (returnTypes.length === 0) {
      const parent = node.parent;
      assert(parent !== undefined, `${printNode(node)} ${node.vFunctionName} has no parent`);
      ast.replaceNode(node, createEmptyTuple(ast));
      ast.insertStatementBefore(
        parent,
        new ExpressionStatement(ast.reserveId(), '', 'ExpressionStatement', node),
      );
    } else if (returnTypes.length === 1) {
      assert(
        returnTypes[0].vType !== undefined,
        'Return types should not be undefined since solidity 0.5.0',
      );
      ast.extractToConstant(node, cloneASTNode(returnTypes[0].vType, ast), this.eGen.next().value);
    } else {
      throw new TranspileFailedError(
        `ExpressionSplitter expects functions to have at most 1 return argument. ${printNode(
          node,
        )} ${node.vFunctionName} has ${returnTypes.length}`,
      );
    }
  }
}

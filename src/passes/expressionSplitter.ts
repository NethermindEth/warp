import assert = require('assert');
import {
  FunctionDefinition,
  FunctionCall,
  VariableDeclarationStatement,
  ExpressionStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneTypeName } from '../utils/cloning';
import { counterGenerator } from '../utils/utils';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}_${count.next().value}`;
  }
}

export class ExpressionSplitter extends ASTMapper {
  eGen = expressionGenerator('__warp_se');

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
    assert(returnTypes.length === 1);

    assert(
      returnTypes[0].vType !== undefined,
      'Return types should not be undefined since solidity 0.5.0',
    );

    ast.extractToConstant(node, cloneTypeName(returnTypes[0].vType, ast), this.eGen.next().value);
  }
}

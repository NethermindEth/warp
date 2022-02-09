import assert = require('assert');
import { Continue, FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { createLoopCall } from './utils';

export class ContinueToLoopCall extends ASTMapper {
  visitContinue(node: Continue, ast: AST): void {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    assert(
      containingFunction !== undefined,
      `Unable to find containing function for ${printNode(node)}`,
    );

    ast.replaceNode(
      node,
      new Return(
        ast.reserveId(),
        node.src,
        'Return',
        containingFunction.vReturnParameters.id,
        createLoopCall(containingFunction, containingFunction.vParameters.vParameters, ast),
      ),
    );
  }
}

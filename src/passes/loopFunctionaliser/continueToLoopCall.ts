import assert = require('assert');
import { Continue, FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { createLoopCall } from './utils';

export class ContinueToLoopCall extends ASTMapper {
  constructor(private loopToContinueFunction: Map<number, FunctionDefinition>) {
    super();
  }

  visitContinue(node: Continue, ast: AST): void {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    assert(
      containingFunction !== undefined,
      `Unable to find containing function for ${printNode(node)}`,
    );

    const continueFunction = this.loopToContinueFunction.get(containingFunction.id);
    assert(
      continueFunction instanceof FunctionDefinition,
      `Unable to find continue function for ${printNode(containingFunction)}`,
    );

    ast.replaceNode(
      node,
      new Return(
        ast.reserveId(),
        node.src,
        'Return',
        continueFunction.vReturnParameters.id,
        createLoopCall(continueFunction, continueFunction.vParameters.vParameters, ast),
      ),
    );
  }
}

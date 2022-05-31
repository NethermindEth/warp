import assert from 'assert';
import { Continue, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { createReturn } from '../../utils/nodeTemplates';
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
      createReturn(
        createLoopCall(continueFunction, containingFunction.vParameters.vParameters, ast),
        containingFunction.vReturnParameters.id,
        ast,
      ),
    );
  }
}

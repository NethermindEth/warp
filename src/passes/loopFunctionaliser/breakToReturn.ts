import assert from 'assert';
import { Break, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { createReturn } from './utils';

export class BreakToReturn extends ASTMapper {
  visitBreak(node: Break, ast: AST): void {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    assert(
      containingFunction !== undefined,
      `Unable to find containing function for ${printNode(node)}`,
    );

    ast.replaceNode(
      node,
      createReturn(
        containingFunction.vParameters.vParameters,
        containingFunction.vReturnParameters.id,
        ast,
      ),
    );
  }
}

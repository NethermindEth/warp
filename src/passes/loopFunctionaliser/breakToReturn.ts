import { Break } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createReturn } from '../../utils/nodeTemplates';
import { getContainingFunction } from '../../utils/utils';

export class BreakToReturn extends ASTMapper {
  visitBreak(node: Break, ast: AST): void {
    const containingFunction = getContainingFunction(node);

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

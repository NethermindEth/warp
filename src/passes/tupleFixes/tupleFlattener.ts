import { TupleExpression } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class TupleFlattener extends ASTMapper {
  visitTupleExpression(node: TupleExpression, ast: AST): void {
    if (
      node.vOriginalComponents.length === 1 &&
      node.vOriginalComponents[0] !== null &&
      node.vOriginalComponents[0].typeString === node.typeString &&
      !node.isInlineArray
    ) {
      const parent = node.parent;
      ast.replaceNode(node, node.vOriginalComponents[0], parent);
      this.dispatchVisit(node.vOriginalComponents[0], ast);
    } else {
      this.visitExpression(node, ast);
    }
  }
}

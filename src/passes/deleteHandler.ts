import {
  Assignment,
  ExpressionStatement,
  getNodeType,
  MappingType,
  Return,
  TupleType,
  UnaryOperation,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { getDefaultValue } from '../utils/defaultValueNodes';

export class DeleteHandler extends ASTMapper {
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.operator === 'delete') {
      const nodeType = getNodeType(node.vSubExpression, ast.compilerVersion);
      const newNode = getDefaultValue(nodeType, node, ast);
      if (nodeType instanceof MappingType) ast.replaceNode(node, newNode);
      else {
        ast.replaceNode(
          node,
          new Assignment(
            ast.reserveId(),
            node.src,
            'Assignment',
            nodeType.pp(),
            '=',
            node.vSubExpression,
            newNode,
            node.raw,
          ),
        );
      }
    } else this.commonVisit(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    let visited = false;
    if (node.vExpression) {
      const nodeType = getNodeType(node.vExpression, ast.compilerVersion);
      if (nodeType instanceof TupleType && nodeType.getChildren().length === 0) {
        const statement = new ExpressionStatement(
          ast.reserveId(),
          node.src,
          'ExpressionStatement',
          node.vExpression,
          node.documentation,
          node.raw,
        );
        ast.replaceNode(node, statement, node.parent);
        this.commonVisit(statement, ast);
        visited = true;
      }
    }
    if (!visited) this.commonVisit(node, ast);
  }
}

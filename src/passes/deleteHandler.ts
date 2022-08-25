import {
  Assignment,
  DataLocation,
  ExpressionStatement,
  Identifier,
  PointerType,
  Return,
  TupleType,
  UnaryOperation,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneDocumentation } from '../utils/cloning';
import { getDefaultValue } from '../utils/defaultValueNodes';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

export class DeleteHandler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.operator !== 'delete') {
      return this.commonVisit(node, ast);
    }

    const nodeType = safeGetNodeType(node.vSubExpression, ast.compilerVersion);
    // Deletetion from storage is handled in References
    if (
      (nodeType instanceof PointerType && nodeType.location === DataLocation.Storage) ||
      (node instanceof Identifier &&
        node.vReferencedDeclaration instanceof VariableDeclaration &&
        node.vReferencedDeclaration.stateVariable)
    ) {
      return;
    }

    const newNode = getDefaultValue(nodeType, node, ast);
    ast.replaceNode(
      node,
      new Assignment(
        ast.reserveId(),
        node.src,
        nodeType.pp(),
        '=',
        node.vSubExpression,
        newNode,
        node.raw,
      ),
    );
  }

  visitReturn(node: Return, ast: AST): void {
    let visited = false;
    if (node.vExpression) {
      const nodeType = safeGetNodeType(node.vExpression, ast.compilerVersion);
      if (nodeType instanceof TupleType && nodeType.getChildren().length === 0) {
        const statement = new ExpressionStatement(
          ast.reserveId(),
          node.src,
          node.vExpression,
          cloneDocumentation(node.documentation, ast, new Map<number, number>()),
          node.raw,
        );
        ast.insertStatementBefore(node, statement);
        node.vExpression = undefined;
        this.commonVisit(statement, ast);
        visited = true;
      }
    }
    if (!visited) this.commonVisit(node, ast);
  }
}

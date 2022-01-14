import { ASTNode } from 'solc-typed-ast';
import { AST } from './ast';
import { ASTVisitor } from './visitor';

export class ASTMapper extends ASTVisitor<void> {
  commonVisit(node: ASTNode, ast: AST): void {
    // The slice is for consistency if the node is modified during visiting
    // If you want to add a new child during a visit, and then visit it, you must call dispatchVisit on it yourself
    node.children.slice().forEach((child) => this.dispatchVisit(child, ast));
  }

  map(ast: AST): AST {
    this.dispatchVisit(ast.root, ast);
    return ast;
  }
}

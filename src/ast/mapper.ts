import { ASTNode } from 'solc-typed-ast';
import { AST } from './ast';
import { ASTVisitor } from './visitor';

/*
 The base transpilation pass class.
 Provides a default method for visiting an ASTNode that just visits its children
 and a method to run the pass on each root of the AST separately. This is important
 to make sure that the result of transpiling a file is not affected by which other
 files happen to be present in the transpilation
*/

export class ASTMapper extends ASTVisitor<void> {
  // List of passes that should have been run before this one
  prerequisites: Set<string> = new Set<string>();

  addPassPrerequisite(pass_key: string) {
    this.prerequisites.add(pass_key);
  }

  addInitialPassPrerequisites(): void {
    return;
  }

  getPassPrerequisites(): Set<string> {
    return this.prerequisites;
  }

  static _getPassPrerequisites(): Set<string> {
    const mapper = new this();
    mapper.addInitialPassPrerequisites();
    return mapper.getPassPrerequisites();
  }

  commonVisit(node: ASTNode, ast: AST): void {
    // The slice is for consistency if the node is modified during visiting
    // If you want to add a new child during a visit, and then visit it, you must call dispatchVisit on it yourself
    node.children.slice().forEach((child) => this.dispatchVisit(child, ast));
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const mapper = new this();
      mapper.dispatchVisit(root, ast);
    });
    return ast;
  }
}

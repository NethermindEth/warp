import assert from 'assert';
import { ElementaryTypeName, TypeName, typeNameToTypeNode } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

class AssertTypeStrings extends ASTMapper {
  visitTypeName(node: TypeName, ast: AST): void {
    this.commonVisit(node, ast);
    assert(node.typeString !== undefined, 'Undefined typestring found for TypeName');
  }
}

export class TypeStringsChecker extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>(['Tf', 'Tnr', 'Ru', 'Fm', 'Ss']);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitElementaryTypeName(node: ElementaryTypeName, _ast: AST): void {
    if (node.typeString === undefined) {
      node.typeString = typeNameToTypeNode(node).pp();
    }
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const mapper = new this();
      mapper.dispatchVisit(root, ast);
    });

    ast.roots.forEach((root) => {
      const mapper = new AssertTypeStrings();
      mapper.dispatchVisit(root, ast);
    });
    return ast;
  }
}

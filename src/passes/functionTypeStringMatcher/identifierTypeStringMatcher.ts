import { ASTMapper } from '../../ast/mapper';

import { Identifier, VariableDeclaration, DataLocation } from 'solc-typed-ast';
import { AST } from '../../ast/ast';

export class IdentifierTypeStringMatcher extends ASTMapper {
  constructor(private declarations: Map<VariableDeclaration, boolean>) {
    super();
  }
  visitIdentifier(node: Identifier, _ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      this.declarations.has(node.vReferencedDeclaration)
    ) {
      const typeString = node.vReferencedDeclaration.typeString;
      if (node.vReferencedDeclaration.storageLocation !== DataLocation.Default) {
        node.typeString = `${typeString} ${node.vReferencedDeclaration.storageLocation}`;
        console.log(node.id, node.vReferencedDeclaration.id, node.typeString);
      }
    }
  }
}

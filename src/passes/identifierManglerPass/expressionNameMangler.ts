import {
  UserDefinedTypeName,
  Identifier,
  MemberAccess,
  VariableDeclaration,
  FunctionDefinition,
  StructDefinition,
  EnumValue,
  UserDefinedValueTypeDefinition,
  ExternalReferenceType,
  ImportDirective,
  EventDefinition,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class ExpressionNameMangler extends ASTMapper {
  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof UserDefinedValueTypeDefinition ||
      node.vReferencedDeclaration instanceof StructDefinition
    ) {
      node.name = node.vReferencedDeclaration.name;
    }

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (
      node.vIdentifierType === ExternalReferenceType.UserDefined &&
      (node.vReferencedDeclaration instanceof VariableDeclaration ||
        node.vReferencedDeclaration instanceof EventDefinition ||
        (node.vReferencedDeclaration instanceof FunctionDefinition &&
          !(node.parent instanceof ImportDirective)))
    ) {
      node.name = node.vReferencedDeclaration.name;
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.commonVisit(node, ast);
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) {
      // No declaration means this is a solidity internal identifier
      return;
    } else if (
      declaration instanceof FunctionDefinition ||
      declaration instanceof VariableDeclaration ||
      declaration instanceof EnumValue
    ) {
      node.memberName = declaration.name;
    }
  }
}

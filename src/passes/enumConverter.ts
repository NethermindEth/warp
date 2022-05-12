import {
  EnumDefinition,
  enumToIntType,
  Identifier,
  MemberAccess,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { generateVariableDeclarationTypeString } from '../utils/getTypeString';
import { createNumberLiteral } from '../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../utils/utils';

export class EnumConverter extends ASTMapper {
  getEnumValue(node: EnumDefinition, memberName: string): number {
    const val = node.vMembers.map((ev) => ev.name).indexOf(memberName);
    if (val < 0) {
      throw new TranspileFailedError(`${memberName} is not a member of ${node.name}`);
    }
    return val;
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vType instanceof UserDefinedTypeName) {
      const enumDef = node.vType.vReferencedDeclaration;
      if (enumDef instanceof EnumDefinition) {
        const replacementIntType = enumToIntType(enumDef);
        const replacementIntTypeName = typeNameFromTypeNode(replacementIntType, ast);
        ast.replaceNode(node.vType, replacementIntTypeName);
        node.typeString = generateVariableDeclarationTypeString(replacementIntTypeName);
      }
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.vExpression instanceof Identifier) {
      const enumDef = node.vExpression.vReferencedDeclaration;
      if (enumDef instanceof EnumDefinition) {
        // replace member access node with literal
        const intLiteral = this.getEnumValue(enumDef, node.memberName);
        ast.replaceNode(node, createNumberLiteral(intLiteral, ast));
      }
    }
  }
}

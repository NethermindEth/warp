import {
  EnumDefinition,
  enumToIntType,
  Expression,
  getNodeType,
  Identifier,
  Literal,
  LiteralKind,
  MemberAccess,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { toHexString, typeNameFromTypeNode } from '../utils/utils';

export class EnumConverter extends ASTMapper {
  getEnumValue(node: EnumDefinition, memberName: string): number {
    const val = node.vMembers.map((ev) => ev.name).indexOf(memberName);
    if (val < 0) {
      throw new TranspileFailedError(`${memberName} is not a member of ${node.name}`);
    }
    return val;
  }

  replacementTypeString(enumDef: EnumDefinition): string {
    return enumToIntType(enumDef).pp();
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vType instanceof UserDefinedTypeName) {
      const enumDef = node.vType.vReferencedDeclaration;
      if (enumDef instanceof EnumDefinition) {
        const replacementIntType = enumToIntType(enumDef);
        const replacementIntTypeName = typeNameFromTypeNode(replacementIntType, ast);
        ast.replaceNode(node.vType, replacementIntTypeName);

        const replacementTypeString = replacementIntType.pp();
        node.typeString = replacementTypeString;
      }
    }
  }

  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const nType = getNodeType(node, ast.compilerVersion);
    if (nType instanceof UserDefinedType) {
      const enumDef = nType.definition;
      if (enumDef instanceof EnumDefinition) {
        node.typeString = this.replacementTypeString(enumDef);
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
        const intLiteralString = intLiteral.toString();
        ast.replaceNode(
          node,
          new Literal(
            ast.reserveId(),
            node.src,
            'Literal',
            `int_const ${intLiteral}`,
            LiteralKind.Number,
            toHexString(intLiteralString),
            intLiteralString,
            undefined,
            node.raw,
          ),
        );
      }
    }
  }
}

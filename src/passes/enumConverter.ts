import {
  ContractDefinition,
  EnumDefinition,
  enumToIntType,
  Identifier,
  Literal,
  LiteralKind,
  MemberAccess,
  SourceUnit,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { toHexString, typeNameFromTypeNode } from '../utils/utils';

export class EnumConverter extends ASTMapper {
  // Enum ID -> Enum member name -> Integer literal
  enumToMemberToIntLiteral: { [id: number]: { [id: string]: number } } = {};
  // ID of declared var of enum type -> integer typestring
  // Typestring is subsequently used by getNodeType in implicitConversionToExplicit pass
  enumVarDeclToIntTypestring: { [id: number]: string } = {};

  visitEnumDefinition(node: EnumDefinition, ast: AST): void {
    const enumValues: { [id: string]: number } = {};
    node.vMembers.forEach((member, idx) => {
      enumValues[member.name] = idx;
    });
    this.enumToMemberToIntLiteral[node.id] = enumValues;
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vType instanceof UserDefinedTypeName) {
      const enumDef = node.vType.vReferencedDeclaration;
      if (enumDef instanceof EnumDefinition) {
        const replacementIntType = enumToIntType(enumDef);
        const replacementIntTypeName = typeNameFromTypeNode(replacementIntType, ast);
        ast.replaceNode(node.vType, replacementIntTypeName);
        this.enumVarDeclToIntTypestring[node.id] = replacementIntType.pp();
      }
    }
    this.commonVisit(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.vExpression instanceof Identifier) {
      const referencedDeclarationId = node.vExpression.referencedDeclaration;
      if (referencedDeclarationId in this.enumToMemberToIntLiteral) {
        // replace member access node with literal
        const intLiteral = this.enumToMemberToIntLiteral[referencedDeclarationId][node.memberName];
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

  visitIdentifier(node: Identifier, ast: AST): void {
    this.commonVisit(node, ast);
    const referencedDeclarationId = node.referencedDeclaration;
    if (referencedDeclarationId in this.enumVarDeclToIntTypestring) {
      node.typeString = this.enumVarDeclToIntTypestring[referencedDeclarationId];
    }
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Guarantee contract enum definitions and state variable declarations
    // are visited before use
    node.vEnums.forEach((n) => this.visitEnumDefinition(n, ast));
    node.vStateVariables.forEach((n) => this.visitVariableDeclaration(n, ast));
    this.commonVisit(node, ast);
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    // Guarantee file level enum definitions and variable declarations
    // are visited before use
    node.vEnums.forEach((n) => this.visitEnumDefinition(n, ast));
    node.vVariables.forEach((n) => this.visitVariableDeclaration(n, ast));
    node.vContracts.forEach((n) => this.visitContractDefinition(n, ast));
    this.commonVisit(node, ast);
  }
}

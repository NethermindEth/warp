import {
  ArrayType,
  ElementaryTypeName,
  EnumDefinition,
  enumToIntType,
  Expression,
  FunctionType,
  getNodeType,
  Identifier,
  MappingType,
  MemberAccess,
  PointerType,
  TupleType,
  TypeName,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import assert from 'assert';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { createNumberLiteral } from '../utils/nodeTemplates';

export class EnumConverter extends ASTMapper {
  getEnumValue(node: EnumDefinition, memberName: string): number {
    const val = node.vMembers.map((ev) => ev.name).indexOf(memberName);
    if (val < 0) {
      throw new TranspileFailedError(`${memberName} is not a member of ${node.name}`);
    }
    return val;
  }

  visitTypeName(node: TypeName, ast: AST): void {
    this.commonVisit(node, ast);
    const tNode = getNodeType(node, ast.compilerVersion);
    const replacementNode = replaceEnumType(tNode);
    if (tNode.pp() !== replacementNode.pp()) {
      node.typeString = generateExpressionTypeString(replacementNode);
    }
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const tNode = getNodeType(node, ast.compilerVersion);
    assert(tNode instanceof UserDefinedType, 'Expected UserDefinedType');
    if (!(tNode.definition instanceof EnumDefinition)) return;
    const newTypeString = generateExpressionTypeString(replaceEnumType(tNode));
    ast.replaceNode(node, new ElementaryTypeName(node.id, node.src, newTypeString, newTypeString));
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    this.commonVisit(node, ast);
    const typeNode = replaceEnumType(getNodeType(node, ast.compilerVersion));
    node.typeString = generateExpressionTypeString(typeNode);
  }

  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const typeNode = replaceEnumType(getNodeType(node, ast.compilerVersion));
    node.typeString = generateExpressionTypeString(typeNode);
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

function replaceEnumType(type: TypeNode): TypeNode {
  if (type instanceof ArrayType) {
    return new ArrayType(replaceEnumType(type.elementT), type.size, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(replaceEnumType),
      type.returns.map(replaceEnumType),
      type.visibility,
      type.mutability,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(
      replaceEnumType(type.keyType),
      replaceEnumType(type.valueType),
      type.src,
    );
  } else if (type instanceof PointerType) {
    return new PointerType(replaceEnumType(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(replaceEnumType), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(replaceEnumType(type.type), type.src);
  } else if (type instanceof UserDefinedType) {
    if (type.definition instanceof EnumDefinition) return enumToIntType(type.definition);
    else return type;
  } else return type;
}

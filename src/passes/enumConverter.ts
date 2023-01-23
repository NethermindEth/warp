import {
  ArrayType,
  ElementaryTypeName,
  EnumDefinition,
  enumToIntType,
  Expression,
  FunctionType,
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
  FunctionCall,
  FunctionCallKind,
  ElementaryTypeNameExpression,
  StringLiteralType,
} from 'solc-typed-ast';
import assert from 'assert';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { generateExpressionTypeStringForASTNode } from '../utils/getTypeString';
import { createNumberLiteral } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

export class EnumConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  getEnumValue(node: EnumDefinition, memberName: string): number {
    const val = node.vMembers.map((ev) => ev.name).indexOf(memberName);
    if (val < 0) {
      throw new TranspileFailedError(`${memberName} is not a member of ${node.name}`);
    }
    return val;
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);
    if (node.kind !== FunctionCallKind.TypeConversion) return;
    const tNode = safeGetNodeType(node.vExpression, ast.inference);
    assert(
      tNode instanceof TypeNameType,
      `Got non-typename type ${tNode.pp()} when parsing conversion function
     ${node.vFunctionName}`,
    );
    if (
      (node.vExpression instanceof Identifier &&
        node.vExpression.vReferencedDeclaration instanceof EnumDefinition) ||
      (node.vExpression instanceof MemberAccess &&
        node.vExpression.vReferencedDeclaration instanceof EnumDefinition)
    ) {
      node.vExpression.typeString = generateExpressionTypeStringForASTNode(
        node,
        replaceEnumType(tNode),
        ast.inference,
      );
      ast.replaceNode(
        node.vExpression,
        new ElementaryTypeNameExpression(
          node.vExpression.id,
          node.vExpression.src,
          node.vExpression.typeString,
          new ElementaryTypeName(
            ast.reserveId(),
            node.vExpression.vReferencedDeclaration.src,
            node.vExpression.typeString,
            node.vExpression.typeString,
          ),
        ),
      );
    }
  }

  visitTypeName(node: TypeName, ast: AST): void {
    this.commonVisit(node, ast);
    const tNode = safeGetNodeType(node, ast.inference);
    const replacementNode = replaceEnumType(tNode);
    if (tNode.pp() !== replacementNode.pp()) {
      node.typeString = generateExpressionTypeStringForASTNode(
        node,
        replacementNode,
        ast.inference,
      );
    }
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const tNode = safeGetNodeType(node, ast.inference);
    assert(tNode instanceof UserDefinedType, 'Expected UserDefinedType');
    if (!(tNode.definition instanceof EnumDefinition)) return;
    const newTypeString = generateExpressionTypeStringForASTNode(
      node,
      replaceEnumType(tNode),
      ast.inference,
    );
    ast.replaceNode(node, new ElementaryTypeName(node.id, node.src, newTypeString, newTypeString));
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    this.commonVisit(node, ast);
    const typeNode = replaceEnumType(safeGetNodeType(node, ast.inference));
    node.typeString = generateExpressionTypeStringForASTNode(node, typeNode, ast.inference);
  }

  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof StringLiteralType) {
      return;
    }
    const typeNode = replaceEnumType(type);
    node.typeString = generateExpressionTypeStringForASTNode(node, typeNode, ast.inference);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    const baseType = safeGetNodeType(node.vExpression, ast.inference);
    if (
      type instanceof UserDefinedType &&
      type.definition instanceof EnumDefinition &&
      baseType instanceof TypeNameType &&
      baseType.type instanceof UserDefinedType &&
      baseType.type.definition instanceof EnumDefinition
    ) {
      const intLiteral = this.getEnumValue(type.definition, node.memberName);
      ast.replaceNode(
        node,
        createNumberLiteral(intLiteral, ast, enumToIntType(type.definition).pp()),
      );
      return;
    }
    this.visitExpression(node, ast);
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

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
  FunctionCall,
  FunctionCallKind,
  ElementaryTypeNameExpression,
} from 'solc-typed-ast';
import assert from 'assert';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { createNumberLiteral } from '../utils/nodeTemplates';

export class EnumConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
      'Rv',
      'If',
      'T',
      'U',
      'V',
      'Vs',
      'I',
      'Dh',
      'Rf',
      'Abc',
    ]);
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
    const tNode = getNodeType(node.vExpression, ast.compilerVersion);
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
      node.vExpression.typeString = generateExpressionTypeString(replaceEnumType(tNode));
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
    const type = getNodeType(node, ast.compilerVersion);
    const baseType = getNodeType(node.vExpression, ast.compilerVersion);
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

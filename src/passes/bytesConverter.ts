import {
  ArrayType,
  ElementaryTypeName,
  Expression,
  FixedBytesType,
  getNodeType,
  IntType,
  PointerType,
  typeNameToTypeNode,
  TupleType,
  VariableDeclaration,
  FunctionType,
  MappingType,
  TypeNameType,
  TypeNode,
  TypeName,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { generateExpressionTypeString } from '../utils/getTypeString';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
    This pass currently does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class BytesConverter extends ASTMapper {
  visitExpression(node: Expression, ast: AST): void {
    const typeNode = replaceFixedBytesType(getNodeType(node, ast.compilerVersion));
    node.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const typeNode = replaceFixedBytesType(getNodeType(node, ast.compilerVersion));
    node.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(node, ast);
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    const typeNode = typeNameToTypeNode(node);
    const replacementTypeNode = replaceFixedBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = replacementTypeNode.pp();
      node.typeString = typeString;
      node.name = typeString;
    }
    this.commonVisit(node, ast);
  }

  visitTypeName(node: TypeName, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    const replacementTypeNode = replaceFixedBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = replacementTypeNode.pp();
      node.typeString = typeString;
    }
    this.commonVisit(node, ast);
  }
}

function replaceFixedBytesType(type: TypeNode): TypeNode {
  if (type instanceof ArrayType) {
    return new ArrayType(replaceFixedBytesType(type.elementT), type.size, type.src);
  } else if (type instanceof FixedBytesType) {
    return new IntType(type.size * 8, false, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(replaceFixedBytesType),
      type.returns.map(replaceFixedBytesType),
      type.visibility,
      type.mutability,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(
      replaceFixedBytesType(type.keyType),
      replaceFixedBytesType(type.valueType),
      type.src,
    );
  } else if (type instanceof PointerType) {
    return new PointerType(replaceFixedBytesType(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(replaceFixedBytesType), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(replaceFixedBytesType(type.type), type.src);
  } else {
    return type;
  }
}

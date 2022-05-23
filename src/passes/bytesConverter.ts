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
  IndexAccess,
  Literal,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { typeNameFromTypeNode } from '../utils/utils';
import { createUint8TypeName, createUint256TypeName } from '../utils/nodeTemplates';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
    This pass currently does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class BytesConverter extends ASTMapper {
  visitExpression(node: Expression, ast: AST): void {
    const typeNode = replaceFixedBytesType(getNodeType(node, ast.compilerVersion));
    const oldTypeString = getNodeType(node, ast.compilerVersion).pp();
    node.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(node, ast);

    // Handle only BytesX type indexAccess
    // If oldTypeString doesn't starts with "bytes" then return

    if (
      !(oldTypeString.startsWith('bytes') && node instanceof IndexAccess && node.vIndexExpression)
    )
      return;

    const baseTypeName = typeNameFromTypeNode(
      getNodeType(node.vBaseExpression, ast.compilerVersion),
      ast,
    );

    if (!(baseTypeName instanceof ElementaryTypeName)) return;

    const indexTypeName =
      node.vIndexExpression instanceof Literal
        ? createUint256TypeName(ast)
        : typeNameFromTypeNode(getNodeType(node.vIndexExpression, ast.compilerVersion), ast);

    const functionStub = createCairoFunctionStub(
      indexTypeName.typeString !== 'uint256' ? 'byte_at_index' : 'byte_at_index_uint256',
      [
        ['base', baseTypeName],
        ['index', indexTypeName],
      ],
      [['res', createUint8TypeName(ast)]],
      ['bitwise_ptr', 'range_check_ptr'],
      ast,
      node,
    );
    const call = createCallToFunction(
      functionStub,
      [node.vBaseExpression, node.vIndexExpression],
      ast,
    );

    ast.registerImport(
      call,
      'warplib.maths.bytes_access',
      indexTypeName.typeString !== 'uint256' ? 'byte_at_index' : 'byte_at_index_uint256',
    );
    ast.replaceNode(node, call, node.parent);
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

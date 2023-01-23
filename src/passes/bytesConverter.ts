import {
  ArrayType,
  ElementaryTypeName,
  Expression,
  FixedBytesType,
  generalizeType,
  IntType,
  PointerType,
  TupleType,
  VariableDeclaration,
  FunctionType,
  MappingType,
  TypeNameType,
  TypeNode,
  TypeName,
  IndexAccess,
  Literal,
  BytesType,
  StringType,
  StringLiteralType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { typeNameFromTypeNode } from '../utils/utils';
import {
  createNumberLiteral,
  createUint8TypeName,
  createUint256TypeName,
  createArrayTypeName,
} from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
    This pass does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class BytesConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpression(node: Expression, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
    if (typeNode instanceof StringLiteralType) {
      return;
    }
    node.typeString = generateExpressionTypeString(replaceBytesType(typeNode));
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const typeNode = replaceBytesType(safeGetNodeType(node, ast.inference));
    node.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(node, ast);
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    const typeNode = ast.inference.typeNameToTypeNode(node);
    if (typeNode instanceof StringType || typeNode instanceof BytesType) {
      ast.replaceNode(node, createArrayTypeName(createUint8TypeName(ast), ast));
      return;
    }
    const replacementTypeNode = replaceBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = replacementTypeNode.pp();
      node.typeString = typeString;
      node.name = typeString;
    }
    this.commonVisit(node, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (
      !(
        node.vIndexExpression &&
        generalizeType(safeGetNodeType(node.vBaseExpression, ast.inference))[0] instanceof
          FixedBytesType
      )
    ) {
      this.visitExpression(node, ast);
      return;
    }

    const baseTypeName = typeNameFromTypeNode(
      safeGetNodeType(node.vBaseExpression, ast.inference),
      ast,
    );

    const width: string = baseTypeName.typeString.slice(5);

    const indexTypeName =
      node.vIndexExpression instanceof Literal
        ? createUint256TypeName(ast)
        : typeNameFromTypeNode(safeGetNodeType(node.vIndexExpression, ast.inference), ast);

    const stubParams: [string, TypeName][] = [
      ['base', baseTypeName],
      ['index', indexTypeName],
    ];
    const callArgs = [node.vBaseExpression, node.vIndexExpression];
    if (baseTypeName.typeString !== 'bytes32') {
      stubParams.push(['width', createUint8TypeName(ast)]);
      callArgs.push(createNumberLiteral(width, ast, 'uint8'));
    }

    const functionStub = createCairoFunctionStub(
      selectWarplibFunction(baseTypeName, indexTypeName),
      stubParams,
      [['res', createUint8TypeName(ast)]],
      ['bitwise_ptr', 'range_check_ptr'],
      ast,
      node,
    );
    const call = createCallToFunction(functionStub, callArgs, ast);

    ast.registerImport(
      call,
      'warplib.maths.bytes_access',
      selectWarplibFunction(baseTypeName, indexTypeName),
    );
    ast.replaceNode(node, call, node.parent);
    const typeNode = replaceBytesType(safeGetNodeType(call, ast.inference));
    call.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(call, ast);
  }

  visitTypeName(node: TypeName, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
    const replacementTypeNode = replaceBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = replacementTypeNode.pp();
      node.typeString = typeString;
    }
    this.commonVisit(node, ast);
  }
}

function replaceBytesType(type: TypeNode): TypeNode {
  if (type instanceof ArrayType) {
    return new ArrayType(replaceBytesType(type.elementT), type.size, type.src);
  } else if (type instanceof FixedBytesType) {
    return new IntType(type.size * 8, false, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(replaceBytesType),
      type.returns.map(replaceBytesType),
      type.visibility,
      type.mutability,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(
      replaceBytesType(type.keyType),
      replaceBytesType(type.valueType),
      type.src,
    );
  } else if (type instanceof PointerType) {
    return new PointerType(replaceBytesType(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(replaceBytesType), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(replaceBytesType(type.type), type.src);
  } else if (type instanceof BytesType) {
    return new ArrayType(new IntType(8, false, type.src), undefined, type.src);
  } else if (type instanceof StringType) {
    return new ArrayType(new IntType(8, false, type.src), undefined, type.src);
  } else {
    return type;
  }
}

function selectWarplibFunction(baseTypeName: TypeName, indexTypeName: TypeName): string {
  if (indexTypeName.typeString === 'uint256' && baseTypeName.typeString === 'bytes32') {
    return 'byte256_at_index_uint256';
  }
  if (indexTypeName.typeString === 'uint256') {
    return 'byte_at_index_uint256';
  }
  if (baseTypeName.typeString === 'bytes32') {
    return 'byte256_at_index';
  }
  return 'byte_at_index';
}

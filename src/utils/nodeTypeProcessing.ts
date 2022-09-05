import assert from 'assert';
import {
  AddressType,
  ArrayType,
  ASTNode,
  BoolType,
  BytesType,
  DataLocation,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  generalizeType,
  getNodeType,
  getNodeTypeInCtx,
  IntType,
  MappingType,
  PackedArrayType,
  PointerType,
  StringType,
  StructDefinition,
  TupleType,
  TypeName,
  typeNameToTypeNode,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
  variableDeclarationToTypeNode,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { TranspileFailedError } from './errors';
import { error } from './formatting';
import { getContainingSourceUnit } from './utils';

/*
Normal function calls and struct constructors require different methods for
getting the expected types of their arguments, this centralises that process
Does not handle type conversion functions, as they don't have a specific input type
*/
export function getParameterTypes(functionCall: FunctionCall, ast: AST): TypeNode[] {
  const functionType = safeGetNodeType(functionCall.vExpression, ast.compilerVersion);
  switch (functionCall.kind) {
    case FunctionCallKind.FunctionCall:
      assert(
        functionType instanceof FunctionType,
        `Expected ${printNode(functionCall.vExpression)} to be FunctionType, got ${printTypeNode(
          functionType,
        )}`,
      );
      return functionType.parameters;

    case FunctionCallKind.StructConstructorCall: {
      assert(
        functionType instanceof TypeNameType &&
          functionType.type instanceof PointerType &&
          functionType.type.to instanceof UserDefinedType,
        error(
          `TypeNode for ${printNode(
            functionCall.vExpression,
          )} was expected to be a TypeNameType(PointerType(UserDefinedType, _)), got ${printTypeNode(
            functionType,
            true,
          )}`,
        ),
      );
      const structDef = functionType.type.to.definition;
      assert(structDef instanceof StructDefinition);
      return structDef.vMembers.map(variableDeclarationToTypeNode);
    }

    case FunctionCallKind.TypeConversion:
      throw new TranspileFailedError(
        `Cannot determine specific expected input type to type conversion function ${printNode(
          functionCall,
        )}`,
      );
  }
}

export function typeNameToSpecializedTypeNode(typeName: TypeName, loc: DataLocation): TypeNode {
  return specializeType(typeNameToTypeNode(typeName), loc);
}

export function specializeType(typeNode: TypeNode, loc: DataLocation): TypeNode {
  if (typeNode instanceof PointerType) {
    assert(
      typeNode.location === loc,
      `Attempting to specialize ${typeNode.location} pointer type to ${loc}\nType:${printTypeNode(
        typeNode,
        true,
      )}`,
    );
    return typeNode;
  }
  assert(
    !(typeNode instanceof TupleType),
    'Unexpected tuple type ${printTypeNode(typeNode)} in concretization.',
  );

  if (typeNode instanceof PackedArrayType) {
    return new PointerType(typeNode, loc);
  }

  if (typeNode instanceof ArrayType) {
    const concreteElT = specializeType(typeNode.elementT, loc);

    return new PointerType(new ArrayType(concreteElT, typeNode.size), loc);
  }

  if (typeNode instanceof UserDefinedType) {
    const def = typeNode.definition;

    assert(
      def !== undefined,
      `Can't concretize user defined type ${printTypeNode(
        typeNode,
      )} with no corresponding definition.`,
    );

    if (def instanceof StructDefinition) {
      return new PointerType(typeNode, loc);
    }

    // Enums and contracts are value types
    return typeNode;
  }

  if (typeNode instanceof MappingType) {
    // Always treat map keys as in-memory copies
    const concreteKeyT = specializeType(typeNode.keyType, DataLocation.Memory);
    // The result of map indexing is always a pointer to a value that lives in storage
    const concreteValueT = specializeType(typeNode.valueType, DataLocation.Storage);
    // Maps always live in storage
    return new PointerType(new MappingType(concreteKeyT, concreteValueT), DataLocation.Storage);
  }

  // Note string literals are a special case where the location cannot be known by a function like this
  // We insert conversions around string literals based on how they are being used in implicitConversionToExplicit
  return typeNode;
}

export function intTypeForLiteral(typestring: string): IntType {
  assert(
    typestring.startsWith('int_const '),
    `Expected int literal typestring to start with "int_const ". Got ${typestring}`,
  );

  const value = BigInt(typestring.slice('int_const '.length));
  if (value >= 0) {
    const binaryLength = value.toString(2).length;
    const width = 8 * Math.ceil(binaryLength / 8);
    return new IntType(width, false);
  } else {
    // This is not the exact binary length in all cases, but it puts the values into the correct 8bit range
    const binaryLength = (-value - 1n).toString(2).length + 1;
    const width = 8 * Math.ceil(binaryLength / 8);
    return new IntType(width, true);
  }
}

export function isDynamicArray(type: TypeNode): boolean {
  return (
    (type instanceof PointerType && isDynamicArray(type.to)) ||
    (type instanceof ArrayType && type.size === undefined) ||
    type instanceof BytesType ||
    type instanceof StringType
  );
}

export function isDynamicCallDataArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.CallData &&
    isDynamicArray(type.to)
  );
}

export function isStruct(type: TypeNode): boolean {
  return (
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition) ||
    (type instanceof PointerType && isStruct(type.to))
  );
}

export function isReferenceType(type: TypeNode): boolean {
  return (
    type instanceof ArrayType ||
    type instanceof BytesType ||
    type instanceof MappingType ||
    type instanceof StringType ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition) ||
    (type instanceof PointerType && isReferenceType(type.to))
  );
}

export function isValueType(type: TypeNode): boolean {
  return !isReferenceType(type);
}

export function isDynamicStorageArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType && type.location === DataLocation.Storage && isDynamicArray(type.to)
  );
}

export function isComplexMemoryType(type: TypeNode): boolean {
  return (
    type instanceof PointerType && type.location === DataLocation.Memory && isReferenceType(type.to)
  );
}

export function isMapping(type: TypeNode): boolean {
  const [base] = generalizeType(type);
  return base instanceof MappingType;
}

export function checkableType(type: TypeNode): boolean {
  return (
    type instanceof ArrayType ||
    type instanceof BytesType ||
    type instanceof FixedBytesType ||
    (type instanceof UserDefinedType &&
      (type.definition instanceof StructDefinition || type.definition instanceof EnumDefinition)) ||
    type instanceof AddressType ||
    type instanceof IntType ||
    type instanceof BoolType ||
    type instanceof StringType
  );
}

export function getElementType(type: ArrayType | BytesType | StringType): TypeNode {
  if (type instanceof ArrayType) {
    return type.elementT;
  } else {
    return new FixedBytesType(1);
  }
}

export function getSize(type: ArrayType | BytesType | StringType): bigint | undefined {
  if (type instanceof ArrayType) {
    return type.size;
  } else {
    return undefined;
  }
}

export function isStorageSpecificType(
  type: TypeNode,
  ast: AST,
  visitedStructs: number[] = [],
): boolean {
  if (type instanceof MappingType) return true;
  if (type instanceof PointerType) return isStorageSpecificType(type.to, ast, visitedStructs);
  if (type instanceof ArrayType) return isStorageSpecificType(type.elementT, ast, visitedStructs);
  if (
    type instanceof UserDefinedType &&
    type.definition instanceof StructDefinition &&
    !visitedStructs.includes(type.definition.id)
  ) {
    visitedStructs.push(type.definition.id);
    return type.definition.vMembers.some((m) =>
      isStorageSpecificType(safeGetNodeType(m, ast.compilerVersion), ast, visitedStructs),
    );
  }
  return false;
}

export function safeGetNodeType(node: Expression | VariableDeclaration, version: string): TypeNode {
  getContainingSourceUnit(node);
  return getNodeType(node, version);
}

export function safeGetNodeTypeInCtx(
  arg: string | VariableDeclaration | Expression,
  version: string,
  ctx: ASTNode,
): TypeNode {
  getContainingSourceUnit(ctx);
  return getNodeTypeInCtx(arg, version, ctx);
}

/**
 * Given a type returns its packed solidity bytes size
 * e.g. uint8 -> byte size is 1
 *      address -> byte size is 20
 *      uint16[3] -> byte size is 6
 *      and so on
 *  For every type whose byte size can be known on compile time
 *  @param type Solidity type
 *  @param version required for calculating structs byte size
 *  @returns returns the types byte representation using packed abi encoding
 */
export function getPackedByteSize(type: TypeNode, version: string): number | bigint {
  if (type instanceof IntType) {
    return type.nBits / 8;
  }
  if (type instanceof FixedBytesType) {
    return type.size;
  }
  if (type instanceof AddressType) {
    return 20;
  }
  if (
    type instanceof BoolType ||
    (type instanceof UserDefinedType && type.definition instanceof EnumDefinition)
  ) {
    return 1;
  }

  if (type instanceof ArrayType && type.size !== undefined) {
    return type.size * BigInt(getPackedByteSize(type.elementT, version));
  }

  const sumMemberSize = (acc: bigint, cv: TypeNode): bigint => {
    return acc + BigInt(getPackedByteSize(cv, version));
  };
  if (type instanceof TupleType) {
    return type.elements.reduce(sumMemberSize, 0n);
  }

  if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    assert(version !== undefined, 'Struct byte size calculation requires compiler version');
    return type.definition.vMembers
      .map((varDecl) => getNodeType(varDecl, version))
      .reduce(sumMemberSize, 0n);
  }

  throw new TranspileFailedError(`Cannot calculate packed byte size for ${printTypeNode(type)}`);
}

/**
 * Given a type returns  solidity bytes size
 * e.g. uint8, bool, address -> byte size is 32
 *      T[] -> byte size is 32
 *      uint16[3] -> byte size is 96
 *      uint16[][3] -> byte size is 32
 *      and so on
 *  @param type Solidity type
 *  @param version parameter required for calculating struct byte size
 *  @returns returns the types byte representation using abi encoding
 */
export function getByteSize(type: TypeNode, version: string): number | bigint {
  if (isValueType(type) || isDynamicallySized(type, version)) {
    return 32;
  }

  if (type instanceof ArrayType) {
    assert(type.size !== undefined);
    return type.size * BigInt(getByteSize(type.elementT, version));
  }

  const sumMemberSize = (acc: bigint, cv: TypeNode): bigint => {
    return acc + BigInt(getByteSize(cv, version));
  };
  if (type instanceof TupleType) {
    return type.elements.reduce(sumMemberSize, 0n);
  }

  if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    assert(version !== undefined, 'Struct byte size calculation requires compiler version');
    return type.definition.vMembers
      .map((varDecl) => safeGetNodeType(varDecl, version))
      .reduce(sumMemberSize, 0n);
  }

  throw new TranspileFailedError(`Cannot calculate byte size for ${printTypeNode(type)}`);
}

export function isDynamicallySized(type: TypeNode, version: string): boolean {
  if (isDynamicArray(type)) {
    return true;
  }
  if (type instanceof PointerType) {
    return isDynamicallySized(type.to, version);
  }
  if (type instanceof ArrayType) {
    return isDynamicallySized(type.elementT, version);
  }
  if (type instanceof TupleType) {
    return type.elements.some((t) => isDynamicallySized(t, version));
  }
  if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    assert(version !== undefined);
    return type.definition.vMembers.some((v) =>
      isDynamicallySized(safeGetNodeType(v, version), version),
    );
  }
  return false;
}

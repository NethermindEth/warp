import assert from 'assert';
import {
  AddressType,
  ArrayType,
  BoolType,
  DataLocation,
  EnumDefinition,
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  generalizeType,
  getNodeType,
  IntType,
  MappingType,
  PackedArrayType,
  PointerType,
  StructDefinition,
  TupleType,
  TypeName,
  typeNameToTypeNode,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  variableDeclarationToTypeNode,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { TranspileFailedError } from './errors';
import { error } from './formatting';

/*
Normal function calls and struct constructors require different methods for
getting the expected types of their arguments, this centralises that process
Does not handle type conversion functions, as they don't have a specific input type
*/
export function getParameterTypes(functionCall: FunctionCall, ast: AST): TypeNode[] {
  const functionType = getNodeType(functionCall.vExpression, ast.compilerVersion);
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

  // TODO: What to do about string literals?
  // All other types are "value" types.
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
    const binaryLength = (-value - 1n).toString(2).length;
    const width = 8 * Math.ceil(binaryLength / 8);
    return new IntType(width, true);
  }
}

export function isDynamicCallDataArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.CallData &&
    type.to instanceof ArrayType &&
    type.to.size === undefined
  );
}

export function isReferenceType(type: TypeNode): boolean {
  return (
    type instanceof ArrayType ||
    type instanceof MappingType ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition) ||
    (type instanceof PointerType && isReferenceType(type.to))
  );
}

export function isValueType(type: TypeNode): boolean {
  return !isReferenceType(type);
}

export function isDynamicStorageArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.Storage &&
    type.to instanceof ArrayType &&
    type.to.size === undefined
  );
}

export function isComplexStorageType(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.Storage &&
    (type.to instanceof ArrayType ||
      (type.to instanceof UserDefinedType && type.to.definition instanceof StructDefinition))
  );
}

export function isComplexMemoryType(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.Memory &&
    (type.to instanceof ArrayType ||
      (type.to instanceof UserDefinedType && type.to.definition instanceof StructDefinition))
  );
}

export function isMapping(type: TypeNode): boolean {
  const [base] = generalizeType(type);
  return base instanceof MappingType;
}

export function checkableType(type: TypeNode): boolean {
  return (
    type instanceof ArrayType ||
    (type instanceof UserDefinedType &&
      (type.definition instanceof StructDefinition || type.definition instanceof EnumDefinition)) ||
    type instanceof AddressType ||
    type instanceof IntType ||
    type instanceof BoolType
  );
}

import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  getNodeType,
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
      `Attempting to specialize ${typeNode.location} pointer type to ${loc}`,
    );
    return typeNode;
  }
  assert(
    !(typeNode instanceof TupleType),
    'Unexpected tuple type ${printTypeNode(typeNode)} in concretization.',
  );

  if (
    typeNode instanceof PackedArrayType ||
    typeNode instanceof BytesType ||
    typeNode instanceof StringType
  ) {
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

import assert from 'assert';
import {
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  getNodeType,
  PointerType,
  StructDefinition,
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

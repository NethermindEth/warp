import assert from 'assert';
import {
  AddressType,
  ArrayType,
  Assignment,
  BinaryOperation,
  BoolType,
  BuiltinType,
  BytesType,
  DataLocation,
  ElementaryTypeName,
  Expression,
  ExternalReferenceType,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  generalizeType,
  getNodeType,
  ImportRefType,
  IndexAccess,
  IntLiteralType,
  IntType,
  MappingType,
  ModuleType,
  PointerType,
  RationalLiteralType,
  Return,
  StringLiteralType,
  StringType,
  TupleExpression,
  TupleType,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { NotSupportedYetError, TranspileFailedError } from '../utils/errors';
import { error } from '../utils/formatting';
import { createElementaryConversionCall } from '../utils/functionGeneration';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { getParameterTypes, intTypeForLiteral, specializeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';

/*
Detects implicit conversions by running solc-typed-ast's type analyser on
nodes and on where they're used and comparing the results. This approach is
relatively limited and does not handle tuples, which are instead processed by
TupleAssignmentSplitter. It also does not handle datalocation differences, which
are handled by the References pass

Prerequisites:
  TupleAssignmentSplitter
*/

export class ImplicitConversionToExplicit extends ASTMapper {
  visitReturn(node: Return, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vExpression == undefined) return;

    const returnDeclarations = node.vFunctionReturnParameters.vParameters;
    // Tuple returns handled by TupleAssignmentSplitter
    if (returnDeclarations.length !== 1) return;

    const expectedRetType = getNodeType(returnDeclarations[0], ast.compilerVersion);
    insertConversionIfNecessary(node.vExpression, expectedRetType, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    const resultType = getNodeType(node, ast.compilerVersion);

    if (node.operator === '<<' || node.operator === '>>') {
      insertConversionIfNecessary(node.vLeftExpression, resultType, ast);
      const rhsType = getNodeType(node.vRightExpression, ast.compilerVersion);
      if (rhsType instanceof IntLiteralType) {
        insertConversionIfNecessary(
          node.vRightExpression,
          intTypeForLiteral(node.vRightExpression.typeString),
          ast,
        );
      }
      return;
    } else if (['**', '*', '/', '%', '+', '-', '&', '^', '|', '&&', '||'].includes(node.operator)) {
      insertConversionIfNecessary(node.vLeftExpression, resultType, ast);
      insertConversionIfNecessary(node.vRightExpression, resultType, ast);
    } else if (['<', '>', '<=', '>=', '==', '!='].includes(node.operator)) {
      const targetType = pickLargerType(
        getNodeType(node.vLeftExpression, ast.compilerVersion),
        getNodeType(node.vLeftExpression, ast.compilerVersion),
      );
      insertConversionIfNecessary(node.vLeftExpression, targetType, ast);
      insertConversionIfNecessary(node.vRightExpression, targetType, ast);
    }
  }

  // Implicit conversions are not deep
  // e.g. int32 = int16 + int8 -> int32 = int32(int16 + int16(int8)), not int32(int16) + int32(int8)
  // Handle signedness conversions (careful about difference between 0.7.0 and 0.8.0)

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);

    insertConversionIfNecessary(
      node.vRightHandSide,
      getNodeType(node.vLeftHandSide, ast.compilerVersion),
      ast,
    );
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    this.commonVisit(node, ast);

    assert(
      node.vInitialValue !== undefined,
      `Implicit conversion to explicit expects variables to be initialised (did you run variable declaration initialiser?). Found at ${printNode(
        node,
      )}`,
    );
    // Assuming all variable declarations are split and have an initial value

    // VariableDeclarationExpressionSplitter must be run before this pass
    if (node.vDeclarations.length !== 1) return;

    insertConversionIfNecessary(
      node.vInitialValue,
      getNodeType(node.vDeclarations[0], ast.compilerVersion),
      ast,
    );
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.kind === FunctionCallKind.TypeConversion) {
      return;
    }

    if (node.vFunctionCallType === ExternalReferenceType.Builtin) {
      // Skip the error message associated with asserts, requires, and reverts
      if (node.vFunctionName === 'revert') {
        return;
      }
      if (['assert', 'require'].includes(node.vFunctionName) && node.vArguments.length > 1) {
        const paramType = getParameterTypes(node, ast)[0];
        insertConversionIfNecessary(node.vArguments[0], paramType, ast);
        return;
      }
      if (['push', 'pop'].includes(node.vFunctionName)) {
        const paramTypes = getParameterTypes(node, ast);
        // Solc 0.7.0 types push and pop as you would expect, 0.8.0 adds an extra initial argument
        assert(
          paramTypes.length >= node.vArguments.length,
          error(
            `${printNode(node)} has incorrect number of arguments. Expected ${
              paramTypes.length
            }, got ${node.vArguments.length}`,
          ),
        );
        node.vArguments.forEach((arg, index) => {
          const paramIndex = index + paramTypes.length - node.vArguments.length;
          insertConversionIfNecessary(arg, paramTypes[paramIndex], ast);
        });
        return;
      }
    }

    const paramTypes = getParameterTypes(node, ast);
    assert(
      paramTypes.length === node.vArguments.length,
      error(
        `${printNode(node)} has incorrect number of arguments. Expected ${paramTypes.length}, got ${
          node.vArguments.length
        }`,
      ),
    );
    node.vArguments.forEach((arg, index) =>
      insertConversionIfNecessary(arg, paramTypes[index], ast),
    );
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vIndexExpression === undefined) return;

    const [baseType, location] = generalizeType(
      getNodeType(node.vBaseExpression, ast.compilerVersion),
    );

    if (baseType instanceof MappingType) {
      insertConversionIfNecessary(node.vIndexExpression, baseType.keyType, ast);
    } else if (location === DataLocation.CallData) {
      insertConversionIfNecessary(node.vIndexExpression, new IntType(248, false), ast);
    } else {
      insertConversionIfNecessary(node.vIndexExpression, new IntType(256, false), ast);
    }
  }
}

function insertConversionIfNecessary(expression: Expression, targetType: TypeNode, ast: AST): void {
  const currentType = generalizeType(getNodeType(expression, ast.compilerVersion))[0];
  targetType = generalizeType(targetType)[0];

  if (currentType instanceof AddressType) {
    if (!(targetType instanceof AddressType)) {
      insertConversion(expression, targetType, ast);
    }
  } else if (currentType instanceof ArrayType) {
    assert(
      targetType instanceof ArrayType,
      `Unable to convert array ${printNode(expression)} to non-array type ${printTypeNode(
        targetType,
      )}`,
    );
    const elementT = targetType.elementT;
    if (currentType.pp() !== targetType.pp()) {
      assert(
        expression instanceof TupleExpression && expression.isInlineArray,
        `Unable to perform array conversion on ${printNode(expression)}, expected an inline array`,
      );
      expression.vOriginalComponents.forEach((element) => {
        assert(element !== null, `Unexpected empty slot in inline array ${printNode(expression)}`);
        insertConversionIfNecessary(element, elementT, ast);
      });
      currentType.elementT = targetType.elementT;
      // console.log(
      // `for node:`,
      // printNode(expression),
      // '\ncurrent type string:',
      // generateExpressionTypeString(specializeType(currentType, DataLocation.Memory)),
      // '\ntarget type string:',
      // generateExpressionTypeString(specializeType(targetType, DataLocation.Memory)),
      // );
      expression.typeString = generateExpressionTypeString(
        specializeType(currentType, DataLocation.Memory),
      );
    }
  } else if (currentType instanceof BoolType) {
    assert(
      targetType instanceof BoolType,
      `Unable to convert bool to ${printTypeNode(targetType)}`,
    );
    return;
  } else if (currentType instanceof BuiltinType) {
    return;
  } else if (currentType instanceof BytesType) {
    throw new NotSupportedYetError(`BytesType not supported yet`);
  } else if (currentType instanceof FixedBytesType) {
    throw new TranspileFailedError(
      `Expected FixedBytesType to have been substituted. Found at ${printNode(expression)}`,
    );
  } else if (currentType instanceof FunctionType) {
    return;
  } else if (currentType instanceof ImportRefType) {
    return;
  } else if (currentType instanceof IntLiteralType) {
    insertConversion(expression, targetType, ast);
  } else if (currentType instanceof IntType) {
    if (targetType instanceof IntType && targetType.pp() === currentType.pp()) {
      return;
    } else {
      insertConversion(expression, targetType, ast);
    }
  } else if (currentType instanceof MappingType) {
    return;
  } else if (currentType instanceof ModuleType) {
    return;
  } else if (currentType instanceof StringType) {
    // TODO bytes conversion
    return;
  } else if (currentType instanceof PointerType) {
    throw new TranspileFailedError(
      `Type conversion analysis error. Unexpected ${printTypeNode(
        currentType,
      )}, found at ${printNode(expression)}`,
    );
  } else if (currentType instanceof RationalLiteralType) {
    throw new TranspileFailedError(
      `Unexpected unresolved rational literal ${printNode(expression)}`,
    );
  } else if (currentType instanceof StringLiteralType) {
    insertConversion(expression, targetType, ast);
  } else if (currentType instanceof TupleType) {
    throw new TranspileFailedError(
      `Attempted to convert tuple ${printNode(expression)} as single value`,
    );
  } else if (currentType instanceof TypeNameType) {
    return;
  } else if (currentType instanceof UserDefinedType) {
    return;
  } else {
    throw new NotSupportedYetError(
      `Encountered unexpected type ${printTypeNode(
        currentType,
      )} during type conversion analysis at ${printNode(expression)}`,
    );
  }
}

function insertConversion(expression: Expression, targetType: TypeNode, ast: AST): void {
  const typeName = typeNameFromTypeNode(targetType, ast);
  assert(
    typeName instanceof ElementaryTypeName,
    `Attempted elementary conversion to non-elementary type ${printTypeNode(targetType)}`,
  );
  const parent = expression.parent;
  const call = createElementaryConversionCall(typeName, expression, ast);
  ast.replaceNode(expression, call, parent);
}

function pickLargerType(typeA: TypeNode, typeB: TypeNode): TypeNode {
  // Generalise the types to remove any location differences
  typeA = generalizeType(typeA)[0];
  typeB = generalizeType(typeB)[0];
  if (typeA.pp() === typeB.pp()) return typeA;

  // Literals always need to be cast to match the other type
  if (typeA instanceof IntLiteralType) {
    if (typeB instanceof IntLiteralType) {
      assert(typeA.literal, `Unexpected unencoded literal value`);
      assert(typeB.literal, `Unexpected unencoded literal value`);
      return pickLargerType(
        intTypeForLiteral(`int_const ${typeA.literal.toString()}`),
        intTypeForLiteral(`int_const ${typeB.literal.toString()}`),
      );
    } else {
      return typeB;
    }
  } else if (typeB instanceof IntLiteralType) {
    return typeA;
  }

  if (typeA instanceof ArrayType && typeB instanceof ArrayType) {
    assert(
      typeA.size === typeB.size,
      `Unable to find a common type for arrays of mismatching lengths: ${printTypeNode(
        typeA,
      )} vs ${printTypeNode(typeB)}`,
    );

    return new ArrayType(pickLargerType(typeA.elementT, typeB.elementT), typeA.size);
  }

  throw new NotSupportedYetError(
    `Unhandled type conversion case: ${printTypeNode(typeA)} vs ${printTypeNode(typeB)}`,
  );
}

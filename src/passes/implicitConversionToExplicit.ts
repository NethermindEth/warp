import assert from 'assert';
import {
  AddressType,
  ArrayType,
  Assignment,
  ASTNode,
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
  ImportRefType,
  IndexAccess,
  IntLiteralType,
  IntType,
  Literal,
  MappingType,
  PointerType,
  RationalLiteralType,
  Return,
  StringLiteralType,
  StringType,
  TupleExpression,
  TupleType,
  TypeNameType,
  TypeNode,
  UnaryOperation,
  UserDefinedType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { NotSupportedYetError, TranspileFailedError } from '../utils/errors';
import { error } from '../utils/formatting';
import { createElementaryConversionCall } from '../utils/functionGeneration';
import { createNumberLiteral } from '../utils/nodeTemplates';
import { getParameterTypes, intTypeForLiteral, safeGetNodeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, isExternalCall } from '../utils/utils';

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
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      // Conditionals pass generates cases that need to be handled by this pass
      'Cos',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitReturn(node: Return, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vExpression === undefined) return;

    const returnDeclarations = node.vFunctionReturnParameters.vParameters;
    // Tuple returns handled by TupleAssignmentSplitter
    if (returnDeclarations.length !== 1) return;

    const expectedRetType = safeGetNodeType(returnDeclarations[0], ast.inference);
    insertConversionIfNecessary(node.vExpression, expectedRetType, node, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    const resultType = safeGetNodeType(node, ast.inference);

    if (node.operator === '<<' || node.operator === '>>') {
      insertConversionIfNecessary(node.vLeftExpression, resultType, node, ast);
      const rhsType = safeGetNodeType(node.vRightExpression, ast.inference);
      if (rhsType instanceof IntLiteralType) {
        insertConversionIfNecessary(
          node.vRightExpression,
          intTypeForLiteral(node.vRightExpression.typeString),
          node,
          ast,
        );
      }
      return;
    } else if (node.operator === '**') {
      const rightNodeType = safeGetNodeType(node.vRightExpression, ast.inference);

      insertConversionIfNecessary(node.vLeftExpression, resultType, node, ast);
      if (rightNodeType instanceof IntLiteralType) {
        const bound = getLiteralValueBound(node.vRightExpression.typeString);
        insertConversionIfNecessary(
          node.vRightExpression,
          intTypeForLiteral(`int_const ${bound}`),
          node,
          ast,
        );
      }
    } else if (['*', '/', '%', '+', '-', '&', '^', '|', '&&', '||'].includes(node.operator)) {
      insertConversionIfNecessary(node.vLeftExpression, resultType, node, ast);
      insertConversionIfNecessary(node.vRightExpression, resultType, node, ast);
    } else if (['<', '>', '<=', '>=', '==', '!='].includes(node.operator)) {
      const leftNodeType = safeGetNodeType(node.vLeftExpression, ast.inference);
      const rightNodeType = safeGetNodeType(node.vRightExpression, ast.inference);

      const targetType = pickLargerType(
        leftNodeType,
        rightNodeType,
        leftNodeType instanceof IntLiteralType
          ? getLiteralValueBound(node.vLeftExpression.typeString)
          : undefined,
        rightNodeType instanceof IntLiteralType
          ? getLiteralValueBound(node.vRightExpression.typeString)
          : undefined,
      );

      insertConversionIfNecessary(node.vLeftExpression, targetType, node, ast);
      insertConversionIfNecessary(node.vRightExpression, targetType, node, ast);
    }
  }

  // Implicit conversions are not deep
  // e.g. int32 = int16 + int8 -> int32 = int32(int16 + int16(int8)), not int32(int16) + int32(int8)
  // Handle signedness conversions (careful about difference between 0.7.0 and 0.8.0)

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);

    insertConversionIfNecessary(
      node.vRightHandSide,
      safeGetNodeType(node.vLeftHandSide, ast.inference),
      node,
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
    if (node.assignments.length !== 1) return;

    insertConversionIfNecessary(
      node.vInitialValue,
      safeGetNodeType(node.vDeclarations[0], ast.inference),
      node,
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
      // post-audit TODO fixedbytes for second argument to allow non-literals
      if (['assert', 'require'].includes(node.vFunctionName) && node.vArguments.length > 1) {
        const paramType = getParameterTypes(node, ast)[0];
        insertConversionIfNecessary(node.vArguments[0], paramType, node, ast);
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
          insertConversionIfNecessary(arg, paramTypes[paramIndex], node, ast);
        });
        return;
      }
      if (node.vFunctionName === 'concat') {
        handleConcatArgs(node, ast);
        return;
      }

      if (node.vFunctionName === 'decode') {
        assert(node.vArguments.length === 2, 'decode recieves two arguments');
        insertConversionIfNecessary(node.vArguments[0], new BytesType(), node, ast);
        return;
      }

      if (['encodePacked', 'encode'].includes(node.vFunctionName)) {
        handleAbiEncodeArgs(node.vArguments, ast);
        return;
      }
      if (['encodeWithSelector', 'encodeWithSignature'].includes(node.vFunctionName)) {
        assert(node.vArguments.length > 0, `${node.vFunctionName} requires at least one argument`);
        const targetType =
          node.vFunctionName === 'encodeWithSelector' ? new FixedBytesType(4) : new StringType();
        insertConversionIfNecessary(node.vArguments[0], targetType, node.vArguments[0], ast);
        handleAbiEncodeArgs(node.vArguments.slice(1), ast);
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
      insertConversionIfNecessary(arg, paramTypes[index], node, ast),
    );
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.commonVisit(node, ast);

    if (
      safeGetNodeType(node, ast.inference) instanceof TypeNameType ||
      node.vIndexExpression === undefined
    ) {
      return;
    }

    const [baseType, location] = generalizeType(
      safeGetNodeType(node.vBaseExpression, ast.inference),
    );

    if (baseType instanceof MappingType) {
      insertConversionIfNecessary(node.vIndexExpression, baseType.keyType, node, ast);
    } else if (
      location === DataLocation.CallData ||
      (node.vBaseExpression instanceof FunctionCall && isExternalCall(node.vBaseExpression))
    ) {
      insertConversionIfNecessary(node.vIndexExpression, new IntType(248, false), node, ast);
    } else {
      insertConversionIfNecessary(node.vIndexExpression, new IntType(256, false), node, ast);
    }
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    if (!node.isInlineArray) return this.visitExpression(node, ast);

    const type = generalizeType(safeGetNodeType(node, ast.inference))[0];

    assert(
      type instanceof ArrayType,
      `Expected inline array ${printNode(node)} to be array type, got ${printTypeNode(type)}`,
    );

    node.vComponents.forEach((element) =>
      insertConversionIfNecessary(element, type.elementT, node, ast),
    );

    this.visitExpression(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    const nodeType = safeGetNodeType(node, ast.inference);
    if (nodeType instanceof IntLiteralType) {
      node.typeString = intTypeForLiteral(
        `int_const ${getLiteralValueBound(node.typeString)}`,
      ).pp();
    }
    this.commonVisit(node, ast);
  }
}

export function insertConversionIfNecessary(
  expression: Expression,
  targetType: TypeNode,
  context: ASTNode,
  ast: AST,
): void {
  const type = safeGetNodeType(expression, ast.inference);
  const [currentType, currentLoc] = generalizeType(type);
  const generalisedTargetType = generalizeType(targetType)[0];

  if (currentType instanceof AddressType) {
    if (!(generalisedTargetType instanceof AddressType)) {
      insertConversion(expression, generalisedTargetType, context, ast);
    }
  } else if (currentType instanceof ArrayType) {
    assert(
      generalisedTargetType instanceof ArrayType,
      `Unable to convert array ${printNode(expression)} to non-array type ${printTypeNode(
        generalisedTargetType,
      )}`,
    );
    if (currentLoc === DataLocation.Memory) {
      const parent = expression.parent;
      const [replacement, shouldReplace] = ast
        .getUtilFuncGen(expression)
        .memory.convert.genIfNecesary(expression, targetType);
      if (shouldReplace) {
        ast.replaceNode(expression, replacement, parent);
      }
    }
    // if (expression instanceof TupleExpression && expression.isInlineArray) {
    //   expression.vOriginalComponents.forEach((element) => {
    //     assert(element !== null, `Unexpected empty slot in inline array ${printNode(expression)}`);
    //     insertConversionIfNecessary(element, elementT, ast);
    //   });
    //   expression.typeString = generateExpressionTypeString(
    //     specializeType(targetType, DataLocation.Memory),
    //   );
    // }
  } else if (currentType instanceof BoolType) {
    assert(
      generalisedTargetType instanceof BoolType,
      `Unable to convert bool to ${printTypeNode(generalisedTargetType)}`,
    );
    return;
  } else if (currentType instanceof BuiltinType) {
    return;
  } else if (currentType instanceof BytesType) {
    if (generalisedTargetType instanceof BytesType || generalisedTargetType instanceof StringType) {
      return;
    }
    if (generalisedTargetType instanceof FixedBytesType) {
      throw new NotSupportedYetError(
        `${printTypeNode(
          currentType,
        )} to fixed bytes type (${targetType.pp()}) not implemented yet`,
      );
    } else {
      throw new TranspileFailedError(
        `Unexpected implicit conversion from ${currentType.pp()} to ${targetType.pp()}`,
      );
    }
  } else if (currentType instanceof FixedBytesType) {
    if (generalisedTargetType instanceof BytesType || generalisedTargetType instanceof StringType) {
      insertConversionIfNecessary(expression, generalisedTargetType, context, ast);
    } else if (generalisedTargetType instanceof FixedBytesType) {
      if (currentType.size !== generalisedTargetType.size) {
        insertConversion(expression, generalisedTargetType, context, ast);
      }
    } else {
      throw new TranspileFailedError(
        `Unexpected implicit conversion from ${currentType.pp()} to ${generalisedTargetType.pp()}`,
      );
    }
  } else if (currentType instanceof FunctionType) {
    return;
  } else if (currentType instanceof ImportRefType) {
    return;
  } else if (currentType instanceof IntLiteralType) {
    insertConversion(expression, generalisedTargetType, context, ast);
  } else if (currentType instanceof IntType) {
    if (
      generalisedTargetType instanceof IntType &&
      generalisedTargetType.pp() === currentType.pp()
    ) {
      return;
    } else {
      insertConversion(expression, generalisedTargetType, context, ast);
    }
  } else if (currentType instanceof MappingType) {
    return;
  } else if (currentType instanceof StringType) {
    if (generalisedTargetType instanceof BytesType || generalisedTargetType instanceof StringType) {
      return;
    }
    if (generalisedTargetType instanceof FixedBytesType) {
      throw new NotSupportedYetError(
        `${printTypeNode(
          currentType,
        )} to fixed bytes type (${generalisedTargetType.pp()}) not implemented yet`,
      );
    } else {
      throw new TranspileFailedError(
        `Unexpected implicit conversion from ${currentType.pp()} to ${generalisedTargetType.pp()}`,
      );
    }
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
    if (generalisedTargetType instanceof FixedBytesType) {
      if (!(expression instanceof Literal)) {
        throw new TranspileFailedError(`Expected stringLiteralType expression to be a Literal`);
      }
      const padding = '0'.repeat(generalisedTargetType.size * 2 - expression.hexValue.length);
      const replacementNode = createNumberLiteral(
        `0x${expression.hexValue}${padding}`,
        ast,
        generalisedTargetType.pp(),
      );
      ast.replaceNode(expression, replacementNode, expression.parent);
      insertConversion(replacementNode, generalisedTargetType, context, ast);
    } else if (
      generalisedTargetType instanceof StringType ||
      generalisedTargetType instanceof BytesType
    ) {
      insertConversion(expression, generalisedTargetType, context, ast);
    }
    return;
  } else if (currentType instanceof TupleType) {
    if (!(targetType instanceof TupleType)) {
      throw new TranspileFailedError(
        `Attempted to convert tuple ${printNode(expression)} as single value`,
      );
    }
    return;
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

function insertConversion(
  expression: Expression,
  targetType: TypeNode,
  context: ASTNode,
  ast: AST,
): void {
  const typeName = typeNameFromTypeNode(targetType, ast);
  assert(
    typeName instanceof ElementaryTypeName,
    `Attempted elementary conversion to non-elementary type: ${safeGetNodeType(
      expression,
      ast.inference,
    ).pp()} -> ${printTypeNode(targetType)}`,
  );
  const parent = expression.parent;
  const call = createElementaryConversionCall(typeName, expression, context, ast);
  ast.replaceNode(expression, call, parent);
}

function pickLargerType(
  typeA: TypeNode,
  typeB: TypeNode,
  leftLiteralBound?: string,
  rightLiteralBound?: string,
): TypeNode {
  // Generalise the types to remove any location differences
  typeA = generalizeType(typeA)[0];
  typeB = generalizeType(typeB)[0];

  if (typeA.pp() === typeB.pp()) {
    if (typeA instanceof IntLiteralType) {
      assert(typeA.literal !== undefined, `Unexpected unencoded literal value`);
      assert(leftLiteralBound !== undefined, `Unexpected unencoded literal value`);
      return intTypeForLiteral(`int_const ${leftLiteralBound}`);
    }
    return typeA;
  }

  if (typeA instanceof AddressType && typeB instanceof AddressType) {
    // when pp() does not match, it means an address is payable and the other is
    // not. Stay with the non payable one
    return typeA.payable ? typeB : typeA;
  }

  // Literals always need to be cast to match the other type
  if (typeA instanceof IntLiteralType) {
    if (typeB instanceof IntLiteralType) {
      assert(typeA.literal !== undefined, `Unexpected unencoded literal value`);
      assert(typeB.literal !== undefined, `Unexpected unencoded literal value`);
      assert(
        leftLiteralBound !== undefined && rightLiteralBound !== undefined,
        `Unexpected literal bounds`,
      );

      return pickLargerType(
        intTypeForLiteral(`int_const ${leftLiteralBound}`),
        intTypeForLiteral(`int_const ${rightLiteralBound}`),
      );
    } else {
      return typeB;
    }
  } else if (typeB instanceof IntLiteralType) {
    return typeA;
  }

  if (typeA instanceof StringLiteralType) {
    return typeB;
  } else if (typeB instanceof StringLiteralType) {
    return typeA;
  }

  if (typeA instanceof IntType) {
    if (typeB instanceof IntType) {
      if (typeA.nBits > typeB.nBits) {
        return typeA;
      }
    }
    return typeB;
  } else if (typeB instanceof IntType) {
    return typeA;
  }

  if (typeA instanceof FixedBytesType) {
    if (typeB instanceof FixedBytesType) {
      if (typeA.size > typeB.size) {
        return typeA;
      }
    }
    return typeB;
  } else if (typeB instanceof FixedBytesType) {
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

function getLiteralValueBound(typeString: string): string {
  // remove any character that is not a digit or '('or ')' or '-'
  const cleanTypeString = typeString.replace(/[^\d()-]/g, '');

  // assert '-' is only used for negative numbers
  assert(
    cleanTypeString.indexOf('-') === -1 || cleanTypeString.indexOf('-') === 0,
    `Unexpected literal value: ${typeString}`,
  );

  // if it doesn't contain '(', it is a literal
  if (!cleanTypeString.includes('(')) {
    //assert it has no ')'
    assert(!cleanTypeString.includes(')'), `Unexpected ')' in literal value bound: ${typeString}`);
    return cleanTypeString;
  }

  // get string between '(', ')' and type-cast to int
  const literalValue = parseInt(
    cleanTypeString.substring(cleanTypeString.indexOf('(') + 1, cleanTypeString.indexOf(')')),
  );

  // replace string between '(', ')' with literal value number of zeros
  const newTypeString = cleanTypeString.replace(`(${literalValue})`, '9'.repeat(literalValue));

  const maxBound: BigInt = BigInt(`2`) ** BigInt(`256`) - BigInt(1);
  const minBound: BigInt = BigInt(`-2`) ** BigInt(`255`) + BigInt(1);

  if (maxBound < BigInt(newTypeString)) {
    // solidity doesn't support literals larger than 256 bits
    return maxBound.toString();
  }

  if (minBound > BigInt(newTypeString)) {
    // solidity doesn't support literals smaller than 255 bits
    return minBound.toString();
  }

  return newTypeString;
}

function handleConcatArgs(node: FunctionCall, ast: AST) {
  node.vArguments.forEach((arg) => {
    const type = safeGetNodeType(arg, ast.inference);
    if (type instanceof StringLiteralType) {
      const literal = (arg as Literal).value;
      if (literal.length < 32 && literal.length > 0) {
        insertConversionIfNecessary(arg, new FixedBytesType(literal.length), node, ast);
      } else {
        insertConversionIfNecessary(arg, new BytesType(), node, ast);
      }
    }
  });
}

function handleAbiEncodeArgs(args: Expression[], ast: AST) {
  args.forEach((arg) => {
    const type = safeGetNodeType(arg, ast.inference);
    if (type instanceof StringLiteralType) {
      insertConversionIfNecessary(arg, new BytesType(), arg, ast);
    } else if (type instanceof IntLiteralType) {
      assert(arg instanceof Literal);
      const signed = BigInt(arg.value) < 0;
      insertConversionIfNecessary(arg, new IntType(256, signed), arg, ast);
    }
  });
}

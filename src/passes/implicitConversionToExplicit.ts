import assert = require('assert');
import {
  Assignment,
  BinaryOperation,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionType,
  getNodeType,
  PointerType,
  UserDefinedTypeName,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError } from '../utils/errors';
import { compareTypeSize, getDeclaredTypeString } from '../utils/utils';

// TODO conclusively handle all edge cases
// TODO for example operations between literals and non-literals truncate the literal,
// they do not upcast the non-literal

export class ImplicitConversionToExplicit extends ASTMapper {
  generateExplicitConversion(typeTo: string, expression: Expression, ast: AST): FunctionCall {
    return new FunctionCall(
      ast.reserveId(),
      expression.src,
      'FunctionCall',
      typeTo,
      FunctionCallKind.TypeConversion,
      new ElementaryTypeNameExpression(
        ast.reserveId(),
        expression.src,
        'ElementaryTypeNameExpression',
        `type(${typeTo})`,
        new ElementaryTypeName(
          ast.reserveId(),
          expression.src,
          'ElementaryTypeName',
          typeTo,
          typeTo,
        ),
      ),
      [expression],
    );
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    const argTypes = [node.vLeftExpression, node.vRightExpression].map((v) =>
      getNodeType(v, ast.compilerVersion),
    );
    const res = compareTypeSize(argTypes[0], argTypes[1]);

    if (res === -1) {
      // argTypes[1] > argTypes[0]
      node.vLeftExpression = this.generateExplicitConversion(
        argTypes[1].pp(),
        node.vLeftExpression,
        ast,
      );
      ast.registerChild(node.vLeftExpression, node);
    } else if (res === 1) {
      // argTypes[0] > argTypes[1]
      node.vRightExpression = this.generateExplicitConversion(
        argTypes[0].pp(),
        node.vRightExpression,
        ast,
      );
      ast.registerChild(node.vRightExpression, node);
    }

    return;
  }

  // Implicit conversions are not deep
  // e.g. int32 = int16 + int8 -> int32 = int32(int16 + int16(int8)), not int32(int16) + int32(int8)
  // Handle signedness conversions (careful about difference between 0.7.0 and 0.8.0)

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);

    const childrenTypes = [node.vLeftHandSide, node.vRightHandSide].map((v) =>
      getNodeType(v, ast.compilerVersion),
    );
    const res = compareTypeSize(childrenTypes[0], childrenTypes[1]);
    if (res === 1) {
      // sizeof(lhs) > sizeof(rhs)
      node.vRightHandSide = this.generateExplicitConversion(
        childrenTypes[0].pp(),
        node.vRightHandSide,
        ast,
      );
      ast.registerChild(node.vRightHandSide, node);
    }
    return;
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    this.commonVisit(node, ast);

    assert(
      node.vInitialValue !== undefined,
      'Implicit conversion to explicit expects variables to be initialised (did you run variable declaration initialiser?)',
    );
    // Assuming all variable declarations are split and have an initial value

    // TODO test tuple of structs
    if (node.vInitialValue.typeString.startsWith('tuple(')) {
      assert(
        getDeclaredTypeString(node) === node.vInitialValue.typeString,
        `ImplicitConversionToExplicit expects tuple declarations to type match exactly. ${getDeclaredTypeString(
          node,
        )} != ${node.vInitialValue.typeString} at ${printNode(node)}`,
      );
      return;
    }

    const declaration = node.vDeclarations[0];

    // TODO handle or rule out implicit conversions of structs
    if (declaration.vType instanceof UserDefinedTypeName) {
      return;
    }

    const declarationType = getNodeType(declaration, ast.compilerVersion);
    const initialValType = getNodeType(node.vInitialValue, ast.compilerVersion);

    if (
      initialValType instanceof PointerType &&
      initialValType.location === declaration.storageLocation
    ) {
      if (compareTypeSize(declarationType, initialValType.to) !== 0) {
        throw new NotSupportedYetError(
          `${initialValType.pp()} to ${declarationType.pp()} (${
            declaration.storageLocation
          }) not implemented yet`,
        );
      }
      return;
    }

    const res = compareTypeSize(declarationType, initialValType);

    if (res === 1) {
      node.vInitialValue = this.generateExplicitConversion(
        declarationType.pp(),
        node.vInitialValue,
        ast,
      );
      ast.registerChild(node.vInitialValue, node);
    }

    return;
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);

    if (
      node.kind === FunctionCallKind.TypeConversion ||
      node.vReferencedDeclaration === undefined
    ) {
      return;
    }

    if (node.kind === FunctionCallKind.StructConstructorCall) {
      if (node.vArguments.length === 0) return;
      throw new NotSupportedYetError(
        'Implicit conversion to explicit not supported yet for struct constructor arguments',
      );
    }

    const functionType = getNodeType(node.vExpression, ast.compilerVersion);
    assert(
      functionType instanceof FunctionType,
      `TypeNode for ${printNode(node.vExpression)} was expected to be a FunctionType, got ${
        functionType.constructor.name
      }`,
    );

    const parameters = functionType.parameters;

    //Ignore any arguments prepended by AddressArgumentPusher
    node.vArguments.slice(-parameters.length).forEach((argument, index) => {
      let argumentType = getNodeType(argument, ast.compilerVersion);
      let nonPtrParamType = parameters[index];
      while (argumentType instanceof PointerType) {
        argumentType = argumentType.to;
      }
      while (nonPtrParamType instanceof PointerType) {
        nonPtrParamType = nonPtrParamType.to;
      }

      const res = compareTypeSize(argumentType, nonPtrParamType);
      if (res !== 0) {
        ast.replaceNode(
          argument,
          this.generateExplicitConversion(parameters[index].pp(), argument, ast),
          node,
        );
      }
    });
  }
}

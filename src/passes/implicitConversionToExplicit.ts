import assert from 'assert';
import {
  ArrayType,
  Assignment,
  BinaryOperation,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  generalizeType,
  getNodeType,
  PointerType,
  Return,
  TupleType,
  TypeNode,
  UserDefinedTypeName,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError } from '../utils/errors';
import { error } from '../utils/formatting';
import { getParameterTypes } from '../utils/nodeTypeProcessing';
import { compareTypeSize, dereferenceType } from '../utils/utils';

/*
Detects implicit conversions by running solc-typed-ast's type analyser on
nodes and on where they're used and comparing the results. This approach is
relatively limited and does not handle tuples, which are instead processed by
TupleAssignmentSplitter. It also does not handle datalocation differences, which
are handled by the References pass
*/

// TODO conclusively handle all edge cases
// TODO for example operations between literals and non-literals truncate the literal,
// they do not upcast the non-literal
// TODO array conversions

export class ImplicitConversionToExplicit extends ASTMapper {
  generateExplicitConversion(typeTo: string, expression: Expression, ast: AST): FunctionCall {
    return new FunctionCall(
      ast.reserveId(),
      expression.src,
      typeTo,
      FunctionCallKind.TypeConversion,
      new ElementaryTypeNameExpression(
        ast.reserveId(),
        expression.src,
        `type(${typeTo})`,
        new ElementaryTypeName(ast.reserveId(), expression.src, typeTo, typeTo),
      ),
      [expression],
    );
  }

  visitReturn(node: Return, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vExpression == undefined) return;

    const returnDeclarations = node.vFunctionReturnParameters.vParameters;
    // Tuple returns handled by TupleExpressionSplitter
    if (returnDeclarations.length !== 1) return;

    const returnValueType = generalizeType(getNodeType(node.vExpression, ast.compilerVersion))[0];

    const expectedRetType = getNodeType(returnDeclarations[0], ast.compilerVersion);

    const res = compareTypeSize(expectedRetType, returnValueType);

    if (res == 1) {
      const castedReturnExp = this.generateExplicitConversion(
        expectedRetType.pp(),
        node.vExpression,
        ast,
      );
      node.vExpression = castedReturnExp;
      ast.registerChild(castedReturnExp, node);
    }
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.operator === '<<' || node.operator === '>>') return;

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

    // VariableDeclarationExpressionSplitter must be run before this pass
    const initialValType = getNodeType(node.vInitialValue, ast.compilerVersion);
    if (initialValType instanceof TupleType || initialValType instanceof PointerType) {
      return;
    }

    const declaration = node.vDeclarations[0];

    // Skip enums - implicit conversion is not allowed
    if (declaration.typeString.startsWith('enum ')) {
      return;
    }

    // TODO handle or rule out implicit conversions of structs
    if (declaration.vType instanceof UserDefinedTypeName) {
      return;
    }

    const declarationType = getNodeType(declaration, ast.compilerVersion);

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
    if (node.fieldNames !== undefined) {
      throw new NotSupportedYetError(`Functions with named arguments are not supported yet`);
    }
    this.commonVisit(node, ast);

    if (
      node.kind === FunctionCallKind.TypeConversion ||
      node.vReferencedDeclaration === undefined
    ) {
      return;
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
    paramTypes.forEach((paramType, index) =>
      this.processArgumentConversion(node, paramType, node.vArguments[index], ast),
    );
  }

  processArgumentConversion(
    func: FunctionCall,
    paramType: TypeNode,
    arg: Expression,
    ast: AST,
  ): void {
    const rawArgType = getNodeType(arg, ast.compilerVersion);
    if (rawArgType instanceof PointerType || rawArgType instanceof ArrayType) {
      // TODO do this properly when implementing storage <-> memory
      return;
    }
    const argumentType = dereferenceType(rawArgType);
    const nonPtrParamType = dereferenceType(paramType);

    // Skip enums - implicit conversion is not allowed
    if (nonPtrParamType.pp().startsWith('enum ')) {
      return;
    }

    const res = compareTypeSize(argumentType, nonPtrParamType);
    if (res !== 0) {
      ast.replaceNode(arg, this.generateExplicitConversion(paramType.pp(), arg, ast), func);
    }
  }
}

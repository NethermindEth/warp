import {
  BinaryOperation,
  Expression,
  Literal,
  LiteralKind,
  TupleExpression,
  UnaryOperation,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { TranspileFailedError } from '../../utils/errors';
import { createBoolLiteral, createNumberLiteral } from '../../utils/nodeTemplates';
import { unitValue } from '../../utils/utils';
import { RationalLiteral, stringToLiteralValue } from './rationalLiteral';

/*
  solidity operators which could be literal:
  (x) tuple expressions can contain literals
  -, !
  ** (exponent will always be an integer)
  *, /, %,
  +, -
  >, <, <=, >=
  ==, !=
  &&, ||

  Hence all literal nodes are of type Literal | UnaryOperation | BinaryOperation
*/

export class LiteralExpressionEvaluator extends ASTMapper {
  visitPossibleLiteralExpression(node: UnaryOperation | BinaryOperation | Literal, ast: AST): void {
    // It is sometimes possible to avoid any calculation and take the value from the type
    // This is not always possible because boolean literals do not contain their value in the type,
    // and because very large int and rational literals omit some digits
    const result = createLiteralFromType(node.typeString) ?? evaluateLiteralExpression(node);

    // TODO add generalised checking that child nodes that are removed aren't referenced elsewhere

    if (result === null) {
      this.commonVisit(node, ast);
    } else if (typeof result === 'boolean') {
      ast.replaceNode(node, createBoolLiteral(result, ast));
    } else {
      const intValue = result.toInteger();
      if (intValue === null) {
        throw new TranspileFailedError('Attempted to make node for non-integral literal');
      }

      ast.replaceNode(node, createNumberLiteral(intValue, ast));
    }
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.visitPossibleLiteralExpression(node, ast);
  }

  visitLiteral(node: Literal, ast: AST): void {
    this.visitPossibleLiteralExpression(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.visitPossibleLiteralExpression(node, ast);
  }
}

function evaluateLiteralExpression(node: Expression): RationalLiteral | boolean | null {
  if (node instanceof Literal) {
    return evaluateLiteral(node);
  } else if (node instanceof UnaryOperation) {
    return evaluateUnaryLiteral(node);
  } else if (node instanceof BinaryOperation) {
    return evaluateBinaryLiteral(node);
  } else if (node instanceof TupleExpression) {
    return evaluateTupleLiteral(node);
  } else {
    // Not a literal expression
    return null;
  }
}

function evaluateLiteral(node: Literal): RationalLiteral | boolean | null {
  // Other passes can produce numeric literals from statements that the solidity compiler does not treat as constant
  // These should not be evaluated with compile time arbitrary precision arithmetic
  // A pass could potentially evaluate them at compile time,
  // but this would purely be an optimisation and not required for correctness
  if (node.kind === LiteralKind.Number && isConstType(node.typeString)) {
    const value = stringToLiteralValue(node.value);
    return value.multiply(new RationalLiteral(BigInt(unitValue(node.subdenomination)), 1n));
  } else if (node.kind === LiteralKind.Bool) {
    return node.value === 'true';
  } else {
    return null;
  }
}

function evaluateUnaryLiteral(node: UnaryOperation): RationalLiteral | boolean | null {
  const op = evaluateLiteralExpression(node.vSubExpression);
  if (op === null) return null;

  switch (node.operator) {
    case '-':
      if (typeof op === 'boolean') {
        throw new TranspileFailedError('Attempted to apply unary numeric negation to boolean');
      }
      return op.multiply(new RationalLiteral(-1n, 1n));
    case '!':
      if (typeof op !== 'boolean') {
        throw new TranspileFailedError('Attempted to apply boolean negation to RationalLiteral');
      }
      return !op;
    default:
      return null;
  }
}

function evaluateBinaryLiteral(node: BinaryOperation): RationalLiteral | boolean | null {
  const [left, right] = [
    evaluateLiteralExpression(node.vLeftExpression),
    evaluateLiteralExpression(node.vRightExpression),
  ];
  if (left === null || right === null) {
    return null;
  } else if (typeof left === 'boolean' && typeof right === 'boolean') {
    switch (node.operator) {
      case '==':
        return left === right;
      case '!=':
        return left !== right;
      case '&&':
        return left && right;
      case '||':
        return left || right;
      default:
        throw new TranspileFailedError(`Unexpected boolean x boolean operator ${node.operator}`);
    }
  } else if (typeof left !== 'boolean' && typeof right !== 'boolean') {
    switch (node.operator) {
      case '**':
        return left.exp(right);
      case '*':
        return left.multiply(right);
      case '/':
        return left.divideBy(right);
      case '%':
        return left.mod(right);
      case '+':
        return left.add(right);
      case '-':
        return left.subtract(right);
      case '>':
        return left.greaterThan(right);
      case '<':
        return !left.greaterThan(right) && !left.equalValueOf(right);
      case '>=':
        return left.greaterThan(right) || left.equalValueOf(right);
      case '<=':
        return !left.greaterThan(right);
      case '==':
        return left.equalValueOf(right);
      case '!=':
        return !left.equalValueOf(right);
      case '<<':
        return left.shiftLeft(right);
      case '>>':
        return left.shiftRight(right);
      default:
        throw new TranspileFailedError(`Unexpected number x number operator ${node.operator}`);
    }
  } else {
    throw new TranspileFailedError('Mismatching literal arguments');
  }
}

function evaluateTupleLiteral(node: TupleExpression): RationalLiteral | boolean | null {
  if (node.vOriginalComponents.length == 1 && node.vOriginalComponents[0] !== null) {
    return evaluateLiteralExpression(node.vOriginalComponents[0]);
  }

  return null;
}

function isConstType(typeString: string): boolean {
  return typeString.startsWith('int_const') || typeString.startsWith('rational_const');
}

function createLiteralFromType(typeString: string): RationalLiteral | null {
  if (typeString.startsWith('int_const ')) {
    const valueString = typeString.substring('int_const '.length);
    const value = Number(valueString);
    if (!isNaN(value)) {
      return new RationalLiteral(BigInt(valueString), 1n);
    }
  } else if (typeString.startsWith('rational_const ')) {
    const valueString = typeString.substring('rational_const '.length);
    const numeratorString = valueString.split('/')[0].trim();
    const denominatorString = valueString.split('/')[1].trim();
    const numerator = Number(numeratorString);
    const denominator = Number(denominatorString);
    if (!isNaN(numerator) && !isNaN(denominator)) {
      return new RationalLiteral(BigInt(numeratorString), BigInt(denominatorString));
    }
  }

  return null;
}

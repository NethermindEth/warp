import {
  ASTNode,
  BinaryOperation,
  Expression,
  Literal,
  LiteralKind,
  TupleExpression,
  UnaryOperation,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../export';
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

type NodeEvaluationInfo = {
  evaluation: RationalLiteral | boolean | null;
  node: ASTNode;
};

export class LiteralExpressionEvaluator extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitPossibleLiteralExpression(node: UnaryOperation | BinaryOperation | Literal, ast: AST): void {
    // It is sometimes possible to avoid any calculation and take the value from the type
    // This is not always possible because boolean literals do not contain their value in the type,
    // and because very large int and rational literals omit some digits
    let result = createLiteralFromType(node, ast);
    if (result.evaluation === null) {
      result = evaluateLiteralExpression(node, ast);
    }

    this.commonVisit(result.node, ast);
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

function evaluateLiteralExpression(node: Expression, ast: AST): NodeEvaluationInfo {
  if (node instanceof Literal) {
    return evaluateLiteral(node, ast);
  } else if (node instanceof UnaryOperation) {
    return evaluateUnaryLiteral(node, ast);
  } else if (node instanceof BinaryOperation) {
    return evaluateBinaryLiteral(node, ast);
  } else if (node instanceof TupleExpression) {
    return evaluateTupleLiteral(node, ast);
  } else {
    // Not a literal expression
    return generateInfo(null, node, ast);
  }
}

function evaluateLiteral(node: Literal, ast: AST): NodeEvaluationInfo {
  // Other passes can produce numeric literals from statements that the solidity compiler does not treat as constant
  // These should not be evaluated with compile time arbitrary precision arithmetic
  // A pass could potentially evaluate them at compile time,
  // but this would purely be an optimisation and not required for correctness
  if (node.kind === LiteralKind.Number && isConstType(node.typeString)) {
    const value = stringToLiteralValue(node.value);
    return generateInfo(
      value.multiply(new RationalLiteral(BigInt(unitValue(node.subdenomination)), 1n)),
      node,
      ast,
    );
  } else if (node.kind === LiteralKind.Bool) {
    return generateInfo(node.value === 'true', node, ast);
  } else {
    return generateInfo(null, node, ast);
  }
}

function evaluateUnaryLiteral(node: UnaryOperation, ast: AST): NodeEvaluationInfo {
  const op = evaluateLiteralExpression(node.vSubExpression, ast);
  const evaluation = op.evaluation;
  if (evaluation === null) return generateInfo(null, node, ast);

  let result;
  switch (node.operator) {
    case '~': {
      if (typeof evaluation === 'boolean') {
        throw new TranspileFailedError('Attempted to apply unary bitwise negation to boolean');
      } else result = generateInfo(evaluation.bitwiseNegate(), node, ast);
      break;
    }
    case '-':
      if (typeof evaluation === 'boolean') {
        throw new TranspileFailedError('Attempted to apply unary numeric negation to boolean');
      } else result = generateInfo(evaluation.multiply(new RationalLiteral(-1n, 1n)), node, ast);
      break;
    case '!':
      if (typeof evaluation !== 'boolean') {
        throw new TranspileFailedError('Attempted to apply boolean negation to RationalLiteral');
      } else result = generateInfo(!evaluation, node, ast);
      break;
    default:
      return generateInfo(null, node, ast);
  }
  ast.replaceNode(node, result.node);
  return result;
}

function evaluateBinaryLiteral(node: BinaryOperation, ast: AST): NodeEvaluationInfo {
  const [left, right] = [
    evaluateLiteralExpression(node.vLeftExpression, ast),
    evaluateLiteralExpression(node.vRightExpression, ast),
  ];
  if (left.evaluation === null || right.evaluation === null) {
    // In some cases a binary expression could be calculated at
    // compile time, even when only one argument is a literal.

    const nullRightExpression = right.evaluation === null;

    const notNullMember = left.evaluation ?? right.evaluation;
    if (notNullMember === null) {
      return generateInfo(null, node, ast);
    } else if (typeof notNullMember === 'boolean') {
      let result;
      switch (node.operator) {
        case '&&': // false && x = false
          result = notNullMember
            ? generateInfo(
                null,
                nullRightExpression ? node.vRightExpression : node.vLeftExpression,
                ast,
              )
            : generateInfo(false, node, ast);
          break;
        case '||': // true || x = true
          result = !notNullMember
            ? generateInfo(
                null,
                nullRightExpression ? node.vRightExpression : node.vLeftExpression,
                ast,
              )
            : generateInfo(true, node, ast);
          break;
        default:
          if (!['==', '!='].includes(node.operator)) {
            throw new TranspileFailedError(
              `Unexpected boolean x boolean operator ${node.operator}`,
            );
          } else return generateInfo(null, node, ast);
      }
      ast.replaceNode(node, result.node);
      return result;
    } else {
      const fraction = notNullMember.toString().split('/');
      const is_zero = fraction[0] === '0';
      const is_one = fraction[0] === fraction[1];
      let result;
      switch (node.operator) {
        case '*': // 0*x = x*0 = 0
          result = is_zero
            ? generateInfo(new RationalLiteral(0n, 1n), node, ast)
            : generateInfo(null, node, ast);
          break;
        case '**': // x**0 = 1   1**x = 1
          result =
            (is_zero && right) || (is_one && left)
              ? generateInfo(new RationalLiteral(1n, 1n), node, ast)
              : generateInfo(null, node, ast);
          break;
        case '<<': // 0<<x = 0   x<<n(n>255) = 0
          result =
            (is_zero && left) || (right && notNullMember.greaterThan(new RationalLiteral(255n, 1n)))
              ? generateInfo(new RationalLiteral(0n, 1n), node, ast)
              : generateInfo(null, node, ast);
          break;
        case '>>': // 0>>x = 0   1>>x = 0
          result =
            left && (is_zero || is_one)
              ? generateInfo(new RationalLiteral(0n, 1n), node, ast)
              : generateInfo(null, node, ast);
          break;
        default: {
          const otherOp = [
            '/',
            '%',
            '+',
            '-',
            '>',
            '<',
            '>=',
            '<=',
            '==',
            '!=',
            '|',
            '&',
            '^',
            '~',
          ];
          if (!otherOp.includes(node.operator)) {
            throw new TranspileFailedError(`Unexpected number x number operator ${node.operator}`);
          } else return generateInfo(null, node, ast);
        }
      }
      ast.replaceNode(node, result.node);
      return result;
    }
  } else if (typeof left.evaluation === 'boolean' && typeof right.evaluation === 'boolean') {
    let result;
    switch (node.operator) {
      case '==':
        result = generateInfo(left.evaluation === right.evaluation, node, ast);
        break;
      case '!=':
        result = generateInfo(left.evaluation !== right.evaluation, node, ast);
        break;
      case '&&':
        result = generateInfo(left.evaluation && right.evaluation, node, ast);
        break;
      case '||':
        result = generateInfo(left.evaluation || right.evaluation, node, ast);
        break;
      default:
        throw new TranspileFailedError(`Unexpected boolean x boolean operator ${node.operator}`);
    }
    ast.replaceNode(node, result.node);
    return result;
  } else if (typeof left.evaluation !== 'boolean' && typeof right.evaluation !== 'boolean') {
    let result;
    switch (node.operator) {
      case '**':
        result = generateInfo(left.evaluation.exp(right.evaluation), node, ast);
        break;
      case '*':
        result = generateInfo(left.evaluation.multiply(right.evaluation), node, ast);
        break;
      case '/':
        result = generateInfo(left.evaluation.divideBy(right.evaluation), node, ast);
        break;
      case '%':
        result = generateInfo(left.evaluation.mod(right.evaluation), node, ast);
        break;
      case '+':
        result = generateInfo(left.evaluation.add(right.evaluation), node, ast);
        break;
      case '-':
        result = generateInfo(left.evaluation.subtract(right.evaluation), node, ast);
        break;
      case '>':
        result = generateInfo(left.evaluation.greaterThan(right.evaluation), node, ast);
        break;
      case '<':
        result = generateInfo(right.evaluation.greaterThan(left.evaluation), node, ast);
        break;
      case '>=':
        result = generateInfo(!right.evaluation.greaterThan(left.evaluation), node, ast);
        break;
      case '<=':
        result = generateInfo(!left.evaluation.greaterThan(right.evaluation), node, ast);
        break;
      case '==':
        result = generateInfo(left.evaluation.equalValueOf(right.evaluation), node, ast);
        break;
      case '!=':
        result = generateInfo(!left.evaluation.equalValueOf(right.evaluation), node, ast);
        break;
      case '<<':
        result = generateInfo(left.evaluation.shiftLeft(right.evaluation), node, ast);
        break;
      case '>>':
        result = generateInfo(left.evaluation.shiftRight(right.evaluation), node, ast);
        break;
      case '&':
        result = generateInfo(left.evaluation.bitwiseAnd(right.evaluation), node, ast);
        break;
      case '|':
        result = generateInfo(left.evaluation.bitwiseOr(right.evaluation), node, ast);
        break;
      case '^':
        result = generateInfo(left.evaluation.bitwiseXor(right.evaluation), node, ast);
        break;
      default:
        throw new TranspileFailedError(`Unexpected number x number operator ${node.operator}`);
    }
    ast.replaceNode(node, result.node);
    return result;
  } else {
    throw new TranspileFailedError('Mismatching literal arguments');
  }
}

function evaluateTupleLiteral(node: TupleExpression, ast: AST): NodeEvaluationInfo {
  if (node.vOriginalComponents.length === 1 && node.vOriginalComponents[0] !== null) {
    const result = evaluateLiteralExpression(node.vOriginalComponents[0], ast);
    ast.replaceNode(node, result.node);
    return result;
  }
  return generateInfo(null, node, ast);
}

function isConstType(typeString: string): boolean {
  return typeString.startsWith('int_const') || typeString.startsWith('rational_const');
}

function createLiteralFromType(
  node: UnaryOperation | BinaryOperation | Literal,
  ast: AST,
): NodeEvaluationInfo {
  const typeString = node.typeString;
  if (typeString.startsWith('int_const ')) {
    const valueString = typeString.substring('int_const '.length);
    const value = Number(valueString);
    if (!isNaN(value)) {
      const result = generateInfo(new RationalLiteral(BigInt(valueString), 1n), node, ast);
      ast.replaceNode(node, result.node);
      return result;
    }
  } else if (typeString.startsWith('rational_const ')) {
    const valueString = typeString.substring('rational_const '.length);
    const valueStringSplitted = valueString.split('/');
    const numeratorString = valueStringSplitted[0].trim();
    const denominatorString = valueStringSplitted[1].trim();
    const numerator = Number(numeratorString);
    const denominator = Number(denominatorString);
    if (!isNaN(numerator) && !isNaN(denominator)) {
      const result = generateInfo(
        new RationalLiteral(BigInt(numeratorString), BigInt(denominatorString)),
        node,
        ast,
      );
      ast.replaceNode(node, result.node);
      return result;
    }
  }

  return generateInfo(null, node, ast);
}

function createNumberLiteralNode(result: RationalLiteral, ast: AST): Literal {
  const intValue = result.toInteger();
  if (intValue === null) {
    throw new TranspileFailedError('Attempted to make node for non-integral literal');
  }
  return createNumberLiteral(intValue, ast);
}

function generateInfo(
  value: RationalLiteral | boolean | null,
  node: ASTNode,
  ast: AST,
): NodeEvaluationInfo {
  if (value === null) return { evaluation: value, node: node };
  else if (typeof value === 'boolean')
    return { evaluation: value, node: createBoolLiteral(value, ast) };
  else if (value instanceof RationalLiteral)
    return { evaluation: value, node: createNumberLiteralNode(value, ast) };
  else
    throw new TranspileFailedError(
      `Unexpected value type after the evaluation of ${printNode(node)}`,
    );
}

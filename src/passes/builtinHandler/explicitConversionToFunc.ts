import assert = require('assert');
import {
  AddressType,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  IntLiteralType,
  IntType,
  Literal,
  TypeNameType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { ASTMapper } from '../../ast/mapper';
import { NotSupportedYetError } from '../../utils/errors';
import { toHexString } from '../../utils/utils';
import { functionaliseIntConversion } from '../../warplib/implementations/conversions/int';

export class ExplicitConversionToFunc extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.kind !== FunctionCallKind.TypeConversion) return;
    assert(
      node.vExpression instanceof ElementaryTypeNameExpression,
      `Unexpected node type ${node.vExpression.type}`,
    );
    assert(node.vArguments.length === 1, `Expecting typeconversion to have one child`);

    // Since we are only considering type conversions typeTo will always be a TypeNameType
    const typeNameType = getNodeType(node.vExpression, ast.compilerVersion);
    assert(
      typeNameType instanceof TypeNameType,
      `Got non-typename type ${typeNameType.pp()} when parsing conversion function ${
        node.vFunctionName
      }`,
    );
    const typeTo = typeNameType.type;
    const argType = getNodeType(node.vArguments[0], ast.compilerVersion);

    if (typeTo instanceof IntType) {
      if (argType instanceof IntLiteralType) {
        ast.replaceNode(node, literalToTypedInt(node.vArguments[0], typeTo));
      } else if (argType instanceof IntType) {
        functionaliseIntConversion(node, ast);
      }
      return;
    }

    if (typeTo instanceof AddressType) {
      ast.replaceNode(node, node.vArguments[0]);
      return;
    }

    throw new NotSupportedYetError(
      `${printTypeNode(argType)} to ${printTypeNode(typeTo)} conversion not supported yet`,
    );
  }
}

// This both truncates values that are too large to fit in the given type range,
// and also converts negative literals to two's complement
function literalToTypedInt(arg: Expression, typeTo: IntType): Expression {
  assert(
    arg instanceof Literal,
    `Found non-literal ${printNode(arg)} to have literal type ${arg.typeString}`,
  );

  const value = BigInt(arg.value);
  let truncated: string;

  if (value >= 0n) {
    // Non-negative values just need to be truncated to the given bitWidth
    const bits = value.toString(2);
    truncated = BigInt(`0b${bits.slice(-typeTo.nBits)}`).toString(10);
  } else {
    // Negative values need to be converted to two's complement
    // This is done by flipping the bits, adding one, and truncating
    const absBits = (-value).toString(2);
    const allBits = `${'0'.repeat(Math.max(typeTo.nBits - absBits.length, 0))}${absBits}`;
    const inverted = `0b${[...allBits].map((c) => (c === '0' ? '1' : '0')).join('')}`;
    const twosComplement = (BigInt(inverted) + 1n).toString(2).slice(-typeTo.nBits);
    truncated = BigInt(`0b${twosComplement}`).toString(10);
  }

  arg.value = truncated;
  arg.hexValue = toHexString(truncated);
  arg.typeString = typeTo.pp();
  return arg;
}

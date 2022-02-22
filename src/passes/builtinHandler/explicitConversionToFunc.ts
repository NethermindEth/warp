import assert = require('assert');
import {
  BinaryOperation,
  BytesType,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  IntLiteralType,
  IntType,
  Literal,
  LiteralKind,
  TypeNameType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { BuiltinMapper } from '../../ast/builtinMapper';
import { printNode } from '../../utils/astPrinter';
import { NotSupportedYetError } from '../../utils/errors';
import { toHexString } from '../../utils/utils';

export class ExplicitConversionToFunc extends BuiltinMapper {
  builtinDefs = {
    felt_to_uint256: this.createBuiltInDef(
      'felt_to_uint256',
      [['in', 'felt']],
      [['out', 'uint256']],
      ['range_check_ptr'],
    ),
  };
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

    if (typeTo instanceof BytesType && argType instanceof BytesType) {
      // TODO: Implement bytes to bytes conversion
      throw new NotSupportedYetError('Bytes to bytes conversion not implemented yet');
    }

    if (typeTo instanceof IntType) {
      const typeToSize = typeTo.nBits;
      // TODO refactor repeated code
      if (argType instanceof IntLiteralType) {
        ast.replaceNode(node, literalToTypedInt(node.vArguments[0], typeTo));
      } else if (argType instanceof IntType) {
        const argTypeSize = argType.nBits;
        // TODO what if arg type size is already 256?
        if (argTypeSize <= typeToSize) {
          // We don't need to do anything for upcasting if its not being casted to a uint256
          if (typeToSize !== 256) {
            // TODO prove whether or not it's possible for something to reference this call by id
            ast.replaceNode(node, node.vArguments[0]);
            return;
          } else {
            ast.addImports({ 'warplib.maths.utils': new Set(['felt_to_uint256']) });
            ast.replaceNode(
              node.vExpression,
              new Identifier(
                ast.reserveId(),
                node.src,
                'Identifier',
                // TODO check what correct typestring should be here (is it typeTo.pp, shouldn't that always be the same?)
                node.typeString,
                'felt_to_uint256',
                this.getDefId('felt_to_uint256', ast),
              ),
            );
            return;
          }
        }

        const maskSize = '0x'.concat('f'.repeat(typeToSize / 4));

        // TODO check this logic, specifically about the type of this literal
        const maskSizeLiteral = new Literal(
          ast.reserveId(),
          node.src,
          'Literal',
          node.vArguments[0].typeString,
          LiteralKind.Number,
          // TODO test what hexstring hexadecimal number literals like this use (I think it's hex of the ascii)
          maskSize,
          maskSize,
        );

        ast.replaceNode(
          node,
          new BinaryOperation(
            ast.reserveId(),
            node.src,
            'BinaryOperation',
            typeTo.pp(),
            '&&',
            node.vArguments[0],
            maskSizeLiteral,
          ),
        );
      }
    }
    return;
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

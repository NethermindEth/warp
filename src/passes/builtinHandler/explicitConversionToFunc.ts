import assert = require('assert');
import {
  BinaryOperation,
  BytesType,
  ElementaryTypeNameExpression,
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
import { NotSupportedYetError } from '../../utils/errors';

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
      // TODO this doesn't cover all possible cases
      // e.g. literals between 2^251 and 2^256
      // TODO refactor repeated code
      // TODO conversions should be possible at compile time
      if (argType instanceof IntLiteralType) {
        if (typeToSize !== 256) {
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
        } else if (typeToSize === 256) {
          ast.addImports({ 'warplib.math.utils': new Set(['felt_to_uint256']) });
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
      if (argType instanceof IntType) {
        const argTypeSize = argType.nBits;
        // TODO what if arg type size is already 256?
        if (argTypeSize <= typeToSize) {
          // We don't need to do anything for upcasting if its not being casted to a uint256
          if (typeToSize !== 256) {
            // TODO prove whether or not it's possible for something to reference this call by id
            ast.replaceNode(node, node.vArguments[0]);
            return;
          } else {
            ast.addImports({ 'warplib.math.utils': new Set(['felt_to_uint256']) });
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

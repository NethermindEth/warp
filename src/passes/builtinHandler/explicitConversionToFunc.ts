import assert = require('assert');
import {
  AddressType,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  IntLiteralType,
  IntType,
  Literal,
  TypeNameType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { ASTMapper } from '../../ast/mapper';
import { NotSupportedYetError } from '../../utils/errors';
import { bigintToTwosComplement, toHexString } from '../../utils/utils';
import { functionaliseIntConversion } from '../../warplib/implementations/conversions/int';

export class ExplicitConversionToFunc extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.kind !== FunctionCallKind.TypeConversion || node.vExpression instanceof Identifier)
      return;
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

  const truncated = bigintToTwosComplement(BigInt(arg.value), typeTo.nBits).toString(10);

  arg.value = truncated;
  arg.hexValue = toHexString(truncated);
  arg.typeString = typeTo.pp();
  return arg;
}

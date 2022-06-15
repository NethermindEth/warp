import assert from 'assert';
import {
  AddressType,
  BytesType,
  ContractDefinition,
  ElementaryTypeNameExpression,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  generalizeType,
  getNodeType,
  IntLiteralType,
  IntType,
  Literal,
  LiteralKind,
  StringLiteralType,
  StringType,
  TypeNameType,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { ASTMapper } from '../../ast/mapper';
import { NotSupportedYetError } from '../../utils/errors';
import { createAddressTypeName, createUint256TypeName } from '../../utils/nodeTemplates';
import { bigintToTwosComplement, toHexString } from '../../utils/utils';
import { functionaliseIntConversion } from '../../warplib/implementations/conversions/int';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { functionaliseFixedBytesConversion } from '../../warplib/implementations/conversions/fixedBytes';

export class ExplicitConversionToFunc extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.kind !== FunctionCallKind.TypeConversion) return;

    const typeNameType = getNodeType(node.vExpression, ast.compilerVersion);

    assert(node.vArguments.length === 1, `Expecting typeconversion to have one child`);

    // Since we are only considering type conversions typeTo will always be a TypeNameType
    assert(
      typeNameType instanceof TypeNameType,
      `Got non-typename type ${typeNameType.pp()} when parsing conversion function ${
        node.vFunctionName
      }`,
    );

    if (
      typeNameType.type instanceof UserDefinedType &&
      typeNameType.type.definition instanceof ContractDefinition
    ) {
      const operand = node.vArguments[0];
      operand.typeString = node.typeString;
      ast.replaceNode(node, operand);
      return;
    }

    assert(
      node.vExpression instanceof ElementaryTypeNameExpression,
      `Unexpected node type ${node.vExpression.type}`,
    );
    const typeTo = generalizeType(typeNameType.type)[0];
    const argType = generalizeType(getNodeType(node.vArguments[0], ast.compilerVersion))[0];

    if (typeTo instanceof IntType) {
      if (argType instanceof FixedBytesType) {
        assert(
          typeTo.nBits === argType.size * 8,
          `Unexpected size changing ${argType.pp()}->${typeTo.pp()} conversion encountered`,
        );
        const operand = node.vArguments[0];
        operand.typeString = node.typeString;
        ast.replaceNode(node, operand);
      } else if (argType instanceof IntLiteralType) {
        ast.replaceNode(node, literalToTypedInt(node.vArguments[0], typeTo));
      } else if (argType instanceof IntType) {
        functionaliseIntConversion(node, ast);
      } else if (argType instanceof AddressType) {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'felt_to_uint256',
            [['address_arg', createAddressTypeName(false, ast)]],
            [['uint_ret', createUint256TypeName(ast)]],
            [],
            ast,
            node,
          ),
          [node.vArguments[0]],
          ast,
        );

        ast.replaceNode(node, replacementCall);
        ast.registerImport(replacementCall, 'warplib.maths.utils', 'felt_to_uint256');
      } else {
        throw new NotSupportedYetError(
          `Unexpected type ${printTypeNode(argType)} in uint256 conversion`,
        );
      }
      return;
    }

    if (typeTo instanceof AddressType) {
      if (
        (argType instanceof IntType && argType.nBits == 256) ||
        (argType instanceof FixedBytesType && argType.size === 32)
      ) {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'uint256_to_address_felt',
            [['uint_arg', createUint256TypeName(ast)]],
            [['address_ret', createAddressTypeName(false, ast)]],
            [],
            ast,
            node,
          ),
          [node.vArguments[0]],
          ast,
        );

        ast.replaceNode(node, replacementCall);
        ast.registerImport(replacementCall, 'warplib.maths.utils', 'uint256_to_address_felt');
      } else {
        ast.replaceNode(node, node.vArguments[0]);
      }
      return;
    }

    if (typeTo instanceof FixedBytesType) {
      if (argType instanceof AddressType) {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'felt_to_uint256',
            [['address_arg', createAddressTypeName(false, ast)]],
            [['uint_ret', createUint256TypeName(ast)]],
            [],
            ast,
            node,
          ),
          [node.vArguments[0]],
          ast,
        );

        ast.replaceNode(node, replacementCall);
        ast.registerImport(replacementCall, 'warplib.maths.utils', 'felt_to_uint256');
        return;
      } else if (argType instanceof BytesType) {
        throw new NotSupportedYetError(
          `Runtime conversion of ${argType.pp()} to ${typeTo.pp()} not supported yet`,
        );
      } else if (argType instanceof FixedBytesType) {
        functionaliseFixedBytesConversion(node, ast);
        return;
      } else if (argType instanceof IntLiteralType) {
        ast.replaceNode(node, literalToFixedBytes(node.vArguments[0], typeTo));
        return;
      } else if (argType instanceof IntType) {
        assert(
          typeTo.size * 8 >= argType.nBits,
          `Unexpected narrowing ${argType.pp()}->${typeTo.pp()} conversion encountered`,
        );
        const operand = node.vArguments[0];
        operand.typeString = node.typeString;
        ast.replaceNode(node, operand);
        return;
      } else if (argType instanceof StringLiteralType) {
        const replacement = literalToFixedBytes(node.vArguments[0], typeTo);
        ast.replaceNode(node, replacement);
        return;
      }
    }

    if (typeTo instanceof BytesType || typeTo instanceof StringType) {
      if (argType instanceof BytesType || argType instanceof StringType) {
        const operand = node.vArguments[0];
        operand.typeString = node.typeString;
        ast.replaceNode(node, operand);
        return;
      }
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

function literalToFixedBytes(arg: Expression, typeTo: FixedBytesType): Expression {
  assert(
    arg instanceof Literal,
    `Found non-literal ${printNode(arg)} to have literal type ${arg.typeString}`,
  );

  if (arg.kind === LiteralKind.HexString || arg.kind === LiteralKind.String) {
    if (arg.hexValue.length < typeTo.size * 2) {
      arg.hexValue = `${arg.hexValue}${'0'.repeat(typeTo.size * 2 - arg.hexValue.length)}`;
    }
  }

  arg.typeString = typeTo.pp();
  return arg;
}

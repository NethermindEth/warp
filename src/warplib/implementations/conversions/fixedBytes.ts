import assert from 'assert';
import { FixedBytesType, FunctionCall, generalizeType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printTypeNode, printNode } from '../../../utils/astPrinter';
import { createCairoFunctionStub, createCallToFunction } from '../../../utils/functionGeneration';
import { createNumberLiteral, createUint8TypeName } from '../../../utils/nodeTemplates';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../../utils/utils';

export function functionaliseFixedBytesConversion(conversion: FunctionCall, ast: AST): void {
  const arg = conversion.vArguments[0];
  const fromType = generalizeType(safeGetNodeType(arg, ast.inference))[0];
  assert(
    fromType instanceof FixedBytesType,
    `Argument of fixed bytes conversion expected to be fixed bytes type. Got ${printTypeNode(
      fromType,
    )} at ${printNode(conversion)}`,
  );
  const toType = safeGetNodeType(conversion, ast.inference);
  assert(
    toType instanceof FixedBytesType,
    `Fixed bytes conversion expected to be fixed bytes type. Got ${printTypeNode(
      toType,
    )} at ${printNode(conversion)}`,
  );

  if (fromType.size < toType.size) {
    const fullName = `warp_bytes_widen${toType.size === 32 ? '_256' : ''}`;
    const stub = createCairoFunctionStub(
      fullName,
      [
        ['op', typeNameFromTypeNode(fromType, ast)],
        ['widthDiff', createUint8TypeName(ast)],
      ],
      [['res', typeNameFromTypeNode(toType, ast)]],
      toType.size === 32 ? ['range_check_ptr'] : [],
      ast,
      conversion,
    );

    const call = createCallToFunction(
      stub,
      [arg, createNumberLiteral(8 * (toType.size - fromType.size), ast, 'uint8')],
      ast,
    );

    ast.replaceNode(conversion, call);
    ast.registerImport(call, `warplib.maths.bytes_conversions`, fullName);
    return;
  } else if (fromType.size === toType.size) {
    ast.replaceNode(conversion, arg);
    return;
  } else {
    const fullName = `warp_bytes_narrow${fromType.size === 32 ? '_256' : ''}`;
    const stub = createCairoFunctionStub(
      fullName,
      [
        ['op', typeNameFromTypeNode(fromType, ast)],
        ['widthDiff', createUint8TypeName(ast)],
      ],
      [['res', typeNameFromTypeNode(toType, ast)]],
      fromType.size === 32 ? ['range_check_ptr'] : ['bitwise_ptr'],
      ast,
      conversion,
    );

    const call = createCallToFunction(
      stub,
      [arg, createNumberLiteral(8 * (fromType.size - toType.size), ast, 'uint8')],
      ast,
    );

    ast.replaceNode(conversion, call);
    ast.registerImport(call, `warplib.maths.bytes_conversions`, fullName);
    return;
  }
}

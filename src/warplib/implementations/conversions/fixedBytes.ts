import assert from 'assert';
import { FixedBytesType, FunctionCall, generalizeType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printTypeNode, printNode } from '../../../utils/astPrinter';
import { createCallToFunction } from '../../../utils/functionGeneration';
import { BYTES_CONVERSIONS } from '../../../utils/importPaths';
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
    const importedFunc = ast.registerImport(
      conversion,
      BYTES_CONVERSIONS,
      fullName,
      [
        ['op', typeNameFromTypeNode(fromType, ast)],
        ['widthDiff', createUint8TypeName(ast)],
      ],
      [['res', typeNameFromTypeNode(toType, ast)]],
    );

    const call = createCallToFunction(
      importedFunc,
      [arg, createNumberLiteral(8 * (toType.size - fromType.size), ast, 'uint8')],
      ast,
    );

    ast.replaceNode(conversion, call);
    return;
  } else if (fromType.size === toType.size) {
    ast.replaceNode(conversion, arg);
    return;
  } else {
    const fullName = `warp_bytes_narrow${fromType.size === 32 ? '_256' : ''}`;
    const importedFunc = ast.registerImport(
      conversion,
      BYTES_CONVERSIONS,
      fullName,
      [
        ['op', typeNameFromTypeNode(fromType, ast)],
        ['widthDiff', createUint8TypeName(ast)],
      ],
      [['res', typeNameFromTypeNode(toType, ast)]],
    );

    const call = createCallToFunction(
      importedFunc,
      [arg, createNumberLiteral(8 * (fromType.size - toType.size), ast, 'uint8')],
      ast,
    );

    ast.replaceNode(conversion, call);
    return;
  }
}

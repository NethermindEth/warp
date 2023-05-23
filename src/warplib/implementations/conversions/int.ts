import assert from 'assert';
import { FunctionCall, generalizeType, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { createCallToFunction, createNumberTypeName } from '../../../export';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { CUTOFF_DOWNCAST, SIGNED_UPCAST, UPCAST } from '../../../utils/importPaths';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';

const cairoWidths = [8, 16, 32, 64, 128, 256];

export function functionaliseIntConversion(conversion: FunctionCall, ast: AST): void {
  const arg = conversion.vArguments[0];
  const fromType = generalizeType(safeGetNodeType(arg, ast.inference))[0];
  assert(
    fromType instanceof IntType,
    `Argument of int conversion expected to be int type. Got ${printTypeNode(
      fromType,
    )} at ${printNode(conversion)}`,
  );
  const toType = safeGetNodeType(conversion, ast.inference);
  assert(
    toType instanceof IntType,
    `Int conversion expected to be int type. Got ${printTypeNode(toType)} at ${printNode(
      conversion,
    )}`,
  );

  const fromCairoWidth = cairoWidths.find((x) => x >= fromType.nBits)!;
  const toCairoWidth = cairoWidths.find((x) => x >= toType.nBits)!;

  if (fromCairoWidth === toCairoWidth) {
    return;
  }
  let functionPath: [string[], string];
  if (fromCairoWidth < toCairoWidth) {
    functionPath = fromType.signed ? SIGNED_UPCAST : UPCAST;
  } else {
    functionPath = CUTOFF_DOWNCAST;
  }
  const functionDef = ast.registerImport(
    conversion,
    ...functionPath,
    [['from', createNumberTypeName(fromType.nBits, fromType.signed, ast)]],
    [['to', createNumberTypeName(toType.nBits, toType.signed, ast)]],
  );
  const functionCall = createCallToFunction(functionDef, conversion.vArguments, ast);
  ast.replaceNode(conversion, functionCall);
}

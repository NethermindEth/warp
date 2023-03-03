import { DataLocation, FixedBytesType, FunctionCall } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { createCallToFunction, ParameterInfo } from '../../../utils/functionGeneration';
import {
  createBytesTypeName,
  createNumberLiteral,
  createUint8TypeName,
} from '../../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../../utils/utils';

export function functionaliseBytesToFixedBytes(
  node: FunctionCall,
  targetType: FixedBytesType,
  ast: AST,
): void {
  const wide = targetType.size === 32;
  const funcName = wide ? 'wm_bytes_to_fixed32' : 'wm_bytes_to_fixed';
  const args: ParameterInfo[] = wide
    ? [['bytesLoc', createBytesTypeName(ast), DataLocation.Memory]]
    : [
        ['bytesLoc', createBytesTypeName(ast), DataLocation.Memory],
        ['width', createUint8TypeName(ast)],
      ];

  const importedFunc = ast.registerImport(node, ['warplib', 'memory'], funcName, args, [
    ['res', typeNameFromTypeNode(targetType, ast)],
  ]);

  const replacement = createCallToFunction(
    importedFunc,
    wide
      ? node.vArguments
      : [...node.vArguments, createNumberLiteral(targetType.size, ast, 'uint8')],
    ast,
  );
  ast.replaceNode(node, replacement);
}

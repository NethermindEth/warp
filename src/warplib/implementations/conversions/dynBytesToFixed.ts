import {
  DataLocation,
  FixedBytesType,
  FunctionCall,
  FunctionStateMutability,
  TypeName,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { createCairoFunctionStub, createCallToFunction } from '../../../utils/functionGeneration';
import { Implicits } from '../../../utils/implicits';
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
  const args: ([string, TypeName] | [string, TypeName, DataLocation])[] = wide
    ? [['bytesLoc', createBytesTypeName(ast), DataLocation.Memory]]
    : [
        ['bytesLoc', createBytesTypeName(ast), DataLocation.Memory],
        ['width', createUint8TypeName(ast)],
      ];
  const implicits: Implicits[] = wide ? ['range_check_ptr', 'warp_memory'] : ['warp_memory'];

  const stub = createCairoFunctionStub(
    funcName,
    args,
    [['res', typeNameFromTypeNode(targetType, ast)]],
    implicits,
    ast,
    node,
    { mutability: FunctionStateMutability.Pure },
  );

  const replacement = createCallToFunction(
    stub,
    wide
      ? node.vArguments
      : [...node.vArguments, createNumberLiteral(targetType.size, ast, 'uint8')],
    ast,
  );
  ast.replaceNode(node, replacement);
  ast.registerImport(replacement, 'warplib.memory', `wm_bytes_to_fixed${wide ? '32' : ''}`);
}

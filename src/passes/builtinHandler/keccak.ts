import { DataLocation, ExternalReferenceType, FunctionCall } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createArrayTypeName, createUintNTypeName } from '../../utils/nodeTemplates';

export class Keccak extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      !(
        node.vFunctionName === 'keccak256' &&
        node.vFunctionCallType === ExternalReferenceType.Builtin
      )
    ) {
      return this.commonVisit(node, ast);
    }

    const warpKeccak = createCairoFunctionStub(
      'warp_keccak',
      [['input', createArrayTypeName(createUintNTypeName(8, ast), ast), DataLocation.Memory]],
      [['hash', createUintNTypeName(256, ast)]],
      ['range_check_ptr', 'bitwise_ptr', 'warp_memory', 'keccak_ptr'],
      ast,
      node,
    );

    ast.registerImport(node, 'warplib.keccak', 'warp_keccak');

    ast.replaceNode(node, createCallToFunction(warpKeccak, node.vArguments, ast));
  }
}

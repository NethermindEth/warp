import { FunctionCall } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesNTypeName, createUintNTypeName } from '../../utils/nodeTemplates';

export class Ecrecover extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.vFunctionName !== 'ecrecover') return;

    const ecrecoverEth = createCairoFunctionStub(
      'ecrecover_eth',
      [
        ['msg_hash', createBytesNTypeName(32, ast)],
        ['v', createUintNTypeName(8, ast)],
        ['r', createBytesNTypeName(32, ast)],
        ['s', createBytesNTypeName(32, ast)],
      ],
      [['eth_address', createUintNTypeName(160, ast)]],
      ['range_check_ptr', 'bitwise_ptr', 'keccak_ptr'],
      ast,
      node,
    );

    ast.registerImport(node, 'warplib.ecrecover', 'ecrecover_eth');

    ast.replaceNode(node, createCallToFunction(ecrecoverEth, node.vArguments, ast));
  }
}

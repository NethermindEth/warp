import { ExternalReferenceType, FunctionCall } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUintNTypeName } from '../../utils/nodeTemplates';

export class Ecrecover extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      !(
        node.vFunctionName === 'ecrecover' &&
        node.vFunctionCallType === ExternalReferenceType.Builtin
      )
    ) {
      return this.commonVisit(node, ast);
    }

    const ecrecoverEth = ast.registerImport(
      node,
      'warplib.ecrecover',
      'ecrecover_eth',
      [
        ['msg_hash', createUintNTypeName(256, ast)],
        ['v', createUintNTypeName(8, ast)],
        ['r', createUintNTypeName(256, ast)],
        ['s', createUintNTypeName(256, ast)],
      ],
      [['eth_address', createUintNTypeName(160, ast)]],
    );
    ast.replaceNode(node, createCallToFunction(ecrecoverEth, node.vArguments, ast));
  }
}

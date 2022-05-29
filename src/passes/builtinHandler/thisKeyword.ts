import { Identifier } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createAddressTypeName } from '../../utils/nodeTemplates';

export class ThisKeyword extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    if (node.name === 'this') {
      const replacementCall = createCallToFunction(
        createCairoFunctionStub(
          'get_contract_address',
          [],
          [['address', createAddressTypeName(false, ast)]],
          ['syscall_ptr'],
          ast,
          node,
        ),
        [],
        ast,
      );
      ast.replaceNode(node, replacementCall);
      ast.registerImport(
        replacementCall,
        'starkware.starknet.common.syscalls',
        'get_contract_address',
      );
    } else {
      return;
    }
  }
}

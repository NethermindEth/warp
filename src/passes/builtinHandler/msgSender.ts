import { MemberAccess, Identifier } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createAddressNonPayableTypeName } from '../../utils/nodeTemplates';

export class MsgSender extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'msg' &&
      node.memberName === 'sender'
    ) {
      const replacementCall = createCallToFunction(
        createCairoFunctionStub(
          'get_caller_address',
          [],
          [['address', createAddressNonPayableTypeName(ast)]],
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
        'get_caller_address',
      );
    } else {
      // This pass is specifically searching for msg.sender, a.msg.sender should be ignored, so don't recurse
      return;
    }
  }
}

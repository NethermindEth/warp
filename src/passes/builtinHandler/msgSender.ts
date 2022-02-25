import { MemberAccess, Identifier } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToStub } from '../../utils/functionStubbing';
import { createAddressNonPayableTypeName } from '../../utils/nodeTemplates';

export class MsgSender extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'msg' &&
      node.memberName === 'sender'
    ) {
      ast.addImports({
        'starkware.starknet.common.syscalls': new Set(['get_caller_address']),
      });
      ast.replaceNode(
        node,
        createCallToStub(
          createCairoFunctionStub(
            'get_caller_address',
            [],
            [['address', createAddressNonPayableTypeName(ast)]],
            ['syscall_ptr'],
            ast,
          ),
          [],
          ast,
        ),
      );
    } else {
      // This pass is specifically searching for msg.sender, a.msg.sender should be ignored, so don't recurse
      return;
    }
  }
}

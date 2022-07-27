import { MemberAccess, Identifier, ExternalReferenceType } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createAddressTypeName } from '../../utils/nodeTemplates';

export class MsgSender extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'msg' &&
      node.vExpression.vIdentifierType === ExternalReferenceType.Builtin &&
      node.memberName === 'sender'
    ) {
      const replacementCall = createCallToFunction(
        createCairoFunctionStub(
          'get_caller_address',
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
        'get_caller_address',
      );
    }
    // This pass is specifically searching for msg.sender, a.msg.sender should be ignored, so don't recurse
    this.visitExpression(node, ast);
  }
}

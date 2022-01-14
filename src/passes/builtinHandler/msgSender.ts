import { MemberAccess, Identifier, FunctionCallKind, FunctionCall } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { BuiltinMapper } from '../../ast/builtinMapper';

export class MsgSender extends BuiltinMapper {
  builtinDefs = {
    // This is only called via BuiltinMapper, and only once
    get_caller_address: this.createBuiltInDef(
      'get_caller_address',
      [],
      [['address', 'address']],
      ['syscall_ptr'],
    ),
  };

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
        new FunctionCall(
          ast.reserveId(),
          node.src,
          'FunctionCall',
          'address',
          FunctionCallKind.FunctionCall,
          new Identifier(
            ast.reserveId(),
            node.src,
            'Identifier',
            'address',
            'get_caller_address',
            this.getDefId('get_caller_address', ast),
            node.raw,
          ),
          [],
          [],
          node.raw,
        ),
      );
    } else {
      // This pass is specifically searching for msg.sender, a.msg.sender should be ignored, so don't recurse
      return;
    }
  }
}

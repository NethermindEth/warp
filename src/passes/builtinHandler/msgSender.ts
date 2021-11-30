import { ASTNode, MemberAccess, Identifier, FunctionCall, FunctionCallKind } from 'solc-typed-ast';
import {BuiltinMapper} from '../../ast/builtinMapper';

export class MsgSender extends BuiltinMapper {
  builtinDefs = {
    "get_caller_address": {name: "get_caller_address", src: "msg.sender", args: [], returns: [{name: "ret", typeString: "felt"}]},
  }

  visitMemberAccess(node: MemberAccess): ASTNode {
    this.addImport({
      'starkware.starknet.common.syscalls': new Set(['get_caller_address']),
    });
    if (
      node.memberName === 'sender' &&
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'msg'
    ) {
      return new FunctionCall(
        this.genId(),
        node.src,
        'FunctionCall',
        'address',
        FunctionCallKind.FunctionCall,
        new Identifier(
          this.genId(),
          node.src,
          'Identifier',
          'address',
          'get_caller_address',
          this.getDefId("get_caller_address"),
          node.raw,
        ),
        [],
        undefined,
        node.raw,
      );
    } else {
      return node;
    }
  }
}

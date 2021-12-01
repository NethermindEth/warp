import {
  ASTNode,
  MemberAccess,
  Identifier,
  FunctionCall,
  FunctionDefinition,
  FunctionCallKind,
  ElementaryTypeName,
  FunctionKind,
  FunctionVisibility,
  FunctionStateMutability,
  ParameterList,
  VariableDeclaration,
  DataLocation,
  StateVariableVisibility,
  Mutability,
} from 'solc-typed-ast';
import { BuiltinMapper } from '../../ast/builtinMapper';

export class MsgSender extends BuiltinMapper {
  builtinDefs = {
    get_caller_address: () =>
      new FunctionDefinition(
        this.genId(),
        '',
        'FunctionDefinition',
        -1,
        FunctionKind.Function,
        'get_caller_address',
        false,
        FunctionVisibility.Private,
        FunctionStateMutability.NonPayable,
        false,
        new ParameterList(this.genId(), '', 'ParameterList', []),
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'address',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Internal,
            Mutability.Mutable,
            'address',
            undefined,
            new ElementaryTypeName(this.genId(), '', 'ElementaryTypeName', 'address', 'address'),
          ),
        ]),
        [],
      ),
  };

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
          this.getDefId('get_caller_address'),
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

import {
  MemberAccess,
  Identifier,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  ElementaryTypeName,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { GET_CALLER_ADDRESS, ADDRESS_INTO_FELT } from '../../utils/importPaths';
import {
  createAddressTypeName,
  createVariableDeclarationStatement,
} from '../../utils/nodeTemplates';

export class MsgSender extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'msg' &&
      node.vExpression.vIdentifierType === ExternalReferenceType.Builtin &&
      node.memberName === 'sender'
    ) {
      const replacementCall = createCallToFunction(
        ast.registerImport(
          node,
          ...GET_CALLER_ADDRESS,
          [],
          [['address', createAddressTypeName(false, ast)]],
        ),
        [],
        ast,
      );

      const IntoTrait = ast.registerImport(
        node,
        ...ADDRESS_INTO_FELT,
        [],
        [['uint256', new ElementaryTypeName(ast.reserveId(), '', 'uint256', 'uint256')]],
      );
      const asFelt = new FunctionCall(
        ast.reserveId(),
        '',
        'uint256',
        FunctionCallKind.FunctionCall,
        new MemberAccess(ast.reserveId(), '', 'uint256', replacementCall, 'into', IntoTrait.id),
        [],
      );

      ast.replaceNode(node, asFelt);
    }
    // Fine to recurse because there is a check that the member access is a Builtin. Therefor a.msg.sender should
    // not be picked up.
    this.visitExpression(node, ast);
  }
}

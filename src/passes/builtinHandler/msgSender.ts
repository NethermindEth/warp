import { MemberAccess, Identifier, ExternalReferenceType } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { getCallerAddressImport } from '../../utils/importFuncs';
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
        ast.registerImport(
          node,
          ...getCallerAddressImport(),
          [],
          [['address', createAddressTypeName(false, ast)]],
        ),
        [],
        ast,
      );
      ast.replaceNode(node, replacementCall);
    }
    // Fine to recurse because there is a check that the member access is a Builtin. Therefor a.msg.sender should
    // not be picked up.
    this.visitExpression(node, ast);
  }
}

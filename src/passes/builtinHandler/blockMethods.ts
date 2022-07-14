import { MemberAccess, Identifier, ExternalReferenceType } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberTypeName } from '../../utils/nodeTemplates';

export class BlockMethods extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'block' &&
      node.vExpression.vIdentifierType === ExternalReferenceType.Builtin
    ) {
      if (node.memberName === 'number') {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'get_block_number',
            [],
            [['block_number', createNumberTypeName(248, false, ast)]],
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
          'get_block_number',
        );
        // } else if (node.memberName === 'number')
      } else if (node.memberName === 'timestamp') {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'get_block_timestamp',
            [],
            [['block_timestamp', createNumberTypeName(248, false, ast)]],
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
          'get_block_timestamp',
        );
        // } else if (node.memberName === 'number')
      }
    } else {
      // This pass is specifically searching for msg.sender, a.msg.sender should be ignored, so don't recurse
      return;
    }
  }
}

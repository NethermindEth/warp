import { MemberAccess, Identifier, ExternalReferenceType, Expression } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';

/*
A subpass that replaces the block.timestamp and block.number methods.
In Solidity these functions return uint256, but in cairo these will return felts.
Therefore, we wrap the replacement functions in felt_to_uint256 warplib functions.
*/
export class BlockMethods extends ASTMapper {
  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.name === 'block' &&
      node.vExpression.vIdentifierType === ExternalReferenceType.Builtin
    ) {
      if (node.memberName === 'number') {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'warp_block_number',
            [],
            [['block_num', createUint256TypeName(ast)]],
            ['syscall_ptr', 'range_check_ptr'],
            ast,
            node,
          ),
          [],
          ast,
        );
        ast.replaceNode(node, replacementCall);
        ast.registerImport(replacementCall, 'warplib.block_methods', 'warp_block_number');
      } else if (node.memberName === 'timestamp') {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'warp_block_timestamp',
            [],
            [['block_timestamp', createUint256TypeName(ast)]],
            ['syscall_ptr', 'range_check_ptr'],
            ast,
            node,
          ),
          [],
          ast,
        );
        ast.replaceNode(node, replacementCall);
        ast.registerImport(replacementCall, 'warplib.block_methods', 'warp_block_timestamp');
      }
    } else {
      this.visitExpression(node, ast);
    }
  }
}

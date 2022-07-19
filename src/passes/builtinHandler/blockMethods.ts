import {
  MemberAccess,
  Identifier,
  ExternalReferenceType,
  Expression,
  getNodeType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName, createUint8TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';

/*
A subpass that replaces the block.timestamp and block.number methods.
In Solidity these functions return uint256, but in cairo these will return felts.
Therefore, we wrap the replacement functions in felt_to_uint256 warplib functions.
*/
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
            // Chosen since this will be transformed to felt, so width does not matter.
            [['block_number', createUint8TypeName(ast)]],
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
        wrapInFeltToUint256(replacementCall, ast);
      } else if (node.memberName === 'timestamp') {
        const replacementCall = createCallToFunction(
          createCairoFunctionStub(
            'get_block_timestamp',
            [],
            [['block_timestamp', createUint8TypeName(ast)]],
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
        wrapInFeltToUint256(replacementCall, ast);
      }
    } else {
      return;
    }
  }
}

function wrapInFeltToUint256(node: Expression, ast: AST): void {
  const funcStub = createCairoFunctionStub(
    'felt_to_uint256',
    [['x', typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast)]],
    [['x_', createUint256TypeName(ast)]],
    ['range_check_ptr', 'bitwise_ptr'],
    ast,
    node,
  );
  const parent = node.parent;
  const funcCall = createCallToFunction(funcStub, [node], ast);
  ast.registerImport(node, 'warplib.maths.utils', 'felt_to_uint256');
  ast.replaceNode(node, funcCall, parent);
  ast.setContextRecursive(funcCall);
}

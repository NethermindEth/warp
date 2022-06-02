import { FunctionStateMutability, generalizeType, getNodeType, MemberAccess } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { FunctionStubKind } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import { isDynamicCallDataArray } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';

export class ReturnArrayLenFunctionalizer extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      isDynamicCallDataArray(getNodeType(node.vExpression, ast.compilerVersion)) &&
      node.memberName === 'length'
    ) {
      const parent = node.parent;
      const type = generalizeType(getNodeType(node, ast.compilerVersion))[0];
      const funcStub = createCairoFunctionStub(
        'felt_to_uint256',
        [['cd_dstruct_array_len', typeNameFromTypeNode(type, ast)]],
        [['len256', typeNameFromTypeNode(type, ast)]],
        ['range_check_ptr'],
        ast,
        node,
        FunctionStateMutability.Constant,
        FunctionStubKind.FunctionDefStub,
      );

      const funcCall = createCallToFunction(funcStub, [node], ast);

      ast.registerImport(funcCall, 'warplib.maths.utils', 'felt_to_uint256');
      ast.replaceNode(node, funcCall, parent);
    }
  }
}

import { FunctionCall, getNodeType, IntType, MemberAccess } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { createNumberLiteral } from '../utils/nodeTemplates';

function calculateMin(type: IntType): string {
  if (type.signed) {
    return (-(2n ** BigInt(type.nBits - 1))).toString();
  } else {
    return '0';
  }
}

function calculateMax(type: IntType): string {
  if (type.signed) {
    return (2n ** BigInt(type.nBits - 1) - 1n).toString();
  } else {
    return (2n ** BigInt(type.nBits) - 1n).toString();
  }
}

export class IntBoundCalculator extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const nodeType = getNodeType(node, ast.compilerVersion);

    if (
      (node.memberName !== 'min' && node.memberName !== 'max') ||
      !(node.vExpression instanceof FunctionCall) ||
      node.vExpression.typeString !== `type(${node.typeString})` ||
      !(nodeType instanceof IntType)
    ) {
      return;
    }

    const valueString = node.memberName === 'min' ? calculateMin(nodeType) : calculateMax(nodeType);

    ast.replaceNode(node, createNumberLiteral(valueString, ast));
  }
}

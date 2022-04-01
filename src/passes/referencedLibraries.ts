import assert = require('assert');
import { ContractDefinition, ContractKind, FunctionCall, MemberAccess } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class ReferencedLibraries extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.vExpression instanceof MemberAccess) {
      const contractDef = new Map();

      node.vExpression.context?.map.forEach((astNode, key) => {
        if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
          contractDef.set(key, astNode);
        }
      });

      const func_id = node.vExpression.referencedDeclaration;

      contractDef.forEach((astNode, key) => {
        assert(astNode instanceof ContractDefinition);
        if (astNode.vFunctions.some((func) => func.id === func_id)) {
          const parent = node.getClosestParentByType(ContractDefinition);

          if (parent === undefined) return;

          if (!parent.linearizedBaseContracts.includes(key)) {
            parent.linearizedBaseContracts.push(key);
          }
        }
      });
    }
    this.commonVisit(node, ast);
  }
}

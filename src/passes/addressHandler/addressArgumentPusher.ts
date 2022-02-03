import {
  ContractDefinition,
  FunctionCall,
  getNodeType,
  MemberAccess,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { NotSupportedYetError } from '../../utils/errors';

// Note: This pass has been deprecated
export class AddressArgumentPusher extends ASTMapper {
  // Replaces function calls on a remote contract with the same call with the address included
  // Contract(add).func() => Contract.func
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const tpNode = getNodeType(node, ast.compilerVersion);
    if (tpNode instanceof UserDefinedType && tpNode.definition instanceof ContractDefinition) {
      //ast.replaceNode(node, node.vExpression);
      throw new NotSupportedYetError(`Unhandled remote contract call ${printNode(node)}`);
    } else if (
      node.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression instanceof FunctionCall
    ) {
      const call = node.vExpression.vExpression;
      const tpCall = getNodeType(call, ast.compilerVersion);
      if (tpCall instanceof UserDefinedType && tpCall.definition instanceof ContractDefinition) {
        //node.vArguments.unshift(call.vArguments[0]);
        //node.acceptChildren();
        throw new NotSupportedYetError(`Unhandled remote contract call ${printNode(node)}`);
      }
    }

    this.commonVisit(node, ast);
  }
}

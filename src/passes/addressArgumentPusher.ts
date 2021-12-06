import clone = require('clone');
import {
  ASTNode,
  ContractDefinition,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  MemberAccess,
  UserDefinedType,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class AddressArgumentPusher extends ASTMapper {
  // Replaces function calls on a remote contract with the same call with the address included
  // Contract(add).func() => Contract.func
  visitFunctionCall(node: FunctionCall): ASTNode {
    const tpNode = getNodeType(node, this.compilerVersion);
    if (tpNode instanceof UserDefinedType && tpNode.definition instanceof ContractDefinition) {
      return clone(node.vExpression);
    } else if (
      node.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression instanceof FunctionCall
    ) {
      const call = node.vExpression.vExpression;
      const tpCall = getNodeType(call, this.compilerVersion);
      if (tpCall instanceof UserDefinedType && tpCall.definition instanceof ContractDefinition) {
        return new FunctionCall(
          this.genId(),
          node.src,
          'FunctionCall',
          node.typeString,
          FunctionCallKind.FunctionCall,
          this.commonVisit(node.vExpression) as Expression,
          [clone(node.vExpression.vExpression.vArguments[0]), ...node.vArguments],
        );
      }
    }
    return super.commonVisit(node);
  }
}

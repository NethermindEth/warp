import clone = require('clone');
import {
  ASTNode,
  ContractDefinition,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  MemberAccess,
  TypeName,
  UserDefinedType,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class AddressEliminator extends ASTMapper {
  // Replaces `address(t)` with `t` when t is a contract type
  visitFunctionCall(node: FunctionCall): ASTNode {
    if (
      node.kind === FunctionCallKind.TypeConversion &&
      (node.vExpression as TypeName).typeString === 'type(address)'
    ) {
      const tp = getNodeType(node.vArguments[0], this.compilerVersion);
      if (tp instanceof UserDefinedType) {
        if (tp.definition instanceof ContractDefinition) {
          return super.commonVisit(node.vArguments[0]);
        }
      }
    }
    return super.commonVisit(node);
  }

  // Replaces typed identifiers with type casted versions of their address
  // Contract1 address; address.func() => Contract1(address).func()
  commonVisit(node: ASTNode): ASTNode {
    if (node instanceof Expression && !(node.parent instanceof FunctionCall)) {
      const tp = getNodeType(node, this.compilerVersion);
      if (
        tp instanceof UserDefinedType &&
        tp.definition instanceof ContractDefinition &&
        node.parent instanceof MemberAccess
      ) {
        //node is a contract with a functioncall
        return new FunctionCall(
          this.genId(),
          node.src,
          'FunctionCall',
          `contract ${tp.definition.name}`,
          FunctionCallKind.TypeConversion,
          new Identifier(
            this.genId(),
            node.src,
            node.type,
            `type(contract ${tp.definition.name})`,
            tp.definition.name,
            tp.definition.id,
          ),
          [clone(node)],
        );
      }
    }
    return super.commonVisit(node);
  }
}

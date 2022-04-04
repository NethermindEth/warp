import {
  ContractDefinition,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  MemberAccess,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

// Note: This pass has been deprecated
export class AddressEliminator extends ASTMapper {
  // Replaces `address(t)` with `t` when t is a contract type
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (
      node.kind === FunctionCallKind.TypeConversion &&
      node.vExpression.typeString === 'type(address)'
    ) {
      const tp = getNodeType(node.vArguments[0], ast.compilerVersion);
      if (tp instanceof UserDefinedType && tp.definition instanceof ContractDefinition) {
        ast.replaceNode(node, node.vArguments[0]);
      }
    }
  }

  // Replaces typed identifiers with type casted versions of their address
  // Contract1 address; address.func() => Contract1(address).func()
  visitMemberAcces(node: MemberAccess, ast: AST): void {
    const tp = getNodeType(node.vExpression, ast.compilerVersion);
    if (tp instanceof UserDefinedType && tp.definition instanceof ContractDefinition) {
      //node is a contract with a functioncall
      ast.replaceNode(
        node.vExpression,
        new FunctionCall(
          ast.reserveId(),
          node.vExpression.src,
          `contract ${tp.definition.name}`,
          FunctionCallKind.TypeConversion,
          new Identifier(
            ast.reserveId(),
            node.vExpression.src,
            `type(contract ${tp.definition.name})`,
            tp.definition.name,
            tp.definition.id,
          ),
          [node.vExpression],
        ),
      );
    }
    this.commonVisit(node, ast);
  }
}

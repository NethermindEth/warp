import {
  Block,
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  replaceNode,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropInterfaceFunctionBodies extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const contract = node.parent as ContractDefinition;
    const prev = node.vBody;
    console.log('Pass');
    console.log(prev !== undefined);
    console.log(node.getChildren());
    console.log(contract.kind);
    console.log(node.name);
    if (prev !== undefined && contract.kind == ContractKind.Interface) {
      console.log('Drop');
      ast.replaceNode(prev, new Block(ast.reserveId(), prev.src, [], prev.documentation, prev.raw));
    }
  }
}

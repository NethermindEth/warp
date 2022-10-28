import {
  ASTNode,
  ContractDefinition,
  EventDefinition,
  FunctionDefinition,
  StructDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST, ASTMapper, MANGLED_WARP, printNode, WillNotSupportError } from '../export';

export class RejectPrefix extends ASTMapper {
  forbiddenPrefix = [MANGLED_WARP];

  checkNoPrefixMatch(name: string, node: ASTNode) {
    this.forbiddenPrefix.forEach((prefix) => {
      if (name.startsWith(prefix))
        throw new WillNotSupportError(
          `Names starting with ${prefix} are not allowed in the code: ${printNode(node)}`,
          node,
        );
    });
  }

  visitStructDefinition(node: StructDefinition, ast: AST) {
    this.checkNoPrefixMatch(node.name, node);
    this.commonVisit(node, ast);
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST) {
    this.checkNoPrefixMatch(node.name, node);
    this.commonVisit(node, ast);
  }
  visitFunctionDefinition(node: FunctionDefinition, ast: AST) {
    this.checkNoPrefixMatch(node.name, node);
    this.commonVisit(node, ast);
  }
  visitContractDefinition(node: ContractDefinition, ast: AST) {
    this.checkNoPrefixMatch(node.name, node);
    this.commonVisit(node, ast);
  }
  visitEventDefinition(node: EventDefinition, ast: AST) {
    this.checkNoPrefixMatch(node.name, node);
    this.commonVisit(node, ast);
  }
}

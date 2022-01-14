import { FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

// TODO handle non-comprehensive early returns

export class ReturnInserter extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vBody === undefined) return;
    // Solidity requires functions that return values to have comprehensive explicit returns
    if (node.vReturnParameters.vParameters.length > 0) return;
    if (!node.vBody.vStatements.some((value) => value instanceof Return)) {
      const newReturn = new Return(ast.reserveId(), node.src, 'Return', node.vReturnParameters.id);
      node.vBody.appendChild(newReturn);
      ast.registerChild(newReturn, node.vBody);
    }
  }
}

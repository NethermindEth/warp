import { VariableDeclaration, WhileStatement } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { collectUnboundVariables, createOuterCall, extractToFunction } from './utils';

export class WhileLoopToFunction extends ASTMapper {
  returnFlags: Map<WhileStatement, VariableDeclaration> = new Map();

  visitWhileStatement(node: WhileStatement, ast: AST): void {
    // Visit innermost loops first
    this.commonVisit(node, ast);

    const unboundVariables = collectUnboundVariables(node);
    const functionDef = extractToFunction(node, [...unboundVariables.keys()], ast);
    const outerCall = createOuterCall(node, unboundVariables, functionDef, ast);
    ast.replaceNode(node, outerCall);
  }
}

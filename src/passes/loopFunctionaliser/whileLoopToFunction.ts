import { DoWhileStatement, FunctionDefinition, WhileStatement } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { collectUnboundVariables, createOuterCall } from '../../utils/functionGeneration';
import { createLoopCall, extractDoWhileToFunction, extractWhileToFunction } from './utils';

export class WhileLoopToFunction extends ASTMapper {
  constructor(private loopToContinueFunction: Map<number, FunctionDefinition>) {
    super();
  }

  loopToFunction(node: WhileStatement | DoWhileStatement, ast: AST): void {
    // Visit innermost loops first
    this.commonVisit(node, ast);
    const loopExtractionFn =
      node instanceof DoWhileStatement ? extractDoWhileToFunction : extractWhileToFunction;

    const unboundVariables = new Map(
      [...collectUnboundVariables(node).entries()].filter(([decl]) => !decl.stateVariable),
    );

    const functionDef = loopExtractionFn(
      node,
      [...unboundVariables.keys()],
      this.loopToContinueFunction,
      ast,
    );
    // const outerCall = createOuterCall(node, unboundVariables, functionDef, ast);
    const outerCall = createOuterCall(
      node,
      [...unboundVariables.keys()],
      createLoopCall(functionDef, [...unboundVariables.keys()], ast),
      ast,
    );
    ast.replaceNode(node, outerCall);
  }

  visitWhileStatement(node: WhileStatement, ast: AST): void {
    this.loopToFunction(node, ast);
  }

  visitDoWhileStatement(node: DoWhileStatement, ast: AST): void {
    this.loopToFunction(node, ast);
  }
}

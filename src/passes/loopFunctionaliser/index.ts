import { FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { BreakToReturn } from './breakToReturn';
import { ContinueToLoopCall } from './continueToLoopCall';
import { ForLoopToWhile } from './forLoopToWhile';
import { ReturnToBreak } from './returnToBreak';
import { WhileLoopToFunction } from './whileLoopToFunction';

export class LoopFunctionaliser extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const loopToContinueFunction: Map<number, FunctionDefinition> = new Map();

      new ForLoopToWhile().dispatchVisit(root, ast);
      new ReturnToBreak().dispatchVisit(root, ast);
      new WhileLoopToFunction(loopToContinueFunction).dispatchVisit(root, ast);
      new BreakToReturn().dispatchVisit(root, ast);
      new ContinueToLoopCall(loopToContinueFunction).dispatchVisit(root, ast);
    });
    return ast;
  }
}

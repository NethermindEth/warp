import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { BreakToReturn } from './breakToReturn';
import { ContinueToLoopCall } from './continueToLoopCall';
import { ForLoopToWhile } from './forLoopToWhile';
import { ReturnToBreak } from './returnToBreak';
import { WhileLoopToFunction } from './whileLoopToFunction';

export class LoopFunctionaliser extends ASTMapper {
  static map(ast: AST): AST {
    ast = ForLoopToWhile.map(ast);
    ast = ReturnToBreak.map(ast);
    ast = WhileLoopToFunction.map(ast);
    ast = BreakToReturn.map(ast);
    ast = ContinueToLoopCall.map(ast);
    return ast;
  }
}

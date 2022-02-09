import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { BreakToReturn } from './breakToReturn';
import { ContinueToLoopCall } from './continueToLoopCall';
import { ForLoopToWhile } from './forLoopToWhile';
import { ReturnToBreak } from './returnToBreak';
import { WhileLoopToFunction } from './whileLoopToFunction';

export class LoopFunctionaliser extends ASTMapper {
  map(ast: AST): AST {
    ast = new ForLoopToWhile().map(ast);
    ast = new ReturnToBreak().map(ast);
    ast = new WhileLoopToFunction().map(ast);
    ast = new BreakToReturn().map(ast);
    ast = new ContinueToLoopCall().map(ast);
    return ast;
  }
}

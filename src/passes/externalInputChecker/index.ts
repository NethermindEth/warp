import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { EnumBoundChecker } from './enumBoundChecker';
// import { BooleanBoundChecker } from './booleanBoundChecker';
// import { IntBoundCalculator } from '../intBoundCalculator';

export class ExternalInputChecker extends ASTMapper {
  static map(ast: AST): AST {
    //ast = IntBoundCalculator.map(ast);
    ast = EnumBoundChecker.map(ast);
    //ast = BooleanBoundChecker.map(ast);
    return ast;
  }
}

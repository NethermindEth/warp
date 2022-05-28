import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
// import { EnumBoundChecker } from './enumBoundChecker';
// import { BooleanBoundChecker } from './booleanBoundChecker';
import { IntBoundChecker } from './intBoundChecker';

export class ExternalInputChecker extends ASTMapper {
  static map(ast: AST): AST {
    ast = IntBoundChecker.map(ast);
    // ast = EnumBoundChecker.map(ast);
    // ast = BooleanBoundChecker.map(ast);
    return ast;
  }
}

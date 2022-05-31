import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { TupleFiller } from './tupleFiller';
import { TupleFlattener } from './tupleFlattener';

export class TupleFixes extends ASTMapper {
  static map(ast: AST): AST {
    TupleFlattener.map(ast);
    TupleFiller.map(ast);
    return ast;
  }
}

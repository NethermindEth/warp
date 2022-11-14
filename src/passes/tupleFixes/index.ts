import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { TupleFiller } from './tupleFiller';
import { TupleFlattener } from './tupleFlattener';

export class TupleFixes extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    TupleFlattener.map(ast);
    TupleFiller.map(ast);
    return ast;
  }
}

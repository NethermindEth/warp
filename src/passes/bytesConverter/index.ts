import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { ReplaceIndexAccessBytesConverter } from './replaceIndexAccessBytesConverter';
import { UpdateTypeStringBytesConverter } from './UpdateTypeStringBytesConverter';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
    This pass does not handle dynamically-sized bytes arrays (i.e. bytes).
*/
export class BytesConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = ReplaceIndexAccessBytesConverter.map(ast);
    ast = UpdateTypeStringBytesConverter.map(ast);
    return ast;
  }
}

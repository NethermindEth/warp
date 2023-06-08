import path from 'path';
import { SourceUnit } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { pathExists } from '../utils/fs';

export class SourceUnitPathFixer extends ASTMapper {
  constructor(private includePaths: string[]) {
    super();
  }

  async visitSourceUnit(node: SourceUnit, _ast: AST): Promise<void> {
    if (!(await pathExists(node.absolutePath))) {
      for (const prefix of this.includePaths) {
        const filePath = path.join(prefix, node.absolutePath);

        if (await pathExists(filePath)) {
          node.absolutePath = filePath;
          break;
        }
      }
    }
  }

  static map_(ast: AST, includePaths: string[]): AST {
    ast.roots.forEach((root) => {
      const mapper = new this(includePaths);
      mapper.dispatchVisit(root, ast);
    });
    return ast;
  }
}

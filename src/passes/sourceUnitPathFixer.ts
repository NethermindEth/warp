import fs from 'fs/promises';
import path from 'path';
import { SourceUnit } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class SourceUnitPathFixer extends ASTMapper {
  constructor(private includePaths: string[]) {
    super();
  }

  async visitSourceUnit(node: SourceUnit, _ast: AST): Promise<void> {
    try {
      await fs.access(node.absolutePath);
    } catch {
      for (const prefix of this.includePaths) {
        const filePath = path.join(prefix, node.absolutePath);

        try {
          await fs.access(filePath);
          node.absolutePath = filePath;
          break;
        } catch {
          // file does not exist
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

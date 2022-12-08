import fs from 'fs';
import path from 'path';
import { SourceUnit } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class SourceUnitPathFixer extends ASTMapper {
  constructor(private includePaths: string[]) {
    super();
  }

  visitSourceUnit(node: SourceUnit, _ast: AST): void {
    if (!fs.existsSync(node.absolutePath)) {
      for (const prefix of this.includePaths) {
        const filePath = path.join(prefix, node.absolutePath);
        if (fs.existsSync(filePath)) {
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

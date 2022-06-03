import { ImportDirective, SourceUnit } from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export function manglePath(path: string): string {
  return path.replaceAll('_', '__').replaceAll('-', '_');
}

export class FilePathMangler extends ASTMapper {
  visitImportDirective(node: ImportDirective, _: AST): void {
    node.absolutePath = manglePath(node.absolutePath);
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);
    node.absolutePath = manglePath(node.absolutePath);
  }
}

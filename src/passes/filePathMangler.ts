import { ImportDirective, SourceUnit } from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class FilePathMangler extends ASTMapper {
  visitImportDirective(node: ImportDirective, _: AST): void {
    node.absolutePath = node.absolutePath.replaceAll('_', '__');
    node.absolutePath = node.absolutePath.replaceAll('-', '_');
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);
    node.absolutePath = node.absolutePath.replaceAll('_', '__');
    node.absolutePath = node.absolutePath.replaceAll('-', '___');
  }
}

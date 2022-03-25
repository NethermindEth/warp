import { ASTNode } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { ArrayFunctions } from './arrayFunctions';
import { StorageDelete } from './delete';
import { ReadIdentifier } from './readIdentifier';
import { StorageRefIdentifier } from './storageRefIdentifier';
import { StorageVariableAccessRewriter } from './storageVariableAccessRewriter';

export class Storage extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const reads: Set<ASTNode> = new Set();
      const storageRefs: Set<ASTNode> = new Set();

      new ReadIdentifier(reads).dispatchVisit(root, ast);
      new StorageRefIdentifier(storageRefs).dispatchVisit(root, ast);
      new StorageDelete(storageRefs).dispatchVisit(root, ast);
      new ArrayFunctions(reads, storageRefs).dispatchVisit(root, ast);
      new StorageVariableAccessRewriter(reads, storageRefs).dispatchVisit(root, ast);
    });
    return ast;
  }
}

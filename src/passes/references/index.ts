import { ASTNode, DataLocation, Expression } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { ArrayFunctions } from './arrayFunctions';
import { StorageDelete } from './delete';
import { ExpectedLocationAnalyser } from './expectedLocationAnalyser';
import { MemoryAccessRewriter } from './memoryAccessRewriter';
import { MemoryAllocations } from './memoryAllocations';
import { MemoryRefIdentifier } from './memoryRefIdentifier';
import { ReadIdentifier } from './readIdentifier';
import { StorageRefIdentifier } from './storageRefIdentifier';
import { StorageVariableAccessRewriter } from './storageVariableAccessRewriter';

export class References extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const reads: Set<ASTNode> = new Set();
      const storageRefs: Set<ASTNode> = new Set();
      const memoryRefs: Set<ASTNode> = new Set();
      const expectedDataLocations: Map<Expression, DataLocation> = new Map();

      new ExpectedLocationAnalyser(expectedDataLocations).dispatchVisit(root, ast);
      new ReadIdentifier(reads).dispatchVisit(root, ast);
      new StorageRefIdentifier(storageRefs).dispatchVisit(root, ast);
      new MemoryRefIdentifier(memoryRefs).dispatchVisit(root, ast);
      new StorageDelete(storageRefs).dispatchVisit(root, ast);
      new ArrayFunctions(reads, storageRefs).dispatchVisit(root, ast);
      new StorageVariableAccessRewriter(reads, storageRefs, expectedDataLocations).dispatchVisit(
        root,
        ast,
      );
      new MemoryAllocations().dispatchVisit(root, ast);
      new MemoryAccessRewriter(reads, memoryRefs).dispatchVisit(root, ast);
    });
    return ast;
  }
}

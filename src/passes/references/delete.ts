import { DataLocation, UnaryOperation } from 'solc-typed-ast';
import { ReferenceSubPass } from './referenceSubPass';
import { AST } from '../../ast/ast';

export class StorageDelete extends ReferenceSubPass {
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.operator !== 'delete') return;

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (actualLoc !== DataLocation.Storage) return;

    const replacement = ast.getUtilFuncGen(node).storage.delete.gen(node.vSubExpression);
    this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
  }
}

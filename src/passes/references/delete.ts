import { DataLocation, UnaryOperation } from 'solc-typed-ast';
import { ReferenceSubPass } from './referenceSubPass';
import { AST } from '../../ast/ast';

/*
  Delete is the one operator that treats storage references as references
  and doesn't just read from them and use that value, so it is handled separately
  The generated functions overwrite the pointed-to location with zeros.

  Dynamic arrays to complex types currently pose an issue as due to the double-pointer
  nature of dynamic arrays they'll need their own implementation to delete data that
  can be pointed to by local references. For simple types they work by deleting the
  initial pointer to the array, making the data unaccessible
*/
export class StorageDelete extends ReferenceSubPass {
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.operator !== 'delete') return;

    const [actualLoc] = this.getLocations(node.vSubExpression);
    if (actualLoc !== DataLocation.Storage) return;

    const [deleteActualLoc, deleteExpectedLoc] = this.getLocations(node);

    const replacement = ast.getUtilFuncGen(node).storage.delete.gen(node.vSubExpression);
    this.replace(node, replacement, undefined, deleteActualLoc, deleteExpectedLoc, ast);
  }
}

// storage references can be made to their elements
/*
function rejectIfUnsupported(node: ASTNode, type: TypeNode, ast: AST): void {
  if (type instanceof PointerType) {
    rejectIfUnsupported(node, type.to, ast);
  } else if (type instanceof ArrayType) {
    if (type.elementT instanceof PointerType && type.size === undefined) {
      throw new NotSupportedYetError(
        `Storage deletes of dynamic arrays of complex types not supported yet. Found at ${printNode(
          node,
        )}`,
      );
    }
    rejectIfUnsupported(node, type.elementT, ast);
  } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    type.definition.vMembers.forEach((decl) =>
      rejectIfUnsupported(node, getNodeType(decl, ast.compilerVersion), ast),
    );
  }
}
*/

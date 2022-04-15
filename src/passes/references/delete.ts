import {
  ArrayType,
  ASTNode,
  DataLocation,
  getNodeType,
  PointerType,
  StructDefinition,
  TypeNode,
  UnaryOperation,
  UserDefinedType,
} from 'solc-typed-ast';
import { ReferenceSubPass } from './referenceSubPass';
import { AST } from '../../ast/ast';
import { NotSupportedYetError } from '../../utils/errors';
import { printNode } from '../../utils/astPrinter';

export class StorageDelete extends ReferenceSubPass {
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.operator !== 'delete') return;

    const [actualLoc, expectedLoc] = this.getLocations(node.vSubExpression);

    if (actualLoc !== DataLocation.Storage) return;

    rejectIfUnsupported(node, getNodeType(node.vSubExpression, ast.compilerVersion), ast);

    const replacement = ast.getUtilFuncGen(node).storage.delete.gen(node.vSubExpression);
    this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
  }
}

// Currently storage deletes do not function correctly for dynamic arrays where local
// storage references can be made to their elements
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

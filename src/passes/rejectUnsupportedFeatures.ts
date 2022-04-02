import {
  IndexAccess,
  InlineAssembly,
  RevertStatement,
  ErrorDefinition,
  Conditional,
  VariableDeclaration,
  DataLocation,
  getNodeType,
  UserDefinedType,
  UsingForDirective,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';

export class RejectUnsupportedFeatures extends ASTMapper {
  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (node.vIndexExpression === undefined) {
      throw new WillNotSupportError(`Undefined index access not supported. Is this in abi.decode?`);
    }
    this.visitExpression(node, ast);
  }
  visitInlineAssembly(_node: InlineAssembly, _ast: AST): void {
    throw new WillNotSupportError('Yul blocks are not supported');
  }
  visitRevertStatement(_node: RevertStatement, _ast: AST): void {
    throw new WillNotSupportError('Reverts with custom errors are not supported');
  }
  visitErrorDefinition(_node: ErrorDefinition, _ast: AST): void {
    throw new WillNotSupportError('User defined Errors are not supported');
  }
  visitConditional(_node: Conditional, _ast: AST): void {
    throw new WillNotSupportError('Conditional expressions (ternary operator) are not supported');
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (
      node.storageLocation === DataLocation.Memory &&
      getNodeType(node, ast.compilerVersion) instanceof UserDefinedType
    ) {
      throw new NotSupportedYetError(
        `Memory structs not supported yet, found at ${printNode(node)}`,
      );
    }
  }
  visitUsingForDirective(node: UsingForDirective, _ast: AST): void {
    if (node.vLibraryName === undefined) {
      throw new NotSupportedYetError(
        `Non-library using fors not supported yet, found at ${printNode(node)}`,
      );
    }
  }
}

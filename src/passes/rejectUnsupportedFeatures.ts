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
  ImportDirective,
  MemberAccess,
  AddressType,
  FunctionType,
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
    if (getNodeType(node, ast.compilerVersion) instanceof FunctionType)
      throw new WillNotSupportError('Function objects are not supported');
    this.commonVisit(node, ast);
  }
  visitImportDirective(node: ImportDirective, _ast: AST): void {
    if (node.children.length !== 0) {
      throw new NotSupportedYetError(
        `Specific imports are not supported yet, found at ${printNode(
          node,
        )}. Please use whole-file imports until this is implemented`,
      );
    }
    // No need to recurse, since we throw if it has any children
  }
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (!(getNodeType(node.vExpression, ast.compilerVersion) instanceof AddressType)) {
      this.visitExpression(node, ast);
      return;
    }

    const members: string[] = [
      'balance',
      'code',
      'codehash',
      'transfer',
      'send',
      'call',
      'delegatecall',
      'staticcall',
    ];
    if (members.includes(node.memberName))
      throw new WillNotSupportError(
        `Members of addresses are not supported. Found at ${printNode(node)}`,
      );
    this.visitExpression(node, ast);
  }
}

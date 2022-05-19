import {
  IndexAccess,
  InlineAssembly,
  RevertStatement,
  ErrorDefinition,
  Conditional,
  MappingType,
  MemberAccess,
  PointerType,
  AddressType,
  FunctionType,
  getNodeType,
  UserDefinedType,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
  FunctionCall,
  FunctionCallKind,
  SourceUnit,
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
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FunctionType)
      throw new WillNotSupportError('Function objects are not supported');
    if (
      typeNode instanceof PointerType &&
      typeNode.to instanceof MappingType &&
      typeNode.to.valueType instanceof UserDefinedType
    )
      throw new NotSupportedYetError('Mappings with structs are not supported yet');
    this.commonVisit(node, ast);
  }

  visitSourceUnit(sourceUnit: SourceUnit, ast: AST): void {
    if (sourceUnit.absolutePath.includes('-')) {
      throw new WillNotSupportError(
        `Cairo filenames should not include "-", as this prevents importing, please rename. Found in ${sourceUnit.absolutePath}`,
      );
    }
    this.commonVisit(sourceUnit, ast);
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
  visitUserDefinedValueTypeDefinition(_node: UserDefinedValueTypeDefinition, _ast: AST): void {
    throw new NotSupportedYetError('User defined types are not supported yet');
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const unsupportedMath = ['keccak256', 'sha256', 'ripemd160', 'ecrecover', 'addmod', 'mulmod'];
    const unsupportedAbi = [
      'decode',
      'encode',
      'encodePacked',
      'encodeWithSelector',
      'encodeWithSignature',
      'encodeCall',
    ];
    const funcName = node.vFunctionName;
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      node.vReferencedDeclaration === undefined &&
      [...unsupportedMath, ...unsupportedAbi].includes(funcName)
    ) {
      const prefix = unsupportedMath.includes(funcName) ? `Math function` : `Abi function`;
      throw new WillNotSupportError(`${prefix} ${funcName} is not supported`);
    }

    this.visitExpression(node, ast);
  }
}

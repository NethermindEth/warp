import {
  IndexAccess,
  InlineAssembly,
  RevertStatement,
  ErrorDefinition,
  Conditional,
  MemberAccess,
  AddressType,
  FunctionType,
  getNodeType,
  VariableDeclaration,
  FunctionKind,
  FunctionCall,
  FunctionCallKind,
  SourceUnit,
  FunctionDefinition,
  ArrayType,
  TryStatement,
  TypeNode,
  UserDefinedType,
  StructDefinition,
  NewExpression,
  ArrayTypeName,
  ParameterList,
  Identifier,
  ExternalReferenceType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';
import { isReferenceType } from '../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../utils/utils';

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
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (node.name === 'msg' && node.vIdentifierType === ExternalReferenceType.Builtin) {
      if (!(node.parent instanceof MemberAccess && node.parent.memberName === 'sender')) {
        throw new WillNotSupportError(`msg object not supported outside of 'msg.sender'`);
      }
    }
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

  visitParameterList(node: ParameterList, ast: AST): void {
    // any of node.vParameters has indexed flag true then throw error
    if (node.vParameters.some((param) => param.indexed)) {
      throw new WillNotSupportError(`Indexed parameters are not supported`);
    }
    this.commonVisit(node, ast);
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

  visitNewExpression(node: NewExpression, ast: AST): void {
    if (!(node.vTypeName instanceof ArrayTypeName)) {
      throw new NotSupportedYetError(
        `new expressions are not supported yet for non-array type ${node.vTypeName.typeString}`,
      );
    }
    this.visitExpression(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (isExternallyVisible(node)) {
      node.vParameters.vParameters.forEach((decl) => {
        const type = getNodeType(decl, ast.compilerVersion);
        if (isReferenceType(type)) {
          if (type instanceof ArrayType) {
            type.size === undefined
              ? this.externalFunctionArgsCheck(type.elementT, ast, true)
              : this.externalFunctionArgsCheck(type.elementT, ast, false);
          } else if (
            type instanceof UserDefinedType &&
            type.definition instanceof StructDefinition
          ) {
            type.definition.vMembers.map((member) =>
              this.externalFunctionArgsCheck(getNodeType(member, ast.compilerVersion), ast, false),
            );
          }
        }
      });
    }
    if (node.kind === FunctionKind.Fallback) {
      if (node.vParameters.vParameters.length > 0)
        throw new WillNotSupportError(`${node.kind} with arguments is not supported`);
    }
    this.commonVisit(node, ast);
  }

  visitTryStatement(_node: TryStatement, _ast: AST): void {
    throw new WillNotSupportError(`Try/Catch statements are not supported`);
  }

  private externalFunctionArgsCheck(
    type: TypeNode,
    ast: AST,
    parentDynArray: boolean,
  ): boolean | void {
    if (type instanceof ArrayType) {
      const elemType = type.elementT;
      if (type instanceof ArrayType && type.size !== undefined && parentDynArray) {
        throw new NotSupportedYetError(
          `Static Arrays as elements of Dynamic arrays are not supported in calldata or as inputs to externally visible functions"`,
        );
      } else if (type instanceof ArrayType && type.size === undefined) {
        throw new NotSupportedYetError(
          `Inputs arguments with nested Dynamic Arrays not supported in external functions`,
        );
      }
      this.externalFunctionArgsCheck(elemType, ast, false);
    } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      type.definition.vMembers.map((member) => {
        this.externalFunctionArgsCheck(getNodeType(member, ast.compilerVersion), ast, false);
      });
    }
  }
}

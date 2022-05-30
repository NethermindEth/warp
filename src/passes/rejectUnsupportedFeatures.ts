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
  FunctionCall,
  FunctionCallKind,
  SourceUnit,
  FunctionDefinition,
  ArrayType,
  generalizeType,
  TypeNode,
  UserDefinedType,
  StructDefinition,
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

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (isExternallyVisible(node)) {
      node.vParameters.vParameters.forEach((decl) => {
        // Check if this is a pointer type
        const type = generalizeType(getNodeType(decl, ast.compilerVersion))[0];
        if (isReferenceType(type)) {
          if (type instanceof ArrayType) {
            type.size === undefined
              ? this.inspectChildType(type.elementT, ast, true)
              : this.inspectChildType(type.elementT, ast, false);
          } else if (
            type instanceof UserDefinedType &&
            type.definition instanceof StructDefinition
          ) {
            type.definition.vMembers.map((member) =>
              this.inspectChildType(getNodeType(member, ast.compilerVersion), ast, false),
            );
          }
        }
      });
    }
  }

  private inspectChildType(type: TypeNode, ast: AST, parentDynArray: boolean): boolean | void {
    // Receiving the top level type
    if (type instanceof ArrayType) {
      const elemType = generalizeType(type.elementT)[0];
      // This fist condition is here since we cannot support DynArrays of StaticArrays, but we can support DynArrays of Structs of StaticArrays ect.
      if (type instanceof ArrayType && type.size !== undefined && parentDynArray) {
        throw new NotSupportedYetError(
          `Static Arrays as elements of Dynamic Arrays are not supported.`,
        );
      } else if (type instanceof ArrayType && type.size === undefined) {
        throw new NotSupportedYetError(
          `Inputs arguments with Dynamic Arrays as members or elements are not supported.`,
        );
      }
      this.inspectChildType(elemType, ast, false);
    } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      type.definition.vMembers.map((member) => {
        this.inspectChildType(getNodeType(member, ast.compilerVersion), ast, false);
      });
    }
  }
}

// inspect Parameters
// Inputs you can have:
// -- Dynamic Arrays
//    -- Cannot have Static Arrays.
//    --Structs
//      -- Static Arrays
//       --. . . . Just no Dynamic Arrays
//    -- If the first level is not a Dynamic Array it is not supported.
//

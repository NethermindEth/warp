import {
  AddressType,
  ArrayType,
  ArrayTypeName,
  ASTNode,
  BytesType,
  Conditional,
  ContractDefinition,
  ContractKind,
  DataLocation,
  ElementaryTypeName,
  ErrorDefinition,
  ExpressionStatement,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionKind,
  FunctionType,
  getNodeType,
  Identifier,
  IndexAccess,
  InlineAssembly,
  MemberAccess,
  NewExpression,
  ParameterList,
  PointerType,
  RevertStatement,
  StructDefinition,
  TryStatement,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';
import { isDynamicArray } from '../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../utils/utils';

export class RejectUnsupportedFeatures extends ASTMapper {
  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (node.vIndexExpression === undefined) {
      throw new WillNotSupportError(
        `Undefined index access not supported. Is this in abi.decode?`,
        node,
      );
    }
    this.visitExpression(node, ast);
  }
  visitInlineAssembly(node: InlineAssembly, _ast: AST): void {
    throw new WillNotSupportError('Yul blocks are not supported', node);
  }
  visitRevertStatement(node: RevertStatement, _ast: AST): void {
    throw new WillNotSupportError('Reverts with custom errors are not supported', node);
  }
  visitErrorDefinition(node: ErrorDefinition, _ast: AST): void {
    throw new WillNotSupportError('User defined Errors are not supported', node);
  }
  visitConditional(node: Conditional, _ast: AST): void {
    throw new WillNotSupportError(
      'Conditional expressions (ternary operator, node) are not supported',
      node,
    );
  }
  visitFunctionCallOptions(node: FunctionCallOptions, _ast: AST): void {
    throw new WillNotSupportError(
      'Function call options, such as {gas:X} and {value:X} are not supported',
      node,
    );
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FunctionType)
      throw new WillNotSupportError('Function objects are not supported', node);
    this.commonVisit(node, ast);
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    const typeNode = getNodeType(node.vExpression, ast.compilerVersion);
    if (typeNode instanceof FunctionType)
      throw new WillNotSupportError('Function objects are not supported', node);
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (node.name === 'msg' && node.vIdentifierType === ExternalReferenceType.Builtin) {
      if (!(node.parent instanceof MemberAccess && node.parent.memberName === 'sender')) {
        throw new WillNotSupportError(`msg object not supported outside of 'msg.sender'`, node);
      }
    }
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
        node,
      );
    this.visitExpression(node, ast);
  }

  visitParameterList(node: ParameterList, ast: AST): void {
    // any of node.vParameters has indexed flag true then throw error
    if (node.vParameters.some((param) => param.indexed)) {
      throw new WillNotSupportError(`Indexed parameters are not supported`, node);
    }
    this.commonVisit(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const unsupportedMath = ['sha256', 'ripemd160', 'addmod', 'mulmod'];
    const unsupportedAbi = [
      'decode',
      'encode',
      'encodePacked',
      'encodeWithSelector',
      'encodeWithSignature',
      'encodeCall',
    ];
    const unsupportedMisc = ['blockhash', 'selfdestruct'];
    const funcName = node.vFunctionName;
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      node.vReferencedDeclaration === undefined &&
      [...unsupportedMath, ...unsupportedAbi, ...unsupportedMisc].includes(funcName)
    ) {
      throw new WillNotSupportError(`Solidity builtin ${funcName} is not supported`, node);
    }

    this.visitExpression(node, ast);
  }

  visitNewExpression(node: NewExpression, ast: AST): void {
    if (
      !(node.vTypeName instanceof ArrayTypeName) &&
      !(node.vTypeName instanceof ElementaryTypeName && node.vTypeName.name === 'bytes')
    ) {
      throw new NotSupportedYetError(
        `new expressions are not supported yet for non-array type ${node.vTypeName.typeString}`,
        node,
      );
    }
    this.visitExpression(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (!(node.vScope instanceof ContractDefinition && node.vScope.kind === ContractKind.Library)) {
      [...node.vParameters.vParameters, ...node.vReturnParameters.vParameters].forEach((decl) => {
        const type = getNodeType(decl, ast.compilerVersion);
        functionArgsCheck(type, ast, isExternallyVisible(node), decl.storageLocation, node);
      });
    }
    if (node.kind === FunctionKind.Fallback) {
      if (node.vParameters.vParameters.length > 0)
        throw new WillNotSupportError(`${node.kind} with arguments is not supported`, node);
    } else if (node.kind === FunctionKind.Receive) {
      throw new WillNotSupportError(`Receive functions are not supported`, node);
    }
    this.commonVisit(node, ast);
  }

  visitTryStatement(node: TryStatement, _ast: AST): void {
    throw new WillNotSupportError(`Try/Catch statements are not supported`, node);
  }
}

// Cases not allowed:
// Dynarray inside structs to/from external functions
// Dynarray inside dynarray to/from external functions
// Dynarray as direct child of static array to/from external functions
function functionArgsCheck(
  type: TypeNode,
  ast: AST,
  externallyVisible: boolean,
  dataLocation: DataLocation,
  node: ASTNode,
): void {
  if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    if (externallyVisible && findDynArrayRecursive(type, ast)) {
      throw new WillNotSupportError(
        `Dynamic arrays are not allowed as (indirect) children of structs passed to/from external functions`,
        node,
      );
    }
    type.definition.vMembers.forEach((member) =>
      functionArgsCheck(
        getNodeType(member, ast.compilerVersion),
        ast,
        externallyVisible,
        dataLocation,
        member,
      ),
    );
  } else if (type instanceof ArrayType && type.size === undefined) {
    if (externallyVisible && findDynArrayRecursive(type.elementT, ast)) {
      throw new WillNotSupportError(
        `Dynamic arrays are not allowed as (indirect) children of dynamic arrays passed to/from external functions`,
      );
    }
    functionArgsCheck(type.elementT, ast, externallyVisible, dataLocation, node);
  } else if (type instanceof ArrayType) {
    if (isDynamicArray(type.elementT)) {
      throw new WillNotSupportError(
        `Dynamic arrays are not allowed as children of static arrays passed to/from external functions`,
      );
    }
    functionArgsCheck(type.elementT, ast, externallyVisible, dataLocation, node);
  }
}

// Returns whether the given type is a dynamic array, or contains one
function findDynArrayRecursive(type: TypeNode, ast: AST): boolean {
  if (isDynamicArray(type)) return true;
  if (type instanceof PointerType) {
    return findDynArrayRecursive(type.to, ast);
  } else if (type instanceof ArrayType) {
    return findDynArrayRecursive(type.elementT, ast);
  } else if (type instanceof BytesType) {
    return true;
  } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    return type.definition.vMembers.some((member) =>
      findDynArrayRecursive(getNodeType(member, ast.compilerVersion), ast),
    );
  } else {
    return false;
  }
}

import {
  AddressType,
  ArrayType,
  ASTNode,
  BytesType,
  ContractDefinition,
  ContractKind,
  DataLocation,
  ErrorDefinition,
  ExpressionStatement,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionKind,
  FunctionType,
  Identifier,
  IndexAccess,
  InlineAssembly,
  Literal,
  MemberAccess,
  PointerType,
  RevertStatement,
  SourceUnit,
  StructDefinition,
  TryStatement,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { getErrorMessage, WillNotSupportError } from '../utils/errors';
import { isDynamicArray, safeGetNodeType } from '../utils/nodeTypeProcessing';
import { isExternalCall, isExternallyVisible } from '../utils/utils';

const PATH_REGEX = /^[\w-@/\\]*$/;

export function checkPath(path: string): boolean {
  const pathWithoutExtension = path.substring(0, path.length - '.sol'.length);
  return !PATH_REGEX.test(pathWithoutExtension);
}

export class RejectUnsupportedFeatures extends ASTMapper {
  unsupportedFeatures: [string, ASTNode][] = [];

  static map(ast: AST): AST {
    const unsupportedPerSource = new Map<string, [string, ASTNode][]>();

    const unsupportedDetected = ast.roots.reduce((unsupported, sourceUnit) => {
      const mapper = new this();
      mapper.dispatchVisit(sourceUnit, ast);
      if (mapper.unsupportedFeatures.length > 0) {
        unsupportedPerSource.set(sourceUnit.absolutePath, mapper.unsupportedFeatures);
        return unsupported + mapper.unsupportedFeatures.length;
      }
      return unsupported;
    }, 0);

    if (unsupportedDetected > 0) {
      const errorMsg = getErrorMessage(
        unsupportedPerSource,
        `Detected ${unsupportedDetected} Unsupported Features:`,
      );
      throw new WillNotSupportError(errorMsg, undefined, false);
    }

    return ast;
  }

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (node.vIndexExpression === undefined) {
      if (!(safeGetNodeType(node, ast.inference) instanceof TypeNameType)) {
        this.addUnsupported(`Undefined index access not supported`, node);
      }
    }
    this.visitExpression(node, ast);
  }

  visitInlineAssembly(node: InlineAssembly, _ast: AST): void {
    this.addUnsupported('Yul blocks are not supported', node);
  }

  visitRevertStatement(node: RevertStatement, _ast: AST): void {
    this.addUnsupported('Reverts with custom errors are not supported', node);
  }

  visitErrorDefinition(node: ErrorDefinition, _ast: AST): void {
    this.addUnsupported('User defined Errors are not supported', node);
  }

  visitFunctionCallOptions(node: FunctionCallOptions, ast: AST): void {
    // Allow options only when passing salt values for contract creation
    if (
      node.parent instanceof FunctionCall &&
      node.parent.typeString.startsWith('contract') &&
      [...node.vOptionsMap.entries()].length === 1 &&
      node.vOptionsMap.has('salt')
    ) {
      return this.visitExpression(node, ast);
    }

    this.addUnsupported(
      'Function call options (other than `salt` when creating a contract), such as {gas:X} and {value:X} are not supported',
      node,
    );
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
    if (typeNode instanceof FunctionType)
      this.addUnsupported('Function objects are not supported', node);
    this.commonVisit(node, ast);
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    const typeNode = safeGetNodeType(node.vExpression, ast.inference);
    if (typeNode instanceof FunctionType)
      this.addUnsupported('Function objects are not supported', node);
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (node.name === 'msg' && node.vIdentifierType === ExternalReferenceType.Builtin) {
      if (!(node.parent instanceof MemberAccess && node.parent.memberName === 'sender')) {
        this.addUnsupported(`msg object not supported outside of 'msg.sender'`, node);
      }
    } else if (node.name === 'block' && node.vIdentifierType === ExternalReferenceType.Builtin) {
      if (
        node.parent instanceof MemberAccess &&
        ['coinbase', 'chainid', 'gaslimit', 'basefee', 'difficulty'].includes(
          (<MemberAccess>node.parent).memberName,
        )
      ) {
        this.addUnsupported(`block.${(<MemberAccess>node.parent).memberName} not supported`, node);
      }
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (!(safeGetNodeType(node.vExpression, ast.inference) instanceof AddressType)) {
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
      this.addUnsupported(
        `Members of addresses are not supported. Found at ${printNode(node)}`,
        node,
      );
    this.visitExpression(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind !== FunctionCallKind.FunctionCall ||
      node.vFunctionCallType !== ExternalReferenceType.Builtin
    )
      return this.visitExpression(node, ast);

    const funcName = node.vFunctionName;
    if (
      ['sha256', 'ripemd160', 'encodeCall', 'blockhash', 'selfdestruct', 'gasleft'].includes(
        funcName,
      )
    ) {
      this.addUnsupported(`Solidity builtin ${funcName} is not supported`, node);
    } else if (
      ['require', 'assert'].includes(funcName) &&
      node.vArguments.length > 1 &&
      !(node.vArguments[1] instanceof Literal)
    ) {
      this.addUnsupported(
        `Dynamic string cannot be used as arguments for  ${funcName}`,
        node.vArguments[1],
      );
    } else if (
      funcName === 'revert' &&
      node.vArguments.length > 0 &&
      !(node.vArguments[0] instanceof Literal)
    ) {
      this.addUnsupported(
        `Dynamic string cannot be used as arguments for  ${funcName}`,
        node.vArguments[0],
      );
    }
    this.visitExpression(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (!(node.vScope instanceof ContractDefinition && node.vScope.kind === ContractKind.Library)) {
      [...node.vParameters.vParameters, ...node.vReturnParameters.vParameters].forEach((decl) => {
        const type = safeGetNodeType(decl, ast.inference);
        this.functionArgsCheck(type, ast, isExternallyVisible(node), decl.storageLocation, node);
      });
    }
    if (node.kind === FunctionKind.Fallback) {
      if (node.vParameters.vParameters.length > 0)
        this.addUnsupported(`${node.kind} with arguments is not supported`, node);
    } else if (node.kind === FunctionKind.Receive) {
      this.addUnsupported(`Receive functions are not supported`, node);
    }

    //checks for the pattern if "this" keyword is used to call the external functions during the contract construction
    this.checkExternalFunctionCallWithThisOnConstruction(node);

    this.commonVisit(node, ast);
  }

  visitTryStatement(node: TryStatement, _ast: AST): void {
    this.addUnsupported(`Try/Catch statements are not supported`, node);
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    if (checkPath(node.absolutePath)) {
      this.addUnsupported(
        'File path includes unsupported characters, only _, -, /, , and alphanumeric characters are supported',
        node,
      );
    }
    this.commonVisit(node, ast);
  }

  // Cases not allowed:
  // Dynarray inside structs to/from external functions
  // Dynarray inside dynarray to/from external functions
  // Dynarray as direct child of static array to/from external functions
  private functionArgsCheck(
    type: TypeNode,
    ast: AST,
    externallyVisible: boolean,
    dataLocation: DataLocation,
    node: ASTNode,
  ): void {
    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      if (externallyVisible && findDynArrayRecursive(type, ast)) {
        this.addUnsupported(
          `Dynamic arrays are not allowed as (indirect) children of structs passed to/from external functions`,
          node,
        );
        return;
      }
      type.definition.vMembers.forEach((member) =>
        this.functionArgsCheck(
          safeGetNodeType(member, ast.inference),
          ast,
          externallyVisible,
          dataLocation,
          member,
        ),
      );
    } else if (type instanceof ArrayType && type.size === undefined) {
      if (externallyVisible && findDynArrayRecursive(type.elementT, ast)) {
        this.addUnsupported(
          `Dynamic arrays are not allowed as (indirect) children of dynamic arrays passed to/from external functions`,
          node,
        );
        return;
      }
      this.functionArgsCheck(type.elementT, ast, externallyVisible, dataLocation, node);
    } else if (type instanceof ArrayType) {
      if (isDynamicArray(type.elementT)) {
        this.addUnsupported(
          `Dynamic arrays are not allowed as children of static arrays passed to/from external functions`,
          node,
        );
        return;
      }
      this.functionArgsCheck(type.elementT, ast, externallyVisible, dataLocation, node);
    }
  }

  // Checking that if the function definition is constructor then there is no usage of
  // the `this` keyword for calling any contract function
  private checkExternalFunctionCallWithThisOnConstruction(node: FunctionDefinition) {
    if (node.kind === FunctionKind.Constructor) {
      const nodesWithThisIdentifier = node.vBody
        ?.getChildren()
        .filter((childNode, _) => childNode instanceof Identifier && childNode.name === 'this');

      nodesWithThisIdentifier?.forEach((identifierNode: ASTNode) => {
        const parentNode = identifierNode?.parent;
        if (
          parentNode instanceof MemberAccess &&
          parentNode?.parent instanceof FunctionCall &&
          isExternalCall(parentNode.parent)
        ) {
          this.addUnsupported(
            `External function calls using "this" keyword are not supported in contract's constructor function`,
            node,
          );
        }
      });
    }
  }
  private addUnsupported(message: string, node: ASTNode) {
    this.unsupportedFeatures.push([message, node]);
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
      findDynArrayRecursive(safeGetNodeType(member, ast.inference), ast),
    );
  } else {
    return false;
  }
}

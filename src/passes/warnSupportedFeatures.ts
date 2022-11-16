import assert from 'assert';
import fs from 'fs';
import {
  AddressType,
  ASTNode,
  ContractDefinition,
  Expression,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  FunctionCallOptions,
  ParameterList,
  NewExpression,
  parseSourceLocation,
  UserDefinedTypeName,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { warning } from '../utils/formatting';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getSourceFromLocations } from '../utils/utils';

export class WarnSupportedFeatures extends ASTMapper {
  public addressesToAbiEncode: ASTNode[] = [];
  public deploySaltOptions: Expression[] = [];

  visitNewExpression(node: NewExpression, ast: AST): void {
    if (
      node.vTypeName instanceof UserDefinedTypeName &&
      node.vTypeName.vReferencedDeclaration instanceof ContractDefinition &&
      node.parent instanceof FunctionCallOptions
    ) {
      const salt = node.parent.vOptionsMap.get('salt');
      assert(salt !== undefined);
      this.deploySaltOptions.push(salt);
    }

    this.commonVisit(node, ast);
  }

  visitParameterList(node: ParameterList, ast: AST): void {
    // any of node.vParameters has indexed flag true then throw error
    if (node.vParameters.some((param) => param.indexed)) {
      console.log(
        `${warning('Warning:')} Indexed parameters are not supported yet. They will be ignored.`,
      );
      const path = node.getClosestParentByType(SourceUnit)?.absolutePath;
      if (path !== undefined)
        warn(
          path,
          node.vParameters.filter((param) => param.indexed),
        );
    }
    this.commonVisit(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      node.vFunctionCallType === ExternalReferenceType.Builtin &&
      ['encodePacked'].includes(node.vFunctionName)
    ) {
      node.vArguments
        .filter((arg) => safeGetNodeType(arg, ast.compilerVersion) instanceof AddressType)
        .forEach((arg) => this.addressesToAbiEncode.push(arg));
    }

    this.commonVisit(node, ast);
  }

  static map(ast: AST): AST {
    const addresses = new Map<string, ASTNode[]>();
    const deploySalts = new Map<string, Expression[]>();

    ast.roots.forEach((sourceUnit) => {
      const mapper = new this();
      mapper.dispatchVisit(sourceUnit, ast);
      if (mapper.addressesToAbiEncode.length > 0) {
        addresses.set(sourceUnit.absolutePath, mapper.addressesToAbiEncode);
      }
      if (mapper.deploySaltOptions.length > 0) {
        deploySalts.set(sourceUnit.absolutePath, mapper.deploySaltOptions);
      }
    });

    if (addresses.size > 0) {
      console.log(
        `${warning(
          'Warning:',
        )} ABI Packed encoding of address is 32 bytes long on warped contract (instead of 20 bytes).`,
      );
      [...addresses.entries()].forEach(([path, nodes]) => warn(path, nodes));
    }

    if (deploySalts.size > 0) {
      console.log(
        `${warning(
          'Warning',
        )}: Due to StarkNet restrictions, salt used for contract creation is narrowed from 'uint256' to 'felt' taking the first 248 most significant bits`,
      );
      [...deploySalts.entries()].forEach(([path, nodes]) => warn(path, nodes));
    }

    return ast;
  }
}

function warn(path: string, nodes: ASTNode[]): void {
  const content = fs.readFileSync(path, { encoding: 'utf-8' });
  const extendedMessage = [
    `File ${path}:`,
    ...getSourceFromLocations(
      content,
      nodes.map((n) => parseSourceLocation(n.src)),
      warning,
      8,
    )
      .split('\n')
      .map((l) => `\t${l}`),
  ].join('\n');

  console.log(extendedMessage + '\n');
}

import assert from 'assert';
import fs from 'fs/promises';
import {
  AddressType,
  ASTNode,
  ContractDefinition,
  Expression,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  FunctionCallOptions,
  NewExpression,
  parseSourceLocation,
  UserDefinedTypeName,
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

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      node.vFunctionCallType === ExternalReferenceType.Builtin &&
      ['encodePacked'].includes(node.vFunctionName)
    ) {
      node.vArguments
        .filter((arg) => safeGetNodeType(arg, ast.inference) instanceof AddressType)
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
        )}: Due to Starknet restrictions, salt used for contract creation is narrowed from 'uint256' to 'felt' taking the first 248 most significant bits`,
      );
      [...deploySalts.entries()].forEach(([path, nodes]) => warn(path, nodes));
    }

    return ast;
  }
}

async function warn(path: string, nodes: ASTNode[]): Promise<void> {
  const content = await fs.readFile(path, { encoding: 'utf-8' });
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

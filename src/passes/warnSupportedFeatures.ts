import fs from 'fs';
import {
  AddressType,
  ASTNode,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  parseSourceLocation,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { warning } from '../utils/formatting';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getSourceFromLocations } from '../utils/utils';

export class WarnSupportedFeatures extends ASTMapper {
  public addressesToAbiEncode: ASTNode[] = [];

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

    ast.roots.forEach((sourceUnit) => {
      const mapper = new this();
      mapper.dispatchVisit(sourceUnit, ast);
      addresses.set(sourceUnit.absolutePath, mapper.addressesToAbiEncode);
    });

    if (addresses.size > 0) {
      console.log(
        `${warning(
          'Warning:',
        )} ABI Packed encoding of address is 32 bytes long on warped contract (instead of 20 bytes).`,
      );
      [...addresses.entries()].forEach(([path, nodes]) => warn(path, nodes));
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

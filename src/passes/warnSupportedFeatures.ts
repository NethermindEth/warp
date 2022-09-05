import fs from 'fs';
import {
  AddressType,
  ASTNode,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  parseSourceLocation,
  SourceLocation,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { warning } from '../utils/formatting';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getSourceFromLocation } from '../utils/utils';

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

    console.log(this.addressesToAbiEncode.length);
    return this.visitExpression(node, ast);
  }

  static map(ast: AST): AST {
    const addresses = new Map<string, ASTNode[]>();

    ast.roots.forEach((sourceUnit) => {
      const mapper = new this();
      mapper.dispatchVisit(sourceUnit, ast);
      addresses.set(sourceUnit.absolutePath, mapper.addressesToAbiEncode);
    });

    [...addresses.entries()].forEach(([path, nodes]) => {
      const content = fs.readFileSync(path, { encoding: 'utf-8' });
      const warnx = [
        `File ${path}:\n`,
        ...getSourceFromLocation(content, parseSourceLocation(nodes[0].src))
          .split('\n')
          .map((l) => `\t${l}`),
      ].join('\n');

      console.log(warnx);
    });

    return ast;
  }
}

interface Source {
  source: string;
  location: SourceLocation;
}
function getSourcesFromLocations(sources: Source[]) {}

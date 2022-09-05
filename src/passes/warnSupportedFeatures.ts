import {
  AddressType,
  ASTNode,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { getSourceCode } from '../utils/errors';
import { warning } from '../utils/formatting';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

export class WarnSupportedFeatures extends ASTMapper {
  public addressesToAbiEncode: [string, ASTNode][] = [];

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      node.vFunctionCallType === ExternalReferenceType.Builtin &&
      ['encodePacked', 'encode', 'encodeWithSelector', 'encodeWithSignature'].includes(
        node.vFunctionName,
      )
    ) {
      node.vArguments
        .filter((arg) => safeGetNodeType(arg, ast.compilerVersion) instanceof AddressType)
        .forEach((arg) =>
          node.vFunctionName === 'encodePacked'
            ? this.addressesToAbiEncode.push(['a', arg])
            : this.addressesToAbiEncode.push(['b', arg]),
        );
    }
    return this.visitExpression(node, ast);
  }

  static map(ast: AST): AST {
    const addresses = new Map<string, [string, ASTNode][]>();

    ast.roots.forEach((sourceUnit) => {
      const mapper = new this();
      mapper.dispatchVisit(sourceUnit, ast);
      addresses.set(sourceUnit.absolutePath, mapper.addressesToAbiEncode);
    });
    return ast;
  }
}

function warn(message: string, node: ASTNode) {
  console.warn(`${warning(message)}${`\n\n${getSourceCode(node)}\n`}`);
}

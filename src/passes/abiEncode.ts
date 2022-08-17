import { FunctionCall, FunctionCallKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';

export class ABIEncode extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind !== FunctionCallKind.FunctionCall ||
      node.vReferencedDeclaration !== undefined ||
      !['encodePacked', 'encode', 'encodeWithSelector', 'encodeWithSignature'].includes(
        node.vFunctionName,
      )
    ) {
      return this.visitExpression(node, ast);
    }

    let replacement: FunctionCall;
    switch (node.vFunctionName) {
      case 'encode':
        replacement = ast.getUtilFuncGen(node).abi.encode.gen(node.vArguments);
        break;
      case 'encodePacked':
        replacement = ast.getUtilFuncGen(node).abi.encodePacked.gen(node.vArguments);
        break;
      case 'encodeWithSelector':
        replacement = ast.getUtilFuncGen(node).abi.encodeWithSelector.gen(node.vArguments);
        break;
      case 'encodeWithSignature':
        replacement = ast.getUtilFuncGen(node).abi.encodeWithSignature.gen(node.vArguments);
        break;
      default:
        throw new TranspileFailedError(`Unknown abi function: ${node.vFunctionName}`);
    }
    ast.replaceNode(node, replacement);
    this.visitExpression(node, ast);
  }
}

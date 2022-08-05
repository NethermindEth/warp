import { FunctionCall, FunctionCallKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

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
      !['encodePacked'].includes(node.vFunctionName)
    ) {
      return this.visitExpression(node, ast);
    }

    const cairoAbiEncode = ast.getUtilFuncGen(node).utils.abiEncodePacked.gen(node.vArguments);
    ast.replaceNode(node, cairoAbiEncode);

    this.visitExpression(node, ast);
  }
}

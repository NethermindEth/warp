import { ExternalReferenceType, FunctionCall, FunctionCallKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';

/**
 * Swap any builtin call to abi.encode | encodePacked | encodeWithSelector | encodeWithSignature
 * for a cairo generated one.
 *
 * Warning:
 *
 * Special care needs to be taken when encoding addresses since in Ethereum they
 * take 20 byte but in Starknet they take the whole felt space.
 * An address whose size fits in 20 bytes will have the exact same encoding
 * in both the Solidity and Cairo transpiled contract when encoding it in any
 * form (packed or not).
 * If the address size is bigger than 20 bytes then:
 *   - `encodePacked` will only encode its first 20 bytes and any extra would be
 *   lost
 *   - `encode` will behave normally since it will have the whole 32 byte slot to
 *   encode, but if tried to decode as an address in Ethereum an exception will be
 *   thrown since it won't fit in a Solidity address type
 */
export class ABIEncode extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'I', // Implicit conversion to explicit needed to handle literal types (int_const, string_const)
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind !== FunctionCallKind.FunctionCall ||
      node.vFunctionCallType !== ExternalReferenceType.Builtin ||
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

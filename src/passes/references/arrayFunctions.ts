import {
  ArrayType,
  DataLocation,
  ExternalReferenceType,
  FunctionCall,
  getNodeType,
  Literal,
  LiteralKind,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { NotSupportedYetError } from '../../utils/errors';
import { generateLiteralTypeString, toHexString } from '../../utils/utils';
import { ReferenceSubPass } from './referenceSubPass';

export class ArrayFunctions extends ReferenceSubPass {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    // This pass is specifically looking for predefined solidity members
    if (node.vFunctionCallType !== ExternalReferenceType.Builtin) return;

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (node.vFunctionName === 'pop') {
      const replacement = ast.getUtilFuncGen(node).storage.dynArrayPop.gen(node);
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
      this.expectedDataLocations.set(replacement.vArguments[0], DataLocation.Default);
    } else if (node.vFunctionName === 'push') {
      let replacement: FunctionCall;
      if (node.vArguments.length > 0) {
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withArg.gen(node);
        this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
      } else {
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withoutArg.gen(node);
        this.replace(node, replacement, undefined, DataLocation.Storage, expectedLoc, ast);
      }
      this.expectedDataLocations.set(replacement.vArguments[0], DataLocation.Default);
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.memberName !== 'length') return;

    const expectedLoc = this.getLocations(node)[1];

    const baseType = getNodeType(node.vExpression, ast.compilerVersion);
    if (baseType instanceof PointerType && baseType.to instanceof ArrayType) {
      if (baseType.location !== DataLocation.Storage) {
        throw new NotSupportedYetError(
          `Accessing ${baseType.location} array length not implemented yet`,
        );
      }

      if (baseType.to.size !== undefined) {
        const size = baseType.to.size.toString();
        this.replace(
          node,
          new Literal(
            ast.reserveId(),
            node.src,
            generateLiteralTypeString(size),
            LiteralKind.Number,
            toHexString(size),
            size,
          ),
          undefined,
          DataLocation.Default,
          DataLocation.Default,
          ast,
        );
      } else {
        const replacement = ast.getUtilFuncGen(node).storage.dynArrayLength.gen(node, baseType.to);
        // The length function returns the actual length rather than a storage pointer to it,
        // so the new actual location is Default
        this.replace(node, replacement, undefined, DataLocation.Default, expectedLoc, ast);
        // This may have to be replaced with an actual read generation once dynamic array copy semantics
        // are in place
        this.expectedDataLocations.set(replacement.vArguments[0], DataLocation.Default);
      }
    }
  }
}

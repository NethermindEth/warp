import {
  ArrayType,
  ASTNode,
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
import { ASTMapper } from '../../ast/mapper';
import { NotSupportedYetError } from '../../utils/errors';
import { generateLiteralTypeString, toHexString } from '../../utils/utils';

export class ArrayFunctions extends ASTMapper {
  constructor(public reads: Set<ASTNode>, public storageRefs: Set<ASTNode>) {
    super();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    // This pass is specifically looking for the inbuilt functions push and pop
    if (node.vFunctionCallType !== ExternalReferenceType.Builtin) return;

    if (node.vFunctionName === 'pop') {
      const replacement = ast.getUtilFuncGen(node).storage.dynArrayPop.gen(node);
      ast.replaceNode(node, replacement);
      this.reads.add(replacement.vArguments[0]);
    } else if (node.vFunctionName === 'push') {
      let replacement: FunctionCall;
      if (node.vArguments.length > 0) {
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withArg.gen(node);
      } else {
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withoutArg.gen(node);
        this.storageRefs.add(replacement);
      }
      ast.replaceNode(node, replacement);
      this.reads.add(replacement.vArguments[0]);
      if (this.reads.has(node)) {
        this.reads.add(replacement);
      }
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.memberName !== 'length') return;

    const baseType = getNodeType(node.vExpression, ast.compilerVersion);
    if (baseType instanceof PointerType && baseType.to instanceof ArrayType) {
      if (baseType.location !== DataLocation.Storage) {
        throw new NotSupportedYetError(`${baseType.location} array length not implemented yet`);
      }

      if (baseType.to.size !== undefined) {
        const size = baseType.to.size.toString();
        ast.replaceNode(
          node,
          new Literal(
            ast.reserveId(),
            node.src,
            generateLiteralTypeString(size),
            LiteralKind.Number,
            toHexString(size),
            size,
          ),
        );
      } else {
        const replacement = ast.getUtilFuncGen(node).storage.dynArrayLength.gen(node, baseType.to);
        ast.replaceNode(node, replacement);
        this.reads.add(replacement.vArguments[0]);
      }
    }
  }
}

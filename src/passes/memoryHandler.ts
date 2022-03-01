import {
  ArrayType,
  ArrayTypeName,
  Assignment,
  DataLocation,
  FunctionCall,
  getNodeType,
  IndexAccess,
  NewExpression,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printTypeNode } from '../utils/astPrinter';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';

// TODO establish rules for 'default' data location, is it ever relevant to this or to the storage pass?

export class MemoryHandler extends ASTMapper {
  // This is specifically for visiting assignments to memory locations such as index access or member accesses
  visitAssignment(node: Assignment, ast: AST): void {
    // x[i] = a where x exists in memory
    if (node.vLeftHandSide instanceof IndexAccess) {
      const baseType = getNodeType(node.vLeftHandSide.vBaseExpression, ast.compilerVersion);
      if (baseType instanceof PointerType && baseType.location === DataLocation.Memory) {
        const replacementFunc = ast
          .getUtilFuncGen(node)
          .memoryWrite(node.vLeftHandSide, node.vRightHandSide);
        ast.replaceNode(node, replacementFunc);
        this.dispatchVisit(replacementFunc, ast);
        return;
      }
    }

    //TODO member access

    this.commonVisit(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);

    if (!(node.vExpression instanceof NewExpression)) return;
    // New can be used to create contract instances, which is not supported
    if (!(node.vExpression.vTypeName instanceof ArrayTypeName)) {
      throw new WillNotSupportError('Non-array new not supported');
    }
    ast.replaceNode(
      node,
      ast.getUtilFuncGen(node).newDynArray(node.vArguments[0], node.vExpression.vTypeName),
    );
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (node.vIndexExpression === undefined) {
      throw new WillNotSupportError(
        'Index access with undefined index expression not supported yet',
      );
    }

    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    if (baseType instanceof PointerType && baseType.location === DataLocation.Memory) {
      if (baseType.to instanceof ArrayType) {
        const replacementFunc = ast.getUtilFuncGen(node).memoryRead(node);
        ast.replaceNode(node, replacementFunc);
        this.dispatchVisit(replacementFunc, ast);
        return;
      } else {
        throw new NotSupportedYetError(
          `Index access into memory ${printTypeNode(baseType.to)} not supported yet`,
        );
      }
    }

    this.commonVisit(node, ast);
  }
}

import assert = require('assert');

import {
  Assignment,
  Identifier,
  IndexAccess,
  MappingType,
  PointerType,
  VariableDeclaration,
  getNodeType,
  MemberAccess,
  Mutability,
  DataLocation,
  ASTNode,
  FunctionCall,
  ArrayType,
} from 'solc-typed-ast';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { printNode, printTypeNode } from '../../utils/astPrinter';

import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { typeNameFromTypeNode } from '../../utils/utils';
import { error } from '../../utils/formatting';

export class StorageVariableAccessRewriter extends ASTMapper {
  constructor(public reads: Set<ASTNode>, public storageRefs: Set<ASTNode>) {
    super();
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (this.storageRefs.has(node.vLeftHandSide)) {
      const replacementFunc = ast
        .getUtilFuncGen(node)
        .storage.write.gen(node.vLeftHandSide, node.vRightHandSide);
      ast.replaceNode(node, replacementFunc);
    }
    this.visitExpression(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    if (!this.reads.has(node) || !this.storageRefs.has(node)) {
      this.visitExpression(node, ast);
      return;
    }

    // This is a read. Writes are caught by visitAssignment
    const decl = node.vReferencedDeclaration;
    if (decl === undefined || !(decl instanceof VariableDeclaration)) {
      throw new NotSupportedYetError(
        `Non-variable storage identifier ${printNode(node)} not supported`,
      );
    }

    assert(
      decl.vType !== undefined,
      error('VariableDeclaration.vType should be defined for compiler versions > 0.4.x'),
    );

    if (decl.mutability !== Mutability.Constant) {
      const parent = node.parent;
      const replacementFunc = ast.getUtilFuncGen(node).storage.read.gen(node, decl.vType);
      ast.replaceNode(node, replacementFunc, parent);
      // Do not recurse
      // The only argument to replacementFunc is node,
      // recursing would cause an infinite loop
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (!this.storageRefs.has(node)) {
      this.visitExpression(node, ast);
      return;
    }

    const type = getNodeType(node.vExpression, ast.compilerVersion);

    if (type instanceof PointerType && type.location === DataLocation.Storage) {
      const utilFuncGen = ast.getUtilFuncGen(node);
      // To transform a struct member access to cairo, there are two steps
      // First get the location in storage of the specific struct member
      // Then use a standard storage read call to read it out
      const referencedDeclaration = node.vReferencedDeclaration;
      assert(referencedDeclaration instanceof VariableDeclaration);
      assert(referencedDeclaration.vType !== undefined);
      const replacementAccessFunc = utilFuncGen.storage.memberAccess.gen(node);
      if (this.reads.has(node)) {
        const replacementReadFunc = utilFuncGen.storage.read.gen(
          replacementAccessFunc,
          referencedDeclaration.vType,
          node,
        );
        ast.replaceNode(node, replacementReadFunc);
        this.visitExpression(replacementReadFunc, ast);
      } else {
        ast.replaceNode(node, replacementAccessFunc);
        this.visitExpression(replacementAccessFunc, ast);
      }
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    assert(node.vIndexExpression !== undefined);

    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    if (baseType instanceof PointerType && baseType.location === DataLocation.Storage) {
      let offsetAddress: FunctionCall;
      if (baseType.to instanceof ArrayType) {
        if (baseType.to.size === undefined) {
          offsetAddress = ast.getUtilFuncGen(node).storage.dynArrayIndexAccess.gen(node);
        } else {
          offsetAddress = ast.getUtilFuncGen(node).storage.staticArrayIndexAccess.gen(node);
        }
      } else if (baseType.to instanceof MappingType) {
        offsetAddress = ast.getUtilFuncGen(node).storage.mappingIndexAccess.gen(node);
      } else {
        throw new TranspileFailedError(
          `Unexpected index access base type ${printTypeNode(baseType.to)} at ${printNode(node)}`,
        );
      }
      if (this.reads.has(node)) {
        const readFunction = ast
          .getUtilFuncGen(node)
          .storage.read.gen(
            offsetAddress,
            typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast),
            node,
          );
        ast.replaceNode(node, readFunction);
        this.dispatchVisit(readFunction, ast);
      } else {
        ast.replaceNode(node, offsetAddress);
        this.dispatchVisit(offsetAddress, ast);
      }
      return;
    }

    throw new NotSupportedYetError(`Unhandled index access case ${printNode(node)}`);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);
    if (this.reads.has(node) && this.storageRefs.has(node)) {
      const parent = node.parent;
      const replacement = ast
        .getUtilFuncGen(node)
        .storage.read.gen(node, typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast));
      ast.replaceNode(node, replacement, parent);
    }
  }
}

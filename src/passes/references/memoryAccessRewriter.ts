import assert = require('assert');
import {
  ArrayType,
  ArrayTypeName,
  Assignment,
  ASTNode,
  DataLocation,
  FunctionCall,
  FunctionDefinition,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  PointerType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { error } from '../../utils/formatting';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { createUint256Literal, createUint256TypeName } from '../../utils/nodeTemplates';
import { dereferenceType, isExternallyVisible, typeNameFromTypeNode } from '../../utils/utils';

export class MemoryAccessRewriter extends ASTMapper {
  constructor(public reads: Set<ASTNode>, public memoryRefs: Set<ASTNode>) {
    super();
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (this.memoryRefs.has(node.vLeftHandSide)) {
      const replacementFunc = ast
        .getUtilFuncGen(node)
        .memory.write.gen(node.vLeftHandSide, node.vRightHandSide);
      ast.replaceNode(node, replacementFunc);
    }
    this.visitExpression(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    if (!this.reads.has(node) || !this.memoryRefs.has(node)) {
      this.visitExpression(node, ast);
      return;
    }

    const decl = node.vReferencedDeclaration;
    if (decl === undefined || !(decl instanceof VariableDeclaration)) {
      throw new NotSupportedYetError(
        `Non-variable memory identifier ${printNode(node)} not supported`,
      );
    }

    assert(
      decl.vType !== undefined,
      error('VariableDeclaration.vType should be defined for compiler versions > 0.4.x'),
    );

    const parent = node.parent;
    const replacementFunc = ast.getUtilFuncGen(node).memory.read.gen(node, decl.vType);
    ast.replaceNode(node, replacementFunc, parent);
    // Do not recurse
    // The only argument to replacementFunc is node,
    // recursing would cause an infinite loop
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (!this.memoryRefs.has(node)) {
      this.visitExpression(node, ast);
      return;
    }

    const type = getNodeType(node.vExpression, ast.compilerVersion);

    if (type instanceof PointerType && type.location === DataLocation.Memory) {
      const utilFuncGen = ast.getUtilFuncGen(node);
      // To transform a struct member access to cairo, there are two steps
      // First get the location in memory of the specific struct member
      // Then use a standard memory read call to read it out
      const referencedDeclaration = node.vReferencedDeclaration;
      assert(referencedDeclaration instanceof VariableDeclaration);
      assert(referencedDeclaration.vType !== undefined);
      const replacementAccessFunc = utilFuncGen.memory.memberAccess.gen(node);
      if (this.reads.has(node)) {
        const replacementReadFunc = utilFuncGen.memory.read.gen(
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
    if (baseType instanceof PointerType && baseType.location === DataLocation.Memory) {
      let offsetAddress: FunctionCall;
      if (baseType.to instanceof ArrayType) {
        if (baseType.to.size === undefined) {
          offsetAddress = createDynArrayIndexAccess(node, ast);
        } else {
          offsetAddress = ast
            .getUtilFuncGen(node)
            .memory.staticArrayIndexAccess.gen(node, baseType.to);
        }
      } else {
        throw new TranspileFailedError(
          `Unexpected index access base type ${printTypeNode(baseType.to)} at ${printNode(node)}`,
        );
      }
      if (this.reads.has(node)) {
        const readFunction = ast
          .getUtilFuncGen(node)
          .memory.read.gen(
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

    this.visitExpression(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    if (this.reads.has(node) && this.memoryRefs.has(node)) {
      const parent = node.parent;
      const replacement = ast
        .getUtilFuncGen(node)
        .memory.read.gen(node, typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast));
      ast.replaceNode(node, replacement, parent);
    }
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (isExternallyVisible(node)) {
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_new');
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_finalize');
    }

    this.commonVisit(node, ast);
  }
}

function createDynArrayIndexAccess(indexAccess: IndexAccess, ast: AST): FunctionCall {
  const arrayType = dereferenceType(getNodeType(indexAccess.vBaseExpression, ast.compilerVersion));
  const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
  assert(
    arrayTypeName instanceof ArrayTypeName,
    `Created unexpected typename ${printNode(arrayTypeName)} for base of ${printNode(indexAccess)}`,
  );

  const stub = createCairoFunctionStub(
    'wm_index_dyn',
    [
      ['arrayLoc', arrayTypeName],
      ['index', createUint256TypeName(ast)],
      ['width', createUint256TypeName(ast)],
    ],
    [['loc', cloneASTNode(arrayTypeName.vBaseType, ast)]],
    ['range_check_ptr', 'warp_memory'],
    ast,
    indexAccess,
  );

  assert(indexAccess.vIndexExpression);
  assert(arrayType instanceof ArrayType);
  const elementCairTypeWidth = CairoType.fromSol(
    arrayType.elementT,
    ast,
    TypeConversionContext.MemoryAllocation,
  ).width;

  const call = createCallToFunction(
    stub,
    [
      indexAccess.vBaseExpression,
      indexAccess.vIndexExpression,
      createUint256Literal(BigInt(elementCairTypeWidth), ast),
    ],
    ast,
  );

  ast.registerImport(call, 'warplib.memory', 'wm_index_dyn');

  return call;
}

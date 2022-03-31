import assert = require('assert');
import {
  ArrayTypeName,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  NewExpression,
  PointerType,
  TupleExpression,
  typeNameToTypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { createUint256Literal, createUint256TypeName } from '../../utils/nodeTemplates';

export class MemoryAllocations extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);
    processIfMemoryStructConstructor(node, ast);
    processIfDynArrayAllocation(node, ast);
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    this.visitExpression(node, ast);

    if (!node.isInlineArray) return;

    ast.replaceNode(node, ast.getUtilFuncGen(node).memory.arrayLiteral.gen(node));
  }
}

function processIfMemoryStructConstructor(node: FunctionCall, ast: AST) {
  if (node.kind !== FunctionCallKind.StructConstructorCall) return;

  const nodeType = getNodeType(node, ast.compilerVersion);
  assert(nodeType instanceof PointerType);
  if (nodeType.location !== DataLocation.Memory) return;

  ast.replaceNode(node, ast.getUtilFuncGen(node).memory.struct.gen(node));
}

function processIfDynArrayAllocation(node: FunctionCall, ast: AST) {
  if (!(node.vExpression instanceof NewExpression)) return;

  assert(
    node.vArguments.length === 1,
    `Expected new expression ${printNode(node)} to have one argument, has ${
      node.vArguments.length
    }`,
  );

  const stub = createCairoFunctionStub(
    'wm_new',
    [
      ['len', createUint256TypeName(ast)],
      ['elemWidth', createUint256TypeName(ast)],
    ],
    [['loc', node.vExpression.vTypeName]],
    ['range_check_ptr', 'warp_memory'],
    ast,
    node,
  );

  assert(node.vExpression.vTypeName instanceof ArrayTypeName);

  const elementCairoType = CairoType.fromSol(
    typeNameToTypeNode(node.vExpression.vTypeName.vBaseType),
    ast,
    TypeConversionContext.MemoryAllocation,
  );

  const call = createCallToFunction(
    stub,
    [node.vArguments[0], createUint256Literal(BigInt(elementCairoType.width), ast)],
    ast,
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, 'warplib.memory', 'wm_new');
}

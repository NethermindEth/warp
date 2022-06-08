import assert from 'assert';
import {
  ArrayTypeName,
  BytesType,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  generalizeType,
  getNodeType,
  Literal,
  NewExpression,
  StringType,
  TupleExpression,
  typeNameToTypeNode,
} from 'solc-typed-ast';
import { ReferenceSubPass } from './referenceSubPass';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';

/*
  TODO update description
  Handles expressions that directly insert data into memory: struct constructors, news, and inline arrays
  Requires expected data location analysis to determine whether to insert objects into memory
  For memory objects, functions are generated that return a felt associated with the start of the data
  For others, they are as explicit expressions to be transpiled to cairo
*/
export class MemoryAllocations extends ReferenceSubPass {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (
      node.kind === FunctionCallKind.StructConstructorCall &&
      this.expectedDataLocations.get(node) === DataLocation.Memory
    ) {
      const replacement = ast.getUtilFuncGen(node).memory.struct.gen(node);
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
    } else if (node.vExpression instanceof NewExpression) {
      if (actualLoc === DataLocation.Memory) {
        this.allocateMemoryDynArray(node, ast);
      } else {
        throw new NotSupportedYetError(
          `Allocating dynamic ${
            actualLoc ?? 'unknown-location'
          } arrays not implemented yet (${printNode(node)})`,
        );
      }
    } else if (node.kind === FunctionCallKind.TypeConversion) {
      const type = generalizeType(getNodeType(node, ast.compilerVersion))[0];
      const arg = node.vArguments[0];
      if ((type instanceof BytesType || type instanceof StringType) && arg instanceof Literal) {
        const replacement = ast.getUtilFuncGen(node).memory.arrayLiteral.stringGen(arg);
        this.replace(node, replacement, node.parent, actualLoc, expectedLoc, ast);
      }
    }
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    this.visitExpression(node, ast);

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (!node.isInlineArray) return;

    const replacement = ast.getUtilFuncGen(node).memory.arrayLiteral.tupleGen(node);
    this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
  }

  allocateMemoryDynArray(node: FunctionCall, ast: AST): void {
    assert(node.vExpression instanceof NewExpression);

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
      [['loc', node.vExpression.vTypeName, DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      ast,
      node,
    );

    assert(node.vExpression.vTypeName instanceof ArrayTypeName);

    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(node.vExpression.vTypeName.vBaseType),
      ast,
    );

    const call = createCallToFunction(
      stub,
      [node.vArguments[0], createNumberLiteral(elementCairoType.width, ast, 'uint256')],
      ast,
    );

    const [actualLoc, expectedLoc] = this.getLocations(node);
    this.replace(node, call, undefined, actualLoc, expectedLoc, ast);
    ast.registerImport(call, 'warplib.memory', 'wm_new');
  }
}

import assert from 'assert';
import {
  ArrayType,
  ArrayTypeName,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  NewExpression,
  PointerType,
  StructDefinition,
  TupleExpression,
  typeNameToTypeNode,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { ReferenceSubPass } from './referenceSubPass';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';

/*
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
      if (this.expectedDataLocations.get(node) === DataLocation.Memory) {
        this.allocateMemoryDynArray(node, ast);
      } else {
        throw new NotSupportedYetError(
          `Allocating dynamic ${
            this.expectedDataLocations.get(node) ?? 'unknown-location'
          } arrays not implemented yet`,
        );
      }
    }
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    this.visitExpression(node, ast);

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (!node.isInlineArray) return;

    const replacement = ast.getUtilFuncGen(node).memory.arrayLiteral.gen(node);
    this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
  }

  allocateMemoryDynArray(node: FunctionCall, ast: AST) {
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
    const typeNode = typeNameToTypeNode(node.vExpression.vTypeName.vBaseType);
    const elementCairoType = CairoType.fromSol(
      typeNode,
      ast,
      this.isReferenceType(typeNode)
        ? TypeConversionContext.Ref
        : TypeConversionContext.MemoryAllocation,
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

  isReferenceType(typeNode: TypeNode): boolean {
    if (
      typeNode instanceof ArrayType ||
      (typeNode instanceof UserDefinedType && typeNode.definition instanceof StructDefinition) ||
      typeNode instanceof PointerType
    ) {
      return true;
    }
    return false;
  }
}

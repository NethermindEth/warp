import assert = require('assert');
import { ArrayType, ASTNode, DataLocation, FunctionCall, IndexAccess } from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { createUint256Literal, createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';

export class MemoryStaticArrayIndexAccessGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    return '';
  }

  gen(indexAccess: IndexAccess, arrayType: ArrayType, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(
      arrayType.size !== undefined,
      `Attempted to use static indexing for dynamic index ${printNode(indexAccess)}`,
    );
    const stub = createCairoFunctionStub(
      'wm_index_static',
      [
        ['arr', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Memory],
        ['index', createUint256TypeName(this.ast)],
        ['width', createUint256TypeName(this.ast)],
        ['length', createUint256TypeName(this.ast)],
      ],
      [['child', typeNameFromTypeNode(arrayType.elementT, this.ast), DataLocation.Memory]],
      ['range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? indexAccess,
    );

    this.ast.registerImport(stub, 'warplib.memory', 'wm_index_static');

    const width = CairoType.fromSol(
      arrayType.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    ).width;

    assert(
      indexAccess.vIndexExpression,
      `Found index access without index expression at ${printNode(indexAccess)}`,
    );
    return createCallToFunction(
      stub,
      [
        indexAccess.vBaseExpression,
        indexAccess.vIndexExpression,
        createUint256Literal(BigInt(width), this.ast),
        createUint256Literal(arrayType.size, this.ast),
      ],
      this.ast,
    );
  }
}

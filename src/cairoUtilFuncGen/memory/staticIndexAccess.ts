import assert = require('assert');
import { ArrayType, DataLocation, FunctionCall, IndexAccess } from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { createCallToFunction } from '../../utils/functionGeneration';
import { TRY_U256_TO_FELT252, WM_INDEX_STATIC } from '../../utils/importPaths';
import {
  createFeltLiteral,
  createFeltTypeName,
  createUint256TypeName,
} from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';

/*
  Produces function stubs for index accesses into statically sized memory arrays
  The actual implementation of this is written in warplib, but for consistency with other
  such cases, this is implemented as a CairoUtilFuncGenBase that produces no code
  The associated warplib function takes the width of the datatype and the length of the array
  as parameters to avoid bloating the code with separate functions for each case
*/
export class MemoryStaticArrayIndexAccessGen extends CairoUtilFuncGenBase {
  gen(indexAccess: IndexAccess, arrayType: ArrayType): FunctionCall {
    assert(
      arrayType.size !== undefined,
      `Attempted to use static indexing for dynamic index ${printNode(indexAccess)}`,
    );
    assert(
      indexAccess.vIndexExpression,
      `Found index access without index expression at ${printNode(indexAccess)}`,
    );

    const importFunc = this.requireImport(
      ...WM_INDEX_STATIC,
      [
        ['arr', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Memory],
        ['index', createFeltTypeName(this.ast)],
        ['width', createFeltTypeName(this.ast)],
        ['length', createFeltTypeName(this.ast)],
      ],
      [['child', typeNameFromTypeNode(arrayType.elementT, this.ast), DataLocation.Memory]],
    );

    const u256ToFelt252 = this.ast.registerImport(
      indexAccess,
      ...TRY_U256_TO_FELT252,
      [['x', createUint256TypeName(this.ast)]],
      [['r', createFeltTypeName(this.ast)]],
    );

    const width = CairoType.fromSol(arrayType.elementT, this.ast).width;
    return createCallToFunction(
      importFunc,
      [
        indexAccess.vBaseExpression,
        createCallToFunction(u256ToFelt252, [indexAccess.vIndexExpression], this.ast),
        createFeltLiteral(width, this.ast),
        createFeltLiteral(arrayType.size, this.ast),
      ],
      this.ast,
    );
  }
}

import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  FunctionCall,
  getNodeType,
  IndexAccess,
  PointerType,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName, createUint256Literal } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';

export class StorageStaticArrayIndexAccessGen extends CairoUtilFuncGenBase {
  private generatedFunction: string | null = null;

  getGeneratedCode(): string {
    return this.generatedFunction ?? '';
  }

  gen(node: IndexAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(node.vIndexExpression !== undefined);

    const name = this.getOrCreate();

    const arrayType = getNodeType(node.vBaseExpression, this.ast.compilerVersion);
    assert(
      arrayType instanceof PointerType &&
        arrayType.to instanceof ArrayType &&
        arrayType.to.size !== undefined,
    );

    const valueType = getNodeType(node, this.ast.compilerVersion);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['index', createUint256TypeName(this.ast)],
        ['size', createUint256TypeName(this.ast)],
        ['limit', createUint256TypeName(this.ast)],
      ],
      [['resLoc', typeNameFromTypeNode(valueType, this.ast), DataLocation.Storage]],
      ['range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(
      functionStub,
      [
        node.vBaseExpression,
        node.vIndexExpression,
        createUint256Literal(
          BigInt(
            CairoType.fromSol(valueType, this.ast, TypeConversionContext.StorageAllocation).width,
          ),
          this.ast,
        ),
        createUint256Literal(arrayType.to.size, this.ast),
      ],
      this.ast,
    );
  }

  private getOrCreate(): string {
    if (this.generatedFunction === null) {
      this.generatedFunction = idxCode;
      this.requireImport('starkware.cairo.common.math', 'split_felt');
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
      this.requireImport('starkware.cairo.common.uint256', 'uint256_le');
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt');
      this.requireImport('starkware.cairo.common.uint256', 'uint256_mul');
    }
    return 'WS0_IDX';
  }
}

const idxCode = [
  `func WS0_IDX{range_check_ptr}(loc: felt, index: Uint256, size: Uint256, limit: Uint256) -> (resLoc: felt):`,
  `    alloc_locals`,
  `    let (inRange) = uint256_lt(index, limit)`,
  `    assert inRange = 1`,
  `    let (locHigh, locLow) = split_felt(loc)`,
  `    let (offset, overflow) = uint256_mul(index, size)`,
  `    assert overflow.low = 0`,
  `    assert overflow.high = 0`,
  `    let (res256, carry) = uint256_add(Uint256(locLow, locHigh), offset)`,
  `    assert carry = 0`,
  `    let (feltLimitHigh, feltLimitLow) = split_felt(-1)`,
  `    let (narrowable) = uint256_le(res256, Uint256(feltLimitLow, feltLimitHigh))`,
  `    assert narrowable = 1`,
  `    return (res256.low + 2**128 * res256.high)`,
  `end`,
].join('\n');

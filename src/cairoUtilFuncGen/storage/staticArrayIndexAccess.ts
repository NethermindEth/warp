import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  FunctionCall,
  IndexAccess,
  PointerType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  SPLIT_FELT,
  UINT256_ADD,
  UINT256_LE,
  UINT256_LT,
  UINT256_MUL,
} from '../../utils/importPaths';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class StorageStaticArrayIndexAccessGen extends StringIndexedFuncGen {
  public gen(node: IndexAccess): FunctionCall {
    assert(node.vIndexExpression !== undefined);

    const arrayType = safeGetNodeType(node.vBaseExpression, this.ast.inference);
    assert(
      arrayType instanceof PointerType &&
        arrayType.to instanceof ArrayType &&
        arrayType.to.size !== undefined,
    );
    const valueType = safeGetNodeType(node, this.ast.inference);

    const funcDef = this.getOrCreateFuncDef(arrayType, valueType);
    return createCallToFunction(
      funcDef,
      [
        node.vBaseExpression,
        node.vIndexExpression,
        createNumberLiteral(
          CairoType.fromSol(valueType, this.ast, TypeConversionContext.StorageAllocation).width,
          this.ast,
          'uint256',
        ),
        createNumberLiteral(arrayType.to.size, this.ast, 'uint256'),
      ],
      this.ast,
    );
  }

  public getOrCreateFuncDef(arrayType: TypeNode, valueType: TypeNode) {
    const key = arrayType.pp() + valueType.pp();
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate();
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['index', createUint256TypeName(this.ast)],
        ['size', createUint256TypeName(this.ast)],
        ['limit', createUint256TypeName(this.ast)],
      ],
      [['res_loc', typeNameFromTypeNode(valueType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );

    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(): GeneratedFunctionInfo {
    return {
      name: 'WS0_IDX',
      code: [
        `func WS0_IDX{range_check_ptr}(loc: felt, index: Uint256, size: Uint256, limit: Uint256) -> (resLoc: felt){`,
        `    alloc_locals;`,
        `    let (inRange) = uint256_lt(index, limit);`,
        `    assert inRange = 1;`,
        `    let (locHigh, locLow) = split_felt(loc);`,
        `    let (offset, overflow) = uint256_mul(index, size);`,
        `    assert overflow.low = 0;`,
        `    assert overflow.high = 0;`,
        `    let (res256, carry) = uint256_add(Uint256(locLow, locHigh), offset);`,
        `    assert carry = 0;`,
        `    let (feltLimitHigh, feltLimitLow) = split_felt(-1);`,
        `    let (narrowable) = uint256_le(res256, Uint256(feltLimitLow, feltLimitHigh));`,
        `    assert narrowable = 1;`,
        `    return (res256.low + 2**128 * res256.high,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...SPLIT_FELT),
        this.requireImport(...UINT256_ADD),
        this.requireImport(...UINT256_LE),
        this.requireImport(...UINT256_LT),
        this.requireImport(...UINT256_MUL),
      ],
    };
  }
}

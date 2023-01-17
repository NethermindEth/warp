import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  FunctionCall,
  FunctionDefinition,
  IndexAccess,
  PointerType,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase, GeneratedFunctionInfo } from '../base';

export class StorageStaticArrayIndexAccessGen extends CairoUtilFuncGenBase {
  private generatedFunctionInfo: GeneratedFunctionInfo | undefined = undefined;

  getGeneratedCode(): GeneratedFunctionInfo | undefined {
    return this.generatedFunctionInfo ?? undefined;
  }

  gen(node: IndexAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(node.vIndexExpression !== undefined);

    const funcInfo = this.getOrCreate();

    const arrayType = safeGetNodeType(node.vBaseExpression, this.ast.compilerVersion);
    assert(
      arrayType instanceof PointerType &&
        arrayType.to instanceof ArrayType &&
        arrayType.to.size !== undefined,
    );

    const valueType = safeGetNodeType(node, this.ast.compilerVersion);

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
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

  private getOrCreate(): GeneratedFunctionInfo {
    if (this.generatedFunctionInfo !== undefined) {
      return this.generatedFunctionInfo;
    }
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.math', 'split_felt'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_le'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_mul'),
    );
    const funcInfo: GeneratedFunctionInfo = {
      name: 'WS0_IDX',
      code: idxCode,
      functionsCalled: funcsCalled,
    };
    this.generatedFunctionInfo = funcInfo;
    return funcInfo;
  }
}

const idxCode = [
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
].join('\n');

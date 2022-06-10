import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { isDynamicStorageArray } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { getBaseType, getNestedNumber } from '../memory/implicitConversion';
import { DynArrayGen } from '../storage/dynArray';
import { DynArrayIndexAccessGen } from '../storage/dynArrayIndexAccess';
import { StorageWriteGen } from '../storage/storageWrite';
// ADD WARP_USED_STORAGE!
// There are 3 conditions here:
// These are only supported with ints.
// The first is that any static calldata array can become a larger storage static array uint[2] -> uint[3].
// The second is that any static calldata array can become a dynamic calldata array uint[2] -> uint[].
// The third is that any int can become a larger int in the above two cases uint8[2] -> uint256[]
export class StaticToDynArray extends StringIndexedFuncGen {
  constructor(
    private storageWriteGen: StorageWriteGen,
    private dynArrayGen: DynArrayGen,
    private dynArrayIndexAccessGen: DynArrayIndexAccessGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  genIfNecessary(
    targetExpression: Expression,
    sourceExpression: Expression,
  ): [Expression, boolean] {
    const lhsType = generalizeType(getNodeType(targetExpression, this.ast.compilerVersion))[0];
    const rhsType = generalizeType(getNodeType(sourceExpression, this.ast.compilerVersion))[0];

    if (this.checkDims(lhsType, rhsType) || this.checkSizes(lhsType, rhsType)) {
      return [this.gen(targetExpression, sourceExpression), true];
    } else {
      return [sourceExpression, false];
    }
  }
  checkSizes(lhsType: TypeNode, rhsType: TypeNode): boolean {
    const lhsBaseType = getBaseType(lhsType);
    const rhsBaseType = getBaseType(rhsType);
    assert(lhsBaseType instanceof IntType && rhsBaseType instanceof IntType);
    return (
      (lhsBaseType.nBits > rhsBaseType.nBits && rhsBaseType.signed) ||
      (!lhsBaseType.signed && lhsBaseType.nBits === 256 && 256 > rhsBaseType.nBits)
    );
  }
  // Right now this will only check that the uint[3] -> uint[4]
  checkDims(lhsType: TypeNode, rhsType: TypeNode): boolean {
    const lhsBaseType = generalizeType(lhsType)[0];
    const rhsBaseType = generalizeType(rhsType)[0];

    if (lhsBaseType instanceof ArrayType && rhsBaseType instanceof ArrayType) {
      const lhsSize = lhsBaseType.size;
      const rhsSize = rhsBaseType.size;
      const lhsElm = generalizeType(lhsBaseType.elementT)[0];
      const rhsElm = generalizeType(rhsBaseType.elementT)[0];

      //Checking for staticArrays
      if (lhsSize !== undefined && rhsSize !== undefined) {
        if (lhsSize > rhsSize) {
          return true;
        } else if (lhsElm instanceof ArrayType && rhsElm instanceof ArrayType) {
          return this.checkDims(lhsElm, rhsElm);
        } else {
          return false;
        }
      } else if (lhsSize === undefined && rhsSize !== undefined) {
        return true;
      } else if (lhsSize === undefined && rhsSize === undefined)
        if (lhsElm instanceof ArrayType && rhsElm instanceof ArrayType) {
          return this.checkDims(lhsElm, rhsElm);
        }
    } else {
      return false;
    }
    return false;
  }

  gen(lhs: Expression, rhs: Expression): FunctionCall {
    const lhsType = getNodeType(lhs, this.ast.compilerVersion);
    const rhsType = getNodeType(rhs, this.ast.compilerVersion);

    const name = this.getOrCreate(lhsType, rhsType);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['lhs', typeNameFromTypeNode(lhsType, this.ast), DataLocation.Storage],
        ['rhs', typeNameFromTypeNode(rhsType, this.ast), DataLocation.CallData],
      ],
      [['lhs', typeNameFromTypeNode(lhsType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'bitwise_ptr', 'range_check_ptr', 'pedersen_ptr', 'bitwise_ptr'],
      this.ast,
      rhs,
    );
    return createCallToFunction(
      functionStub,
      [cloneASTNode(lhs, this.ast), cloneASTNode(rhs, this.ast)],
      this.ast,
    );
  }

  getOrCreate(targetType: TypeNode, sourceType: TypeNode): string {
    const targetCairoType = CairoType.fromSol(
      generalizeType(targetType)[0],
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const sourceCairoType = CairoType.fromSol(
      generalizeType(sourceType)[0],
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const targetBaseCairoType = CairoType.fromSol(
      getBaseType(targetType),
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const sourceBaseCairoType = CairoType.fromSol(
      getBaseType(sourceType),
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const key = `${targetCairoType.fullStringRepresentation}_${targetBaseCairoType} -> ${
      sourceCairoType.fullStringRepresentation
    }_${getNestedNumber(targetType)}_${sourceBaseCairoType}_${getNestedNumber(sourceType)}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    let cairoFunc: CairoFunction;
    if (targetType.to.size === undefined && sourceType.to.size === undefined) {
      cairoFunc = this.DynamicToDynamicConversion(key, targetType, sourceType);
    } else if (targetType.to.size === undefined && sourceType.to.size !== undefined) {
      cairoFunc = this.staticToDynamicConversion(key, targetType, sourceType);
    } else {
      cairoFunc = this.staticToStaticConversion(key, targetType, sourceType);
    }
    return cairoFunc.name;
  }

  private staticToStaticConversion(
    key: string,
    targetType: TypeNode,
    sourceType: TypeNode,
  ): CairoFunction {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(
      targetType.to.size !== undefined &&
        sourceType.to.size !== undefined &&
        targetType.to.size >= sourceType.to.size,
    );

    const targetElementType = targetType.to.elementT;

    const funcName = `CD_ST_TO_ST${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const sourceElementType = sourceType.to.elementT;

    const cairoTargetElementType = CairoType.fromSol(
      targetType.to.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoSourceTypeString = cairoSourceType.toString();

    const sizeSource = narrowBigIntSafe(sourceType.to.size);
    const sizeTarget = narrowBigIntSafe(targetType.to.size);

    assert(sizeSource !== undefined && sizeTarget !== undefined);
    // Make sure these are the right way round.
    let offset = 0;
    const conversionCode = mapRange(sizeSource, (index) => {
      if (targetElementType instanceof IntType) {
        assert(sourceElementType instanceof IntType);
        if (targetElementType.signed) {
          this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}`,
          );
          const code = [
            `    let (target_elem${index}) = warp_int${sourceElementType.nBits}_to_int${
              targetElementType.nBits
            }(source_elem[${index}])
               ${this.storageWriteGen.getOrCreate(targetElementType)}(${add(
              'loc',
              offset,
            )}, target_elem${index})`,
          ].join('\n');
          offset = offset + cairoTargetElementType.width;
          return code;
        } else {
          this.requireImport('warplib.maths.utils', 'felt_to_uint256');
          const code = [
            `    let (target_elem${index}) = felt_to_uint256(source_elem[${index}])`,
            `    ${this.storageWriteGen.getOrCreate(targetElementType)}(${add(
              'loc',
              offset,
            )}, target_elem${index})`,
          ].join('\n');
          offset = offset + cairoTargetElementType.width;
          return code;
        }
      } else {
        let code;
        if (isDynamicStorageArray(targetElementType)) {
          code = [
            `let (ref_${index}) = readId(${add('loc', offset)})`,
            `${this.getOrCreate(
              targetElementType,
              sourceElementType,
            )}(ref_${index}, source_elem[${index}])`,
          ].join('\n');
        } else {
          code = [
            `    ${this.getOrCreate(targetElementType, sourceElementType)}(${add(
              'loc',
              offset,
            )}, source_elem[${index}])`,
          ].join('\n');
        }
        offset = offset + cairoTargetElementType.width;
        return code;
      }
    });

    // TODO check implicit order does not matter. //Does not matter.
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(loc: felt, source_elem: ${cairoSourceTypeString}) -> (loc: felt):`,
      `alloc_locals`,
      ...conversionCode,
      '    return (loc)',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  private staticToDynamicConversion(
    key: string,
    targetType: TypeNode,
    sourceType: TypeNode,
  ): CairoFunction {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(targetType.to.size === undefined && sourceType.to.size !== undefined);

    const targetElementType = targetType.to.elementT;

    const funcName = `CD_ST_TO_WS_DY${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const sourceElementType = sourceType.to.elementT;

    const cairoTargetElementType = CairoType.fromSol(
      targetType.to.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoSourceTypeString = cairoSourceType.toString();

    const sizeSource = narrowBigIntSafe(sourceType.to.size);

    assert(sizeSource !== undefined);
    // Make sure these are the right way round.
    let offset = 0;
    const dynArrayLengthName = this.dynArrayGen.gen(cairoTargetElementType)[1];
    const conversionCode = mapRange(sizeSource, (index) => {
      if (targetElementType instanceof IntType) {
        assert(sourceElementType instanceof IntType);
        if (targetElementType.signed) {
          this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}`,
          );
          this.requireImport('starkware.cairo.common.uint256', 'Uint256');
          this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
          // TODO find util to convert index to Uint256
          const code = [
            `    let (target_elem${index}) = warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}(source_elem[${index}])`,
            `    let (loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElementType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.storageWriteGen.getOrCreate(
              targetElementType,
            )}(loc${index}, target_elem${index})`,
          ].join('\n');
          return code;
        } else {
          this.requireImport('warplib.maths.utils', 'felt_to_uint256');
          const code = [
            `    let (target_elem${index}) = felt_to_uint256(source_elem[${index}])`,
            `    let (loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElementType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.storageWriteGen.getOrCreate(
              targetElementType,
            )}(loc${index}, target_elem${index})`,
          ].join('\n');
          return code;
        }
      } else {
        let code;
        if (isDynamicStorageArray(targetElementType)) {
          code = [
            ` let (loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElementType,
            )}(ref, Uint256(${index}, 0))`,
            `let (ref_${index}) = readId(loc${index})`,
            `${dynArrayLengthName}.write(ref_${index}, Uint256(${sizeSource}, 0))`,
            `${this.getOrCreate(
              targetElementType,
              sourceElementType,
            )}(ref_${index}, source_elem[${index}])`,
          ].join('\n');
        } else {
          code = [
            ` let (loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElementType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.getOrCreate(
              targetElementType,
              sourceElementType,
            )}(loc${index}, source_elem[${index}])`,
          ].join('\n');
        }
        offset = offset + cairoTargetElementType.width;
        return code;
      }
    });

    // TODO check implicit order does not matter. //Does not matter.
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(ref: felt, source_elem: ${cairoSourceTypeString}) -> ():`,
      `     alloc_locals`,
      isDynamicStorageArray(targetType)
        ? `    ${dynArrayLengthName}.write(ref, Uint256(${sourceType.to.size}, 0))`
        : '',
      ...conversionCode,
      '    return ()',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////

  private DynamicToDynamicConversion(
    key: string,
    targetType: TypeNode,
    sourceType: TypeNode,
  ): CairoFunction {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(targetType.to.size === undefined && sourceType.to.size === undefined);

    const targetElementType = targetType.to.elementT;

    const funcName = `CD_DY_TO_WS_DY${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const sourceElementType = sourceType.to.elementT;

    const cairoSourceElementType = CairoType.fromSol(
      sourceType.to.elementT,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoTargetElementType = CairoType.fromSol(
      targetType.to.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );
    assert(cairoSourceType instanceof CairoDynArray);
    const cairoSourceTypeString = cairoSourceType.toString();
    const dynArrayLengthName = this.dynArrayGen.gen(cairoTargetElementType)[1];
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const loaderName = `DY_LOADER${this.generatedFunctions.size}`;
    this.requireImport('starkware.cairo.common.math', 'split_felt');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    let code;
    if (sourceElementType instanceof IntType && targetElementType instanceof IntType) {
      this.requireImport(
        'warplib.maths.int_conversions',
        `warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}`,
      );
      this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      code = [
        `func ${loaderName}${implicit}(ref: felt, len: felt, ptr: ${cairoSourceType.ptr_member.toString()}*, target_index: felt ):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `      return ()`,
        `    end`,
        `    let (loc) = ${this.dynArrayIndexAccessGen.getOrCreate(
          targetElementType,
        )}(ref, Uint256(target_index, 0))`,
        `    let target_index = target_index + 1`,
        sourceElementType.signed
          ? `    let (val) = warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}(ptr[0])`
          : `    let (val) = felt_to_uint256(ptr[0])`,
        `    ${this.storageWriteGen.getOrCreate(targetElementType)}(loc, val)`,
        `    return ${loaderName}(ref, len - 1, ptr + ${cairoSourceElementType.width}, target_index)`,
        `end`,
        ``,

        `func ${funcName}${implicit}(ref: felt, source: ${cairoSourceTypeString}) -> ():`,
        `     alloc_locals`,
        `    ${dynArrayLengthName}.write(ref, Uint256(source.len, 0))`,
        `    ${loaderName}(ref, source.len, source.ptr, 0)`,
        '    return ()',
        'end',
      ].join('\n');
    } else {
      code = [
        `func ${loaderName}${implicit}(ref: felt, len: felt, ptr: ${cairoSourceType.ptr_member.toString()}*, target_index: felt ):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `      return ()`,
        `    end`,
        `    let (loc) = ${this.dynArrayIndexAccessGen.getOrCreate(
          targetElementType,
        )}(ref, Uint256(target_index, 0))`,
        isDynamicStorageArray(targetElementType)
          ? `let (ref0) = readId(loc)
          ${this.getOrCreate(targetElementType, sourceElementType)}(ref0, ptr[0])`
          : `    ${this.getOrCreate(targetElementType, sourceElementType)}(loc, ptr[0])`,
        `    return ${loaderName}(ref, len - 1, ptr + ${cairoSourceType.ptr_member.width}, target_index+1)`,
        `end`,
        ``,

        `func ${funcName}${implicit}(ref: felt, source: ${cairoSourceTypeString}) -> ():`,
        `     alloc_locals`,
        `    ${dynArrayLengthName}.write(ref, Uint256(source.len, 0))`,
        `    ${loaderName}(ref, source.len, source.ptr, 0)`,
        '    return ()',
        'end',
      ].join('\n');
    }

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }
}

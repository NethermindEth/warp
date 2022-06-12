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
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { getBaseType, getNestedNumber } from '../memory/implicitConversion';
import { DynArrayGen } from '../storage/dynArray';
import { DynArrayIndexAccessGen } from '../storage/dynArrayIndexAccess';
import { StorageWriteGen } from '../storage/storageWrite';

// STILL LOOKED FOR UTIL THAT CREATES UINT256STRUCT CONSTRUCTOR.
// There are 3 conditions here:
// These are only supported with ints.
// The first is that any static calldata array can become a larger storage static array uint[2] -> uint[3].
// The second is that any static calldata array can become a dynamic calldata array uint[2] -> uint[].
// The third is that any int can become a larger int in the above two cases uint8[2] -> uint256[]

export class ImplicitArrayConversion extends StringIndexedFuncGen {
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
    const targetType = generalizeType(getNodeType(targetExpression, this.ast.compilerVersion))[0];
    const sourceType = generalizeType(getNodeType(sourceExpression, this.ast.compilerVersion))[0];

    if (this.checkDims(targetType, sourceType) || this.checkSizes(targetType, sourceType)) {
      return [this.gen(targetExpression, sourceExpression), true];
    } else {
      return [sourceExpression, false];
    }
  }

  checkSizes(targetType: TypeNode, sourceType: TypeNode): boolean {
    const targetBaseType = getBaseType(targetType);
    const sourceBaseType = getBaseType(sourceType);
    if (targetBaseType instanceof IntType && sourceBaseType instanceof IntType) {
      return (
        (targetBaseType.nBits > sourceBaseType.nBits && sourceBaseType.signed) ||
        (!targetBaseType.signed && targetBaseType.nBits === 256 && 256 > sourceBaseType.nBits)
      );
    }
    return false;
  }

  checkDims(targetType: TypeNode, sourceType: TypeNode): boolean {
    const targetArray = generalizeType(targetType)[0];
    const sourceArray = generalizeType(sourceType)[0];

    if (targetArray instanceof ArrayType && sourceArray instanceof ArrayType) {
      const targetArrayElm = generalizeType(targetArray.elementT)[0];
      const sourceArrayElm = generalizeType(sourceArray.elementT)[0];
      // Check to see if this is done by another pass.
      if (targetArray.size !== undefined && sourceArray.size !== undefined) {
        if (targetArray.size > sourceArray.size) {
          return true;
        } else if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
          return this.checkDims(targetArrayElm, sourceArrayElm);
        } else {
          return false;
        }
      } else if (targetArray.size === undefined && sourceArray.size !== undefined) {
        return true;
      } else if (targetArray.size === undefined && sourceArray.size === undefined)
        if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
          return this.checkDims(targetArrayElm, sourceArrayElm);
        }
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
      [],
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

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_ST_TO_WS_ST${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoSourceTypeString = cairoSourceType.toString();

    const sizeSource = narrowBigIntSafe(sourceType.to.size);
    const sizeTarget = narrowBigIntSafe(targetType.to.size);

    assert(sizeSource !== undefined && sizeTarget !== undefined);
    const copyInstructions = this.generateS2SCopyInstructions(
      targetElmType,
      sourceElmType,
      sizeSource,
    );
    // Make sure these are the right way round.

    // TODO check implicit order does not matter. //Does not matter.
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(storage_loc: felt, arg: ${cairoSourceTypeString}):`,
      `alloc_locals`,
      ...copyInstructions,
      '    return ()',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }

  private generateS2SCopyInstructions(
    targetElmType: TypeNode,
    sourceElmType: TypeNode,
    length: number,
  ): string[] {
    const cairoTargetElementType = CairoType.fromSol(
      targetElmType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    let offset = 0;
    const instructions = mapRange(length, (index) => {
      let code;
      if (targetElmType instanceof IntType) {
        assert(sourceElmType instanceof IntType);
        if (targetElmType.nBits === sourceElmType.nBits) {
          code = `     ${this.storageWriteGen.getOrCreate(targetElmType)}(${add(
            'storage_loc',
            offset,
          )}, arg[${index}])`;
        } else if (targetElmType.signed) {
          code = [
            `    let (arg_${index}) = warp_int${sourceElmType.nBits}_to_int${
              targetElmType.nBits
            }(arg[${index}])
            ${this.storageWriteGen.getOrCreate(targetElmType)}(${add(
              'storage_loc',
              offset,
            )}, arg_${index})`,
          ].join('\n');
          this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
          );
        } else {
          code = [
            `    let (arg_${index}) = felt_to_uint256(arg[${index}])`,
            `    ${this.storageWriteGen.getOrCreate(targetElmType)}(${add(
              'storage_loc',
              offset,
            )}, arg_${index})`,
          ].join('\n');
          this.requireImport('warplib.maths.utils', 'felt_to_uint256');
        }
      } else {
        if (isDynamicStorageArray(targetElmType)) {
          code = [
            `let (ref_${index}) = readId(${add('storage_loc', offset)})`,
            `${this.getOrCreate(targetElmType, sourceElmType)}(ref_${index}, arg[${index}])`,
          ].join('\n');
        } else {
          code = [
            `    ${this.getOrCreate(targetElmType, sourceElmType)}(${add(
              'storage_loc',
              offset,
            )}, arg[${index}])`,
          ].join('\n');
        }
      }
      offset = offset + cairoTargetElementType.width;
      return code;
    });
    return instructions;
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

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_ST_TO_WS_DY${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

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

    const dynArrayLengthName = this.dynArrayGen.gen(cairoTargetElementType)[1];
    const copyInstructions = this.generateS2DCopyInstructions(
      targetElmType,
      sourceElmType,
      sizeSource,
    );

    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(ref: felt, arg: ${cairoSourceTypeString}):`,
      `     alloc_locals`,
      isDynamicStorageArray(targetType)
        ? `    ${dynArrayLengthName}.write(ref, ${sourceType.to.size}, 0))`
        : '',
      ...copyInstructions,
      '    return ()',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }

  private generateS2DCopyInstructions(
    targetElmType: TypeNode,
    sourceElmType: TypeNode,
    length: number,
  ): string[] {
    const cairoTargetElementType = CairoType.fromSol(
      targetElmType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const instructions = mapRange(length, (index) => {
      let code;
      if (targetElmType instanceof IntType) {
        assert(sourceElmType instanceof IntType);
        if (targetElmType.nBits === sourceElmType.nBits) {
          code = [
            `    let (storage_loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElmType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.storageWriteGen.getOrCreate(
              targetElmType,
            )}(storage_loc${index}, arg[${index}])`,
          ].join('\n');
        } else if (targetElmType.signed) {
          // TODO find util to convert index to Uint256
          code = [
            `    let (arg_${index}) = warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}(arg[${index}])`,
            `    let (storage_loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElmType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.storageWriteGen.getOrCreate(
              targetElmType,
            )}(storage_loc${index}, arg_${index})`,
          ].join('\n');

          this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
          );
          this.requireImport('starkware.cairo.common.uint256', 'Uint256');
          this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
          return code;
        } else {
          code = [
            `    let (arg_${index}) = felt_to_uint256(arg[${index}])`,
            `    let (storage_loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElmType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.storageWriteGen.getOrCreate(
              targetElmType,
            )}(storage_loc${index}, arg_${index})`,
          ].join('\n');
          this.requireImport('warplib.maths.utils', 'felt_to_uint256');
          return code;
        }
      } else {
        if (isDynamicStorageArray(targetElmType)) {
          const dynArrayLengthName = this.dynArrayGen.gen(cairoTargetElementType)[1];
          code = [
            ` let (storage_loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElmType,
            )}(ref, Uint256(${index}, 0))`,
            `let (ref_${index}) = readId(storage_loc${index})`,
            `${dynArrayLengthName}.write(ref_${index}, Uint256(${length}, 0))`,
            `${this.getOrCreate(targetElmType, sourceElmType)}(ref_${index}, arg[${index}])`,
          ].join('\n');
        } else {
          code = [
            `     let (storage_loc${index}) = ${this.dynArrayIndexAccessGen.getOrCreate(
              targetElmType,
            )}(ref, Uint256(${index}, 0))`,
            `    ${this.getOrCreate(
              targetElmType,
              sourceElmType,
            )}(storage_loc${index}, arg[${index}])`,
          ].join('\n');
        }
      }
      return code;
    });
    return instructions;
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

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_DY_TO_WS_DY${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

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

    const copyInstructions = this.generateDynCopyInstructions(targetElmType, sourceElmType);

    const code = [
      `func ${loaderName}${implicit}(ref: felt, len: felt, ptr: ${cairoSourceType.ptr_member.toString()}*, target_index: felt):`,
      `    alloc_locals`,
      `    if len == 0:`,
      `      return ()`,
      `    end`,
      `    let (storage_loc) = ${this.dynArrayIndexAccessGen.getOrCreate(
        targetElmType,
      )}(ref, Uint256(target_index, 0))`,
      copyInstructions,

      `    return ${loaderName}(ref, len - 1, ptr + ${cairoSourceType.ptr_member.width}, target_index+ 1 )`,
      `end`,
      ``,
      `func ${funcName}${implicit}(ref: felt, source: ${cairoSourceTypeString}):`,
      `     alloc_locals`,
      `    ${dynArrayLengthName}.write(ref, Uint256(source.len, 0))`,
      `    ${loaderName}(ref, source.len, source.ptr, 0)`,
      '    return ()',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }

  private generateDynCopyInstructions(targetElmType: TypeNode, sourceElmType: TypeNode): string {
    let copyInstructions;
    if (sourceElmType instanceof IntType && targetElmType instanceof IntType) {
      copyInstructions = [
        sourceElmType.signed
          ? `let (val) = warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}(ptr[0])`
          : `    let (val) = felt_to_uint256(ptr[0])`,
        `    ${this.storageWriteGen.getOrCreate(targetElmType)}(storage_loc, val)`,
      ].join('\n');
      this.requireImport(
        'warplib.maths.int_conversions',
        `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
      );
      this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    } else {
      copyInstructions = isDynamicStorageArray(targetElmType)
        ? `let (ref_name) = readId(storage_loc)
          ${this.getOrCreate(targetElmType, sourceElmType)}(ref_name, ptr[0])`
        : `    ${this.getOrCreate(targetElmType, sourceElmType)}(storage_loc, ptr[0])`;
    }
    return copyInstructions;
  }
}

import assert from 'assert';
import {
  AddressType,
  ArrayType,
  DataLocation,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  PointerType,
  SourceUnit,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { isDynamicArray } from '../../utils/nodeTypeProcessing';
import { narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from './memoryRead';
import { MemoryWriteGen } from './memoryWrite';

/*
  Class that converts arrays with smaller element types into bigger types
  e. g. 
    uint8[] -> uint256[]
    uint8[3] -> uint256[]
    uint8[3] -> uint256[3]
    uint8[3] -> uint256[8]
  Only int/uint type implicit conversions
*/

const IMPLICITS = '{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';

export class MemoryImplicitConversionGen extends StringIndexedFuncGen {
  constructor(
    private memoryWrite: MemoryWriteGen,
    private memoryRead: MemoryReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  genIfNecesary(sourceExpression: Expression, targetType: TypeNode): [Expression, boolean] {
    const sourceType = getNodeType(sourceExpression, this.ast.compilerVersion);

    const generalTarget = generalizeType(targetType)[0];
    const generalSource = generalizeType(sourceType)[0];
    if (differentSizeArrays(generalTarget, generalSource)) {
      return [this.gen(sourceExpression, targetType), true];
    }

    const targetBaseType = getBaseType(targetType);
    const sourceBaseType = getBaseType(sourceType);

    // Cast Ints: intY[] -> intX[] with X > Y
    if (
      targetBaseType instanceof IntType &&
      sourceBaseType instanceof IntType &&
      targetBaseType.signed &&
      targetBaseType.nBits > sourceBaseType.nBits
    ) {
      return [this.gen(sourceExpression, targetType), true];
    }

    if (
      targetBaseType instanceof FixedBytesType &&
      sourceBaseType instanceof FixedBytesType &&
      targetBaseType.size > sourceBaseType.size
    ) {
      return [this.gen(sourceExpression, targetType), true];
    }

    const targetBaseCairoType = CairoType.fromSol(
      targetBaseType,
      this.ast,
      TypeConversionContext.Ref,
    );
    const sourceBaseCairoType = CairoType.fromSol(
      sourceBaseType,
      this.ast,
      TypeConversionContext.Ref,
    );

    // Casts anything with smaller memory space to a bigger one
    // Applies to uint only
    // (uintX[] -> uint256[])
    if (targetBaseCairoType.width > sourceBaseCairoType.width)
      return [this.gen(sourceExpression, targetType), true];

    return [sourceExpression, false];
  }

  gen(source: Expression, targetType: TypeNode): FunctionCall {
    const sourceType = getNodeType(source, this.ast.compilerVersion);

    const name = this.getOrCreate(targetType, sourceType);

    const functionStub = createCairoFunctionStub(
      name,
      [['source', typeNameFromTypeNode(sourceType, this.ast), DataLocation.Memory]],
      [['target', typeNameFromTypeNode(targetType, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'bitwise_ptr', 'warp_memory'],
      this.ast,
      this.sourceUnit,
    );

    return createCallToFunction(functionStub, [source], this.ast);
  }

  getOrCreate(targetType: TypeNode, sourceType: TypeNode): string {
    const key = targetType.pp() + sourceType.pp();

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    targetType = targetType.to;
    sourceType = sourceType.to;

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Scaling ${printTypeNode(sourceType)} to ${printTypeNode(
          targetType,
        )} from memory to storage not implemented yet`,
      );
    };

    const cairoFunc = delegateBasedOnType<CairoFunction>(
      targetType,
      (targetType) => {
        assert(targetType instanceof ArrayType && sourceType instanceof ArrayType);
        return sourceType.size === undefined
          ? this.dynamicToDynamicArrayConversion(targetType, sourceType)
          : this.staticToDynamicArrayConversion(targetType, sourceType);
      },
      (targetType) => {
        assert(sourceType instanceof ArrayType);
        return this.staticToStaticArrayConversion(targetType, sourceType);
      },
      unexpectedTypeFunc,
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );

    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  private staticToStaticArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): CairoFunction {
    assert(
      targetType.size !== undefined &&
        sourceType.size !== undefined &&
        targetType.size >= sourceType.size,
    );
    const [cairoTargetElementType, cairoSourceElementType] = typesToCairoTypes(
      [targetType.elementT, sourceType.elementT],
      this.ast,
      TypeConversionContext.Ref,
    );

    const sourceLoc = `${getOffset('source', 'index', cairoSourceElementType.width)}`;
    let sourceLocationCode;
    if (targetType.elementT instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_read_id');
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationCode = `let (source_elem) = wm_read_id(${sourceLoc}, ${uint256(idAllocSize)})`;
    } else {
      sourceLocationCode = `let (source_elem) = ${this.memoryRead.getOrCreate(
        cairoSourceElementType,
      )}(${sourceLoc})`;
    }

    const conversionCode = this.generateScalingCode(targetType.elementT, sourceType.elementT);

    const targetLoc = `${getOffset('target', 'index', cairoTargetElementType.width)}`;
    const targetCopyCode = `${this.memoryWrite.getOrCreate(
      targetType.elementT,
    )}(${targetLoc}, target_elem)`;

    const allocSize = narrowBigIntSafe(targetType.size) * cairoTargetElementType.width;
    const funcName = `memory_conversion_static_to_static${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : felt):`,
      `   alloc_locals`,
      `   if index == ${sourceType.size}:`,
      `       return ()`,
      `   end`,
      `   ${sourceLocationCode}`,
      `   ${conversionCode}`,
      `   ${targetCopyCode}`,
      `   return ${funcName}_copy(source, target, index + 1)`,
      `end`,

      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   let (target) = wm_alloc(${uint256(allocSize)})`,
      `   ${funcName}_copy(source, target, 0)`,
      `   return(target)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_alloc');

    return { name: funcName, code: code };
  }

  private staticToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): CairoFunction {
    assert(sourceType.size !== undefined);
    const [cairoTargetElementType, cairoSourceElementType] = typesToCairoTypes(
      [targetType.elementT, sourceType.elementT],
      this.ast,
      TypeConversionContext.Ref,
    );
    const sourceTWidth = cairoSourceElementType.width;
    const targetTWidth = cairoTargetElementType.width;

    const sourceLocationCode = ['let felt_index = index.low + index.high * 128'];
    if (sourceType.elementT instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_read_id');
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationCode.push(
        `let (source_elem) = wm_read_id(${getOffset(
          'source',
          'felt_index',
          sourceTWidth,
        )}, ${uint256(idAllocSize)})`,
      );
    } else {
      sourceLocationCode.push(
        `let (source_elem) = ${this.memoryRead.getOrCreate(cairoSourceElementType)}(${getOffset(
          'source',
          'felt_index',
          sourceTWidth,
        )})`,
      );
    }

    const conversionCode = this.generateScalingCode(targetType.elementT, sourceType.elementT);

    const targetCopyCode = [
      `let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(targetTWidth)})`,
      `${this.memoryWrite.getOrCreate(targetType.elementT)}(target_elem_loc, target_elem)`,
    ];

    const funcName = `memory_conversion_static_to_dynamic${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : Uint256, len : Uint256):`,
      `   alloc_locals`,
      `   if len.low == index.low:`,
      `       if len.high == index.high:`,
      `           return ()`,
      `       end`,
      `   end`,
      ...sourceLocationCode,
      `   ${conversionCode}`,
      ...targetCopyCode,
      `   let (next_index, _) = uint256_add(index, ${uint256(1)})`,
      `   return ${funcName}_copy(source, target, next_index, len)`,
      `end`,
      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   let len = ${uint256(sourceType.size)}`,
      `   let (target) = wm_new(len, ${uint256(targetTWidth)})`,
      `   ${funcName}_copy(source, target, Uint256(0, 0), len)`,
      `   return (target=target)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.memory', 'wm_new');

    return { name: funcName, code: code };
  }

  private dynamicToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): CairoFunction {
    const [cairoTargetElementType, cairoSourceElementType] = typesToCairoTypes(
      [targetType.elementT, sourceType.elementT],
      this.ast,
      TypeConversionContext.Ref,
    );
    const sourceTWidth = cairoSourceElementType.width;
    const targetTWidth = cairoTargetElementType.width;

    const sourceLocationCode = [
      `let (source_elem_loc) = wm_index_dyn(source, index, ${uint256(sourceTWidth)})`,
    ];
    if (sourceType.elementT instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_read_id');
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationCode.push(
        `let (source_elem) = wm_read_id(source_elem_loc, ${uint256(idAllocSize)})`,
      );
    } else {
      sourceLocationCode.push(
        `let (source_elem) = ${this.memoryRead.getOrCreate(
          cairoSourceElementType,
        )}(source_elem_loc)`,
      );
    }

    const conversionCode = this.generateScalingCode(targetType.elementT, sourceType.elementT);

    const targetCopyCode = [
      `let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(targetTWidth)})`,
      `${this.memoryWrite.getOrCreate(targetType.elementT)}(target_elem_loc, target_elem)`,
    ];

    const targetWidth = cairoTargetElementType.width;
    const funcName = `memory_conversion_dynamic_to_dynamic${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : Uint256, len : Uint256):`,
      `   alloc_locals`,
      `   if len.low == index.low:`,
      `       if len.high == index.high:`,
      `           return ()`,
      `       end`,
      `   end`,
      ...sourceLocationCode,
      `   ${conversionCode}`,
      ...targetCopyCode,
      `   let (next_index, _) = uint256_add(index, ${uint256(1)})`,
      `   return ${funcName}_copy(source, target, next_index, len)`,
      `end`,

      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   let (len) = wm_dyn_array_length(source)`,
      `   let (target) = wm_new(len, ${uint256(targetWidth)})`,
      `   ${funcName}_copy(source, target, Uint256(0, 0), len)`,
      `   return (target=target)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.memory', 'wm_new');

    return { name: funcName, code: code };
  }

  private generateScalingCode(targetType: TypeNode, sourceType: TypeNode) {
    if (targetType instanceof IntType) {
      assert(sourceType instanceof IntType);
      return this.generateIntegerScalingCode(targetType, sourceType, 'target_elem', 'source_elem');
    } else if (targetType instanceof FixedBytesType) {
      assert(sourceType instanceof FixedBytesType);
      return this.generateFixedBytesScalingCode(
        targetType,
        sourceType,
        'target_elem',
        'source_elem',
      );
    } else if (targetType instanceof PointerType) {
      assert(sourceType instanceof PointerType);
      return `let (target_elem) = ${this.getOrCreate(targetType, sourceType)}(source_elem)`;
    } else if (isNoScalableType(targetType)) {
      return `let target_elem = source_elem`;
    } else {
      throw new TranspileFailedError(
        `Cannot scale ${printTypeNode(sourceType)} into ${printTypeNode(
          targetType,
        )} from memory to strage`,
      );
    }
  }

  private generateIntegerScalingCode(
    targetType: IntType,
    sourceType: IntType,
    targetVar: string,
    sourceVar: string,
  ): string {
    if (targetType.signed && targetType.nBits !== sourceType.nBits) {
      const conversionFunc = `warp_int${sourceType.nBits}_to_int${targetType.nBits}`;
      this.requireImport('warplib.maths.int_conversions', conversionFunc);
      return `let (${targetVar}) = ${conversionFunc}(${sourceVar})`;
    } else if (!targetType.signed && targetType.nBits === 256 && sourceType.nBits < 256) {
      const conversionFunc = `felt_to_uint256`;
      this.requireImport('warplib.maths.utils', conversionFunc);
      return `let (${targetVar}) = ${conversionFunc}(${sourceVar})`;
    } else {
      return `let ${targetVar} = ${sourceVar}`;
    }
  }

  private generateFixedBytesScalingCode(
    targetType: FixedBytesType,
    sourceType: FixedBytesType,
    targetVar: string,
    sourceVar: string,
  ): string {
    const widthDiff = targetType.size - sourceType.size;
    if (widthDiff === 0) {
      return `let ${targetVar} = ${sourceVar}`;
    }

    const conversionFunc = targetType.size === 32 ? 'warp_bytes_widen_256' : 'warp_bytes_widen';
    this.requireImport('warplib.maths.bytes_conversions', conversionFunc);

    return `let (${targetVar}) = ${conversionFunc}(${sourceVar}, ${widthDiff * 8})`;
  }
}

export function getBaseType(type: TypeNode): TypeNode {
  const deferencedType = generalizeType(type)[0];
  return deferencedType instanceof ArrayType
    ? getBaseType(deferencedType.elementT)
    : deferencedType;
}

export function getNestedNumber(type: TypeNode): string {
  const generalType = generalizeType(type)[0];
  return generalType instanceof ArrayType
    ? (generalType.size === undefined ? 'D' : `S${generalType.size}`) +
        getNestedNumber(generalType.elementT)
    : '';
}

function typesToCairoTypes(
  types: TypeNode[],
  ast: AST,
  conversionContext: TypeConversionContext,
): CairoType[] {
  return types.map((t) => CairoType.fromSol(t, ast, conversionContext));
}

function getOffset(base: string, index: string, offset: number): string {
  return offset === 0 ? base : offset === 1 ? `${base} + ${index}` : `${base} + ${index}*${offset}`;
}

function differentSizeArrays(targetType: TypeNode, sourceType: TypeNode): boolean {
  if (!(targetType instanceof ArrayType) || !(sourceType instanceof ArrayType)) {
    return false;
  }

  if (isDynamicArray(targetType) && isDynamicArray(sourceType)) {
    return differentSizeArrays(targetType.elementT, sourceType.elementT);
  }

  if (isDynamicArray(targetType)) {
    return true;
  }
  assert(targetType.size !== undefined && sourceType.size !== undefined);
  if (targetType.size > sourceType.size) return true;

  return differentSizeArrays(targetType.elementT, sourceType.elementT);
}

function isNoScalableType(type: TypeNode) {
  return (
    type instanceof AddressType ||
    (type instanceof UserDefinedType && type.definition instanceof EnumDefinition)
  );
}

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
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from './memoryRead';
import { MemoryWriteGen } from './memoryWrite';

/*
  Class that converts arrays with smaller element types into bigger types
  e. g. 
    uint8[] -> uint256[]
    uint8[3] -> uint256[]
    uint8[3] -> uint256[3]
    uint8[3] -> uint256[8] ?
  Only int/uint type implicit conversions
*/
export class MemoryImplicitConversionGen extends StringIndexedFuncGen {
  constructor(private memoryWrite: MemoryWriteGen, private memoryRead: MemoryReadGen, ast: AST) {
    super(ast);
  }

  genIfNecesary(targetExpression: Expression, sourceExpression: Expression): [Expression, boolean] {
    const targetType = getNodeType(targetExpression, this.ast.compilerVersion);
    const sourceType = getNodeType(sourceExpression, this.ast.compilerVersion);

    const targetBaseType = getBaseType(targetType);
    const sourceBaseType = getBaseType(sourceType);

    const targetBaseCairoType = CairoType.fromSol(
      targetBaseType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const sourceBaseCairoType = CairoType.fromSol(
      sourceBaseType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );

    console.log(targetBaseType.pp(), targetBaseCairoType.toString());
    console.log(sourceBaseType.pp(), sourceBaseCairoType.toString());

    return targetBaseCairoType.width > sourceBaseCairoType.width
      ? [this.gen(targetExpression, sourceExpression), true]
      : [sourceExpression, false];
  }

  gen(target: Expression, source: Expression): FunctionCall {
    const targetType = getNodeType(target, this.ast.compilerVersion);
    const sourceType = getNodeType(source, this.ast.compilerVersion);

    const name = this.getOrCreate(targetType, sourceType);

    const functionStub = createCairoFunctionStub(
      name,
      [['source', typeNameFromTypeNode(sourceType, this.ast), DataLocation.Memory]],
      [['target', typeNameFromTypeNode(targetType, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      target,
    );

    return createCallToFunction(functionStub, [source], this.ast);
  }

  getOrCreate(targetType: TypeNode, sourceType: TypeNode): string {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    const targetBaseCairoType = CairoType.fromSol(
      getBaseType(targetType),
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const sourceBaseCairoType = CairoType.fromSol(
      getBaseType(sourceType),
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    assert(targetBaseCairoType.width > sourceBaseCairoType.width);

    const key = `${targetBaseCairoType.fullStringRepresentation}_${getNestedNumber(
      targetType,
    )}_${getNestedNumber(sourceType)}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoFunc =
      targetType.to.size === undefined
        ? this.dynamicArrayConversion(targetType.to, sourceType.to)
        : this.staticArrayConversion(targetType.to, sourceType.to);

    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  private staticArrayConversion(targetType: ArrayType, sourceType: ArrayType): CairoFunction {
    assert(
      targetType.size !== undefined &&
        sourceType.size !== undefined &&
        targetType.size >= sourceType.size,
    );

    const cairoTargetElementType = CairoType.fromSol(
      targetType.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const cairoSourceElementType = CairoType.fromSol(
      sourceType.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );

    const sourceRead = this.memoryRead.getOrCreate(cairoSourceElementType);
    const sourceLoc = `source ${getOffset('index', cairoSourceElementType.width)}`;
    const conversionCode =
      targetType.elementT instanceof IntType
        ? [
            `let (source_elem) = ${sourceRead}(${sourceLoc})`,
            `let (target_elem) = felt_to_uint256(source_elem)`,
          ]
        : [
            `let (source_elem) = ${sourceRead}(${sourceLoc})`,
            `let (target_elem) = ${this.getOrCreate(
              targetType.elementT,
              sourceType.elementT,
            )}(source_elem)`,
          ];

    const allocSize = narrowBigIntSafe(targetType.size) * cairoTargetElementType.width;

    const funcName = `memory_static_array_conversion${this.generatedFunctions.size}`;
    const implicit = '{range_check_ptr, warp_memory : DictAccess*}';
    const code = [
      `func ${funcName}_copy${implicit}(source : felt, target : felt, index : felt):`,
      `   alloc_locals`,
      `   if index == ${sourceType.size}:`,
      `      return ()`,
      `   end`,
      ...conversionCode,
      `   ${this.memoryWrite.getOrCreate(targetType.elementT)}(target + index * ${
        cairoTargetElementType.width
      }, target_elem)`,
      `   return ${funcName}_copy(source, target, index + 1)`,
      `end`,

      `func ${funcName}${implicit}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   let (target) = wm_alloc(${uint256(allocSize)})`,
      `   ${funcName}_copy(source, target, 0)`,
      `   return(target)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return { name: funcName, code: code };
  }

  private dynamicArrayConversion(targetType: ArrayType, sourceType: ArrayType): CairoFunction {
    const cairoTargetElementType = CairoType.fromSol(
      targetType.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const cairoSourceElementType = CairoType.fromSol(
      sourceType.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );

    const getLen =
      sourceType.size === undefined
        ? `let (len) = wm_dyn_array_length(source)`
        : `let len = ${uint256(sourceType.size)}`;

    const getSourceLoc =
      sourceType.size === undefined
        ? `let (source_elem_loc) = wm_index_dyn(source, index, ${uint256(
            cairoSourceElementType.width,
          )})`
        : [
            `let felt_index = index.low + index.high * 128`,
            `let source_elem_loc = source ${getOffset('felt_index', cairoSourceElementType.width)}`,
          ].join('\n');

    const memoryReadFunc = this.memoryRead.getOrCreate(cairoSourceElementType);
    const conversionCode =
      targetType.elementT instanceof IntType
        ? [
            getSourceLoc,
            `let (source_elem) = ${memoryReadFunc}(source_elem_loc)`,
            `let (target_elem) = felt_to_uint256(source_elem)`,
          ]
        : [
            getSourceLoc,
            // `let (source_elem) = ${memoryReadFunc}(source_elem_loc)`,
            `let (target_elem) = ${this.getOrCreate(
              targetType.elementT,
              sourceType.elementT,
            )}(source_elem_loc)`,
          ];

    const implicit = '{range_check_ptr, warp_memory : DictAccess*}';
    const funcName = `memory_dynamic_array_conversion${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_copy${implicit}(source : felt, target : felt,  len : Uint256):`,
      `   alloc_locals`,
      `   if len.low == 0:`,
      `       if len.high == 0:`,
      `           return ()`,
      `       end`,
      `   end`,
      `   let (index) = uint256_sub(len, ${uint256(1)})`,
      ...conversionCode,
      `   let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(
        cairoTargetElementType.width,
      )})`,
      `   ${this.memoryWrite.getOrCreate(targetType.elementT)}(target_elem_loc, target_elem)`,
      `   return ${funcName}_copy(source, target, index)`,
      `end`,

      `func ${funcName}${implicit}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   ${getLen}`,
      `   let (target) = wm_new(len, ${uint256(cairoTargetElementType.width)})`,
      `   ${funcName}_copy(source, target, len)`,
      `   return (target=target)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('warplib.memory', 'wm_index_dyn');

    return { name: funcName, code: code };
  }
}

function getBaseType(type: TypeNode): TypeNode {
  const generalType = generalizeType(type)[0];
  return generalType instanceof ArrayType ? getBaseType(generalType.elementT) : generalType;
}
function getNestedNumber(type: TypeNode): string {
  const generalType = generalizeType(type)[0];
  return generalType instanceof ArrayType
    ? (generalType.size === undefined ? 'D' : `S${generalType.size}`) +
        getNestedNumber(generalType.elementT)
    : '';
}

function getOffset(index: string, offset: number): string {
  return offset === 0 ? '' : offset === 1 ? `+ ${index}` : `+ ${index} * ${offset}`;
}

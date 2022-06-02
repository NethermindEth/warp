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
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
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
export class MemoryImplicitConversionGen extends StringIndexedFuncGen {
  constructor(private memoryWrite: MemoryWriteGen, private memoryRead: MemoryReadGen, ast: AST) {
    super(ast);
  }

  genIfNecesary(targetExpression: Expression, sourceExpression: Expression): [Expression, boolean] {
    const targetType = getNodeType(targetExpression, this.ast.compilerVersion);
    const sourceType = getNodeType(sourceExpression, this.ast.compilerVersion);

    const targetBaseType = getBaseType(targetType);
    const sourceBaseType = getBaseType(sourceType);
    // Cast Ints: intY[] -> intX[] with X > Y
    if (
      targetBaseType instanceof IntType &&
      sourceBaseType instanceof IntType &&
      targetBaseType.signed &&
      targetBaseType.nBits > sourceBaseType.nBits
    ) {
      return [this.gen(targetExpression, sourceExpression), true];
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
      return [this.gen(targetExpression, sourceExpression), true];

    return [sourceExpression, false];
  }

  gen(target: Expression, source: Expression): FunctionCall {
    const targetType = getNodeType(target, this.ast.compilerVersion);
    const sourceType = getNodeType(source, this.ast.compilerVersion);

    const name = this.getOrCreate(targetType, sourceType);

    const functionStub = createCairoFunctionStub(
      name,
      [['source', typeNameFromTypeNode(sourceType, this.ast), DataLocation.Memory]],
      [['target', typeNameFromTypeNode(targetType, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'bitwise_ptr', 'warp_memory'],
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

  // static array conversion handle all cases wiht any dimension
  // uint8[x] -> uint[y],  with x <= y
  // int8[x] -> int32[y],  with x <= y
  private staticArrayConversion(targetType: ArrayType, sourceType: ArrayType): CairoFunction {
    assert(
      targetType.size !== undefined &&
        sourceType.size !== undefined &&
        targetType.size >= sourceType.size,
    );

    const cairoTargetElementType = CairoType.fromSol(
      targetType.elementT,
      this.ast,
      TypeConversionContext.Ref,
    );
    const cairoSourceElementType = CairoType.fromSol(
      sourceType.elementT,
      this.ast,
      TypeConversionContext.Ref,
    );

    const sourceRead = this.memoryRead.getOrCreate(cairoSourceElementType);
    const sourceLoc = `source ${getOffset('index', cairoSourceElementType.width)}`;
    let conversionCode;
    if (targetType.elementT instanceof IntType) {
      assert(sourceType.elementT instanceof IntType);
      conversionCode = [
        `let (source_elem) = ${sourceRead}(${sourceLoc})`,
        targetType.elementT.signed
          ? `let (target_elem) = warp_int${sourceType.elementT.nBits}_to_int${targetType.elementT.nBits}(source_elem)`
          : `let (target_elem) = felt_to_uint256(source_elem)`,
      ];
    } else {
      conversionCode = [
        `let (source_elem) = wm_read_felt(${sourceLoc})`,
        `let (target_elem) = ${this.getOrCreate(
          targetType.elementT,
          sourceType.elementT,
        )}(source_elem)`,
      ];
    }

    const funcName = `memory_static_array_conversion${this.generatedFunctions.size}`;
    const targetLoc = `target ${getOffset('index', cairoTargetElementType.width)}`;
    const allocSize = narrowBigIntSafe(targetType.size) * cairoTargetElementType.width;
    const implicit = '{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';

    const recursionStopCase =
      targetType.elementT instanceof PointerType && targetType.size !== sourceType.size
        ? [
            `if index == ${targetType.size}:`,
            `    return()`,
            `end`,
            `let (lesser) = is_le(index, ${sourceType.size - 1n})`,
            `if lesser == 0:`,
            `   let (target_elem) = ${this.getOrCreateEmptyArrayInitializer(
              targetType.elementT,
            )}()`,
            `   wm_write_felt(${targetLoc}, target_elem)`,
            `   return ${funcName}_copy(source, target, index + 1)`,
            `end`,
          ]
        : [`if index == ${sourceType.size}:`, `return()`, `end`];

    const code = [
      `func ${funcName}_copy${implicit}(source : felt, target : felt, index : felt):`,
      `   alloc_locals`,
      ...recursionStopCase,
      ...conversionCode,
      `   ${this.memoryWrite.getOrCreate(targetType.elementT)}(${targetLoc}, target_elem)`,
      `   return ${funcName}_copy(source, target, index + 1)`,
      `end`,

      `func ${funcName}${implicit}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   let (target) = wm_alloc(${uint256(allocSize)})`,
      `   ${funcName}_copy(source, target, 0)`,
      `   return(target)`,
      `end`,
    ].join('\n');

    // Import according to how the function was generated
    if (sourceType.elementT instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_read_felt');
      this.requireImport('starkware.cairo.common.math_cmp', 'is_le');
    }
    if (targetType.elementT instanceof IntType) {
      if (targetType.elementT.signed) {
        assert(sourceType.elementT instanceof IntType);
        this.requireImport(
          'warplib.maths.int_conversions',
          `warp_int${sourceType.elementT.nBits}_to_int${targetType.elementT.nBits}`,
        );
      } else {
        this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      }
    }
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return { name: funcName, code: code };
  }

  // dynamic arrays handle all uint/int cases with any dimensionality
  // uint8[] -> uint[]
  // int16[] -> int32[]
  // uint8[n] -> uint[]
  // int16[n] -> int32[]
  private dynamicArrayConversion(targetType: ArrayType, sourceType: ArrayType): CairoFunction {
    const cairoTargetElementType = CairoType.fromSol(
      targetType.elementT,
      this.ast,
      TypeConversionContext.Ref,
    );
    const cairoSourceElementType = CairoType.fromSol(
      sourceType.elementT,
      this.ast,
      TypeConversionContext.Ref,
    );

    const getSourceLoc =
      sourceType.size === undefined
        ? [
            `let (source_elem_loc) = wm_index_dyn(source, index, ${uint256(
              cairoSourceElementType.width,
            )})`,
            sourceType.elementT instanceof PointerType
              ? `let (source_elem_loc) = wm_read_felt(source_elem_loc)`
              : '',
          ]
        : [
            `let felt_index = index.low + index.high * 128`,
            sourceType.elementT instanceof PointerType
              ? `let (source_elem_loc) = wm_read_felt(source + felt_index)`
              : `let source_elem_loc = source ${getOffset(
                  'felt_index',
                  cairoSourceElementType.width,
                )}`,
          ];

    let conversionCode;
    if (targetType.elementT instanceof IntType) {
      assert(sourceType.elementT instanceof IntType);
      conversionCode = [
        ...getSourceLoc,
        `let (source_elem) = ${this.memoryRead.getOrCreate(
          cairoSourceElementType,
        )}(source_elem_loc)`,
        targetType.elementT.signed
          ? `let (target_elem) = warp_int${sourceType.elementT.nBits}_to_int${targetType.elementT.nBits}(source_elem)`
          : `let (target_elem) = felt_to_uint256(source_elem)`,
      ];
    } else {
      conversionCode = [
        ...getSourceLoc,
        `let (target_elem) = ${this.getOrCreate(
          targetType.elementT,
          sourceType.elementT,
        )}(source_elem_loc)`,
      ];
    }

    const getLen =
      sourceType.size === undefined
        ? `let (len) = wm_dyn_array_length(source)`
        : `let len = ${uint256(sourceType.size)}`;

    const targetWidth = cairoTargetElementType.width;
    const implicit = '{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';
    const funcName = `memory_dynamic_array_conversion${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_copy${implicit}(source : felt, target : felt, index : Uint256, len : Uint256):`,
      `   alloc_locals`,
      `   if len.low == index.low:`,
      `       if len.high == index.high:`,
      `           return ()`,
      `       end`,
      `   end`,
      ...conversionCode,
      `   let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(targetWidth)})`,
      `   ${this.memoryWrite.getOrCreate(targetType.elementT)}(target_elem_loc, target_elem)`,
      `   let (next_index, carry) = uint256_add(index, ${uint256(1)})`,
      `   assert carry = 0`,
      `   return ${funcName}_copy(source, target, next_index, len)`,
      `end`,

      `func ${funcName}${implicit}(source : felt) -> (target : felt):`,
      `   alloc_locals`,
      `   ${getLen}`,
      `   let (target) = wm_new(len, ${uint256(targetWidth)})`,
      `   ${funcName}_copy(source, target, Uint256(0, 0), len)`,
      `   return (target=target)`,
      `end`,
    ].join('\n');

    // Import according to how the function was generated
    if (sourceType.elementT instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_read_felt');
    }
    if (targetType.elementT instanceof IntType && targetType.elementT.signed) {
      assert(sourceType.elementT instanceof IntType);
      this.requireImport(
        'warplib.maths.int_conversions',
        `warp_int${sourceType.elementT.nBits}_to_int${targetType.elementT.nBits}`,
      );
    } else {
      this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    }

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('warplib.memory', 'wm_index_dyn');

    return { name: funcName, code: code };
  }

  // Need to create empty array initalizer for unitiniatlized vars of static arrays.
  // For example:
  // uint[3][3] memory X <- uint[2][2] memory Y
  // Y is something like [y_pointer1, y_pointer2] where y_pointer1 -> [a, b]  and y_pointer2 -> [c, d]
  // After converting X will be [x_pointer1, x_pointer2, 0]
  // When reading from the last element of X it will point to memory location 0
  // which will have wrong values.
  // With this function you get
  // X -> [x_pointer1, x_pointer2, x_pointer3] where x_pointer3 -> [0, 0, 0]
  private getOrCreateEmptyArrayInitializer(targetType: PointerType) {
    const targetBaseCairoType = CairoType.fromSol(
      getBaseType(targetType),
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = `empty_initialization${
      targetBaseCairoType.fullStringRepresentation
    }_${getNestedNumber(targetType)}_${getNestedNumber(targetType)}`;

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const empty_init_func = this.generateEmptyArrayIntializer(targetType);
    this.generatedFunctions.set(key, empty_init_func);
    return empty_init_func.name;
  }

  private generateEmptyArrayIntializer(targetType: PointerType): CairoFunction {
    const deferencedType = generalizeType(targetType)[0];
    assert(deferencedType instanceof ArrayType);

    const cairoTargetElementType = CairoType.fromSol(
      deferencedType.elementT,
      this.ast,
      TypeConversionContext.Ref,
    );

    const implicit = '{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';

    // creating empty static array
    if (deferencedType.size !== undefined) {
      const size = narrowBigIntSafe(deferencedType.size);

      const elementT = deferencedType.elementT;

      const recurse =
        elementT instanceof PointerType
          ? mapRange(size, (index) => [
              `let (elem) = ${this.getOrCreateEmptyArrayInitializer(elementT)}()`,
              `wm_write_felt(${add('empty_mem_loc', index * cairoTargetElementType.width)}, elem)`,
            ])
          : [];

      const allocSize = narrowBigIntSafe(deferencedType.size) * cairoTargetElementType.width;
      const funcName = `init_empty_static_${this.generatedFunctions.size}`;
      ('{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}');
      const code = [
        `func ${funcName}${implicit}() -> (empty_mem_loc : felt):`,
        `   alloc_locals`,
        `   let (empty_mem_loc) = wm_alloc(${uint256(allocSize)})`,
        ...recurse,
        `   return (empty_mem_loc)`,
        `end`,
      ].join('\n');

      return { name: funcName, code: code };
    }

    //creating empty dynamic array
    const funcName = `init_empty_dynamic_${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${implicit}() -> (empty_mem_loc):`,
      `    alloc_locals`,
      `    let (empty_mem_loc) = wm_new(${uint256(0)}, ${cairoTargetElementType.width})`,
      `    return (empty_mem_loc)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.memory', 'wm_new');

    return { name: funcName, code: code };
  }
}

function getBaseType(type: TypeNode): TypeNode {
  const deferencedType = generalizeType(type)[0];
  return deferencedType instanceof ArrayType
    ? getBaseType(deferencedType.elementT)
    : deferencedType;
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

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
  IntType,
  PointerType,
  SourceUnit,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition, CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  BYTES_CONVERSIONS,
  FELT_TO_UINT256,
  INDEX_DYN,
  INT_CONVERSIONS,
  NEW,
  READ_ID,
  UINT256,
  UINT256_ADD,
  WARP_ALLOC,
} from '../../utils/importPaths';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from './memoryRead';
import { MemoryWriteGen } from './memoryWrite';

/*
  Class that converts arrays with smaller element types into bigger types
  e.g. 
    uint8[] -> uint256[]
    uint8[3] -> uint256[]
    uint8[3] -> uint256[3]
    uint8[3] -> uint256[8]
  Only int/uint or fixed bytes implicit conversions
*/

const IMPLICITS = '{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';

export class MemoryImplicitConversionGen extends StringIndexedFuncGen {
  public constructor(
    private memoryWrite: MemoryWriteGen,
    private memoryRead: MemoryReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  public genIfNecesary(sourceExpression: Expression, targetType: TypeNode): [Expression, boolean] {
    const sourceType = safeGetNodeType(sourceExpression, this.ast.inference);

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

  public gen(source: Expression, targetType: TypeNode): FunctionCall {
    const sourceType = safeGetNodeType(source, this.ast.inference);

    const funcDef = this.getOrCreateFuncDef(targetType, sourceType);
    return createCallToFunction(funcDef, [source], this.ast);
  }

  public getOrCreateFuncDef(targetType: TypeNode, sourceType: TypeNode) {
    const key = targetType.pp() + sourceType.pp();
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(targetType, sourceType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['source', typeNameFromTypeNode(sourceType, this.ast), DataLocation.Memory]],
      [['target', typeNameFromTypeNode(targetType, this.ast), DataLocation.Memory]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(targetType: TypeNode, sourceType: TypeNode): GeneratedFunctionInfo {
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

    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
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
    return funcInfo;
  }

  private staticToStaticArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
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
    let sourceLocationFunc: CairoFunctionDefinition;
    let sourceLocationCode: string;
    if (targetType.elementT instanceof PointerType) {
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationFunc = this.requireImport(...READ_ID);
      sourceLocationCode = `let (source_elem) = wm_read_id(${sourceLoc}, ${uint256(idAllocSize)});`;
    } else {
      sourceLocationFunc = this.memoryRead.getOrCreateFuncDef(sourceType.elementT);
      sourceLocationCode = `let (source_elem) = ${sourceLocationFunc.name}(${sourceLoc});`;
    }

    const [conversionCode, calledFuncs] = this.generateScalingCode(
      targetType.elementT,
      sourceType.elementT,
    );

    const memoryWriteDef = this.memoryWrite.getOrCreateFuncDef(targetType.elementT);
    const targetLoc = `${getOffset('target', 'index', cairoTargetElementType.width)}`;
    const targetCopyCode = `${memoryWriteDef.name}(${targetLoc}, target_elem);`;

    const allocSize = narrowBigIntSafe(targetType.size) * cairoTargetElementType.width;
    const funcName = `memory_conversion_static_to_static${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : felt){`,
      `   alloc_locals;`,
      `   if (index == ${sourceType.size}){`,
      `       return ();`,
      `   }`,
      `   ${sourceLocationCode}`,
      `   ${conversionCode}`,
      `   ${targetCopyCode}`,
      `   return ${funcName}_copy(source, target, index + 1);`,
      `}`,

      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt){`,
      `   alloc_locals;`,
      `   let (target) = wm_alloc(${uint256(allocSize)});`,
      `   ${funcName}_copy(source, target, 0);`,
      `   return(target,);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport(...UINT256),
        this.requireImport(...WARP_ALLOC),
        sourceLocationFunc,
        ...calledFuncs,
        memoryWriteDef,
      ],
    };
  }

  private staticToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(sourceType.size !== undefined);
    const [cairoTargetElementType, cairoSourceElementType] = typesToCairoTypes(
      [targetType.elementT, sourceType.elementT],
      this.ast,
      TypeConversionContext.Ref,
    );
    const sourceTWidth = cairoSourceElementType.width;
    const targetTWidth = cairoTargetElementType.width;

    const memoryRead = this.memoryRead.getOrCreateFuncDef(sourceType.elementT);
    const sourceLocationCode = ['let felt_index = index.low + index.high * 128;'];
    if (sourceType.elementT instanceof PointerType) {
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationCode.push(
        `let (source_elem) = wm_read_id(${getOffset(
          'source',
          'felt_index',
          sourceTWidth,
        )}, ${uint256(idAllocSize)});`,
      );
    } else {
      sourceLocationCode.push(
        `let (source_elem) = ${memoryRead.name}(${getOffset(
          'source',
          'felt_index',
          sourceTWidth,
        )});`,
      );
    }

    const [conversionCode, conversionFuncs] = this.generateScalingCode(
      targetType.elementT,
      sourceType.elementT,
    );

    const memoryWrite = this.memoryWrite.getOrCreateFuncDef(targetType.elementT);
    const targetCopyCode = [
      `let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(targetTWidth)});`,
      `${memoryWrite.name}(target_elem_loc, target_elem);`,
    ];

    const funcName = `memory_conversion_static_to_dynamic${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : Uint256, len : Uint256){`,
      `   alloc_locals;`,
      `   if (len.low == index.low and len.high == index.high){`,
      `       return ();`,
      `   }`,
      ...sourceLocationCode,
      `   ${conversionCode}`,
      ...targetCopyCode,
      `   let (next_index, _) = uint256_add(index, ${uint256(1)});`,
      `   return ${funcName}_copy(source, target, next_index, len);`,
      `}`,
      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt){`,
      `   alloc_locals;`,
      `   let len = ${uint256(sourceType.size)};`,
      `   let (target) = wm_new(len, ${uint256(targetTWidth)});`,
      `   ${funcName}_copy(source, target, Uint256(0, 0), len);`,
      `   return (target=target,);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport(...UINT256),
        this.requireImport(...UINT256_ADD),
        this.requireImport(...INDEX_DYN),
        this.requireImport(...NEW),
        memoryRead,
        ...conversionFuncs,
        memoryWrite,
      ],
    };
  }

  private dynamicToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
    const [cairoTargetElementType, cairoSourceElementType] = typesToCairoTypes(
      [targetType.elementT, sourceType.elementT],
      this.ast,
      TypeConversionContext.Ref,
    );
    const sourceTWidth = cairoSourceElementType.width;
    const targetTWidth = cairoTargetElementType.width;

    const sourceLocationCode = [
      `let (source_elem_loc) = wm_index_dyn(source, index, ${uint256(sourceTWidth)});`,
    ];

    const memoryRead = this.memoryRead.getOrCreateFuncDef(sourceType.elementT);
    if (sourceType.elementT instanceof PointerType) {
      const idAllocSize = isDynamicArray(sourceType.elementT) ? 2 : cairoSourceElementType.width;
      sourceLocationCode.push(
        `let (source_elem) = wm_read_id(source_elem_loc, ${uint256(idAllocSize)});`,
      );
    } else {
      sourceLocationCode.push(`let (source_elem) = ${memoryRead.name}(source_elem_loc);`);
    }

    const [conversionCode, conversionCalls] = this.generateScalingCode(
      targetType.elementT,
      sourceType.elementT,
    );

    const memoryWrite = this.memoryWrite.getOrCreateFuncDef(targetType.elementT);
    const targetCopyCode = [
      `let (target_elem_loc) = wm_index_dyn(target, index, ${uint256(targetTWidth)});`,
      `${memoryWrite.name}(target_elem_loc, target_elem);`,
    ];

    const targetWidth = cairoTargetElementType.width;
    const funcName = `memory_conversion_dynamic_to_dynamic${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}_copy${IMPLICITS}(source : felt, target : felt, index : Uint256, len : Uint256){`,
      `   alloc_locals;`,
      `   if (len.low == index.low and len.high == index.high){`,
      `       return ();`,
      `   }`,
      ...sourceLocationCode,
      `   ${conversionCode}`,
      ...targetCopyCode,
      `   let (next_index, _) = uint256_add(index, ${uint256(1)});`,
      `   return ${funcName}_copy(source, target, next_index, len);`,
      `}`,

      `func ${funcName}${IMPLICITS}(source : felt) -> (target : felt){`,
      `   alloc_locals;`,
      `   let (len) = wm_dyn_array_length(source);`,
      `   let (target) = wm_new(len, ${uint256(targetWidth)});`,
      `   ${funcName}_copy(source, target, Uint256(0, 0), len);`,
      `   return (target=target,);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport(...UINT256),
        this.requireImport(...UINT256_ADD),
        this.requireImport(...INDEX_DYN),
        this.requireImport(...NEW),
        memoryRead,
        ...conversionCalls,
        memoryWrite,
      ],
    };
  }

  private generateScalingCode(
    targetType: TypeNode,
    sourceType: TypeNode,
  ): [string, CairoFunctionDefinition[]] {
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
      const auxFunc = this.getOrCreateFuncDef(targetType, sourceType);
      return [`let (target_elem) = ${auxFunc.name}(source_elem);`, [auxFunc]];
    } else if (isNoScalableType(targetType)) {
      return [`let target_elem = source_elem;`, []];
    } else {
      throw new TranspileFailedError(
        `Cannot scale ${printTypeNode(sourceType)} into ${printTypeNode(
          targetType,
        )} from memory to storage`,
      );
    }
  }

  private generateIntegerScalingCode(
    targetType: IntType,
    sourceType: IntType,
    targetVar: string,
    sourceVar: string,
  ): [string, CairoImportFunctionDefinition[]] {
    if (targetType.signed && targetType.nBits !== sourceType.nBits) {
      const conversionFunc = `warp_int${sourceType.nBits}_to_int${targetType.nBits}`;
      return [
        `let (${targetVar}) = ${conversionFunc}(${sourceVar});`,
        [this.requireImport(INT_CONVERSIONS, conversionFunc)],
      ];
    } else if (!targetType.signed && targetType.nBits === 256 && sourceType.nBits < 256) {
      return [
        `let (${targetVar}) = felt_to_uint256(${sourceVar});`,
        [this.requireImport(...FELT_TO_UINT256)],
      ];
    } else {
      return [`let ${targetVar} = ${sourceVar};`, []];
    }
  }

  private generateFixedBytesScalingCode(
    targetType: FixedBytesType,
    sourceType: FixedBytesType,
    targetVar: string,
    sourceVar: string,
  ): [string, CairoImportFunctionDefinition[]] {
    const widthDiff = targetType.size - sourceType.size;
    if (widthDiff === 0) {
      return [`let ${targetVar} = ${sourceVar};`, []];
    }

    const conversionFunc = targetType.size === 32 ? 'warp_bytes_widen_256' : 'warp_bytes_widen';

    return [
      `let (${targetVar}) = ${conversionFunc}(${sourceVar}, ${widthDiff * 8});`,
      [this.requireImport(BYTES_CONVERSIONS, conversionFunc)],
    ];
  }
}

export function getBaseType(type: TypeNode): TypeNode {
  const deferencedType = generalizeType(type)[0];
  return deferencedType instanceof ArrayType
    ? getBaseType(deferencedType.elementT)
    : deferencedType;
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

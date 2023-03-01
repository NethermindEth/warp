import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  IntType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { getBaseType } from '../memory/implicitConversion';
import { DynArrayGen } from '../storage/dynArray';
import { DynArrayIndexAccessGen } from '../storage/dynArrayIndexAccess';
import { StorageWriteGen } from '../storage/storageWrite';
import { NotSupportedYetError } from '../../utils/errors';
import { printTypeNode } from '../../utils/astPrinter';

const IMPLICITS =
  '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';

// TODO: Add checks for expressions locations when generating
export class ImplicitArrayConversion extends StringIndexedFuncGen {
  public constructor(
    private storageWriteGen: StorageWriteGen,
    private dynArrayGen: DynArrayGen,
    private dynArrayIndexAccessGen: DynArrayIndexAccessGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  public genIfNecessary(
    targetExpression: Expression,
    sourceExpression: Expression,
  ): [Expression, boolean] {
    const targetType = generalizeType(safeGetNodeType(targetExpression, this.ast.inference))[0];
    const sourceType = generalizeType(safeGetNodeType(sourceExpression, this.ast.inference))[0];

    if (checkDims(targetType, sourceType) || checkSizes(targetType, sourceType)) {
      return [this.gen(targetExpression, sourceExpression), true];
    } else {
      return [sourceExpression, false];
    }
  }

  public gen(lhs: Expression, rhs: Expression): FunctionCall {
    const lhsType = safeGetNodeType(lhs, this.ast.inference);
    const rhsType = safeGetNodeType(rhs, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(lhsType, rhsType);

    return createCallToFunction(
      funcDef,
      [cloneASTNode(lhs, this.ast), cloneASTNode(rhs, this.ast)],
      this.ast,
    );
  }

  public getOrCreateFuncDef(targetType: TypeNode, sourceType: TypeNode) {
    targetType = generalizeType(targetType)[0];
    sourceType = generalizeType(sourceType)[0];
    assert(
      targetType instanceof ArrayType && sourceType instanceof ArrayType,
      `Invalid calldata implicit conversion: Expected ArrayType type but found: ${printTypeNode(
        targetType,
      )} and ${printTypeNode(sourceType)}`,
    );

    const sourceRepForKey = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    ).fullStringRepresentation;

    // Even though the target is in Storage, a unique key is needed to set the function.
    // Using Calldata here gives us the full representation instead of WarpId provided by Storage.
    // This is only for KeyGen and no further processing.
    const targetRepForKey = CairoType.fromSol(
      targetType,
      this.ast,
      TypeConversionContext.CallDataRef,
    ).fullStringRepresentation;

    const targetBaseType = getBaseType(targetType).pp();
    const sourceBaseType = getBaseType(sourceType).pp();
    const key = `${targetRepForKey}_${targetBaseType} -> ${sourceRepForKey}_${sourceBaseType}`;
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(targetType, sourceType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['lhs', typeNameFromTypeNode(targetType, this.ast), DataLocation.Storage],
        ['rhs', typeNameFromTypeNode(sourceType, this.ast), DataLocation.CallData],
      ],
      [],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(targetType: ArrayType, sourceType: ArrayType): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Scaling ${printTypeNode(sourceType)} to ${printTypeNode(
          targetType,
        )} from memory to storage not implemented yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
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
  }

  private staticToStaticArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(targetType.size !== undefined && sourceType.size !== undefined);
    assert(
      targetType.size >= sourceType.size,
      `Cannot convert a bigger static array (${targetType.size}) into a smaller one (${sourceType.size})`,
    );

    const [generateCopyCode, requiredFunctions] = this.createStaticToStaticCopyCode(
      targetType,
      sourceType,
    );

    const sourceSize = narrowBigIntSafe(sourceType.size);
    const targetElementTSize = CairoType.fromSol(
      targetType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const copyInstructions: string[] = mapRange(sourceSize, (index) =>
      generateCopyCode(index, index * targetElementTSize),
    );

    const cairoSourceTypeName = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    ).toString();
    const funcName = `calldata_conversion_static_to_static${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(storage_loc: felt, arg: ${cairoSourceTypeName}){`,
      `alloc_locals;`,
      ...copyInstructions,
      '    return ();',
      '}',
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: requiredFunctions,
    };
  }

  private staticToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(targetType.size === undefined && sourceType.size !== undefined);

    const [generateCopyCode, requiredFunctions] = this.createStaticToDynamicCopyCode(
      targetType,
      sourceType,
    );

    const sourceSize = narrowBigIntSafe(sourceType.size);
    const copyInstructions: string[] = mapRange(sourceSize, (index) => generateCopyCode(index));

    let optionalCode = '';
    let optionalImport: CairoFunctionDefinition[] = [];
    if (isDynamicArray(targetType)) {
      const [_dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(targetType.elementT);
      optionalImport = [dynArrayLength];
      optionalCode = `${dynArrayLength.name}.write(ref, ${uint256(sourceSize)});`;
    }

    const cairoSourceTypeName = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    ).toString();
    const funcName = `calldata_conversion_static_to_dynamic${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(ref: felt, arg: ${cairoSourceTypeName}){`,
      `alloc_locals;`,
      `    ${optionalCode}`,
      ...copyInstructions,
      '    return ();',
      '}',
    ].join('\n');
    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        ...requiredFunctions,
        ...optionalImport,
      ],
    };
  }

  private dynamicToDynamicArrayConversion(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(targetType.size === undefined && sourceType.size === undefined);

    const [_dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(targetType.elementT);
    const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(
      targetType.elementT,
      targetType,
    );

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const [copyInstructions, requiredFunctions] = this.createDyamicToDynamicCopyCode(
      targetType,
      sourceType,
    );

    assert(cairoSourceType instanceof CairoDynArray);
    const funcName = `calldata_conversion_dynamic_to_dynamic${this.generatedFunctionsDef.size}`;
    const recursiveFuncName = `${funcName}_helper`;
    const code = [
      `func ${recursiveFuncName}${IMPLICITS}(ref: felt, len: felt, ptr: ${cairoSourceType.ptr_member.toString()}*, target_index: felt){`,
      `    alloc_locals;`,
      `    if (len == 0){`,
      `      return ();`,
      `    }`,
      `    let (storage_loc) = ${arrayDef.name}(ref, Uint256(target_index, 0));`,
      copyInstructions(),

      `    return ${recursiveFuncName}(ref, len - 1, ptr + ${cairoSourceType.ptr_member.width}, target_index+ 1 );`,
      `}`,
      ``,
      `func ${funcName}${IMPLICITS}(ref: felt, source: ${cairoSourceType.toString()}){`,
      `     alloc_locals;`,
      `    ${dynArrayLength.name}.write(ref, Uint256(source.len, 0));`,
      `    ${recursiveFuncName}(ref, source.len, source.ptr, 0);`,
      '    return ();',
      '}',
    ].join('\n');

    return { name: funcName, code: code, functionsCalled: [...requiredFunctions, dynArrayLength] };
  }

  private createStaticToStaticCopyCode(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): [(index: number, offset: number) => string, CairoFunctionDefinition[]] {
    const targetElementT = targetType.elementT;
    const sourceElementT = sourceType.elementT;

    if (targetElementT instanceof IntType) {
      assert(sourceElementT instanceof IntType);
      const writeToStorage = this.storageWriteGen.getOrCreateFuncDef(targetElementT);
      if (targetElementT.nBits === sourceElementT.nBits) {
        return [
          (index, offset) =>
            `${writeToStorage.name}(${add('storage_loc', offset)}, arg[${index}]);`,
          [writeToStorage],
        ];
      }
      if (targetElementT.signed) {
        const convertionFunc = this.requireImport(
          'warplib.maths.int_conversions',
          `warp_int${sourceElementT.nBits}_to_int${targetElementT.nBits}`,
        );
        return [
          (index, offset) =>
            [
              `    let (arg_${index}) = ${convertionFunc.name}(arg[${index}]);`,
              `    ${writeToStorage.name}(${add('storage_loc', offset)}, arg_${index});`,
            ].join('\n'),
          [writeToStorage, convertionFunc],
        ];
      }
      const toUintFunc = this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      return [
        (index, offset) =>
          [
            `    let (arg_${index}) = ${toUintFunc.name}(arg[${index}]);`,
            `    ${writeToStorage.name}(${add('storage_loc', offset)}, arg_${index});`,
          ].join('\n'),
        [writeToStorage, toUintFunc],
      ];
    }

    if (targetElementT instanceof FixedBytesType) {
      assert(sourceElementT instanceof FixedBytesType);
      const writeToStorage = this.storageWriteGen.getOrCreateFuncDef(targetElementT);
      if (targetElementT.size > sourceElementT.size) {
        const widenFunc = this.requireImport(
          'warplib.maths.bytes_conversions',
          `warp_bytes_widen${targetElementT.size === 32 ? '_256' : ''}`,
        );
        return [
          (index, offset) =>
            [
              `    let (arg_${index}) = ${widenFunc.name}(arg[${index}], ${
                (targetElementT.size - sourceElementT.size) * 8
              });`,
              `    ${writeToStorage.name}(${add('storage_loc', offset)}, arg_${index});`,
            ].join('\n'),
          [writeToStorage, widenFunc],
        ];
      }
      return [
        (index, offset) =>
          `     ${writeToStorage.name}(${add('storage_loc', offset)}, arg[${index}]);`,
        [writeToStorage],
      ];
    }

    const auxFunc = this.getOrCreateFuncDef(targetElementT, sourceElementT);
    return [
      isDynamicArray(targetElementT)
        ? (index, offset) =>
            [
              `    let (ref_${index}) = readId(${add('storage_loc', offset)});`,
              `    ${auxFunc.name}(ref_${index}, arg[${index}]);`,
            ].join('\n')
        : (index, offset) => `    ${auxFunc.name}(${add('storage_loc', offset)}, arg[${index}]);`,
      [auxFunc],
    ];
  }

  private createStaticToDynamicCopyCode(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): [(index: number) => string, CairoFunctionDefinition[]] {
    const targetElmType = targetType.elementT;
    const sourceElmType = sourceType.elementT;

    if (targetElmType instanceof IntType) {
      assert(sourceElmType instanceof IntType);
      const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType, targetType);
      const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
      if (targetElmType.nBits === sourceElmType.nBits) {
        return [
          (index) =>
            [
              `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
              `    ${writeDef.name}(storage_loc${index}, arg[${index}]);`,
            ].join('\n'),
          [arrayDef, writeDef],
        ];
      }
      if (targetElmType.signed) {
        const conversionFunc = this.requireImport(
          'warplib.maths.int_conversions',
          `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
        );
        return [
          (index) =>
            [
              `    let (arg_${index}) = ${conversionFunc.name}(arg[${index}]);`,
              `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
              `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
            ].join('\n'),
          [arrayDef, writeDef, conversionFunc],
        ];
      }
      const toUintFunc = this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      return [
        (index) =>
          [
            `    let (arg_${index}) = ${toUintFunc.name}(arg[${index}]);`,
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
          ].join('\n'),
        [arrayDef, writeDef, toUintFunc],
      ];
    }

    if (targetElmType instanceof FixedBytesType) {
      assert(sourceElmType instanceof FixedBytesType);
      const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType, targetType);
      const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);

      if (targetElmType.size > sourceElmType.size) {
        const widenFunc = this.requireImport(
          'warplib.maths.bytes_conversions',
          `warp_bytes_widen${targetElmType.size === 32 ? '_256' : ''}`,
        );
        const bits = (targetElmType.size - sourceElmType.size) * 8;
        return [
          (index) =>
            [
              `    let (arg_${index}) = ${widenFunc.name}(arg[${index}], ${bits});`,
              `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
              `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
            ].join('\n'),
          [arrayDef, writeDef, widenFunc],
        ];
      }

      return [
        (index) =>
          [
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg[${index}]);`,
          ].join('\n'),
        [arrayDef, writeDef],
      ];
    }

    const sourceSize = sourceType.size;
    assert(sourceSize !== undefined);

    const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType, targetType);
    const auxFunc = this.getOrCreateFuncDef(targetElmType, sourceElmType);
    const [_dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(targetElmType);
    if (isDynamicArray(targetElmType)) {
      return [
        (index) =>
          [
            `     let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `     let (ref_${index}) = readId(storage_loc${index});`,
            // TODO: Potential bug here: when array size is reduced, remaining elements must be
            // deleted. Investigate
            `     ${dynArrayLength.name}.write(ref_${index}, ${uint256(sourceSize)});`,
            `     ${auxFunc.name}(ref_${index}, arg[${index}]);`,
          ].join('\n'),
        [arrayDef, auxFunc, dynArrayLength],
      ];
    }

    return [
      (index) =>
        [
          `     let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
          `    ${auxFunc.name}(storage_loc${index}, arg[${index}]);`,
        ].join('\n'),
      [arrayDef, auxFunc],
    ];
  }

  private createDyamicToDynamicCopyCode(
    targetType: ArrayType,
    sourceType: ArrayType,
  ): [() => string, CairoFunctionDefinition[]] {
    const targetElmType = targetType.elementT;
    const sourceElmType = sourceType.elementT;

    const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);

    if (targetElmType instanceof IntType) {
      assert(sourceElmType instanceof IntType);
      const convertionFunc = targetElmType.signed
        ? this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
          )
        : this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      return [
        () =>
          [
            sourceElmType.signed
              ? `    let (val) = ${convertionFunc.name}(ptr[0]);`
              : `    let (val) = felt_to_uint256(ptr[0]);`,
            `    ${writeDef.name}(storage_loc, val);`,
          ].join('\n'),
        [writeDef, convertionFunc],
      ];
    }

    if (targetElmType instanceof FixedBytesType) {
      assert(sourceElmType instanceof FixedBytesType);
      const widenFunc = this.requireImport(
        'warplib.maths.bytes_conversions',
        `warp_bytes_widen${targetElmType.size === 32 ? '_256' : ''}`,
      );
      const bits = (targetElmType.size - sourceElmType.size) * 8;
      return [
        () =>
          [
            `   let (val) = ${widenFunc.name}(ptr[0], ${bits});`,
            `   ${writeDef.name}(storage_loc, val);`,
          ].join('\n'),
        [writeDef, widenFunc],
      ];
    }

    const auxFunc = this.getOrCreateFuncDef(targetElmType, sourceElmType);
    return [
      isDynamicArray(targetElmType)
        ? () =>
            [`let (ref_name) = readId(storage_loc);`, `${auxFunc.name}(ref_name, ptr[0]);`].join(
              '\n',
            )
        : () => `${auxFunc.name}(storage_loc, ptr[0]);`,
      [auxFunc],
    ];
  }
}

function checkSizes(targetType: TypeNode, sourceType: TypeNode): boolean {
  const targetBaseType = getBaseType(targetType);
  const sourceBaseType = getBaseType(sourceType);
  if (targetBaseType instanceof IntType && sourceBaseType instanceof IntType) {
    return (
      (targetBaseType.nBits > sourceBaseType.nBits && sourceBaseType.signed) ||
      (!targetBaseType.signed && targetBaseType.nBits === 256 && 256 > sourceBaseType.nBits)
    );
  }
  if (targetBaseType instanceof FixedBytesType && sourceBaseType instanceof FixedBytesType) {
    return targetBaseType.size > sourceBaseType.size;
  }
  return false;
}

function checkDims(targetType: TypeNode, sourceType: TypeNode): boolean {
  if (targetType instanceof ArrayType && sourceType instanceof ArrayType) {
    const targetArrayElm = targetType.elementT;
    const sourceArrayElm = sourceType.elementT;

    if (targetType.size !== undefined && sourceType.size !== undefined) {
      if (targetType.size > sourceType.size) {
        return true;
      } else if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
        return checkDims(targetArrayElm, sourceArrayElm);
      } else {
        return false;
      }
    } else if (targetType.size === undefined && sourceType.size !== undefined) {
      return true;
    } else if (targetType.size === undefined && sourceType.size === undefined)
      if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
        return checkDims(targetArrayElm, sourceArrayElm);
      }
  }
  return false;
}

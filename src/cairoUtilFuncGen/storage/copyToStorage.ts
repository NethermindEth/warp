import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  IntType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext, WarpLocation } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  isLeImport,
  uint256AddImport,
  uint256Import,
  uint256LtImport,
  uint256SubImport,
} from '../../utils/importFuncs';
import {
  getElementType,
  getSize,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageDeleteGen } from './storageDelete';

const IMPLICITS =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}';

/*
  Generates functions to copy data from WARP_STORAGE to WARP_STORAGE
  The main point of care here is to copy dynamic arrays. Mappings and types containing them
  cannot be copied from storage to storage, and all types other than dynamic arrays can be
  copied by caring only about their width
*/

export class StorageToStorageGen extends StringIndexedFuncGen {
  public constructor(
    private dynArrayGen: DynArrayGen,
    private storageDeleteGen: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }
  public gen(to: Expression, from: Expression): FunctionCall {
    const toType = generalizeType(safeGetNodeType(to, this.ast.inference))[0];
    const fromType = generalizeType(safeGetNodeType(from, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(toType, fromType);

    return createCallToFunction(funcDef, [to, from], this.ast);
  }

  public getOrCreateFuncDef(toType: TypeNode, fromType: TypeNode) {
    const key = `${fromType.pp()}->${toType.pp()}`;
    const exisiting = this.generatedFunctionsDef.get(key);
    if (exisiting !== undefined) {
      return exisiting;
    }
    const funcInfo = this.getOrCreate(toType, fromType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['toLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage],
        ['fromLoc', typeNameFromTypeNode(fromType, this.ast), DataLocation.Storage],
      ],
      [['retLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(toType: TypeNode, fromType: TypeNode): GeneratedFunctionInfo {
    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      toType,
      (toType) => {
        assert(
          fromType instanceof ArrayType ||
            fromType instanceof BytesType ||
            fromType instanceof StringType,
        );
        if (getSize(fromType) === undefined) {
          return this.createDynamicArrayCopyFunction(toType, fromType);
        } else {
          assert(fromType instanceof ArrayType);
          return this.createStaticToDynamicArrayCopyFunction(toType, fromType);
        }
      },
      (toType) => {
        assert(fromType instanceof ArrayType);
        return this.createStaticArrayCopyFunction(toType, fromType);
      },
      (_toType, def) => this.createStructCopyFunction(def),
      () => {
        throw new TranspileFailedError('Attempted to create mapping clone function');
      },
      (toType) => {
        if (toType instanceof IntType) {
          assert(fromType instanceof IntType);
          return this.createIntegerCopyFunction(toType, fromType);
        } else if (toType instanceof FixedBytesType) {
          assert(fromType instanceof FixedBytesType);
          return this.createFixedBytesCopyFunction(toType, fromType);
        } else {
          return this.createValueTypeCopyFunction(toType);
        }
      },
    );
    return funcInfo;
  }

  private createStructCopyFunction(def: StructDefinition): GeneratedFunctionInfo {
    const members = def.vMembers.map((decl) => safeGetNodeType(decl, this.ast.inference));
    const [copyCode, funcsCalled] = members.reduce(
      ([copyCode, funcsCalled, offset], memberType) => {
        const width = CairoType.fromSol(
          memberType,
          this.ast,
          TypeConversionContext.StorageAllocation,
        ).width;

        if (isReferenceType(memberType)) {
          const memberCopyFunc = this.getOrCreateFuncDef(memberType, memberType);
          const toLoc = add('to_loc', offset);
          const fromLoc = add('from_loc', offset);
          return [
            [...copyCode, `${memberCopyFunc.name}(${toLoc}, ${fromLoc});`],
            [...funcsCalled, memberCopyFunc],
            offset + width,
          ];
        }
        return [
          [...copyCode, mapRange(width, (index) => copyAtOffset(index + offset)).join('\n')],
          funcsCalled,
          offset + width,
        ];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
    );

    const funcName = `WS_COPY_STRUCT_${def.name}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        ...copyCode,
        `    return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createStaticArrayCopyFunction(
    toType: ArrayType,
    fromType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(
      toType.size !== undefined,
      `Attempted to copy to storage dynamic array as static array in ${printTypeNode(
        fromType,
      )}->${printTypeNode(toType)}`,
    );
    assert(
      fromType.size !== undefined,
      `Attempted to copy from storage dynamic array as static array in ${printTypeNode(
        fromType,
      )}->${printTypeNode(toType)}`,
    );

    const elementCopyFunc = this.getOrCreateFuncDef(toType.elementT, fromType.elementT);

    const toElemType = CairoType.fromSol(
      toType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const fromElemType = CairoType.fromSol(
      fromType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const copyCode = createElementCopy(toElemType, fromElemType, elementCopyFunc.name);

    const fromSize = narrowBigIntSafe(fromType.size);
    const toSize = narrowBigIntSafe(toType.size);

    const funcName = `WS_COPY_STATIC_${this.generatedFunctionsDef.size}`;
    let optionalCalls: CairoFunctionDefinition[];
    let stopRecursion: string[];
    if (fromSize === toSize) {
      optionalCalls = [];
      stopRecursion = [`if (index == ${fromSize}){`, `return ();`, `}`];
    } else {
      const deleteFunc = this.storageDeleteGen.getOrCreateFuncDef(toType.elementT);
      optionalCalls = [deleteFunc, this.requireImport(...isLeImport())];
      stopRecursion = [
        `if (index == ${toSize}){`,
        `    return ();`,
        `}`,
        `let lesser = is_le(index, ${fromSize - 1});`,
        `if (lesser == 0){`,
        `    ${deleteFunc.name}(to_elem_loc);`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc, index + 1);`,
        `}`,
      ];
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${IMPLICITS}(to_elem_loc: felt, from_elem_loc: felt, index: felt) -> (){`,
        ...stopRecursion,
        `    ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc + ${fromElemType.width}, index + 1);`,
        `}`,
        `func ${funcName}${IMPLICITS}(to_elem_loc: felt, from_elem_loc: felt) -> (retLoc: felt){`,
        `    ${funcName}_elem(to_elem_loc, from_elem_loc, 0);`,
        `    return (to_elem_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [elementCopyFunc, ...optionalCalls],
    };
  }

  private createDynamicArrayCopyFunction(
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const fromElementT = getElementType(fromType);
    const fromSize = getSize(fromType);
    const toElementT = getElementType(toType);
    const toSize = getSize(toType);
    assert(toSize === undefined, 'Attempted to copy to storage static array as dynamic array');
    assert(fromSize === undefined, 'Attempted to copy from storage static array as dynamic array');

    const elementCopyFunc = this.getOrCreateFuncDef(toElementT, fromElementT);

    const fromElementCairoType = CairoType.fromSol(
      fromElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementCairoType = CairoType.fromSol(
      toElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const [fromElementMapping, fromLengthMapping] =
      this.dynArrayGen.getOrCreateFuncDef(fromElementT);
    const fromElementMappingName = fromElementMapping.name;
    const fromLengthMappingName = fromLengthMapping.name;

    const [toElementMapping, toLengthMapping] = this.dynArrayGen.getOrCreateFuncDef(toElementT);
    const toElementMappingName = toElementMapping.name;
    const toLengthMappingName = toLengthMapping.name;

    const copyCode = createElementCopy(
      toElementCairoType,
      fromElementCairoType,
      elementCopyFunc.name,
    );

    const deleteFunc = this.storageDeleteGen.getOrCreateFuncDef(toType);
    const deleteRemainingCode = `${deleteFunc.name}_elem(to_loc, from_length, to_length)`;

    const funcName = `WS_COPY_DYNAMIC_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${IMPLICITS}(to_loc: felt, from_loc: felt, length: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == 0 and length.high == 0){`,
        `        return ();`,
        `    }`,
        `    let (index) = uint256_sub(length, Uint256(1,0));`,
        `    let (from_elem_loc) = ${fromElementMappingName}.read(from_loc, index);`,
        `    let (to_elem_loc) = ${toElementMappingName}.read(to_loc, index);`,
        `    if (to_elem_loc == 0){`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width});`,
        `        ${toElementMappingName}.write(to_loc, index, to_elem_loc);`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index);`,
        `    }else{`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index);`,
        `    }`,
        `}`,
        `func ${funcName}${IMPLICITS}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        `    let (from_length) = ${fromLengthMappingName}.read(from_loc);`,
        `    let (to_length) = ${toLengthMappingName}.read(to_loc);`,
        `    ${toLengthMappingName}.write(to_loc, from_length);`,
        `    ${funcName}_elem(to_loc, from_loc, from_length);`,
        `    let (lesser) = uint256_lt(from_length, to_length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode};`,
        `       return (to_loc,);`,
        `    }else{`,
        `       return (to_loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...uint256Import()),
        this.requireImport(...uint256SubImport()),
        this.requireImport(...uint256LtImport()),
        elementCopyFunc,
        fromElementMapping,
        fromLengthMapping,
        toElementMapping,
        toLengthMapping,
        deleteFunc,
      ],
    };
  }

  private createStaticToDynamicArrayCopyFunction(
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType,
  ): GeneratedFunctionInfo {
    const toSize = getSize(toType);
    const toElementT = getElementType(toType);
    assert(fromType.size !== undefined);
    assert(toSize === undefined);

    const elementCopyFunc = this.getOrCreateFuncDef(toElementT, fromType.elementT);

    const fromElementCairoType = CairoType.fromSol(
      fromType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementCairoType = CairoType.fromSol(
      toElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const [toElementMapping, toLengthMapping] = this.dynArrayGen.getOrCreateFuncDef(toElementT);
    const toElementMappingName = toElementMapping.name;
    const toLengthMappingName = toLengthMapping.name;
    const copyCode = createElementCopy(
      toElementCairoType,
      fromElementCairoType,
      elementCopyFunc.name,
    );

    const deleteFunc = this.storageDeleteGen.getOrCreateFuncDef(toType);
    const deleteRemainingCode = `${deleteFunc.name}_elem(to_loc, from_length, to_length)`;

    const funcName = `WS_COPY_STATIC_TO_DYNAMIC_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${IMPLICITS}(to_loc: felt, from_elem_loc: felt, length: Uint256, index: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == index.low){`,
        `        if (length.high == index.high){`,
        `            return ();`,
        `        }`,
        `    }`,
        `    let (to_elem_loc) = ${toElementMappingName}.read(to_loc, index);`,
        `    let (next_index, carry) = uint256_add(index, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    if (to_elem_loc == 0){`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width});`,
        `        ${toElementMappingName}.write(to_loc, index, to_elem_loc);`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index);`,
        `    }else{`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index);`,
        `    }`,
        `}`,
        `func ${funcName}${IMPLICITS}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        `    let from_length  = ${uint256(narrowBigIntSafe(fromType.size))};`,
        `    let (to_length) = ${toLengthMappingName}.read(to_loc);`,
        `    ${toLengthMappingName}.write(to_loc, from_length);`,
        `    ${funcName}_elem(to_loc, from_loc, from_length , Uint256(0,0));`,
        `    let (lesser) = uint256_lt(from_length, to_length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode};`,
        `       return (to_loc,);`,
        `    }else{`,
        `       return (to_loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...uint256Import()),
        this.requireImport(...uint256AddImport()),
        this.requireImport(...uint256LtImport()),
        elementCopyFunc,
        toElementMapping,
        toLengthMapping,
        deleteFunc,
      ],
    };
  }

  private createIntegerCopyFunction(toType: IntType, fromType: IntType): GeneratedFunctionInfo {
    assert(
      fromType.nBits <= toType.nBits,
      `Attempted to scale integer ${fromType.nBits} to ${toType.nBits}`,
    );

    // Read changes depending if From is 256 bits or less
    const readFromCode =
      fromType.nBits === 256
        ? [
            'let (from_low) = WARP_STORAGE.read(from_loc);',
            'let (from_high) = WARP_STORAGE.read(from_loc + 1);',
            'tempvar from_elem = Uint256(from_low, from_high);',
          ].join('\n')
        : 'let (from_elem) = WARP_STORAGE.read(from_loc);';

    // Scaling for ints is different than for uints
    // Also memory represenation only change when To is 256 bits
    // and From is lesser than 256 bits
    const scalingCode = toType.signed
      ? `let (to_elem) = warp_int${fromType.nBits}_to_int${toType.nBits}(from_elem);`
      : toType.nBits === 256 && fromType.nBits < 256
      ? 'let (to_elem) = felt_to_uint256(from_elem);'
      : `let to_elem = from_elem;`;

    // Copy changes depending if To is 256 bits or less
    const copyToCode =
      toType.nBits === 256
        ? [
            'WARP_STORAGE.write(to_loc, to_elem.low);',
            'WARP_STORAGE.write(to_loc + 1, to_elem.high);',
          ].join('\n')
        : 'WARP_STORAGE.write(to_loc, to_elem);';

    const funcName = `WS_COPY_INTEGER_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `   alloc_locals;`,
        `   ${readFromCode}`,
        `   ${scalingCode}`,
        `   ${copyToCode}`,
        `   return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...uint256Import()),
        toType.signed
          ? this.requireImport(
              'warplib.maths.int_conversions',
              `warp_int${fromType.nBits}_to_int${toType.nBits}`,
            )
          : this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
      ],
    };
  }

  private createFixedBytesCopyFunction(
    toType: FixedBytesType,
    fromType: FixedBytesType,
  ): GeneratedFunctionInfo {
    const bitWidthDiff = (toType.size - fromType.size) * 8;
    assert(bitWidthDiff >= 0, `Attempted to scale fixed byte ${fromType.size} to ${toType.size}`);

    const conversionFunc = toType.size === 32 ? 'warp_bytes_widen_256' : 'warp_bytes_widen';

    const readFromCode =
      fromType.size === 32
        ? [
            'let (from_low) = WARP_STORAGE.read(from_loc);',
            'let (from_high) = WARP_STORAGE.read(from_loc + 1);',
            'tempvar from_elem = Uint256(from_low, from_high);',
          ].join('\n')
        : 'let (from_elem) = WARP_STORAGE.read(from_loc);';

    const scalingCode =
      bitWidthDiff !== 0
        ? `let (to_elem) = ${conversionFunc}(from_elem, ${bitWidthDiff});`
        : 'let to_elem = from_elem;';

    const copyToCode =
      toType.size === 32
        ? [
            'WARP_STORAGE.write(to_loc, to_elem.low);',
            'WARP_STORAGE.write(to_loc + 1, to_elem.high);',
          ].join('\n')
        : 'WARP_STORAGE.write(to_loc, to_elem);';

    const funcName = `WS_COPY_FIXED_BYTES_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `   alloc_locals;`,
        `   ${readFromCode}`,
        `   ${scalingCode}`,
        `   ${copyToCode}`,
        `   return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport('warplib.maths.bytes_conversions', conversionFunc),
        this.requireImport(...uint256Import()),
      ],
    };
  }

  private createValueTypeCopyFunction(type: TypeNode): GeneratedFunctionInfo {
    const width = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width;

    const funcName = `WS_COPY_VALUE_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `    alloc_locals;`,
        ...mapRange(width, copyAtOffset),
        `    return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
  }
}

function copyAtOffset(n: number): string {
  return [
    `let (copy) = WARP_STORAGE.read(${add('from_loc', n)});`,
    `WARP_STORAGE.write(${add('to_loc', n)}, copy);`,
  ].join('\n');
}

// TODO: There is a bunch of `readId` here!
// Do they need to be imported
function createElementCopy(
  toElementCairoType: CairoType,
  fromElementCairoType: CairoType,
  elementCopyFunc: string,
): (to: string, from: string) => string {
  if (fromElementCairoType instanceof WarpLocation) {
    if (toElementCairoType instanceof WarpLocation) {
      return (to: string, from: string): string =>
        [
          `let (from_elem_id) = readId(${from});`,
          `let (to_elem_id) = readId(${to});`,
          `${elementCopyFunc}(to_elem_id, from_elem_id);`,
        ].join('\n');
    } else {
      return (to: string, from: string): string =>
        [`let (from_elem_id) = readId(${from});`, `${elementCopyFunc}(${to}, from_elem_id);`].join(
          '\n',
        );
    }
  } else {
    if (toElementCairoType instanceof WarpLocation) {
      return (to: string, from: string): string =>
        [`let (to_elem_id) = readId(${to});`, `${elementCopyFunc}(to_elem_id, ${from});`].join(
          '\n',
        );
    } else {
      return (to: string, from: string): string =>
        [`${elementCopyFunc}(${to}, ${from});`].join('\n');
    }
  }
}

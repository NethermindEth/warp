import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  DICT_READ,
  WM_DYN_ARRAY_LENGTH,
  NARROW_SAFE,
  GET_U128,
  UINT256_LT,
  UINT256_SUB,
} from '../../utils/importPaths';
import {
  getElementType,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
  isStruct,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageDeleteGen } from '../storage/storageDelete';
import { MemoryReadGen } from './memoryRead';

/*
  Generates functions to copy data from warp_memory to WARP_STORAGE
  Specifically this has to deal with structs, static arrays, and dynamic arrays
  These require extra care because the representations are different in storage and memory
  In storage nested structures are stored in place, whereas in memory 'pointers' are used
*/
const IMPLICITS =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class MemoryToStorageGen extends StringIndexedFuncGen {
  public constructor(
    private dynArrayGen: DynArrayGen,
    private memoryReadGen: MemoryReadGen,
    private storageDeleteGen: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  public gen(storageLocation: Expression, memoryLocation: Expression): FunctionCall {
    const type = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(type);
    return createCallToFunction(funcDef, [storageLocation, memoryLocation], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = type.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage],
        ['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory],
      ],
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from memory to storage not implemented yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(type),
      (type) => this.createStaticArrayCopyFunction(type),
      (type, def) => this.createStructCopyFunction(type, def),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  // This can also be used for static arrays, in which case they are treated
  // like structs with <length> members of the same type
  private createStructCopyFunction(
    _type: UserDefinedType,
    def: StructDefinition,
  ): GeneratedFunctionInfo {
    const funcName = `wm_to_storage_struct_${def.name}`;

    const [copyInstructions, funcsCalled] = this.generateTupleCopyInstructions(
      def.vMembers.map((decl) => safeGetNodeType(decl, this.ast.inference)),
    );
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(loc : felt, mem_loc: felt) -> (loc: felt){`,
        `    alloc_locals;`,
        ...copyInstructions,
        `    return (loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    return type.size <= 5
      ? this.createSmallStaticArrayCopyFunction(type)
      : this.createLargeStaticArrayCopyFunction(type);
  }

  private createSmallStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const size = narrowBigIntSafe(type.size, 'Static array size is unsupported');

    const [copyInstructions, funcsCalled] = this.generateTupleCopyInstructions(
      new Array(size).fill(type.elementT),
    );

    const funcName = `wm_to_storage_static_array_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(loc : felt, mem_loc: felt) -> (loc: felt){`,
        `    alloc_locals;`,
        ...copyInstructions,
        `    return (loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createLargeStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    const length = narrowBigIntSafe(
      type.size,
      `Failed to narrow size of ${printTypeNode(type)} in memory->storage copy generation`,
    );

    const elementStorageWidth = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(type.elementT, this.ast).width;

    let copyCode: string;
    let calledFuncs: CairoFunctionDefinition[];
    if (isDynamicArray(type.elementT)) {
      const readFunc = this.memoryReadGen.getOrCreateFuncDef(type.elementT);
      const auxFunc = this.getOrCreateFuncDef(type.elementT);
      copyCode = [
        `    let (storage_id) = readId(storage_loc);`,
        `    let (memory_id) = ${readFunc.name}(mem_loc, ${uint256(2)});`,
        `    ${auxFunc.name}(storage_id, memory_id);`,
      ].join('\n');
      calledFuncs = [readFunc, auxFunc];
    } else if (isStruct(type.elementT)) {
      const readFunc = this.memoryReadGen.getOrCreateFuncDef(type.elementT);
      const auxFunc = this.getOrCreateFuncDef(type.elementT);
      copyCode = [
        `    let (memory_id) = ${readFunc.name}{dict_ptr=warp_memory}(mem_loc, ${uint256(
          elementMemoryWidth,
        )});`,
        `    ${auxFunc.name}(storage_loc, memory_id);`,
      ].join('\n');
      calledFuncs = [readFunc, auxFunc];
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)});`,
          `    WARP_STORAGE.write(${add('storage_loc', n)}, copy);`,
        ].join('\n'),
      ).join('\n');
      calledFuncs = [this.requireImport(...DICT_READ)];
    }

    const funcName = `wm_to_storage_static_array_${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${IMPLICITS}(storage_loc: felt, mem_loc : felt, length: felt) -> (){`,
        `    alloc_locals;`,
        `    if (length == 0){`,
        `        return ();`,
        `    }`,
        `    let index = length - 1;`,
        `    ${copyCode}`,
        `    return ${funcName}_elem(${add('storage_loc', elementStorageWidth)}, ${add(
          'mem_loc',
          elementMemoryWidth,
        )}, index);`,
        `}`,

        `func ${funcName}${IMPLICITS}(loc : felt, mem_loc : felt) -> (loc : felt){`,
        `    alloc_locals;`,
        `    ${funcName}_elem(loc, mem_loc, ${length});`,
        `    return (loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: calledFuncs,
    };
  }

  private createDynamicArrayCopyFunction(
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(type);

    const [dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(elementT);

    const elemMappingName = dynArray.name;
    const lengthMappingName = dynArrayLength.name;

    const elementStorageWidth = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(elementT, this.ast).width;

    let copyCode: string;
    let funcCalls: CairoFunctionDefinition[];
    if (isReferenceType(elementT)) {
      const readFunc = this.memoryReadGen.getOrCreateFuncDef(elementT);
      const auxFunc = this.getOrCreateFuncDef(elementT);
      copyCode = isDynamicArray(elementT)
        ? [
            `    let (storage_id) = readId(storage_loc);`,
            `    let (read) = ${readFunc.name}(mem_loc, ${uint256(2)});`,
            `    ${auxFunc.name}(storage_id, read);`,
          ].join('\n')
        : [
            `    let (read) = ${readFunc.name}(mem_loc, ${uint256(elementMemoryWidth)});`,
            `    ${auxFunc.name}(storage_loc, read);`,
          ].join('\n');
      funcCalls = [readFunc, auxFunc];
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)});`,
          `    WARP_STORAGE.write(${add('storage_loc', n)}, copy);`,
        ].join('\n'),
      ).join('\n');
      funcCalls = [this.requireImport(...DICT_READ)];
    }

    const deleteFunc = this.storageDeleteGen.getOrCreateFuncDef(type);
    const auxDeleteFuncName = deleteFunc.name + '_elem';
    const deleteRemainingCode = `${auxDeleteFuncName}(loc, mem_length, length);`;

    const funcName = `wm_to_storage_dynamic_array${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}_elem${IMPLICITS}(storage_name: felt, mem_loc : felt, length: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == 0 and length.high == 0){`,
        `        return ();`,
        `    }`,
        `    let (index) = uint256_sub(length, Uint256(1,0));`,
        `    let (storage_loc) = ${elemMappingName}.read(storage_name, index);`,
        `    let mem_loc = mem_loc - ${elementMemoryWidth};`,
        `    if (storage_loc == 0){`,
        `        let (storage_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(storage_loc + ${elementStorageWidth});`,
        `        ${elemMappingName}.write(storage_name, index, storage_loc);`,
        `        ${copyCode}`,
        `    return ${funcName}_elem(storage_name, mem_loc, index);`,
        `    }else{`,
        `        ${copyCode}`,
        `    return ${funcName}_elem(storage_name, mem_loc, index);`,
        `    }`,
        `}`,

        `func ${funcName}${IMPLICITS}(loc : felt, mem_loc : felt) -> (loc : felt){`,
        `    alloc_locals;`,
        `    let (length) = ${lengthMappingName}.read(loc);`,
        `    let (mem_length) = wm_dyn_array_length(mem_loc);`,
        `    ${lengthMappingName}.write(loc, mem_length);`,
        `    let (narrowedLength) = narrow_safe(mem_length);`,
        `    ${funcName}_elem(loc, mem_loc + 2 + ${elementMemoryWidth} * narrowedLength, mem_length);`,
        `    let (lesser) = uint256_lt(mem_length, length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode}`,
        `       return (loc,);`,
        `    }else{`,
        `       return (loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...NARROW_SAFE),
        this.requireImport(...UINT256_LT),
        this.requireImport(...UINT256_SUB),
        this.requireImport(...WM_DYN_ARRAY_LENGTH),
        ...funcCalls,
        dynArray,
        dynArrayLength,
        deleteFunc,
      ],
    };
    return funcInfo;
  }
  private generateTupleCopyInstructions(types: TypeNode[]): [string[], CairoFunctionDefinition[]] {
    const [code, funcCalls] = types.reduce(
      ([code, funcCalls, storageOffset, memOffset], type, index) => {
        const typeFeltWidth = getFeltWidth(type, this.ast);
        const readFunc = this.memoryReadGen.getOrCreateFuncDef(type);
        const elemLoc = `elem_mem_loc_${index}`;
        if (isReferenceType(type)) {
          const auxFunc = this.getOrCreateFuncDef(type);
          const copyCode = isDynamicArray(type)
            ? [
                `let (${elemLoc}) = ${readFunc.name}(${add('mem_loc', memOffset)}, ${uint256(2)});`,
                `let (storage_dyn_array_loc) = readId(${add('loc', storageOffset)});`,
                `${auxFunc.name}(storage_dyn_array_loc, ${elemLoc});`,
              ]
            : [
                `let (${elemLoc}) = ${readFunc.name}(${add('mem_loc', memOffset)}, ${uint256(
                  CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).width,
                )});`,
                `${auxFunc.name}(${add('loc', storageOffset)}, ${elemLoc});`,
              ];
          return [
            [...code, ...copyCode],
            [...funcCalls, this.requireImport(...GET_U128), readFunc, auxFunc],
            storageOffset + typeFeltWidth,
            memOffset + 1,
          ];
        }
        return [
          [
            ...code,
            ...mapRange(typeFeltWidth, (n) =>
              [
                `let (${elemLoc}_prt_${n}) = dict_read{dict_ptr=warp_memory}(${add(
                  'mem_loc',
                  memOffset + n,
                )});`,
                `WARP_STORAGE.write(${add('loc', storageOffset + n)}, ${elemLoc}_prt_${n});`,
              ].join('\n'),
            ),
          ],
          [...funcCalls, this.requireImport(...DICT_READ)],
          storageOffset + typeFeltWidth,
          memOffset + typeFeltWidth,
        ];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>(), 0, 0],
    );
    return [code, funcCalls];
  }
}

function getFeltWidth(type: TypeNode, ast: AST): number {
  return CairoType.fromSol(type, ast, TypeConversionContext.StorageAllocation).width;
}

import assert from 'assert';
import endent from 'endent';
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
import { DICT_READ, WM_DYN_ARRAY_LENGTH, U128_FROM_FELT } from '../../utils/importPaths';
import {
  getElementType,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
  isStruct,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
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
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(loc: felt252, mem_loc: felt252) -> felt252 {
            ${copyInstructions}
            loc
        }
      `,
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
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(loc: felt252, mem_loc: felt252) -> felt252 {
            ${copyInstructions}
            loc
        }
        `,
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
      copyCode = endent`
          let storage_id = readId(storage_loc);
          let memory_id = ${readFunc.name}(mem_loc, 1);
          ${auxFunc.name}(storage_id, memory_id);
      `;
      calledFuncs = [readFunc, auxFunc];
    } else if (isStruct(type.elementT)) {
      const readFunc = this.memoryReadGen.getOrCreateFuncDef(type.elementT);
      const auxFunc = this.getOrCreateFuncDef(type.elementT);
      copyCode = endent`
        let memory_id = ${readFunc.name}(mem_loc, ${elementMemoryWidth});
        ${auxFunc.name}(storage_loc, memory_id);
      `;
      calledFuncs = [readFunc, auxFunc];
    } else {
      copyCode = mapRange(
        elementStorageWidth,
        (n) =>
          endent`
            let copy = warp_memory.unsafe_read(${add('mem_loc', n)});
            WARP_STORAGE::write(${add('storage_loc', n)}, copy);
        `,
      ).join('\n');
      calledFuncs = [this.requireImport(...DICT_READ)];
    }

    const funcName = `wm_to_storage_static_array_${this.generatedFunctionsDef.size}`;
    const storageOffset = add('storage_loc', elementStorageWidth);
    const memoryOffset = add('mem_loc', elementMemoryWidth);
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}_elem(storage_loc: felt252, mem_loc: felt252, length: felt252) {
          if length == 0 {
              return ();
          }
          let index = length - 1;
          ${copyCode}
          ${funcName}_elem(${storageOffset}, ${memoryOffset}, index);
        }

        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(storage_loc : felt252, mem_loc : felt252) -> felt252 {
            ${funcName}_elem(storage_loc, mem_loc, ${length});
            storage_loc
        }
      `,
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
        ? endent`
            let storage_id = readId(storage_loc);
            let read = ${readFunc.name}(mem_loc, 1);
            ${auxFunc.name}(storage_id, read);
          `
        : endent`
            let read = ${readFunc.name}(mem_loc, ${elementMemoryWidth});
            ${auxFunc.name}(storage_loc, read);
          `;
      funcCalls = [readFunc, auxFunc];
    } else {
      copyCode = mapRange(
        elementStorageWidth,
        (n) =>
          endent`
          let copy = warp_memory.unsafe_read(${add('mem_loc', n)});
          WARP_STORAGE::write(${add('storage_loc', n)}, copy);
        `,
      ).join('\n');
      funcCalls = [this.requireImport(...DICT_READ)];
    }

    const deleteFunc = this.storageDeleteGen.getOrCreateFuncDef(type);
    const auxDeleteFuncName = deleteFunc.name + '_elem';
    const deleteRemainingCode = `${auxDeleteFuncName}(loc, mem_length, length);`;

    const funcName = `wm_to_storage_dynamic_array${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}_elem(storage_id: felt252, mem_loc: felt252, length: felt252) {
            if length == 0 {
                return ();
            }
            let index = length - 1;
            let storage_loc = ${elemMappingName}.read(storage_id, index);
            let mem_loc = mem_loc - ${elementMemoryWidth};
            if (storage_loc == 0){
                let (storage_loc) = WARP_USED_STORAGE.read();
                WARP_USED_STORAGE::write(storage_loc + ${elementStorageWidth});
                ${elemMappingName}::write(storage_id, index, storage_loc);
                ${copyCode}
                ${funcName}_elem(storage_id, mem_loc, index);
            }else{
                ${copyCode}
                ${funcName}_elem(storage_id, mem_loc, index);
            }
        }

        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(storage_id: felt252, mem_loc: felt252) -> felt252 {
            let length = ${lengthMappingName}::read(loc);
            let mem_length = warp_memory.dyn_array_length(mem_loc);
            ${lengthMappingName}.write(storage_id, mem_length);

            ${funcName}_elem(storage_id, mem_loc + 1 + ${elementMemoryWidth} * mem_length, mem_length);

            if (u256_from_felt252(length) < u256_from_felt252(mem_length)){
               ${deleteRemainingCode}
               loc
            }else{
               loc
            }
        }
      `,
      functionsCalled: [
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
            ? endent`
                let ${elemLoc} = ${readFunc.name}(${add('mem_loc', memOffset)}, 1);
                let storage_dyn_array_loc = readId(${add('loc', storageOffset)});
                ${auxFunc.name}(storage_dyn_array_loc, ${elemLoc});`
            : endent`
                let ${elemLoc} = ${readFunc.name}(${add('mem_loc', memOffset)}, ${
                CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).width
              });
                ${auxFunc.name}(${add('loc', storageOffset)}, ${elemLoc});`;
          return [
            [...code, ...copyCode],
            [...funcCalls, this.requireImport(...U128_FROM_FELT), readFunc, auxFunc],
            storageOffset + typeFeltWidth,
            memOffset + 1,
          ];
        }
        return [
          [
            ...code,
            ...mapRange(
              typeFeltWidth,
              (n) =>
                endent`
                let ${elemLoc}_prt_${n} = warp_memory.unsafe_read(${add('mem_loc', memOffset + n)});
                WARP_STORAGE::write(${add('loc', storageOffset + n)}, ${elemLoc}_prt_${n});
              `,
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

import assert from 'assert';
import endent from 'endent';
import {
  ArrayType,
  generalizeType,
  SourceUnit,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, MemoryLocation, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  ALLOC,
  DYNAMIC_ARRAYS_UTIL,
  FELT_ARRAY_TO_WARP_MEMORY_ARRAY,
  FELT_TO_UINT256,
  NARROW_SAFE,
  U128_FROM_FELT,
  WM_DYN_ARRAY_LENGTH,
  WM_INDEX_DYN,
  WM_NEW,
} from '../../utils/importPaths';
import {
  getByteSize,
  getElementType,
  getPackedByteSize,
  isAddressType,
  isDynamicallySized,
  isDynamicArray,
  isStruct,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, GeneratedFunctionInfo, mul } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiBase, removeSizeInfo } from './base';

/**
 * Given any data type produces the same output of solidity abi.encode
 * in the form of an array of felts where each element represents a byte
 */
export class AbiEncode extends AbiBase {
  protected override functionName = 'abi_encode';
  protected memoryRead: MemoryReadGen;

  constructor(memoryRead: MemoryReadGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.memoryRead = memoryRead;
  }

  public getOrCreate(types: TypeNode[]): GeneratedFunctionInfo {
    const [params, encodings, functionsCalled] = types.reduce(
      ([params, encodings, functionsCalled], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });

        const [paramEncoding, paramFunctionsCalled] = this.generateEncodingCode(
          type,
          'bytes_index',
          'bytes_offset',
          '0',
          `param${index}`,
        );

        encodings.push(paramEncoding);

        return [params, encodings, functionsCalled.concat(paramFunctionsCalled)];
      },
      [
        new Array<{ name: string; type: string }>(),
        new Array<string>(),
        new Array<CairoFunctionDefinition>(),
      ],
    );

    const initialOffset = types.reduce(
      (pv, cv) => pv + BigInt(getByteSize(cv, this.ast.inference)),
      0n,
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctionsDef.size}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${funcName}(${cairoParams}) -> (result_ptr : felt){
        alloc_locals;
        let bytes_index : felt = 0;
        let bytes_offset : felt = ${initialOffset};
        let (bytes_array : felt*) = alloc();
        ${encodings.join('\n')}
        let (max_length256) = felt_to_uint256(bytes_offset);
        let (mem_ptr) = wm_new(max_length256, ${uint256(1)});
        felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
        return (mem_ptr,);
      }
      `;

    const importedFuncs = [
      this.requireImport(...ALLOC),
      this.requireImport(...U128_FROM_FELT),
      this.requireImport(...FELT_TO_UINT256),
      this.requireImport(...WM_NEW),
      this.requireImport(...FELT_ARRAY_TO_WARP_MEMORY_ARRAY),
    ];

    const funcInfo = {
      name: funcName,
      code: code,
      functionsCalled: [...importedFuncs, ...functionsCalled],
    };
    return funcInfo;
  }

  /**
   * Given a type generate a function that abi-encodes it
   * @param type type to encode
   * @returns the name of the generated function
   */
  public getOrCreateEncoding(type: TypeNode): CairoFunctionDefinition {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<CairoFunctionDefinition>(
      type,
      (type) =>
        type instanceof ArrayType
          ? this.createDynamicArrayHeadEncoding(type)
          : this.createStringOrBytesHeadEncoding(),
      (type) =>
        isDynamicallySized(type, this.ast.inference)
          ? this.createStaticArrayHeadEncoding(type)
          : this.createArrayInlineEncoding(type),
      (type, def) =>
        isDynamicallySized(type, this.ast.inference)
          ? this.createStructHeadEncoding(type, def)
          : this.createStructInlineEncoding(type, def),
      unexpectedType,
      () => this.createValueTypeHeadEncoding(),
    );
  }

  /**
   * Given a type it generates the function to encodes it, as well as all other
   * instructions required to use it.
   * @param type type to encode
   * @param newIndexVar cairo var where the updated index should be stored
   * @param newOffsetVar cairo var where the updated offset should be stored
   * @param elementOffset used to calculate the relative offset of dynamically sized types
   * @param varToEncode variable that holds the values to encode
   * @returns instructions to encode `varToEncode`
   */
  public generateEncodingCode(
    type: TypeNode,
    newIndexVar: string,
    newOffsetVar: string,
    elementOffset: string,
    varToEncode: string,
  ): [string, CairoFunctionDefinition[]] {
    const func = this.getOrCreateEncoding(type);
    if (isDynamicallySized(type, this.ast.inference) || isStruct(type)) {
      return [
        endent`
          let (${newIndexVar}, ${newOffsetVar}) = ${func.name}(
            bytes_index,
            bytes_offset,
            bytes_array,
            ${elementOffset}
            ${varToEncode}
          );
        `,
        [func],
      ];
    }

    // Static array with known compile time size
    if (type instanceof ArrayType) {
      assert(type.size !== undefined);
      return [
        endent`
          let (${newIndexVar}, ${newOffsetVar}) = ${func.name}(
            bytes_index,
            bytes_offset,
            bytes_array,
            ${elementOffset},
            0,
            ${type.size},
            ${varToEncode},
          );
        `,
        [func],
      ];
    }

    // Is value type
    const size = getPackedByteSize(type, this.ast.inference);
    const instructions: string[] = [];

    const funcsCalled: CairoFunctionDefinition[] = [func];
    // packed size of addresses is 32 bytes, but they are treated as felts,
    // so they should be converted to Uint256 accordingly
    if (size < 32 || isAddressType(type)) {
      funcsCalled.push(this.requireImport(...FELT_TO_UINT256));
      instructions.push(`let (${varToEncode}256) = felt_to_uint256(${varToEncode});`);
      varToEncode = `${varToEncode}256`;
    }
    instructions.push(
      ...[
        `${func.name}(bytes_index, bytes_array, 0, ${varToEncode});`,
        `let ${newIndexVar} = bytes_index + 32;`,
      ],
    );
    if (newOffsetVar !== 'bytes_offset') {
      instructions.push(`let ${newOffsetVar} = bytes_offset;`);
    }

    return [instructions.join('\n'), funcsCalled];
  }

  private createDynamicArrayHeadEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT, this.ast.inference);

    const tailEncoding = this.createDynamicArrayTailEncoding(type);
    const valueEncoding = this.createValueTypeHeadEncoding();

    const name = `${this.functionName}_head_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index: felt,
        bytes_offset: felt,
        bytes_array: felt*,
        element_offset: felt,
        mem_ptr : felt
      ) -> (final_bytes_index : felt, final_bytes_offset : felt){
        alloc_locals;
        // Storing pointer to data
        let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);
        ${valueEncoding.name}(bytes_index, bytes_array, 0, bytes_offset256);
        let new_index = bytes_index + 32;
        // Storing the length
        let (length256) = wm_dyn_array_length(mem_ptr);
        ${valueEncoding.name}(bytes_offset, bytes_array, 0, length256);
        let bytes_offset = bytes_offset + 32;
        // Storing the data
        let (length) = narrow_safe(length256);
        let bytes_offset_offset = bytes_offset + ${mul('length', elementByteSize)};
        let (extended_offset) = ${tailEncoding.name}(
          bytes_offset,
          bytes_offset_offset,
          bytes_array,
          bytes_offset,
          0,
          length,
          mem_ptr
        );
        return (
          final_bytes_index=new_index,
          final_bytes_offset=extended_offset
        );
      }
      `;

    const importedFuncs = [
      this.requireImport(...WM_DYN_ARRAY_LENGTH),
      this.requireImport(...FELT_TO_UINT256),
      this.requireImport(...NARROW_SAFE),
    ];

    const genFuncInfo = {
      name,
      code,
      functionsCalled: [...importedFuncs, valueEncoding, tailEncoding],
    };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createDynamicArrayTailEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'tail ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementT = getElementType(type);
    const elementTSize = CairoType.fromSol(elementT, this.ast).width;

    const [readElement, readFunc] = this.readMemory(elementT, 'elem_loc');
    const [headEncodingCode, functionsCalled] = this.generateEncodingCode(
      elementT,
      'new_bytes_index',
      'new_bytes_offset',
      'element_offset',
      'elem',
    );
    const name = `${this.functionName}_tail_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index : felt,
        bytes_offset : felt,
        bytes_array : felt*,
        element_offset : felt,
        index : felt,
        length : felt,
        mem_ptr : felt
      ) -> (final_offset : felt){
        alloc_locals;
        if (index == length){
           return (final_offset=bytes_offset);
        }
        let (index256) = felt_to_uint256(index);
        let (elem_loc) = wm_index_dyn(mem_ptr, index256, ${uint256(elementTSize)});
        let (elem) = ${readElement};
        ${headEncodingCode}
        return ${name}(new_bytes_index, new_bytes_offset, bytes_array, element_offset, index + 1, length, mem_ptr);
      }
      `;

    const importedFuncs = [
      this.requireImport(...WM_INDEX_DYN),
      this.requireImport(...FELT_TO_UINT256),
    ];

    const genFuncInfo = {
      name,
      code,
      functionsCalled: [...importedFuncs, ...functionsCalled, readFunc],
    };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStaticArrayHeadEncoding(type: ArrayType): CairoFunctionDefinition {
    assert(type.size !== undefined);
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT, this.ast.inference);

    const inlineEncoding = this.createArrayInlineEncoding(type);
    const valueEncoding = this.createValueTypeHeadEncoding();

    const name = `${this.functionName}_head_static_array${this.auxiliarGeneratedFunctions.size}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index : felt,
        bytes_offset : felt,
        bytes_array : felt*,
        element_offset : felt,
        mem_ptr : felt,
      ) -> (final_bytes_index : felt, final_bytes_offset : felt){
        alloc_locals;
        // Storing pointer to data
        let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);
        ${valueEncoding.name}(bytes_index, bytes_array, 0, bytes_offset256);
        let new_bytes_index = bytes_index + 32;
        // Storing the data
        let length = ${type.size};
        let bytes_offset_offset = bytes_offset + ${mul('length', elementByteSize)};
        let (_, extended_offset) = ${inlineEncoding.name}(
          bytes_offset,
          bytes_offset_offset,
          bytes_array,
          bytes_offset,
          0,
          length,
          mem_ptr
        );
        return (
          final_bytes_index=new_bytes_index,
          final_bytes_offset=extended_offset
        );
      `;

    const importedFunc = this.requireImport(...FELT_TO_UINT256);

    const genFuncInfo = {
      name,
      code,
      functionsCalled: [importedFunc, inlineEncoding, valueEncoding],
    };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createArrayInlineEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'inline ' + removeSizeInfo(type);
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast).width;

    const [readElement, readFunc] = this.readMemory(type.elementT, 'elem_loc');

    const [headEncodingCode, functionsCalled] = this.generateEncodingCode(
      type.elementT,
      'new_bytes_index',
      'new_bytes_offset',
      'element_offset',
      'elem',
    );

    const name = `${this.functionName}_inline_array${this.auxiliarGeneratedFunctions.size}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index : felt,
        bytes_offset : felt,
        bytes_array : felt*,
        element_offset : felt,
        mem_index : felt,
        mem_length : felt,
        mem_ptr : felt,
      ) -> (final_bytes_index : felt, final_bytes_offset : felt){
        alloc_locals;
        if (mem_index == mem_length){
           return (final_bytes_index=bytes_index, final_bytes_offset=bytes_offset);
        }
        let elem_loc = mem_ptr + ${mul('mem_index', elementTWidth)};
        let (elem) = ${readElement};
        ${headEncodingCode}
        return ${name}(
           new_bytes_index,
           new_bytes_offset,
           bytes_array,
           element_offset,
           mem_index + 1,
           mem_length,
           mem_ptr
        );
      }
      `;

    const genFuncInfo = { name, code, functionsCalled: [...functionsCalled, readFunc] };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStructHeadEncoding(
    type: UserDefinedType,
    def: StructDefinition,
  ): CairoFunctionDefinition {
    const key = 'struct head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    // Get the size of all it's members
    const typeByteSize = def.vMembers.reduce(
      (sum, varDecl) =>
        sum +
        BigInt(
          getByteSize(
            generalizeType(safeGetNodeType(varDecl, this.ast.inference))[0],
            this.ast.inference,
          ),
        ),
      0n,
    );

    const inlineEncoding = this.createStructInlineEncoding(type, def);
    const valueEncoding = this.createValueTypeHeadEncoding();

    const name = `${this.functionName}_head_${def.name}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index : felt,
        bytes_offset : felt,
        bytes_array : felt*,
        element_offset : felt,
        mem_ptr : felt,
      ) -> (final_bytes_index : felt, final_bytes_offset : felt){
        alloc_locals;
        // Storing pointer to data
        let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);
        ${valueEncoding.name}(bytes_index, bytes_array, 0, bytes_offset256);
        let new_bytes_index = bytes_index + 32;
        // Storing the data
        let bytes_offset_offset = bytes_offset + ${typeByteSize};
        let (_, new_bytes_offset) = ${inlineEncoding.name}(
          bytes_offset,
          bytes_offset_offset,
          bytes_array,
          bytes_offset,
          mem_ptr
      );
        return (new_bytes_index, new_bytes_offset);
      }
      `;

    const genFuncInfo = {
      name,
      code,
      functionsCalled: [this.requireImport(...FELT_TO_UINT256), inlineEncoding, valueEncoding],
    };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStructInlineEncoding(
    type: UserDefinedType,
    def: StructDefinition,
  ): CairoFunctionDefinition {
    const key = 'struct inline ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const decodingInfo: [string, CairoFunctionDefinition[]][] = def.vMembers.map(
      (member, index) => {
        const type = generalizeType(safeGetNodeType(member, this.ast.inference))[0];
        const elemWidth = CairoType.fromSol(type, this.ast).width;
        const [readElement, readFunc] = this.readMemory(type, 'mem_ptr');
        const [encoding, funcsCalled] = this.generateEncodingCode(
          type,
          'bytes_index',
          'bytes_offset',
          'element_offset',
          `elem${index}`,
        );
        return [
          endent`
            // Encoding member ${member.name}
            let (elem${index}) = ${readElement};
            ${encoding}
            let mem_ptr = mem_ptr + ${elemWidth};
          `,
          [...funcsCalled, readFunc],
        ];
      },
    );

    const instructions = decodingInfo.map((info) => info[0]);
    const functionsCalled = decodingInfo.flatMap((info) => info[1]);

    const name = `${this.functionName}_inline_struct_${def.name}`;
    const code = endent`
      #[implicit(warp_memory)]
      func ${name}(
        bytes_index : felt,
        bytes_offset : felt,
        bytes_array : felt*,
        element_offset : felt,
        mem_ptr : felt,
      ) -> (final_bytes_index : felt, final_bytes_offset : felt){
        alloc_locals;
        ${instructions.join('\n')}
        return (bytes_index, bytes_offset);
      }
      `;

    const genFuncInfo = { name, code, functionsCalled };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStringOrBytesHeadEncoding(): CairoFunctionDefinition {
    const funcName = 'bytes_to_felt_dynamic_array';
    return this.requireImport(DYNAMIC_ARRAYS_UTIL, funcName);
  }

  private createValueTypeHeadEncoding(): CairoFunctionDefinition {
    const funcName = 'fixed_bytes256_to_felt_dynamic_array';
    return this.requireImport(DYNAMIC_ARRAYS_UTIL, funcName);
  }

  protected readMemory(type: TypeNode, arg: string): [string, CairoFunctionDefinition] {
    const func = this.memoryRead.getOrCreateFuncDef(type);
    const cairoType = CairoType.fromSol(type, this.ast);
    const args =
      cairoType instanceof MemoryLocation
        ? [arg, isDynamicArray(type) ? uint256(2) : uint256(0)]
        : [arg];
    return [`${func.name}(${args.join(',')})`, func];
  }
}

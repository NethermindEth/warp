import {
  ArrayType,
  BytesType,
  FunctionDefinition,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { GeneratedFunctionInfo } from '../base';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  getElementType,
  getPackedByteSize,
  isAddressType,
  isDynamicArray,
} from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, mul } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiBase } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Given any data type produces the same output of solidty abi.encodePacked
 * in the form of an array of felts where each element represents a byte
 */
export class AbiEncodePacked extends AbiBase {
  protected override functionName = 'abi_encode_packed';
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
        const [paramEncoding, paramFuncCalls] = this.generateEncodingCode(
          type,
          'bytes_index',
          `param${index}`,
        );
        encodings.push(paramEncoding);
        functionsCalled.concat(paramFuncCalls);

        return [params, encodings, functionsCalled];
      },
      [
        new Array<{ name: string; type: string }>(),
        new Array<string>(),
        new Array<FunctionDefinition>(),
      ],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt){`,
      `  alloc_locals;`,
      `  let bytes_index : felt = 0;`,
      `  let (bytes_array : felt*) = alloc();`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_index);`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)});`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);`,
      `  return (mem_ptr,);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.alloc', 'alloc'),
      this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
      this.requireImport('warplib.memory', 'wm_new'),
      this.requireImport('warplib.dynamic_arrays_util', 'felt_array_to_warp_memory_array'),
    ];

    const cairoFuncInfo = {
      name: funcName,
      code: code,
      functionsCalled: [...importedFuncs, ...functionsCalled],
    };

    return cairoFuncInfo;
  }

  public override getOrCreateEncoding(type: TypeNode): CairoFunctionDefinition {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported`);
    };

    return delegateBasedOnType<CairoFunctionDefinition>(
      type,
      (type) => this.createArrayInlineEncoding(type),
      (type) => this.createArrayInlineEncoding(type),
      unexpectedType,
      unexpectedType,
      (type) => this.createValueTypeHeadEncoding(getPackedByteSize(type, this.ast.inference)),
    );
  }

  private generateEncodingCode(
    type: TypeNode,
    newIndexVar: string,
    varToEncode: string,
  ): [string, CairoFunctionDefinition[]] {
    // Cairo address are 251 bits in size but solidity is 160.
    // It was decided to store them fully before just a part
    if (isAddressType(type)) {
      return [
        [
          `let (${varToEncode}256) = felt_to_uint256(${varToEncode});`,
          `fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, ${varToEncode}256);`,
          `let ${newIndexVar} = bytes_index +  32;`,
        ].join('\n'),
        [
          this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
          this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes256_to_felt_dynamic_array'),
        ],
      ];
    }

    const func = this.getOrCreateEncoding(type);

    if (isDynamicArray(type)) {
      return [
        [
          `let (length256) = wm_dyn_array_length(${varToEncode});`,
          `let (length) = narrow_safe(length256);`,
          `let (${newIndexVar}) = ${func.name}(bytes_index, bytes_array, 0, length, ${varToEncode});`,
        ].join('\n'),
        [
          this.requireImport('warplib.memory', 'wm_dyn_array_length'),
          this.requireImport('warplib.maths.utils', 'narrow_safe'),
          func,
        ],
      ];
    }

    // Type is a static array
    if (type instanceof ArrayType) {
      return [
        `let (${newIndexVar}) = ${func.name}(bytes_index, bytes_array, 0, ${type.size}, ${varToEncode});`,
        [func],
      ];
    }

    // Type is value type
    const packedByteSize = getPackedByteSize(type, this.ast.inference);
    const args = ['bytes_index', 'bytes_array', '0', varToEncode];
    if (packedByteSize < 32) args.push(`${packedByteSize}`);

    return [
      [
        `${func.name}(${args.join(',')});`,
        `let ${newIndexVar} = bytes_index +  ${packedByteSize};`,
      ].join('\n'),
      [func],
    ];
  }

  /*
   * Produce inline array encoding for static and dynamic array types
   */
  private createArrayInlineEncoding(
    type: ArrayType | BytesType | StringType,
  ): CairoFunctionDefinition {
    const key = type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const elementT = getElementType(type);
    const cairoElementT = CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref);

    // Obtaining the location differs from static and dynamic arrays
    const elementTSize256 = uint256(cairoElementT.width);
    const getElemLoc = isDynamicArray(type)
      ? [
          `let (mem_index256) = felt_to_uint256(mem_index);`,
          `let (elem_loc : felt) = wm_index_dyn(mem_ptr, mem_index256, ${elementTSize256});`,
        ].join('\n')
      : `let elem_loc : felt = mem_ptr + ${mul('mem_index', cairoElementT.width)};`;

    const readFunc = this.memoryRead.getOrCreateFuncDef(elementT);
    const readCode = `let (elem) = ${readFunc.name}(elem_loc);`;

    const encodingCode = this.generateEncodingCode(elementT, 'new_bytes_index', 'elem');

    const name = `${this.functionName}_inline_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_index : felt,`,
      `  mem_length : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      `  if (mem_index == mem_length){`,
      `     return (final_bytes_index=bytes_index);`,
      `  }`,
      `  ${getElemLoc}`,
      `  ${readCode}`,
      `  ${encodingCode}`,
      `  return ${name}(`,
      `     new_bytes_index,`,
      `     bytes_array,`,
      `     mem_index + 1,`,
      `     mem_length,`,
      `     mem_ptr`,
      `  );`,
      `}`,
    ].join('\n');

    const importedFuncs = isDynamicArray(type)
      ? [
          this.requireImport('warplib.memory', 'wm_index_dyn'),
          this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
        ]
      : [];

    const genFuncInfo = { name, code, functionsCalled: [...importedFuncs] };
    const auxFunc = this.createAuxiliarGeneratedFunction(genFuncInfo, this.ast, this.sourceUnit);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createValueTypeHeadEncoding(size: number | bigint): CairoFunctionDefinition {
    const funcName =
      size === 32 ? 'fixed_bytes256_to_felt_dynamic_array' : `fixed_bytes_to_felt_dynamic_array`;

    return this.requireImport('warplib.dynamic_arrays_util', funcName);
  }
}

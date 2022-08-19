import {
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { getByteSize, isValueType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { AbiEncodeWithSelector } from './abiEncodeWithSelector';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, keccak_ptr : felt*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiEncodeWithSignature extends AbiEncodeWithSelector {
  protected override functionName = 'abi_encode_with_signature';

  public gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    const exprTypes = expressions.map(
      (expr) => generalizeType(getNodeType(expr, this.ast.compilerVersion))[0],
    );
    const functionName = this.getOrCreate(exprTypes);

    const functionStub = createCairoFunctionStub(
      functionName,
      exprTypes.map((exprT, index) =>
        isValueType(exprT)
          ? [`param${index}`, typeNameFromTypeNode(exprT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(exprT, this.ast), DataLocation.Memory],
      ),
      [['result', createBytesTypeName(this.ast), DataLocation.Memory]],
      ['bitwise_ptr', 'keccak_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, expressions, this.ast);
  }

  public override getOrCreate(types: TypeNode[]): string {
    const signature = types[0];
    if (!(signature instanceof StringType)) {
      throw new TranspileFailedError(
        `While encoding with selector expected first argument to be string but found ${printTypeNode(
          signature,
        )} instead`,
      );
    }
    types = types.slice(1);

    const key = types.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [params, encodings] = types.reduce(
      ([params, encodings], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        encodings.push(
          this.abiEncode.generateEncodingCode(
            type,
            'bytes_index',
            'bytes_offset',
            '4',
            `param${index}`,
          ),
        );
        return [params, encodings];
      },
      [
        [{ name: 'signature', type: 'felt' }],
        [
          [
            'let (signature_hash) = warp_keccak(signature)',
            'let (byte0) = byte256_at_index(signature_hash, 0)',
            'let (byte1) = byte256_at_index(signature_hash, 1)',
            'let (byte2) = byte256_at_index(signature_hash, 2)',
            'let (byte3) = byte256_at_index(signature_hash, 3)',
            'assert bytes_array[bytes_index] = byte0',
            'assert bytes_array[bytes_index + 1] = byte1',
            'assert bytes_array[bytes_index + 2] = byte2',
            'assert bytes_array[bytes_index + 3] = byte3',
            'let bytes_index = bytes_index + 4',
          ].join('\n'),
        ],
      ],
    );

    const initialOffset = types.reduce(
      (pv, cv) => pv + BigInt(getByteSize(cv, this.ast.compilerVersion, true)),
      4n,
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt):`,
      `  alloc_locals`,
      `  let bytes_index : felt = 0`,
      `  let bytes_offset : felt = ${initialOffset}`,
      `  let (bytes_array : felt*) = alloc()`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_offset)`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)})`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset)`,
      `  return (mem_ptr)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.dynamic_arrays_util', 'felt_array_to_warp_memory_array');
    this.requireImport('warplib.maths.bytes_access', 'byte256_at_index');
    this.requireImport('warplib.keccak', 'warp_keccak');

    const cairoFunc = { name: funcName, code: code };
    this.generatedFunctions.set(key, cairoFunc);

    return cairoFunc.name;
  }
}

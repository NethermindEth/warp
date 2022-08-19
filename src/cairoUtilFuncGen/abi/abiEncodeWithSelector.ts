import { FixedBytesType, SourceUnit, TypeNode } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { getByteSize } from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { AbiEncode } from './abiEncode';
import { AbiBase } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiEncodeWithSelector extends AbiBase {
  protected override functionName = 'abi_encode_with_selector';
  protected abiEncode: AbiEncode;

  constructor(abiEncode: AbiEncode, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.abiEncode = abiEncode;
  }

  public override getOrCreate(types: TypeNode[]): string {
    const selector = types[0];
    if (!(selector instanceof FixedBytesType && selector.size === 4)) {
      throw new TranspileFailedError(
        `While encoding with selector expected first argument to be bytes4 but found ${printTypeNode(
          selector,
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
        [{ name: 'selector', type: 'felt' }],
        [
          [
            'fixed_bytes_to_felt_dynamic_array(bytes_index, bytes_array, 0, selector, 4)',
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
    this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes_to_felt_dynamic_array');
    this.requireImport('warplib.keccak', 'warp_keccak');

    const cairoFunc = { name: funcName, code: code };
    this.generatedFunctions.set(key, cairoFunc);

    return cairoFunc.name;
  }
}

import endent from 'endent';
import { FixedBytesType, SourceUnit, TypeNode } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  ALLOC,
  FELT_ARRAY_TO_WARP_MEMORY_ARRAY,
  FELT_TO_UINT256,
  FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY,
  U128_FROM_FELT,
  WARP_KECCAK,
  WM_NEW,
} from '../../utils/importPaths';
import { getByteSize } from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { GeneratedFunctionInfo } from '../base';
import { AbiEncode } from './abiEncode';
import { AbiBase } from './base';

export class AbiEncodeWithSelector extends AbiBase {
  protected override functionName = 'abi_encode_with_selector';
  protected abiEncode: AbiEncode;

  constructor(abiEncode: AbiEncode, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.abiEncode = abiEncode;
  }

  public override getOrCreate(types: TypeNode[]): GeneratedFunctionInfo {
    const selector = types[0];
    if (!(selector instanceof FixedBytesType && selector.size === 4)) {
      throw new TranspileFailedError(
        `While encoding with selector expected first argument to be bytes4 but found ${printTypeNode(
          selector,
        )} instead`,
      );
    }
    types = types.slice(1);

    const [params, encodings, functionsCalled] = types.reduce(
      ([params, encodings, functionsCalled], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        const [paramEncodings, paramFuncCalls] = this.abiEncode.generateEncodingCode(
          type,
          'bytes_index',
          'bytes_offset',
          '4',
          `param${index}`,
        );

        encodings.push(paramEncodings);
        return [params, encodings, functionsCalled.concat(paramFuncCalls)];
      },
      [
        [{ name: 'selector', type: 'felt' }],
        [
          endent`
            fixed_bytes_to_felt_dynamic_array(bytes_index, bytes_array, 0, selector, 4);
            let bytes_index = bytes_index + 4;
          `,
        ],
        new Array<CairoFunctionDefinition>(),
      ],
    );

    const initialOffset = types.reduce(
      (pv, cv) => pv + BigInt(getByteSize(cv, this.ast.inference)),
      4n,
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
      this.requireImport(...U128_FROM_FELT),
      this.requireImport(...ALLOC),
      this.requireImport(...FELT_TO_UINT256),
      this.requireImport(...WM_NEW),
      this.requireImport(...FELT_ARRAY_TO_WARP_MEMORY_ARRAY),
      this.requireImport(...FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY),
      this.requireImport(...WARP_KECCAK),
    ];

    const funcInfo = {
      name: funcName,
      code: code,
      functionsCalled: [...importedFuncs, ...functionsCalled],
    };
    return funcInfo;
  }
}

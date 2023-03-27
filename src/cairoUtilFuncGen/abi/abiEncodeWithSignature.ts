import {
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { getByteSize, isValueType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { GeneratedFunctionInfo } from '../base';
import { AbiEncodeWithSelector } from './abiEncodeWithSelector';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, keccak_ptr : felt*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiEncodeWithSignature extends AbiEncodeWithSelector {
  protected override functionName = 'abi_encode_with_signature';

  public gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    const exprTypes = expressions.map(
      (expr) => generalizeType(safeGetNodeType(expr, this.ast.inference))[0],
    );
    const funcInfo = this.getOrCreate(exprTypes);

    const functionStub = createCairoGeneratedFunction(
      funcInfo,
      exprTypes.map((exprT, index) =>
        isValueType(exprT)
          ? [`param${index}`, typeNameFromTypeNode(exprT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(exprT, this.ast), DataLocation.Memory],
      ),
      [['result', createBytesTypeName(this.ast), DataLocation.Memory]],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, expressions, this.ast);
  }

  public override getOrCreate(types: TypeNode[]): GeneratedFunctionInfo {
    const signature = types[0];
    if (!(signature instanceof StringType)) {
      throw new TranspileFailedError(
        `While encoding with selector expected first argument to be string but found ${printTypeNode(
          signature,
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
        [{ name: 'signature', type: 'felt' }],
        [
          [
            'let (signature_hash) = warp_keccak(signature);',
            'let (byte0) = byte256_at_index(signature_hash, 0);',
            'let (byte1) = byte256_at_index(signature_hash, 1);',
            'let (byte2) = byte256_at_index(signature_hash, 2);',
            'let (byte3) = byte256_at_index(signature_hash, 3);',
            'assert bytes_array[bytes_index] = byte0;',
            'assert bytes_array[bytes_index + 1] = byte1;',
            'assert bytes_array[bytes_index + 2] = byte2;',
            'assert bytes_array[bytes_index + 3] = byte3;',
            'let bytes_index = bytes_index + 4;',
          ].join('\n'),
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
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt){`,
      `  alloc_locals;`,
      `  let bytes_index : felt = 0;`,
      `  let bytes_offset : felt = ${initialOffset};`,
      `  let (bytes_array : felt*) = alloc();`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_offset);`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)});`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);`,
      `  return (mem_ptr,);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.alloc', 'alloc'),
      this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
      this.requireImport('warplib.memory', 'wm_new'),
      this.requireImport('warplib.dynamic_arrays_util', 'felt_array_to_warp_memory_array'),
      this.requireImport('warplib.maths.bytes_access', 'byte256_at_index'),
      this.requireImport('warplib.keccak', 'warp_keccak'),
    ];

    const cairoFunc = {
      name: funcName,
      code: code,
      functionsCalled: [...importedFuncs, ...functionsCalled],
    };

    return cairoFunc;
  }
}

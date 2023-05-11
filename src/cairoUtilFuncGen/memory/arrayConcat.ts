import assert from 'assert';
import endent from 'endent';
import {
  BytesType,
  DataLocation,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  IntType,
  isReferenceType,
  StringType,
  TypeName,
  TypeNode,
} from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { createBytesTypeName, createStringTypeName } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  ParameterInfo,
} from '../../utils/functionGeneration';
import {
  DYNAMIC_ARRAYS_UTIL,
  FELT_TO_UINT256,
  U256_TO_FELT252,
  U128_FROM_FELT,
  WM_DYN_ARRAY_LENGTH,
  WM_NEW,
} from '../../utils/importPaths';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { getIntOrFixedByteBitWidth } from '../../warplib/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class MemoryArrayConcat extends StringIndexedFuncGen {
  public gen(concat: FunctionCall) {
    const argTypes = concat.vArguments.map(
      (expr) => generalizeType(safeGetNodeType(expr, this.ast.inference))[0],
    );

    const funcDef = this.getOrCreateFuncDef(argTypes);
    return createCallToFunction(funcDef, concat.vArguments, this.ast);
  }

  public getOrCreateFuncDef(argTypes: TypeNode[]) {
    // TODO: Check for hex"" and unicode"" which are treated as bytes instead of strings?!
    const validArgs = argTypes.every(
      (type) => type instanceof BytesType || type instanceof FixedBytesType || StringType,
    );
    assert(
      validArgs,
      `Concat arguments must be all of string, bytes or fixed bytes type. Instead of: ${argTypes.map(
        (t) => printTypeNode(t),
      )}`,
    );

    const key = argTypes
      // TODO: Wouldn't type.pp() work here?
      .map((type) => {
        isReferenceType(type) ? 'A' : `B${getIntOrFixedByteBitWidth(type)}`;
      })
      .join('');
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const inputs: ParameterInfo[] = argTypes.map((arg, index) => [
      `arg_${index}`,
      typeNameFromTypeNode(arg, this.ast),
      DataLocation.Memory,
    ]);

    const outputTypeName: TypeName = argTypes.some((t) => t instanceof StringType)
      ? createStringTypeName(this.ast)
      : createBytesTypeName(this.ast);
    const output: ParameterInfo = ['res_loc', outputTypeName, DataLocation.Memory];

    const funcInfo = this.getOrCreate(argTypes);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      inputs,
      [output],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(argTypes: TypeNode[]): GeneratedFunctionInfo {
    const funcInfo = this.generateBytesConcat(argTypes);
    return funcInfo;
  }

  private generateBytesConcat(argTypes: TypeNode[]): GeneratedFunctionInfo {
    const argAmount = argTypes.length;
    const funcName = `concat${this.generatedFunctionsDef.size}_${argAmount}`;

    if (argAmount === 0) {
      return {
        name: funcName,
        code: endent`
          #[implicit(warp_memory: WarpMemory)]
          fn ${funcName}() -> felt{
              warp_memory.new_dynamic_array(0, 1)
          }
        `,
        functionsCalled: [this.requireImport(...U128_FROM_FELT), this.requireImport(...WM_NEW)],
      };
    }

    const cairoArgs = argTypes.map((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast).toString();
      return `arg_${index} : ${cairoType}`;
    });

    const [argSizes, argSizesImports] = argTypes
      .map((t, n) => this.getSize(t, n))
      .reduce(([argSizes, argSizesImports], [sizeCode, sizeImport]) => {
        return [`${argSizes}\n${sizeCode}`, [...argSizesImports, ...sizeImport]];
      });

    const [concatCode, concatImports] = argTypes.reduce(
      ([concatCode, concatImports], argType, index) => {
        const [copyCode, copyImport] = this.getCopyFunctionCall(argType, index);
        const fullCopyCode = [
          `let end_loc = start_loc + size_${index};`,
          copyCode,
          `let start_loc = end_loc;`,
        ];
        return [
          [
            ...concatCode,
            index < argTypes.length - 1
              ? fullCopyCode.join('\n')
              : fullCopyCode.slice(0, -1).join('\n'),
          ],
          [...concatImports, copyImport],
        ];
      },
      [new Array<string>(), new Array<CairoImportFunctionDefinition>()],
    );

    const code = endent`
      #[implicit(warp_memory: WarpMemory)]
      fn ${funcName}(${cairoArgs}) -> (res_loc : felt){
          // Get all sizes
          ${argSizes}
          let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')};
          let res_loc = warp_memory.new_dynamic_array(total_length, 1);
          // Copy values
          let start_loc = 0;
          ${concatCode.join('\n')}
          res_loc
      }
      `;

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...FELT_TO_UINT256),
        this.requireImport(...WM_NEW),
        ...argSizesImports,
        ...concatImports,
      ],
    };
  }

  private getSize(type: TypeNode, index: number): [string, CairoImportFunctionDefinition[]] {
    if (type instanceof StringType || type instanceof BytesType) {
      return [
        endent`
          let size_${index} = warp_memory.read(arg_${index});
        `,
        [this.requireImport(...WM_DYN_ARRAY_LENGTH), this.requireImport(...U256_TO_FELT252)],
      ];
    }

    if (type instanceof IntType) {
      return [`let size_${index} = ${type.nBits / 8};`, []];
    }

    if (type instanceof FixedBytesType) {
      return [`let size_${index} = ${type.size};`, []];
    }

    throw new TranspileFailedError(
      `Attempted to get size for unexpected type ${printTypeNode(type)} during concat`,
    );
  }

  // TODO: Implmenet utils
  private getCopyFunctionCall(
    type: TypeNode,
    index: number,
  ): [string, CairoImportFunctionDefinition] {
    if (type instanceof StringType || type instanceof BytesType) {
      return [
        `dynamic_array_copy_felt(res_loc, start_loc, end_loc, arg_${index}, 0);`,
        this.requireImport(DYNAMIC_ARRAYS_UTIL, 'dynamic_array_copy_felt'),
      ];
    }

    assert(type instanceof FixedBytesType);
    if (type.size < 32) {
      return [
        `fixed_bytes_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0, size_${index});`,
        this.requireImport(DYNAMIC_ARRAYS_UTIL, 'fixed_bytes_to_dynamic_array'),
      ];
    }

    return [
      `fixed_bytes256_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0);`,
      this.requireImport(DYNAMIC_ARRAYS_UTIL, 'fixed_bytes256_to_dynamic_array'),
    ];
  }
}

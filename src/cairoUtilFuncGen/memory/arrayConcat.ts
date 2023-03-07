import assert from 'assert';
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
  NARROW_SAFE,
  UINT256,
  WM_DYN_ARRAY_LENGTH,
  WM_NEW,
} from '../../utils/importPaths';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { getIntOrFixedByteBitWidth, uint256 } from '../../warplib/utils';
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
        if (isReferenceType(type)) return 'A';
        return `B${getIntOrFixedByteBitWidth(type)}`;
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
    const implicits = argTypes.some(
      (type) => type instanceof IntType || type instanceof FixedBytesType,
    )
      ? '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}'
      : '{range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcInfo = this.generateBytesConcat(argTypes, implicits);
    return funcInfo;
  }

  private generateBytesConcat(argTypes: TypeNode[], implicits: string): GeneratedFunctionInfo {
    const argAmount = argTypes.length;
    const funcName = `concat${this.generatedFunctionsDef.size}_${argAmount}`;

    if (argAmount === 0) {
      return {
        name: funcName,
        code: [
          `func ${funcName}${implicits}() -> (res_loc : felt){`,
          `   alloc_locals;`,
          `   let (res_loc) = wm_new(${uint256(0)}, ${uint256(1)});`,
          `   return (res_loc,);`,
          `}`,
        ].join('\n'),
        functionsCalled: [this.requireImport(...UINT256), this.requireImport(...WM_NEW)],
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

    const code = [
      `func ${funcName}${implicits}(${cairoArgs}) -> (res_loc : felt){`,
      `    alloc_locals;`,
      `    // Get all sizes`,
      argSizes,
      `    let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')};`,
      `    let (total_length256) = felt_to_uint256(total_length);`,
      `    let (res_loc) = wm_new(total_length256, ${uint256(1)});`,
      `    // Copy values`,
      `    let start_loc = 0;`,
      ...concatCode,
      `    return (res_loc,);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport(...UINT256),
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
        [
          `let (size256_${index}) = wm_dyn_array_length(arg_${index});`,
          `let (size_${index}) = narrow_safe(size256_${index});`,
        ].join('\n'),
        [this.requireImport(...WM_DYN_ARRAY_LENGTH), this.requireImport(...NARROW_SAFE)],
      ];
    }

    if (type instanceof IntType) {
      return [`let size_${index} = ${type.nBits / 8};`, []];
    }

    if (type instanceof FixedBytesType) {
      return [`let size_${index} = ${type.size};`, []];
    }

    throw new TranspileFailedError(
      `Attempted to get size for unexpected type ${printTypeNode(type)} in concat`,
    );
  }

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

import assert from 'assert';
import {
  DataLocation,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  IntType,
  PointerType,
  TypeName,
  TypeNode,
} from 'solc-typed-ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { Implicits } from '../../utils/implicits';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { getIntOrFixedByteBitWidth, uint256 } from '../../warplib/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class MemoryArrayConcat extends StringIndexedFuncGen {
  gen(concat: FunctionCall) {
    const args = concat.vArguments;
    args.forEach((expr) => {
      const exprType = safeGetNodeType(expr, this.ast.inference);
      if (
        !isDynamicArray(exprType) &&
        !(exprType instanceof IntType || exprType instanceof FixedBytesType)
      )
        throw new TranspileFailedError(
          `Unexpected type ${printTypeNode(exprType)} in ${printNode(expr)} to concatenate.` +
            'Expected FixedBytes, IntType, ArrayType, BytesType, or StringType',
        );
    });

    const inputs: [string, TypeName, DataLocation][] = mapRange(args.length, (n) => [
      `arg_${n}`,
      typeNameFromTypeNode(safeGetNodeType(args[n], this.ast.inference), this.ast),
      DataLocation.Memory,
    ]);
    const output: [string, TypeName, DataLocation] = [
      'res_loc',
      typeNameFromTypeNode(safeGetNodeType(concat, this.ast.inference), this.ast),
      DataLocation.Memory,
    ];

    const argTypes = args.map((e) => safeGetNodeType(e, this.ast.inference));

    const funcDef = this.getOrCreateFuncDef(argTypes, inputs, output);
    return createCallToFunction(funcDef, args, this.ast);
  }

  getOrCreateFuncDef(
    argTypes: TypeNode[],
    inputs: [string, TypeName, DataLocation][],
    output: [string, TypeName, DataLocation],
  ) {
    // TODO Remove arguments that are not TypeNodes

    const key = `storageToCallData(${argTypes.map((t) => `${t.pp()}`).flat()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(argTypes);
    // const implicits: Implicits[] = argTypes.some(
    //   (type) => type instanceof IntType || type instanceof FixedBytesType,
    // )
    //   ? ['bitwise_ptr', 'range_check_ptr', 'warp_memory']
    //   : ['range_check_ptr', 'warp_memory'];
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      inputs,
      [output],
      // implicits,
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(argTypes: TypeNode[]): GeneratedFunctionInfo {
    const key = argTypes
      .map((type) => {
        if (type instanceof PointerType) return 'A';
        return `B${getIntOrFixedByteBitWidth(type)}`;
      })
      .join('');

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const implicits = argTypes.some(
      (type) => type instanceof IntType || type instanceof FixedBytesType,
    )
      ? '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}'
      : '{range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcInfo = this.generateBytesConcat(argTypes, implicits);
    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }

  private generateBytesConcat(argTypes: TypeNode[], implicits: string): GeneratedFunctionInfo {
    const argAmount = argTypes.length;
    const funcName = `concat${this.generatedFunctions.size}_${argAmount}`;
    const funcsCalled: FunctionDefinition[] = [];

    if (argAmount === 0) {
      funcsCalled.push(
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        this.requireImport('warplib.memory', 'wm_new'),
      );
      return {
        name: funcName,
        code: [
          `func ${funcName}${implicits}() -> (res_loc : felt){`,
          `   alloc_locals;`,
          `   let (res_loc) = wm_new(${uint256(0)}, ${uint256(1)});`,
          `   return (res_loc,);`,
          `}`,
        ].join('\n'),
        functionsCalled: funcsCalled,
      };
    }

    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
      this.requireImport('warplib.memory', 'wm_new'),
    );

    const cairoArgs = argTypes.map((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast).toString();
      return `arg_${index} : ${cairoType}`;
    });
    const code = [
      `func ${funcName}${implicits}(${cairoArgs}) -> (res_loc : felt){`,
      `    alloc_locals;`,
      `    // Get all sizes`,
      ...argTypes.map((t, n) => this.getSize(t, n, funcsCalled)),
      `    let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')};`,
      `    let (total_length256) = felt_to_uint256(total_length);`,
      `    let (res_loc) = wm_new(total_length256, ${uint256(1)});`,
      `    // Copy values`,
      `    let start_loc = 0;`,
      ...mapRange(argAmount, (n) => {
        const copy = [
          `let end_loc = start_loc + size_${n};`,
          this.getCopyFunctionCall(argTypes[n], n, funcsCalled),
          `let start_loc = end_loc;`,
        ];
        return n < argAmount - 1 ? copy.join('\n') : copy.slice(0, -1).join('\n');
      }),
      `    return (res_loc,);`,
      `}`,
    ].join('\n');

    return { name: funcName, code: code, functionsCalled: funcsCalled };
  }

  private getSize(type: TypeNode, index: number, funcsCalled: FunctionDefinition[]): string {
    if (type instanceof PointerType) {
      funcsCalled.push(
        this.requireImport('warplib.memory', 'wm_dyn_array_length'),
        this.requireImport('warplib.maths.utils', 'narrow_safe'),
      );
      return [
        `let (size256_${index}) = wm_dyn_array_length(arg_${index});`,
        `let (size_${index}) = narrow_safe(size256_${index});`,
      ].join('\n');
    }

    if (type instanceof IntType) {
      return `let size_${index} = ${type.nBits / 8};`;
    }

    if (type instanceof FixedBytesType) {
      return `let size_${index} = ${type.size};`;
    }

    throw new TranspileFailedError(
      `Attempted to get size for unexpected type ${printTypeNode(type)} in concat`,
    );
  }

  private getCopyFunctionCall(
    type: TypeNode,
    index: number,
    funcsCalled: FunctionDefinition[],
  ): string {
    if (type instanceof PointerType) {
      funcsCalled.push(
        this.requireImport('warplib.dynamic_arrays_util', 'dynamic_array_copy_felt'),
      );
      return `dynamic_array_copy_felt(res_loc, start_loc, end_loc, arg_${index}, 0);`;
    }

    assert(type instanceof FixedBytesType);
    if (type.size < 32) {
      funcsCalled.push(
        this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes_to_dynamic_array'),
      );
      return `fixed_bytes_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0, size_${index});`;
    }

    funcsCalled.push(
      this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes256_to_dynamic_array'),
    );
    return `fixed_bytes256_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0);`;
  }
}

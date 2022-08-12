import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getByteSize,
  getElementType,
  getPackedByteSize,
  isDynamicArray,
  isReferenceType,
  isValueType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiEncode extends StringIndexedFuncGen {
  protected functionName = 'abi_encode';
  protected auxiliarGeneratedFunctions = new Map<string, CairoFunction>();
  protected memoryRead: MemoryReadGen;

  constructor(memoryRead: MemoryReadGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.memoryRead = memoryRead;
  }

  getGeneratedCode(): string {
    return [...this.auxiliarGeneratedFunctions.values(), ...this.generatedFunctions.values()]
      .map((func) => func.code)
      .join('\n\n');
  }

  gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
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
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, expressions, this.ast);
  }

  protected getOrCreate(types: TypeNode[]): string {
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
          this.generateEncodingCode(type, 'bytes_index', 'bytes_offset', `param${index}`),
        );
        return [params, encodings];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const initialOffset = types.reduce(
      (pv, cv) => pv + BigInt(getByteSize(cv, this.ast.compilerVersion)),
      0n,
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
      `  # Transform the felt array into a memory one`,
      `  return (0)`,
      `end`,
    ].join('\n');

    const cairoFunc = { name: funcName, code: code };
    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  protected getOrCreateEncoding(type: TypeNode): string {
    const unexpectedType = () => {
      throw new NotSupportedYetError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<string>(
      type,
      (type) => this.createDynamicArrayHeadEncoding(type),
      unexpectedType,
      unexpectedType,
      unexpectedType,
      () => this.createValueTypeHeadEncoding(),
    );
  }

  private generateEncodingCode(
    type: TypeNode,
    newIndexVar: string,
    newOffsetVar: string,
    varToEncode: string,
  ): string {
    const funcName = this.getOrCreateEncoding(type);
    if (isReferenceType(type)) {
      return [
        `let (${newIndexVar}, ${newOffsetVar}) = ${funcName}(`,
        `  bytes_index,`,
        `  bytes_offset,`,
        `  bytes_array,`,
        `  ${varToEncode}`,
        `)`,
      ].join('\n');
    }

    // Is value type
    const size = getPackedByteSize(type);
    const instructions: string[] = [];
    if (size < 32) {
      this.requireImport(`warplib.maths.utils`, 'felt_to_uint256');
      instructions.push(`let (${varToEncode}256) = felt_to_uint256(${varToEncode})`);
      varToEncode = `${varToEncode}256`;
    }
    instructions.push(
      ...[
        `${funcName}(bytes_index, bytes_array, 0, ${varToEncode})`,
        `let ${newIndexVar} = bytes_index + 32`,
      ],
    );
    if (newOffsetVar !== 'bytes_offset') {
      instructions.push(`let ${newOffsetVar} = bytes_offset`);
    }
    return instructions.join('\n');
  }

  private createDynamicArrayHeadEncoding(type: ArrayType | StringType | BytesType): string {
    const key = 'head' + type.pp();
    const exisiting = this.auxiliarGeneratedFunctions.get(key);
    if (exisiting !== undefined) return exisiting.name;

    const typeByteSize = getByteSize(type, this.ast.compilerVersion);
    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT, this.ast.compilerVersion);

    const tailEncoding = this.createDynamicArrayTailEncoding(type);
    const name = `${this.functionName}_head_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt):`,
      `  alloc_locals`,
      `  # Storing pointer to data`,
      `  let (bytes_offset256) = felt_to_uint256(bytes_offset)`,
      `  ${this.createValueTypeHeadEncoding()}(bytes_index, bytes_array, 0, bytes_offset256)`,
      `  let new_index = bytes_index + ${typeByteSize}`,
      `  # Storing the data`,
      `  let (length256) = wm_dyn_array_length(mem_ptr)`,
      `  let (length) = narrow_safe(length256)`,
      `  let bytes_offset_offset = bytes_offset + ${mul('length', elementByteSize)}`,
      `  let (extended_offset) = ${tailEncoding}(`,
      `    bytes_offset,`,
      `    bytes_offset_offset,`,
      `    bytes_array,`,
      `    0,`,
      `    length,`,
      `    mem_ptr`,
      `  )`,
      `  return (`,
      `    final_bytes_index=new_index,`,
      `    final_bytes_offset=extended_offset`,
      `  )`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.memory', 'wm_dyn_array_length');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('warplib.maths.utils', 'narrow_safe');

    this.auxiliarGeneratedFunctions.set(type.pp(), { name, code });
    return name;
  }

  private createDynamicArrayTailEncoding(type: ArrayType | StringType | BytesType): string {
    const key = 'tail' + type.pp();
    const exisiting = this.auxiliarGeneratedFunctions.get(key);
    if (exisiting !== undefined) return exisiting.name;

    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT);
    const elementTCairoSize = CairoType.fromSol(elementT, this.ast).width;

    const cairoElementT = CairoType.fromSol(elementT, this.ast);
    const readElementFunc = this.memoryRead.getOrCreate(cairoElementT);
    const readElement = isDynamicArray(elementT)
      ? `${readElementFunc}(elem_loc, ${uint256(0)})`
      : `${readElementFunc}(elem_loc)`;
    const headEncodingCode = this.generateEncodingCode(
      elementT,
      'new_bytes_index',
      'new_bytes_offset',
      'elem_loc',
    );
    const name = `${this.functionName}_tail_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  index : felt,`,
      `  length : felt,`,
      `  mem_ptr : felt`,
      `) -> (final_offset : felt):`,
      `  alloc_locals`,
      `  if index == length:`,
      `     return (final_offset=bytes_offset)`,
      `  end`,
      `  let (index256) = felt_to_uint256(index)`,
      `  let (elem_loc) = wm_index_dyn(mem_ptr, index256, ${uint256(elementTCairoSize)})`,
      `  let (elem) = ${readElement}`,
      `  ${headEncodingCode}`,
      `  return ${name}(new_bytes_index, new_bytes_offset, bytes_array, index + 1, length, mem_ptr)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createValueTypeHeadEncoding(): string {
    const funcName = 'fixed_bytes256_to_felt_dynamic_array';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }
}

function mul(cairoVar: string, scalar: number | bigint) {
  if (scalar === 1) return cairoVar;
  return `${cairoVar} * ${scalar}`;
}

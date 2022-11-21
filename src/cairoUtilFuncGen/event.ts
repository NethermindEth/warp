import {
  DataLocation,
  EmitStatement,
  EventDefinition,
  FunctionCall,
  generalizeType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';

import {
  AbiEncode,
  AST,
  CairoType,
  createCairoFunctionStub,
  createCallToFunction,
  isValueType,
  mapRange,
  safeGetNodeType,
  TypeConversionContext,
  typeNameFromTypeNode,
} from '../export';
import { StringIndexedFuncGenWithAuxiliar } from './base';

import keccak from 'keccak';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Generates a cairo function that emits an event through a cairo syscall.
 * Then replace the emit statement with a call to the generated function.
 */
export class EventFunction extends StringIndexedFuncGenWithAuxiliar {
  private abiEncode: AbiEncode;

  constructor(abiEncode: AbiEncode, ast: AST, sourceUint: SourceUnit) {
    super(ast, sourceUint);
    this.abiEncode = abiEncode;
  }

  public gen(node: EmitStatement, refEventDef: EventDefinition): FunctionCall {
    const argsTypes: TypeNode[] = node.vEventCall.vArguments.map(
      (arg) => generalizeType(safeGetNodeType(arg, this.ast.compilerVersion))[0],
    );

    const funcName = this.getOrCreate(refEventDef);

    const functionStub = createCairoFunctionStub(
      funcName,
      argsTypes.map((argT, index) =>
        isValueType(argT)
          ? [`param${index}`, typeNameFromTypeNode(argT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(argT, this.ast), DataLocation.Memory],
      ),
      [],
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      this.sourceUnit,
    );

    return createCallToFunction(functionStub, node.vEventCall.vArguments, this.ast);
  }

  private getOrCreate(node: EventDefinition): string {
    const key = node.name;
    const existing = this.generatedFunctions.get(key);

    if (existing !== undefined) {
      return existing.name;
    }

    const [params, insertions] = node.vParameters.vParameters.reduce(
      ([params, insertions], param, index) => {
        const paramType = generalizeType(safeGetNodeType(param, this.ast.compilerVersion))[0];
        const cairoType = CairoType.fromSol(paramType, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        insertions.push(
          this.generateInsertionCode(paramType, param.indexed ? 'keys' : 'data', `param${index}`),
        );
        return [params, insertions];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');

    const code = [
      `func _emit_${key}${IMPLICITS}(${cairoParams}){`,
      `   alloc_locals;`,
      `   let (keys: felt*) = alloc();`,
      this.genTopicCode(node, 0),
      `   let (data: felt*) = alloc();`,
      ...insertions,
      `   return ();`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');

    this.generatedFunctions.set(key, { name: `_emit_${key}`, code: code });
    return `_emit_${key}`;
  }

  private generateInsertionCode(type: TypeNode, arrayName: string, argName: string): string {
    const abiFunc = this.abiEncode.getOrCreate([type]);
    this.requireImport('warplib.dynamic_arrays_util', 'memory_array_to_felt_array');
    return [
      `   let (mem_encode: felt) = ${abiFunc}(${argName});`,
      `   memory_array_to_felt_array(mem_encode, ${arrayName}, 0);`,
    ].join('\n');
  }

  private genTopicCode(node: EventDefinition, index: number): string {
    const topic: string = keccak('keccak256')
      .update(node.canonicalSignature(ABIEncoderVersion.V2))
      .digest('hex');

    const topicLength = topic.length / 2;
    const topicFelts = mapRange(topicLength, (n) => parseInt(topic.slice(2 * n, 2 * n + 2), 16));

    return `   let (keys_len: felt) = ${this.getOrCreateTopic(
      topicLength,
    )}(keys, ${index}, ${topicFelts.join(',')});`;
  }

  private getOrCreateTopic(length: number): string {
    const existing = this.auxiliarGeneratedFunctions.get(`TP_${length}`);

    if (existing !== undefined) {
      return existing.name;
    }

    const code = [
      `func TP_${length}${IMPLICITS}(keys: felt*, index: felt${length ? ', ' : ''}${mapRange(
        length,
        (n) => `e${n}: felt`,
      )}) -> (new_index: felt){`,
      `   alloc_locals;`,
      ...mapRange(length, (n) => `   assert keys[${n}] = e${n};`),
      `   return (new_index = index + ${length});`,
      `}`,
    ].join('\n');

    this.auxiliarGeneratedFunctions.set(`TP_${length}`, {
      name: `TP_${length}`,
      code: code,
    });

    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');

    return `TP_${length}`;
  }
}

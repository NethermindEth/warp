import {
  ArrayType,
  BytesType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { TranspileFailedError } from '../../utils/errors';
import { getElementType, isDynamicArray, isValueType } from '../../utils/nodeTypeProcessing';
import { StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiEncodePacked } from './abiEncodePacked';

const IMPLICITS = '';
export class AbiEncode extends StringIndexedFuncGen {
  protected functionName = 'abi_encode';
  constructor(
    private abiEncodePacked: AbiEncodePacked,
    memoryRead: MemoryReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  protected getOrCreate(typesToEncode: TypeNode[]): string {
    const indexVar = 'index';
    const offsetVar = 'offset';
    const arrayVar = 'byte_array';
    const params: string[] = [];
    const encodingCode: string[] = [];
    typesToEncode.forEach((type, index) => {});

    const code = [
      `func ${this.functionName}${IMPLICITS}(): -> (result_ptr : felt):`,
      `  alloc_locals`,
      `  let ${indexVar} : felt = 0`,
      `  let ${offsetVar} : felt = 0`,
      `  let (${arrayVar} : felt*) = alloc()`,
      `  `,
      `  `,
      `  `,
      `end`,
    ];

    return '';
  }

  // Algorithm
  // 1. Calculate everybody's max size (I have the compile info)
  //    - Dynamically sized types get one slot
  //    - Statically sized can be calculated on compile time
  // 2. Set initial offset as the sum of all calculated values
  // 3. Encode each value's HEAD
  //    - If it is a dynamic type, set the slot with the current offset
  //    and increase it accordingly in case for the next dynamic type
  //    - If it is a static type, fill the slots with the corresponding values
  //    Can  possible values be offset as well? (Should check this)
  // 4. Encode each value's TAIL
  //    - Get for each list, and get the offset and make a recursion that starts
  //    from the offset to the type length and fill with the correspoding values
  // 5. Get the compile info of the elements produced by TAIL encoding (HOW?)

  protected generateTypeEncoding(
    type: TypeNode,
    memLoc: string,
    currIndex: string,
    currParam: string,
    currParamSize: string,
  ): string {
    if (isDynamicArray(type)) {
      const funcName = this.generateDynamicArrayEncodeFunction(type);
    }

    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      const funcName = this.generateStructEncodingFunction(type);
    }

    // If it is not dynamic, it is static
    if (type instanceof ArrayType) {
      const funcName = isValueType(type.elementT);
      // ? this.abiEncodePacked.generateInlineArrayEncodingFunction(type)
      //  : this.generateInlineArrayEncodingFunction(type);
    }

    if (isValueType(type)) {
      const args = [memLoc, currIndex, `${currIndex} + ${currParamSize}`, currParam, 0];
      // const funcName = this.getValueTypeEncodingFunction(32);
      // return `${funcName}(${args.join(',')})`;
    }

    throw new TranspileFailedError(`Could not generate abi encdoing for ${printTypeNode(type)}`);
  }

  private encodeHead(type: TypeNode, indexVar: string, offsetVar: string, arrayVar: string) {
    if (isDynamicArray(type)) {
    }
  }

  private encodeTail(type: TypeNode) {}

  private encodeDynamicArrayHead(type: ArrayType | StringType | BytesType) {
    // element_offset = offset
    // element_length = get_length
    // new_offset = offset + element_length
    // new_index = index + 1
    const funcName = '';
    const code = [`func ${funcName}${IMPLICITS}():`, `  alloc_locals`, `  `, `end`];
  }

  private encodeDynamicArrayTail(type: ArrayType | StringType | BytesType) {
    // This is going to be a recursion
    // from element_offset to element_offset + element_length
    // encode head of what is there

    const funcName = '';
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `  offset : felt,`,
      `  max_offset : felt,`,
      `  bytes_array : felt*,`,
      `  darray_ptr : felt`,
      `):`,
      `  alloc_locals`,
      `  if offset == max_offset:`,
      `    return ()`,
      `  end`,
      `  `,
      `end`,
    ];
  }

  protected generateDynamicArrayEncodeFunction(type: ArrayType | StringType | BytesType): string {
    throw new Error('Not implemented');
  }

  protected generateStructEncodingFunction(type: UserDefinedType): string {
    const def = type.definition;
    throw new Error('Not implemented');
  }

  protected calculateSize(type: TypeNode, cairoVar: string, suffix: string | number): string {
    if (isDynamicArray(type)) {
      const elemenT = getElementType(type);
    }

    throw new TranspileFailedError(`Could not get byte size for ${printTypeNode(type)}`);
  }
}

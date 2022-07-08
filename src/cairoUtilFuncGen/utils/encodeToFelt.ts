import assert from 'assert';
import {
  ArrayType,
  BytesType,
  FunctionCall,
  getNodeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoDynArray,
  CairoStruct,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import {
  getElementType,
  isDynamicArray,
  isStruct,
  isValueType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe } from '../../utils/utils';
import { CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';

const IMPLICITS = '{}';

export class EncodeAsFelt extends StringIndexedFuncGen {
  private auxiliarGeneratedFunctions = new Map<string, CairoFunction>();

  gen(newFunctionCall: FunctionCall, sourceUnit: SourceUnit): FunctionCall {
    return newFunctionCall;
  }

  getOrCreate(typesToEncode: TypeNode[]): string {
    const key = typesToEncode.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const parameters: string[] = [];
    const encodeCode: string[] = [];

    typesToEncode.forEach((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
      const prefix = `arg_${index}_`;

      if (isDynamicArray(type)) {
        assert(cairoType instanceof CairoDynArray);
        const sizeName = `${prefix}_size`;
        const arrayName = `${prefix}${cairoType.name}`;
        parameters.push(`${sizeName} : felt, ${arrayName} : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCrateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${sizeName}, ${arrayName})`,
        );
      } else if (type instanceof ArrayType) {
        parameters.push(`${prefix}static : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCrateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${prefix}static)`,
        );
      } else if (isStruct(type)) {
        assert(cairoType instanceof CairoStruct);
        parameters.push(`${prefix}${cairoType.name} : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCrateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${prefix}${cairoType.name})`,
        );
      } else if (isValueType(type)) {
        parameters.push(`${prefix}} : ${cairoType.typeName}`);
        encodeCode.push(
          cairoType.width > 1
            ? [
                `let decode_array[total_size] = ${prefix}.low`,
                `let decode_array[total_size + 1] = ${prefix}.high`,
                `let total_size = total_size + 2`,
              ].join('\n')
            : [`let decode_array[total_size] ${prefix}`, `let total_size = total_size + 1`].join(
                '\n',
              ),
        );
      } else {
        throw new NotSupportedYetError(
          `Decoding ${printTypeNode(type)} into felt dynamic array is not supported yet`,
        );
      }
    });

    const funcName = `encode_as_felt${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${parameters.join(',')}) -> (len : felt, array : felt*):`,
      `   alloc_locals`,
      `   let total_size : felt = ${0}`,
      `   let (decode_array : felt*) = alloc()`,
      `   return (size=size, array=array)`,
      `end`,
    ];

    this.generatedFunctions.set(key, { name: funcName, code: code.join('\n') });

    return funcName;
  }

  private getOrCrateAuxiliar(type: TypeNode): string {
    const key = type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);

    if (existing !== undefined) {
      return existing.name;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Encoding of type ${printTypeNode(type)} is not supported yet`,
      );
    };

    const cairoFunc = delegateBasedOnType<CairoFunction>(
      type,
      (type) => this.generateDynamicArrayEncodeFunction(type),
      (type) => this.generateStaticArrayEncodeFunction(type),
      (type) => this.generateStructEncodeFunction(type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );

    this.auxiliarGeneratedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  private generateEncodeCode(type: TypeNode, currentElementName: string) {
    if (isValueType(type)) {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
      return cairoType.width > 1
        ? [
            `let to_array[to_index] = ${currentElementName}.low`,
            `let to_array[to_index + 1] = ${currentElementName}.high`,
            `let to_index = to_index + 2`,
          ]
        : [`let to_array[to_index] = ${currentElementName}`, `let to_index = to_index + 1`];
    }

    const auxFuncName = this.getOrCrateAuxiliar(type);
    return [`let (to_index) = ${auxFuncName}(to_index, to_array, ${currentElementName})`];
  }

  private generateDynamicArrayEncodeFunction(
    type: ArrayType | BytesType | StringType,
  ): CairoFunction {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const elemenT = getElementType(type);
    const funcName = `encode_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `   to_index : felt`,
      `   to_array : felt*`,
      `   from_index: felt`,
      `   from_size: felt`,
      `   from_array: ${cairoType.toString()}`,
      `) -> (total_copied : felt):`,
      `   alloc_locals`,
      `   if from_index == from_size:`,
      `      return (total_copied=to_index)`,
      `   end`,
      `   let current_element = from_array[from_index]`,
      ...this.generateEncodeCode(elemenT, 'current_element'),
      `   return ${funcName}(to_index, to_array, from_index + 1, from_size, from_array)`,
      `end`,
    ];

    return { name: funcName, code: code.join('\n') };
  }

  private generateStructEncodeFunction(type: UserDefinedType): CairoFunction {
    assert(type.definition instanceof StructDefinition);

    const encodeCode = type.definition.vMembers.map((varDecl, index) => {
      const varType = getNodeType(varDecl, this.ast.compilerVersion);
      return [
        `let member_${index} = from_struct.${varDecl.name}`,
        ...this.generateEncodeCode(varType, `member_${index}`),
      ].join('\n');
    });

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoStruct);

    const funcName = cairoType.name;
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `   to_index : felt, to_array : felt*, from_struct : ${cairoType.toString()}`,
      `) -> (total_copied : felt):`,
      `    alloc_locals`,
      ...encodeCode,
      `    return (to_index)`,
      `end`,
    ];
    return { name: funcName, code: code.join('\n') };
  }

  private generateStaticArrayEncodeFunction(type: ArrayType): CairoFunction {
    assert(type.size !== undefined);
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const elemenT = type.elementT;
    const encodeCode = mapRange(narrowBigIntSafe(type.size), (index) => {
      return [
        `let elem_${index} = from_static_array[${index}]`,
        ...this.generateEncodeCode(elemenT, `elem_${index}`),
      ].join('\n');
    });

    const funcName = `encode_static_size${type.size}_array_${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(to_index : felt, to_array : felt*, from_static_array : ${cairoType.toString()})`,
      `    alloc_locals`,
      ...encodeCode,
      `    return (to_index)`,
      `end`,
    ];
    return { name: funcName, code: code.join('\n') };
  }
}

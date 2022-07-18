import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  SourceUnit,
  StringType,
  StructDefinition,
  typeNameToTypeNode,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoDynArray,
  CairoStruct,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getElementType,
  isDynamicArray,
  isStruct,
  isValueType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { ExternalDynArrayStructConstructor } from '../calldata/externalDynArray/externalDynArrayStructConstructor';

const IMPLICITS = '';

// TODO:
// What happens with sructs defined in other contract different than the one using new

export class EncodeAsFelt extends StringIndexedFuncGen {
  private auxiliarGeneratedFunctions = new Map<string, CairoFunction>();

  constructor(
    private externalArrayGen: ExternalDynArrayStructConstructor,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  getGeneratedCode(): string {
    return [...this.auxiliarGeneratedFunctions.values(), ...this.generatedFunctions.values()]
      .map((func) => func.code)
      .join('\n\n');
  }

  gen(newFunctionCall: FunctionCall, sourceUnit?: SourceUnit): FunctionCall {
    const argTypes = newFunctionCall.vArguments.map(
      (arg) => generalizeType(getNodeType(arg, this.ast.compilerVersion))[0],
    );
    const functionName = this.getOrCreate(argTypes);

    const functionStub = createCairoFunctionStub(
      functionName,
      argTypes.map((argType, index) => [
        `arg${index}`,
        typeNameFromTypeNode(argType, this.ast),
        DataLocation.CallData,
      ]),
      [['result', createBytesTypeName(this.ast), DataLocation.CallData]],
      [],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );
    return createCallToFunction(functionStub, newFunctionCall.vArguments, this.ast);
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
      const prefix = `arg_${index}`;

      if (isDynamicArray(type)) {
        assert(cairoType instanceof CairoDynArray);
        const arrayName = `${prefix}_dynamic`;
        parameters.push(` ${arrayName} : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCreateAuxiliar(type);
        encodeCode.push(
          `assert decode_array[total_size] = ${arrayName}.len`,
          `let total_size = total_size + 1`,
          `let (total_size) = ${auxFuncName}(total_size, decode_array, 0, ${arrayName}.len, ${arrayName}.ptr)`,
        );
      } else if (type instanceof ArrayType) {
        parameters.push(`${prefix}_static : ${cairoType.toString()}`);
        const auxFuncName = this.getOrCreateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${prefix}_static)`,
        );
      } else if (isStruct(type)) {
        assert(cairoType instanceof CairoStruct);
        parameters.push(`${prefix}_${cairoType.name} : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCreateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${prefix}_${cairoType.name})`,
        );
      } else if (isValueType(type)) {
        parameters.push(`${prefix} : ${cairoType.typeName}`);
        encodeCode.push(
          cairoType.width > 1
            ? [
                `assert decode_array[total_size] = ${prefix}.low`,
                `assert decode_array[total_size + 1] = ${prefix}.high`,
                `let total_size = total_size + 2`,
              ].join('\n')
            : [
                `assert decode_array[total_size] = ${prefix}`,
                `let total_size = total_size + 1`,
              ].join('\n'),
        );
      } else {
        throw new NotSupportedYetError(
          `Decoding ${printTypeNode(type)} into felt dynamic array is not supported yet`,
        );
      }
    });

    const resultStruct = this.externalArrayGen.getOrCreate(
      typeNameToTypeNode(createBytesTypeName(this.ast)),
    );

    const cairoParams = parameters.join(',');
    const funcName = `encode_as_felt${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (calldata_array : ${resultStruct}):`,
      `   alloc_locals`,
      `   let total_size : felt = ${0}`,
      `   let (decode_array : felt*) = alloc()`,
      ...encodeCode,
      `   let result = ${resultStruct}(total_size, decode_array)`,
      `   return (result)`,
      `end`,
    ].join('\n');
    this.ast.registerImport(this.sourceUnit, 'starkware.cairo.common.alloc', 'alloc');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return funcName;
  }

  private getOrCreateAuxiliar(type: TypeNode): string {
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
            `assert to_array[to_index] = ${currentElementName}.low`,
            `assert to_array[to_index + 1] = ${currentElementName}.high`,
            `let to_index = to_index + 2`,
          ]
        : [`assert to_array[to_index] = ${currentElementName}`, `let to_index = to_index + 1`];
    }

    const auxFuncName = this.getOrCreateAuxiliar(type);
    return [`let (to_index) = ${auxFuncName}(to_index, to_array, ${currentElementName})`];
  }

  private generateDynamicArrayEncodeFunction(
    type: ArrayType | BytesType | StringType,
  ): CairoFunction {
    const cairoElementType = CairoType.fromSol(
      getElementType(type),
      this.ast,
      TypeConversionContext.CallDataRef,
    );
    const elemenT = getElementType(type);
    const funcName = `encode_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `   to_index : felt,`,
      `   to_array : felt*,`,
      `   from_index: felt,`,
      `   from_size: felt,`,
      `   from_array: ${cairoElementType.toString()}*`,
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

    const funcName = `encode_struct_${cairoType.name}`;
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
      `func ${funcName}${IMPLICITS}(to_index : felt, to_array : felt*, from_static_array : ${cairoType.toString()}) -> (total_copied : felt):`,
      `    alloc_locals`,
      ...encodeCode,
      `    return (to_index)`,
      `end`,
    ];
    return { name: funcName, code: code.join('\n') };
  }
}

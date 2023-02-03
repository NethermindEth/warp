import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeName,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoDynArray,
  CairoStruct,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError, WillNotSupportError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getElementType,
  isDynamicArray,
  isStruct,
  isValueType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import {
  delegateBasedOnType,
  GeneratedFunctionInfo,
  StringIndexedFuncGenWithAuxiliar,
} from '../base';
import { ExternalDynArrayStructConstructor } from '../calldata/externalDynArray/externalDynArrayStructConstructor';

const IMPLICITS = '';

/**
 * This class generate `encode` cairo util functions with the objective of making
 * a list of values into a single list where all items are felts. For example:
 * Value list: [a : felt, b : Uint256, c : (felt, felt, felt), d_len : felt, d : felt*]
 * Result: [a, b.low, b.high, c[0], c[1], c[2], d_len, d[0], ..., d[d_len - 1]]
 *
 * It generates a different function depending on the amount of expressions
 * and their types. It also generate different auxiliar functions depending
 * on the type to encode.
 *
 * Auxiliar functions can and will be reused if possible between different
 * generated encoding functions. I.e. the auxiliar function to encode felt
 * dynamic arrays will be always the same
 */
export class EncodeAsFelt extends StringIndexedFuncGenWithAuxiliar {
  constructor(
    private externalArrayGen: ExternalDynArrayStructConstructor,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  /**
   * Given a expression list it generates a `encode` cairo function definition
   * and call that serializes the arguments into a list of felts
   * @param expressions expression list
   * @param expectedTypes expected type for each expression of the list
   * @param sourceUnit source unit where the expression is defined
   * @returns a function call that serializes the value of `expressions`
   */
  gen(expressions: Expression[], expectedTypes: TypeNode[]): FunctionCall {
    assert(expectedTypes.length === expressions.length);
    expectedTypes = expectedTypes.map((type) => generalizeType(type)[0]);
    const funcDef = this.getOrCreateFuncDef(expectedTypes);
    return createCallToFunction(funcDef, expressions, this.ast);
  }

  private getOrCreateFuncDef(expectedTypes: TypeNode[]) {
    const expectedTypesName = expectedTypes.map((value) => `${value.pp()}`).flat();
    const key = `encodeToFelt(${expectedTypesName})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }
    const funcInfo = this.getOrCreate(expectedTypes);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      expectedTypes.map((exprT, index) => {
        const input: [string, TypeName] = [`arg${index}`, typeNameFromTypeNode(exprT, this.ast)];
        return isValueType(exprT) ? input : [...input, DataLocation.CallData];
      }),
      [['result', createBytesTypeName(this.ast), DataLocation.CallData]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  /**
   * Given a type list it generates a `encode` cairo function definition
   * that serializes the arguments into a list of felts
   * @param typesToEncode type list
   * @returns the name of the generated function
   */
  private getOrCreate(typesToEncode: TypeNode[]): GeneratedFunctionInfo {
    const parameters: string[] = [];
    const encodeCode: string[] = [];
    const functionsCalled: FunctionDefinition[] = [];

    typesToEncode.forEach((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
      const prefix = `arg_${index}`;

      if (isDynamicArray(type)) {
        assert(cairoType instanceof CairoDynArray);

        const arrayName = `${prefix}_dynamic`;
        parameters.push(` ${arrayName} : ${cairoType.typeName}`);

        const auxFunc = this.getOrCreateAuxiliar(type);
        functionsCalled.push(auxFunc);

        encodeCode.push(
          `assert decode_array[total_size] = ${arrayName}.len;`,
          `let total_size = total_size + 1;`,
          `let (total_size) = ${auxFunc.name}(total_size, decode_array, 0, ${arrayName}.len, ${arrayName}.ptr);`,
        );
      } else if (type instanceof ArrayType) {
        parameters.push(`${prefix}_static : ${cairoType.toString()}`);

        const auxFunc = this.getOrCreateAuxiliar(type);
        functionsCalled.push(auxFunc);

        encodeCode.push(
          `let (total_size) = ${auxFunc.name}(total_size, decode_array, ${prefix}_static);`,
        );
      } else if (isStruct(type)) {
        assert(cairoType instanceof CairoStruct);
        parameters.push(`${prefix}_${cairoType.name} : ${cairoType.typeName}`);
        const auxFuncName = this.getOrCreateAuxiliar(type);
        encodeCode.push(
          `let (total_size) = ${auxFuncName}(total_size, decode_array, ${prefix}_${cairoType.name});`,
        );
      } else if (isValueType(type)) {
        parameters.push(`${prefix} : ${cairoType.typeName}`);
        encodeCode.push(
          cairoType.width > 1
            ? [
                `assert decode_array[total_size] = ${prefix}.low;`,
                `assert decode_array[total_size + 1] = ${prefix}.high;`,
                `let total_size = total_size + 2;`,
              ].join('\n')
            : [
                `assert decode_array[total_size] = ${prefix};`,
                `let total_size = total_size + 1;`,
              ].join('\n'),
        );
      } else {
        throw new WillNotSupportError(
          `Decoding ${printTypeNode(type)} into felt dynamic array is not supported`,
        );
      }
    });

    const resultStruct = this.externalArrayGen.getOrCreateFuncDef(new BytesType());

    const cairoParams = parameters.join(',');
    const funcName = `encode_as_felt${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (calldata_array : ${resultStruct}){`,
      `   alloc_locals;`,
      `   let total_size : felt = 0;`,
      `   let (decode_array : felt*) = alloc();`,
      ...encodeCode,
      `   let result = ${resultStruct.name}(total_size, decode_array);`,
      `   return (result,);`,
      `}`,
    ].join('\n');

    const importFunc = this.requireImport('starkware.cairo.common.alloc', 'alloc');

    const funcInfo = {
      name: funcName,
      code: code,
      functionsCalled: [importFunc, ...functionsCalled, resultStruct],
    };
    return funcInfo;
  }

  /**
   * Given a type it generates the appropiate auxiliar encoding function for this specific type.
   * @param type to encode (only arrays and structs allowed)
   * @returns name of the generated function
   */
  private getOrCreateAuxiliar(type: TypeNode): CairoFunctionDefinition {
    const key = type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);

    if (existing !== undefined) {
      return existing;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Encoding of type ${printTypeNode(type)} is not supported yet`,
      );
    };

    const cairoFunc = delegateBasedOnType<CairoGeneratedFunctionDefinition>(
      type,
      (type) => this.generateDynamicArrayEncodeFunction(type),
      (type) => this.generateStaticArrayEncodeFunction(type),
      (type) => this.generateStructEncodeFunction(type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );

    this.auxiliarGeneratedFunctions.set(key, cairoFunc);
    return cairoFunc;
  }

  /**
   * Generates caior code depending on the type. If it is a value type it generates
   * the appropiate instructions. If it is a an array or struct, it generates a function
   * call
   * @param type type to generate encoding code
   * @param currentElementName cairo variable to encode to felt
   * @returns generated code
   */
  private generateEncodeCode(type: TypeNode, currentElementName: string): string[] {
    if (isValueType(type)) {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
      return cairoType.width > 1
        ? [
            `assert to_array[to_index] = ${currentElementName}.low;`,
            `assert to_array[to_index + 1] = ${currentElementName}.high;`,
            `let to_index = to_index + 2;`,
          ]
        : [`assert to_array[to_index] = ${currentElementName};`, `let to_index = to_index + 1;`];
    }

    const auxFuncName = this.getOrCreateAuxiliar(type);
    return [`let (to_index) = ${auxFuncName}(to_index, to_array, ${currentElementName});`];
  }

  private generateDynamicArrayEncodeFunction(
    type: ArrayType | BytesType | StringType,
  ): CairoGeneratedFunctionDefinition {
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
      `) -> (total_copied : felt){`,
      `   alloc_locals;`,
      `   if (from_index == from_size){`,
      `      return (total_copied=to_index,);`,
      `   }`,
      `   let current_element = from_array[from_index];`,
      ...this.generateEncodeCode(elemenT, 'current_element'),
      `   return ${funcName}(to_index, to_array, from_index + 1, from_size, from_array);`,
      `}`,
    ];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code.join('\n'),
      functionsCalled: [],
    };

    return createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit);
  }

  private generateStructEncodeFunction(type: UserDefinedType): CairoGeneratedFunctionDefinition {
    assert(type.definition instanceof StructDefinition);

    const encodeCode = type.definition.vMembers.map((varDecl, index) => {
      const varType = safeGetNodeType(varDecl, this.ast.inference);
      return [
        `let member_${index} = from_struct.${varDecl.name};`,
        ...this.generateEncodeCode(varType, `member_${index}`),
      ].join('\n');
    });

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoStruct);

    const funcName = `encode_struct_${cairoType.name}`;
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `   to_index : felt, to_array : felt*, from_struct : ${cairoType.toString()}`,
      `) -> (total_copied : felt){`,
      `    alloc_locals;`,
      ...encodeCode,
      `    return (to_index,);`,
      `}`,
    ];

    const funcInfo = { name: funcName, code: code.join('\n'), functionsCalled: [] };
    return createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit);
  }

  private generateStaticArrayEncodeFunction(type: ArrayType): CairoGeneratedFunctionDefinition {
    assert(type.size !== undefined);
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const elemenT = type.elementT;
    const encodeCode = mapRange(narrowBigIntSafe(type.size), (index) => {
      return [
        `let elem_${index} = from_static_array[${index}];`,
        ...this.generateEncodeCode(elemenT, `elem_${index}`),
      ].join('\n');
    });

    const funcName = `encode_static_size${type.size}_array_${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(to_index : felt, to_array : felt*, from_static_array : ${cairoType.toString()}) -> (total_copied : felt){`,
      `    alloc_locals;`,
      ...encodeCode,
      `    return (to_index,);`,
      `}`,
    ];

    const funcInfo = { name: funcName, code: code.join('\n'), functionsCalled: [] };
    return createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit);
  }
}

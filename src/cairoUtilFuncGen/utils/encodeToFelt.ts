import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  isReferenceType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeName,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { CairoFunctionDefinition, notUndefined } from '../../export';
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
  public constructor(
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
  public gen(expressions: Expression[], expectedTypes: TypeNode[]): FunctionCall {
    assert(expectedTypes.length === expressions.length);
    expectedTypes = expectedTypes.map((type) => generalizeType(type)[0]);
    const funcDef = this.getOrCreateFuncDef(expectedTypes);
    return createCallToFunction(funcDef, expressions, this.ast);
  }

  public getOrCreateFuncDef(typesToEncode: TypeNode[]) {
    const key = typesToEncode.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }
    const funcInfo = this.getOrCreate(typesToEncode);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      typesToEncode.map((exprT, index) => {
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
    const [parameters, encodeCode, encodeCalls] = typesToEncode.reduce(
      ([parameters, encodeCode, encodeCalls], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
        const prefix = `arg_${index}`;
        if (isDynamicArray(type)) {
          // Handle dynamic arrays
          assert(cairoType instanceof CairoDynArray);
          const arrayName = `${prefix}_dynamic`;
          const auxFunc = this.getOrCreateAuxiliar(type);
          return [
            [...parameters, ` ${arrayName} : ${cairoType.typeName}`],
            [
              ...encodeCode,
              `assert decode_array[total_size] = ${arrayName}.len;`,
              `let total_size = total_size + 1;`,
              `let (total_size) = ${auxFunc.name}(total_size, decode_array, 0, ${arrayName}.len, ${arrayName}.ptr);`,
            ],
            [...encodeCalls, auxFunc],
          ];
        } else if (type instanceof ArrayType) {
          // Handle static arrays
          const auxFunc = this.getOrCreateAuxiliar(type);
          return [
            [...parameters, `${prefix}_static : ${cairoType.toString()}`],
            [
              ...encodeCode,
              `let (total_size) = ${auxFunc.name}(total_size, decode_array, ${prefix}_static);`,
            ],
            [...encodeCalls, auxFunc],
          ];
        } else if (isStruct(type)) {
          // Handle structs
          assert(cairoType instanceof CairoStruct);
          const auxFuncName = this.getOrCreateAuxiliar(type);
          return [
            [...parameters, `${prefix}_${cairoType.name} : ${cairoType.typeName}`],
            [
              ...encodeCode,
              `let (total_size) = ${auxFuncName.name}(total_size, decode_array, ${prefix}_${cairoType.name});`,
            ],
            [...encodeCalls, auxFuncName],
          ];
        } else if (isValueType(type)) {
          // Handle value types
          return [
            [...parameters, `${prefix} : ${cairoType.typeName}`],
            [
              ...encodeCode,
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
            ],
            [...encodeCalls],
          ];
        }
        throw new WillNotSupportError(
          `Decoding ${printTypeNode(type)} into felt dynamic array is not supported`,
        );
      },
      [new Array<string>(), new Array<string>(), new Array<CairoFunctionDefinition>()],
    );

    const resultStruct = this.externalArrayGen.getOrCreateFuncDef(new BytesType());

    const cairoParams = parameters.join(',');
    const funcName = `encode_as_felt${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (calldata_array : ${resultStruct.name}){`,
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
      functionsCalled: [importFunc, ...encodeCalls, resultStruct].filter(notUndefined),
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
  private generateEncodeCode(
    type: TypeNode,
    currentElementName: string,
  ): [string[], CairoFunctionDefinition[]] {
    if (isValueType(type)) {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
      return [
        cairoType.width === 2
          ? [
              `assert to_array[to_index] = ${currentElementName}.low;`,
              `assert to_array[to_index + 1] = ${currentElementName}.high;`,
              `let to_index = to_index + 2;`,
            ]
          : [`assert to_array[to_index] = ${currentElementName};`, `let to_index = to_index + 1;`],
        [],
      ];
    }

    const auxFuncName = this.getOrCreateAuxiliar(type);
    return [
      [`let (to_index) = ${auxFuncName.name}(to_index, to_array, ${currentElementName});`],
      [auxFuncName],
    ];
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
    const [encodingCode, encodingCalls] = this.generateEncodeCode(elemenT, 'current_element');
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
      ...encodingCode,
      `   return ${funcName}(to_index, to_array, from_index + 1, from_size, from_array);`,
      `}`,
    ];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code.join('\n'),
      functionsCalled: encodingCalls,
    };

    return createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit);
  }

  private generateStructEncodeFunction(type: UserDefinedType): CairoGeneratedFunctionDefinition {
    assert(type.definition instanceof StructDefinition);

    const [encodeCode, encodeCalls] = type.definition.vMembers.reduce(
      ([encodeCode, encodeCalls], varDecl, index) => {
        const varType = safeGetNodeType(varDecl, this.ast.inference);
        const [memberEncodeCode, memberEncodeCalls] = this.generateEncodeCode(
          varType,
          `member_${index}`,
        );
        return [
          [
            ...encodeCode,
            `let member_${index} = from_struct.${varDecl.name};`,
            ...memberEncodeCode,
          ],
          [...encodeCalls, ...memberEncodeCalls],
        ];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>()],
    );

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoStruct);

    const funcName = `encode_struct_${cairoType.name}`;
    return this.createAuxiliarGeneratedFunction({
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(`,
        `   to_index : felt, to_array : felt*, from_struct : ${cairoType.toString()}`,
        `) -> (total_copied : felt){`,
        `    alloc_locals;`,
        ...encodeCode,
        `    return (to_index,);`,
        `}`,
      ].join('\n'),
      functionsCalled: encodeCalls,
    });
  }

  // TODO: Do a small version of static array encoding
  private generateStaticArrayEncodeFunction(type: ArrayType): CairoGeneratedFunctionDefinition {
    assert(type.size !== undefined);
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const elemenT = type.elementT;

    const auxFunc = isReferenceType(elemenT) ? this.getOrCreateAuxiliar(elemenT) : undefined;

    const cairoElementT = CairoType.fromSol(elemenT, this.ast, TypeConversionContext.CallDataRef);
    const staticArrayEncoding = (element: string) => {
      if (isValueType(elemenT)) {
        return cairoElementT.width === 2
          ? [
              `assert to_array[to_index] = ${element}.low;`,
              `assert to_array[to_index + 1] = ${element}.high;`,
              `let to_index = to_index + 2;`,
            ]
          : [`assert to_array[to_index] = ${element};`, `let to_index = to_index + 1;`];
      }
      return [`let (to_index) = ${auxFunc!.name}(to_index, to_array, ${element});`];
    };

    const encodeCode = mapRange(narrowBigIntSafe(type.size), (index) => {
      return [
        `let elem_${index} = from_static_array[${index}];`,
        ...staticArrayEncoding(`elem_${index}`),
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

    return this.createAuxiliarGeneratedFunction({
      name: funcName,
      code: code.join('\n'),
      functionsCalled: auxFunc !== undefined ? [auxFunc] : [],
    });
  }
}

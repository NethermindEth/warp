import assert = require('assert');
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  IntType,
  Literal,
  LiteralKind,
  StringLiteralType,
  StringType,
  StructDefinition,
  TupleExpression,
  TupleType,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberLiteral } from '../../utils/nodeTemplates';
import {
  getElementType,
  getSize,
  isDynamicArray,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { notNull } from '../../utils/typeConstructs';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import {
  isUint,
  isUserElements,
  matrix3dFunctions,
  matrixExtraFunctions,
  recursiveStaticfunction,
  stringInit,
  struct_initializer,
} from '../utils/staticArrayUtils';

/*
  Converts [a,b,c] and "abc" into WM0_arr(a,b,c), which allocates new space in warp_memory
  and assigns the given values into that space, returning the location of the
  start of the array
*/
export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  public stringGen(node: Literal): FunctionCall {
    // Encode the literal to the uint-8 byte representation
    assert(
      node.kind === LiteralKind.String ||
        node.kind === LiteralKind.UnicodeString ||
        LiteralKind.HexString,
    );

    const size = node.hexValue.length / 2;
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    const funcDef = this.getOrCreateFuncDef(type, size, null, false, false);
    return createCallToFunction(
      funcDef,
      mapRange(size, (n) =>
        createNumberLiteral(parseInt(node.hexValue.slice(2 * n, 2 * n + 2), 16), this.ast),
      ),
      this.ast,
    );
  }

  public tupleGen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    const elementsInfo = isUserElements(elements, type);
    assert(
      type instanceof ArrayType ||
        type instanceof TupleType ||
        type instanceof BytesType ||
        type instanceof StringType,
    );

    const isMatrix =
      type instanceof ArrayType ? (type as ArrayType).elementT instanceof ArrayType : false;
    const is3dMatrix = isMatrix
      ? ((type as ArrayType).elementT as ArrayType).elementT instanceof ArrayType
      : false;

    const wideSize = getSize(type);
    const size =
      wideSize !== undefined
        ? narrowBigIntSafe(wideSize, `${printNode(node)} too long to process`)
        : elements.length;

    const funcDef = this.getOrCreateFuncDef(type, size, elementsInfo, isMatrix, is3dMatrix);
    return createCallToFunction(funcDef, elements, this.ast);
  }

  public getOrCreateFuncDef(
    type: ArrayType | StringType,
    size: number,
    elementsInfo: {
      userDefined: boolean;
      matrixSize: number;
      args: string[];
      isIdentifier: boolean;
    } | null,
    isMatrix: boolean,
    is3dMatrix: boolean,
  ) {
    const baseType = getElementType(type);

    const key = !isDynamicArray(type)
      ? type instanceof ArrayType
        ? `${baseType.pp()}${isMatrix ? 'matrix' : ''}${isUint(baseType, isMatrix) ? 'uint' : ''}${
            elementsInfo!.userDefined ? size : ''
          }`
        : baseType.pp() + size
      : baseType.pp() + size;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const baseTypeName = typeNameFromTypeNode(baseType, this.ast);
    const funcInfo = this.getOrCreate(
      baseType,
      isMatrix
        ? (baseType as ArrayType).size === undefined
          ? Number((type as ArrayType).size)
          : elementsInfo!.matrixSize
        : size,
      isDynamicArray(type) || type instanceof StringLiteralType,
      type instanceof ArrayType ? elementsInfo!.userDefined : false,
      isMatrix,
      is3dMatrix,
      !isDynamicArray(type) && type instanceof ArrayType
        ? elementsInfo!.userDefined
          ? elementsInfo!.args
          : []
        : [],
      !isDynamicArray(type) && type instanceof ArrayType ? elementsInfo!.isIdentifier : false,
    );
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      mapRange(size, (n) => [
        `arg_${n}`,
        cloneASTNode(baseTypeName, this.ast),
        locationIfComplexType(baseType, DataLocation.Memory),
      ]),
      [['arr', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(
    type: TypeNode,
    size: number,
    dynamic: boolean,
    isUserDefined: boolean,
    isMatrix: boolean,
    is3dMatrix: boolean,
    args: string[],
    isIdentifier: boolean,
  ): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const funcName = `wm${this.generatedFunctionsDef.size}_${dynamic ? 'dynamic' : 'static'}_array`;
    const isStruct = isMatrix
      ? (type as ArrayType).elementT instanceof UserDefinedType
      : type instanceof UserDefinedType;
    const members: string[] = [];
    if (isStruct) {
      if (isMatrix) {
        (
          ((type as ArrayType).elementT as UserDefinedType).definition as StructDefinition
        ).vMembers.forEach((member) => {
          const memberType = safeGetNodeType(member, this.ast.inference);
          if (memberType instanceof IntType) {
            if ((memberType as IntType).nBits === 256) {
              members.push('Uint256');
            }
          } else {
            members.push('felt');
          }
        });
      }
    }

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    const argStatic = isUserDefined && !dynamic ? `size_arr, arr: (${args.join(',')})` : 'size_arr';
    const argStaticMatrix =
      isUserDefined && !dynamic
        ? `row, column,${is3dMatrix ? ' column2,' : ''} matrix: (${args.join(', ')})`
        : `row, column${is3dMatrix ? ', column2' : ''}`;

    const initializationlist = mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
      .flat()
      .map(
        (name, index) =>
          `    dict_write{dict_ptr=warp_memory}(${add('start', index + 2)}, ${name});`,
      );

    const imports = () => {
      const importList = [
        this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
        this.requireImport('warplib.memory', 'wm_alloc'),
        this.requireImport('warplib.memory', 'wm_write_256'),
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      ];
      if (isUserDefined) {
        importList.push(this.requireImport('starkware.cairo.common.registers', 'get_fp_and_pc'));
      }
      return importList;
    };

    // If it's dynamic we need to include the length at the start
    const alloc_len = dynamic ? size * elementCairoType.width + 2 : size * elementCairoType.width;
    const isStaticDynamic = isMatrix && (type as ArrayType).size === undefined;
    return {
      name: funcName,
      code: [
        !isMatrix && type instanceof StringType ? stringInit(funcName) : [],
        isStruct ? struct_initializer(funcName, members) : [],
        ...(dynamic
          ? []
          : recursiveStaticfunction(
              funcName,
              type,
              isUint(type, isMatrix),
              isUserDefined,
              isStaticDynamic,
              isIdentifier,
            )),
        is3dMatrix
          ? matrix3dFunctions(funcName, isUint(type, isMatrix), isUserDefined).join('\n')
          : [],
        isMatrix && !isStaticDynamic
          ? matrixExtraFunctions(funcName, isUint(type, isMatrix), isUserDefined, is3dMatrix).join(
              '\n',
            )
          : [],

        ` `,
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${
          dynamic
            ? argString
            : (isMatrix && !isIdentifier) || is3dMatrix
            ? argStaticMatrix
            : argStatic
        }) -> (loc: felt){`,
        `    alloc_locals;`,
        isMatrix && !isIdentifier
          ? [
              `    let (size256) = felt_to_uint256(${
                isStaticDynamic && !isStruct
                  ? `row*column${isUint(type, isMatrix) && !isStaticDynamic ? ` * 2` : ''}`
                  : `row${isUint(type, isMatrix) ? '* 2' : ''}`
              });`,
              `    let (start) = wm_alloc(size256);`,
              isUserDefined ? '    let (__fp__, _) = get_fp_and_pc();' : '',
              isStaticDynamic && !isStruct
                ? `    ${funcName}_recursive(start,  start + row*column${
                    isUint(type, isMatrix) ? (isStaticDynamic ? '' : ` * 2`) : ''
                  }${!isUserDefined ? '' : ', cast(&matrix, felt*)'});`
                : `    ${funcName}_iterator(start + row${
                    isUint(type, isMatrix) ? '* 2' : ''
                  }, column${isUint(type, isMatrix) ? '* 2' : ''}${
                    is3dMatrix ? ', column2' : ''
                  }, start${isUserDefined ? ', cast(&matrix, felt*)' : ''});`,
            ].join('\n')
          : [
              dynamic
                ? ``
                : `    let (size256) = felt_to_uint256(size_arr${
                    isUint(type, isMatrix) ? ` * 2` : ''
                  });`,
              `    let (start) = wm_alloc(${dynamic ? uint256(alloc_len) : 'size256'});`,
              [
                dynamic
                  ? [`    wm_write_256{warp_memory=warp_memory}(start, ${uint256(size)});`]
                  : [],
                dynamic
                  ? initializationlist.join('\n')
                  : [
                      isUserDefined ? '    let (__fp__, _) = get_fp_and_pc();' : [],
                      `    ${funcName}_recursive(start,  start + size_arr${
                        isUint(type, isMatrix) ? ' * 2' : ''
                      }${isUserDefined ? ', cast(&arr, felt*)' : ''});`,
                    ].join('\n'),
              ].join('\n'),
            ].join('\n'),
        `    return (start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: imports(),
    };
  }
}

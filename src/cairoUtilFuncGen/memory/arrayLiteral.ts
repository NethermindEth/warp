import assert = require('assert');
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  Identifier,
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

    const funcDef = this.getOrCreateFuncDef(type, size, null, false);
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
    const elementsInfo = this.isUserElements(elements, type);
    assert(
      type instanceof ArrayType ||
        type instanceof TupleType ||
        type instanceof BytesType ||
        type instanceof StringType,
    );

    const isMatrix =
      type instanceof ArrayType ? (type as ArrayType).elementT instanceof ArrayType : false;
    const wideSize = getSize(type);
    const size =
      wideSize !== undefined
        ? narrowBigIntSafe(wideSize, `${printNode(node)} too long to process`)
        : elements.length;

    const funcDef = this.getOrCreateFuncDef(type, size, elementsInfo, isMatrix);
    return createCallToFunction(funcDef, elements, this.ast);
  }

  private isUserElements(
    elements: Expression[],
    type: TypeNode,
  ): { userDefined: boolean; matrixSize: number; args: string[] } {
    const isMatrix =
      type instanceof ArrayType ? (type as ArrayType).elementT instanceof ArrayType : false;
    const elementT = isMatrix
      ? ((type as ArrayType).elementT as ArrayType).elementT
      : (type as ArrayType).elementT;
    let userDefined = false;
    let matrixSize = 0;
    let args: string[] = [];
    elements.forEach((ele) => {
      if (elementT instanceof UserDefinedType) {
        userDefined = true;
        if (ele instanceof TupleExpression) {
          let argsRound: string[] = [];
          (ele as TupleExpression).vOriginalComponents.forEach((e) => {
            argsRound.push('felt');
          });
          args.push(`(${argsRound.join(', ')})`);
          argsRound = [];
        } else {
          if (isMatrix) {
            args.push('(felt)');
          } else {
            args.push('felt');
          }
        }
      } else if (ele instanceof Identifier) {
        userDefined = true;
        if (isMatrix) {
          args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? '(Uint256)' : '(felt)');
        } else {
          args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
        }
      } else if (isMatrix) {
        if (ele instanceof FunctionCall) {
          let argsRound: string[] = [];
          matrixSize = (ele as FunctionCall).vArguments.length;
          (ele as FunctionCall).vArguments.forEach((e) => {
            let value = (e as Literal).value;

            if (value === '0' || value === 'false' || value === '0x0') {
              argsRound.push(
                this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
              );
            } else {
              argsRound.push(
                this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
              );
              userDefined = true;
            }
          });
          args.push(`(${argsRound.join(', ')})`);
          argsRound = [];
        } else {
          let argsRound: string[] = [];
          if (ele instanceof TupleExpression) {
            matrixSize = (ele as TupleExpression).vOriginalComponents.length;
            (ele as TupleExpression).vOriginalComponents.forEach((e) => {
              if (e instanceof FunctionCall) {
                (e as FunctionCall).vArguments.forEach((e) => {
                  if (
                    (e as Literal).value === '' ||
                    (e as Literal).value === '0' ||
                    (e as Literal).value === 'false' ||
                    (e as Literal).value === '0x0'
                  ) {
                    argsRound.push(
                      this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                    );
                  } else {
                    argsRound.push(
                      this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                    );
                    userDefined = true;
                  }
                });
              } else if (e instanceof Literal) {
                if (
                  (e as Literal).value === '0' ||
                  (e as Literal).value === 'false' ||
                  (e as Literal).value === '0x0'
                ) {
                  argsRound.push(
                    this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                  );
                } else {
                  argsRound.push(
                    this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                  );
                  userDefined = true;
                }
              } else if (e instanceof Identifier) {
                userDefined = true;
                argsRound.push(
                  this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                );
              }
            });
            args.push(`(${argsRound.join(', ')})`);
            argsRound = [];
          }
        }
      } else {
        if (ele instanceof FunctionCall) {
          (ele as FunctionCall).vArguments.forEach((e) => {
            if (
              (e as Literal).value === '' ||
              (e as Literal).value === '0' ||
              (e as Literal).value === 'false' ||
              (e as Literal).value === '0x0'
            ) {
              args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
            } else {
              args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
              userDefined = true;
            }
          });
        } else if (ele instanceof Literal) {
          if (
            (ele as Literal).value === '0' ||
            (ele as Literal).value === 'false' ||
            (ele as Literal).value === '0x0'
          ) {
            args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
          } else {
            userDefined = true;
            args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
          }
        }
      }
    });
    return { userDefined, matrixSize, args };
  }

  public getOrCreateFuncDef(
    type: ArrayType | StringType,
    size: number,
    elementsInfo: { userDefined: boolean; matrixSize: number; args: string[] } | null,
    isMatrix: boolean,
  ) {
    const baseType = getElementType(type);

    const key = !isDynamicArray(type)
      ? type instanceof ArrayType
        ? `${baseType.pp()}${isMatrix ? 'matrix' : ''}${
            this.isUint(baseType, isMatrix) ? 'uint' : ''
          }${elementsInfo!.userDefined ? size : ''}`
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
      !isDynamicArray(type) && type instanceof ArrayType
        ? elementsInfo!.userDefined
          ? elementsInfo!.args
          : []
        : [],
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

  private struct_initializer(funcName: string, members: string[]): string {
    let feltMembers: string[] = [];
    let memberIndex: number = 0;
    let arrayIndex: number = 0;
    let args: string[] = [];
    members.forEach((member) => {
      if (member === 'Uint256') {
        feltMembers.push(
          `    dict_write{dict_ptr=warp_memory}(start${
            arrayIndex > 0 ? `+${arrayIndex}` : ''
          }, member_${memberIndex}.low);`,
        );
        feltMembers.push(
          `    dict_write{dict_ptr=warp_memory}(start${`+${
            arrayIndex + 1
          }`}, member_${memberIndex}.high);`,
        );
        arrayIndex = arrayIndex + 2;
        memberIndex = memberIndex + 1;
      } else {
        feltMembers.push(
          `    dict_write{dict_ptr=warp_memory}(start${
            arrayIndex > 0 ? `+${arrayIndex}` : ''
          }, member_${memberIndex});`,
        );
        arrayIndex = arrayIndex + 1;
        memberIndex = memberIndex + 1;
      }
      args.push(`member_${memberIndex - 1}: ${member === 'Uint256' ? `Uint256` : `felt`}`);
    });

    return [
      `func ${funcName}_struct_init{range_check_ptr, warp_memory: DictAccess*}(${args.join(
        ', ',
      )}) -> (start: felt){`,
      `    alloc_locals;`,
      `    let (start) = wm_alloc(${uint256(arrayIndex)});`,
      ...feltMembers,
      `    return (start,);`,
      `}`,
    ]
      .flat()
      .join('\n');
  }

  private recursiveStaticfunction(
    funcName: string,
    type: TypeNode,
    isUint: boolean,
    isUserDefined: boolean,
    isStaticDynamic: boolean,
  ): string[] {
    const isBytesOrString = type instanceof BytesType || type instanceof StringType;
    return [
      `func ${funcName}_recursive{range_check_ptr, warp_memory: DictAccess*}(index, size_arr${
        isUserDefined ? `, definedArr: felt*` : ''
      }) {`,
      `    alloc_locals;`,
      `    if (index == size_arr) {`,
      `        return ();`,
      `    }`,
      isBytesOrString || isStaticDynamic
        ? isUserDefined
          ? isStaticDynamic
            ? [
                `    let (arr) = wm_new(Uint256(low=definedArr[0], high=${
                  isUint ? 'definedArr[1]' : '0'
                }), Uint256(low=1, high=0));`,
              ]
            : []
          : ['    let (arr) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));']
        : [],
      `    dict_write{dict_ptr=warp_memory}(index, ${
        isBytesOrString || isStaticDynamic ? 'arr' : isUserDefined ? 'definedArr[0]' : '0'
      });`,

      isUint
        ? [
            `    dict_write{dict_ptr=warp_memory}(index + 1, ${
              isUserDefined ? 'definedArr[1]' : '0'
            });`,
          ]
        : [],
      `    return ${funcName}_recursive(index + ${isUint ? '2' : '1'}, size_arr${
        isUserDefined ? `, definedArr${isUint ? '+ 2' : '+ 1'}` : ''
      });`,
      `}`,
    ].flat();
  }

  private matrixExtraFunctions(
    funcName: string,
    isUint: boolean,
    isUserDefined: boolean,
  ): string[] {
    return [
      '  ',
      `func ${funcName}_matrix{range_check_ptr, warp_memory: DictAccess*}(size_arr${
        isUserDefined ? ', arr: felt*' : ''
      }) -> (loc: felt){`,
      '    alloc_locals;',
      '    let (size256) = felt_to_uint256(size_arr);',
      '    let (start) = wm_alloc(size256);',
      `    ${funcName}_recursive(start,  start + size_arr${
        isUint ? (isUserDefined ? '' : '* 2') : ''
      }${isUserDefined ? ', arr' : ''});`,
      '    return (start,);',
      '}',
      ' ',
      `func ${funcName}_iterator{range_check_ptr, warp_memory: DictAccess*}(size, column, index${
        isUserDefined ? ', matrix: felt*' : ''
      }){`,
      '    alloc_locals;',
      '    if(index == size){',
      '        return ();',
      '    }',
      `    let (element) = ${funcName}_matrix(column${isUserDefined ? ', matrix' : ''});`,
      `    dict_write{dict_ptr=warp_memory}(index, element);`,
      `    return ${funcName}_iterator(size, column, index+1${
        isUserDefined ? ', matrix+column' : ''
      });`,
      '}',
      '  ',
    ];
  }

  private isUint(type: TypeNode, isMatrix: boolean): boolean {
    let isUint = false;
    if (isMatrix) {
      if (
        ((type as ArrayType).elementT instanceof FixedBytesType &&
          ((type as ArrayType).elementT as FixedBytesType).size === 32) ||
        ((type as ArrayType).elementT instanceof IntType &&
          ((type as ArrayType).elementT as IntType).nBits === 256)
      ) {
        isUint = true;
      }
    } else {
      if (
        (type instanceof FixedBytesType && (type as FixedBytesType).size === 32) ||
        (type instanceof IntType && (type as IntType).nBits === 256)
      ) {
        isUint = true;
      }
    }
    return isUint;
  }

  private getOrCreate(
    type: TypeNode,
    size: number,
    dynamic: boolean,
    isUserDefined: boolean,
    isMatrix: boolean,
    args: string[],
  ): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const funcName = `wm${this.generatedFunctionsDef.size}_${dynamic ? 'dynamic' : 'static'}_array`;
    const isStruct = isMatrix
      ? (type as ArrayType).elementT instanceof UserDefinedType
      : type instanceof UserDefinedType;
    let members: string[] = [];
    if (isStruct) {
      if (isMatrix) {
        (
          ((type as ArrayType).elementT as UserDefinedType).definition as StructDefinition
        ).vMembers.forEach((member) => {
          let memberType = safeGetNodeType(member, this.ast.inference);
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
      isUserDefined && !dynamic ? `row, column, matrix: (${args.join(', ')})` : 'row, column';

    const initializationlist = mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
      .flat()
      .map(
        (name, index) =>
          `    dict_write{dict_ptr=warp_memory}(${add('start', index + 2)}, ${name});`,
      );

    const imports = () => {
      let importList = [
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
        ...(dynamic
          ? []
          : this.recursiveStaticfunction(
              funcName,
              type,
              this.isUint(type, isMatrix),
              isUserDefined,
              isStaticDynamic,
            )),
        isMatrix && !isStaticDynamic
          ? this.matrixExtraFunctions(funcName, this.isUint(type, isMatrix), isUserDefined).join(
              '\n',
            )
          : [],
        ` `,
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${
          dynamic ? argString : isMatrix ? argStaticMatrix : argStatic
        }) -> (loc: felt){`,
        `    alloc_locals;`,
        isMatrix
          ? [
              `    let (size256) = felt_to_uint256(${
                isStaticDynamic ? `row*column${this.isUint(type, isMatrix) ? ` * 2` : ''}` : 'row'
              });`,
              `    let (start) = wm_alloc(size256);`,
              isUserDefined ? '    let (__fp__, _) = get_fp_and_pc();' : '',
              isUserDefined && isStaticDynamic
                ? `    ${funcName}_recursive(start,  start + row*column${
                    this.isUint(type, isMatrix) ? ` * 2` : ''
                  }, cast(&matrix, felt*));`
                : `    ${funcName}_iterator(start + row, column, start${
                    isUserDefined ? ', cast(&matrix, felt*)' : ''
                  });`,
            ].join('\n')
          : [
              dynamic
                ? ``
                : `    let (size256) = felt_to_uint256(size_arr${
                    this.isUint(type, isMatrix) ? ` * 2` : ''
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
                        this.isUint(type, isMatrix) ? (isUserDefined ? '' : ' * 2') : ''
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

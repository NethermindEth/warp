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
    const elementsInfo = this.isUserElements(elements, type);
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

  private isUserElements(
    elements: Expression[],
    type: TypeNode,
  ): {
    userDefined: boolean;
    matrixSize: number;
    matrixL2Size: number;
    args: string[];
    isIdentifier: boolean;
  } {
    const isMatrix =
      type instanceof ArrayType ? (type as ArrayType).elementT instanceof ArrayType : false;
    const is3dMatrix = isMatrix
      ? ((type as ArrayType).elementT as ArrayType).elementT instanceof ArrayType
      : false;
    const elementT = isMatrix
      ? ((type as ArrayType).elementT as ArrayType).elementT
      : (type as ArrayType).elementT;
    let userDefined = false;
    let matrixSize = 0;
    let matrixL2Size = 0;
    let isIdentifier = false;
    const args: string[] = [];
    elements.forEach((ele) => {
      if (elementT instanceof UserDefinedType) {
        userDefined = true;
        if (ele instanceof TupleExpression) {
          let argsRound: string[] = [];
          (ele as TupleExpression).vOriginalComponents.forEach(() => {
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
        isIdentifier = true;
        userDefined = true;
        if (isMatrix) {
          args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? '(Uint256)' : '(felt)');
        } else {
          args.push(this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
        }
      } else if (is3dMatrix) {
        matrixSize = (ele as TupleExpression).vOriginalComponents.length;
        matrixL2Size = ((ele as TupleExpression).vOriginalComponents[0] as TupleExpression)
          .vOriginalComponents.length;
        (ele as TupleExpression).vOriginalComponents.forEach((ele1) => {
          const argsRound: string[] = [];
          (ele1 as TupleExpression).vOriginalComponents.forEach((ele2) => {
            const argsRoundL2: string[] = [];
            (ele2 as FunctionCall).vArguments.forEach((literal) => {
              const value = (literal as Literal).value;

              if (value === '0' || value === 'false' || value === '0x0') {
                argsRoundL2.push(
                  this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                );
              } else {
                argsRoundL2.push(
                  this.isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                );
                userDefined = true;
              }
            });
            argsRound.push(`(${argsRoundL2.join(', ')})`);
          });
          args.push(`(${argsRound.join(', ')})`);
        });
      } else if (isMatrix) {
        if (ele instanceof FunctionCall) {
          let argsRound: string[] = [];
          matrixSize = (ele as FunctionCall).vArguments.length;
          (ele as FunctionCall).vArguments.forEach((e) => {
            const value = (e as Literal).value;

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
    return { userDefined, matrixSize, matrixL2Size, args, isIdentifier };
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

  private struct_initializer(funcName: string, members: string[]): string {
    const feltMembers: string[] = [];
    let memberIndex = 0;
    let arrayIndex = 0;
    const args: string[] = [];
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
    isIdentifier: boolean,
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
          ? isStaticDynamic && !isIdentifier
            ? [
                `    let (arr) = wm_new(Uint256(low=definedArr[0], high=${
                  isUint ? 'definedArr[1]' : '0'
                }), Uint256(low=1, high=0));`,
              ]
            : []
          : ['    let (arr) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));']
        : [],
      `    dict_write{dict_ptr=warp_memory}(index, ${
        isBytesOrString || (isStaticDynamic && !isIdentifier)
          ? 'arr'
          : isUserDefined || isIdentifier
          ? 'definedArr[0]'
          : '0'
      });`,

      isUint && !isStaticDynamic
        ? [
            `    dict_write{dict_ptr=warp_memory}(index + 1, ${
              isUserDefined ? 'definedArr[1]' : '0'
            });`,
          ]
        : [],
      `    return ${funcName}_recursive(index + ${
        isUint && !isStaticDynamic ? '2' : '1'
      }, size_arr${
        isUserDefined ? `, definedArr${isUint && !isStaticDynamic ? '+ 2' : '+ 1'}` : ''
      });`,
      `}`,
    ].flat();
  }

  private matrix3dFunctions(funcName: string, isUint: boolean, isUserDefined: boolean): string[] {
    return [
      '  ',
      `func ${funcName}_3d_matrix{range_check_ptr, warp_memory: DictAccess*}(size_arr, column2${
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
      `func ${funcName}_3d_iterator{range_check_ptr, warp_memory: DictAccess*}(size, column, index${
        isUserDefined ? ', matrix: felt*' : ''
      }){`,
      '    alloc_locals;',
      '    if(index == size){',
      '        return ();',
      '    }',
      `    let (element) = ${funcName}_3d_matrix(size, column${isUserDefined ? ', matrix' : ''});`,
      `    dict_write{dict_ptr=warp_memory}(index, element);`,
      `    return ${funcName}_3d_iterator(size, column, index+1${
        isUserDefined ? ', matrix+column' : ''
      });`,
      '}',
      '  ',
    ];
  }

  private matrixExtraFunctions(
    funcName: string,
    isUint: boolean,
    isUserDefined: boolean,
    is3dMatrix: boolean,
  ): string[] {
    return [
      '  ',
      `func ${funcName}_matrix{range_check_ptr, warp_memory: DictAccess*}(size_arr${
        is3dMatrix ? ', column2' : ''
      }${isUserDefined ? ', arr: felt*' : ''}) -> (loc: felt){`,
      '    alloc_locals;',
      '    let (size256) = felt_to_uint256(size_arr);',
      '    let (start) = wm_alloc(size256);',
      is3dMatrix
        ? `    ${funcName}_3d_iterator(start+ size_arr, column2, start${
            isUserDefined ? ', arr' : ''
          });`
        : `    ${funcName}_recursive(start,  start + size_arr${
            isUint ? (isUserDefined ? '' : '* 2') : ''
          }${isUserDefined ? ', arr' : ''});`,
      '    return (start,);',
      '}',
      ' ',
      `func ${funcName}_iterator{range_check_ptr, warp_memory: DictAccess*}(size, column,${
        is3dMatrix ? 'column2,' : ''
      } index${isUserDefined ? ', matrix: felt*' : ''}){`,
      '    alloc_locals;',
      '    if(index == size){',
      '        return ();',
      '    }',
      `    let (element) = ${funcName}_matrix(column${is3dMatrix ? ', column2' : ''}${
        isUserDefined ? ', matrix' : ''
      });`,
      `    dict_write{dict_ptr=warp_memory}(index, element);`,
      `    return ${funcName}_iterator(size, column${is3dMatrix ? ', column2' : ''}, index+1${
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
        isStruct ? this.struct_initializer(funcName, members) : [],
        ...(dynamic
          ? []
          : this.recursiveStaticfunction(
              funcName,
              type,
              this.isUint(type, isMatrix),
              isUserDefined,
              isStaticDynamic,
              isIdentifier,
            )),
        is3dMatrix
          ? this.matrix3dFunctions(funcName, this.isUint(type, isMatrix), isUserDefined).join('\n')
          : [],
        isMatrix && !isStaticDynamic
          ? this.matrixExtraFunctions(
              funcName,
              this.isUint(type, isMatrix),
              isUserDefined,
              is3dMatrix,
            ).join('\n')
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
                  ? `row*column${this.isUint(type, isMatrix) && !isStaticDynamic ? ` * 2` : ''}`
                  : `row${this.isUint(type, isMatrix) ? '* 2' : ''}`
              });`,
              `    let (start) = wm_alloc(size256);`,
              isUserDefined ? '    let (__fp__, _) = get_fp_and_pc();' : '',
              isStaticDynamic && !isStruct
                ? `    ${funcName}_recursive(start,  start + row*column${
                    this.isUint(type, isMatrix) ? (isStaticDynamic ? '' : ` * 2`) : ''
                  }${!isUserDefined ? '' : ', cast(&matrix, felt*)'});`
                : `    ${funcName}_iterator(start + row${
                    this.isUint(type, isMatrix) ? '* 2' : ''
                  }, column${this.isUint(type, isMatrix) ? '* 2' : ''}${
                    is3dMatrix ? ', column2' : ''
                  }, start${isUserDefined ? ', cast(&matrix, felt*)' : ''});`,
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
                        this.isUint(type, isMatrix) ? ' * 2' : ''
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

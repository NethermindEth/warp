import assert = require('assert');
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  Identifier,
  Literal,
  LiteralKind,
  StringLiteralType,
  StringType,
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

    const funcDef = this.getOrCreateFuncDef(type, size);
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

    const wideSize = getSize(type);
    const size =
      wideSize !== undefined
        ? narrowBigIntSafe(wideSize, `${printNode(node)} too long to process`)
        : elements.length;

    const funcDef = this.getOrCreateFuncDef(type, size, elementsInfo);
    return createCallToFunction(funcDef, elements, this.ast);
  }

  private isUserElements(elements: Expression[], type: TypeNode): {userDefined: boolean, matrixSize: number} {
    const isMatrix = type instanceof ArrayType? (type as ArrayType).elementT instanceof ArrayType: false;
    let userDefined = false;
    let matrixSize = 0;
    elements.forEach((ele) => {
      if (userDefined) {
        return userDefined;
      }
      if (ele instanceof Identifier) {
        userDefined = true;
      }
      if (isMatrix) {
        if (ele instanceof FunctionCall) {
          matrixSize = (ele as FunctionCall).vArguments.length;
          (ele as FunctionCall).vArguments.forEach((e) => {
            let value = (e as Literal).value;

            if (value === '0' || value === 'false' || value === '0x0') {
              userDefined = false;
            } else {
              userDefined = true;
              return userDefined;
            }
          });
        } else {
          if (ele instanceof TupleExpression) {
            matrixSize = (ele as TupleExpression).vOriginalComponents.length;
            (ele as TupleExpression).vOriginalComponents.forEach((e) => {
              if (userDefined) {
                return userDefined;
              }
              if (e instanceof FunctionCall) {
                (e as FunctionCall).vArguments.forEach((e) => {
                  if ((e as Literal).value !== '') {
                    userDefined = true;
                  }
                });
              }
              if (e instanceof Literal) {
                if (
                  (e as Literal).value === '0' ||
                  (e as Literal).value === 'false' ||
                  (e as Literal).value === '0x0'
                ) {
                  userDefined = false;
                } else {
                  userDefined = true;
                  return userDefined;
                }
              }
            });
          }
        }
      } else {
        if (userDefined) {
          return userDefined;
        }
        if (ele instanceof FunctionCall) {
          (ele as FunctionCall).vArguments.forEach((e) => {
            if ((e as Literal).value !== '') {
              userDefined = true;
            }
          });
        } else if (ele instanceof Literal) {
          if (
            (ele as Literal).value === '0' ||
            (ele as Literal).value === 'false' ||
            (ele as Literal).value === '0x0'
          ) {
            userDefined = false;
          } else {
            userDefined = true;
            return userDefined;
          }
        }
      }
    });
    return {userDefined, matrixSize};
  }

  public getOrCreateFuncDef(type: ArrayType | StringType, size: number, elementsInfo: {userDefined: boolean, matrixSize: number}) {
    const baseType = getElementType(type);
    const isMatrix = type instanceof ArrayType && baseType instanceof ArrayType
    const isStruct = isMatrix
      ? baseType.elementT instanceof UserDefinedType
      : baseType instanceof UserDefinedType;
    const key = baseType.pp() + size;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const baseTypeName = typeNameFromTypeNode(baseType, this.ast);
    const funcInfo = this.getOrCreate(
      baseType,
      isMatrix? elementsInfo.matrixSize:size,
      isDynamicArray(type) || type instanceof StringLiteralType,
      elementsInfo.userDefined,
      isMatrix,
      isMatrix? Number(type.size) : 0,
      isStruct
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

  private structToFeltTuple(funcName: string, members: string[]): string{
    let feltMembers: string[] = []; 
    let memberIndex:number = 0;
    let arrayIndex: number = 0;
    let args: string[] = [];
    members.forEach((member) => {
      if (member === 'Uint256') {
        feltMembers.push(`    dict_write{dict_ptr=warp_memory}(start${arrayIndex > 0?`+${arrayIndex}`:''}, member_${memberIndex}.low);`);
        feltMembers.push(`    dict_write{dict_ptr=warp_memory}(start${`+${arrayIndex+1}`}, member_${memberIndex}.high);`);
        arrayIndex = arrayIndex + 2;
        memberIndex = memberIndex + 1;
      } else {
        feltMembers.push(`    dict_write{dict_ptr=warp_memory}(start${arrayIndex > 0?`+${arrayIndex}`:''}, member_${memberIndex});`);
        arrayIndex = arrayIndex + 1;
        memberIndex = memberIndex + 1;
      }
      args.push(`member_${memberIndex-1}: ${member === 'Uint256'? `Uint256`:`felt`}`);
    })
    
    return [
      `func ${funcName}_struct_to_array{range_check_ptr, warp_memory: DictAccess*}(${args.join(', ')}) -> (start: felt){`,
      `    alloc_locals;`,
      `    let (start) = wm_alloc(${uint256(arrayIndex)});`,
      ...feltMembers,
      `    return (start,);`,
      `}`,
    ].flat().join('\n');
  }

  private recursiveStaticfunction(
    funcName: string,
    type: TypeNode,
    isUint: boolean,
    isUserDefined: boolean,
    isStruct: boolean,
    isMatrix: boolean
  ): string[] {
    const isBytesOrString = type instanceof BytesType || type instanceof StringType;
    return [
      `func ${funcName}_recursive{range_check_ptr, warp_memory: DictAccess*}(index, size_arr${
        isUserDefined || isStruct ? `, definedArr: felt*` : ''
      }) {`,
      `    alloc_locals;`,
      `    if (index == size_arr) {`,
      `        return ();`,
      `    }`,
      isBytesOrString
        ? isUserDefined
          ? []
          : ['    let (arr) = wm_new(Uint256(low=0, high=0), Uint256(low=1, high=0));']
        : [],
      isStruct && isMatrix ? [
        `    let (struct_start) = ${funcName}_struct_to_array(definedArr[0]);`
      ] : [],      
      isUint && isUserDefined ? '    let (uint256) = felt_to_uint256(definedArr[0]);' : [],
      `    dict_write{dict_ptr=warp_memory}(index, ${
        isBytesOrString ? 'arr' : isUserDefined ? (isUint ? `uint256.low` : 'definedArr[0]') : isStruct? 'struct_start': '0'
      });`,
      isUint
        ? [
            `    dict_write{dict_ptr=warp_memory}(index + 1, ${
              isUserDefined ? 'uint256.high' : '0'
            });`,
          ]
        : [],
      `    return ${funcName}_recursive(index + ${
        isUint ? (isUserDefined ? '1' : '2') : '1'
      }, size_arr${isUserDefined ? ', definedArr+1' : ''});`,
      `}`,
    ].flat();
  };

  private matrixExtraFunctions(
    funcName: string,
    isUint: boolean,
    isUserDefined: boolean,
  ): string[] {
    return [
      '  ',
      `func ${funcName}_matrix{range_check_ptr, warp_memory: DictAccess*}(size_arr${
        isUserDefined ? ', arr' : ''
      }) -> (loc: felt){`,
      '    alloc_locals;',
      '    let (size256) = felt_to_uint256(size_arr);',
      '    let (start) = wm_alloc(size256);',
      isUserDefined ? '    let (__fp__, _) = get_fp_and_pc();' : '',
      `    ${funcName}_recursive(start,  start + size_arr${
        isUint ? (isUserDefined ? '' : '* 2') : ''
      }${isUserDefined ? ', cast(&arr, felt*)' : ''});`,
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
      `    let (element) = ${funcName}_matrix(column${isUserDefined ? ', matrix[0]' : ''});`,
      `    dict_write{dict_ptr=warp_memory}(index, element);`,
      `    return ${funcName}_iterator(size, column, index+1${isUserDefined ? ', matrix+1' : ''});`,
      '}',
      '  ',
    ];
  }

  private getOrCreate(type: TypeNode, size: number, dynamic: boolean, isUserDefined: boolean, isMatrix: boolean, matrixDimension: number, isStruct: boolean): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const funcName = `wm${this.generatedFunctionsDef.size}_${dynamic ? 'dynamic' : 'static'}_array`;

    let isUint = false;
    if (isMatrix && !isStruct) {
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

    let structMembers: string = '';
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
        structMembers = `(${size === 1? `(${members.join(', ')})`:`(${members.join(', ')}), `.repeat(size-1)+`(${members.join(', ')})`}), `.repeat(matrixDimension-1)+`(${size === 1? `(${members.join(', ')})`:`(${members.join(', ')}), `.repeat(size-1)+`(${members.join(', ')})`})`;
      } else {
        ((type as UserDefinedType).definition as StructDefinition).vMembers.forEach((member) => {
          let memberType = safeGetNodeType(member, this.ast.inference);
          if (memberType instanceof IntType) {
            if ((memberType as IntType).nBits === 256) {
              members.push('Uint256');
            }
          } else {
            members.push('felt');
          }
          structMembers = `${`(${members.join(', ')})`.repeat(size)} `;
        });
      }
    }

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    // If it's dynamic we need to include the length at the start
    const alloc_len = dynamic ? size * elementCairoType.width + 2 : size * elementCairoType.width;
    return {
      name: funcName,
      code: [
        isStruct && isMatrix? this.structToFeltTuple(funcName, members) : [],
        ...(dynamic
          ? []
          : this.recursiveStaticfunction(funcName, type, isUint, userDefinedArgs, isStruct, isMatrix)),
        isMatrix ? this.matrixExtraFunctions(funcName, isUint, userDefinedArgs).join('\n') : [],
        ` `,
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${
          dynamic ? argString : isMatrix ? argStaticMatrix : argStatic
        }) -> (loc: felt){`,
        `    alloc_locals;`,
        isMatrix
          ? [
              '    let (size256) = felt_to_uint256(row);',
              `    let (start) = wm_alloc(${
                isStaticDynamic ? uint256(size * elementCairoType.width + 2) : 'size256'
              });`,
              userDefinedArgs ? '    let (__fp__, _) = get_fp_and_pc();' : '',
              isStaticDynamic
                ? `    wm_write_256{warp_memory=warp_memory}(start, ${uint256(size)});`
                : '',
              `    ${funcName}_iterator(start + row, column, start${
                userDefinedArgs ? ', cast(&matrix, felt*)' : ''
              });`,
            ].join('\n')
          : [
              dynamic
                ? ``
                : `    let (size256) = felt_to_uint256(size_arr${isUint ? ` * 2` : ''});`,
              `    let (start) = wm_alloc(${dynamic ? uint256(alloc_len) : 'size256'});`,
              [
                dynamic
                  ? [`    wm_write_256{warp_memory=warp_memory}(start, ${uint256(size)});`]
                  : [],
                dynamic
                  ? initializationlist.join('\n')
                  : [
                      userDefinedArgs ? '    let (__fp__, _) = get_fp_and_pc();' : [],
                      `    ${funcName}_recursive(start,  start + size_arr${
                        isUint ? (userDefinedArgs ? '' : ' * 2') : ''
                      }${userDefinedArgs ? ', cast(&arr, felt*)' : ''});`,
                    ].join('\n'),
              ].join('\n'),
            ].join('\n'),
        `    return (start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        isUserDefined? this.requireImport('starkware.cairo.common.registers', 'get_fp_and_pc'): _,
        this.requireImport('warplib.memory', 'wm_alloc'),
        this.requireImport('warplib.memory', 'wm_write_256'),
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      ],
    };
  }
}

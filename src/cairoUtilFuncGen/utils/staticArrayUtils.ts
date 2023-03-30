import {
  ArrayType,
  BytesType,
  Expression,
  FixedBytesType,
  FunctionCall,
  Identifier,
  IndexAccess,
  IntType,
  Literal,
  StringType,
  TupleExpression,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { uint256 } from '../../warplib/utils';

export function isUint(type: TypeNode, isMatrix: boolean): boolean {
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

export function struct_initializer(funcName: string, members: string[]): string {
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

export function stringInit(funcName: string): string {
  return [
    `func ${funcName}_string_array_init{range_check_ptr, warp_memory: DictAccess*}(index, str_size, char: felt*) {`,
    `    alloc_locals;`,
    `    if (index == str_size) {`,
    `        return ();`,
    `    }`,
    `    dict_write{dict_ptr=warp_memory}(index, char[0]);`,
    `    return ${funcName}_string_array_init(index + 1, str_size, char+ 1);`,
    `}`,
    ``,
    `func ${funcName}_string_array{range_check_ptr, warp_memory: DictAccess*}(str_size, str: felt*) -> (loc: felt){`,
    `    alloc_locals;`,
    `    let (size256) = felt_to_uint256(str_size);`,
    `    let (start) = wm_alloc(size256);`,
    `    ${funcName}_string_array_init(start,  start + str_size, str);`,
    `    return (start,);`,
    `}`,
  ].join('\n');
}

export function recursiveStaticfunction(
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
        ? isBytesOrString && isUserDefined
          ? 'definedArr[0]'
          : 'arr'
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
    `    return ${funcName}_recursive(index + ${isUint && !isStaticDynamic ? '2' : '1'}, size_arr${
      isUserDefined ? `, definedArr${isUint && !isStaticDynamic ? '+ 2' : '+ 1'}` : ''
    });`,
    `}`,
  ].flat();
}

export function matrix3dFunctions(
  funcName: string,
  isUint: boolean,
  isUserDefined: boolean,
): string[] {
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

export function matrixExtraFunctions(
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

export function isUserElements(
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
        if (((type as ArrayType).elementT as ArrayType).size === undefined) {
          args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
        } else {
          args.push(isUint((type as ArrayType).elementT, isMatrix) ? '(Uint256)' : '(felt)');
        }
      } else {
        args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
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
              argsRoundL2.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
            } else {
              argsRoundL2.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
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
            argsRound.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
          } else {
            argsRound.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
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
                    isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
                  );
                } else {
                  argsRound.push(
                    isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt',
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
                argsRound.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
              } else {
                argsRound.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
                userDefined = true;
              }
            } else if (e instanceof Identifier) {
              userDefined = true;
              argsRound.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
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
            args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
          } else {
            args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
            userDefined = true;
          }
        });
      } else if (ele instanceof Literal) {
        if (
          (ele as Literal).value === '0' ||
          (ele as Literal).value === 'false' ||
          (ele as Literal).value === '0x0'
        ) {
          args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
        } else {
          userDefined = true;
          args.push(isUint((type as ArrayType).elementT, isMatrix) ? 'Uint256' : 'felt');
        }
      } else if (ele instanceof IndexAccess) {
        userDefined = true;
        args.push('felt');
      }
    }
  });
  return { userDefined, matrixSize, matrixL2Size, args, isIdentifier };
}

import assert from 'assert';
import {
  ArrayType,
  ArrayTypeName,
  ASTNode,
  ASTWriter,
  BoolType,
  Expression,
  FunctionCall,
  Identifier,
  InferType,
  IntType,
  Literal,
  SourceUnit,
  StructDefinition,
  StructuredDocumentation,
  TupleExpression,
  TypeNode,
  UserDefinedType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { uint256 } from '../warplib/utils';

export const INDENT = ' '.repeat(4);
export const INCLUDE_CAIRO_DUMP_FUNCTIONS = false;

export function getDocumentation(
  documentation: string | StructuredDocumentation | undefined,
  writer: ASTWriter,
): string {
  return documentation !== undefined
    ? typeof documentation === 'string'
      ? `// ${documentation.split('\n').join('\n//')}`
      : writer.write(documentation)
    : '';
}

export function getInterfaceNameForContract(
  contractName: string,
  nodeInSourceUnit: ASTNode,
  interfaceNameMappings: Map<SourceUnit, Map<string, string>>,
): string {
  const sourceUnit =
    nodeInSourceUnit instanceof SourceUnit
      ? nodeInSourceUnit
      : nodeInSourceUnit.getClosestParentByType(SourceUnit);

  assert(
    sourceUnit !== undefined,
    `Unable to find source unit for interface ${contractName} while writing`,
  );

  const interfaceName = interfaceNameMappings.get(sourceUnit)?.get(contractName);
  assert(
    interfaceName !== undefined,
    `An error occurred during name substitution for the interface ${contractName}`,
  );

  return interfaceName;
}

function getArguments(
  node: VariableDeclarationStatement,
  nodeType: ArrayType,
  inf: InferType,
  funcName: string,
  argsLen: number,
): { args: string; isStringArray: boolean; structInitCalls: string[]; stringInitCalls: string[] } {
  const elementT =
    (nodeType as ArrayType).elementT instanceof ArrayType
      ? ((nodeType as ArrayType).elementT as ArrayType).elementT
      : (nodeType as ArrayType).elementT;
  const argumentList: string[] = [];
  let valuesAreDefault = true;
  let isStructMatrix = false;
  const structInitCalls: string[] = [];
  let isStringArray = false;
  const stringInitCalls: string[] = [];
  if (elementT instanceof ArrayType) {
    (node.vInitialValue as FunctionCall).vArguments.forEach((element) => {
      const argsRound: string[] = [];
      (element as TupleExpression).vOriginalComponents.forEach((ele1) => {
        const argsRoundL2: string[] = [];
        (ele1 as TupleExpression).vOriginalComponents.forEach((literal) => {
          const value = (literal as Literal).value;
          const isUint256 =
            (elementT as ArrayType).elementT instanceof IntType
              ? ((elementT as ArrayType).elementT as IntType).nBits === 256
              : false;

          if (value === '0' || value === 'false' || value === '0x0') {
            argsRoundL2.push(isUint256 ? uint256(BigInt(value)) : value);
          } else {
            argsRoundL2.push(isUint256 ? uint256(BigInt(value)) : value);
            valuesAreDefault = false;
          }
        });
        argsRound.push(
          `(${argsRoundL2.join(', ')}${
            (ele1 as TupleExpression).vOriginalComponents.length === 1 ? ',' : ''
          })`,
        );
      });
      argumentList.push(
        `(${argsRound.join(', ')}${
          (element as TupleExpression).vOriginalComponents.length === 1 ? ',' : ''
        })`,
      );
    });
    let args = valuesAreDefault
      ? ''
      : `, (${argumentList.join('), (')}${argumentList.length === 1 ? ',' : ''})`;
    return { args, isStringArray, structInitCalls, stringInitCalls };
  }
  // in case of matrix
  else if (
    ((nodeType as ArrayType).elementT instanceof ArrayType ||
      (nodeType as ArrayType).elementT instanceof UserDefinedType) &&
    node.vInitialValue instanceof FunctionCall &&
    !(node.vInitialValue instanceof Identifier) &&
    argsLen !== 1
  ) {
    let isStringArray = false;
    if ((node.vInitialValue as FunctionCall)?.vArguments[0] instanceof TupleExpression) {
      let argRound: string[] = [];
      (node.vInitialValue as FunctionCall).vArguments?.forEach((element, index) => {
        const single = (node.vInitialValue as FunctionCall).vArguments.length === 1;
        if (elementT instanceof UserDefinedType) {
          valuesAreDefault = false;
          isStructMatrix = true;
          let structElements: string[] = [];
          const structInputArgs: string[] = [];
          let argRound: string[] = [];

          (element as TupleExpression).vOriginalComponents.forEach((ele, ind) => {
            argRound.push(`${funcName}_struct_${index}x${ind}`);
            (ele as FunctionCall).vArguments.forEach((e, i) => {
              let value = '';
              if (e instanceof FunctionCall) {
                value = ((e as FunctionCall).vArguments[0] as Literal).value;
              } else if (e instanceof Literal) {
                value = (e as Literal).value;
              }

              const eleType = safeGetNodeType(
                ((elementT as UserDefinedType).definition as StructDefinition).vMembers[i],
                inf,
              );
              if (value === '') {
                structElements.push(`0x0${single ? ',' : ''}`);
              } else if (value === '0') {
                structElements.push(
                  `${(eleType as IntType).nBits === 256 ? uint256(BigInt(value)) : value}${
                    single ? ',' : ''
                  }`,
                );
              } else if (value === '0x0') {
                structElements.push(`0x0${single ? ',' : ''}`);
              } else if (value === 'false') {
                structElements.push(`0${single ? ',' : ''}`);
              } else {
                try {
                  const type = typeof JSON.parse(value);
                  if (type === 'number') {
                    structElements.push(
                      `${(eleType as IntType).nBits === 256 ? uint256(BigInt(value)) : value}${
                        single ? ',' : ''
                      }`,
                    );
                  } else if (type === 'boolean') {
                    structElements.push(`1${single ? ',' : ''}`);
                  }
                } catch (error) {
                  if (value.includes('0x')) {
                    structElements.push(`${value}${single ? ',' : ''}`);
                  } else {
                    structElements.push(
                      `${((element as FunctionCall)?.vArguments[0] as Literal).hexValue}${
                        single ? ',' : ''
                      }`,
                    );
                  }
                }
              }
            });
            structInputArgs.push(`${structElements}`);
            structElements = [];
          });

          argRound.forEach((arg, index) => {
            structInitCalls.push(
              `let (${arg}) = ${funcName}_struct_init(${structInputArgs[index]});`,
            );
          });
          argumentList.push(argRound.join(', '));
          argRound = [];
        }
        // bool type
        else if (elementT instanceof BoolType) {
          (element as TupleExpression).vComponents?.forEach((ele) => {
            if (ele instanceof Identifier) {
              argRound.push((element as Identifier).name + `${single ? ',' : ''}`);
              valuesAreDefault = false;
            } else {
              if ((ele as Literal).value !== 'false') {
                valuesAreDefault = false;
              }
              argRound.push(
                (ele as Literal).value === 'false'
                  ? `0${single ? ',' : ''}`
                  : `1${single ? ',' : ''}`,
              );
            }
          });
          argumentList.push(argRound.join(', '));
          argRound = [];
        }
        // string type
        else if (
          (elementT as ArrayType).elementT instanceof IntType &&
          ((element as TupleExpression)?.vComponents[0] as Literal)?.kind === 'string'
        ) {
          (element as TupleExpression).vComponents?.forEach((ele) => {
            if (ele instanceof Identifier) {
              argRound.push((element as Identifier).name + `${single ? ',' : ''}`);
              valuesAreDefault = false;
            } else {
              if ((ele as Literal).value !== '') {
                valuesAreDefault = false;
              }
              argRound.push(
                (ele as Literal).value !== ''
                  ? '0x' + (ele as Literal).hexValue + `${single ? ',' : ''}`
                  : `0x0${single ? ',' : ''}`,
              );
            }
          });
          argumentList.push(argRound.join(', '));
          argRound = [];
        }
        // bytes type
        else if (
          (elementT as ArrayType).elementT instanceof IntType &&
          (element as TupleExpression)?.vComponents[0] instanceof FunctionCall
        ) {
          (element as TupleExpression).vComponents?.forEach((ele) => {
            if (ele instanceof Identifier) {
              argRound.push((element as Identifier).name + `${single ? ',' : ''}`);
              valuesAreDefault = false;
            } else {
              if (((ele as FunctionCall).vArguments[0] as Literal).value !== '0') {
                valuesAreDefault = false;
              }
              argRound.push(
                ((ele as FunctionCall).vArguments[0] as Literal).value !== '0'
                  ? ((ele as FunctionCall).vArguments[0] as Literal).value + `${single ? ',' : ''}`
                  : `0x0${single ? ',' : ''}`,
              );
            }
          });
          argumentList.push(argRound.join(', '));
          argRound = [];
        } else if (elementT instanceof IntType) {
          (element as TupleExpression).vComponents?.forEach((ele) => {
            if (ele instanceof Identifier) {
              argRound.push((ele as Identifier).name + `${single ? ',' : ''}`);
              valuesAreDefault = false;
            } else {
              if ((ele as Literal).value !== '0') {
                valuesAreDefault = false;
              }
              argRound.push(
                (elementT as IntType).nBits === 256
                  ? uint256(BigInt((ele as Literal).value)) + `${single ? ',' : ''}`
                  : (ele as Literal).value + `${single ? ',' : ''}`,
              );
            }
          });
          argumentList.push(argRound.join(', '));
          argRound = [];
        }
      });
    } else if (elementT instanceof UserDefinedType) {
      valuesAreDefault = false;
      let argRound: string[] = [];
      const isSingle =
        ((node as VariableDeclarationStatement).vInitialValue as FunctionCall).vArguments.length ===
        1;
      ((node as VariableDeclarationStatement).vInitialValue as FunctionCall).vArguments.forEach(
        (ele) => {
          argRound.push(`${(ele as Identifier).name}${isSingle ? ',' : ''}`);
        },
      );
      argumentList.push(argRound.join(', '));
      argRound = [];
    } else {
      let argRound: string[] = [];

      (node.vInitialValue as FunctionCall).vArguments?.forEach((element) => {
        if (element instanceof Identifier) {
          argRound.push((element as Identifier).name + ',');
          valuesAreDefault = false;
        } else {
          if (element instanceof Literal) {
            isStringArray = true;
            const value = (element as Literal).value;
            if (value === '') {
              argRound.push(`0x0`);
            } else if (value === '0') {
              argRound.push(
                `${(elementT as IntType).nBits === 256 ? uint256(BigInt(value)) : value}`,
              );
            } else if (value === '0x0') {
              argRound.push(`0x0`);
            } else if (value === 'false') {
              argRound.push(`0`);
            } else {
              valuesAreDefault = false;

              try {
                const type = typeof JSON.parse(value);
                if (type === 'number') {
                  argRound.push(
                    `${(elementT as IntType).nBits === 256 ? uint256(BigInt(value)) : value}`,
                  );
                } else if (type === 'boolean') {
                  argRound.push(`1`);
                }
              } catch (error) {
                if (value.includes('0x')) {
                  argRound.push(`${value}`);
                } else {
                  argRound.push(`0x${(element as Literal).hexValue}`);
                }
              }
            }
          } else if (element instanceof FunctionCall) {
            const single = (element as FunctionCall)?.vArguments.length === 1;
            (element as FunctionCall)?.vArguments?.forEach((ele) => {
              const value = (ele as Literal).value;
              if (value === '') {
                argRound.push(`0x0${single ? ',' : ''}`);
              } else if (value === '0') {
                argRound.push(
                  `${(elementT as IntType).nBits === 256 ? uint256(BigInt(value)) : value}${
                    single ? ',' : ''
                  }`,
                );
              } else if (value === '0x0') {
                argRound.push(`0x0${single ? ',' : ''}`);
              } else if (value === 'false') {
                argRound.push(`0${single ? ',' : ''}`);
              } else {
                valuesAreDefault = false;

                try {
                  const type = typeof JSON.parse(value);
                  if (type === 'number') {
                    argRound.push(
                      `${(elementT as IntType).nBits === 256 ? uint256(BigInt(value)) : value}${
                        single ? ',' : ''
                      }`,
                    );
                  } else if (type === 'boolean') {
                    argRound.push(`1${single ? ',' : ''}`);
                  }
                } catch (error) {
                  if (value.includes('0x')) {
                    argRound.push(`${value}${single ? ',' : ''}`);
                  } else {
                    argRound.push(
                      `0x${((element as FunctionCall)?.vArguments[0] as Literal).hexValue}${
                        single ? ',' : ''
                      }`,
                    );
                  }
                }
              }
            });
          }
        }

        argumentList.push(argRound.join(', '));
        argRound = [];
      });
    }

    let args = valuesAreDefault
      ? ''
      : isStringArray
      ? `, (${argumentList.join(', ')})`
      : elementT instanceof UserDefinedType && !isStructMatrix
      ? `, (${argumentList.join('), (')})`
      : `, ((${argumentList.join('), (')}))`;
    return { args, isStringArray, structInitCalls, stringInitCalls };
  } else {
    // in case of array
    // bool type

    if (!(node.vInitialValue instanceof Identifier)) {
      const single = (node.vInitialValue as FunctionCall).vArguments.length === 1;
      if (elementT instanceof UserDefinedType) {
        valuesAreDefault = false;
        (node.vInitialValue as FunctionCall).vArguments.forEach((element) => {
          argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
        });
      }
      if (elementT instanceof BoolType) {
        (node.vInitialValue as FunctionCall).vArguments?.forEach((element) => {
          if (element instanceof Identifier) {
            argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
            valuesAreDefault = false;
          } else {
            if ((element as Literal).value !== 'false') {
              valuesAreDefault = false;
            }
            argumentList.push(
              (element as Literal).value === 'false'
                ? `0${single ? ',' : ''}`
                : `1${single ? ',' : ''}`,
            );
          }
        });
      }
      // string type
      else if (
        elementT instanceof IntType &&
        (((node.vInitialValue as FunctionCall)?.vArguments[0] as Literal)?.kind === 'string' ||
          ((node.vInitialValue as FunctionCall)?.vArguments[0] instanceof Identifier &&
            (elementT as IntType)?.nBits === 8))
      ) {
        (node.vInitialValue as FunctionCall).vArguments?.forEach((element, index) => {
          if (element instanceof Identifier) {
            argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
            valuesAreDefault = false;
          } else {
            const value = (element as Literal).value;
            const chars = value.split('');
            const stringArray: string[] = [];
            if (value !== '') {
              isStringArray = true;
              const call = `${funcName}_string_${index}`;
              valuesAreDefault = false;
              stringArray.push('0x' + chars.length.toString(16));
              stringArray.push('0x0');
              chars.forEach((char) => {
                stringArray.push(`${char.charCodeAt(0)}`);
              });
              const str_elements: string[] = [];
              const str_values: string[] = [];
              stringArray.forEach((_, index) => {
                str_elements.push(`e_${index}: felt`);
                str_values.push(`e_${index}= ${stringArray[index]}`);
              });
              stringInitCalls.push(
                [
                  `local str_${index}: (${str_elements.join(', ')}) = (${stringArray.join(', ')});`,
                  `let (${call}) = ${funcName}_string_array(${
                    chars.length + 2
                  } ,cast(&str_${index}, felt*));`,
                ].join('\n'),
              );
              argumentList.push(`${call}${single ? ',' : ''}`);
            } else {
              argumentList.push(`0x0${single ? ',' : ''}`);
            }
          }
        });
      }
      // bytes type
      else if (
        elementT instanceof IntType &&
        (node.vInitialValue as FunctionCall)?.vArguments[0] instanceof FunctionCall
      ) {
        (node.vInitialValue as FunctionCall).vArguments?.forEach((element) => {
          if (element instanceof Identifier) {
            argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
            valuesAreDefault = false;
          } else {
            if (((element as FunctionCall).vArguments[0] as Literal).value !== '0') {
              valuesAreDefault = false;
            }
            argumentList.push(
              ((element as FunctionCall).vArguments[0] as Literal).value !== '0'
                ? ((element as FunctionCall).vArguments[0] as Literal).value +
                    `${single ? ',' : ''}`
                : `0x0${single ? ',' : ''}`,
            );
          }
        });
      }
      // bytesX/int/uint types
      else if (elementT instanceof IntType) {
        (node.vInitialValue as FunctionCall).vArguments?.forEach((element) => {
          if (element instanceof Identifier) {
            argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
            valuesAreDefault = false;
          } else {
            if ((element as Literal).value !== '0') {
              if ((element as Literal).value !== '0x0') {
                valuesAreDefault = false;
              }
            }
            argumentList.push(
              (elementT as IntType).nBits === 256
                ? uint256(BigInt((element as Literal).value)) + `${single ? ',' : ''}`
                : (element as Literal).value + `${single ? ',' : ''}`,
            );
          }
        });
      }
    }
    let args = valuesAreDefault ? '' : `, (${argumentList.join(', ')})`;
    return { args, isStringArray, structInitCalls, stringInitCalls };
  }
}

export function getStaticArrayCallInfo(
  node: VariableDeclarationStatement,
  nodeType: ArrayType,
  inf: InferType,
  funcName: string,
): {
  staticArrayCall: string;
  isStringArray: boolean;
  structInitCalls: string[];
  stringInitCalls: string[];
} {
  const isBytes =
    node.vInitialValue instanceof Identifier
      ? false
      : (node.vInitialValue as FunctionCall)?.vArguments[0] instanceof FunctionCall
      ? (nodeType.elementT as ArrayType).elementT instanceof ArrayType
        ? true
        : false
      : false;
  const isString =
    node.vInitialValue instanceof Identifier
      ? false
      : ((node.vInitialValue as FunctionCall)?.vArguments[0] as Literal).kind === 'string'
      ? true
      : false;
  const isMatrix = (nodeType as ArrayType).elementT instanceof ArrayType;
  const is3dMatrix = isMatrix
    ? ((nodeType as ArrayType).elementT as ArrayType).elementT instanceof ArrayType
    : false;
  let staticArrayCall = '';
  if (is3dMatrix && !isString && !isBytes) {
    const argsInfo = getArguments(node, nodeType, inf, funcName, 3);
    staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}, ${Number(
      ((nodeType as ArrayType).elementT as ArrayType).size,
    )}, ${Number((((nodeType as ArrayType).elementT as ArrayType).elementT as ArrayType).size)}${
      argsInfo.args
    })`;
    const isStringArray = argsInfo.isStringArray;
    const structInitCalls = argsInfo.structInitCalls;
    const stringInitCalls = argsInfo.stringInitCalls;
    return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
  } else if (isMatrix && !isString && !isBytes) {
    if (((nodeType as ArrayType).elementT as ArrayType).size !== undefined) {
      let argsInfo = getArguments(node, nodeType, inf, funcName, 2);
      staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}, ${Number(
        ((nodeType as ArrayType).elementT as ArrayType).size,
      )}${argsInfo.args})`;
      const isStringArray = argsInfo.isStringArray;
      const structInitCalls = argsInfo.structInitCalls;
      const stringInitCalls = argsInfo.stringInitCalls;
      return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
    } else {
      if ((node.vInitialValue as FunctionCall).vArguments[0] instanceof Identifier) {
        let argsInfo = getArguments(node, nodeType, inf, funcName, 1);
        staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}${argsInfo.args})`;
        const isStringArray = argsInfo.isStringArray;
        const structInitCalls = argsInfo.structInitCalls;
        const stringInitCalls = argsInfo.stringInitCalls;
        return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
      } else {
        let argsInfo = getArguments(node, nodeType, inf, funcName, 2);
        staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}, ${
          ((node.vInitialValue as FunctionCall).vArguments[0] as FunctionCall).vArguments.length
        }${argsInfo.args})`;
        const isStringArray = argsInfo.isStringArray;
        const structInitCalls = argsInfo.structInitCalls;
        const stringInitCalls = argsInfo.stringInitCalls;
        return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
      }
    }
  } else {
    if ((node.vDeclarations[0].vType as ArrayTypeName).vLength instanceof Literal) {
      let argsInfo = getArguments(node, nodeType, inf, funcName, 1);
      staticArrayCall = `${funcName}(${
        ((node.vDeclarations[0].vType as ArrayTypeName).vLength as Literal).value
      }${argsInfo.args})`;
      const isStringArray = argsInfo.isStringArray;
      const structInitCalls = argsInfo.structInitCalls;
      const stringInitCalls = argsInfo.stringInitCalls;
      return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
    } else {
      let argsInfo = getArguments(node, nodeType, inf, funcName, 1);
      staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}${argsInfo.args})`;
      const isStringArray = argsInfo.isStringArray;
      const structInitCalls = argsInfo.structInitCalls;
      const stringInitCalls = argsInfo.stringInitCalls;
      return { staticArrayCall, isStringArray, structInitCalls, stringInitCalls };
    }
  }
}

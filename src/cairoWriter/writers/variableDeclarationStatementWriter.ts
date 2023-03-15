import assert from 'assert';
import {
  ArrayType,
  ASTWriter,
  BoolType,
  DataLocation,
  FunctionCall,
  generalizeType,
  Identifier,
  IntType,
  Literal,
  SrcDesc,
  StructDefinition,
  TupleExpression,
  TupleType,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { TranspileFailedError } from '../../utils/errors';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternalCall } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class VariableDeclarationStatementWriter extends CairoASTNodeWriter {
  gapVarCounter = 0;
  writeInner(node: VariableDeclarationStatement, writer: ASTWriter): SrcDesc {
    assert(
      node.vInitialValue !== undefined,
      'Variables should be initialised. Did you use VariableDeclarationInitialiser?',
    );

    const documentation = getDocumentation(node.documentation, writer);
    const initialValueType = safeGetNodeType(node.vInitialValue, this.ast.inference);

    const getValueN = (n: number): TypeNode => {
      if (initialValueType instanceof TupleType) {
        return initialValueType.elements[n];
      } else if (n === 0) return initialValueType;
      throw new TranspileFailedError(
        `Attempted to extract value at index ${n} of non-tuple return`,
      );
    };

    const getDeclarationForId = (id: number): VariableDeclaration => {
      const declaration = node.vDeclarations.find((decl) => decl.id === id);
      assert(declaration !== undefined, `Unable to find variable declaration for assignment ${id}`);
      return declaration;
    };

    let isStaticArray = false;
    let staticArrayCall = '';

    const nodeType = generalizeType(getValueN(0))[0];

    const funcName = (node.vInitialValue as FunctionCall).vFunctionName;

    let valuesAreDefault = true;
    let isStructMatrix = false;
    let structInitCalls: string[] = [];

    const getArguments = (): string => {
      const elementT =
        (nodeType as ArrayType).elementT instanceof ArrayType
          ? ((nodeType as ArrayType).elementT as ArrayType).elementT
          : (nodeType as ArrayType).elementT;
      let argumentList: string[] = [];
      // in case of matrix
      if (
        ((nodeType as ArrayType).elementT instanceof ArrayType ||
          (nodeType as ArrayType).elementT instanceof UserDefinedType) &&
        node.vInitialValue instanceof FunctionCall &&
        !(node.vInitialValue instanceof Identifier)
      ) {
        if ((node.vInitialValue as FunctionCall)?.vArguments[0] instanceof TupleExpression) {
          let argRound: string[] = [];
          (node.vInitialValue as FunctionCall).vArguments?.forEach((element, index) => {
            let single = (node.vInitialValue as FunctionCall).vArguments.length === 1;
            if (elementT instanceof UserDefinedType) {
              valuesAreDefault = false;
              isStructMatrix = true;
              let structElements: string[] = [];
              let structInputArgs: string[] = [];
              let argRound: string[] = [];

              (element as TupleExpression).vOriginalComponents.forEach((ele, ind) => {
                argRound.push(`${funcName}_struct_${index}x${ind}`);
                (ele as FunctionCall).vArguments.forEach((e, i) => {
                  let value: string = '';
                  if (e instanceof FunctionCall) {
                    value = ((e as FunctionCall).vArguments[0] as Literal).value;
                  } else if (e instanceof Literal) {
                    value = (e as Literal).value;
                  }

                  let eleType = safeGetNodeType(
                    ((elementT as UserDefinedType).definition as StructDefinition).vMembers[i],
                    this.ast.inference,
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
                      let type = typeof JSON.parse(value);
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
            if (elementT instanceof BoolType) {
              (element as TupleExpression).vComponents?.forEach((ele) => {
                if (ele instanceof Identifier) {
                  argRound.push((element as Identifier).name + `${single ? ',' : ''}`);
                  valuesAreDefault = false;
                } else {
                  if ((ele as Literal).value !== 'false') {
                    valuesAreDefault = false;
                  }
                  argRound.push(
                    (ele as Literal).value == 'false'
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
                      ? ((ele as FunctionCall).vArguments[0] as Literal).value +
                          `${single ? ',' : ''}`
                      : `0x0${single ? ',' : ''}`,
                  );
                }
              });
              argumentList.push(argRound.join(', '));
              argRound = [];
            } else if (elementT instanceof IntType) {
              (element as TupleExpression).vComponents?.forEach((ele) => {
                if (ele instanceof Identifier) {
                  argRound.push((element as Identifier).name + `${single ? ',' : ''}`);
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
          ((node as VariableDeclarationStatement).vInitialValue as FunctionCall).vArguments.forEach(
            (ele) => {
              argRound.push(`${(ele as Identifier).name}`);
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
              let single = (element as FunctionCall)?.vArguments.length === 1;
              (element as FunctionCall)?.vArguments?.forEach((ele) => {
                let value = (ele as Literal).value;
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
                    let type = typeof JSON.parse(value);
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
                        `${((element as FunctionCall)?.vArguments[0] as Literal).hexValue}${
                          single ? ',' : ''
                        }`,
                      );
                    }
                  }
                }
              });
            }

            argumentList.push(argRound.join(', '));
            argRound = [];
          });
        }

        return valuesAreDefault
          ? ''
          : elementT instanceof UserDefinedType && !isStructMatrix
          ? `, (${argumentList.join('), (')})`
          : `, ((${argumentList.join('), (')}))`;
      } else {
        // in case of array
        // bool type

        if (!(node.vInitialValue instanceof Identifier)) {
          let single = (node.vInitialValue as FunctionCall).vArguments.length === 1;
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
                  (element as Literal).value == 'false'
                    ? `0${single ? ',' : ''}`
                    : `1${single ? ',' : ''}`,
                );
              }
            });
          }
          // string type
          else if (
            elementT instanceof IntType &&
            ((node.vInitialValue as FunctionCall)?.vArguments[0] as Literal)?.kind === 'string'
          ) {
            (node.vInitialValue as FunctionCall).vArguments?.forEach((element) => {
              if (element instanceof Identifier) {
                argumentList.push((element as Identifier).name + `${single ? ',' : ''}`);
                valuesAreDefault = false;
              } else {
                if ((element as Literal).value !== '') {
                  valuesAreDefault = false;
                }
                argumentList.push('0x' + (element as Literal).hexValue + `${single ? ',' : ''}`);
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
        return valuesAreDefault ? '' : `, (${argumentList.join(', ')})`;
      }
    };

    if (
      nodeType instanceof ArrayType &&
      (nodeType as ArrayType).size !== undefined &&
      funcName?.includes('static_array') &&
      !funcName?.includes('calldata') &&
      !funcName?.includes('memory') &&
      !funcName?.includes('storage')
    ) {
      isStaticArray = true;
      let isBytes =
        node.vInitialValue instanceof Identifier
          ? false
          : (node.vInitialValue as FunctionCall)?.vArguments[0] instanceof FunctionCall
          ? (nodeType.elementT as ArrayType).elementT instanceof ArrayType
            ? true
            : false
          : false;
      let isString =
        node.vInitialValue instanceof Identifier
          ? false
          : ((node.vInitialValue as FunctionCall)?.vArguments[0] as Literal).kind === 'string'
          ? true
          : false;
      if ((nodeType as ArrayType).elementT instanceof ArrayType && !isString && !isBytes) {
        if (((nodeType as ArrayType).elementT as ArrayType).size !== undefined) {
          staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}, ${Number(
            ((nodeType as ArrayType).elementT as ArrayType).size,
          )}${getArguments()})`;
        } else {
          staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}, ${Number(
            (nodeType as ArrayType).size,
          )}${getArguments()})`;
        }
      } else {
        staticArrayCall = `${funcName}(${Number((nodeType as ArrayType).size)}${getArguments()})`;
      }
    }

    const declarations = node.assignments.flatMap((id, index) => {
      const type = generalizeType(getValueN(index))[0];
      if (
        isDynamicArray(type) &&
        node.vInitialValue instanceof FunctionCall &&
        isExternalCall(node.vInitialValue)
      ) {
        if (id === null) {
          const uniqueSuffix = this.gapVarCounter++;
          return [`__warp_gv_len${uniqueSuffix}`, `__warp_gv${uniqueSuffix}`];
        }
        const declaration = getDeclarationForId(id);
        assert(
          declaration.storageLocation === DataLocation.CallData,
          `WARNING: declaration receiving calldata dynarray has location ${declaration.storageLocation}`,
        );
        const writtenVar = writer.write(declaration);
        return [`${writtenVar}_len`, writtenVar];
      } else {
        if (id === null) {
          return [`__warp_gv${this.gapVarCounter++}`];
        }
        return [writer.write(getDeclarationForId(id))];
      }
    });
    if (
      node.vInitialValue instanceof FunctionCall &&
      node.vInitialValue.vReferencedDeclaration instanceof CairoFunctionDefinition &&
      node.vInitialValue.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub
    ) {
      // This local statement is needed since Cairo is not supporting member access of structs with let.
      // The type hint also needs to be placed there since Cairo's default type hint is a felt.
      return [
        [
          documentation,
          `local ${declarations.join(', ')} : ${
            node.vInitialValue.vReferencedDeclaration.name
          } = ${writer.write(node.vInitialValue)};`,
        ].join('\n'),
      ];
    } else if (declarations.length > 1 || node.vInitialValue instanceof FunctionCall) {
      return [
        [
          documentation,
          structInitCalls.join('\n'),
          `let (${declarations.join(', ')}) = ${
            isStaticArray ? staticArrayCall : writer.write(node.vInitialValue)
          };`,
        ].join('\n'),
      ];
    }
    return [
      [documentation, `let ${declarations[0]} = ${writer.write(node.vInitialValue)};`].join('\n'),
    ];
  }
}

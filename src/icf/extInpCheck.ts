import { assert } from 'console';
import { StructAbiItemType } from './abiTypes';
import { INDENT } from './genCairo';
import { hashType, tupleParser } from './utils';

export function externalInputCheckStatement(
  input: string,
  type: string,
  expInpFunctionsMap: Map<string, string>,
  typeToStruct?: Map<string, StructAbiItemType>,
  structTuplesMap?: Map<string, StructAbiItemType>,
): string {
  if (type === 'Uint256') return `${INDENT}warp_external_input_check_int256(${input});`;
  if (type.endsWith('*')) {
    const funcName = `external_input_check_${hashType(type)}`;
    expInpFunctionsMap.set(
      type,
      [
        `func ${funcName}{range_check_ptr : felt}(len: felt, ptr: ${type}) -> (){`,
        `${INDENT}alloc_locals;`,
        `${INDENT}if (len == 0){`,
        `${INDENT}    return ();`,
        `${INDENT}}`,
        externalInputCheckStatement(
          `ptr[0]`,
          type.slice(0, -1),
          expInpFunctionsMap,
          typeToStruct,
          structTuplesMap,
        ),
        `${INDENT}${funcName}(len = len - 1, ptr = ptr + 1);`,
        `${INDENT}return ();`,
        '}',
      ].join('\n'),
    );
    return `${INDENT}${funcName}(${input}_len, ${input});`;
  }
  if (typeToStruct?.has(type) || structTuplesMap?.has(type)) {
    const funcName = `external_input_check_${hashType(type)}`;
    const struct = typeToStruct?.get(type) ?? structTuplesMap?.get(type);
    expInpFunctionsMap.set(
      type,
      [
        `func ${funcName}{range_check_ptr : felt}(arg: ${type}) -> (){`,
        `${INDENT}alloc_locals;`,
        ...(struct?.members.map((member) => {
          return externalInputCheckStatement(
            `arg.${member.name}`,
            member.type,
            expInpFunctionsMap,
            typeToStruct,
            structTuplesMap,
          );
        }) ?? []),
        `${INDENT}return ();`,
        '}',
      ].join('\n'),
    );
    return `${INDENT}${funcName}(${input});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = tupleParser(type);
    if (subTypes.every((subType) => subType === subTypes[0])) {
      const ret = subTypes.map((subType, index) =>
        externalInputCheckStatement(
          `${input}[${index}]`,
          subType,
          expInpFunctionsMap,
          typeToStruct,
          structTuplesMap,
        ),
      );
      return ret.join('\n');
    }
    throw new Error('Heterogeneous tuples are should be wrapped in a struct');
  }
  assert(type === 'felt', `Unknown type for external Input Check: ${type}`);
  return ';';
}

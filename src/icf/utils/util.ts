import { AbiItemType, StructAbiItemType } from '../abiTypes';
import keccak from 'keccak';
import { INDENT } from '../genCairo';

export function stringfyStructs(structs: StructAbiItemType[]): string[] {
  return structs
    .filter((item: AbiItemType) => item.name !== 'u256')
    .map((item: StructAbiItemType) => {
      return [
        `struct ${item.name} {`,
        ...item.members.map((member: { name: string; type: string }) => {
          return `${INDENT}${member.name}: ${member.type},`;
        }),
        '}',
      ].join('\n');
    });
}

export function transformType(
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  structToAdd?: Map<string, StructAbiItemType>,
): string {
  type = type.trim();
  if (type === 'felt') return 'u256';
  if (typeToStruct.has(type)) return `${type}_uint256`;
  if (type.endsWith('*')) {
    return `${transformType(type.slice(0, -1), typeToStruct, structToAdd)}*`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = tupleParser(type);
    if (subTypes.every((subType) => subType === subTypes[0])) {
      const ret = `(${subTypes
        .map((subType) => transformType(subType, typeToStruct, structToAdd))
        .join(',')})`;
      return ret;
    }
    const structName = `struct_${hashType(type)}`;
    if (structToAdd !== undefined) {
      structToAdd.set(type, {
        name: structName,
        type: 'struct',
        members: subTypes.map((subType, index) => ({
          name: `member_${index}`,
          type: transformType(subType, typeToStruct, structToAdd),
        })),
      });
    }
    return structName;
  }
  return type;
}

export function castStatement(
  lvar: string,
  rvar: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  addedStruct?: Map<string, StructAbiItemType>,
): string {
  type = type.trim();
  if (type === 'felt') return `${INDENT}let (${lvar}) = narrow_safe(${rvar});`;
  if (typeToStruct.has(type)) return `${INDENT}let (${lvar}) = ${type}_cast(${rvar});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${lvar} = cast(${rvar}, ${type});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = tupleParser(type);
    const castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(
        castStatement(
          `${lvar}_${i}`,
          addedStruct?.has(type) ? `${rvar}.member_${i}` : `${rvar}[${i}]`,
          subTypes[i],
          typeToStruct,
          addedStruct,
        ),
      );
    }
    castBody.push(`${INDENT}let ${lvar} = (${subTypes.map((_, i) => `${lvar}_${i}`).join(',')});`);
    return castBody.join('\n');
  }
  return `${INDENT}let ${lvar} = ${rvar};`;
}

export function reverseCastStatement(
  lvar: string,
  rvar: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  addedStruct?: Map<string, StructAbiItemType>,
): string {
  type = type.trim();
  if (type === 'felt') return `${INDENT}let (${lvar}) = felt_to_uint256(${rvar});`;
  if (typeToStruct.has(type)) return `${INDENT}let (${lvar}) = ${type}_cast_reverse(${rvar});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${lvar} = cast(${rvar}, ${transformType(type, typeToStruct)});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = tupleParser(type);
    const castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(
        reverseCastStatement(
          `${lvar}_${i}`,
          `${rvar}[${i}]`,
          subTypes[i],
          typeToStruct,
          addedStruct,
        ),
      );
    }
    castBody.push(
      `${INDENT}let ${lvar} = ${addedStruct?.has(type) ? `struct_${hashType(type)}` : ``}(${subTypes
        .map((_, i) => `${lvar}_${i}`)
        .join(',')});`,
    );
    return castBody.join('\n');
  }
  return `${INDENT}let ${lvar} = ${rvar};`;
}

export function tupleParser(tuple: string): string[] {
  if (tuple.startsWith('(') && tuple.endsWith(')')) tuple = tuple.slice(1, -1).trim();
  tuple = tuple + ',';
  const subTypes: string[] = [];
  let start = 0;
  let end = 0;
  let count = 0;
  for (let i = 0; i < tuple.length; i++) {
    if (tuple[i] === '(') {
      count++;
    } else if (tuple[i] === ')') {
      count--;
    } else if (tuple[i] === ',' && count === 0) {
      end = i;
      subTypes.push(tuple.slice(start, end));
      start = i + 1;
    }
  }
  return subTypes.map((subType) => subType.trim());
}

export function hashType(type: string) {
  // first 4 bytes keccak256 hash of type
  return keccak('keccak256').update(type).digest('hex').slice(0, 8);
}

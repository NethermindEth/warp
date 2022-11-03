import { AbiItemType, StructAbiItemType } from '../abiTypes';
import { INDENT } from '../genCairo';

export function stringfyStructs(structs: StructAbiItemType[]): string[] {
  return structs
    .filter((item: AbiItemType) => item.name !== 'Uint256')
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
  if (type === 'felt') return 'Uint256';
  if (typeToStruct.has(type)) return `${type}_uint256`;
  if (type.endsWith('*')) {
    return transformType(type.slice(0, -1), typeToStruct) + '*';
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = type
      .slice(1, -1)
      .split(',')
      .map((x) => x.trim());
    if (subTypes.every((subType) => subType === subTypes[0])) {
      return `(${type
        .slice(1, -1)
        .split(',')
        .map((x) => transformType(x, typeToStruct))
        .join(',')})`;
    }
    const structName = `struct_${Buffer.from(type).toString('hex')}`;
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
  name: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  varName?: string,
  addedStruct?: Map<string, StructAbiItemType>,
): string {
  type = type.trim();
  if (type === 'felt') return `${INDENT}let (${name}_cast) = narrow_safe(${varName ?? name});`;
  if (typeToStruct.has(type))
    return `${INDENT}let (${name}_cast) = ${type}_cast(${varName ?? name});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${name}_cast = cast(${varName ?? name}, ${type});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = type.slice(1, -1).split(',');
    const castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(
        castStatement(
          `${name}_${i}`,
          subTypes[i],
          typeToStruct,
          addedStruct?.has(type) ? `${name}.member_${i}` : `${name}[${i}]`,
        ),
      );
    }
    castBody.push(
      `${INDENT}let ${name}_cast = (${subTypes.map((_, i) => `${name}_${i}_cast`).join(',')});`,
    );
    return castBody.join('\n');
  }
  return `${INDENT}let ${name}_cast = ${varName ?? name};`;
}

export function reverseCastStatement(
  name: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  varName?: string,
  addedStruct?: Map<string, StructAbiItemType>,
): string {
  type = type.trim();
  if (type === 'felt')
    return `${INDENT}let (${name}) = felt_to_uint256(${varName ?? `${name}_cast_rev`});`;
  if (typeToStruct.has(type))
    return `${INDENT}let (${name}) = ${type}_cast_reverse(${varName ?? `${name}_cast_rev`});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${name} = cast(${varName ?? `${name}_cast_rev`}, ${transformType(
      type,
      typeToStruct,
    )});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = type.slice(1, -1).split(',');
    const castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(
        reverseCastStatement(`${name}_${i}`, subTypes[i], typeToStruct, `${name}_cast_rev[${i}]`),
      );
    }
    castBody.push(
      `${INDENT}let ${name} = ${
        addedStruct?.has(type) ? `struct_${Buffer.from(type).toString('hex')}` : ``
      }(${subTypes.map((_, i) => `${name}_${i}`).join(',')});`,
    );
    return castBody.join('\n');
  }
  return `${INDENT}let ${name} = ${varName ?? `${name}_cast_rev`};`;
}

export function tupleParser(tuple: string): string[] {
  tuple = tuple.slice(1, -1).trim();
  let subTuples: string[] = [];
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
      subTuples.push(tuple.slice(start, end));
      start = i + 1;
    }
  }
  subTuples.forEach((subTuple) => {
    tuple.replace(subTuple, '');
  });
  const remainingTuples = tuple
    .split(',')
    .map((x) => x.trim())
    .filter((x) => x !== '');
  return [...subTuples, ...remainingTuples];
}

console.log(tupleParser('(felt, (felt, felt), (felt, (felt, felt)))'));

import { AbiItemType, StructAbiItemType } from '../abiTypes';
import { INDENT } from '../genCairo';

export function stringfyStructs(structs: StructAbiItemType[]): string[] {
  return structs
    .filter((item: AbiItemType) => item.name !== 'Uint256')
    .map((item: StructAbiItemType) => {
      return [
        `struct ${item.name} {`,
        ...item.members.map((member: any) => {
          return `${INDENT}${member.name}: ${member.type},`;
        }),
        '}',
      ].join('\n');
    });
}

export function transformType(type: string, typeToStruct: Map<string, StructAbiItemType>): string {
  type = type.trim();
  if (type === 'felt') return 'Uint256';
  if (typeToStruct.has(type)) return `${type}_uint256`;
  if (type.endsWith('*')) {
    return transformType(type.slice(0, -1), typeToStruct) + '*';
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    return `(${type
      .slice(1, -1)
      .split(',')
      .map((x) => transformType(x, typeToStruct))
      .join(',')})`;
  }
  return type;
}

export function castStatement(
  name: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  var_name?: string,
): string {
  type = type.trim();
  if (type === 'felt') return `${INDENT}let (${name}_cast) = narrow_safe(${var_name ?? name});`;
  if (typeToStruct.has(type))
    return `${INDENT}let (${name}_cast) = ${type}_cast(${var_name ?? name});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${name}_cast = cast(${var_name ?? name}, ${type});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = type.slice(1, -1).split(',');
    let castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(castStatement(`${name}_${i}`, subTypes[i], typeToStruct, `${name}[${i}]`));
    }
    castBody.push(
      `${INDENT}let ${name}_cast = (${subTypes.map((_, i) => `${name}_${i}_cast`).join(',')});`,
    );
    return castBody.join('\n');
  }
  return `${INDENT}let ${name}_cast = ${var_name ?? name};`;
}

export function reverseCastStatement(
  name: string,
  type: string,
  typeToStruct: Map<string, StructAbiItemType>,
  var_name?: string,
): string {
  type = type.trim();
  if (type === 'felt')
    return `${INDENT}let (${name}) = felt_to_uint256(${var_name ?? `${name}_cast_rev`});`;
  if (typeToStruct.has(type))
    return `${INDENT}let (${name}) = ${type}_cast_reverse(${var_name ?? `${name}_cast_rev`});`;
  if (type.endsWith('*')) {
    return `${INDENT}let ${name} = cast(${var_name ?? `${name}_cast_rev`}, ${transformType(
      type,
      typeToStruct,
    )});`;
  }
  if (type.startsWith('(') && type.endsWith(')')) {
    const subTypes = type.slice(1, -1).split(',');
    let castBody = [];
    for (let i = 0; i < subTypes.length; i++) {
      castBody.push(
        reverseCastStatement(`${name}_${i}`, subTypes[i], typeToStruct, `${name}_cast_rev[${i}]`),
      );
    }
    castBody.push(`${INDENT}let ${name} = (${subTypes.map((_, i) => `${name}_${i}`).join(',')});`);
    return castBody.join('\n');
  }
  return `${INDENT}let ${name} = ${var_name ?? `${name}_cast_rev`};`;
}

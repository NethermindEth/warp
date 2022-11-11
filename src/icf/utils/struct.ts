import { AbiType, AbiItemType, StructAbiItemType } from '../abiTypes';
import { castStatement, reverseCastStatement, transformType } from './util';
import { INDENT, getInteractiveFuncs } from '../genCairo';

function copyStructItem(struct: StructAbiItemType): StructAbiItemType {
  return {
    type: 'struct',
    name: struct.name,
    size: struct.size,
    members: struct.members.map((member) => {
      return { name: member.name, offset: member.offset, type: member.type };
    }),
  };
}

export function getStructsFromABI(abi: AbiType): StructAbiItemType[] {
  const result: StructAbiItemType[] = [];
  abi.forEach((item) => {
    if (item.type === 'struct' && item.name !== 'Uint256') {
      result.push(item);
    }
  });
  return result;
}

export function getAllStructsFromABI(abi: AbiType): StructAbiItemType[] {
  let result: StructAbiItemType[] = getStructDependencyGraph(abi);
  const res = getInteractiveFuncs(abi, undefined, undefined);
  result = result.concat(res[2]);
  result = result.concat(res[5]);
  return result;
}

function visitStructItemNode(
  node: StructAbiItemType,
  visitedStructItem: Map<StructAbiItemType, boolean>,
  typeToStruct: Map<string, StructAbiItemType>,
  result: StructAbiItemType[],
): void {
  if (visitedStructItem.has(node)) {
    return;
  }
  visitedStructItem.set(node, true);
  for (let i = 0; i < node.members.length; i++) {
    const struct = typeToStruct.get(node.members[i].type);
    if (struct !== undefined) {
      visitStructItemNode(struct as StructAbiItemType, visitedStructItem, typeToStruct, result);
    }
  }
  result.push(node);
}

export function getStructDependencyGraph(abi: AbiType): StructAbiItemType[] {
  const visitedStructItem: Map<StructAbiItemType, boolean> = new Map();
  const typeToStruct: Map<string, StructAbiItemType> = typeToStructMapping(getStructsFromABI(abi));
  const result: StructAbiItemType[] = [];

  abi.forEach((item: AbiItemType) => {
    if (item.type === 'struct' && item.name !== 'Uint256') {
      visitStructItemNode(item, visitedStructItem, typeToStruct, result);
    }
  });
  return result;
}

export function typeToStructMapping(structs: StructAbiItemType[]): Map<string, StructAbiItemType> {
  const result: Map<string, StructAbiItemType> = new Map();
  structs.forEach((item: StructAbiItemType) => {
    result.set(item.name, item);
  });
  return result;
}

export function uint256TransformStructs(
  structDependency: StructAbiItemType[],
): [StructAbiItemType[], string[], Map<string, StructAbiItemType>] {
  const typeToStruct = typeToStructMapping(structDependency);
  const transformedStructs: StructAbiItemType[] = [];
  const transformedStructsFuncs: string[] = [];
  const structTuplesMap: Map<string, StructAbiItemType> = new Map();

  structDependency.forEach((itm: StructAbiItemType) => {
    const item: StructAbiItemType = copyStructItem(itm);
    const castFunctionBody: string[] = [];
    const castReverseFunctionBody: string[] = [];

    item.members.forEach((member: { name: string; offset?: number; type: string }) => {
      castFunctionBody.push(
        castStatement(
          member.name,
          `frm.${member.name}`,
          member.type,
          typeToStruct,
          structTuplesMap,
        ),
      );
      castReverseFunctionBody.push(
        reverseCastStatement(
          member.name,
          `frm.${member.name}`,
          member.type,
          typeToStruct,
          structTuplesMap,
        ),
      );
      member.type = transformType(member.type, typeToStruct, structTuplesMap);
    });

    transformedStructs.push(item as StructAbiItemType);

    transformedStructsFuncs.push(
      [
        `func ${item.name}_cast{syscall_ptr: felt*, range_check_ptr: felt}(frm : ${item.name}_uint256) -> (to : ${item.name}) {`,
        `${INDENT}alloc_locals;`,
        ...castFunctionBody,
        `${INDENT}return (${item.name}(${item.members.map((x) => `${x.name}`).join(',')}),);`,
        '}',
        `func ${item.name}_cast_reverse{syscall_ptr: felt*, range_check_ptr: felt}(frm : ${item.name}) -> (to : ${item.name}_uint256) {`,
        `${INDENT}alloc_locals;`,
        ...castReverseFunctionBody,
        `${INDENT}return (${item.name}_uint256(${item.members.map((x) => x.name).join(',')}),);`,
        '}',
      ].join('\n'),
    );

    item.name = `${item.name}_uint256`;
  });
  return [transformedStructs, transformedStructsFuncs, structTuplesMap];
}

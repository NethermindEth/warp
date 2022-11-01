import { AbiType, AbiItemType, StructAbiItemType } from '../abiTypes';
import { castStatement, reverseCastStatement, transformType } from './util';
import { INDENT } from '../genCairo';

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
  let result: StructAbiItemType[] = [];
  abi.forEach((item) => {
    if (item.type === 'struct' && item.name !== 'Uint256') {
      result.push(item);
    }
  });
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
  let visitedStructItem: Map<StructAbiItemType, boolean> = new Map();
  let typeToStruct: Map<string, StructAbiItemType> = typeToStructMappping(getStructsFromABI(abi));
  let result: StructAbiItemType[] = [];

  abi.forEach((item: AbiItemType) => {
    if (item.type === 'struct' && item.name !== 'Uint256') {
      visitStructItemNode(item, visitedStructItem, typeToStruct, result);
    }
  });
  return result;
}

export function typeToStructMappping(structs: StructAbiItemType[]): Map<string, StructAbiItemType> {
  let result: Map<string, StructAbiItemType> = new Map();
  structs.forEach((item: StructAbiItemType) => {
    result.set(item.name, item);
  });
  return result;
}

export function uint256TransformStructs(
  structDependency: StructAbiItemType[],
): [StructAbiItemType[], string[]] {
  const typeToStruct = typeToStructMappping(structDependency);
  let transformedStructs: StructAbiItemType[] = [];
  let transformedStructsFuncs: string[] = [];

  structDependency.forEach((itm: StructAbiItemType) => {
    const item: StructAbiItemType = copyStructItem(itm);
    let castFunctionBody: string[] = [];
    let castReverseFunctionBody: string[] = [];

    item.members.forEach((member: { name: string; offset: number; type: string }) => {
      castFunctionBody.push(
        castStatement(member.name, member.type, typeToStruct, `frm.${member.name}`),
      );
      castReverseFunctionBody.push(
        reverseCastStatement(member.name, member.type, typeToStruct, `frm.${member.name}`),
      );
      member.type = transformType(member.type, typeToStruct);
    });

    transformedStructs.push(item as StructAbiItemType);

    transformedStructsFuncs.push(
      [
        `func ${item.name}_cast{syscall_ptr: felt*, range_check_ptr: felt}(frm : ${item.name}_uint256) -> (to : ${item.name}) {`,
        `${INDENT}alloc_locals;`,
        ...castFunctionBody,
        `${INDENT}return (${item.name}(${item.members.map((x) => `${x.name}_cast`).join(',')}),);`,
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
  return [transformedStructs, transformedStructsFuncs];
}

import { AbiType, AbiItemType, StructAbiItemType, FunctionAbiItemType } from './types';

const INDENT = '    ';

export function genCairoContract(abi: AbiType, contract_address: string | undefined) {
  const langDirective: string[] = getStarknetLangDirective();
  const structs: string[] = getStructs(abi);
  const forwarderInterface: string[] = getForwarderInterface(abi);
  const { interactiveFuncs, imports }: { interactiveFuncs: string[]; imports: string[] } =
    getInteractiveFuncs(abi);
}

function getStarknetLangDirective(): string[] {
  return ['%lang starknet'];
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
    if (node.members[i].type === 'struct') {
      const struct = typeToStruct.get(node.members[i].type);
      if (struct !== undefined)
        visitStructItemNode(struct, visitedStructItem, typeToStruct, result);
    }
  }
  result.push(node);
}

export function getStructDependencyGraph(abi: AbiType): StructAbiItemType[] {
  let visitedStructItem: Map<StructAbiItemType, boolean> = new Map();
  let typeToStruct: Map<string, StructAbiItemType> = typeToStructMappping(abi);
  let result: StructAbiItemType[] = [];

  abi.forEach((item: AbiItemType) => {
    if (item.type === 'struct') {
      visitStructItemNode(item, visitedStructItem, typeToStruct, result);
    }
  });
  return result;
}

function typeToStructMappping(abi: AbiType): Map<string, StructAbiItemType> {
  const typeToStruct: Map<string, StructAbiItemType> = new Map();
  abi.forEach((item: AbiItemType) => {
    if (item.type === 'struct' && item.name !== 'Uint256') {
      typeToStruct.set(item.name, item);
    }
  });
  return typeToStruct;
}

function getStructs(abi: any): string[] {
  const structDependency = getStructDependencyGraph(abi);
  return structDependency
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

function getForwarderInterface(abi: AbiType): string[] {
  return [
    '@contract_interface',
    'nampspace Forwarder {',
    ...abi.map((item: AbiItemType) => {
      if (item.type === 'function') {
        return [
          `${INDENT}func ${item.name}(`,
          ...item.inputs.map((input: any) => {
            return `${INDENT}${INDENT}${input.name}: ${input.type},`;
          }),
          `${INDENT}) -> (${item.outputs.map((output: any) => output.type).join(', ')}){`,
          `${INDENT}}`,
        ].join('\n');
      }
      return '';
    }),
    '}',
  ];
}

function uint256TransformStructs(
  structDependency: StructAbiItemType[],
  typeToStruct: Map<string, StructAbiItemType>,
): { transformedStructs: StructAbiItemType[]; transformedStructsFuncs: string[] } {
  let transformedStructs: StructAbiItemType[] = [];
  let transformedStructsFuncs: string[] = [];
  structDependency.forEach((item: StructAbiItemType) => {
    let castFunctionBody: string[] = [];
    item.name = `${item.name}_uint256`;
    item.members.forEach((member: { name: string; offset: number; type: string }) => {
      if (member.type === 'felt') {
        member.type = 'Uint256';
        castFunctionBody.push(`${INDENT}let (${member.name}) = narrow_safe(${member.name});`);
      } else if (typeToStruct.has(member.type)) {
        member.type = `${member.type}_uint256`;
        castFunctionBody.push(
          `${INDENT}let (${member.name}) = ${member.type}_cast(${member.name});`,
        );
      } else {
        throw new Error(`Calldata doesn't expect ${member.type} arguments`);
      }
    });
    transformedStructs.push(item);
    transformedStructsFuncs.push(
      [
        `func ${item.name}_cast(from : ${item.name}) -> (to : ${item.name}_uint256) {`,
        ...castFunctionBody,
        `${INDENT}return (${item.name}_uint256(${item.members.map((x) => x.name).join(',')}),);`,
        '}',
      ].join('\n'),
    );
  });
  return { transformedStructs, transformedStructsFuncs };
}

function getInteractiveFuncs(abi: AbiType): { interactiveFuncs: string[]; imports: string[] } {
  const structDependency = getStructDependencyGraph(abi);
  const { transformedStructs, transformedStructsFuncs } = uint256TransformStructs(
    structDependency,
    typeToStructMappping(abi),
  );

  let imports: string[] = [
    'from starkware.cairo.common.uint256 import Uint256',
    'from starkware.cairo.common.cairo_builtins import HashBuiltin',
    'from warplib.maths.utils import felt_to_uint256, narrow_safe',
  ];

  let interactiveFuncs: string[] = [];
  abi.forEach((item: AbiItemType) => {
    if (item.type === 'function') {
      const decorator: string = item.stateMutability === 'view' ? '@view' : '@external';
    }
  });

  return { interactiveFuncs, imports };
}

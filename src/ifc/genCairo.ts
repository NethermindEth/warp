import { AbiType, AbiItemType, StructAbiItemType } from './abiTypes';
import {
  castStatement,
  getStructDependencyGraph,
  reverseCastStatement,
  stringfyStructs,
  transformType,
  typeToStructMappping,
  uint256TransformStructs,
} from './utils';

export const INDENT = '    ';

export function genCairoContract(abi: AbiType, contract_address: string | undefined): string {
  const langDirective: string[] = getStarknetLangDirective();
  const structs: string[] = stringfyStructs(getStructDependencyGraph(abi));
  const forwarderInterface: string[] = getForwarderInterface(abi);
  const [interactiveFuncs, imports, transformStructs, castFunctions, tupleStructs] =
    getInteractiveFuncs(abi, contract_address);
  return (
    langDirective.join('\n') +
    '\n\n// imports \n' +
    imports.join('\n') +
    '\n\n// existing structs\n' +
    structs.join('\n') +
    '\n\n// transformed structs \n' +
    stringfyStructs(transformStructs).join('\n') +
    '\n\n// tuple structs \n' +
    stringfyStructs(tupleStructs).join('\n') +
    '\n\n// forwarder interface \n' +
    forwarderInterface.join('\n') +
    '\n\n//cast functions for structs \n' +
    castFunctions.join('\n') +
    '\n\n//funtions to interact with given cairo contract\n' +
    interactiveFuncs.join('\n')
  );
}

function getStarknetLangDirective(): string[] {
  return ['%lang starknet'];
}

function getForwarderInterface(abi: AbiType): string[] {
  return [
    '@contract_interface',
    'namespace Forwarder {',
    ...abi.map((item: AbiItemType) => {
      if (item.type === 'function') {
        return [
          `${INDENT}func ${item.name}(`,
          ...item.inputs.map((input: { name: string; type: string }) => {
            return `${INDENT}${INDENT}${input.name}: ${input.type},`;
          }),
          `${INDENT}) -> (${item.outputs
            .map((output: { name: string; type: string }) => `${output.name}:${output.type}`)
            .join(', ')}){`,
          `${INDENT}}`,
        ].join('\n');
      }
      return '';
    }),
    '}',
  ];
}

export function getInteractiveFuncs(
  abi: AbiType,
  contract_address: string | undefined,
): [string[], string[], StructAbiItemType[], string[], StructAbiItemType[]] {
  const structDependency = getStructDependencyGraph(abi);
  const typeToStruct = typeToStructMappping(structDependency);
  const [transformedStructs, transformedStructsFuncs, structTuplesMap] =
    uint256TransformStructs(structDependency);

  const imports: string[] = [
    'from starkware.cairo.common.uint256 import Uint256',
    'from starkware.cairo.common.cairo_builtins import HashBuiltin',
    'from warplib.maths.utils import felt_to_uint256, narrow_safe',
  ];

  const interactiveFuncs: string[] = [];
  abi.forEach((item: AbiItemType) => {
    if (item.type === 'function') {
      const decorator: string = item.stateMutability === 'view' ? '@view' : '@external';

      const callToFunc = `${INDENT}let (${item.outputs.reduce(
        (acc: string[], output: { name: string; type: string }) => {
          if (output.type.endsWith('*')) {
            acc.pop();
            acc.push(`${output.name}_len`);
          }
          return [...acc, `${output.name}_cast_rev`];
        },
        [],
      )}) = Forwarder.${item.name}(${contract_address ?? 0},${item.inputs.reduce(
        (acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
            acc.push(`${input.name}_len`);
          }
          return [...acc, `${input.name}_cast`];
        },
        [],
      )});`;

      interactiveFuncs.push(
        decorator,
        `func _ITR_${item.name} {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(`,
        ...item.inputs.reduce((acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
            acc.push(`${INDENT}${input.name}_len: felt,`);
          }
          acc.push(
            `${INDENT}${input.name}: ${transformType(input.type, typeToStruct, structTuplesMap)},`,
          );
          return acc;
        }, []),
        ') -> (',
        ...item.outputs.reduce((acc: string[], output: { name: string; type: string }) => {
          if (output.type.endsWith('*')) {
            acc.pop();
            acc.push(`${INDENT}${output.name}_len: felt,`);
          }
          acc.push(
            `${INDENT}${output.name}: ${transformType(
              output.type,
              typeToStruct,
              structTuplesMap,
            )},`,
          );
          return acc;
        }, []),
        ') {',
        `${INDENT}alloc_locals;`,
        ...item.inputs.reduce((acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
          }
          acc.push(castStatement(input.name, input.type, typeToStruct, undefined, structTuplesMap));
          return acc;
        }, []),
        callToFunc,
        ...item.outputs.reduce((acc: string[], output: { name: string; type: string }) => {
          if (output.type.endsWith('*')) {
            acc.pop();
          }
          acc.push(
            reverseCastStatement(
              output.name,
              output.type,
              typeToStruct,
              undefined,
              structTuplesMap,
            ),
          );
          return acc;
        }, []),
        `${INDENT}return (${[...item.outputs.map((x) => x.name), ''].join(',')});`,
        '}',
      );
    }
  });
  return [
    interactiveFuncs,
    imports,
    transformedStructs,
    transformedStructsFuncs,
    [...structTuplesMap.values()],
  ];
}

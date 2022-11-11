import { AbiType, AbiItemType, StructAbiItemType, FunctionAbiItemType } from './abiTypes';
import { externalInputCheckStatement } from './extInpCheck';
import {
  castStatement,
  getStructDependencyGraph,
  reverseCastStatement,
  stringfyStructs,
  transformType,
  typeToStructMapping,
  uint256TransformStructs,
} from './utils';

export const INDENT = '    ';

export function genCairoContract(
  abi: AbiType,
  contract_address: string | undefined,
  class_hash: string | undefined,
): string {
  const langDirective: string[] = getStarknetLangDirective();
  const structs: string[] = stringfyStructs(getStructDependencyGraph(abi));
  const forwarderInterface: string[] = getForwarderInterface(abi);
  const [
    interactiveFuncs,
    imports,
    transformStructs,
    castFunctions,
    expInpFunctions,
    tupleStructs,
  ] = getInteractiveFuncs(abi, contract_address, class_hash);
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
    '\n\n// external input check functions\n' +
    expInpFunctions.join('\n') +
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
      if (item.type === 'function' && item.name !== '__default__') {
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
  class_hash: string | undefined,
): [string[], string[], StructAbiItemType[], string[], string[], StructAbiItemType[]] {
  const structDependency = getStructDependencyGraph(abi);
  const typeToStruct = typeToStructMapping(structDependency);
  const [transformedStructs, transformedStructsFuncs, structTuplesMap] =
    uint256TransformStructs(structDependency);

  const imports: string[] = [
    'from starkware.cairo.common.uint256 import Uint256',
    'from starkware.cairo.common.cairo_builtins import HashBuiltin',
    'from warplib.maths.utils import felt_to_uint256, narrow_safe',
    'from warplib.maths.external_input_check_ints import warp_external_input_check_int256',
  ];

  const interactiveFuncs: string[] = [];
  const expInpFunctionsMap: Map<string, string> = new Map();

  abi.forEach((item: AbiItemType) => {
    if (item.type === 'function' && item.name !== '__default__') {
      const decorator: string = item.stateMutability === 'view' ? '@view' : '@external';

      const callToFunc = (isDelegate: boolean) =>
        `${INDENT}let (${item.outputs.reduce(
          (acc: string[], output: { name: string; type: string }) => {
            if (output.type.endsWith('*')) {
              acc.pop();
              acc.push(`${output.name}_len`);
            }
            return [...acc, `${output.name}_cast_rev`];
          },
          [],
        )}) = Forwarder.${(isDelegate ? 'library_call_' : '') + item.name}(${
          isDelegate ? class_hash ?? 0 : contract_address ?? 0
        },${item.inputs.reduce((acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
            acc.push(`${input.name}_len`);
          }
          return [...acc, `${input.name}_cast`];
        }, [])});`;

      const funcDef = (isDelegate: boolean) => [
        decorator,
        `func _ITR_${
          (isDelegate ? '_delegate_' : '') + item.name
        } {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(`,
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
        `${INDENT}// check external input`,
        ...item.inputs.reduce((acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
          }
          acc.push(
            externalInputCheckStatement(
              input.name,
              transformType(input.type, typeToStruct, structTuplesMap),
              expInpFunctionsMap,
              typeToStructMapping(transformedStructs),
              structTuplesMap,
            ),
          );
          return acc;
        }, []),
        `${INDENT}// cast inputs`,
        ...item.inputs.reduce((acc: string[], input: { name: string; type: string }) => {
          if (input.type.endsWith('*')) {
            acc.pop();
          }
          acc.push(
            castStatement(
              input.name + '_cast',
              input.name,
              input.type,
              typeToStruct,
              structTuplesMap,
            ),
          );
          return acc;
        }, []),
        `${INDENT}// call cairo contract function`,
        callToFunc(isDelegate),
        `${INDENT}// cast outputs`,
        ...item.outputs.reduce((acc: string[], output: { name: string; type: string }) => {
          if (output.type.endsWith('*')) {
            acc.pop();
          }
          acc.push(
            reverseCastStatement(
              output.name,
              output.name + '_cast_rev',
              output.type,
              typeToStruct,
              structTuplesMap,
            ),
          );
          return acc;
        }, []),
        `${INDENT}return (${[...item.outputs.map((x) => x.name), ''].join(',')});`,
        '}',
      ];

      interactiveFuncs.push(...funcDef(false), ...funcDef(true));
    }
  });
  return [
    interactiveFuncs,
    imports,
    transformedStructs,
    transformedStructsFuncs,
    [...expInpFunctionsMap.values()],
    [...structTuplesMap.values()],
  ];
}

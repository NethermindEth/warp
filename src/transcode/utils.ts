import { BigNumberish } from 'ethers';
import { ParamType, Result } from 'ethers/lib/utils';
import { CLIError } from '../utils/errors';
import { readFileSync } from 'fs';
import prompts from 'prompts';
import { divmod } from '../utils/utils';

export type SolValue = BigNumberish | boolean | string | { [key: string]: SolValue } | SolValue[];
export type Param = (string | number | Param)[];

export type SolParamType = { internalType: string; name: string; type: string };
export type SolFuncType = {
  inputs: SolParamType[];
  name: string;
  outputs: SolParamType[];
  stateMutability: 'payable' | 'pure' | 'view';
  type: 'function';
};

export type SolConstructorType = {
  inputs: SolParamType[];
  stateMutability: 'payable' | 'pure' | 'view';
  type: 'constructor';
};

export type SolABIFunction = SolFuncType | SolConstructorType;

export function getWidthInFeltsOf(type: ParamType): number {
  if (type.baseType.startsWith('uint')) {
    const width = parseInt(type.baseType.slice(4), 10);
    return width < 256 ? 1 : 2;
  } else if (type.baseType.startsWith('int')) {
    const width = parseInt(type.baseType.slice(3), 10);
    return width < 256 ? 1 : 2;
  } else if (type.baseType.startsWith('address')) {
    return 1;
  } else if (type.baseType.startsWith('bool')) {
    return 1;
  } else if (/bytes\d*$/.test(type.baseType)) {
    const width = parseInt(type.baseType.slice(4), 10);
    if (width === 32) return 2;
    return 1;
  } else if (type.baseType.startsWith('ufixed') || type.baseType.startsWith('fixed')) {
    throw new Error('Fixed types not supported by Warp');
  } else if (type.baseType.startsWith('bytes')) {
    throw new Error('Nested dynamic types not supported in Warp');
  } else if (type.indexed) {
    // array
    if (type.arrayLength === -1) {
      throw new Error('Nested dynamic types not supported in Warp');
    } else {
      // static array
      return type.arrayLength * getWidthInFeltsOf(type.arrayChildren);
    }
  } else if (type.components.length !== 0) {
    // struct
    return type.components.reduce((acc, ty) => {
      return acc + getWidthInFeltsOf(ty);
    }, 0);
  }
  throw new Error('Not Supported ' + type.baseType);
}

export function isPrimitiveParam(type: ParamType): boolean {
  return type.arrayLength === null && type.components === null;
}

const uint128 = BigInt('0x100000000000000000000000000000000');

export function toUintOrFelt(value: bigint, nBits: number): bigint[] {
  const val = bigintToTwosComplement(BigInt(value.toString()), nBits);
  if (nBits > 251) {
    const [high, low] = divmod(val, uint128);
    return [low, high];
  } else {
    return [val];
  }
}

export function bigintToTwosComplement(val: bigint, width: number): bigint {
  if (val >= 0n) {
    // Non-negative values just need to be truncated to the given bitWidth
    const bits = val.toString(2);
    return BigInt(`0b${bits.slice(-width)}`);
  } else {
    // Negative values need to be converted to two's complement
    // This is done by flipping the bits, adding one, and truncating
    const absBits = (-val).toString(2);
    const allBits = `${'0'.repeat(Math.max(width - absBits.length, 0))}${absBits}`;
    const inverted = `0b${[...allBits].map((c) => (c === '0' ? '1' : '0')).join('')}`;
    const twosComplement = (BigInt(inverted) + 1n).toString(2).slice(-width);
    return BigInt(`0b${twosComplement}`);
  }
}

export function twosComplementToBigInt(val: bigint, width: number): bigint {
  const mask = 2n ** BigInt(width) - 1n;
  const max = 2n ** BigInt(width - 1) - 1n;
  if (val > max) {
    // Negative number
    const pos = (val ^ mask) + 1n;
    return -pos;
  } else {
    // Positive numbers as are
    return val;
  }
}

export function safeNext<T>(iter: IterableIterator<T>): T {
  const next = iter.next();
  if (!next.done) {
    return next.value;
  }
  throw new Error('Unexpected end of input in Solidity to Cairo encode');
}

export function normalizeAddress(address: string): string {
  // For some reason starknet-devnet does not zero pads their addresses
  // For some reason starknet zero pads their addresses
  return `0x${address.split('x')[1].padStart(64, '0')}`;
}

export function parseParam(param: string): Param {
  try {
    const parsedParam = JSON.parse(`[${param}]`.replaceAll(/\b0x[0-9a-fA-F]+/g, (s) => `"${s}"`));
    validateParam(parsedParam);
    return parsedParam;
  } catch (e: unknown) {
    throw new CLIError('Param must be a comma separated list of numbers, strings and lists');
  }
}

function validateParam(param: unknown) {
  if (param instanceof Array) {
    param.map(validateParam);
    return;
  }
  if (
    param instanceof String ||
    param instanceof Number ||
    typeof param === 'string' ||
    typeof param === 'number'
  )
    return;

  throw new CLIError('Input invalid');
}

export function parseSolAbi(filePath: string): [] {
  const abiString = readFileSync(filePath, 'utf-8');
  const solAbi = JSON.parse(abiString);
  return solAbi;
}

export async function selectSignature(
  abi: SolABIFunction[],
  funcName: string,
): Promise<SolABIFunction> {
  if (funcName === 'constructor') {
    // Item with abi[type] === 'constructor'
    const constructorsAbi = abi.filter((item: SolABIFunction) => item.type === 'constructor');
    if (constructorsAbi.length === 0) {
      // Solidity ABI has no constructor so enforce empty args for constructor in CLI
      return {
        inputs: [],
        stateMutability: 'view',
        type: 'constructor',
      };
    }
    if (constructorsAbi.length > 1) {
      throw new CLIError('Multiple constructors found in abi');
    }
    return {
      type: 'function',
      inputs: constructorsAbi[0].inputs,
      outputs: [],
      stateMutability: constructorsAbi[0].stateMutability,
      name: 'constructor',
    };
  }

  const matchesWithoutConstructor = abi.filter(
    (item: SolABIFunction) => item.type === 'function',
  ) as SolFuncType[];
  const matches = matchesWithoutConstructor.filter((fs: SolFuncType) => fs['name'] === funcName);

  if (!matches.length) {
    throw new CLIError(`No function in abi with name ${funcName}`);
  }

  if (matches.length === 1) return matches[0];

  const choice = await prompts({
    type: 'select',
    name: 'func',
    message: `Multiple function definitions found for ${funcName}. Please select one now:`,
    choices: matches.map((func) => ({ title: func.name, value: func })),
  });

  return choice.func;
}

export function decodedOutputsToString(outputs: Result): string {
  return outputs.map((output) => outputToString(output)).join(', ');
}

function outputToString(output: Result | string | number): string {
  if (Array.isArray(output)) return `[ ${output.map((o) => outputToString(o)).join(', ')} ]`;
  else if (output.constructor === Object)
    // is a Struct
    return `{ ${Object.keys(output)
      .map(
        (key: string | number) =>
          outputToString(key) + ': ' + outputToString((output as Result)[key]),
      )
      .join(', ')} }`;
  else return (output as Result).toString();
}

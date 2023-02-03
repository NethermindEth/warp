import { BigNumber } from 'ethers';
import { isBytes, ParamType } from 'ethers/lib/utils';
import { isBigNumberish } from '@ethersproject/bignumber/lib/bignumber';
import {
  isPrimitiveParam,
  SolValue,
  toUintOrFelt,
  safeNext,
  parseSolAbi,
  selectSignature,
} from './utils';
import Web3 from 'web3';

export async function encodeInputs(
  filePath: string,
  func: string,
  useCairoABI: boolean,
  rawInputs?: string[],
): Promise<[string, string]> {
  if (useCairoABI) {
    const inputs = rawInputs ? `${rawInputs.join(' ').split(',').join(' ')}` : '';
    return [func, inputs];
  }

  const solABI = parseSolAbi(filePath);
  const funcSignature = await selectSignature(solABI, func);

  let funcName = func;

  // If function type is not constructor then append the EVM function selector to the function name
  if (funcSignature.type === 'function') {
    const selector = new Web3().utils
      .keccak256(
        `${funcSignature['name']}(${funcSignature['inputs'].map((i) => i['type']).join(',')})`,
      )
      .substring(2, 10);
    funcName = `${func}_${selector}`;
  }

  const inputNodes: ParamType[] = funcSignature.inputs.map(ParamType.fromObject);
  const encodedInputs = encode(inputNodes, rawInputs ?? []);
  const inputs = rawInputs ? `${encodedInputs.join(' ')}` : '';

  return [funcName, inputs];
}

export function encode(types: ParamType[], inputs: SolValue[]): string[] {
  return encodeParams(types, makeIterator(inputs));
}

export function encodeParams(types: ParamType[], inputs: IterableIterator<SolValue>): string[] {
  return types.flatMap((ty) => encode_(ty, inputs));
}

export function encode_(type: ParamType, inputs: IterableIterator<SolValue>): string[] {
  if (isPrimitiveParam(type)) {
    return encodePrimitive(type.type, inputs);
  } else {
    return encodeComplex(type, inputs);
  }
}

function encodePrimitive(typeString: string, inputs: IterableIterator<SolValue>): string[] {
  if (typeString.startsWith('uint')) {
    return encodeAsUintOrFelt(typeString, inputs, parseInt(typeString.slice(4), 10));
  }
  if (typeString.startsWith('int')) {
    return encodeAsUintOrFelt(typeString, inputs, parseInt(typeString.slice(3), 10));
  }
  if (typeString === 'address') {
    return encodeAsUintOrFelt(typeString, inputs, 251);
  }
  if (typeString === 'bool') {
    const value = safeNext(inputs);
    if (typeof value === 'boolean') {
      return value ? ['1'] : ['0'];
    }
    if (typeof value === 'string') {
      if (value === 'true' || value === 'false') return value === 'true' ? ['1'] : ['0'];
      if (value === '1' || value === '0') return [value];
    }
    throw new Error(`Cannot encode ${value} as a boolean value. Expected 'true' or 'false'`);
  }
  if (typeString === 'fixed' || typeString === 'ufixed') {
    throw new Error('Fixed types not supported by Warp');
  }
  if (/bytes\d+$/.test(typeString)) {
    const nbits = parseInt(typeString.slice(5), 10) * 8;
    return encodeAsUintOrFelt(typeString, inputs, nbits);
  }
  if (typeString === 'bytes') {
    const value = safeNext(inputs);
    if (typeof value === 'string') {
      // remove 0x
      const bytes = value.substring(2);
      if (bytes.length % 2 !== 0) throw new Error('Bytes must have even length');

      const cairoBytes: string[] = [];
      for (let index = 0; index < bytes.length; index += 2) {
        const byte = bytes.substring(index, index + 2);
        cairoBytes.push(`0x${byte}`);
      }
      return [...cairoBytes].flat();
    } else if (isBytes(value)) {
      if (value.length % 2 !== 0) throw new Error('Bytes must have even length');

      return Array.from(value).map((byte) => byte.toString());
    }
    throw new Error(`Can't encode ${value} as bytes`);
  }
  if (typeString === 'string') {
    const value = safeNext(inputs);
    if (typeof value === 'string') {
      return [
        value.length.toString(),
        ...Buffer.from(value)
          .toJSON()
          .data.map((v) => v.toString()),
      ];
    }
    throw new Error(`Can't encode ${value} as string`);
  }
  throw new Error(`Failed to encode type ${typeString}`);
}

export function encodeComplex(type: ParamType, inputs: IterableIterator<SolValue>): string[] {
  const value = safeNext(inputs);

  if (type.baseType === 'array') {
    if (!Array.isArray(value)) {
      throw new Error(`Array must be of array type`);
    }
    // array type
    const length = type.arrayLength === -1 ? [value.length.toString()] : [];
    return [...length, ...value.flatMap((val) => encode_(type.arrayChildren, makeIterator([val])))];
  } else if (type.baseType === 'tuple') {
    if (typeof value !== 'object') {
      throw new Error('Expected Object input for transcoding struct types');
    }

    const tupleValues = value as { [key: string]: SolValue };
    const keys = new Set(Object.keys(tupleValues));

    const encoding = type.components.flatMap((type) => {
      if (!keys.has(type.name)) {
        throw new Error(`Unknown struct member: ${type.name}`);
      }
      keys.delete(type.name);
      return encode_(type, makeIterator(tupleValues[type.name]));
    });
    if (keys.size !== 0) {
      throw new Error(
        `Some struct properties where not specified: ${[...keys.values()].join(', ')}`,
      );
    }
    return encoding;
  }
  throw new Error(`Can't encode complex type ${type}`);
}

export function makeIterator(value: SolValue) {
  if (Array.isArray(value)) {
    return value.values();
  }

  return [value].values();
}

export function encodeAsUintOrFelt(
  tp: string,
  inputs: IterableIterator<SolValue>,
  nbits: number,
): string[] {
  const value = safeNext(inputs);
  if (isBigNumberish(value)) {
    return toUintOrFelt(BigNumber.from(value).toBigInt(), nbits).map((x) => x.toString());
  }
  throw new Error(`Can't encode ${value} as ${tp}`);
}

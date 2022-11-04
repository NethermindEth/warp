import { BigNumber, BigNumberish } from 'ethers';
import { ParamType, Result, FunctionFragment } from 'ethers/lib/utils';
import {
  isPrimitiveParam,
  twosComplementToBigInt,
  safeNext,
  normalizeAddress,
  parseSolAbi,
  selectSignature,
  SolValue,
} from './utils';

export async function decodeOutputs(
  filePath: string,
  func: string,
  rawOutputs?: string[],
): Promise<Result> {
  const solABI = parseSolAbi(filePath);

  const [funcSignature, returnSignature] = await selectSignature(solABI, func);

  const outputNodes: ParamType[] =
    FunctionFragment.fromString(`${funcSignature} returns (${returnSignature})`).outputs ?? [];
  const outputs: string[] = rawOutputs ?? [];

  return decode(outputNodes, outputs);
}

type Struct = { [key: string]: SolValue };

export function decode(types: ParamType[], outputs: string[]): Result {
  const decoded = decode_(types, outputs.values());
  const namedMembers: Struct = {};
  types.forEach((ty, i) => {
    namedMembers[ty.name] = decoded[i];
  });

  if (types.length === 1) {
    return decoded[0];
  }

  return { ...namedMembers, ...decoded };
}

export function decodeEvents(types: ParamType[], outputs: string[]) {
  const decoded = decode_(types, outputs.values());
  const namedMembers: Struct = {};
  types.forEach((ty, i) => {
    namedMembers[ty.name] = decoded[i];
  });

  return { ...namedMembers, ...decoded };
}

export function decode_(types: ParamType[], outputs: IterableIterator<string>): Result {
  return types.map((ty) => {
    if (isPrimitiveParam(ty)) {
      return decodePrimitive(ty.baseType, outputs);
    } else {
      return decodeComplex(ty, outputs);
    }
  });
}

function decodePrimitive(
  typeString: string,
  outputs: IterableIterator<string>,
): BigNumberish | boolean | string {
  if (typeString.startsWith('uint')) {
    return decodeUint(typeString.length > 4 ? parseInt(typeString.slice(4), 10) : 256, outputs);
  }
  if (typeString.startsWith('int')) {
    return decodeInt(typeString.length > 3 ? parseInt(typeString.slice(3), 10) : 256, outputs);
  }
  if (typeString === 'address') {
    return normalizeAddress(`0x${readFelt(outputs).toString(16)}`);
  }
  if (typeString === 'bool') {
    return readFelt(outputs) === 0n ? false : true;
  }
  if (typeString === 'fixed' || typeString === 'ufixed') {
    throw new Error('Not Supported');
  }
  if (typeString.startsWith('bytes')) {
    return typeString.length === 5
      ? decodeBytes(outputs)
      : decodeFixedBytes(outputs, parseInt(typeString.slice(5)));
  }
  // Todo make pretty
  throw new Error(`Can't decode type ${typeString}`);
}

function readFelt(outputs: IterableIterator<string>): bigint {
  return BigInt(safeNext(outputs));
}

function useNumberIfSafe(n: bigint, width: number): BigNumber | number {
  return width <= 48 ? Number(n) : BigNumber.from(n);
}

function readUint(outputs: IterableIterator<string>): bigint {
  const low = BigInt(safeNext(outputs));
  const high = BigInt(safeNext(outputs));
  return (high << 128n) + low;
}

function decodeUint(nbits: number, outputs: IterableIterator<string>): BigNumber | number {
  return useNumberIfSafe(nbits < 256 ? readFelt(outputs) : readUint(outputs), nbits);
}

function decodeInt(nbits: number, outputs: IterableIterator<string>): BigNumber | number {
  return useNumberIfSafe(
    twosComplementToBigInt(nbits < 256 ? BigInt(readFelt(outputs)) : readUint(outputs), nbits),
    nbits,
  );
}

function decodeBytes(outputs: IterableIterator<string>): bigint {
  const len = readFelt(outputs);
  let result = 0n;
  for (let i = 0; i < len; i++) {
    result << 8n;
    result += BigInt(readFelt(outputs));
  }
  return result;
}

function decodeFixedBytes(outputs: IterableIterator<string>, length: number): BigNumber | number {
  return useNumberIfSafe(length < 32 ? readFelt(outputs) : readUint(outputs), length * 8);
}

export function decodeComplex(type: ParamType, outputs: IterableIterator<string>) {
  if (type.arrayLength) {
    // array type
    const length = type.arrayLength === -1 ? readFelt(outputs) : type.arrayLength;
    const result: Result = [];
    for (let i = 0; i < length; ++i) {
      result.push(decode_([type.arrayChildren], outputs)[0]);
    }
    return result;
  } else if (type.components !== null) {
    // struct type
    const indexedMembers = type.components.map((m) => decode_([m], outputs));
    const namedMembers: Struct = {};
    type.components.forEach((member, i) => {
      namedMembers[member.name] = indexedMembers[i];
    });

    return { ...namedMembers, ...indexedMembers } as Result;
  }
  throw Error(`Complex type not supported ${type.type}`);
}

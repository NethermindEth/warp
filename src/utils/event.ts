import createKeccakHash from 'keccak';
import { toUintOrFelt } from './export';

export type EventItem = { data: string[]; keys: string[]; order?: number };

export function splitInto248BitChunks(data: string): string[] {
  if (data.startsWith('0x')) data = data.slice(2);
  if (data === '') return [];
  const paddedData = data.padEnd(data.length + (62 - (data.length % 62)), '0');

  const result = [];
  // get number from every 62 hex digits chunk
  for (let i = 0; i < paddedData.length; i += 62) {
    result.push(BigInt(`0x${paddedData.slice(i, i + 62)}`).toString());
  }
  return result;
}

export function join248bitChunks(data: string[]): string[] {
  // numbers to hex in 248 bits
  const numberToHex248 = (num: number | bigint | string): string => {
    return `${BigInt(num).toString(16).padStart(62, '0')}`;
  };

  // decode number from raw hex input string
  const decode248BitEncoding = (hexArray: string[]): bigint[] => {
    const rawHex = hexArray.map(numberToHex248).join('');

    // pad '0' to the end of the string to make it a multiple of 64
    const paddedHexVals = rawHex.padEnd(rawHex.length + (64 - (rawHex.length % 64)), '0');

    // get number from every 64 hex digits chunk
    const result: bigint[] = [];
    for (let i = 0; i < paddedHexVals.length; i += 64) {
      result.push(BigInt(`0x${paddedHexVals.slice(i, i + 64)}`));
    }

    //remove trailing zero
    if (paddedHexVals.length !== rawHex.length && result[result.length - 1] === 0n) {
      result.pop();
    }

    return result;
  };

  return decode248BitEncoding(data).map((num) => `0x${num.toString(16).padStart(64, '0')}`);
}

export type argType = string | argType[];

// NOTE: argTypes must not contain `uint` , it should be `uint256` instead
export function warpEventCanonicalSignaturehash256(
  eventName: string,
  argTypes: argType[],
): { low: string; high: string } {
  const getArgStringRepresentation = (arg: argType): string => {
    if (typeof arg === 'string') return arg;
    return `(${arg.map(getArgStringRepresentation).join(',')})`;
  };

  const funcSignature = `${eventName}(${argTypes.map(getArgStringRepresentation).join(',')})`;
  return warpEventSignatureHash256FromString(funcSignature);
}

// NOTE: argTypes must not contain `uint` , it should be `uint256` instead
export function warpEventSignatureHash256FromString(functionSignature: string): {
  low: string;
  high: string;
} {
  const funcSignatureHash = createKeccakHash('keccak256').update(functionSignature).digest('hex');
  const [low, high] = toUintOrFelt(BigInt(`0x${funcSignatureHash}`), 256);

  return {
    low: `0x${low.toString(16)}`,
    high: `0x${high.toString(16)}`,
  };
}

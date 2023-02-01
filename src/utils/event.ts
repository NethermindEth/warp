import createKeccakHash from 'keccak';
import { EventFragment, Result, ParamType } from 'ethers/lib/utils';
import { safeNext, SolValue } from '../transcode/utils';
import { makeIterator } from '../transcode/encode';
import { warpInterface } from '../transcode/interface';
import { toUintOrFelt } from './export';

export type EventItem = { data: string[]; keys: string[]; order?: number };

export function decodeWarpEvent(fragment: EventFragment | string, warpEvent: EventItem): Result {
  // reverse 248 bit packing - concat string
  const data = warpEvent.data.join('');
  const result = warpInterface.decodeEventLog(fragment, data, warpEvent.keys);

  return result;
}

export function encodeWarpEvent(fragment: EventFragment, values: argType[], order = 0): EventItem {
  const { data, topics }: { data: string; topics: string[] } = warpInterface.encodeEventLog(
    fragment,
    values,
  );

  return { order, keys: topics, data: data.split('') };
}

export function splitInto248BitChunks(data: string): string[] {
  const paddedData = data.padEnd(data.length + (62 - (data.length % 62)), '0');

  const result = [];
  // get number from every 62 hex digits chunk
  for (let i = 0; i < paddedData.length; i += 62) {
    result.push(`${paddedData.slice(i, i + 62)}`);
  }

  if (paddedData.length !== data.length && BigInt(result.slice(-1)[0]) === 0n) {
    result.pop();
  }

  return result;
}

export function join248bitChunks(eventsLog: EventItem[]): EventItem[] {
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

  const events: EventItem[] = eventsLog.map((event) => {
    return {
      order: event.order,
      keys: decode248BitEncoding(event.keys).map((num) => `0x${num.toString(16)}`),
      data: decode248BitEncoding(event.data).map((num) => `0x${num.toString(16)}`),
    };
  });
  return events;
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

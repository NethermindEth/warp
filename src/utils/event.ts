import createKeccakHash from 'keccak';
import { EventFragment, Result } from 'ethers/lib/utils';
import { WarpInterface } from '../transcode/interface';
import { toUintOrFelt } from './export';

export type EventItem = { data: string[]; keys: string[]; order?: number };

export function decodeWarpEvent(fragment: EventFragment | string, warpEvent: EventItem): Result {
  warpEvent = join248bitChunks(warpEvent); // reverse 248 bit packing

  // Remove leading 0x from each element and join them
  const data = `0x${warpEvent.data.map((x) => x.slice(2)).join('')}`;

  const result = new WarpInterface(fragment).decodeEventLog(fragment, data, warpEvent.keys);
  return result;
}

export function encodeWarpEvent(fragment: EventFragment, values: argType[], order = 0): EventItem {
  const { data, topics }: { data: string; topics: string[] } = new WarpInterface(
    fragment,
  ).encodeEventLog(fragment, values);

  console.log('data', data);

  const topicFlatHex = '0x' + topics.map((x) => x.slice(2).padStart(64, '0')).join('');
  const topicItems248: string[] = splitInto248BitChunks(topicFlatHex.slice(2));
  const dataItems248: string[] = splitInto248BitChunks(data.slice(2));

  console.log(dataItems248);

  return { order, keys: topicItems248, data: dataItems248 };
}

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

export function join248bitChunks(eventLog: EventItem): EventItem {
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

  return {
    order: eventLog.order,
    keys: decode248BitEncoding(eventLog.keys).map(
      (num) => `0x${num.toString(16).padStart(64, '0')}`,
    ),
    data: decode248BitEncoding(eventLog.data).map(
      (num) => `0x${num.toString(16).padStart(64, '0')}`,
    ),
  };
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

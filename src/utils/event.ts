import createKeccakHash from 'keccak';
import { MASK_250 } from '../cairoUtilFuncGen/event';
import { toUintOrFelt } from './export';

export type EventItem = { data: string[]; keys: string[]; order: number };

export function decodeEventLog(eventsLog: EventItem[]): EventItem[] {
  // flat number to hex string with rjust 62
  const flatNumberToHexString = (num: number | bigint | string): string => {
    return `${BigInt(num).toString(16).padStart(62, '0')}`;
  };

  // decode number from raw hex input string
  const byte32numbers = (hexArray: string[]): bigint[] => {
    const raw_hex_input = hexArray.reduce((pv, cv) => {
      return `${pv}${flatNumberToHexString(cv)}`;
    }, '');

    // pad '0' to the end of the string to make it a multiple of 64
    const padded_hex_input = raw_hex_input.padEnd(
      raw_hex_input.length + (64 - (raw_hex_input.length % 64)),
      '0',
    );

    // get number from every 64 hex digits chunk
    const numbers: bigint[] = [];
    for (let i = 0; i < padded_hex_input.length; i += 64) {
      numbers.push(BigInt(`0x${padded_hex_input.slice(i, i + 64)}`));
    }

    //remove trailing zero
    if (padded_hex_input.length !== raw_hex_input.length && numbers[numbers.length - 1] === 0n) {
      numbers.pop();
    }

    return numbers;
  };

  const events: EventItem[] = eventsLog.map((event) => {
    return {
      order: event.order,
      keys: byte32numbers(event.keys).map((num) => `0x${num.toString(16)}`),
      data: byte32numbers(event.data).map((num) => `0x${num.toString(16)}`),
    };
  });
  return events;
}

export type argType = string | argType[];

// NOTE: argTypes must not contain `uint` , it should be `uint256` instead
export function warpEventCanonicalSignaturehash(eventName: string, argTypes: argType[]): string {
  const getArgStringRepresentation = (arg: argType): string => {
    if (typeof arg === 'string') return arg;
    return `(${arg.map(getArgStringRepresentation).join(',')})`;
  };

  const funcSignature = `${eventName}(${argTypes.map(getArgStringRepresentation).join(',')})`;
  const funcSignatureHash = createKeccakHash('keccak256').update(funcSignature).digest('hex');

  return `0x${(BigInt(`0x${funcSignatureHash}`) & MASK_250).toString(16)}`;
}

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
  const funcSignatureHash = createKeccakHash('keccak256').update(funcSignature).digest('hex');

  const splitHash: bigint[] = toUintOrFelt(BigInt(`0x${funcSignatureHash}`), 256);

  return {
    low: `0x${splitHash[0].toString(16)}`,
    high: `0x${splitHash[1].toString(16)}`,
  };
}

import { Dir, Value, File, EventItem } from './types';
import createKeccakHash from 'keccak';
import { MASK_250 } from '../../../src/export';

const capacity = (bits: number) => 2n ** BigInt(bits);
const max_uint = (bits: number) => capacity(bits) - 1n;
const max_int = (bits: number) => capacity(bits) / 2n - 1n;
const min_int = (bits: number) => -(capacity(bits) / 2n);

export const MIN_INT256 = min_int(256);
export const MAX_INT256 = max_int(256);
export const MIN_INT8 = min_int(8);
export const MAX_INT8 = max_int(8);

export function flatten(test: Dir | File): File[] {
  if (test instanceof Dir) {
    return test.tests.flatMap((subTest) => {
      subTest.name = `${test.name}/${subTest.name}`;
      return flatten(subTest);
    });
  } else {
    return [test];
  }
}

function stringFlatten_(val: Value): string[] {
  if (typeof val === 'string' || typeof val === 'number') {
    if (typeof val === 'string' && (val.startsWith('address@') || val.startsWith('hash@')))
      return [val];
    return [BigInt(val).toString()];
  }
  if (Array.isArray(val)) {
    return [val.length, ...val].flatMap(stringFlatten_);
  }
  throw new Error('Test expectation not a string or an int.');
}

export function stringFlatten(val: Value[]): string[] {
  return val.map(stringFlatten_).flat();
}

/**
 * Given a series of numbers it produces an array of it's bytes32 represenation
 * where the first value is the total amount of bytes
 * e.g. (3, 2) -> [64, 0 ..., 3, 0 ..., 2]
 * @param val number(s) to get it's byte32 representation
 * @returns bytes32 representation of arguments, where first element is total
 * amount of bytes
 */
export function getByte32Array(...val: (number | bigint)[]): string[] {
  return val.reduce(
    (pv, cv) => {
      pv.push(...numToByteX(BigInt(cv), 32));
      return pv;
    },
    [`${val.length * 32}`],
  );
}

/**
 * Same as getByte32Array but the number of bytes must to be specified for each element
 */
export function getByteXArray(...val: { byteSize: number; value: number | bigint }[]) {
  const byteArray = val.reduce((pv, cv) => {
    pv.push(...numToByteX(BigInt(cv.value), cv.byteSize));
    return pv;
  }, [] as string[]);
  return [`${byteArray.length}`, ...byteArray];
}

function numToByteX(val: bigint, byteSize: number): string[] {
  const byteArray: string[] = [];
  for (let i = 0; i < byteSize; i++) {
    const byte = val & BigInt(0xff);
    byteArray[i] = `${byte}`;
    val = (val - byte) / BigInt(256);
  }
  return byteArray.reverse();
}

export function toCairoUint256(val: number | bigint): [string, string] {
  val = BigInt(val);
  const low = val & ((1n << 128n) - 1n);
  const high = val >> 128n;
  return [low.toString(), high.toString()];
}

export function toCairoInt256(val: number | bigint): [string, string] {
  return toCairoUint256(BigInt.asUintN(256, BigInt(val)));
}

export const toCairoInt8 = (val: number | bigint) => BigInt.asUintN(8, BigInt(val)).toString();
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
    if (padded_hex_input.length != raw_hex_input.length && numbers[numbers.length - 1] === 0n) {
      numbers.pop();
    }

    return numbers;
  };

  const events: EventItem[] = eventsLog.map((event) => {
    return {
      order: event.order,
      keys: byte32numbers(event.keys).map((num) => num.toString()),
      data: byte32numbers(event.data).map((num) => num.toString()),
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
  const funcSignatureHash = createKeccakHash('keccak256')
    .update(funcSignature)
    .digest('hex')
    .slice(0, 8);
  const functionSignatureWarp = `${eventName}_${funcSignatureHash}(${argTypes
    .map(getArgStringRepresentation)
    .join(',')})`;

  return (
    BigInt(`0x${createKeccakHash('keccak256').update(functionSignatureWarp).digest('hex')}`) &
    MASK_250
  ).toString();
}

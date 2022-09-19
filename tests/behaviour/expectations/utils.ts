import { Dir, Value, File } from './types';

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
  const byteArray = [];
  for (let i = 0; i < byteSize; i++) {
    const byte = val & BigInt(0xff);
    byteArray[i] = `${byte}`;
    val = (val - byte) / BigInt(256);
  }
  return byteArray.reverse();
}

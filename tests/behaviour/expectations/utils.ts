import { Dir, Value, File } from './types';

export function flatten(test: Dir | File, filter?: string): File[] {
  if (test instanceof Dir) {
    return test.tests.flatMap((subTest) => {
      subTest.name = `${test.name}/${subTest.name}`;
      return flatten(subTest, filter);
    });
  } else {
    return [test];
  }
}

function stringFlatten_(val: Value): string[] {
  if (typeof val === 'string' || typeof val === 'number') {
    return [BigInt(val).toString()];
  }
  if (Array.isArray(val)) {
    return [val.length, ...val].flatMap(stringFlatten_);
  }
  throw new Error('Test expectation not a stirng or an int.');
}

export function stringFlatten(val: Value[]): string[] {
  return val.map(stringFlatten_).flat();
}

import { expectations as semantic } from './semantic';
import { expectations as behaviour } from './behaviour';
import { AsyncTest, File } from './types';

// Don't be fooled, process.env.BLAH can be undefined
function filterTests(
  syncTests: File[],
  asyncTests: AsyncTest[],
  filter = process.env.FILTER,
): AsyncTest[] {
  const tests = [...syncTests.map(AsyncTest.fromSync), ...asyncTests];
  if (filter === undefined) {
    return tests;
  }

  console.log(`Using filter '${filter}' on behaviour test paths`);
  return tests.filter((test) => test.name.includes(filter));
}

export const expectations = filterTests(behaviour, semantic, 'dynamic_array_return_index');

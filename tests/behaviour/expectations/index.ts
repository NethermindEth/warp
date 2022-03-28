import { expectations as semantic } from './semantic';
import { expectations as behaviour } from './behaviour';
import { File } from './types';

// Don't be fooled, process.env.BLAH can be undefined
function filterTests(tests: File[], filter = process.env.FILTER): File[] {
  if (filter === undefined) {
    return tests;
  }

  console.log(`Using filter '${filter}' on behaviour test paths`);
  return tests.filter((test) => test.name.includes(filter));
}

export const expectations = filterTests([...behaviour, ...semantic], 'value_passing');

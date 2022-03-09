import { expectations as semantic } from './semantic';
import { expectations as behaviour } from './behaviour';
import { File } from './types';

function filterTests(tests: File[], filter?: string): File[] {
  return filter === undefined ? tests : tests.filter((test) => test.name.includes(filter));
}

export const expectations = filterTests([...behaviour, ...semantic]);

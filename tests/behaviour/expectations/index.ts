import { expectations as semantic } from './semantic';
import { expectations as behaviour } from './behaviour';
import { exceptions } from './semantic_exceptions';
import { AsyncTest, Expect, File } from './types';
import { readFileSync } from 'fs-extra';

function getSyncTestFromPath(path: string): File {
  const text = readFileSync(path + '.sol', 'utf-8');

  const contractNames = [...text.matchAll(/contract (\w+)/g)].map(([_, name]) => name);
  const lastContract = contractNames[contractNames.length - 1];

  const lines = text.replace(/\s+$/gm, '').split('\n');
  const testStartIndex = lines.indexOf('// ----');
  const tests = lines.slice(testStartIndex + 1);
  const expects = tests.map((test) => {
    const matches = [...test.matchAll(/\/\/ (\S*)\(.*\): (.*) -> ([^ ,\n]*)/gm)];
    return Expect.Simple(
      matches[0][1],
      matches[0][2].split(','),
      matches[0][3] === 'FAILURE' ? null : [matches[0][3]],
    );
  });
  return File.Simple(path, expects, lastContract);
}

// Don't be fooled, process.env.BLAH can be undefined
function filterTests(
  syncTests: File[],
  asyncTests: AsyncTest[],
  filter = process.env.FILTER,
): AsyncTest[] {
  // Separate the exceptions from the selected semanticTests
  // into a different array 'newSyncTests'
  const newAsyncTests = asyncTests.filter((test) => !exceptions.includes(test.name));
  const newSyncTests = asyncTests.filter((test) => exceptions.includes(test.name));

  syncTests = [...syncTests, ...newSyncTests.map((test) => getSyncTestFromPath(test.name))];
  const tests = [...syncTests.map(AsyncTest.fromSync), ...newAsyncTests];
  if (filter === undefined) {
    return tests;
  }

  console.log(`Using filter '${filter}' on behaviour test paths`);
  return tests.filter((test) => test.name.includes(filter));
}

export const expectations = filterTests(behaviour, semantic, 'new');

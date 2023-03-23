import { describe } from 'mocha';
import {
  ResultType,
  postTestCleanup,
  preTestChecks,
  getTestsWithUnexpectedResults,
  printResults,
  runCairoFileTest,
  runSolFileTest,
  solCompileResultTypes,
  cairoCompileResultTypes,
} from '../tests/testing';

import { findSolSourceFilePaths } from '../src/export';
import { error } from '../src/utils/formatting';
import path from 'path';
import { expect } from 'chai';

const TIME_LIMIT = 2 * 60 * 60 * 1000;

const WARP_TEST = 'warpTest';
const WARP_COMPILATION_TEST_PATH = 'exampleContracts';
const WARP_TEST_FOLDER = path.join(WARP_TEST, WARP_COMPILATION_TEST_PATH);

const expectedResults = new Map<string, ResultType>(
  [
    ['ERC20.sol', 'Success'],
    ['address/7/padding.sol', 'Success'],
    ['address/7/primeField.sol', 'Success'],
    ['address/8/padding.sol', 'Success'],
    ['address/8/primeField.sol', 'Success'],
    ['comments.sol', 'Success'],
    ['enums.sol', 'Success'],
    ['fileWithMinusSignIncluded-.sol', 'Success'],
    ['freeFunction.sol', 'Success'],
    ['idManglingTest9.sol', 'Success'],
    ['inheritance/simple.sol', 'Success'],
    ['inheritance/super/base.sol', 'Success'],
    ['inheritance/super/mid.sol', 'Success'],
    ['inheritance/variables.sol', 'Success'],
    ['internalFunctions.sol', 'Success'],
    ['lib.sol', 'Success'],
    ['multipleVariables.sol', 'Success'],
    ['nestedStructs.sol', 'Success'],
    ['simpleStorageVar.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['structs.sol', 'Success'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['userdefinedtypes.sol', 'Success'],
    ['usingFor/imports/userDefined.sol', 'Success'],
    ['usingFor/private.sol', 'Success'],
  ].map(([key, result]) => {
    return [path.join(WARP_TEST_FOLDER, key), result] as [string, ResultType];
  }),
);

// Transpiling the solidity files using the `bin/warp transpile` CLI command.
describe('Running compilation tests', function () {
  this.timeout(TIME_LIMIT);

  let onlyResults: boolean, unsafe: boolean, force: boolean, exact: boolean;
  let filter: string | undefined;

  const results = new Map<string, ResultType>();

  this.beforeAll(() => {
    onlyResults = process.argv.includes('--only-results') ? true : false;
    unsafe = process.argv.includes('--unsafe') ? true : false;
    force = process.argv.includes('--force') ? true : false;
    exact = process.argv.includes('--exact') ? true : false;
    if (force) {
      postTestCleanup(WARP_TEST_FOLDER);
    } else {
      if (!preTestChecks(WARP_TEST_FOLDER)) return;
    }
    filter = process.env.FILTER;
  });

  describe('Running warp compilation on solidity files', async function () {
    findSolSourceFilePaths(WARP_COMPILATION_TEST_PATH, true).forEach((file) => {
      if (filter === undefined || file.includes(filter)) {
        let compileResult: { result: ResultType; cairoFiles?: string[] };
        const expectedResult: ResultType | undefined = expectedResults.get(
          path.join(WARP_TEST, file),
        );
        it(`Running warp compile on ${file}`, async () => {
          compileResult = runSolFileTest(WARP_TEST, file, results, onlyResults, unsafe);
          expect(expectedResult).to.not.be.undefined;
          if (expectedResult === 'Success') {
            expect(compileResult.result).to.equal('Success');
          }
          if (expectedResult !== undefined && solCompileResultTypes.includes(expectedResult)) {
            expect(compileResult.result).to.equal(expectedResult);
          }
        });
        if (expectedResult !== undefined && cairoCompileResultTypes.includes(expectedResult)) {
          it(`Running cairo compile on ${file}`, async () => {
            if (compileResult.cairoFiles !== undefined) {
              compileResult.cairoFiles.forEach((cairoFile) => {
                const cairoCompileResult = runCairoFileTest(cairoFile, results, onlyResults);
                expect(cairoCompileResult).to.equal(expectedResult);
              });
            }
          });
        }
      }
    });
  });

  this.afterAll(() => {
    const testsWithUnexpectedResults = getTestsWithUnexpectedResults(expectedResults, results);
    printResults(expectedResults, results, testsWithUnexpectedResults);
    postTestCleanup(WARP_TEST_FOLDER);
    if (exact) {
      if (testsWithUnexpectedResults.length > 0) {
        throw new Error(
          error(`${testsWithUnexpectedResults.length} test(s) had unexpected outcome(s)`),
        );
      }
    }
  });
});

import { describe } from 'mocha';
import { ResultType, runTests } from '../tests/testing';

import path from 'path';

const WARP_TEST = 'warpTest';
const WARP_COMPILATION_TEST_PATH = 'exampleContracts';
const WARP_TEST_FOLDER = path.join(WARP_TEST, WARP_COMPILATION_TEST_PATH);

const expectedResults = new Map<string, ResultType>(
  [['ERC20.sol', 'Success']].map(([key, result]) => {
    return [path.join(WARP_TEST_FOLDER, key), result] as [string, ResultType];
  }),
);

describe('Compilation tests execution started', () =>
  runTests(
    expectedResults,
    WARP_TEST,
    WARP_TEST_FOLDER,
    WARP_COMPILATION_TEST_PATH,
    'exampleContracts',
  ));

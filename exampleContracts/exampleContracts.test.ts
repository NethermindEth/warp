import { describe } from 'mocha';
import { ResultType, runTests } from '../tests/testing';

import path from 'path';

const WARP_TEST = 'warpTest';
const WARP_COMPILATION_TEST_PATH = 'exampleContracts';
const WARP_TEST_FOLDER = path.join(WARP_TEST, WARP_COMPILATION_TEST_PATH);

const expectedResults = new Map<string, ResultType>(
  [
    ['structs.sol', 'Success'],
    ['ERC20.sol', 'Success'],
    ['explicitTypeConversion.sol', 'Success'],
    ['nestedStructs.sol', 'Success'],
    ['variables.sol', 'Success'],
    ['padding.sol', 'Success'],
    ['simpleStorageVar.sol', 'Success'],
    ['freeFunction.sol', 'Success'],
    ['comments.sol', 'Success'],
    ['enums.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['lib.sol', 'Success'],
    ['idManglingTest9.sol', 'Success'],
    ['base.sol', 'Success'],
    ['multipleVariables.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['simple.sol', 'Success'],
    ['private.sol', 'Success'],
    ['primeField.sol', 'Success'],
    ['fileWithMinusSignIncluded-.sol', 'Success'],
    ['mid.sol', 'Success'],
    ['inheritance/variables.sol', 'Success'],
    ['inheritance/simple.sol', 'Success'],
    ['inheritance/super/base.sol', 'Success'],
    ['inheritance/super/mid.sol', 'Success'],
    ['address/7/padding.sol', 'Success'],
    ['address/7/primeField.sol', 'Success'],
    ['address/8/padding.sol', 'Success'],
    ['address/8/primeField.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
  ].map(([key, result]) => {
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

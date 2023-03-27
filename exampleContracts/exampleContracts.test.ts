import { describe } from 'mocha';
import { ResultType, runTests } from '../tests/testing';

import path from 'path';

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
    ['lib.sol', 'Success'],
    ['multipleVariables.sol', 'Success'],
    ['nestedStructs.sol', 'Success'],
    ['simpleStorageVar.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['structs.sol', 'Success'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['usingFor/private.sol', 'Success'],
    ['usingFor/simple.sol', 'Success'],
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

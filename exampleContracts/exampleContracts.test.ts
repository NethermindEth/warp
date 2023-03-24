import { describe } from 'mocha';
import { ResultType, runTests } from '../tests/testing';

import path from 'path';

const WARP_TEST = 'warpTest';
const WARP_COMPILATION_TEST_PATH = 'exampleContracts';
const WARP_TEST_FOLDER = path.join(WARP_TEST, WARP_COMPILATION_TEST_PATH);

const expectedResults = new Map<string, ResultType>(
  [
    ['nestedStructs.sol', 'Success'],
    ['usingFor/simple.sol', 'Success'],
    ['ERC20.sol', 'Success'],
    ['freeFunction.sol', 'Success'],
    ['address/7/primeField.sol', 'Success'],
    ['inheritance/super/base.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['lib.sol', 'Success'],
    ['multipleVariables.sol', 'Success'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['fileWithMinusSignIncluded-.sol', 'Success'],
    ['inheritance/super/mid.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['usingFor/private.sol', 'Success'],
    ['address/8/padding.sol', 'Success'],
    ['inheritance/variables.sol', 'Success'],
    ['simpleStorageVar.sol', 'Success'],
    ['address/8/primeField.sol', 'Success'],
    ['enums.sol', 'Success'],
    ['comments.sol', 'Success'],
    ['inheritance/simple.sol', 'Success'],
    ['address/7/padding.sol', 'Success'],
    ['structs.sol', 'Success'],
    ['idManglingTest9.sol', 'Success'],
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

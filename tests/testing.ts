import path from 'path';
import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths, findSolSourceFilePaths } from '../src/io';
import { compileSolFiles } from '../src/solCompile';
import { compileCairo } from '../src/starknetCli';
import { transpile } from '../src/transpiler';
import {
  NotSupportedYetError,
  TranspilationAbandonedError,
  WillNotSupportError,
} from '../src/utils/errors';
import { groupBy, printCompileErrors } from '../src/utils/utils';
import * as fs from 'fs';
import { outputFileSync } from '../src/utils/fs';
import { error } from '../src/utils/formatting';

const WARP_TEST = 'warpTest';
const WARP_TEST_FOLDER = 'testsContracts';
const WARP_TEST_FOLDER_PATH = path.join(WARP_TEST, WARP_TEST_FOLDER);
const WARP_EXAMPLES_FOLDER = 'exampleContracts';
const WARP_EXAMPLES_FOLDER_PATH = path.join(WARP_TEST, WARP_EXAMPLES_FOLDER);

type ResultType =
  | 'CairoCompileFailed'
  | 'SolCompileFailed'
  | 'Success'
  | 'NotSupportedYet'
  | 'WillNotSupport'
  | 'TranspilationFailed';

const ResultTypeOrder = [
  'Success',
  'CairoCompileFailed',
  'NotSupportedYet',
  'TranspilationFailed',
  'WillNotSupport',
  'SolCompileFailed',
];

const expectedResults = new Map<string, ResultType>(
  [
    ['address/8/160NotAllowed.sol', 'SolCompileFailed'],
    ['address/8/256Address.sol', 'Success'],
    ['address/8/maxPrime.sol', 'SolCompileFailed'],
    ['address/8/maxPrimeExplicit.sol', 'Success'],
    ['address/8/padding.sol', 'Success'],
    ['address/8/primeField.sol', 'Success'],
    ['address/7/160NotAllowed.sol', 'SolCompileFailed'],
    ['address/7/256Address.sol', 'Success'],
    ['address/7/maxPrime.sol', 'SolCompileFailed'],
    ['address/7/maxPrimeExplicit.sol', 'Success'],
    ['address/7/padding.sol', 'Success'],
    ['address/7/primeField.sol', 'Success'],
    ['arrayLength.sol', 'Success'],
    ['ERC20Storage.sol', 'Success'],
    ['boolOpNoSideEffects.sol', 'Success'],
    ['boolOpSideEffects.sol', 'Success'],
    ['bytesXAccess.sol', 'Success'],
    ['c2c.sol', 'Success'],
    ['conditional.sol', 'Success'],
    ['conditionalSimple.sol', 'Success'],
    ['contractToContract.sol', 'Success'],
    ['calldatacopy.sol', 'WillNotSupport'],
    ['calldataCrossContractCalls.sol', 'Success'],
    ['calldataload.sol', 'WillNotSupport'],
    ['calldatasize.sol', 'WillNotSupport'],
    ['comments.sol', 'Success'],
    ['constructorsDyn.sol', 'Success'],
    ['constructorsNonDyn.sol', 'Success'],
    ['contractsAsInput.sol', 'Success'],
    ['dai.sol', 'Success'],
    ['delete.sol', 'SolCompileFailed'],
    ['deleteUses.sol', 'Success'],
    ['enums.sol', 'Success'],
    ['enums7.sol', 'Success'],
    ['errorHandling/assert.sol', 'Success'],
    ['errorHandling/require.sol', 'Success'],
    ['errorHandling/revert.sol', 'Success'],
    ['events.sol', 'Success'],
    ['expressionSplitter/assignSimple.sol', 'Success'],
    ['expressionSplitter/funcCallSimple.sol', 'Success'],
    ['expressionSplitter/tupleAssign.sol', 'Success'],
    ['externalFunction.sol', 'Success'],
    ['fallbackWithoutArgs.sol', 'Success'],
    ['fallbackWithArgs.sol', 'WillNotSupport'],
    ['fileWithMinusSignIncluded-.sol', 'Success'],
    ['freeFunction.sol', 'Success'],
    ['freeStruct.sol', 'Success'],
    ['functionWithNestedReturn.sol', 'Success'],
    ['functionArgumentConversions.sol', 'Success'],
    ['functionInputs/arrayTest/arrayArrayArray.sol', 'Success'],
    ['functionInputs/arrayTest/arrayArrayBytes.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayArrayStruct.sol', 'Success'],
    ['functionInputs/arrayTest/arrayDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayStructArray.sol', 'Success'],
    ['functionInputs/arrayTest/arrayStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayStructStruct.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayArrayArray.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayArrayStruct.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayStructArray.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayStructStruct.sol', 'Success'],
    ['functionInputs/structTest/structArrayArray.sol', 'Success'],
    ['functionInputs/structTest/structArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structArrayStruct.sol', 'Success'],
    ['functionInputs/structTest/structDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structString.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructArray.sol', 'Success'],
    ['functionInputs/structTest/structStructBytes.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructStruct.sol', 'Success'],
    ['idManglingTest8.sol', 'Success'],
    ['idManglingTest9.sol', 'Success'],
    ['ifFlattening.sol', 'Success'],
    ['implicitsFromStub.sol', 'Success'],
    ['imports/importContract.sol', 'Success'],
    ['imports/importEnum.sol', 'Success'],
    ['imports/importfrom.sol', 'Success'],
    ['imports/importInterface.sol', 'Success'],
    ['imports/importLibrary.sol', 'Success'],
    ['imports/importStruct.sol', 'Success'],
    ['indexParam.sol', 'Success'],
    ['inheritance/simple.sol', 'Success'],
    ['inheritance/super/base.sol', 'Success'],
    ['inheritance/super/derived.sol', 'Success'],
    ['inheritance/super/mid.sol', 'Success'],
    ['inheritance/variables.sol', 'Success'],
    ['interfaces.sol', 'Success'],
    ['interfaceFromBaseContract.sol', 'Success'],
    ['internalFunctions.sol', 'Success'],
    ['invalidSolidity.sol', 'SolCompileFailed'],
    ['lib.sol', 'Success'],
    ['libraries/usingForStar.sol', 'Success'],
    ['literalOperations.sol', 'Success'],
    ['loops/forLoopWithBreak.sol', 'Success'],
    ['loops/forLoopWithContinue.sol', 'Success'],
    ['loops/forLoopWithNestedReturn.sol', 'Success'],
    ['rejectedTerms/contractName$.sol', 'WillNotSupport'],
    ['rejectedTerms/reservedContract.sol', 'WillNotSupport'],
    ['rejectedTerms/contractNameLib.sol', 'WillNotSupport'],
    ['memberAccess/balance.sol', 'WillNotSupport'],
    ['memberAccess/call.sol', 'WillNotSupport'],
    ['memberAccess/code.sol', 'WillNotSupport'],
    ['memberAccess/codehash.sol', 'WillNotSupport'],
    ['memberAccess/delegatecall.sol', 'WillNotSupport'],
    ['memberAccess/send.sol', 'WillNotSupport'],
    ['memberAccess/staticcall.sol', 'WillNotSupport'],
    ['memberAccess/transfer.sol', 'WillNotSupport'],
    ['msg.sol', 'WillNotSupport'],
    ['multipleVariables.sol', 'Success'],
    ['mutableReferences/deepDelete.sol', 'Success'],
    ['mutableReferences/memory.sol', 'Success'],
    ['mutableReferences/mutableReferences.sol', 'Success'],
    ['mutableReferences/scalarStorage.sol', 'Success'],
    ['namedArgs/constructor.sol', 'Success'],
    ['namedArgs/eventsAndErrors.sol', 'Success'],
    ['namedArgs/function.sol', 'Success'],
    ['nestedStaticArrayStruct.sol', 'Success'],
    ['nestedStructStaticArray.sol', 'Success'],
    ['nestedStructs.sol', 'Success'],
    ['nestedTuple.sol', 'WillNotSupport'],
    ['oldCodeGenErr.sol', 'WillNotSupport'],
    ['oldCodeGenErr7.sol', 'WillNotSupport'],
    ['payableFunction.sol', 'Success'],
    ['pureFunction.sol', 'Success'],
    ['rejectNaming.sol', 'WillNotSupport'],
    ['removeUnreachableFunctions.sol', 'Success'],
    ['returnDynArray.sol', 'Success'],
    ['returnVarCapturing.sol', 'Success'],
    ['returndatasize.sol', 'WillNotSupport'],
    ['returnInserter.sol', 'Success'],
    ['simpleStorageVar.sol', 'Success'],
    ['sstoreSload.sol', 'WillNotSupport'],
    ['stateVariables/scalars.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['stateVariables/arrays.sol', 'Success'],
    ['stateVariables/arraysInit.sol', 'Success'],
    ['stateVariables/mappings.sol', 'Success'],
    ['stateVariables/structs.sol', 'Success'],
    ['stateVariables/structsNested.sol', 'Success'],
    ['stateVariables/misc.sol', 'Success'],
    ['structs.sol', 'Success'],
    ['thisMethodsCall.sol', 'Success'],
    ['tryCatch.sol', 'WillNotSupport'],
    ['tupleAssignment7.sol', 'Success'],
    ['tupleAssignment8.sol', 'SolCompileFailed'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
    ['typeConversion/implicitReturnConversion.sol', 'Success'],
    ['typeConversion/implicitTypeConv.sol', 'Success'],
    ['typeConversion/shifts.sol', 'Success'],
    ['typeConversion/unusedArrayConversion.sol', 'Success'],
    ['typeMinMax.sol', 'Success'],
    ['uint256StaticArrayCasting.sol', 'Success'],
    ['typestrings/basicArrays.sol', 'Success'],
    ['typestrings/scalars.sol', 'Success'],
    ['typestrings/structArrays.sol', 'Success'],
    ['typestrings/structs.sol', 'Success'],
    ['units.sol', 'Success'],
    ['unsupportedFunctions/abi.sol', `Success`],
    ['unsupportedFunctions/keccak256.sol', `Success`],
    ['unsupportedFunctions/ecrecover.sol', `Success`],
    ['unsupportedFunctions/addmod.sol', `Success`],
    ['unsupportedFunctions/gasleft.sol', `WillNotSupport`],
    // Supported precompiles
    ['precompiles/ecrecover.sol', 'Success'],
    ['precompiles/keccak256.sol', 'Success'],
    // Uses bytes memory
    ['unsupportedFunctions/shadowAbi.sol', `Success`],
    // Uses bytes memory
    ['unsupportedFunctions/shadowKeccak256.sol', `Success`],
    ['unsupportedFunctions/shadowEcrecover.sol', `Success`],
    // uses modulo (%)
    ['unsupportedFunctions/shadowAddmod.sol', 'Success'],
    // Uses WARP_STORAGE in a free function
    ['usingFor/imports/userDefined.sol', 'Success'],
    // global_directive.sol cannot resolve struct when file imported as identifier
    ['usingFor/imports/globalDirective.sol', 'Success'],
    ['usingFor/complexLibraries.sol', 'Success'],
    ['usingFor/function.sol', 'WillNotSupport'],
    ['usingFor/private.sol', 'Success'],
    ['usingFor/library.sol', 'Success'],
    ['usingFor/simple.sol', 'Success'],
    ['usingReturnValues.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['userdefinedtypes.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['variableDeclarations.sol', 'Success'],
    ['viewFunction.sol', 'Success'],
    ['typestrings/enumArrays.sol', 'Success'],
    //uses 'this' keyword in the constructor
    ['thisAtConstructor/externalFunctionCallAtConstruction.sol', 'WillNotSupport'],
    ['thisAtConstructor/multipleExternalFunctionCallsAtConstruction.sol', 'WillNotSupport'],
    ['thisAtConstructor/validThisUseAtConstructor.sol', 'Success'],
  ].map(([key, result]) => {
    return [path.join(WARP_TEST_FOLDER_PATH, key), result] as [string, ResultType];
  }),
);

export function runTests(force: boolean, onlyResults: boolean, unsafe = false, exact = false) {
  if (force) {
    postTestCleanup();
  } else if (!preTestChecks()) return;

  const filter = process.env.FILTER;

  // Run tests contracts
  const testsResults = new Map<string, ResultType>();
  findSolSourceFilePaths(WARP_TEST_FOLDER, true).forEach((file) => {
    if (filter === undefined || file.includes(filter)) {
      runSolFileTest(file, testsResults, onlyResults, unsafe);
    }
  });
  findCairoSourceFilePaths(WARP_TEST_FOLDER_PATH, true).forEach((file) => {
    runCairoFileTest(file, testsResults, onlyResults);
  });

  // Run examples contracts
  const exampleResults = new Map<string, ResultType>();
  findSolSourceFilePaths(WARP_EXAMPLES_FOLDER, true).forEach((file) => {
    if (filter === undefined || file.includes(filter)) {
      runSolFileTest(file, exampleResults, onlyResults, unsafe);
    }
  });
  findCairoSourceFilePaths(WARP_EXAMPLES_FOLDER_PATH, true).forEach((file) => {
    runCairoFileTest(file, exampleResults, onlyResults);
  });

  const testsWithUnexpectedResults = getTestsWithUnexpectedResults(testsResults)
    // all examples should be successful
    .concat(getTestsWithUnsuccessfullResults(exampleResults));

  printResults(
    new Map<string, ResultType>([...testsResults, ...exampleResults]),
    testsWithUnexpectedResults,
  );
  postTestCleanup();
  if (exact) {
    if (testsWithUnexpectedResults.length > 0) {
      throw new Error(
        error(`${testsWithUnexpectedResults.length} test(s) had unexpected outcome(s)`),
      );
    }
  }
}

function preTestChecks(): boolean {
  if (!checkNoCairo(WARP_TEST) || !checkNoJson(WARP_TEST)) {
    console.log(`Please remove ${WARP_TEST}, or run with -f to delete it`);
    return false;
  }
  if (!checkNoJson('warplib')) {
    console.log('Please remove all json files from warplib, or run with -f to delete them');
    return false;
  }
  return true;
}

function runSolFileTest(
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  unsafe: boolean,
): void {
  console.log(`Warping ${file}`);
  const mangledPath = path.join(WARP_TEST, file);
  try {
    transpile(compileSolFiles([file], { warnings: false }), { strict: true, dev: true }).forEach(
      ([file, cairo]) => outputFileSync(path.join(WARP_TEST, file), cairo),
    );
    results.set(mangledPath, 'Success');
  } catch (e) {
    if (e instanceof CompileFailedError) {
      if (!onlyResults) printCompileErrors(e);
      results.set(mangledPath, 'SolCompileFailed');
    } else if (e instanceof TranspilationAbandonedError) {
      if (e instanceof NotSupportedYetError) {
        results.set(mangledPath, 'NotSupportedYet');
      } else if (e instanceof WillNotSupportError) {
        results.set(mangledPath, 'WillNotSupport');
      } else {
        results.set(mangledPath, 'TranspilationFailed');
        if (unsafe) throw e;
      }
      if (!onlyResults) console.log(`Transpilation abandoned ${e.message}`);
    } else {
      if (!onlyResults) console.log('Transpilation failed');
      if (!onlyResults) console.log(e);
      results.set(mangledPath, 'TranspilationFailed');
      if (unsafe) throw e;
    }
  }
}

function runCairoFileTest(
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  throwError = false,
): void {
  if (!onlyResults) console.log(`Compiling ${file}`);
  if (compileCairo(file).success) {
    results.set(file, 'Success');
  } else {
    if (throwError) {
      throw new Error(error(`Compilation of ${file} failed`));
    }
    results.set(removeExtension(file), 'CairoCompileFailed');
  }
}

function combineResults(results: ResultType[]): ResultType {
  return results.reduce((prev, current) =>
    ResultTypeOrder.indexOf(prev) > ResultTypeOrder.indexOf(current) ? prev : current,
  );
}

function getTestsWithResults(
  results: Map<string, ResultType>,
  getExpectedResult: (file: string) => ResultType,
  unexpected = false, // return all tests that have a result different than the expected
): string[] {
  const testsWithResults: string[] = [];
  const groupedResults = groupBy([...results.entries()], ([file, _]) =>
    file.endsWith('.cairo') ? path.dirname(file) : file,
  );
  [...groupedResults.entries()].forEach((e) => {
    const expected = getExpectedResult(e[0]);
    const collectiveResult = combineResults(
      [...e[1]].reduce((res, [_, result]) => [...res, result], <ResultType[]>[]),
    );
    if (unexpected !== (collectiveResult === expected)) {
      testsWithResults.push(e[0]);
    }
  });
  return testsWithResults;
}

function getTestsWithUnexpectedResults(results: Map<string, ResultType>): string[] {
  const expectedResults = new Map<string, ResultType>();
  [...results.entries()].forEach(([file, result]) => {
    if (file.endsWith('.cairo')) {
      expectedResults.set(path.dirname(file), result);
    }
  });
  return getTestsWithResults(results, (file) => expectedResults.get(file) ?? 'Success', true);
}

function getTestsWithUnsuccessfullResults(results: Map<string, ResultType>): string[] {
  return getTestsWithResults(results, (_) => 'Success', true);
}

function printResults(results: Map<string, ResultType>, unexpectedResults: string[]): void {
  const totals = new Map<ResultType, number>();
  [...results.values()].forEach((r) => totals.set(r, (totals.get(r) ?? 0) + 1));
  console.log(
    `[${[...totals.entries()]
      .map(([result, count]) => `${result}: ${count}/${results.size}`)
      .join(', ')}]`,
  );
  if (unexpectedResults.length === 0) {
    console.log(`CI passed. All outcomes are as expected.`);
  } else {
    console.log(`CI failed. ${unexpectedResults.length} test(s) had unexpected outcome(s).`);
    unexpectedResults.map((o) => {
      console.log(`\nTest: ${o}`);
      console.log(`Expected outcome: ${expectedResults.get(o)}`);
      console.log(`Actual outcome:`);
      const Actual = new Map<string, ResultType>();
      results.forEach((value, key) => {
        if (key.startsWith(o)) {
          Actual.set(key, value);
        }
      });
      Actual.forEach((value, key) => {
        console.log(key + ' : ' + value);
      });
    });
    console.log('\n');
  }
}

function checkNoCairo(path: string): boolean {
  return !fs.existsSync(path) || findCairoSourceFilePaths(path, true).length === 0;
}

function checkNoJson(path: string): boolean {
  return (
    !fs.existsSync(path) ||
    findAllFiles(path, true).filter((file) => file.endsWith('.json')).length === 0
  );
}

function postTestCleanup(): void {
  deleteJson('warplib');
  fs.rmSync(WARP_TEST, { recursive: true, force: true });
}

function deleteJson(path: string): void {
  findAllFiles(path, true)
    .filter((file) => file.endsWith('.json'))
    .forEach((file) => fs.unlinkSync(file));
}

function removeExtension(file: string): string {
  const index = file.lastIndexOf('.');
  if (index === -1) return file;
  return file.slice(0, index);
}

import path from 'path';
import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths, findSolSourceFilePaths } from '../src/io';
import { compileSolFiles } from '../src/solCompile';
import { enqueueCompileCairo } from '../src/starknetCli';
import { transpile } from '../src/transpiler';
import {
  NotSupportedYetError,
  TranspilationAbandonedError,
  WillNotSupportError,
} from '../src/utils/errors';
import { groupBy, printCompileErrors } from '../src/utils/utils';
import * as fs from 'fs/promises';
import Bottleneck from 'bottleneck';
import { outputFile } from '../src/utils/fs';
import { error } from '../src/utils/formatting';

const WARP_TEST = 'warpTest';
const WARP_TEST_FOLDER = path.join(WARP_TEST, 'exampleContracts');
const PARALLEL_COUNT = 8;

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
    ['exampleContracts/arrayLength.sol', 'Success'],
    ['exampleContracts/ERC20.sol', 'Success'],
    ['exampleContracts/ERC20Storage.sol', 'Success'],
    ['exampleContracts/address/8/160NotAllowed.sol', 'SolCompileFailed'],
    ['exampleContracts/address/8/256Address.sol', 'Success'],
    ['exampleContracts/address/8/maxPrime.sol', 'SolCompileFailed'],
    ['exampleContracts/address/8/maxPrimeExplicit.sol', 'Success'],
    ['exampleContracts/address/8/padding.sol', 'Success'],
    ['exampleContracts/address/8/primeField.sol', 'Success'],
    ['exampleContracts/address/7/160NotAllowed.sol', 'SolCompileFailed'],
    ['exampleContracts/address/7/256Address.sol', 'Success'],
    ['exampleContracts/address/7/maxPrime.sol', 'SolCompileFailed'],
    ['exampleContracts/address/7/maxPrimeExplicit.sol', 'Success'],
    ['exampleContracts/address/7/padding.sol', 'Success'],
    ['exampleContracts/address/7/primeField.sol', 'Success'],
    ['exampleContracts/boolOpNoSideEffects.sol', 'Success'],
    ['exampleContracts/boolOpSideEffects.sol', 'Success'],
    ['exampleContracts/bytesXAccess.sol', 'Success'],
    ['exampleContracts/c2c.sol', 'Success'],
    // Uses conditionals explicitly
    ['exampleContracts/conditional.sol', 'Success'],
    ['exampleContracts/conditionalSimple.sol', 'Success'],
    ['exampleContracts/contractToContract.sol', 'Success'],
    ['exampleContracts/calldatacopy.sol', 'WillNotSupport'],
    ['exampleContracts/calldataCrossContractCalls.sol', 'Success'],
    ['exampleContracts/calldataload.sol', 'WillNotSupport'],
    ['exampleContracts/calldatasize.sol', 'WillNotSupport'],
    ['exampleContracts/comments.sol', 'Success'],
    ['exampleContracts/constructorsDyn.sol', 'Success'],
    ['exampleContracts/constructorsNonDyn.sol', 'Success'],
    ['exampleContracts/contractsAsInput.sol', 'Success'],
    ['exampleContracts/dai.sol', 'Success'],
    ['exampleContracts/delete.sol', 'SolCompileFailed'],
    ['exampleContracts/deleteUses.sol', 'Success'],
    ['exampleContracts/enums.sol', 'Success'],
    ['exampleContracts/enums7.sol', 'Success'],
    ['exampleContracts/errorHandling/assert.sol', 'Success'],
    ['exampleContracts/errorHandling/require.sol', 'Success'],
    ['exampleContracts/errorHandling/revert.sol', 'Success'],
    ['exampleContracts/events.sol', 'Success'],
    ['exampleContracts/expressionSplitter/assignSimple.sol', 'Success'],
    ['exampleContracts/expressionSplitter/funcCallSimple.sol', 'Success'],
    ['exampleContracts/expressionSplitter/tupleAssign.sol', 'Success'],
    ['exampleContracts/externalFunction.sol', 'Success'],
    ['exampleContracts/fallbackWithoutArgs.sol', 'Success'],
    ['exampleContracts/fallbackWithArgs.sol', 'WillNotSupport'],
    // Cannot import with a - in the filename
    ['exampleContracts/fileWithMinusSignIncluded-.sol', 'Success'],
    // Typestring for the internal function call doesn't contain a location so a read isn't generated
    ['exampleContracts/freeFunction.sol', 'Success'],
    ['exampleContracts/freeStruct.sol', 'Success'],
    ['exampleContracts/functionWithNestedReturn.sol', 'Success'],
    ['exampleContracts/functionArgumentConversions.sol', 'Success'],
    ['exampleContracts/functionInputs/arrayTest/arrayArrayArray.sol', 'Success'],
    ['exampleContracts/functionInputs/arrayTest/arrayArrayBytes.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayArrayStruct.sol', 'Success'],
    ['exampleContracts/functionInputs/arrayTest/arrayDynArrayArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayDynArrayStruct.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayStructArray.sol', 'Success'],
    ['exampleContracts/functionInputs/arrayTest/arrayStructDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/arrayTest/arrayStructStruct.sol', 'Success'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayArrayArray.sol', 'Success'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayArrayStruct.sol', 'Success'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayDynArrayArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayDynArrayStruct.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayStructArray.sol', 'Success'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayStructDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/dynArrayTest/dynArrayStructStruct.sol', 'Success'],
    ['exampleContracts/functionInputs/structTest/structArrayArray.sol', 'Success'],
    ['exampleContracts/functionInputs/structTest/structArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structArrayStruct.sol', 'Success'],
    ['exampleContracts/functionInputs/structTest/structDynArrayArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structDynArrayDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structDynArrayStruct.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structString.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structStructArray.sol', 'Success'],
    ['exampleContracts/functionInputs/structTest/structStructBytes.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structStructDynArray.sol', 'WillNotSupport'],
    ['exampleContracts/functionInputs/structTest/structStructStruct.sol', 'Success'],
    ['exampleContracts/idManglingTest8.sol', 'Success'],
    ['exampleContracts/idManglingTest9.sol', 'Success'],
    ['exampleContracts/ifFlattening.sol', 'Success'],
    ['exampleContracts/implicitsFromStub.sol', 'Success'],
    ['exampleContracts/imports/importContract.sol', 'Success'],
    ['exampleContracts/imports/importEnum.sol', 'Success'],
    ['exampleContracts/imports/importfrom.sol', 'Success'],
    ['exampleContracts/imports/importInterface.sol', 'Success'],
    ['exampleContracts/imports/importLibrary.sol', 'Success'],
    ['exampleContracts/imports/importStruct.sol', 'Success'],
    ['exampleContracts/indexParam.sol', 'Success'],
    ['exampleContracts/inheritance/simple.sol', 'Success'],
    ['exampleContracts/inheritance/super/base.sol', 'Success'],
    ['exampleContracts/inheritance/super/derived.sol', 'Success'],
    ['exampleContracts/inheritance/super/mid.sol', 'Success'],
    ['exampleContracts/inheritance/variables.sol', 'Success'],
    // Requires struct imports
    ['exampleContracts/interfaces.sol', 'Success'],
    ['exampleContracts/interfaceFromBaseContract.sol', 'Success'],
    ['exampleContracts/invalidSolidity.sol', 'SolCompileFailed'],
    ['exampleContracts/lib.sol', 'Success'],
    ['exampleContracts/libraries/usingForStar.sol', 'Success'],
    ['exampleContracts/literalOperations.sol', 'Success'],
    ['exampleContracts/loops/forLoopWithBreak.sol', 'Success'],
    ['exampleContracts/loops/forLoopWithContinue.sol', 'Success'],
    ['exampleContracts/loops/forLoopWithNestedReturn.sol', 'Success'],
    ['exampleContracts/rejectedTerms/contractName$.sol', 'WillNotSupport'],
    ['exampleContracts/rejectedTerms/reservedContract.sol', 'WillNotSupport'],
    ['exampleContracts/rejectedTerms/contractNameLib.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/balance.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/call.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/code.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/codehash.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/delegatecall.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/send.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/staticcall.sol', 'WillNotSupport'],
    ['exampleContracts/memberAccess/transfer.sol', 'WillNotSupport'],
    ['exampleContracts/msg.sol', 'WillNotSupport'],
    ['exampleContracts/multipleVariables.sol', 'Success'],
    ['exampleContracts/mutableReferences/deepDelete.sol', 'Success'],
    ['exampleContracts/mutableReferences/memory.sol', 'Success'],
    ['exampleContracts/mutableReferences/mutableReferences.sol', 'Success'],
    ['exampleContracts/mutableReferences/scalarStorage.sol', 'Success'],
    ['exampleContracts/namedArgs/constructor.sol', 'Success'],
    ['exampleContracts/namedArgs/eventsAndErrors.sol', 'Success'],
    ['exampleContracts/namedArgs/function.sol', 'Success'],
    ['exampleContracts/nestedStaticArrayStruct.sol', 'Success'],
    ['exampleContracts/nestedStructStaticArray.sol', 'Success'],
    ['exampleContracts/nestedStructs.sol', 'Success'],
    ['exampleContracts/nestedTuple.sol', 'WillNotSupport'],
    ['exampleContracts/oldCodeGenErr.sol', 'WillNotSupport'],
    ['exampleContracts/oldCodeGenErr7.sol', 'WillNotSupport'],
    ['exampleContracts/payableFunction.sol', 'Success'],
    ['exampleContracts/pureFunction.sol', 'Success'],
    ['exampleContracts/rejectNaming.sol', 'WillNotSupport'],
    ['exampleContracts/removeUnreachableFunctions.sol', 'Success'],
    ['exampleContracts/returnDynArray.sol', 'Success'],
    ['exampleContracts/returnVarCapturing.sol', 'Success'],
    ['exampleContracts/returndatasize.sol', 'WillNotSupport'],
    ['exampleContracts/returnInserter.sol', 'Success'],
    ['exampleContracts/simpleStorageVar.sol', 'Success'],
    ['exampleContracts/sstoreSload.sol', 'WillNotSupport'],
    ['exampleContracts/stateVariables/scalars.sol', 'Success'],
    ['exampleContracts/stateVariables/enums.sol', 'Success'],
    ['exampleContracts/stateVariables/arrays.sol', 'Success'],
    ['exampleContracts/stateVariables/arraysInit.sol', 'Success'],
    ['exampleContracts/stateVariables/mappings.sol', 'Success'],
    ['exampleContracts/stateVariables/structs.sol', 'Success'],
    ['exampleContracts/stateVariables/structsNested.sol', 'Success'],
    ['exampleContracts/stateVariables/misc.sol', 'Success'],
    ['exampleContracts/structs.sol', 'Success'],
    ['exampleContracts/thisMethodsCall.sol', 'Success'],
    ['exampleContracts/tryCatch.sol', 'WillNotSupport'],
    ['exampleContracts/tupleAssignment7.sol', 'Success'],
    ['exampleContracts/tupleAssignment8.sol', 'SolCompileFailed'],
    ['exampleContracts/typeConversion/explicitTypeConversion.sol', 'Success'],
    ['exampleContracts/typeConversion/implicitReturnConversion.sol', 'Success'],
    ['exampleContracts/typeConversion/implicitTypeConv.sol', 'Success'],
    ['exampleContracts/typeConversion/shifts.sol', 'Success'],
    ['exampleContracts/typeConversion/unusedArrayConversion.sol', 'Success'],
    ['exampleContracts/typeMinMax.sol', 'Success'],
    ['exampleContracts/uint256StaticArrayCasting.sol', 'Success'],
    ['exampleContracts/typestrings/basicArrays.sol', 'Success'],
    ['exampleContracts/typestrings/scalars.sol', 'Success'],
    ['exampleContracts/typestrings/structArrays.sol', 'Success'],
    ['exampleContracts/typestrings/structs.sol', 'Success'],
    ['exampleContracts/units.sol', 'Success'],
    ['exampleContracts/unsupportedFunctions/abi.sol', `Success`],
    ['exampleContracts/unsupportedFunctions/keccak256.sol', `Success`],
    ['exampleContracts/unsupportedFunctions/ecrecover.sol', `Success`],
    ['exampleContracts/unsupportedFunctions/addmod.sol', `Success`],
    ['exampleContracts/unsupportedFunctions/gasleft.sol', `WillNotSupport`],
    // Supported precompiles
    ['exampleContracts/precompiles/ecrecover.sol', 'Success'],
    ['exampleContracts/precompiles/keccak256.sol', 'Success'],
    // Uses bytes memory
    ['exampleContracts/unsupportedFunctions/shadowAbi.sol', `Success`],
    // Uses bytes memory
    ['exampleContracts/unsupportedFunctions/shadowKeccak256.sol', `Success`],
    ['exampleContracts/unsupportedFunctions/shadowEcrecover.sol', `Success`],
    // uses modulo (%)
    ['exampleContracts/unsupportedFunctions/shadowAddmod.sol', 'Success'],
    // Uses WARP_STORAGE in a free function
    ['exampleContracts/usingFor/imports/userDefined.sol', 'Success'],
    // global_directive.sol cannot resolve struct when file imported as identifier
    ['exampleContracts/usingFor/imports/globalDirective.sol', 'Success'],
    ['exampleContracts/usingFor/complexLibraries.sol', 'Success'],
    ['exampleContracts/usingFor/function.sol', 'WillNotSupport'],
    ['exampleContracts/usingFor/private.sol', 'Success'],
    ['exampleContracts/usingFor/library.sol', 'Success'],
    ['exampleContracts/usingFor/simple.sol', 'Success'],
    ['exampleContracts/usingReturnValues.sol', 'Success'],
    ['exampleContracts/userDefinedFunctionCalls.sol', 'Success'],
    ['exampleContracts/userdefinedtypes.sol', 'Success'],
    ['exampleContracts/userdefinedidentifier.sol', 'Success'],
    ['exampleContracts/variableDeclarations.sol', 'Success'],
    ['exampleContracts/viewFunction.sol', 'Success'],
    ['exampleContracts/typestrings/enumArrays.sol', 'Success'],
    //uses 'this' keyword in the constructor
    ['exampleContracts/thisAtConstructor/externalFunctionCallAtConstruction.sol', 'WillNotSupport'],
    [
      'exampleContracts/thisAtConstructor/multipleExternalFunctionCallsAtConstruction.sol',
      'WillNotSupport',
    ],
    ['exampleContracts/thisAtConstructor/validThisUseAtConstructor.sol', 'Success'],
  ].map(([key, result]) => {
    return [path.join(WARP_TEST, key), result] as [string, ResultType];
  }),
);

export async function runTests(
  force: boolean,
  onlyResults: boolean,
  unsafe = false,
  exact = false,
) {
  if (force) {
    await postTestCleanup();
  } else if (!preTestChecks()) return;

  const filter = process.env.FILTER;
  const results = new Map<string, ResultType>();

  await Promise.all(
    (
      await findSolSourceFilePaths('exampleContracts', true)
    ).map(async (file) => {
      if (filter === undefined || file.includes(filter)) {
        await runSolFileTest(file, results, onlyResults, unsafe);
      }
    }),
  );

  const bottleneck = new Bottleneck({ maxConcurrent: PARALLEL_COUNT });

  await Promise.all(
    (
      await findCairoSourceFilePaths(WARP_TEST_FOLDER, true)
    ).map((file) => bottleneck.schedule(() => runCairoFileTest(file, results, onlyResults))),
  );

  const testsWithUnexpectedResults = getTestsWithUnexpectedResults(results);
  printResults(results, testsWithUnexpectedResults);
  await postTestCleanup();

  if (exact) {
    if (testsWithUnexpectedResults.length > 0) {
      throw new Error(
        error(`${testsWithUnexpectedResults.length} test(s) had unexpected outcome(s)`),
      );
    }
  }
}

function preTestChecks(): boolean {
  if (!checkNoCairo(WARP_TEST_FOLDER) || !checkNoJson(WARP_TEST_FOLDER)) {
    console.log('Please remove warpTest/exampleContracts, or run with -f to delete it');
    return false;
  }

  if (!checkNoJson('warplib')) {
    console.log('Please remove all json files from warplib, or run with -f to delete them');
    return false;
  }

  return true;
}

async function runSolFileTest(
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  unsafe: boolean,
): Promise<void> {
  console.log(`Warping ${file}`);
  const mangledPath = path.join(WARP_TEST, file);
  try {
    await Promise.all(
      (
        await transpile(await compileSolFiles([file], { warnings: false }), {
          strict: true,
          dev: true,
        })
      ).map(([file, cairo]) => outputFile(path.join(WARP_TEST, file), cairo)),
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

async function runCairoFileTest(
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  throwError = false,
): Promise<void> {
  if (!onlyResults) console.log(`Compiling ${file}`);
  if ((await enqueueCompileCairo(file)).success) {
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

function getTestsWithUnexpectedResults(results: Map<string, ResultType>): string[] {
  const testsWithUnexpectedResults: string[] = [];
  const groupedResults = groupBy([...results.entries()], ([file, _]) =>
    file.endsWith('.cairo') ? path.dirname(file) : file,
  );
  [...groupedResults.entries()].forEach((e) => {
    const expected = expectedResults.get(e[0]);
    const collectiveResult = combineResults(
      [...e[1]].reduce((res, [_, result]) => [...res, result], <ResultType[]>[]),
    );
    if (collectiveResult !== expected) {
      testsWithUnexpectedResults.push(e[0]);
    }
  });
  return testsWithUnexpectedResults;
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

async function checkNoCairo(path: string): Promise<boolean> {
  try {
    await fs.access(path);
  } catch {
    return true;
  }

  return (await findCairoSourceFilePaths(path, true)).length === 0;
}

async function checkNoJson(path: string): Promise<boolean> {
  try {
    await fs.access(path);
  } catch {
    return true;
  }

  return (await findAllFiles(path, true)).filter((file) => file.endsWith('.json')).length === 0;
}

async function postTestCleanup(): Promise<void> {
  await deleteJson('warplib');
  await fs.rm(WARP_TEST_FOLDER, { recursive: true, force: true });
}

async function deleteJson(path: string): Promise<void> {
  const jsonFiles = (await findAllFiles(path, true)).filter((file) => file.endsWith('.json'));

  await Promise.all(jsonFiles.map((file) => fs.unlink(file)));
}

function removeExtension(file: string): string {
  const index = file.lastIndexOf('.');
  if (index === -1) return file;
  return file.slice(0, index);
}

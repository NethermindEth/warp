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

const WARP_TEST = 'warp_test';
const WARP_TEST_FOLDER = path.join(WARP_TEST, 'example_contracts');

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
    ['example_contracts/array_length.sol', 'Success'],
    ['example_contracts/ERC20.sol', 'Success'],
    ['example_contracts/ERC20_storage.sol', 'Success'],
    ['example_contracts/address/8/160_not_allowed.sol', 'SolCompileFailed'],
    ['example_contracts/address/8/256_address.sol', 'Success'],
    ['example_contracts/address/8/max_prime.sol', 'SolCompileFailed'],
    ['example_contracts/address/8/max_prime_explicit.sol', 'Success'],
    ['example_contracts/address/8/padding.sol', 'Success'],
    ['example_contracts/address/8/prime_field.sol', 'Success'],
    ['example_contracts/address/7/160_not_allowed.sol', 'SolCompileFailed'],
    ['example_contracts/address/7/256_address.sol', 'Success'],
    ['example_contracts/address/7/max_prime.sol', 'SolCompileFailed'],
    ['example_contracts/address/7/max_prime_explicit.sol', 'Success'],
    ['example_contracts/address/7/padding.sol', 'Success'],
    ['example_contracts/address/7/prime_field.sol', 'Success'],
    ['example_contracts/boolOp_noSideEffects.sol', 'Success'],
    ['example_contracts/boolOp_sideEffects.sol', 'Success'],
    ['example_contracts/bytesXAccess.sol', 'Success'],
    ['example_contracts/c2c.sol', 'Success'],
    // Uses conditionals explicitly
    ['example_contracts/conditional.sol', 'Success'],
    ['example_contracts/conditional_simple.sol', 'Success'],
    ['example_contracts/contract_to_contract.sol', 'Success'],
    ['example_contracts/calldatacopy.sol', 'WillNotSupport'],
    ['example_contracts/calldataCrossContractCalls.sol', 'Success'],
    ['example_contracts/calldataload.sol', 'WillNotSupport'],
    ['example_contracts/calldatasize.sol', 'WillNotSupport'],
    ['example_contracts/comments.sol', 'Success'],
    ['example_contracts/constructors_dyn.sol', 'Success'],
    ['example_contracts/constructors_nonDyn.sol', 'Success'],
    ['example_contracts/contracts_as_input.sol', 'Success'],
    ['example_contracts/dai.sol', 'Success'],
    ['example_contracts/delete.sol', 'SolCompileFailed'],
    ['example_contracts/delete_uses.sol', 'Success'],
    ['example_contracts/enums.sol', 'Success'],
    ['example_contracts/enums7.sol', 'Success'],
    ['example_contracts/errorHandling/assert.sol', 'Success'],
    ['example_contracts/errorHandling/require.sol', 'Success'],
    ['example_contracts/errorHandling/revert.sol', 'Success'],
    ['example_contracts/events.sol', 'Success'],
    ['example_contracts/expressionSplitter/assign_simple.sol', 'Success'],
    ['example_contracts/expressionSplitter/func_call_simple.sol', 'Success'],
    ['example_contracts/expressionSplitter/tuple_assign.sol', 'Success'],
    ['example_contracts/external_function.sol', 'Success'],
    ['example_contracts/fallbackWithoutArgs.sol', 'Success'],
    ['example_contracts/fallbackWithArgs.sol', 'WillNotSupport'],
    // Cannot import with a - in the filename
    ['example_contracts/file-with-minus-sign-included.sol', 'Success'],
    // Typestring for the internal function call doesn't contain a location so a read isn't generated
    ['example_contracts/freeFunction.sol', 'Success'],
    ['example_contracts/freeStruct.sol', 'Success'],
    ['example_contracts/function_with_nested_return.sol', 'Success'],
    ['example_contracts/functionArgumentConversions.sol', 'Success'],
    ['example_contracts/functionInputs/arrayTest/arrayArrayArray.sol', 'Success'],
    ['example_contracts/functionInputs/arrayTest/arrayArrayBytes.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayArrayDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayArrayStruct.sol', 'Success'],
    ['example_contracts/functionInputs/arrayTest/arrayDynArrayArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayDynArrayStruct.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayStructArray.sol', 'Success'],
    ['example_contracts/functionInputs/arrayTest/arrayStructDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/arrayTest/arrayStructStruct.sol', 'Success'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayArray.sol', 'Success'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayStruct.sol', 'Success'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayArray.sol', 'WillNotSupport'],
    [
      'example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayDynArray.sol',
      'WillNotSupport',
    ],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayStruct.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayStructArray.sol', 'Success'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayStructDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/dynArrayTest/dynArrayStructStruct.sol', 'Success'],
    ['example_contracts/functionInputs/structTest/structArrayArray.sol', 'Success'],
    ['example_contracts/functionInputs/structTest/structArrayDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structArrayStruct.sol', 'Success'],
    ['example_contracts/functionInputs/structTest/structDynArrayArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structDynArrayDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structDynArrayStruct.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structString.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structStructArray.sol', 'Success'],
    ['example_contracts/functionInputs/structTest/structStructBytes.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structStructDynArray.sol', 'WillNotSupport'],
    ['example_contracts/functionInputs/structTest/structStructStruct.sol', 'Success'],
    ['example_contracts/idManglingTest8.sol', 'Success'],
    ['example_contracts/idManglingTest9.sol', 'Success'],
    ['example_contracts/if_flattening.sol', 'Success'],
    ['example_contracts/implicitsFromStub.sol', 'Success'],
    ['example_contracts/imports/importContract.sol', 'Success'],
    ['example_contracts/imports/importEnum.sol', 'Success'],
    ['example_contracts/imports/importfrom.sol', 'Success'],
    ['example_contracts/imports/importInterface.sol', 'Success'],
    ['example_contracts/imports/importLibrary.sol', 'Success'],
    ['example_contracts/imports/importStruct.sol', 'Success'],
    ['example_contracts/index_param.sol', 'Success'],
    ['example_contracts/inheritance/simple.sol', 'Success'],
    ['example_contracts/inheritance/super/base.sol', 'Success'],
    ['example_contracts/inheritance/super/derived.sol', 'Success'],
    ['example_contracts/inheritance/super/mid.sol', 'Success'],
    ['example_contracts/inheritance/variables.sol', 'Success'],
    // Requires struct imports
    ['example_contracts/interfaces.sol', 'Success'],
    ['example_contracts/interfaceFromBaseContract.sol', 'Success'],
    ['example_contracts/invalidSolidity.sol', 'SolCompileFailed'],
    ['example_contracts/lib.sol', 'Success'],
    ['example_contracts/libraries/using_for_star.sol', 'Success'],
    ['example_contracts/literalOperations.sol', 'Success'],
    ['example_contracts/loops/for_loop_with_break.sol', 'Success'],
    ['example_contracts/loops/for_loop_with_continue.sol', 'Success'],
    ['example_contracts/loops/for_loop_with_nested_return.sol', 'Success'],
    ['example_contracts/rejectedTerms/contract_name$.sol', 'WillNotSupport'],
    ['example_contracts/rejectedTerms/reservedContract.sol', 'WillNotSupport'],
    ['example_contracts/rejectedTerms/contract_name_lib.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/balance.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/call.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/code.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/codehash.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/delegatecall.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/send.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/staticcall.sol', 'WillNotSupport'],
    ['example_contracts/memberAccess/transfer.sol', 'WillNotSupport'],
    ['example_contracts/msg.sol', 'WillNotSupport'],
    ['example_contracts/multiple_variables.sol', 'Success'],
    ['example_contracts/mutableReferences/deepDelete.sol', 'Success'],
    ['example_contracts/mutableReferences/memory.sol', 'Success'],
    ['example_contracts/mutableReferences/mutableReferences.sol', 'Success'],
    ['example_contracts/mutableReferences/scalarStorage.sol', 'Success'],
    ['example_contracts/namedArgs/constructor.sol', 'Success'],
    ['example_contracts/namedArgs/events_and_errors.sol', 'Success'],
    ['example_contracts/namedArgs/function.sol', 'Success'],
    ['example_contracts/nested_static_array_struct.sol', 'Success'],
    ['example_contracts/nested_struct_static_array.sol', 'Success'],
    ['example_contracts/nested_structs.sol', 'Success'],
    ['example_contracts/nested_tuple.sol', 'WillNotSupport'],
    ['example_contracts/old_code_gen_err.sol', 'WillNotSupport'],
    ['example_contracts/old_code_gen_err_7.sol', 'WillNotSupport'],
    ['example_contracts/payable_function.sol', 'Success'],
    ['example_contracts/pure_function.sol', 'Success'],
    ['example_contracts/rejectNaming.sol', 'WillNotSupport'],
    ['example_contracts/removeUnreachableFunctions.sol', 'Success'],
    ['example_contracts/return_dyn_array.sol', 'Success'],
    ['example_contracts/return_var_capturing.sol', 'Success'],
    ['example_contracts/returndatasize.sol', 'WillNotSupport'],
    ['example_contracts/returnInserter.sol', 'Success'],
    ['example_contracts/simple_storage_var.sol', 'Success'],
    ['example_contracts/sstore_sload.sol', 'WillNotSupport'],
    ['example_contracts/state_variables/scalars.sol', 'Success'],
    ['example_contracts/state_variables/enums.sol', 'Success'],
    ['example_contracts/state_variables/arrays.sol', 'Success'],
    ['example_contracts/state_variables/arrays_init.sol', 'Success'],
    ['example_contracts/state_variables/mappings.sol', 'Success'],
    ['example_contracts/state_variables/structs.sol', 'Success'],
    ['example_contracts/state_variables/structs_nested.sol', 'Success'],
    ['example_contracts/state_variables/misc.sol', 'Success'],
    ['example_contracts/structs.sol', 'Success'],
    ['example_contracts/this_methods_call.sol', 'Success'],
    ['example_contracts/try_catch.sol', 'WillNotSupport'],
    ['example_contracts/tupleAssignment7.sol', 'Success'],
    ['example_contracts/tupleAssignment8.sol', 'SolCompileFailed'],
    ['example_contracts/typeConversion/explicitTypeConversion.sol', 'Success'],
    ['example_contracts/typeConversion/implicitReturnConversion.sol', 'Success'],
    ['example_contracts/typeConversion/implicit_type_conv.sol', 'Success'],
    ['example_contracts/typeConversion/shifts.sol', 'Success'],
    ['example_contracts/typeConversion/unusedArrayConversion.sol', 'Success'],
    ['example_contracts/typeMinMax.sol', 'Success'],
    ['example_contracts/uint256_static_array_casting.sol', 'Success'],
    ['example_contracts/typestrings/basicArrays.sol', 'Success'],
    ['example_contracts/typestrings/scalars.sol', 'Success'],
    ['example_contracts/typestrings/structArrays.sol', 'Success'],
    ['example_contracts/typestrings/structs.sol', 'Success'],
    ['example_contracts/units.sol', 'Success'],
    ['example_contracts/unsupportedFunctions/abi.sol', `Success`],
    ['example_contracts/unsupportedFunctions/keccak256.sol', `Success`],
    ['example_contracts/unsupportedFunctions/ecrecover.sol', `Success`],
    ['example_contracts/unsupportedFunctions/addmod.sol', `Success`],
    ['example_contracts/unsupportedFunctions/gasleft.sol', `WillNotSupport`],
    // Supported precompiles
    ['example_contracts/precompiles/ecrecover.sol', 'Success'],
    ['example_contracts/precompiles/keccak256.sol', 'Success'],
    // Uses bytes memory
    ['example_contracts/unsupportedFunctions/shadowAbi.sol', `Success`],
    // Uses bytes memory
    ['example_contracts/unsupportedFunctions/shadowKeccak256.sol', `Success`],
    ['example_contracts/unsupportedFunctions/shadowEcrecover.sol', `Success`],
    // uses modulo (%)
    ['example_contracts/unsupportedFunctions/shadowAddmod.sol', 'Success'],
    // Uses WARP_STORAGE in a free function
    ['example_contracts/using_for/imports/user_defined.sol', 'Success'],
    // global_directive.sol cannot resolve struct when file imported as identifier
    ['example_contracts/using_for/imports/global_directive.sol', 'Success'],
    ['example_contracts/using_for/complex_libraries.sol', 'Success'],
    ['example_contracts/using_for/function.sol', 'WillNotSupport'],
    ['example_contracts/using_for/private.sol', 'Success'],
    ['example_contracts/using_for/library.sol', 'Success'],
    ['example_contracts/using_for/simple.sol', 'Success'],
    ['example_contracts/usingReturnValues.sol', 'Success'],
    ['example_contracts/userDefinedFunctionCalls.sol', 'Success'],
    ['example_contracts/userdefinedtypes.sol', 'Success'],
    ['example_contracts/userdefinedidentifier.sol', 'Success'],
    ['example_contracts/variable_declarations.sol', 'Success'],
    ['example_contracts/view_function.sol', 'Success'],
    ['example_contracts/typestrings/enumArrays.sol', 'Success'],
    //uses 'this' keyword in the constructor
    [
      'example_contracts/this_at_constructor/external_function_call_at_construction.sol',
      'WillNotSupport',
    ],
    [
      'example_contracts/this_at_constructor/multiple_external_function_calls_at_construction.sol',
      'WillNotSupport',
    ],
    ['example_contracts/this_at_constructor/valid_this_use_at_constructor.sol', 'Success'],
  ].map(([key, result]) => {
    return [path.join(WARP_TEST, key), result] as [string, ResultType];
  }),
);

export function runTests(force: boolean, onlyResults: boolean, unsafe = false, exact = false) {
  const results = new Map<string, ResultType>();
  if (force) {
    postTestCleanup();
  } else if (!preTestChecks()) return;
  const filter = process.env.FILTER;
  findSolSourceFilePaths('example_contracts', true).forEach((file) => {
    if (filter === undefined || file.includes(filter)) {
      runSolFileTest(file, results, onlyResults, unsafe);
    }
  });
  findCairoSourceFilePaths(WARP_TEST_FOLDER, true).forEach((file) => {
    runCairoFileTest(file, results, onlyResults);
  });
  const testsWithUnexpectedResults = getTestsWithUnexpectedResults(results);
  printResults(results, testsWithUnexpectedResults);
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
  if (!checkNoCairo(WARP_TEST_FOLDER) || !checkNoJson(WARP_TEST_FOLDER)) {
    console.log('Please remove warp_test/example_contracts, or run with -f to delete it');
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
  fs.rmSync(WARP_TEST_FOLDER, { recursive: true, force: true });
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

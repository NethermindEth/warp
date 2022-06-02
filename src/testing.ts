import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths, findSolSourceFilePaths } from './io';
import { compileSolFile } from './solCompile';
import { compileCairo } from './starknetCli';
import { transpile } from './transpiler';
import {
  NotSupportedYetError,
  TranspilationAbandonedError,
  WillNotSupportError,
} from './utils/errors';
import { groupBy, printCompileErrors } from './utils/utils';
import * as fs from 'fs';
import { error } from './utils/formatting';

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

const expectedResults = new Map<string, ResultType>([
  ['example_contracts/array_length', 'Success'],
  ['example_contracts/ERC20', 'Success'],
  ['example_contracts/ERC20_storage', 'Success'],
  ['example_contracts/address/8/160_not_allowed', 'SolCompileFailed'],
  ['example_contracts/address/8/256_address', 'Success'],
  ['example_contracts/address/8/max_prime', 'SolCompileFailed'],
  ['example_contracts/address/8/max_prime_explicit', 'Success'],
  ['example_contracts/address/8/padding', 'Success'],
  ['example_contracts/address/8/prime_field', 'Success'],
  ['example_contracts/address/7/160_not_allowed', 'SolCompileFailed'],
  ['example_contracts/address/7/256_address', 'Success'],
  ['example_contracts/address/7/max_prime', 'SolCompileFailed'],
  ['example_contracts/address/7/max_prime_explicit', 'Success'],
  ['example_contracts/address/7/padding', 'Success'],
  ['example_contracts/address/7/prime_field', 'Success'],
  ['example_contracts/boolOp_noSideEffects', 'Success'],
  ['example_contracts/boolOp_sideEffects', 'Success'],
  ['example_contracts/bytesXAccess', 'Success'],
  ['example_contracts/c2c', 'Success'],
  // Uses conditionals explicitly
  ['example_contracts/conditional', 'WillNotSupport'],
  ['example_contracts/contract_to_contract', 'Success'],
  ['example_contracts/calldatacopy', 'WillNotSupport'],
  ['example_contracts/calldataload', 'WillNotSupport'],
  ['example_contracts/calldatasize', 'WillNotSupport'],
  ['example_contracts/comments', 'Success'],
  ['example_contracts/constructors_dyn', 'Success'],
  ['example_contracts/constructors_nonDyn', 'Success'],
  ['example_contracts/dai', 'Success'],
  ['example_contracts/delete', 'SolCompileFailed'],
  ['example_contracts/enums', 'Success'],
  ['example_contracts/enums7', 'Success'],
  ['example_contracts/errorHandling/assert', 'Success'],
  ['example_contracts/errorHandling/require', 'Success'],
  ['example_contracts/errorHandling/revert', 'Success'],
  ['example_contracts/events', 'Success'],
  ['example_contracts/external_function', 'Success'],
  ['example_contracts/fallbackWithoutArgs', 'Success'],
  ['example_contracts/fallbackWithArgs', 'WillNotSupport'],
  // Cannot import with a - in the filename
  ['example_contracts/file-with-minus-sign-included', 'WillNotSupport'],
  // Typestring for the internal function call doesn't contain a location so a read isn't generated
  ['example_contracts/freeFunction', 'Success'],
  ['example_contracts/freeStruct', 'Success'],
  ['example_contracts/function_with_nested_return', 'Success'],
  ['example_contracts/functionArgumentConversions', 'Success'],
  ['example_contracts/functionInputs/arrayTest/arrayArrayArray', 'Success'],
  ['example_contracts/functionInputs/arrayTest/arrayArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/arrayTest/arrayArrayStruct', 'Success'],
  ['example_contracts/functionInputs/arrayTest/arrayDynArrayArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/arrayTest/arrayDynArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/arrayTest/arrayDynArrayStruct', 'NotSupportedYet'],
  ['example_contracts/functionInputs/arrayTest/arrayStructArray', 'Success'],
  ['example_contracts/functionInputs/arrayTest/arrayStructDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/arrayTest/arrayStructStruct', 'Success'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayArrayStruct', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayDynArrayStruct', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayStructArray', 'Success'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayStructDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/dynArrayTest/dynArrayStructStruct', 'Success'],
  ['example_contracts/functionInputs/structTest/structArrayArray', 'Success'],
  ['example_contracts/functionInputs/structTest/structArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/structTest/structArrayStruct', 'Success'],
  ['example_contracts/functionInputs/structTest/structDynArrayArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/structTest/structDynArrayDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/structTest/structDynArrayStruct', 'NotSupportedYet'],
  ['example_contracts/functionInputs/structTest/structStructArray', 'Success'],
  ['example_contracts/functionInputs/structTest/structStructDynArray', 'NotSupportedYet'],
  ['example_contracts/functionInputs/structTest/structStructStruct', 'Success'],
  ['example_contracts/idManglingTest8', 'Success'],
  ['example_contracts/idManglingTest9', 'Success'],
  ['example_contracts/if_flattening', 'Success'],
  ['example_contracts/imports/importContract', 'Success'],
  ['example_contracts/imports/importEnum', 'Success'],
  ['example_contracts/imports/importfrom', 'Success'],
  ['example_contracts/imports/importInterface', 'Success'],
  ['example_contracts/imports/importLibrary', 'Success'],
  ['example_contracts/imports/importStruct', 'Success'],
  ['example_contracts/inheritance/simple', 'Success'],
  ['example_contracts/inheritance/super/base', 'Success'],
  ['example_contracts/inheritance/super/derived', 'Success'],
  ['example_contracts/inheritance/super/mid', 'Success'],
  ['example_contracts/inheritance/variables', 'Success'],
  // Requires struct imports
  ['example_contracts/interfaces', 'CairoCompileFailed'],
  ['example_contracts/invalidSolidity', 'SolCompileFailed'],
  ['example_contracts/lib', 'Success'],
  ['example_contracts/libraries/using_for_star', 'Success'],
  ['example_contracts/literalOperations', 'Success'],
  ['example_contracts/loops/for_loop_with_break', 'Success'],
  ['example_contracts/loops/for_loop_with_continue', 'Success'],
  ['example_contracts/loops/for_loop_with_nested_return', 'Success'],
  ['example_contracts/memberAccess/balance', 'WillNotSupport'],
  ['example_contracts/memberAccess/call', 'WillNotSupport'],
  ['example_contracts/memberAccess/code', 'WillNotSupport'],
  ['example_contracts/memberAccess/codehash', 'WillNotSupport'],
  ['example_contracts/memberAccess/delegatecall', 'WillNotSupport'],
  ['example_contracts/memberAccess/send', 'WillNotSupport'],
  ['example_contracts/memberAccess/staticcall', 'WillNotSupport'],
  ['example_contracts/memberAccess/transfer', 'WillNotSupport'],
  ['example_contracts/mutableReferences/deepDelete', 'Success'],
  ['example_contracts/mutableReferences/memory', 'Success'],
  ['example_contracts/mutableReferences/mutableReferences', 'Success'],
  ['example_contracts/mutableReferences/scalarStorage', 'Success'],
  ['example_contracts/namedArgs/constructor', 'Success'],
  ['example_contracts/namedArgs/events_and_errors', 'Success'],
  ['example_contracts/namedArgs/function', 'Success'],
  ['example_contracts/nested_static_array_struct', 'Success'],
  ['example_contracts/nested_struct_static_array', 'Success'],
  ['example_contracts/nested_structs', 'Success'],
  ['example_contracts/payable_function', 'Success'],
  ['example_contracts/pure_function', 'Success'],
  ['example_contracts/return_dyn_array', 'Success'],
  ['example_contracts/return_var_capturing', 'Success'],
  ['example_contracts/returndatasize', 'WillNotSupport'],
  ['example_contracts/returnInserter', 'Success'],
  ['example_contracts/simple_storage_var', 'Success'],
  ['example_contracts/sstore_sload', 'WillNotSupport'],
  ['example_contracts/state_variables/scalars', 'Success'],
  ['example_contracts/state_variables/enums', 'Success'],
  ['example_contracts/state_variables/arrays', 'Success'],
  // Tuple initialization not supported yet
  ['example_contracts/state_variables/arrays_init', 'NotSupportedYet'],
  ['example_contracts/state_variables/mappings', 'Success'],
  ['example_contracts/state_variables/structs', 'Success'],
  ['example_contracts/state_variables/structs_nested', 'Success'],
  // Mappings of structs are not supported yet
  ['example_contracts/state_variables/misc', 'Success'],
  ['example_contracts/structs', 'Success'],
  ['example_contracts/tupleAssignment7', 'Success'],
  ['example_contracts/tupleAssignment8', 'SolCompileFailed'],
  ['example_contracts/typeConversion/explicitTypeConversion', 'Success'],
  ['example_contracts/typeConversion/implicitReturnConversion', 'Success'],
  ['example_contracts/typeConversion/implicit_type_conv', 'Success'],
  ['example_contracts/typeConversion/shifts', 'Success'],
  ['example_contracts/typeConversion/unusedArrayConversion', 'Success'],
  ['example_contracts/typeMinMax', 'Success'],
  ['example_contracts/uint256_static_array_casting', 'Success'],
  // Serialising BytesType not supported yet
  ['example_contracts/typestrings/basicArrays', 'Success'],
  // Not supported operation delete on CairoContract
  ['example_contracts/typestrings/scalars', 'NotSupportedYet'],
  ['example_contracts/typestrings/structArrays', 'Success'],
  ['example_contracts/typestrings/structs', 'Success'],
  ['example_contracts/units', 'Success'],
  ['example_contracts/unsupportedFunctions/abi', `WillNotSupport`],
  ['example_contracts/unsupportedFunctions/keccak256', `WillNotSupport`],
  ['example_contracts/unsupportedFunctions/ecrecover', `WillNotSupport`],
  ['example_contracts/unsupportedFunctions/addmod', `WillNotSupport`],
  // Uses bytes memory
  ['example_contracts/unsupportedFunctions/shadowAbi', `Success`],
  // Uses bytes memory
  ['example_contracts/unsupportedFunctions/shadowKeccak256', `Success`],
  ['example_contracts/unsupportedFunctions/shadowEcrecover', `Success`],
  // uses modulo (%)
  ['example_contracts/unsupportedFunctions/shadowAddmod', 'Success'],
  // Uses WARP_STORAGE in a free function
  ['example_contracts/using_for/imports/user_defined', 'Success'],
  // global_directive.sol cannot resolve struct when file imported as identifier
  ['example_contracts/using_for/imports/global_directive', 'CairoCompileFailed'],
  ['example_contracts/using_for/function', 'WillNotSupport'],
  ['example_contracts/using_for/private', 'Success'],
  ['example_contracts/using_for/library', 'Success'],
  ['example_contracts/using_for/simple', 'Success'],
  ['example_contracts/usingReturnValues', 'Success'],
  ['example_contracts/userDefinedFunctionCalls', 'Success'],
  ['example_contracts/userdefinedtypes', 'Success'],
  ['example_contracts/userdefinedidentifier', 'Success'],
  ['example_contracts/variable_declarations', 'Success'],
  ['example_contracts/view_function', 'Success'],
  ['example_contracts/typestrings/enumArrays', 'Success'],
]);

export function runTests(force: boolean, onlyResults: boolean, unsafe = false, exact = false) {
  const results = new Map<string, ResultType>();
  if (force) {
    postTestCleanup();
  } else if (!preTestChecks()) return;
  findSolSourceFilePaths('example_contracts', true).forEach((file) =>
    runSolFileTest(file, results, onlyResults, unsafe),
  );
  findCairoSourceFilePaths('example_contracts', true).forEach((file) => {
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
  if (!checkNoCairo('example_contracts')) {
    console.log(
      'Please remove all .cairo files from example_contracts, or run with -f to delete them',
    );
    return false;
  }
  if (!checkNoJson('example_contracts')) {
    console.log('Please remove all json files from warplib, or run with -f to delete them');
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
  try {
    transpile(compileSolFile(file, false), { strict: true }).forEach(([file, cairo]) =>
      fs.writeFileSync(`${file.slice(0, -4)}.cairo`, cairo),
    );
    results.set(removeExtension(file), 'Success');
  } catch (e) {
    if (e instanceof CompileFailedError) {
      if (!onlyResults) printCompileErrors(e);
      results.set(removeExtension(file), 'SolCompileFailed');
    } else if (e instanceof TranspilationAbandonedError) {
      if (e instanceof NotSupportedYetError) {
        results.set(removeExtension(file), 'NotSupportedYet');
      } else if (e instanceof WillNotSupportError) {
        results.set(removeExtension(file), 'WillNotSupport');
      } else {
        results.set(removeExtension(file), 'TranspilationFailed');
        if (unsafe) throw e;
      }
      if (!onlyResults) console.log(`Transpilation abandoned ${e.message}`);
    } else {
      if (!onlyResults) console.log('Transpilation failed');
      if (!onlyResults) console.log(e);
      results.set(removeExtension(file), 'TranspilationFailed');
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
  if (file.endsWith('WARP_FREE__.cairo')) return;
  if (!onlyResults) console.log(`Compiling ${file}`);
  if (compileCairo(file).success) {
    results.set(removeExtension(file), 'Success');
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
  const groupedResults = groupBy([...results.entries()], ([file, _]) => {
    return file.endsWith('__WARP_FREE__')
      ? file.slice(0, file.length - '__WARP_FREE__'.length)
      : file.split('__WARP_CONTRACT__')[0];
  });
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
      console.log(`\nTest: ${o}.sol`);
      console.log(`Expected outcome: ${expectedResults.get(o)}`);
      console.log(`Actual outcome:`);
      const Actual = new Map<string, ResultType>();
      results.forEach((value, key) => {
        if (
          key === o ||
          key.startsWith(`${o}__WARP_CONTRACT__`) ||
          key.startsWith(`${o}__WARP_FREE__`)
        ) {
          Actual.set(key, value);
        }
      });
      Actual.forEach((value, key) => {
        if (key.includes('__WARP_CONTRACT__') || key.includes('__WARP_FREE__')) {
          console.log(key + '.cairo' + ' : ' + value);
        } else {
          console.log(key + '.sol' + ' : ' + value);
        }
      });
    });
    console.log('\n');
  }
}

function checkNoCairo(path: string): boolean {
  return findCairoSourceFilePaths(path, true).length === 0;
}

function checkNoJson(path: string): boolean {
  return findAllFiles(path, true).filter((file) => file.endsWith('.json')).length === 0;
}

function postTestCleanup(): void {
  deleteJson('warplib');
  deleteCairoSource('example_contracts');
  deleteJson('example_contracts');
}

function deleteCairoSource(path: string): void {
  findCairoSourceFilePaths(path, true).forEach((file) => fs.unlinkSync(file));
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

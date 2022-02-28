import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths, findSolSourceFilePaths } from './io';
import { compileSolFile } from './solCompile';
import { compileCairo } from './starknetCli';
import { transpile } from './transpiler';
import {
  NotSupportedYetError,
  TranspilationAbandonedError,
  WillNotSupportError,
  error,
} from './utils/errors';
import { printCompileErrors } from './utils/utils';
import * as fs from 'fs';

type ResultType =
  | 'CairoCompileFailed'
  | 'SolCompileFailed'
  | 'Success'
  | 'NotSupportedYet'
  | 'WillNotSupport'
  | 'TranspilationFailed';

const expectedResults = new Map<string, ResultType>([
  ['example-contracts/ERC20', 'Success'],
  ['example-contracts/ERC20_storage', 'Success'],
  ['example-contracts/c2c', 'NotSupportedYet'],
  ['example-contracts/calldatacopy', 'WillNotSupport'],
  ['example-contracts/calldataload', 'WillNotSupport'],
  ['example-contracts/calldatasize', 'WillNotSupport'],
  ['example-contracts/constructors_dyn', 'NotSupportedYet'],
  ['example-contracts/constructors_nonDyn', 'NotSupportedYet'],
  ['example-contracts/dai', 'Success'],
  ['example-contracts/delete', 'SolCompileFailed'],
  ['example-contracts/enums', 'Success'],
  ['example-contracts/enums7', 'Success'],
  ['example-contracts/errorHandling/assert', 'Success'],
  ['example-contracts/errorHandling/require', 'Success'],
  ['example-contracts/errorHandling/revert', 'CairoCompileFailed'],
  ['example-contracts/events', 'Success'],
  ['example-contracts/freeFunction', 'Success'],
  ['example-contracts/function-with-nested-return', 'Success'],
  ['example-contracts/functionArgumentConversions', 'Success'],
  ['example-contracts/idManglingTest8', 'Success'],
  ['example-contracts/idManglingTest9', 'Success'],
  ['example-contracts/if-flattening', 'CairoCompileFailed'],
  ['example-contracts/interfaces', 'NotSupportedYet'],
  ['example-contracts/invalidSolidity', 'SolCompileFailed'],
  ['example-contracts/lib', 'Success'],
  ['example-contracts/libraries/using_for_simple', 'CairoCompileFailed'],
  ['example-contracts/libraries/using_for_star', 'NotSupportedYet'],
  ['example-contracts/literalOperations', 'Success'],
  ['example-contracts/loops/for-loop-with-break', 'Success'],
  ['example-contracts/loops/for-loop-with-continue', 'Success'],
  ['example-contracts/loops/for-loop-with-nested-return', 'Success'],
  ['example-contracts/mutableReferences/memory', 'Success'],
  ['example-contracts/mutableReferences/mutableReferences', 'NotSupportedYet'],
  ['example-contracts/mutableReferences/scalarStorage', 'Success'],
  ['example-contracts/payable-function', 'Success'],
  ['example-contracts/pure-function', 'NotSupportedYet'],
  ['example-contracts/return-var-capturing', 'Success'],
  ['example-contracts/returndatasize', 'WillNotSupport'],
  ['example-contracts/simple-storage-var', 'Success'],
  ['example-contracts/sstore-sload', 'WillNotSupport'],
  ['example-contracts/state_variables', 'Success'],
  ['example-contracts/structs', 'Success'],
  ['example-contracts/tupleAssignment7', 'Success'],
  ['example-contracts/tupleAssignment8', 'SolCompileFailed'],
  ['example-contracts/typeConversion/explicitTypeConversion', 'Success'],
  ['example-contracts/typeConversion/implicitReturnConversion', 'CairoCompileFailed'],
  ['example-contracts/typeConversion/implicit_type_conv', 'Success'],
  ['example-contracts/typeConversion/shifts', 'Success'],
  ['example-contracts/typeMinMax', 'Success'],
  ['example-contracts/units', 'Success'],
  ['example-contracts/usingReturnValues', 'Success'],
  ['example-contracts/variable-declarations', 'NotSupportedYet'],
  ['example-contracts/view-function', 'Success'],
]);

export function runTests(force: boolean, onlyResults: boolean, unsafe = false, exact = false) {
  const results = new Map<string, ResultType>();
  if (force) {
    postTestCleanup();
  } else if (!preTestChecks()) return;
  findSolSourceFilePaths('example-contracts', true).forEach((file) =>
    runSolFileTest(file, results, onlyResults, unsafe),
  );
  findCairoSourceFilePaths('example-contracts', true).forEach((file) => {
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
  if (!checkNoCairo('example-contracts')) {
    console.log(
      'Please remove all .cairo files from example-contracts, or run with -f to delete them',
    );
    return false;
  }
  if (!checkNoJson('example-contracts')) {
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
    compileSolFile(file, false)
      .map((ast) => transpile(ast, { strict: true }))
      .forEach((cairo) => fs.writeFileSync(`${file.slice(0, -4)}.cairo`, cairo));
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

function getTestsWithUnexpectedResults(results: Map<string, ResultType>): string[] {
  const testsWithUnexpectedResults: string[] = [];
  [...results.entries()].forEach((e) => {
    const expected = expectedResults.get(e[0]);
    if (e[1] != expected) {
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
      console.log(`Actual outcome: ${results.get(o)}`);
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
  deleteCairoSource('example-contracts');
  deleteJson('example-contracts');
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

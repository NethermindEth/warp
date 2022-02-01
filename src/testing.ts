import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths, findSolSourceFilePaths } from './io';
import { compileSolFile } from './solCompile';
import { compileCairo } from './starknetCompile';
import { transpile } from './transpiler';
import {
  NotSupportedYetError,
  TranspilationAbandonedError,
  WillNotSupportError,
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

export function runTests(force: boolean, onlyResults: boolean, unsafe = false) {
  const results = new Map<string, ResultType>();
  if (force) {
    postTestCleanup();
  } else if (!preTestChecks()) return;
  findCairoSourceFilePaths('warplib', true).forEach((file) => {
    runCairoFileTest(file, results, onlyResults, unsafe);
  });
  findSolSourceFilePaths('example-contracts', true).forEach((file) =>
    runSolFileTest(file, results, onlyResults, unsafe),
  );
  findCairoSourceFilePaths('example-contracts', true).forEach((file) => {
    runCairoFileTest(file, results, onlyResults);
  });
  printResults(results);
  postTestCleanup();
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
  if (compileCairo(file)) {
    results.set(removeExtension(file), 'Success');
  } else {
    if (throwError) {
      throw new Error(`Compilation of ${file} failed`);
    }
    results.set(removeExtension(file), 'CairoCompileFailed');
  }
}

function printResults(results: Map<string, ResultType>): void {
  const totals = new Map<ResultType, number>();
  [...results.values()].forEach((r) => totals.set(r, (totals.get(r) ?? 0) + 1));
  console.log(
    `[${[...totals.entries()]
      .map(([result, count]) => `${result}: ${count}/${results.size}`)
      .join(', ')}]`,
  );
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

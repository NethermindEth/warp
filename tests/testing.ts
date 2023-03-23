import path from 'path';
import { CompileFailedError } from 'solc-typed-ast';
import { findAllFiles, findCairoSourceFilePaths } from '../src/io';
import { compileSolFiles } from '../src/solCompile';
import { compileCairo1 } from '../src/starknetCli';
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

export const solCompileResultTypes = [
  'SolCompileFailed',
  'NotSupportedYet',
  'WillNotSupport',
  'TranspilationFailed',
  'Sucess',
];

export const cairoCompileResultTypes = ['CairoCompileFailed', 'Success'];

export type ResultType =
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

export function preTestChecks(warpTestFolder: string): boolean {
  if (!checkNoCairo(warpTestFolder) || !checkNoJson(warpTestFolder)) {
    console.log('Please remove warpTest/exampleContracts, or run with --force to delete it');
    return false;
  }
  if (!checkNoJson('warplib')) {
    console.log('Please remove all json files from warplib, or run with --force to delete them');
    return false;
  }
  return true;
}

export function runSolFileTest(
  warpTest: string,
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  unsafe: boolean,
): { cairoFiles: string[]; result: ResultType } {
  const mangledPath = path.join(warpTest, file);
  const cairoFiles: string[] = [];
  try {
    transpile(compileSolFiles([file], { warnings: false }), { strict: true, dev: true }).forEach(
      ([file, cairo]) => {
        outputFileSync(path.join(warpTest, file), cairo);
        cairoFiles.push(path.join(warpTest, file));
      },
    );
    results.set(mangledPath, 'Success');
    return {
      cairoFiles: cairoFiles,
      result: 'Success',
    };
  } catch (e) {
    if (e instanceof CompileFailedError) {
      if (!onlyResults) printCompileErrors(e);
      results.set(mangledPath, 'SolCompileFailed');
      return {
        cairoFiles: cairoFiles,
        result: 'SolCompileFailed',
      };
    } else if (e instanceof TranspilationAbandonedError) {
      if (!onlyResults) console.log(`Transpilation abandoned ${e.message}`);
      if (e instanceof NotSupportedYetError) {
        results.set(mangledPath, 'NotSupportedYet');
        return {
          cairoFiles: cairoFiles,
          result: 'NotSupportedYet',
        };
      } else if (e instanceof WillNotSupportError) {
        results.set(mangledPath, 'WillNotSupport');
        return {
          cairoFiles: cairoFiles,
          result: 'WillNotSupport',
        };
      } else {
        results.set(mangledPath, 'TranspilationFailed');
        if (unsafe) throw e;
        return {
          cairoFiles: cairoFiles,
          result: 'TranspilationFailed',
        };
      }
    } else {
      if (!onlyResults) console.log('Transpilation failed');
      if (!onlyResults) console.log(e);
      results.set(mangledPath, 'TranspilationFailed');
      if (unsafe) throw e;
      return {
        cairoFiles: cairoFiles,
        result: 'TranspilationFailed',
      };
    }
  }
}

export function runCairoFileTest(
  file: string,
  results: Map<string, ResultType>,
  onlyResults: boolean,
  throwError = false,
): ResultType {
  if (!onlyResults) console.log(`Compiling ${file}`);
  if (compileCairo1(file, !onlyResults).success) {
    results.set(file, 'Success');
    return 'Success';
  } else {
    if (throwError) {
      throw new Error(error(`Compilation of ${file} failed`));
    }
    results.set(file, 'CairoCompileFailed');
    return 'CairoCompileFailed';
  }
}

function combineResults(results: ResultType[]): ResultType {
  return results.reduce((prev, current) =>
    ResultTypeOrder.indexOf(prev) > ResultTypeOrder.indexOf(current) ? prev : current,
  );
}

export function getTestsWithUnexpectedResults(
  expectedResults: Map<string, ResultType>,
  results: Map<string, ResultType>,
): string[] {
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

export function printResults(
  expectedResults: Map<string, ResultType>,
  results: Map<string, ResultType>,
  unexpectedResults: string[],
): void {
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

export function postTestCleanup(warpTestFolder: string): void {
  deleteJson('warplib');
  fs.rmSync(warpTestFolder, { recursive: true, force: true });
}

function deleteJson(path: string): void {
  findAllFiles(path, true)
    .filter((file) => file.endsWith('.json'))
    .forEach((file) => fs.unlinkSync(file));
}

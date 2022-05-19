import { execSync } from 'child_process';
import * as fs from 'fs-extra';
import { OutputOptions } from '.';
import { compileCairo } from './starknetCli';
import { TranspileFailedError, logError } from './utils/errors';

export const solABIPrefix = '# SolABI:';

export function isValidSolFile(path: string, printError = true): boolean {
  if (!fs.existsSync(path)) {
    if (printError) logError(`${path} doesn't exist`);
    return false;
  }

  if (!fs.lstatSync(path).isFile()) {
    if (printError) logError(`${path} is not a file`);
    return false;
  }

  if (!path.endsWith('.sol')) {
    if (printError) logError(`${path} is not a solidity source file`);
    return false;
  }

  return true;
}

export function findSolSourceFilePaths(targetPath: string, recurse: boolean): string[] {
  return findAllFiles(targetPath, recurse).filter((path) => path.endsWith('.sol'));
}

export function findCairoSourceFilePaths(targetPath: string, recurse: boolean): string[] {
  return findAllFiles(targetPath, recurse).filter((path) => path.endsWith('.cairo'));
}

export function findAllFiles(targetPath: string, recurse: boolean): string[] {
  const targetInformation = fs.lstatSync(targetPath);
  if (targetInformation.isDirectory()) {
    return evaluateDirectory(targetPath, recurse);
  } else if (targetInformation.isFile()) {
    return [targetPath];
  } else {
    // TODO check all non-file, non-directory options and remove this
    console.log(`WARNING: Found ${targetPath}, which is neither a file nor directory`);
    return [];
  }
}

function evaluateDirectory(path: string, recurse: boolean): string[] {
  return fs.readdirSync(path, { withFileTypes: true }).flatMap((dirEntry) => {
    if (!recurse && dirEntry.isDirectory()) {
      return [];
    }
    return findAllFiles(`${path}/${dirEntry.name}`, recurse);
  });
}

export function outputResult(
  solidityPath: string,
  code: string,
  options: OutputOptions,
  suffix: string,
  abi?: string,
): void {
  const inputFileNameRoot = solidityPath.endsWith('.sol')
    ? solidityPath.slice(0, -'.sol'.length)
    : solidityPath;
  const codeOutput = `${inputFileNameRoot}${suffix}`;
  const codeWithABI = abi ? `${code}\n\n${solABIPrefix} ${abi}` : code;

  if (options.outputDir === undefined) {
    if (options.result) {
      console.log(`#--- ${codeOutput} ---\n${code}\n#---`);
    }
  } else {
    if (fs.existsSync(options.outputDir)) {
      const targetInformation = fs.lstatSync(options.outputDir);
      if (!targetInformation.isDirectory()) {
        throw new TranspileFailedError(
          `Cannot output to ${options.outputDir}. Output-dir must be a directory`,
        );
      }
    }
    const fullCodeOutPath = `${options.outputDir}/${codeOutput}`;
    fs.outputFileSync(fullCodeOutPath, codeWithABI);
    formatOutput(fullCodeOutPath);

    if (options.compileCairo) {
      const { resultPath, abiPath } = compileCairo(fullCodeOutPath, options.outputDir);
      if (resultPath) {
        fs.unlinkSync(resultPath);
      }
      if (abiPath) {
        fs.unlinkSync(abiPath);
      }
    }
  }
}

function formatOutput(filePath: string): void {
  execSync(`cairo-format -i ${filePath}`);
}

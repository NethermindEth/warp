import { execSync } from 'child_process';
import * as path from 'path';
import * as fs from 'fs-extra';
import { OutputOptions } from '.';
import { TranspileFailedError, logError } from './utils/errors';

export const solABIPrefix = '// Original soldity abi:';

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

export function createCairoFileName(solidityPath: string, suffix: string): string {
  const inputFileNameRoot = solidityPath.endsWith('.sol')
    ? solidityPath.slice(0, -'.sol'.length)
    : solidityPath;
  return `${inputFileNameRoot}${suffix}`;
}

export function outputResult(
  solidityPath: string,
  code: string,
  options: OutputOptions,
  suffix: string,
  abi?: string,
): void {
  const codeOutput = createCairoFileName(solidityPath, suffix);
  const codeWithABI = abi ? `${code}\n\n${solABIPrefix} ${abi}` : code;

  if (options.outputDir === undefined) {
    if (options.result) {
      console.log(`//--- ${codeOutput} ---\n${code}\n//---`);
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
    const fullCodeOutPath = path.join(options.outputDir, codeOutput);
    fs.outputFileSync(fullCodeOutPath, codeWithABI);
    formatOutput(fullCodeOutPath);
  }
}

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;

function formatOutput(filePath: string): void {
  execSync(`${warpVenvPrefix} cairo-format -i ${filePath}`);
}

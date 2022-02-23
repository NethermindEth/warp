import * as fs from 'fs';
import { OutputOptions } from '.';
import { compileCairo } from './starknetCli';
import { TranspileFailedError, logError } from './utils/errors';

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

export function outputResult(solidityPath: string, cairo: string, options: OutputOptions): void {
  const inputFileNameRoot = solidityPath.endsWith('.sol')
    ? solidityPath.slice(0, -4)
    : solidityPath;
  const cairoSourceOutput = `${inputFileNameRoot}.cairo`;

  let outputPath: string;

  if (options.output === undefined) {
    outputPath = '.warp_temp.cairo';
    if (options.result) {
      console.log(`#--- ${cairoSourceOutput} ---\n${cairo}\n#---`);
    }
  } else {
    if (fs.existsSync(options.output)) {
      const targetInformation = fs.lstatSync(options.output);
      if (targetInformation.isDirectory()) {
        outputPath = cairoSourceOutput;
      } else if (targetInformation.isFile()) {
        outputPath = options.output;
      } else {
        // TODO decide on type
        throw new TranspileFailedError(
          `output path ${options.output} is neither a file nor directory`,
        );
      }
    } else {
      outputPath = options.output;
    }
    fs.writeFileSync(outputPath, cairo);
  }

  if (options.compileCairo) {
    if (options.output === undefined) {
      fs.writeFileSync(outputPath, cairo);
    }
    compileCairo(outputPath);
    if (options.output === undefined) {
      fs.unlinkSync(outputPath);
    }
  }
}

export function outputSol(solidityPath: string, solidity: string, options: OutputOptions): void {
  const inputFileNameRoot = solidityPath.endsWith('.sol')
    ? solidityPath.slice(0, -4)
    : solidityPath;
  const transpiledSolSourceOutput = `${inputFileNameRoot}_warp.sol`;

  let outputPath: string;

  if (options.output === undefined) {
    outputPath = '.warp_temp.sol';
    if (options.result) {
      console.log(`#--- ${transpiledSolSourceOutput} ---\n${solidity}\n#---`);
    }
  } else {
    if (fs.existsSync(options.output)) {
      const targetInformation = fs.lstatSync(options.output);
      if (targetInformation.isDirectory()) {
        outputPath = transpiledSolSourceOutput;
      } else if (targetInformation.isFile()) {
        outputPath = options.output;
      } else {
        // TODO decide on type
        throw new TranspileFailedError(
          `output path ${options.output} is neither a file nor directory`,
        );
      }
    } else {
      outputPath = options.output;
    }
    fs.writeFileSync(outputPath, solidity);
  }
}

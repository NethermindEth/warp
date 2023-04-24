import * as path from 'path';
import * as fs from 'fs';
import { OutputOptions, TranspilationOptions } from './cli';
import { TranspileFailedError, logError } from './utils/errors';
import { AST } from './ast/ast';
import { outputFileSync } from './utils/fs';

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

export function replaceSuffix(filePath: string, suffix: string): string {
  const parsedPath = path.parse(filePath);
  return path.join(parsedPath.dir, `${parsedPath.name}${suffix}`);
}

export function outputResult(
  contractName: string,
  outputPath: string,
  code: string,
  options: OutputOptions & TranspilationOptions,
  ast: AST,
): void {
  if (options.outputDir !== undefined) {
    if (fs.existsSync(options.outputDir)) {
      const targetInformation = fs.lstatSync(options.outputDir);
      if (!targetInformation.isDirectory()) {
        throw new TranspileFailedError(
          `Cannot output to ${options.outputDir}. Output-dir must be a directory`,
        );
      }
    }

    const outputLocation = path.parse(path.join(options.outputDir, outputPath));
    const metadataLocation = path.dirname(outputLocation.dir);

    const abiOutPath = path.join(metadataLocation, `${outputLocation.name}_sol_abi.json`);

    const solFilePath = path.dirname(path.dirname(outputPath));
    outputFileSync(
      abiOutPath,
      JSON.stringify(ast.solidityABI.contracts[solFilePath][contractName]['abi'], null, 2),
    );

    const codeOutPath = path.join(outputLocation.dir, outputLocation.base);
    outputFileSync(codeOutPath, code);
    // Cairo-format is disabled, as it has a bug
    // if (options.formatCairo || options.dev) {
    //   const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
    //   execSync(`${warpVenvPrefix} cairo-format -i ${fullCodeOutPath}`);
    // }
  } else {
    console.log(`//--- ${outputPath} ---\n${code}\n//---`);
  }
}

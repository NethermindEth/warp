import assert from 'assert';
import { execSync } from 'child_process';
import * as fs from 'fs';
import {
  ASTReader,
  CompileFailedError,
  extractSpecifiersFromSource,
  getCompilerVersionsBySpecifiers,
} from 'solc-typed-ast';
import { CompilationOptions } from './cli/cli';
import { AST } from './ast/ast';
import { SupportedSolcVersions, nethersolcPath, fullVersionFromMajor } from './nethersolc';
import { TranspileFailedError } from './utils/errors';
import { error } from './utils/formatting';

// For contracts of a reasonable size the json representation of the
// AST was exceeding the buffer size. We leave it unbounded by setting the
// size to the largest possible
const MAX_BUFFER_SIZE = Number.MAX_SAFE_INTEGER;

function compileSolFilesCommon(files: string[], options: CompilationOptions): SolcOutput {
  const sources = files.map((file) => {
    return getSolFileVersion(file);
  });

  sources.forEach((version, i) => {
    const [, majorVersion] = matchCompilerVersion(version);
    if (majorVersion !== '7' && majorVersion !== '8') {
      throw new TranspileFailedError(
        `Unsupported version of solidity source ${version} in file ${files[i]}`,
      );
    }
  });

  if (!sources.every((version) => version === sources[0])) {
    throw new TranspileFailedError(`All solidity files should be the same major version`);
  }

  const solcOutput = cliCompile(formatInput(files), sources[0], options);
  return solcOutput;
}

export function compileSolFiles(files: string[], options: CompilationOptions): AST {
  const solcOutput = compileSolFilesCommon(files, options);
  printErrors(solcOutput.result, options.warnings || false, solcOutput.compilerVersion);
  const reader = new ASTReader();
  const sourceUnits = reader.read(solcOutput.result);

  return new AST(sourceUnits, solcOutput.compilerVersion, solcOutput.result);
}

const supportedVersions = ['0.8.14', '0.7.6'];

function getSolFileVersion(file: string): string {
  const content = fs.readFileSync(file, { encoding: 'utf-8' });
  const pragma = extractSpecifiersFromSource(content);
  const retrievedVersions = getCompilerVersionsBySpecifiers(pragma, supportedVersions);
  const version =
    retrievedVersions.length !== 0 ? retrievedVersions.sort().reverse()[0] : supportedVersions[0];
  return version;
}

type SolcInput = {
  language: 'Solidity';
  sources: {
    [fileName: string]: {
      urls: string[];
    };
  };
  settings?: {
    outputSelection: {
      '*': {
        '*': ['abi'];
        '': ['ast'];
      };
    };
  };
};

function formatInput(fileNames: string[]): SolcInput {
  const sources: { [key: string]: { urls: string[] } } = {};
  fileNames.forEach((fileName) => {
    sources[fileName] = {
      urls: [fileName],
    };
  });
  return {
    language: 'Solidity',
    sources,
    settings: {
      outputSelection: {
        '*': {
          '*': ['abi'],
          '': ['ast'],
        },
      },
    },
  };
}

export type SolcOutput = {
  result: {
    contracts: {
      [path: string]: {
        [contract: string]: {
          abi: [{ [key: string]: string }];
        };
      };
    };
    sources: {
      [path: string]: {
        ast: [{ [key: string]: string }];
      };
    };
  };
  compilerVersion: string;
};

function cliCompile(
  input: SolcInput,
  solcVersion: string,
  options?: CompilationOptions,
): SolcOutput {
  // Determine compiler version to use
  const nethersolcVersion: SupportedSolcVersions = solcVersion.startsWith('0.7.') ? `7` : `8`;
  const solcCommand = nethersolcPath(nethersolcVersion);

  let allowedPaths = '';
  // Check if compiler version used is v0.7.6
  // For solc v0.8.7 and before, we need to set the allow path.
  // Since we are using latest version of v0.8.x, we do not need to set allow path
  // for v0.8.x contracts.
  if (nethersolcVersion === '7') {
    const currentDirectory = execSync(`pwd`).toString().replace('\n', '');
    allowedPaths = `--allow-paths ${currentDirectory}`;
  }

  const includePathOptions =
    options?.includePaths === undefined || nethersolcVersion === '7'
      ? ``
      : `--include-path ${options.includePaths.join(' --include-path ')}`;
  const basePathOption = options?.basePath === undefined ? `` : `--base-path ${options.basePath}`;

  const commandOptions = `--standard-json ${allowedPaths} ${basePathOption} ${includePathOptions}`;

  return {
    result: JSON.parse(
      execSync(`${solcCommand} ${commandOptions}`, {
        input: JSON.stringify(input),
        maxBuffer: MAX_BUFFER_SIZE,
        stdio: ['pipe', 'pipe', 'ignore'],
      }).toString(),
    ),
    compilerVersion: fullVersionFromMajor(nethersolcVersion),
  };
}

function matchCompilerVersion(version: string): [string, string, string] {
  const pattern = /([0-9]+)\.([0-9]+)\.([0-9]+)/;
  const match = pattern.exec(version);
  if (match === null) {
    throw new TranspileFailedError(`Unable to extract version number from "${version}"`);
  }

  return [match[1], match[2], match[3]];
}

function printErrors(cliOutput: unknown, printWarnings: boolean, compilerVersion: string): void {
  assert(
    typeof cliOutput === 'object' && cliOutput !== null,
    error(`Obtained unexpected output from solc: ${cliOutput}`),
  );
  const errorsAndWarnings = Object.entries(cliOutput).find(
    ([propName]) => propName === 'errors',
  )?.[1];
  if (errorsAndWarnings === undefined) return;
  assert(
    errorsAndWarnings instanceof Array,
    error(`Solc error output of unexpected type. ${errorsAndWarnings}`),
  );

  // This also includes output of type info
  const warnings = errorsAndWarnings.filter((data) => data.severity !== 'error');

  if (warnings.length !== 0 && printWarnings) {
    console.log('---Solc warnings:');
    warnings.forEach((warningData) => {
      if (warningData.formattedMessage !== undefined) {
        console.log(warningData.formattedMessage);
        return;
      } else {
        console.log(warningData);
      }
      console.log('-');
    });
    console.log('---');
  }

  const errors = errorsAndWarnings.filter((data) => data.severity === 'error');
  if (errors.length !== 0) {
    throw new CompileFailedError([
      {
        errors: errors.map(
          (error) => error.formattedMessage ?? error(`${error.type}: ${error.message}`),
        ),
        compilerVersion,
      },
    ]);
  }
}

// used for the semantic test suite
export function compileSolFilesAndExtractContracts(file: string): unknown {
  const requiredSolcVersion = getSolFileVersion(file);
  const [, majorVersion] = matchCompilerVersion(requiredSolcVersion);
  if (majorVersion !== '7' && majorVersion !== '8') {
    throw new TranspileFailedError(`Unsupported version of solidity source ${requiredSolcVersion}`);
  }

  const solcOutput = cliCompile(formatInput([file]), requiredSolcVersion);
  assert(typeof solcOutput.result === 'object' && solcOutput.result !== null);
  return Object.entries(solcOutput.result).filter(([name]) => name === 'contracts')[0][1][file];
}

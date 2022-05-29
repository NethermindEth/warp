import assert from 'assert';
import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import {
  ASTReader,
  CompileFailedError,
  extractSpecifiersFromSource,
  getCompilerVersionsBySpecifiers,
} from 'solc-typed-ast';
import { AST } from './ast/ast';
import { SupportedSolcVersions, nethersolcPath, fullVersionFromMajor } from './nethersolc';
import { TranspileFailedError } from './utils/errors';
import { error } from './utils/formatting';

// For contracts of a reasonable size the json representation of the
// AST was exceeding the buffer size. We leave it unbounded by setting the
// size to the largest possible
const MAX_BUFFER_SIZE = Number.MAX_SAFE_INTEGER;

export function compileSolFile(file: string, printWarnings: boolean): AST {
  const requiredSolcVersion = getSolFileVersion(file);
  const [, majorVersion] = matchCompilerVersion(requiredSolcVersion);
  if (majorVersion != '7' && majorVersion != '8') {
    throw new TranspileFailedError(`Unsupported version of solidity source ${requiredSolcVersion}`);
  }

  const { result, compilerVersion } = cliCompile(formatInput(file), requiredSolcVersion);
  printErrors(result, printWarnings, compilerVersion);
  const reader = new ASTReader();
  const sourceUnits = reader.read(result);

  return new AST(sourceUnits, requiredSolcVersion);
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
  language: 'Solidity' | 'Yul';
  sources: {
    [fileName: string]: {
      keccak256?: string;
      urls: string[];
    };
  };
  settings?: {
    outputSelection: {
      '*': {
        '*': ['*'];
        '': ['*'];
      };
    };
  };
};

function formatInput(fileName: string): SolcInput {
  return {
    language: 'Solidity',
    sources: {
      [fileName]: {
        urls: [fileName],
      },
    },
    settings: {
      outputSelection: {
        '*': {
          '*': ['*'],
          '': ['*'],
        },
      },
    },
  };
}

function cliCompile(
  input: SolcInput,
  solcVersion: string,
): { result: unknown; compilerVersion: string } {
  // Determine compiler version to use
  const nethersolcVersion: SupportedSolcVersions = solcVersion.startsWith('0.7.') ? `7` : `8`;
  const solcCommand = nethersolcPath(nethersolcVersion);

  // Check if compiler version used is v0.7.6
  // For solc v0.8.7 and before, we need to set the allow path.
  // Since we are using latest version of v0.8.x, we do not need to set allow path
  // for v0.8.x contracts.
  if (nethersolcVersion == '7') {
    const currentDirectory = execSync(`pwd`).toString().replace('\n', '');
    const filePath = Object.keys(input.sources)[0];
    const allowPath = path.resolve(currentDirectory, filePath);
    return {
      result: JSON.parse(
        execSync(`${solcCommand} --standard-json --allow-paths ${allowPath}`, {
          input: JSON.stringify(input),
          maxBuffer: MAX_BUFFER_SIZE,
        }).toString(),
      ),
      compilerVersion: fullVersionFromMajor(nethersolcVersion),
    };
  }
  return {
    result: JSON.parse(
      execSync(`${solcCommand} --standard-json`, {
        input: JSON.stringify(input),
        maxBuffer: MAX_BUFFER_SIZE,
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

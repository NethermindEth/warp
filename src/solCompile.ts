import assert = require('assert');
import { execSync } from 'child_process';
import * as fs from 'fs';
import {
  ASTReader,
  CompileFailedError,
  extractSpecifiersFromSource,
  getCompilerVersionsBySpecifiers,
} from 'solc-typed-ast';
import { AST } from './ast/ast';
import { error, TranspileFailedError } from './utils/errors';

export function compileSolFile(file: string, printWarnings: boolean): AST {
  const requiredSolcVersion = getSolFileVersion(file);
  const result = cliCompile(formatInput(file), requiredSolcVersion);
  printErrors(result, printWarnings);
  const reader = new ASTReader();
  const sourceUnits = reader.read(result);
  const compilerVersion = getCompilerVersion();
  assert(compilerVersion !== undefined, 'compileSol should return a defined compiler version');
  return new AST(sourceUnits, compilerVersion);
}

const supportedVersions = ['0.8.12', '0.7.6'];

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

function cliCompile(input: SolcInput, solcVersion: string): unknown {
  // Determine compiler version to use
  const solcCommand = solcVersion.startsWith('0.7.') ? `./solc-v0.7.6` : `solc`;

  // Check if compiler version used is v0.7.6
  // For solc v0.8.7 and before, we need to set the allow path.
  // Since we are using latest version of v0.8.x, we do not need to set allow path
  // for v0.8.x contracts.
  if (solcVersion.startsWith('0.7.')) {
    const currentDirectory = execSync(`pwd`).toString().replace('\n', '');
    const filePath = Object.keys(input.sources)[0];
    const allowPath = `${currentDirectory}/${filePath}`;
    return JSON.parse(
      execSync(`${solcCommand} --standard-json --allow-paths ${allowPath}`, {
        input: JSON.stringify(input),
      }).toString(),
    );
  }
  return JSON.parse(
    execSync(`${solcCommand} --standard-json`, { input: JSON.stringify(input) }).toString(),
  );
}

function getCompilerVersion(): string {
  const fullVersion = execSync('solc --version').toString();
  const pattern = /[0-9]+\.[0-9]+\.[0-9]+/;
  const match = pattern.exec(fullVersion);
  if (match === null) {
    throw new TranspileFailedError(`Unable to extract version number from "${fullVersion}"`);
  }

  return match.toString();
}

function printErrors(cliOutput: unknown, printWarnings: boolean): void {
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
        compilerVersion: getCompilerVersion(),
      },
    ]);
  }
}

import assert = require('assert');
import { ASTReader, CompileFailedError } from 'solc-typed-ast';
import { AST } from './ast/ast';
import { execSync } from 'child_process';
import { TranspileFailedError } from './utils/errors';

export function compileSolFile(file: string, printWarnings: boolean): AST[] {
  const result = cliCompile(formatInput(file));
  printErrors(result, printWarnings);
  const reader = new ASTReader();
  const sourceUnits = reader.read(result);
  const compilerVersion = getCompilerVersion();
  assert(compilerVersion !== undefined, 'compileSol should return a defined compiler version');
  // Reverse the list so that each AST can only depend on ASTs earlier in the list
  return sourceUnits.map((node) => new AST(node, compilerVersion)).reverse();
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

function cliCompile(input: SolcInput): unknown {
  return JSON.parse(execSync(`solc --standard-json`, { input: JSON.stringify(input) }).toString());
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
    `Obtained unexpected output from solc: ${cliOutput}`,
  );
  const errorsAndWarnings = Object.entries(cliOutput).find(
    ([propName]) => propName === 'errors',
  )?.[1];
  if (errorsAndWarnings === undefined) return;
  assert(
    errorsAndWarnings instanceof Array,
    `Solc error output of unexpected type. ${errorsAndWarnings}`,
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
        errors: errors.map((error) => error.formattedMessage ?? `${error.type}: ${error.message}`),
        compilerVersion: getCompilerVersion(),
      },
    ]);
  }
}

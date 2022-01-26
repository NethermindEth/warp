import assert = require('assert');
import { ASTReader } from 'solc-typed-ast';
import { AST } from './ast/ast';
import { execSync } from 'child_process';
import { TranspileFailedError } from './utils/errors';

export function compileSolFile(file: string): AST[] {
  const result = cliCompile(formatInput(file));
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

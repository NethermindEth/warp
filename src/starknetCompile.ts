import assert = require('assert');
import { execSync } from 'child_process';

export function compileCairo(filePath: string): boolean {
  assert(filePath.endsWith('.cairo'), `Attempted to compile non-cairo file ${filePath} as cairo`);
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const resultPath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;
  const parameters = new Map([
    ['output', resultPath],
    ['abi', abiPath],
  ]);
  const cairoPath = extractCairoPath(filePath);
  if (cairoPath !== '') {
    parameters.set('cairo_path', cairoPath);
  }
  try {
    runStarknetCompile(filePath, parameters);
    console.log('Success');
    return true;
  } catch (e) {
    if (e instanceof Error) {
      console.log('Compile failed');
      return false;
    } else {
      throw e;
    }
  }
}

function runStarknetCompile(filePath: string, cliOptions: Map<string, string>) {
  console.log(`Running starknet compile with cairoPath ${cliOptions.get('cairo_path')}`);
  execSync(
    `starknet-compile ${filePath} ${[...cliOptions.entries()]
      .map(([key, value]) => `--${key} ${value}`)
      .join(' ')}`,
    { stdio: 'inherit' },
  );
}

// TODO use actual path libraries rather than doing this manually
function extractCairoPath(filePath: string): string {
  return filePath.split('/').slice(0, -1).join('/');
}

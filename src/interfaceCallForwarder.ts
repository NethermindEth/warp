import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';
import { SolcInterfaceGenOptions } from './index';
import fs from 'fs';
import { execSync } from 'child_process';

import { AST } from './ast/ast';
import { SourceUnit } from 'solc-typed-ast';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const defaultCompilerVersion = '0.8.14';

export function generateSolInterface(filePath: string, options: SolcInterfaceGenOptions) {
  const { success } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debug_info: false,
  });
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const jsonCairoPath = `${cairoPathRoot}.json`;

  let solPath = `${cairoPathRoot}.sol`;

  if (options.output) {
    solPath = options.output;
  }

  const parameters = new Map([['output', solPath]]);

  parameters.set('cairo_path', path.resolve(__dirname, '..'));

  execSync(
    `${warpVenvPrefix} python3 ../interface_call_forwarder/generate_cairo_json.py ${filePath} ${[
      ...parameters.entries(),
    ]
      .map(([key, value]) => `--${key} ${value}`)
      .join(' ')}`,
    { stdio: 'inherit' },
  );

  const jsonCairo = JSON.parse(fs.readFileSync(jsonCairoPath, 'utf8'));
}

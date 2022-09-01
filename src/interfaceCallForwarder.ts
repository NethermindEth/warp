import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';
import { SolcInterfaceGenOptions } from './index';
import fs from 'fs';
import { execSync } from 'child_process';

import {
  ASTWriter,
  ContractDefinition,
  ContractKind,
  DefaultASTWriterMapping,
  PragmaDirective,
  PrettyFormatter,
  SourceUnit,
} from 'solc-typed-ast';
import { removeExcessNewlines } from './utils/formatting';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const defaultCompilerVersion = '0.8.14';

let idCount = 0;

function getNewId(): number {
  return idCount++;
}

function getPragmaDirective(version: string): PragmaDirective {
  const id = getNewId();
  const src = '';
  const name = 'solidity';
  const value = version;
  const raw = {
    id,
    src,
    name,
    value,
  };
  return new PragmaDirective(id, src, [name, '^', value], raw);
}

function getForwarderContract(jsonCairo: {
  imports: any[];
  structs: String[][];
  forwarder_interface: string[];
}): ContractDefinition {
  const id = getNewId();
  const src = '';
  const name = 'Forwarder';
  const contractDocs = [
    'warp-cairo',
    jsonCairo.imports.join('\n'),
    jsonCairo.structs.map((struct: String[]) => struct.join('\n')).join('\n'),
    jsonCairo.forwarder_interface
      .map((s: string) => (s.startsWith('@') ? `DECORATOR(${s.slice(1)})` : s))
      .join('\n'),
  ].join('\n');
  return new ContractDefinition(
    id,
    src,
    name,
    -1,
    ContractKind.Contract,
    false,
    true,
    [],
    [],
    contractDocs,
  );
}

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
  console.log(jsonCairo);
  console.log(solPath);

  const sourceUnitChildren = [
    getPragmaDirective(options.solc_version ?? defaultCompilerVersion),
    getForwarderContract(jsonCairo),
  ];

  const writer = new ASTWriter(
    DefaultASTWriterMapping,
    new PrettyFormatter(4, 0),
    options.solc_version ?? defaultCompilerVersion,
  );

  const result: String = removeExcessNewlines(
    writer.write(
      new SourceUnit(getNewId(), '', solPath, 0, solPath, new Map(), sourceUnitChildren),
    ),
    2,
  );

  console.log(result);
}

// {
//   abi: [
//     { name: 'AA', type: 'struct', members: [Array], size: 3 },
//     { name: 'Uint256', type: 'struct', members: [Array], size: 2 },
//     {
//       name: 'use_struct',
//       type: 'function',
//       inputs: [Array],
//       outputs: [Array],
//       stateMutability: 'view',
//       stub: [Array]
//     }
//   ],
//   forwarder_interface: [
//     '@contract_interface',
//     'namespace Forwarder:',
//     '    func use_struct(addr : felt, a : AA) -> (val : Uint256):',
//     '    end',
//     'end'
//   ],
//   imports: [
//     'from warplib.maths.external_input_check_ints import warp_external_input_check_int256',
//     'from starkware.cairo.common.uint256 import Uint256',
//     'from warplib.maths.add import warp_add256',
//     'from starkware.cairo.common.cairo_builtins import HashBuiltin'
//   ],
//   structs: [
//     [
//       'struct AA:',
//       '    member a : Uint256',
//       '    member b : felt',
//       'end'
//     ]
//   ],
//   functions: [
//     [
//       'func use_struct(addr : felt, a : AA) -> (val : Uint256):',
//       'end'
//     ]
//   ]
// }

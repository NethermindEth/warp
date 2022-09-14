import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';
import { SolcInterfaceGenOptions } from './index';
import fs from 'fs';
import { execSync } from 'child_process';

import {
  ASTWriter,
  Block,
  ContractDefinition,
  ContractKind,
  DefaultASTWriterMapping,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
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
  imports: string[];
  structs: string[][];
  forwarder_interface: string[];
}): ContractDefinition {
  const id = getNewId();
  const src = '';
  const name = 'WARP';
  const contractDocs = [
    'warp-cairo',
    jsonCairo.imports.join('\n'),
    jsonCairo.structs.map((struct: string[]) => struct.join('\n')).join('\n'),
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

function getFreeFunctions(
  jsonCairo: {
    abi: [{ name: string; type: string; stub: string[] }];
  },
  sourceUnitId: number,
): FunctionDefinition[] {
  let functions: FunctionDefinition[] = [];
  jsonCairo.abi.forEach((element: { name: string; type: string; stub: string[] }) => {
    console.log(element.name, element.type);
    if (element.type !== 'function') return;
    const id = getNewId();
    functions.push(
      new FunctionDefinition(
        id,
        '',
        sourceUnitId,
        FunctionKind.Free,
        element.name,
        false,
        FunctionVisibility.Internal,
        FunctionStateMutability.NonPayable,
        false, // is constructor
        new ParameterList(getNewId(), '', []), // parameters
        new ParameterList(getNewId(), '', []), // return parameters
        [], // modifiers
        undefined, // override specifier
        new Block(getNewId(), '', []), // body
        ['warp-cairo', ...element.stub].join('\n'), // documentation
      ),
    );
  });
  return functions;
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

  if (!solPath.endsWith('.sol')) {
    logError(`Output path ${solPath} must end with .sol`);
    return;
  }

  const parameters = new Map([
    ['output', solPath],
    ['cairo_path', path.resolve(__dirname, '..')],
  ]);

  execSync(
    `${warpVenvPrefix} python3 ../interface_call_forwarder/generate_cairo_json.py ${filePath} ${[
      ...parameters.entries(),
    ]
      .map(([key, value]) => `--${key} ${value}`)
      .join(' ')}`,
    { stdio: 'inherit' },
  );

  const jsonCairo = JSON.parse(fs.readFileSync(jsonCairoPath, 'utf8'));

  const sourceUnitId = getNewId();

  const freeFunctions = getFreeFunctions(jsonCairo, sourceUnitId);

  const sourceUnitChildren = [
    getPragmaDirective(options.solc_version ?? defaultCompilerVersion),
    getForwarderContract(jsonCairo),
    ...freeFunctions,
  ];

  const writer = new ASTWriter(
    DefaultASTWriterMapping,
    new PrettyFormatter(4, 0),
    options.solc_version ?? defaultCompilerVersion,
  );

  const result: string = removeExcessNewlines(
    writer.write(
      new SourceUnit(sourceUnitId, '', solPath, 0, solPath, new Map(), sourceUnitChildren),
    ),
    2,
  );

  fs.writeFileSync(solPath, result);
}

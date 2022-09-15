import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';
import { SolcInterfaceGenOptions } from './index';
import fs from 'fs';
import { execSync } from 'child_process';
import { AST } from './ast/ast';

import {
  ArrayTypeName,
  ASTContext,
  ASTNode,
  ASTNodeConstructor,
  ASTNodeWriter,
  ASTWriter,
  Block,
  ContractDefinition,
  ContractKind,
  DataLocation,
  DefaultASTWriterMapping,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Mutability,
  ParameterList,
  PragmaDirective,
  PrettyFormatter,
  SourceUnit,
  SrcDesc,
  StateVariableVisibility,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { removeExcessNewlines } from './utils/formatting';
import { CairoContract } from './ast/cairoNodes';
import {
  createAddressTypeName,
  createUint256TypeName,
  createUintNTypeName,
} from './utils/nodeTemplates';
import { assert } from 'console';

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

  const writer = new ASTWriter(
    new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
      ...DefaultASTWriterMapping,
      [CairoContract, new CairoContractSolWriter()],
    ]),
    new PrettyFormatter(4, 0),
    options.solc_version ?? defaultCompilerVersion,
  );

  const sourceUint = new SourceUnit(0, '', solPath, 0, solPath, new Map(), []);
  sourceUint.context = new ASTContext(sourceUint);
  const ast = new AST([sourceUint], options.solc_version ?? defaultCompilerVersion);

  addPragmaDirective(options.solc_version ?? defaultCompilerVersion, sourceUint, ast);
  addForwarderContract(jsonCairo, sourceUint, ast);
  addFreeFunctions(jsonCairo, sourceUint, ast);

  const result: string = removeExcessNewlines(writer.write(ast.roots[0] as SourceUnit), 2);

  fs.writeFileSync(solPath, result);
}

function addPragmaDirective(version: string, sourceUint: SourceUnit, ast: AST): void {
  const id = ast.reserveId();
  const src = '';
  const name = 'solidity';
  const value = version;
  const raw = {
    id,
    src,
    name,
    value,
  };
  const pragma = new PragmaDirective(id, src, [name, '^', value], raw);
  sourceUint.appendChild(pragma);
  ast.registerChild(pragma, sourceUint);
}

function addForwarderContract(
  jsonCairo: {
    imports: string[];
    structs: string[][];
    forwarder_interface: string[];
  },
  sourceUint: SourceUnit,
  ast: AST,
): void {
  const id = ast.reserveId();
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
  const contract = new CairoContract(
    id,
    src,
    name,
    -1,
    ContractKind.Contract,
    false,
    true,
    [],
    [],
    new Map(),
    new Map(),
    0,
    0,
    contractDocs,
  );
  sourceUint.appendChild(contract);
  ast.registerChild(contract, sourceUint);
}

function getParametersFromStringRepresentation(
  params: [{ name: string; type: string }],
  scope: number,
  ast: AST,
  return_param = false,
): VariableDeclaration[] {
  const parameters: VariableDeclaration[] = return_param
    ? []
    : [
        new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          'contract_address',
          scope,
          false,
          DataLocation.Default,
          StateVariableVisibility.Internal,
          Mutability.Mutable,
          'address',
          undefined,
          createAddressTypeName(false, ast),
        ),
      ];
  params.forEach((param: { name: string; type: string }) => {
    const solTypeName: TypeName = getSolTypeName(param.type, ast);
    if (solTypeName instanceof ArrayTypeName) {
      assert(
        parameters.length > 0 &&
          parameters[parameters.length - 1].name === param.name + '_len' &&
          parameters[parameters.length - 1].typeString === 'uint248',
        'Array parameters must be preceded by a size parameter',
      );
      parameters.pop();
    }
    parameters.push(
      new VariableDeclaration(
        ast.reserveId(),
        '',
        false,
        false,
        param.name,
        scope,
        false,
        solTypeName instanceof ArrayTypeName ? DataLocation.CallData : DataLocation.Default,
        StateVariableVisibility.Internal,
        Mutability.Mutable,
        solTypeName.typeString,
        undefined,
        solTypeName,
      ),
    );
  });
  return parameters;
}

function addFreeFunctions(
  jsonCairo: {
    abi: [{ name: string; type: string; stub: string[] }];
  },
  sourceUnit: SourceUnit,
  ast: AST,
): void {
  const functions: FunctionDefinition[] = [];
  jsonCairo.abi.forEach(
    (element: { [x: string]: any; name: string; type: string; stub: string[] }) => {
      if (element.type !== 'function') return;
      const id = ast.reserveId();
      const inputParameters: VariableDeclaration[] = getParametersFromStringRepresentation(
        element.inputs,
        id,
        ast,
      );
      const returnParameters: VariableDeclaration[] = getParametersFromStringRepresentation(
        element.outputs,
        id,
        ast,
        true,
      );
      functions.push(
        new FunctionDefinition(
          id,
          '',
          sourceUnit.id,
          FunctionKind.Free,
          element.name,
          false,
          FunctionVisibility.Internal,
          FunctionStateMutability.NonPayable,
          false, // is constructor
          new ParameterList(ast.reserveId(), '', inputParameters), // parameters
          new ParameterList(ast.reserveId(), '', returnParameters), // return parameters
          [], // modifiers
          undefined, // override specifier
          new Block(ast.reserveId(), '', []), // body
          ['warp-cairo', ...element.stub].join('\n'), // documentation
        ),
      );
    },
  );
  functions.forEach((f: FunctionDefinition) => {
    sourceUnit.appendChild(f);
    ast.setContextRecursive(f);
  });
}

class CairoContractSolWriter extends ASTNodeWriter {
  writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
    const result: SrcDesc = [];

    const solContract = new ContractDefinition(
      node.id,
      node.src,
      node.name,
      node.scope,
      node.kind,
      node.abstract,
      node.fullyImplemented,
      node.linearizedBaseContracts,
      node.usedErrors,
      node.documentation,
      node.children,
      node.nameLocation,
      node.raw,
    );
    result.push(writer.write(solContract).slice(0, -1));
    result.push('\n    // Write your logic here\n');
    result.push('}\n');
    return result;
  }
}

function getSolTypeName(cairoTypeString: string, ast: AST): TypeName {
  if (cairoTypeString === 'felt') {
    return createUintNTypeName(248, ast);
  }
  if (cairoTypeString === 'Uint256') {
    return createUint256TypeName(ast);
  }
  // if(cairoTypeString.endsWith('*')){
  //   const baseTypeName : TypeName = getSolTypeName(cairoTypeString.slice(0, -1), ast);
  //   return createArrayTypeName(baseTypeName, ast);
  // }
  throw new Error(`Cairo type: ${cairoTypeString} Not Supported`);
}

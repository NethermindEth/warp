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
  createArrayTypeName,
  createUint256TypeName,
  createUintNTypeName,
} from './utils/nodeTemplates';
import { assert } from 'console';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const defaultSolcVersion = '0.8.14';

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
    [
      'cairo_path',
      path.resolve(__dirname, '..') + options.cairoPath ??
        `:${path.resolve(__dirname, options.cairoPath)}`,
    ],
  ]);

  execSync(
    `${warpVenvPrefix} python3 interface_call_forwarder/generate_cairo_json.py ${filePath} ${[
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
      [CornerTypeName, new CornerTypeNameWriter()],
    ]),
    new PrettyFormatter(4, 0),
    options.solcVersion ?? defaultSolcVersion,
  );

  const sourceUint = new SourceUnit(0, '', solPath, 0, solPath, new Map(), []);
  sourceUint.context = new ASTContext(sourceUint);
  const ast = new AST([sourceUint], options.solcVersion ?? defaultSolcVersion);

  addPragmaDirective(options.solcVersion ?? defaultSolcVersion, sourceUint, ast);
  addForwarderContract(jsonCairo, sourceUint, ast);
  addFreeFunctions(jsonCairo, sourceUint, ast);

  const result: string =
    contractComments() + removeExcessNewlines(writer.write(ast.roots[0] as SourceUnit), 2);

  fs.writeFileSync(solPath, result);
}

function contractComments(): string {
  const comments: string[] = [
    '// SOME POINTS TO BE TAKEN CARE OF BEFORE TRANSPILING THIS CONTRACT:',
    '// 1. Handle the conflicting imports and structs after transpiling this the contract',
    '// 2. replace <TYPE> with appropriate solidity type , you can infer struct members from',
    '// \t the WARP contract stubs',
    '// 3. You must have the address of the deployed CAIRO CONTRACT you want to interact with',
    '// 4. You can use these free functions defined in this file to interact with the cairo contract',
    '// 5. Replace functions:[ wm_to_calldata_NUM, cd_to_memory_NUM] with appropriate function names (probably replace NUM) after transpiling this contract',
    '// 6. Replace the data type cd_dynarray_OBJECT_TYPE with appropriate object type after transpiling this contract',
    '\n\n',
  ];
  return comments.join('\n');
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
    // TODO: add struct automation can be done using topological dependency struct ordering
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
  struct_names: string[],
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
    const solTypeName: TypeName = getSolTypeName(param.type, ast, struct_names);
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
        solTypeName instanceof ArrayTypeName ? DataLocation.Memory : DataLocation.Default,
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
    abi: [
      {
        outputs: [{ name: string; type: string }];
        inputs: [{ name: string; type: string }];
        name: string;
        type: string;
        stub: string[];
      },
    ];
  },
  sourceUnit: SourceUnit,
  ast: AST,
): void {
  const struct_names = jsonCairo.abi
    .filter((x: { name: string; type: string }) => x.type === 'struct')
    .map((x: { name: string; type: string }) => {
      return x.name;
    });
  const functions: FunctionDefinition[] = [];
  jsonCairo.abi.forEach((element) => {
    if (element.type !== 'function') return;
    const id = ast.reserveId();
    const inputParameters: VariableDeclaration[] = getParametersFromStringRepresentation(
      element.inputs,
      id,
      ast,
      struct_names,
    );
    const returnParameters: VariableDeclaration[] = getParametersFromStringRepresentation(
      element.outputs,
      id,
      ast,
      struct_names,
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
  });
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

class CornerTypeNameWriter extends ASTNodeWriter {
  writeInner(node: CornerTypeName, _writer: ASTWriter): SrcDesc {
    const result: SrcDesc = [];
    result.push(node.typeString);
    return result;
  }
}

class CornerTypeName extends TypeName {
  constructor(id: number, src: string, typeString: string) {
    super(id, src, typeString);
  }
}

function getSolTypeName(cairoTypeString: string, ast: AST, struct_names: string[]): TypeName {
  if (cairoTypeString.endsWith('*')) {
    const baseTypeName: TypeName = getSolTypeName(cairoTypeString.slice(0, -1), ast, struct_names);
    return createArrayTypeName(baseTypeName, ast);
  }
  if (cairoTypeString === 'felt') {
    return createUintNTypeName(248, ast);
  }
  if (cairoTypeString === 'Uint256') {
    return createUint256TypeName(ast);
  }
  if (struct_names.includes(cairoTypeString)) {
    // TODO: replace this with a proper struct type
    // after creation of struct dependency ordering
    return new CornerTypeName(ast.reserveId(), '', '<STRUCT>');
  }
  throw new Error(`Cairo type: ${cairoTypeString} Not Supported`);
}

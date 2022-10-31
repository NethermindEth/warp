import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';
import { SolcInterfaceGenOptions } from './index';
import fs from 'fs';
import { execSync } from 'child_process';
import { AST } from './ast/ast';

import {
  ArrayTypeName,
  Assignment,
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
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Literal,
  LiteralKind,
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
  createBlock,
  createExpressionStatement,
  createIdentifier,
  createUint256TypeName,
} from './utils/nodeTemplates';
import { assert } from 'console';
import { generateLiteralTypeString } from './utils/getTypeString';
import { cloneASTNode } from './utils/cloning';

const defaultSolcVersion = '0.8.14';

export function generateSolInterface(filePath: string, options: SolcInterfaceGenOptions) {
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const { success } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debugInfo: false,
  });

  const resultPath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;

  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  } else {
    fs.unlinkSync(resultPath);
  }

  let solPath = `${cairoPathRoot}.sol`;
  let cairoContractPath = `${cairoPathRoot}_forwarder.cairo`;

  if (options.output) {
    const filePathRoot = options.output.slice(0, -'.sol'.length);
    solPath = options.output;
    cairoContractPath = filePathRoot + '.cairo';
  }

  const abi = JSON.parse(fs.readFileSync(abiPath, 'utf8'));

  // generate forwarder cairo contract
  const cairoContract: string = genCairoContract(abi, options.contractAddress);

  const writer = new ASTWriter(
    new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
      ...DefaultASTWriterMapping,
      [CairoContract, new CairoContractSolWriter()],
      [CornerTypeName, new CornerTypeNameWriter()],
      [CornerStructTypeName, new CornerStructTypeNameWriter()],
    ]),
    new PrettyFormatter(4, 0),
    options.solcVersion ?? defaultSolcVersion,
  );

  const sourceUint = new SourceUnit(0, '', solPath, 0, solPath, new Map(), []);
  sourceUint.context = new ASTContext(sourceUint);
  const ast = new AST([sourceUint], options.solcVersion ?? defaultSolcVersion);

  addPragmaDirective(options.solcVersion ?? defaultSolcVersion, sourceUint, ast);
  addForwarderContract(jsonCairo, sourceUint, ast, fileName, options.contractAddress);

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
  sourceUint: SourceUnit,
  ast: AST,
  fileName: string,
  contract_address?: string,
): void {
  const id = ast.reserveId();
  const src = '';
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
    fileName + '_forwarder',
    sourceUint.id,
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
  addAddressConstructor(contract, ast, contract_address);
  addForwarderFunctions(jsonCairo, contract, ast);
}

function addAddressConstructor(contract: CairoContract, ast: AST, contract_address?: string): void {
  const id = ast.reserveId();
  const addr_type = createAddressTypeName(false, ast);
  const addr_var_decl = new VariableDeclaration(
    ast.reserveId(),
    '',
    false,
    false,
    '__fwd_contract_address',
    contract.id,
    true,
    DataLocation.Default,
    StateVariableVisibility.Public,
    Mutability.Mutable,
    'address',
    'Keep this variable as a first state variable declaration in this contract',
    cloneASTNode(addr_type, ast),
    undefined,
    contract_address
      ? new FunctionCall(
          ast.reserveId(),
          '',
          'address',
          FunctionCallKind.TypeConversion,
          new ElementaryTypeNameExpression(
            ast.reserveId(),
            '',
            'type(address)',
            new ElementaryTypeName(ast.reserveId(), '', 'address', 'address'),
          ),
          [
            new Literal(
              ast.reserveId(),
              '',
              generateLiteralTypeString(contract_address),
              LiteralKind.Number,
              contract_address,
              contract_address,
            ),
          ],
        )
      : undefined,
  );
  contract.appendChild(addr_var_decl);
  ast.registerChild(addr_var_decl, contract);
  const addr_var_param_decl = new VariableDeclaration(
    ast.reserveId(),
    '',
    false,
    false,
    'cairo_contract_address',
    id,
    false,
    DataLocation.Default,
    StateVariableVisibility.Internal,
    Mutability.Mutable,
    addr_type.typeString,
    undefined,
    addr_type,
    undefined,
  );
  const constructor = new FunctionDefinition(
    id,
    '',
    contract.id,
    FunctionKind.Constructor,
    '',
    false,
    FunctionVisibility.Public,
    FunctionStateMutability.NonPayable,
    true,
    new ParameterList(ast.reserveId(), '', [addr_var_param_decl]),
    new ParameterList(ast.reserveId(), '', []),
    [],
    undefined,
  );
  contract.appendChild(constructor);
  ast.registerChild(constructor, contract);
  const constructor_body = createBlock(
    [
      createExpressionStatement(
        ast,
        new Assignment(
          ast.reserveId(),
          '',
          'address',
          '=',
          createIdentifier(addr_var_decl, ast),
          createIdentifier(addr_var_param_decl, ast),
        ),
      ),
    ],
    ast,
  );
  constructor.vBody = constructor_body;
  ast.registerChild(constructor_body, constructor);
}

function getParametersFromStringRepresentation(
  params: [{ name: string; type: string }],
  scope: number,
  ast: AST,
  struct_names: string[],
): VariableDeclaration[] {
  const parameters: VariableDeclaration[] = [];
  params.forEach((param: { name: string; type: string }) => {
    const solTypeName: TypeName = getSolTypeName(param.type, ast, struct_names);
    const param_name = '_var_' + param.name;
    if (solTypeName instanceof ArrayTypeName) {
      assert(
        parameters.length > 0 &&
          parameters[parameters.length - 1].name ===
            param_name +
              (param_name === '_var_calldata' || param_name === '_var_retdata'
                ? '_size'
                : '_len') &&
          parameters[parameters.length - 1].typeString === 'uint256',
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
        param_name,
        scope,
        false,
        solTypeName instanceof ArrayTypeName || solTypeName instanceof CornerStructTypeName
          ? DataLocation.Memory
          : DataLocation.Default,
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

function addForwarderFunctions(
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
  contract: CairoContract,
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
    );
    functions.push(
      new FunctionDefinition(
        id,
        '',
        contract.id,
        FunctionKind.Function,
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
    contract.appendChild(f);
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

class CornerStructTypeNameWriter extends ASTNodeWriter {
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

class CornerStructTypeName extends TypeName {
  constructor(id: number, src: string, typeString: string) {
    super(id, src, typeString);
  }
}

function getSolTypeName(cairoTypeString: string, ast: AST, struct_names: string[]): TypeName {
  if (cairoTypeString.endsWith('*')) {
    const baseTypeName: TypeName = getSolTypeName(cairoTypeString.slice(0, -1), ast, struct_names);
    return createArrayTypeName(baseTypeName, ast);
  }

  if (cairoTypeString === 'Uint256' || cairoTypeString === 'felt') {
    return createUint256TypeName(ast);
  }

  if (struct_names.includes(cairoTypeString)) {
    // TODO: replace this with a proper struct type
    // after creation of struct dependency ordering
    return new CornerStructTypeName(ast.reserveId(), '', `<STRUCT:${cairoTypeString}>`);
  }
  // throw new Error(`Cairo type: ${cairoTypeString} Not Supported`);
  return new CornerTypeName(ast.reserveId(), '', `<TYPE:${cairoTypeString}>`);
}

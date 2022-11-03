import { compileCairo } from '../starknetCli';
import * as path from 'path';
import { logError } from '../utils/errors';
import { SolcInterfaceGenOptions } from '../index';
import fs from 'fs';
import { AST } from '../ast/ast';

import {
  ArrayTypeName,
  ASTContext,
  ASTNode,
  ASTNodeConstructor,
  ASTNodeWriter,
  ASTWriter,
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
  StateVariableVisibility,
  StructDefinition,
  TypeName,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { removeExcessNewlines } from '../utils/formatting';

import {
  createArrayTypeName,
  createStaticArrayTypeName,
  createUint256TypeName,
} from '../utils/nodeTemplates';

import { assert } from 'console';

import { genCairoContract } from './genCairo';
import { AbiType, FunctionAbiItemType, StructAbiItemType } from './abiTypes';
import {
  getAllStructsFromABI,
  getFunctionItems,
  getStructsFromABI,
  transformType,
  typeToStructMappping,
} from './utils';
import { safeCanonicalHash } from '../export';

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

  const abi: AbiType = JSON.parse(fs.readFileSync(abiPath, 'utf8'));

  // generate forwarder cairo contract
  let cairoContract: string = genCairoContract(abi, options.contractAddress);

  const writer = new ASTWriter(
    new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([...DefaultASTWriterMapping]),
    new PrettyFormatter(4, 0),
    options.solcVersion ?? defaultSolcVersion,
  );

  const sourceUint = new SourceUnit(0, '', solPath, 0, solPath, new Map(), []);
  sourceUint.context = new ASTContext(sourceUint);
  const ast = new AST([sourceUint], options.solcVersion ?? defaultSolcVersion);

  addPragmaDirective(options.solcVersion ?? defaultSolcVersion, sourceUint, ast);
  const structDefs: Map<string, StructDefinition> = addTransformedStructs(sourceUint, ast, abi);

  const funcSignatures = addForwarderContract(
    abi,
    sourceUint,
    structDefs,
    ast,
    cairoPathRoot.split('/').pop(),
  );

  const result: string = removeExcessNewlines(writer.write(ast.roots[0] as SourceUnit), 2);

  fs.unlinkSync(abiPath);

  funcSignatures.forEach((value, key) => {
    cairoContract = cairoContract.replace(`_ITR_${key}`, `${key}_${value}`);
  });

  fs.writeFileSync(cairoContractPath, cairoContract);
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
  abi: AbiType,
  sourceUint: SourceUnit,
  structDefs: Map<string, StructDefinition>,
  ast: AST,
  fileName: string | undefined,
): Map<string, string> {
  const id = ast.reserveId();

  const contract = new ContractDefinition(
    id,
    '',
    'Forwarder_' + fileName ?? 'contract',
    sourceUint.id,
    ContractKind.Interface,
    false,
    false,
    [],
    [],
  );
  sourceUint.appendChild(contract);
  ast.registerChild(contract, sourceUint);
  return addInteractiveFunctions(
    contract,
    structDefs,
    ast,
    abi,
    typeToStructMappping(getStructsFromABI(abi)),
  );
}

function addTransformedStructs(
  sourceUint: SourceUnit,
  ast: AST,
  abi: AbiType,
): Map<string, StructDefinition> {
  const transformedStructs = new Map<string, StructDefinition>();
  getAllStructsFromABI(abi).forEach((item: StructAbiItemType) => {
    const id = ast.reserveId();
    const struct = new StructDefinition(
      id,
      '',
      item.name,
      sourceUint.id,
      'public',
      item.members.map((member) => {
        const typeName = getSolTypeName(member.type, transformedStructs, ast);
        return new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          member.name,
          id,
          false,
          DataLocation.Default,
          StateVariableVisibility.Internal,
          Mutability.Mutable,
          typeName.typeString,
          undefined,
          typeName,
        );
      }),
    );
    sourceUint.appendChild(struct);
    ast.registerChild(struct, sourceUint);
    transformedStructs.set(item.name, struct);
  });
  return transformedStructs;
}

function getSolTypeName(
  cairoType: string,
  structDefs: Map<string, StructDefinition>,
  ast: AST,
): TypeName {
  cairoType = cairoType.trim();
  if (cairoType === 'Uint256' || cairoType === 'felt') {
    return createUint256TypeName(ast);
  }
  if (cairoType.endsWith('*')) {
    const baseTypeName: TypeName = getSolTypeName(cairoType.slice(0, -1), structDefs, ast);
    return createArrayTypeName(baseTypeName, ast);
  }
  if (cairoType.startsWith('(') && cairoType.endsWith(')')) {
    const subTypes: string[] = cairoType
      .slice(1, -1)
      .split(',')
      .map((type) => type.trim());
    // assert all subtypes are the same string
    // Since there is no way to represent a tuple in solidity,
    // we will represent it as an array of the same type
    assert(
      subTypes.every((subType) => subType === subTypes[0]),
      'Tuple types must be homogeneous',
    );
    const baseTypeName: TypeName = getSolTypeName(subTypes[0], structDefs, ast);
    return createStaticArrayTypeName(baseTypeName, subTypes.length, ast);
  }
  if (structDefs.has(cairoType)) {
    const refStructDef = structDefs.get(cairoType);
    if (refStructDef === undefined) {
      throw new Error(`Could not find struct definition for ${cairoType}`);
    }
    return new UserDefinedTypeName(
      ast.reserveId(),
      '',
      `struct ${cairoType}`,
      cairoType,
      refStructDef.id,
    );
  }
  throw new Error(`Unsupported Cairo type ${cairoType}`);
}

function getParametersCairoType(
  params: { name: string; type: string }[],
  scope: number,
  structDefs: Map<string, StructDefinition>,
  ast: AST,
  typeToStructMap: Map<string, StructAbiItemType>,
): VariableDeclaration[] {
  const parameters: VariableDeclaration[] = [];
  params.forEach((param: { name: string; type: string }) => {
    const transformedType = transformType(param.type, typeToStructMap);
    const solTypeName: TypeName = getSolTypeName(transformedType, structDefs, ast);

    if (solTypeName instanceof ArrayTypeName && solTypeName.vLength === undefined) {
      assert(
        parameters.length > 0 &&
          parameters[parameters.length - 1].name === param.name + '_len' &&
          parameters[parameters.length - 1].typeString === 'uint256',
        `Array argument "${param.name}" must be preceded by a length argument named "${param.name}_len" of type felt`,
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
        DataLocation.Default,
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

function addInteractiveFunctions(
  contract: ContractDefinition,
  structDefs: Map<string, StructDefinition>,
  ast: AST,
  abi: AbiType,
  typeToStructMap: Map<string, StructAbiItemType>,
): Map<string, string> {
  const functionItems = getFunctionItems(abi);
  const functions: FunctionDefinition[] = [];

  functionItems.forEach((element: FunctionAbiItemType) => {
    const id = ast.reserveId();
    const inputParameters: VariableDeclaration[] = getParametersCairoType(
      element.inputs,
      id,
      structDefs,
      ast,
      typeToStructMap,
    );
    const returnParameters: VariableDeclaration[] = getParametersCairoType(
      element.outputs,
      id,
      structDefs,
      ast,
      typeToStructMap,
    );
    functions.push(
      new FunctionDefinition(
        id,
        '',
        contract.id,
        FunctionKind.Function,
        element.name,
        false,
        FunctionVisibility.External,
        FunctionStateMutability.NonPayable,
        false, // is constructor
        new ParameterList(ast.reserveId(), '', inputParameters), // parameters
        new ParameterList(ast.reserveId(), '', returnParameters), // return parameters
        [], // modifiers
        undefined, // override specifier
        undefined, // body
      ),
    );
  });
  const signatures = new Map<string, string>();
  functions.forEach((f: FunctionDefinition) => {
    contract.appendChild(f);
    ast.setContextRecursive(f);
    // set function array/complex parameters to be calldata
    f.vParameters.vParameters.forEach((param: VariableDeclaration) => {
      if (
        param.vType instanceof ArrayTypeName ||
        (param.vType instanceof UserDefinedTypeName &&
          param.vType.vReferencedDeclaration instanceof StructDefinition)
      ) {
        param.storageLocation = DataLocation.CallData;
      }
    });
    // set function return array/complex parameters to be Calldata
    f.vReturnParameters.vParameters.forEach((param: VariableDeclaration) => {
      if (
        param.vType instanceof ArrayTypeName ||
        (param.vType instanceof UserDefinedTypeName &&
          param.vType.vReferencedDeclaration instanceof StructDefinition)
      ) {
        param.storageLocation = DataLocation.CallData;
      }
    });
    signatures.set(f.name, safeCanonicalHash(f, ast));
  });
  return signatures;
}

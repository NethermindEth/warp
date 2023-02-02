import { compileCairo } from '../starknetCli';
import * as path from 'path';
import { logError } from '../utils/errors';
import { SolcInterfaceGenOptions } from '../cli';
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
  tupleParser,
  typeToStructMapping,
} from './utils';
import { runStarkNetClassHash, safeCanonicalHash } from '../export';

const defaultSolcVersion = '0.8.14';

/**
 * Generate a cairo & solidity interface from given cairo contract file to interact
 * with it (given cairo contract) from a solidity contract.
 * More details you can find in the README.md file.
 * @param filePath : path to the cairo contract file
 * @param options : options for the generation (solc version, output directory, etc.)
 * @returns : none
 */
export function generateSolInterface(filePath: string, options: SolcInterfaceGenOptions) {
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const { success, resultPath, abiPath } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debugInfo: false,
  });

  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  } else {
    if (resultPath) fs.unlinkSync(resultPath);
  }

  let solPath = `${cairoPathRoot}.sol`; // default path for the generated solidity file
  let cairoContractPath = `${cairoPathRoot}_forwarder.cairo`; // default path for the generated cairo contract file

  if (options.output) {
    const filePathRoot = options.output.slice(0, -'.sol'.length);
    solPath = options.output;
    cairoContractPath = filePathRoot + '.cairo';
  }

  const abi: AbiType = abiPath ? JSON.parse(fs.readFileSync(abiPath, 'utf8')) : [];

  // generate the cairo contract that will be used to interact with the given cairo contract
  let cairoContract: string = genCairoContract(abi, options.contractAddress, options.classHash);

  const writer = new ASTWriter(
    new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([...DefaultASTWriterMapping]),
    new PrettyFormatter(4, 0),
    options.solcVersion ?? defaultSolcVersion,
  );

  const sourceUint = new SourceUnit(0, '', solPath, 0, solPath, new Map(), []);
  sourceUint.context = new ASTContext(sourceUint);
  const ast = new AST([sourceUint], options.solcVersion ?? defaultSolcVersion, {
    contracts: {},
    sources: {},
  });

  addPragmaDirective(options.solcVersion ?? defaultSolcVersion, sourceUint, ast);

  // add uint256 version of the structs from the cairo contract after transformation
  // of all felt types to uint256 to the source unit and also the structs that represents
  // the heterogeneous tuples used in the given cairo contract
  const structDefs: Map<string, StructDefinition> = addAllStructs(sourceUint, ast, abi);

  // solidity interface contract
  const { contract, funcSignatures } = addForwarderContract(
    abi,
    sourceUint,
    structDefs,
    ast,
    cairoPathRoot.split('/').pop(),
  );

  if (abiPath) fs.unlinkSync(abiPath);

  // replace function names in the generated cairo contract such that it'll match the function
  // names in the generated solidity contract after transpilation of the latter
  funcSignatures.forEach((value, key) => {
    cairoContract = cairoContract.replace(`_ITR_${key}`, `${key}_${value}`);
  });

  fs.writeFileSync(cairoContractPath, cairoContract);

  const compileForwarder = compileCairo(cairoContractPath, path.resolve(__dirname, '..'), {
    debugInfo: false,
  });

  contract.documentation = `WARP-GENERATED\nclass_hash: ${
    compileForwarder.resultPath ? runStarkNetClassHash(compileForwarder.resultPath) : '0x0'
  }`;

  if (compileForwarder.success) {
    if (compileForwarder.resultPath) fs.unlinkSync(compileForwarder.resultPath);
    if (compileForwarder.abiPath) fs.unlinkSync(compileForwarder.abiPath);
  }

  const result: string = removeExcessNewlines(writer.write(ast.roots[0] as SourceUnit), 2);
  fs.writeFileSync(solPath, result);
}

function addPragmaDirective(version: string, sourceUint: SourceUnit, ast: AST): void {
  /**
   * Add a pragma directive to the given source unit
   */
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

/**
 * Add a contract to the given source unit that will be used to interact with the given cairo contract
 * via the generated cairo contract
 * @param abi : abi of the given cairo contract
 * @param sourceUint : source unit to add the contract to
 * @param structDefs : map of the struct definitions that has been added to the source unit
 * @param ast : ast of the given source unit
 * @param fileName : name of the given cairo contract file
 * @returns : map of the function signatures and their corresponding function names
 */
function addForwarderContract(
  abi: AbiType,
  sourceUint: SourceUnit,
  structDefs: Map<string, StructDefinition>,
  ast: AST,
  fileName: string | undefined,
): { contract: ContractDefinition; funcSignatures: Map<string, string> } {
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

  // add functions to the contract that will be used to interact with the given cairo contract
  return {
    contract: contract,
    funcSignatures: addInteractiveFunctions(
      contract,
      structDefs,
      ast,
      abi,
      typeToStructMapping(getStructsFromABI(abi)),
    ),
  };
}

/**
  Add the solidity structs that are equivalent to the cairo structs after
  transformation of all felt types to uint256 and also structs corresponding to
  heterogeneous tuples (e.g `param: (felt, (Uint256, felt))`) that are used
  in the given cairo contract 
 * @param sourceUint : source unit to add the structs to
 * @param ast : ast of the given source unit
 * @param abi : abi of the given cairo contract
 * @returns : map of the struct names and their corresponding struct definitions
 */
function addAllStructs(
  sourceUint: SourceUnit,
  ast: AST,
  abi: AbiType,
): Map<string, StructDefinition> {
  const transformedStructs = new Map<string, StructDefinition>();
  // getAllStructsFromABI ensures that the structs are added in the correct order
  // and fetch all structs that are transformed (uint256 version), structs that are
  // added as a result of transformation of heterogeneous tuples
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

/**
 * Returns TypeName Node for the given cairo type
 * @param cairoType : cairo type string
 * @param structDefs : solidity struct definitions that have been added to the source unit
 * @param ast : ast of the source unit
 * @returns : solidity TypeName object that corresponds to the given cairo type
 */
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
    const subTypes: string[] = tupleParser(cairoType);
    // assert all subtypes are the same string
    // Since there is no way to represent a tuple in solidity,
    // we will represent as an array for the same types and a struct for different types
    // since heterogeneous tuples are represented as structs it should not contain parentheses
    // after type transformation transformation ( see transformType function in ../utils/util.ts)
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

/**
 * Returns variable declaration nodes for the interactive functions
 * @param params : array of cairo parameters from abi function items
 * @param scope : scope for the variable declarations
 * @param structDefs : map of the struct definitions that has been added to the source unit
 * @param ast : ast of the source unit
 * @param typeToStructMap : map of the cairo types and their corresponding struct abi items
 * @returns : array of variable declarations that can be used in function definition
 */
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

/**
 * Add function definition to the given contract and returns function signatures
 * @param contract : solidity contract definition object
 * @param structDefs : map of the struct definitions that has been added to the source unit
 * @param ast : ast of the source unit
 * @param abi : abi of the cairo contract
 * @param typeToStructMap : map of the cairo types and their corresponding struct abi items
 * @returns : Map of the function name and the function signature
 */
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
    const funcDef = (isDelegate: boolean) => {
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
      return new FunctionDefinition(
        id,
        '',
        contract.id,
        FunctionKind.Function,
        (isDelegate ? '_delegate_' : '') + element.name,
        false,
        FunctionVisibility.External,
        FunctionStateMutability.NonPayable,
        false, // is constructor
        new ParameterList(ast.reserveId(), '', inputParameters), // parameters
        new ParameterList(ast.reserveId(), '', returnParameters), // return parameters
        [], // modifiers
        undefined, // override specifier
        undefined, // body
      );
    };

    functions.push(funcDef(false), funcDef(true));
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

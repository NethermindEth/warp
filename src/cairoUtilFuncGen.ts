import assert = require('assert');
import {
  AddressType,
  ArrayType,
  ArrayTypeName,
  BoolType,
  BuiltinStructType,
  BuiltinType,
  BytesType,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionKind,
  FunctionStateMutability,
  FunctionType,
  FunctionVisibility,
  getNodeType,
  Identifier,
  IndexAccess,
  IntType,
  Literal,
  Mapping,
  MappingType,
  Mutability,
  ParameterList,
  PointerType,
  StateVariableVisibility,
  StringType,
  TypeName,
  typeNameToTypeNode,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from './ast/ast';
import { CairoFunctionDefinition } from './ast/cairoNodes';
import { printTypeNode } from './utils/astPrinter';
import {
  CairoFelt,
  CairoStruct,
  CairoTuple,
  CairoType,
  CairoUint256,
} from './utils/cairoTypeSystem';
import { cloneTypeName } from './utils/cloning';
import { NotSupportedYetError, TranspileFailedError } from './utils/errors';
import { Implicits } from './utils/implicits';
import {
  getFunctionTypeString,
  getReturnTypeString,
  mapRange,
  typeNameFromTypeNode,
} from './utils/utils';

type CairoFunction = {
  name: string;
  code: string;
};

export class cairoUtilFuncGen {
  private ast: AST;
  // cairoType -> code
  private generatedStorageReads: Map<string, CairoFunction> = new Map();
  private generatedStorageWrites: Map<string, CairoFunction> = new Map();
  // keyType -> valueType -> code
  private generatedMappingReads: Map<string, Map<string, CairoFunction>> = new Map();
  // element cairoType -> code
  private generatedNews: Map<string, CairoFunction> = new Map();
  // readType -> code
  private generatedMemoryReads: Map<string, CairoFunction> = new Map();
  // writeType -> code
  private generatedMemoryWrites: Map<string, CairoFunction> = new Map();

  // keytype -> valuetype -> associated storage var
  private mappings: Map<string, Map<string, CairoFunction>> = new Map();
  private mappingId = 0;

  constructor(ast: AST) {
    this.ast = ast;
  }

  // Concatenate all the generated cairo code into a single string
  write(): string {
    return [
      ['@storage_var', 'func WARP_STORAGE(index: felt) -> (val: felt):', 'end'].join('\n'),
      ...[...this.mappings.values()]
        .flatMap((map) => [...map.values()])
        .map((cairoMapping) => cairoMapping.code),
      ...[...this.generatedNews.values()].map((func) => func.code),
      ...[...this.generatedMemoryReads.values()].map((func) => func.code),
      ...[...this.generatedMemoryWrites.values()].map((func) => func.code),
      ...[...this.generatedStorageReads.values()].map((func) => func.code),
      ...[...this.generatedStorageWrites.values()].map((func) => func.code),
      ...[...this.generatedMappingReads.values()]
        .flatMap((map) => [...map.values()])
        .map((func) => func.code),
    ].join('\n\n');
  }

  //----------------public solidity function call generators-------------------

  newDynArray(len: Expression, arrayType: ArrayTypeName): FunctionCall {
    const elementCairoType = cairoType(typeNameToTypeNode(arrayType.vBaseType));
    const name =
      this.generatedNews.get(elementCairoType.toString())?.name ??
      this.createMemoryNew(elementCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [['len', this.uint256TypeName()]],
      [['arr', arrayType]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [len]);
  }

  memoryRead(indexAccess: IndexAccess): FunctionCall {
    const index = indexAccess.vIndexExpression;
    assert(index !== undefined);
    const cairoTypeToRead = cairoType(getNodeType(indexAccess, this.ast.compilerVersion));
    const name =
      this.generatedMemoryReads.get(cairoTypeToRead.toString())?.name ??
      this.createMemoryRead(cairoTypeToRead);
    const functionStub = createCairoFunctionStub(
      name,
      [
        [
          'name',
          typeNameFromTypeNode(
            getNodeType(indexAccess.vBaseExpression, this.ast.compilerVersion),
            this.ast,
          ),
        ],
        ['index', this.uint256TypeName()],
      ],
      [['val', typeNameFromTypeNode(getNodeType(indexAccess, this.ast.compilerVersion), this.ast)]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [indexAccess.vBaseExpression, index]);
  }

  memoryWrite(indexAccess: IndexAccess, writeValue: Expression): FunctionCall {
    const index = indexAccess.vIndexExpression;
    assert(index !== undefined);
    const assignedType = getNodeType(indexAccess, this.ast.compilerVersion);
    const assignedTypeName = typeNameFromTypeNode(assignedType, this.ast);
    const assignedCairoType = cairoType(assignedType);
    const name =
      this.generatedMemoryWrites.get(assignedCairoType.toString())?.name ??
      this.createMemoryWrite(assignedCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [
        [
          'name',
          typeNameFromTypeNode(
            getNodeType(indexAccess.vBaseExpression, this.ast.compilerVersion),
            this.ast,
          ),
        ],
        ['index', this.uint256TypeName()],
        ['value', assignedTypeName],
      ],
      [['assignedValue', cloneTypeName(assignedTypeName, this.ast)]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [indexAccess.vBaseExpression, index, writeValue]);
  }

  storageRead(storageLocation: Literal, type: TypeName): FunctionCall {
    const valueType = typeNameToTypeNode(type);
    const resultCairoType = cairoType(valueType);
    const name =
      this.generatedStorageReads.get(resultCairoType.toString())?.name ??
      this.createStorageRead(resultCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', storageLocation]],
      [['val', type]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [storageLocation]);
  }

  storageWrite(
    declaration: VariableDeclaration,
    storageLocation: Literal,
    writeValue: Expression,
  ): FunctionCall {
    assert(
      declaration.vType !== undefined,
      'Declaration should have defined vType for solidity >=0.5',
    );
    const typeToWrite = typeNameToTypeNode(declaration.vType);
    const name =
      this.generatedStorageWrites.get(cairoType(typeToWrite).toString())?.name ??
      this.createStorageWrite(typeToWrite);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', storageLocation],
        ['value', cloneTypeName(declaration.vType, this.ast)],
      ],
      [['res', cloneTypeName(declaration.vType, this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [storageLocation, writeValue]);
  }

  readMapping(mapping: Expression, key: Expression, mappingTypeName: Mapping): FunctionCall {
    const keyType = cairoType(typeNameToTypeNode(mappingTypeName.vKeyType)).toString();
    const valueType = cairoType(typeNameToTypeNode(mappingTypeName.vValueType)).toString();
    const name = `${
      this.mappings.get(keyType)?.get(valueType)?.name ?? this.createMapping(keyType, valueType)
    }.read`;
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['name', mapping],
        ['key', mappingTypeName.vKeyType],
      ],
      [['val', mappingTypeName.vValueType]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
    );
    return this.createCallToStub(functionStub, [mapping, key]);
  }

  //-------------------private cairo implementation generators-----------------

  private createCallToStub(stub: CairoFunctionDefinition, args: Expression[]): FunctionCall {
    return new FunctionCall(
      this.ast.reserveId(),
      '',
      'FunctionCall',
      getReturnTypeString(stub),
      FunctionCallKind.FunctionCall,
      new Identifier(
        this.ast.reserveId(),
        '',
        'Identifier',
        getFunctionTypeString(stub),
        stub.name,
        stub.id,
      ),
      args,
    );
  }

  private createMemoryNew(elementType: CairoType): string {
    const name = `WM_NEW${this.generatedNews.size}`;
    this.generatedNews.set(elementType.toString(), {
      name,
      code: [
        `func ${name}{range_check_ptr, warp_memory: MemCell*}(len: Uint256) -> (name: felt):`,
        `    let (feltLength: Uint256, _) = uint256_mul(len, Uint256(${elementType.width}, 0))`,
        `    return warp_create_array(feltLength)`,
        'end',
      ].join('\n'),
    });
    this.ast.addImports({ ['starkware.cairo.common.uint256']: new Set(['uint256_mul']) });
    this.ast.addImports({ ['warplib.memory']: new Set(['MemCell', 'warp_create_array']) });
    return name;
  }

  private createMemoryRead(typeToRead: CairoType): string {
    const funcName = `WM_READ${this.generatedStorageReads.size}`;
    const commands: ReadSerialisationCommand[] = serialiseReads(typeToRead);
    const resultCairoType = typeToRead.toString();
    const queue: string[] = [];
    let readCounter = 0;
    let packCounter = 0;
    this.generatedStorageReads.set(resultCairoType, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: MemCell*}(name: felt, offset: Uint256) ->(val: ${resultCairoType}):`,
        `    alloc_locals`,
        ...commands.map((command) => {
          if (command.tag === 'READ') {
            queue.push(`read${readCounter}`);
            const readCode = [
              `    let (idx: Uint256) = warp_idx(offset, 1, ${readCounter})`,
              `    let (local read${readCounter}: felt) = warp_memory_read(warp_memory, name, idx)`,
            ].join('\n');
            ++readCounter;
            return readCode;
          } else {
            const ops: string[] = [];
            mapRange(command.count, () => {
              assert(queue.length > 0, `Invalid read commands. Attempt to pack from empty queue`);
              ops.push(queue[0]);
              queue.shift();
            });
            queue.push(`pack${packCounter}`);
            const packCode = `    local pack${packCounter}: ${command.type} = ${
              command.name
            }(${ops.join(', ')})`;
            ++packCounter;
            return packCode;
          }
        }),
        `    return (${packCounter === 0 ? `read${readCounter - 1}` : `pack${packCounter - 1}`})`,
        'end',
      ].join('\n'),
    });
    this.ast.addImports({
      ['warplib.memory']: new Set(['MemCell', 'warp_idx', 'warp_memory_read']),
    });
    return funcName;
  }

  private createMemoryWrite(assignedCairoType: CairoType): string {
    const name = `WM_WRITE${this.generatedMemoryWrites.size}`;
    const valueTypeString = assignedCairoType.toString();
    const width = assignedCairoType.width;
    this.generatedMemoryWrites.set(valueTypeString, {
      name,
      code: [
        `func ${name}{range_check_ptr, warp_memory: MemCell*}(name: felt, index: Uint256, value: ${valueTypeString}) -> (val: ${valueTypeString}):`,
        ...assignedCairoType
          .serialiseMembers('value')
          .map((value, offset) =>
            [
              `    let (cell: Uint256) = warp_idx(index, ${width}, ${offset})`,
              `    warp_memory_write(name, cell, ${value})`,
            ].join('\n'),
          ),
        `    return (value)`,
        'end',
      ].join('\n'),
    });
    this.ast.addImports({
      ['warplib.memory']: new Set(['MemCell', 'warp_idx', 'warp_memory_write']),
    });
    return name;
  }

  private createStorageRead(typeToRead: CairoType): string {
    const funcName = `WS_READ${this.generatedStorageReads.size}`;
    const commands: ReadSerialisationCommand[] = serialiseReads(typeToRead);
    const resultCairoType = typeToRead.toString();
    const queue: string[] = [];
    let readCounter = 0;
    let packCounter = 0;
    this.generatedStorageReads.set(resultCairoType, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: ${resultCairoType}):`,
        ...commands.map((command) => {
          if (command.tag === 'READ') {
            queue.push(`read${readCounter}`);
            const readCode = `    let (read${readCounter}) = WARP_STORAGE.read(loc + ${readCounter})`;
            ++readCounter;
            return readCode;
          } else {
            const ops: string[] = [];
            mapRange(command.count, () => {
              assert(queue.length > 0, `Invalid read commands. Attempt to pack from empty queue`);
              ops.push(queue[0]);
              queue.shift();
            });
            queue.push(`pack${packCounter}`);
            const packCode = `    let pack${packCounter} = ${command.name}(${ops.join(', ')})`;
            ++packCounter;
            return packCode;
          }
        }),
        `    return (${packCounter === 0 ? `read${readCounter - 1}` : `pack${packCounter - 1}`})`,
        'end',
      ].join('\n'),
    });
    return funcName;
  }

  private createStorageWrite(typeToWrite: TypeNode): string {
    const cairoTypeToWrite = cairoType(typeToWrite);
    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WS_WRITE${this.generatedStorageWrites.size}`;
    this.generatedStorageWrites.set(cairoTypeString, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: ${cairoTypeString}) -> (res: ${cairoTypeString}):`,
        ...cairoTypeToWrite
          .serialiseMembers('value')
          .map((name, index) => `    WARP_STORAGE.write(loc + ${index}, ${name})`),
        '    return (value)',
        'end',
      ].join('\n'),
    });
    return funcName;
  }

  private createMapping(key: string, value: string): string {
    let keyMappings = this.mappings.get(key);
    if (keyMappings === undefined) {
      keyMappings = new Map();
      this.mappings.set(key, keyMappings);
    }

    const name = `WARP_MAPPING${this.mappingId++}`;
    keyMappings.set(value, {
      name,
      code: [
        '@storage_var',
        `func ${name}(name: felt, key: ${key}) -> (val: ${value}):`,
        'end',
      ].join('\n'),
    });
    return name;
  }

  private uint256TypeName(): ElementaryTypeName {
    const typeName = new ElementaryTypeName(
      this.ast.reserveId(),
      '',
      'ElementaryTypeName',
      'uint256',
      'uint256',
    );
    this.ast.setContextRecursive(typeName);
    return typeName;
  }
}

//----------------------------helper functions---------------------------------

type ReadSerialisationCommand =
  | {
      tag: 'READ';
      count: number;
    }
  | {
      tag: 'PACK';
      count: number;
      name: string;
      type: string;
    };

function serialiseReads(type: CairoType): ReadSerialisationCommand[] {
  if (type instanceof CairoFelt) return [{ tag: 'READ', count: 1 }];
  if (type instanceof CairoStruct) {
    return [
      ...[...type.members.values()].flatMap((type) => serialiseReads(type)),
      { tag: 'PACK', count: type.members.size, name: type.name, type: type.name },
    ];
  }
  if (type instanceof CairoTuple) {
    return [
      ...[...type.members.values()].flatMap((type) => serialiseReads(type)),
      { tag: 'PACK', count: type.members.length, name: '', type: type.toString() },
    ];
  }
  throw new TranspileFailedError('Solidity should not evluate to cairo pointers');
}

// Sync this with the one in typewriter.ts
function cairoType(tp: TypeNode): CairoType {
  if (tp instanceof IntType) {
    return tp.nBits > 251 ? CairoUint256 : new CairoFelt();
  } else if (tp instanceof ArrayType) {
    return new CairoFelt();
  } else if (tp instanceof BoolType) {
    return new CairoFelt();
  } else if (tp instanceof BytesType) {
    throw new NotSupportedYetError('Serialising BytesType not supported yet');
  } else if (tp instanceof StringType) {
    return new CairoFelt();
  } else if (tp instanceof AddressType) {
    return new CairoFelt();
  } else if (tp instanceof BuiltinType) {
    throw new NotSupportedYetError('Serialising BuiltinType not supported yet');
  } else if (tp instanceof BuiltinStructType) {
    throw new NotSupportedYetError('Serialising BuiltinStructType not supported yet');
  } else if (tp instanceof MappingType) {
    return new CairoFelt();
  } else if (tp instanceof UserDefinedType) {
    throw new NotSupportedYetError('Serialising UserDefinedType not supported yet');
  } else if (tp instanceof FunctionType) {
    throw new NotSupportedYetError('Serialising FunctionType not supported yet');
  } else if (tp instanceof PointerType) {
    console.log('WARNING: serialising pointer type. Check this manually');
    return new CairoFelt();
  } else {
    throw new Error(`Don't know how to convert type ${printTypeNode(tp)}`);
  }
}

function createCairoFunctionStub(
  name: string,
  inputs: [string, TypeName][],
  returns: [string, TypeName][],
  implicits: Implicits[],
  ast: AST,
): CairoFunctionDefinition {
  const createParameters = (inputs: [string, TypeName][]) =>
    inputs.map(
      ([name, type]) =>
        new VariableDeclaration(
          ast.reserveId(),
          '',
          'VariableDeclaration',
          false,
          false,
          name,
          -1,
          false,
          DataLocation.Memory,
          StateVariableVisibility.Private,
          Mutability.Mutable,
          type.typeString,
          undefined,
          type,
        ),
    );

  const funcDef = new CairoFunctionDefinition(
    ast.reserveId(),
    '',
    'CairoFunctionDefinition',
    -1,
    FunctionKind.Function,
    name,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    new ParameterList(ast.reserveId(), '', 'ParameterList', createParameters(inputs)),
    new ParameterList(ast.reserveId(), '', 'ParameterList', createParameters(returns)),
    [],
    new Set(implicits),
  );

  ast.setContextRecursive(funcDef);

  return funcDef;
}

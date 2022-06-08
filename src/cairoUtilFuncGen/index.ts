import { AST } from '../ast/ast';
import { mergeImports } from '../utils/utils';
import { CairoUtilFuncGenBase } from './base';
import { InputCheckGen } from './inputArgCheck/inputCheck';
import { MemoryArrayLiteralGen } from './memory/arrayLiteral';
import { MemoryDynArrayLengthGen } from './memory/memoryDynArrayLength';
import { MemoryMemberAccessGen } from './memory/memoryMemberAccess';
import { MemoryReadGen } from './memory/memoryRead';
import { MemoryStructGen } from './memory/memoryStruct';
import { MemoryWriteGen } from './memory/memoryWrite';
import { MemoryStaticArrayIndexAccessGen } from './memory/staticIndexAccess';
import { DynArrayGen } from './storage/dynArray';
import { DynArrayIndexAccessGen } from './storage/dynArrayIndexAccess';
import { DynArrayLengthGen } from './storage/dynArrayLength';
import { DynArrayPopGen } from './storage/dynArrayPop';
import { DynArrayPushWithArgGen } from './storage/dynArrayPushWithArg';
import { DynArrayPushWithoutArgGen } from './storage/dynArrayPushWithoutArg';
import { CallDataToMemoryGen } from './calldata/calldataToMemory';
import { ExternalDynArrayStructConstructor } from './calldata/externalDynArray/externalDynArrayStructConstructor';
import { StaticToDynArray } from './calldata/staticToDynamic';
import { MappingIndexAccessGen } from './storage/mappingIndexAccess';
import { StorageStaticArrayIndexAccessGen } from './storage/staticArrayIndexAccess';
import { StorageDeleteGen } from './storage/storageDelete';
import { StorageMemberAccessGen } from './storage/storageMemberAccess';
import { StorageReadGen } from './storage/storageRead';
import { StorageToMemoryGen } from './storage/storageToMemory';
import { StorageWriteGen } from './storage/storageWrite';
import { MemoryToCallDataGen } from './memory/memoryToCalldata';
import { MemoryToStorageGen } from './memory/memoryToStorage';
import { CalldataToStorageGen } from './calldata/calldataToStorage';
import { StorageToStorageGen } from './storage/copyToStorage';
import { StorageToCalldataGen } from './storage/storageToCalldata';
import { SourceUnit } from 'solc-typed-ast';
import { MemoryImplicitConversionGen } from './memory/implicitCoversion';

export class CairoUtilFuncGen {
  calldata: {
    toMemory: CallDataToMemoryGen;
    toStorage: CalldataToStorageGen;
    convert: StaticToDynArray;
  };
  memory: {
    arrayLiteral: MemoryArrayLiteralGen;
    convert: MemoryImplicitConversionGen;
    dynArrayLength: MemoryDynArrayLengthGen;
    memberAccess: MemoryMemberAccessGen;
    read: MemoryReadGen;
    staticArrayIndexAccess: MemoryStaticArrayIndexAccessGen;
    struct: MemoryStructGen;
    toCallData: MemoryToCallDataGen;
    toStorage: MemoryToStorageGen;
    write: MemoryWriteGen;
  };
  storage: {
    delete: StorageDeleteGen;
    dynArrayIndexAccess: DynArrayIndexAccessGen;
    dynArrayLength: DynArrayLengthGen;
    dynArrayPop: DynArrayPopGen;
    dynArrayPush: {
      withArg: DynArrayPushWithArgGen;
      withoutArg: DynArrayPushWithoutArgGen;
    };
    mappingIndexAccess: MappingIndexAccessGen;
    memberAccess: StorageMemberAccessGen;
    read: StorageReadGen;
    staticArrayIndexAccess: StorageStaticArrayIndexAccessGen;
    toCallData: StorageToCalldataGen;
    toMemory: StorageToMemoryGen;
    toStorage: StorageToStorageGen;
    write: StorageWriteGen;
  };
  externalFunctions: {
    inputCheck: InputCheckGen;
    inputs: {
      darrayStructConstructor: ExternalDynArrayStructConstructor;
    };
  };

  private implementation: {
    dynArray: DynArrayGen;
  };

  constructor(ast: AST, sourceUnit: SourceUnit) {
    this.implementation = {
      dynArray: new DynArrayGen(ast, sourceUnit),
    };

    const memoryToStorage = new MemoryToStorageGen(this.implementation.dynArray, ast, sourceUnit);
    const storageWrite = new StorageWriteGen(ast, sourceUnit);
    const externalDynArrayStructConstructor = new ExternalDynArrayStructConstructor(
      ast,
      sourceUnit,
    );

    const memoryRead = new MemoryReadGen(ast, sourceUnit);
    const memoryWrite = new MemoryWriteGen(ast, sourceUnit);
    this.memory = {
      arrayLiteral: new MemoryArrayLiteralGen(ast, sourceUnit),
      convert: new MemoryImplicitConversionGen(memoryWrite, memoryRead, ast, sourceUnit),
      dynArrayLength: new MemoryDynArrayLengthGen(ast, sourceUnit),
      memberAccess: new MemoryMemberAccessGen(ast, sourceUnit),
      read: memoryRead,
      staticArrayIndexAccess: new MemoryStaticArrayIndexAccessGen(ast, sourceUnit),
      struct: new MemoryStructGen(ast, sourceUnit),
      toCallData: new MemoryToCallDataGen(externalDynArrayStructConstructor, ast, sourceUnit),
      toStorage: memoryToStorage,
      write: memoryWrite,
    };
    const storageReadGen = new StorageReadGen(ast, sourceUnit);
    const storageDelete = new StorageDeleteGen(
      this.implementation.dynArray,
      storageReadGen,
      ast,
      sourceUnit,
    );
    this.storage = {
      delete: storageDelete,
      dynArrayIndexAccess: new DynArrayIndexAccessGen(
        this.implementation.dynArray,
        ast,
        sourceUnit,
      ),
      dynArrayLength: new DynArrayLengthGen(this.implementation.dynArray, ast, sourceUnit),
      dynArrayPop: new DynArrayPopGen(this.implementation.dynArray, storageDelete, ast, sourceUnit),
      dynArrayPush: {
        withArg: new DynArrayPushWithArgGen(
          this.implementation.dynArray,
          storageWrite,
          memoryToStorage,
          ast,
          sourceUnit,
        ),
        withoutArg: new DynArrayPushWithoutArgGen(this.implementation.dynArray, ast, sourceUnit),
      },
      mappingIndexAccess: new MappingIndexAccessGen(ast, sourceUnit),
      memberAccess: new StorageMemberAccessGen(ast, sourceUnit),
      read: storageReadGen,
      staticArrayIndexAccess: new StorageStaticArrayIndexAccessGen(ast, sourceUnit),
      toCallData: new StorageToCalldataGen(
        this.implementation.dynArray,
        storageReadGen,
        externalDynArrayStructConstructor,
        ast,
        sourceUnit,
      ),
      toMemory: new StorageToMemoryGen(this.implementation.dynArray, ast, sourceUnit),
      toStorage: new StorageToStorageGen(this.implementation.dynArray, ast, sourceUnit),
      write: storageWrite,
    };
    this.externalFunctions = {
      inputCheck: new InputCheckGen(ast, sourceUnit),
      inputs: {
        darrayStructConstructor: externalDynArrayStructConstructor,
      },
    };
    this.calldata = {
      toMemory: new CallDataToMemoryGen(ast, sourceUnit),
      toStorage: new CalldataToStorageGen(
        this.implementation.dynArray,
        storageWrite,
        ast,
        sourceUnit,
      ),
      convert: new StaticToDynArray(
        storageWrite,
        this.implementation.dynArray,
        this.storage.dynArrayIndexAccess,
        ast,
        sourceUnit,
      ),
    };
  }

  getImports(): Map<string, Set<string>> {
    return mergeImports(...this.getAllChildren().map((c) => c.getImports()));
  }
  getGeneratedCode(): string {
    return this.getAllChildren()
      .map((c) => c.getGeneratedCode())
      .sort((a, b) => {
        // This sort is needed to make sure the structs generated from CairoUtilGen are before the generated functions that
        // reference them. This sort is also order preserving in that it will only make sure the structs come before
        // any functions and not sort the struct/functions within their respective groups.
        if (a.slice(0, 1) < b.slice(0, 1)) {
          return 1;
        } else if (a.slice(0, 1) > b.slice(0, 1)) {
          return -1;
        }
        return 0;
      })
      .join('\n\n');
  }
  private getAllChildren(): CairoUtilFuncGenBase[] {
    return getAllGenerators(this);
  }
}

function getAllGenerators(container: unknown): CairoUtilFuncGenBase[] {
  if (typeof container !== 'object' || container === null) return [];
  if (container instanceof CairoUtilFuncGenBase) return [container];
  return Object.values(container).flatMap(getAllGenerators);
}

import { AST } from '../ast/ast';
import { mergeImports } from '../utils/utils';
import { CairoUtilFuncGenBase } from './base';
import { EnumBoundCheckGen } from './enumBoundCheck';
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
import { DynArrayLoader } from './calldata/calldataToMemory';
import { ExternalDynArrayStructConstructor } from './memory/externalDynArray/externalDynArrayStructConstructor';
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

export class CairoUtilFuncGen {
  calldata: {
    toMemory: DynArrayLoader;
    toStorage: CalldataToStorageGen;
  };
  memory: {
    arrayLiteral: MemoryArrayLiteralGen;
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
    toMemory: StorageToMemoryGen;
    toStorage: StorageToStorageGen;
    write: StorageWriteGen;
  };
  externalFunctions: {
    inputsChecks: { enum: EnumBoundCheckGen };
    inputs: {
      darrayStructConstructor: ExternalDynArrayStructConstructor;
    };
  };

  private implementation: {
    dynArray: DynArrayGen;
  };

  constructor(ast: AST) {
    this.implementation = {
      dynArray: new DynArrayGen(ast),
    };

    const memoryToStorage = new MemoryToStorageGen(this.implementation.dynArray, ast);
    const storageWrite = new StorageWriteGen(ast);

    this.memory = {
      arrayLiteral: new MemoryArrayLiteralGen(ast),
      dynArrayLength: new MemoryDynArrayLengthGen(ast),
      memberAccess: new MemoryMemberAccessGen(ast),
      read: new MemoryReadGen(ast),
      staticArrayIndexAccess: new MemoryStaticArrayIndexAccessGen(ast),
      struct: new MemoryStructGen(ast),
      toCallData: new MemoryToCallDataGen(ast),
      toStorage: memoryToStorage,
      write: new MemoryWriteGen(ast),
    };
    const storageReadGen = new StorageReadGen(ast);
    const storageDelete = new StorageDeleteGen(this.implementation.dynArray, storageReadGen, ast);
    this.storage = {
      delete: storageDelete,
      dynArrayIndexAccess: new DynArrayIndexAccessGen(this.implementation.dynArray, ast),
      dynArrayLength: new DynArrayLengthGen(this.implementation.dynArray, ast),
      dynArrayPop: new DynArrayPopGen(this.implementation.dynArray, storageDelete, ast),
      dynArrayPush: {
        withArg: new DynArrayPushWithArgGen(
          this.implementation.dynArray,
          storageWrite,
          memoryToStorage,
          ast,
        ),
        withoutArg: new DynArrayPushWithoutArgGen(this.implementation.dynArray, ast),
      },
      mappingIndexAccess: new MappingIndexAccessGen(ast),
      memberAccess: new StorageMemberAccessGen(ast),
      read: storageReadGen,
      staticArrayIndexAccess: new StorageStaticArrayIndexAccessGen(ast),
      toMemory: new StorageToMemoryGen(this.implementation.dynArray, ast),
      toStorage: new StorageToStorageGen(this.implementation.dynArray, ast),
      write: storageWrite,
    };
    this.externalFunctions = {
      inputsChecks: { enum: new EnumBoundCheckGen(ast) },
      inputs: {
        darrayStructConstructor: new ExternalDynArrayStructConstructor(ast),
      },
    };
    this.calldata = {
      toMemory: new DynArrayLoader(ast),
      toStorage: new CalldataToStorageGen(this.implementation.dynArray, storageWrite, ast),
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

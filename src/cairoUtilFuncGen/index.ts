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
import { MemoryToCallData } from './memory/callData';
import { DynArrayGen } from './storage/dynArray';
import { DynArrayIndexAccessGen } from './storage/dynArrayIndexAccess';
import { DynArrayLengthGen } from './storage/dynArrayLength';
import { DynArrayPopGen } from './storage/dynArrayPop';
import { DynArrayPushWithArgGen } from './storage/dynArrayPushWithArg';
import { DynArrayPushWithoutArgGen } from './storage/dynArrayPushWithoutArg';
import { ExternalDynArrayAllocator } from './memory/externalDynArray/externalDynArrayAlloc';
import { ExternalDynArrayStructConstructor } from './memory/externalDynArray/externalDynArrayStructConstructor';
import { ExternalDynArrayWriter } from './memory/externalDynArray/externalDynArrayWriter';
import { MappingIndexAccessGen } from './storage/mappingIndexAccess';
import { StorageStaticArrayIndexAccessGen } from './storage/staticArrayIndexAccess';
import { StorageDeleteGen } from './storage/storageDelete';
import { StorageMemberAccessGen } from './storage/storageMemberAccess';
import { StorageReadGen } from './storage/storageRead';
import { StorageToMemoryGen } from './storage/storageToMemory';
import { StorageWriteGen } from './storage/storageWrite';
import { MemoryToCallDataGen } from './memory/memoryToCalldata';
import { MemoryToStorageGen } from './memory/memoryToStorage';

export class CairoUtilFuncGen {
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
    callDataRead: MemoryToCallData;
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
    write: StorageWriteGen;
  };
  externalFunctions: {
    inputsChecks: { enum: EnumBoundCheckGen };
    inputs: {
      darrayStructConstructor: ExternalDynArrayStructConstructor;
      darrayAllocator: ExternalDynArrayAllocator;
      darrayWriter: ExternalDynArrayWriter;
    };
  };

  private implementation: {
    dynArray: DynArrayGen;
  };

  constructor(ast: AST) {
    this.implementation = {
      dynArray: new DynArrayGen(ast),
    };
    this.memory = {
      arrayLiteral: new MemoryArrayLiteralGen(ast),
      dynArrayLength: new MemoryDynArrayLengthGen(ast),
      memberAccess: new MemoryMemberAccessGen(ast),
      read: new MemoryReadGen(ast),
      staticArrayIndexAccess: new MemoryStaticArrayIndexAccessGen(ast),
      struct: new MemoryStructGen(ast),
      toCallData: new MemoryToCallDataGen(ast),
      toStorage: new MemoryToStorageGen(this.implementation.dynArray, ast),
      write: new MemoryWriteGen(ast),
      callDataRead: new MemoryToCallData(ast),
    };
    const storageReadGen = new StorageReadGen(ast);
    this.storage = {
      delete: new StorageDeleteGen(ast),
      dynArrayIndexAccess: new DynArrayIndexAccessGen(this.implementation.dynArray, ast),
      dynArrayLength: new DynArrayLengthGen(this.implementation.dynArray, ast),
      dynArrayPop: new DynArrayPopGen(this.implementation.dynArray, ast),
      dynArrayPush: {
        withArg: new DynArrayPushWithArgGen(this.implementation.dynArray, ast),
        withoutArg: new DynArrayPushWithoutArgGen(this.implementation.dynArray, ast),
      },
      mappingIndexAccess: new MappingIndexAccessGen(ast),
      memberAccess: new StorageMemberAccessGen(ast),
      read: storageReadGen,
      staticArrayIndexAccess: new StorageStaticArrayIndexAccessGen(ast),
      toMemory: new StorageToMemoryGen(this.implementation.dynArray, ast),
      write: new StorageWriteGen(ast),
    };
    this.externalFunctions = {
      inputsChecks: { enum: new EnumBoundCheckGen(ast) },
      inputs: {
        darrayStructConstructor: new ExternalDynArrayStructConstructor(ast),
        darrayAllocator: new ExternalDynArrayAllocator(ast),
        darrayWriter: new ExternalDynArrayWriter(ast),
      },
    };
  }

  getImports(): Map<string, Set<string>> {
    return mergeImports(...this.getAllChildren().map((c) => c.getImports()));
  }
  getGeneratedCode(): string {
    return this.getAllChildren()
      .map((c) => c.getGeneratedCode())
      .sort((a, b) => {
        // This sort is needed to make sure the struct in CairoUtilGen are before the functions that
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

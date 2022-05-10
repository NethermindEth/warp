import { AST } from '../ast/ast';
import { mergeImports } from '../utils/utils';
import { CairoUtilFuncGenBase } from './base';
import { EnumBoundCheckGen } from './enumBoundCheck';
import { MemoryArrayLiteralGen } from './memory/arrayLiteral';
import { MemoryDynArrayLengthGen } from './memory/MemoryDynArrayLength';
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
import { MappingIndexAccessGen } from './storage/mappingIndexAccess';
import { StorageStaticArrayIndexAccessGen } from './storage/staticArrayIndexAccess';
import { StorageDeleteGen } from './storage/storageDelete';
import { StorageMemberAccessGen } from './storage/storageMemberAccess';
import { StorageReadGen } from './storage/storageRead';
import { StorageToMemoryGen } from './storage/storageToMemory';
import { StorageWriteGen } from './storage/storageWrite';

export class CairoUtilFuncGen {
  memory: {
    arrayLiteral: MemoryArrayLiteralGen;
    memoryDynArrayLength: MemoryDynArrayLengthGen;
    memberAccess: MemoryMemberAccessGen;
    read: MemoryReadGen;
    staticArrayIndexAccess: MemoryStaticArrayIndexAccessGen;
    struct: MemoryStructGen;
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
    write: StorageWriteGen;
  };
  externalInputChecks: {
    enum: EnumBoundCheckGen;
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
      memoryDynArrayLength: new MemoryDynArrayLengthGen(ast),
      memberAccess: new MemoryMemberAccessGen(ast),
      read: new MemoryReadGen(ast),
      staticArrayIndexAccess: new MemoryStaticArrayIndexAccessGen(ast),
      struct: new MemoryStructGen(ast),
      write: new MemoryWriteGen(ast),
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
      toMemory: new StorageToMemoryGen(storageReadGen, ast),
      write: new StorageWriteGen(ast),
    };
    this.externalInputChecks = {
      enum: new EnumBoundCheckGen(ast),
    };
  }

  getImports(): Map<string, Set<string>> {
    return mergeImports(...this.getAllChildren().map((c) => c.getImports()));
  }
  getGeneratedCode(): string {
    return this.getAllChildren()
      .map((c) => c.getGeneratedCode())
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

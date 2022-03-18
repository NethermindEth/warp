import { AST } from '../ast/ast';
import { mergeImports } from '../utils/utils';
import { CairoUtilFuncGenBase } from './base';
import { DynArrayGen } from './dynArray';
import { DynArrayIndexAccessGen } from './dynArrayIndexAccess';
import { DynArrayPushWithoutArgGen } from './dynArrayPushWithoutArg';
import { DynArrayPushWithArgGen } from './dynArrayPushWithArg';
import { MappingIndexAccessGen } from './mappingIndexAccess';
import { MemberAccessGen } from './memberAccess';
import { MemoryNewGen } from './memoryNew';
import { MemoryReadGen } from './memoryRead';
import { MemoryWriteGen } from './memoryWrite';
import { StorageReadGen } from './storageRead';
import { StorageWriteGen } from './storageWrite';
import { StaticArrayIndexAccessGen } from './staticArrayIndexAccess';
import { DynArrayLengthGen } from './dynArrayLength';
import { DynArrayPopGen } from './dynArrayPop';
import { StorageDeleteGen } from './storageDelete';
import { EnumBoundCheckGen } from './enumBoundCheck';

export class CairoUtilFuncGen {
  memory: {
    new: MemoryNewGen;
    read: MemoryReadGen;
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
    memberAccess: MemberAccessGen;
    read: StorageReadGen;
    staticArrayIndexAccess: StaticArrayIndexAccessGen;
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
      new: new MemoryNewGen(ast),
      read: new MemoryReadGen(ast),
      write: new MemoryWriteGen(ast),
    };
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
      memberAccess: new MemberAccessGen(ast),
      read: new StorageReadGen(ast),
      staticArrayIndexAccess: new StaticArrayIndexAccessGen(ast),
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

import { AST } from '../ast/ast';
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
import { DynArrayPopGen } from './storage/dynArrayPop';
import { DynArrayPushWithArgGen } from './storage/dynArrayPushWithArg';
import { DynArrayPushWithoutArgGen } from './storage/dynArrayPushWithoutArg';
import { CallDataToMemoryGen } from './calldata/calldataToMemory';
import { ExternalDynArrayStructConstructor } from './calldata/externalDynArray/externalDynArrayStructConstructor';
import { ImplicitArrayConversion } from './calldata/implicitArrayConversion';
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
import { MemoryImplicitConversionGen } from './memory/implicitConversion';
import { MemoryArrayConcat } from './memory/arrayConcat';
import { EnumInputCheck } from './enumInputCheck';
import { EncodeAsFelt } from './utils/encodeToFelt';
import { AbiEncode } from './abi/abiEncode';
import { AbiEncodePacked } from './abi/abiEncodePacked';
import { AbiEncodeWithSelector } from './abi/abiEncodeWithSelector';
import { AbiEncodeWithSignature } from './abi/abiEncodeWithSignature';
import { AbiDecode } from './abi/abiDecode';
import { IndexEncode } from './abi/indexEncode';
import { EventFunction } from './event';

export class CairoUtilFuncGen {
  abi: {
    decode: AbiDecode;
    encode: AbiEncode;
    encodePacked: AbiEncodePacked;
    encodeWithSelector: AbiEncodeWithSelector;
    encodeWithSignature: AbiEncodeWithSignature;
  };
  calldata: {
    dynArrayStructConstructor: ExternalDynArrayStructConstructor;
    toMemory: CallDataToMemoryGen;
    toStorage: CalldataToStorageGen;
    convert: ImplicitArrayConversion;
  };
  memory: {
    arrayLiteral: MemoryArrayLiteralGen;
    concat: MemoryArrayConcat;
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
    dynArray: DynArrayGen;
    dynArrayIndexAccess: DynArrayIndexAccessGen;
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
  boundChecks: {
    inputCheck: InputCheckGen;
    enums: EnumInputCheck;
  };
  events: {
    index: IndexEncode;
    event: EventFunction;
  };
  utils: {
    encodeAsFelt: EncodeAsFelt;
  };

  constructor(ast: AST, sourceUnit: SourceUnit) {
    const dynArray = new DynArrayGen(ast, sourceUnit);
    const memoryRead = new MemoryReadGen(ast, sourceUnit);
    const storageReadGen = new StorageReadGen(ast, sourceUnit);
    const storageDelete = new StorageDeleteGen(dynArray, storageReadGen, ast, sourceUnit);
    const memoryToStorage = new MemoryToStorageGen(
      dynArray,
      memoryRead,
      storageDelete,
      ast,
      sourceUnit,
    );
    const storageWrite = new StorageWriteGen(ast, sourceUnit);
    const storageToStorage = new StorageToStorageGen(dynArray, storageDelete, ast, sourceUnit);
    const calldataToStorage = new CalldataToStorageGen(dynArray, storageWrite, ast, sourceUnit);
    const externalDynArrayStructConstructor = new ExternalDynArrayStructConstructor(
      ast,
      sourceUnit,
    );

    const memoryWrite = new MemoryWriteGen(ast, sourceUnit);
    const storageDynArrayIndexAccess = new DynArrayIndexAccessGen(dynArray, ast, sourceUnit);
    const callDataConvert = new ImplicitArrayConversion(
      storageWrite,
      dynArray,
      storageDynArrayIndexAccess,
      ast,
      sourceUnit,
    );
    this.memory = {
      arrayLiteral: new MemoryArrayLiteralGen(ast, sourceUnit),
      concat: new MemoryArrayConcat(ast, sourceUnit),
      convert: new MemoryImplicitConversionGen(memoryWrite, memoryRead, ast, sourceUnit),
      dynArrayLength: new MemoryDynArrayLengthGen(ast, sourceUnit),
      memberAccess: new MemoryMemberAccessGen(ast, sourceUnit),
      read: memoryRead,
      staticArrayIndexAccess: new MemoryStaticArrayIndexAccessGen(ast, sourceUnit),
      struct: new MemoryStructGen(ast, sourceUnit),
      toCallData: new MemoryToCallDataGen(
        externalDynArrayStructConstructor,
        memoryRead,
        ast,
        sourceUnit,
      ),
      toStorage: memoryToStorage,
      write: memoryWrite,
    };
    this.storage = {
      delete: storageDelete,
      dynArray: dynArray,
      dynArrayIndexAccess: storageDynArrayIndexAccess,
      dynArrayPop: new DynArrayPopGen(dynArray, storageDelete, ast, sourceUnit),
      dynArrayPush: {
        withArg: new DynArrayPushWithArgGen(
          dynArray,
          storageWrite,
          memoryToStorage,
          storageToStorage,
          calldataToStorage,
          callDataConvert,
          ast,
          sourceUnit,
        ),
        withoutArg: new DynArrayPushWithoutArgGen(dynArray, ast, sourceUnit),
      },
      mappingIndexAccess: new MappingIndexAccessGen(dynArray, ast, sourceUnit),
      memberAccess: new StorageMemberAccessGen(ast, sourceUnit),
      read: storageReadGen,
      staticArrayIndexAccess: new StorageStaticArrayIndexAccessGen(ast, sourceUnit),
      toCallData: new StorageToCalldataGen(
        dynArray,
        storageReadGen,
        externalDynArrayStructConstructor,
        ast,
        sourceUnit,
      ),
      toMemory: new StorageToMemoryGen(dynArray, ast, sourceUnit),
      toStorage: storageToStorage,
      write: storageWrite,
    };
    this.boundChecks = {
      inputCheck: new InputCheckGen(ast, sourceUnit),
      enums: new EnumInputCheck(ast, sourceUnit),
    };
    this.calldata = {
      dynArrayStructConstructor: externalDynArrayStructConstructor,
      toMemory: new CallDataToMemoryGen(ast, sourceUnit),
      convert: callDataConvert,
      toStorage: calldataToStorage,
    };

    const abiEncode = new AbiEncode(memoryRead, ast, sourceUnit);
    this.abi = {
      decode: new AbiDecode(memoryWrite, ast, sourceUnit),
      encode: abiEncode,
      encodePacked: new AbiEncodePacked(memoryRead, ast, sourceUnit),
      encodeWithSelector: new AbiEncodeWithSelector(abiEncode, ast, sourceUnit),
      encodeWithSignature: new AbiEncodeWithSignature(abiEncode, ast, sourceUnit),
    };
    const indexEncode = new IndexEncode(memoryRead, ast, sourceUnit);
    this.events = {
      index: indexEncode,
      event: new EventFunction(abiEncode, indexEncode, ast, sourceUnit),
    };
    this.utils = {
      encodeAsFelt: new EncodeAsFelt(externalDynArrayStructConstructor, ast, sourceUnit),
    };
  }
}

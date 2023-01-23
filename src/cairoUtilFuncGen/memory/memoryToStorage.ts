import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionStateMutability,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import {
  getElementType,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
  isStruct,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageDeleteGen } from '../storage/storageDelete';

/*
  Generates functions to copy data from warp_memory to WARP_STORAGE
  Specifically this has to deal with structs, static arrays, and dynamic arrays
  These require extra care because the representations are different in storage and memory
  In storage nested structures are stored in place, whereas in memory 'pointers' are used
*/

export class MemoryToStorageGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageDeleteGen: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }
  gen(storageLocation: Expression, memoryLocation: Expression): FunctionCall {
    const type = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(type);

    return createCallToFunction(funcDef, [storageLocation, memoryLocation], this.ast);
  }

  getOrCreateFuncDef(type: TypeNode) {
    const key = `memoryToStorage(${type.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage],
        ['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory],
      ],
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      // ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from memory to storage not implemented yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(type),
      (type) => this.createStaticArrayCopyFunction(type),
      (type) => this.createStructCopyFunction(type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  // This can also be used for static arrays, in which case they are treated
  // like structs with <length> members of the same type
  private createStructCopyFunction(type: TypeNode): GeneratedFunctionInfo {
    const funcName = `wm_to_storage${this.generatedFunctionsDef.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_read'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc : felt, mem_loc: felt) -> (loc: felt){`,
        `    alloc_locals;`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => {
            const elemLoc = `elem_mem_loc_${index}`;
            if (copyType === undefined) {
              return [
                `let (${elemLoc}) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', index)});`,
                `WARP_STORAGE.write(${add('loc', storageOffset)}, ${elemLoc});`,
              ];
            } else if (isDynamicArray(copyType)) {
              funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_id'));
              const calledFuncInfo = this.getOrCreate(copyType);
              funcsCalled.push(...calledFuncInfo.functionsCalled);
              return [
                `let (${elemLoc}) = wm_read_id(${add('mem_loc', index)}, ${uint256(2)});`,
                `let (storage_dyn_array_loc) = readId(${add('loc', storageOffset)});`,
                `${calledFuncInfo.name}(storage_dyn_array_loc, ${elemLoc});`,
              ];
            } else {
              const calledFuncInfo = this.getOrCreate(copyType);
              funcsCalled.push(
                ...calledFuncInfo.functionsCalled,
                this.requireImport('warplib.memory', 'wm_read_id'),
              );
              const copyTypeWidth = CairoType.fromSol(
                copyType,
                this.ast,
                TypeConversionContext.Ref,
              ).width;
              return [
                `let (${elemLoc}) = wm_read_id(${add('mem_loc', index)}, ${uint256(
                  copyTypeWidth,
                )});`,
                `${calledFuncInfo.name}(${add('loc', storageOffset)}, ${elemLoc});`,
              ];
            }
          },
        ),
        `    return (loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    return type.size <= 5
      ? this.createStructCopyFunction(type)
      : this.createLargeStaticArrayCopyFunction(type);
  }

  private createLargeStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    const length = narrowBigIntSafe(
      type.size,
      `Failed to narrow size of ${printTypeNode(type)} in memory->storage copy generation`,
    );
    const funcName = `wm_to_storage${this.generatedFunctionsDef.size}`;

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('warplib.memory', 'wm_alloc'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );
    if (isReferenceType(type.elementT)) {
      funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_id'));
    }
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const elementStorageWidth = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(type.elementT, this.ast).width;

    let copyCode: string;
    if (isDynamicArray(type.elementT)) {
      const calledFuncInfo = this.getOrCreate(type.elementT);
      funcsCalled.push(...calledFuncInfo.functionsCalled);
      copyCode = [
        `    let (storage_id) = readId(storage_loc);`,
        `    let (read) = wm_read_id(mem_loc, ${uint256(2)});`,
        `    ${calledFuncInfo.name}(storage_id, read);`,
      ].join('\n');
    } else if (isStruct(type.elementT)) {
      const calledFuncInfo = this.getOrCreate(type.elementT);
      funcsCalled.push(...calledFuncInfo.functionsCalled);
      copyCode = [
        `    let (read) = wm_read_id{dict_ptr=warp_memory}(mem_loc, ${uint256(
          elementMemoryWidth,
        )});`,
        `    ${calledFuncInfo.name}(storage_loc, read);`,
      ].join('\n');
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)});`,
          `    WARP_STORAGE.write(${add('storage_loc', n)}, copy);`,
        ].join('\n'),
      ).join('\n');
    }

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storage_loc: felt, mem_loc : felt, length: felt) -> (){`,
        `    alloc_locals;`,
        `    if (length == 0){`,
        `        return ();`,
        `    }`,
        `    let index = length - 1;`,
        copyCode,
        `    return ${funcName}_elem(${add('storage_loc', elementStorageWidth)}, ${add(
          'mem_loc',
          elementMemoryWidth,
        )}, index);`,
        `}`,

        `func ${funcName}${implicits}(loc : felt, mem_loc : felt) -> (loc : felt){`,
        `    alloc_locals;`,
        `    ${funcName}_elem(loc, mem_loc, ${length});`,
        `    return (loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createDynamicArrayCopyFunction(
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const funcName = `wm_to_storage${this.generatedFunctionsDef.size}`;

    const emptyInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };

    const elementT = getElementType(type);

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_read'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_dyn_array_length'),
      this.requireImport('warplib.maths.utils', 'narrow_safe'),
    );
    if (isReferenceType(elementT)) {
      funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_id'));
    }

    const elemMappingDef = this.dynArrayGen.getOrCreateFuncDef(elementT);
    funcsCalled.push(elemMappingDef);
    const elemMappingName = elemMappingDef.name;
    const lengthMappingName = elemMappingName + '_LENGTH';

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const elementStorageWidth = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(elementT, this.ast).width;
    let copyCode: string;
    if (isDynamicArray(elementT)) {
      const calledFuncInfo = this.getOrCreate(elementT);
      funcsCalled.push(...calledFuncInfo.functionsCalled);
      copyCode = [
        `    let (storage_id) = readId(storage_loc);`,
        `    let (read) = wm_read_id(mem_loc, ${uint256(2)});`,
        `    ${calledFuncInfo.name}(storage_id, read);`,
      ].join('\n');
    } else if (isReferenceType(elementT)) {
      const calledFuncInfo = this.getOrCreate(elementT);
      funcsCalled.push(...calledFuncInfo.functionsCalled);
      copyCode = [
        `    let (read) = wm_read_id(mem_loc, ${uint256(elementMemoryWidth)});`,
        `    ${calledFuncInfo.name}(storage_loc, read);`,
      ].join('\n');
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)});`,
          `    WARP_STORAGE.write(${add('storage_loc', n)}, copy);`,
        ].join('\n'),
      ).join('\n');
    }

    const deleteRemainingCode = `${this.storageDeleteGen.genAuxFuncName(
      type,
    )}(loc, mem_length, length);`;

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storage_name: felt, mem_loc : felt, length: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == 0 and length.high == 0){`,
        `        return ();`,
        `    }`,
        `    let (index) = uint256_sub(length, Uint256(1,0));`,
        `    let (storage_loc) = ${elemMappingName}.read(storage_name, index);`,
        `    let mem_loc = mem_loc - ${elementMemoryWidth};`,
        `    if (storage_loc == 0){`,
        `        let (storage_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(storage_loc + ${elementStorageWidth});`,
        `        ${elemMappingName}.write(storage_name, index, storage_loc);`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_loc, index);`,
        `    }else{`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_loc, index);`,
        `    }`,
        `}`,

        `func ${funcName}${implicits}(loc : felt, mem_loc : felt) -> (loc : felt){`,
        `    alloc_locals;`,
        `    let (length) = ${lengthMappingName}.read(loc);`,
        `    let (mem_length) = wm_dyn_array_length(mem_loc);`,
        `    ${lengthMappingName}.write(loc, mem_length);`,
        `    let (narrowedLength) = narrow_safe(mem_length);`,
        `    ${funcName}_elem(loc, mem_loc + 2 + ${elementMemoryWidth} * narrowedLength, mem_length);`,
        `    let (lesser) = uint256_lt(mem_length, length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode}`,
        `       return (loc,);`,
        `    }else{`,
        `       return (loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }
}

type CopyInstruction = {
  // The offset into the storage object to write to
  storageOffset: number;
  // If the copy requires a recursive call, this is the type to copy
  copyType?: TypeNode;
};

function generateCopyInstructions(type: TypeNode, ast: AST): CopyInstruction[] {
  let members: TypeNode[];

  if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    members = type.definition.vMembers.map((decl) => safeGetNodeType(decl, ast.inference));
  } else if (type instanceof ArrayType && type.size !== undefined) {
    const narrowedWidth = narrowBigIntSafe(type.size, `Array size ${type.size} not supported`);
    members = mapRange(narrowedWidth, () => type.elementT);
  } else {
    throw new TranspileFailedError(
      `Attempted to create incorrect form of memory->storage copy for ${printTypeNode(type)}`,
    );
  }

  let storageOffset = 0;
  return members.flatMap((memberType) => {
    if (isReferenceType(memberType)) {
      const offset = storageOffset;
      storageOffset += CairoType.fromSol(
        memberType,
        ast,
        TypeConversionContext.StorageAllocation,
      ).width;
      return [{ storageOffset: offset, copyType: memberType }];
    } else {
      const width = CairoType.fromSol(
        memberType,
        ast,
        TypeConversionContext.StorageAllocation,
      ).width;
      return mapRange(width, () => ({ storageOffset: storageOffset++ }));
    }
  });
}

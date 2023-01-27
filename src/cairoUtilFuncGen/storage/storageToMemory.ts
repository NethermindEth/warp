import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
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
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

/*
  Generates functions to copy data from WARP_STORAGE to warp_memory
  Specifically this has to deal with structs, static arrays, and dynamic arrays
  These require extra care because the representations are different in storage and memory
  In storage nested structures are stored in place, whereas in memory 'pointers' are used
*/

export class StorageToMemoryGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }
  gen(node: Expression): Expression {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    const funcDef = this.getOrCreateFuncDef(type);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  getOrCreateFuncDef(type: TypeNode) {
    const key = `storageToMemory(${type.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
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
        `Copying ${printTypeNode(type)} from storage to memory not implemented yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(type),
      (type) => this.createStaticArrayCopyFunction(type),
      (type, def) => this.createStructCopyFunction(type, def),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(
    type: UserDefinedType,
    def: StructDefinition,
  ): GeneratedFunctionInfo {
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);

    const funcName = `ws_to_memory_struct_${def.name}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('warplib.memory', 'wm_alloc'),
    );

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc : felt) -> (mem_loc: felt){`,
        `    alloc_locals;`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)});`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => [
            this.getIterCopyCode(copyType, index, storageOffset),
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index});`,
          ],
        ),
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    return type.size <= 5
      ? this.createSmallStaticArrayCopyFunction(type)
      : this.createLargeStaticArrayCopyFunction(type);
  }

  private createSmallStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('warplib.memory', 'wm_alloc'),
    );

    const funcName = `ws_to_memory_static_array${this.generatedFunctionsDef.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc : felt) -> (mem_loc : felt){`,
        `    alloc_locals;`,
        `    let length = ${uint256(memoryType.width)};`,
        `    let (mem_start) = wm_alloc(length);`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => [
            this.getIterCopyCode(copyType, index, storageOffset),
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index});`,
          ],
        ),
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };

    return funcInfo;
  }

  private createLargeStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined, 'Expected static array with known size');
    const funcName = `ws_to_memory${this.generatedFunctionsDef.size}`;
    const length = narrowBigIntSafe(
      type.size,
      `Failed to narrow size of ${printTypeNode(type)} in memory->storage copy generation`,
    );
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('warplib.memory', 'wm_alloc'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );

    const elementMemoryWidth = CairoType.fromSol(type.elementT, this.ast).width;
    const elementStorageWidth = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const copyCode: string = this.getRecursiveCopyCode(
      type.elementT,
      elementMemoryWidth,
      'loc',
      'mem_start',
    );

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(mem_start: felt, loc : felt, length: Uint256) -> (){`,
        `   alloc_locals;`,
        `   if (length.low == 0){`,
        `       if (length.high == 0){`,
        `           return ();`,
        `       }`,
        `   }`,
        `   let (index) = uint256_sub(length, Uint256(1, 0));`,
        copyCode,
        `   return ${funcName}_elem(${add('mem_start', elementMemoryWidth)}, ${add(
          'loc',
          elementStorageWidth,
        )}, index);`,
        `}`,

        `func ${funcName}${implicits}(loc : felt) -> (mem_loc : felt){`,
        `    alloc_locals;`,
        `    let length = ${uint256(length)};`,
        `    let (mem_start) = wm_alloc(length);`,
        `    ${funcName}_elem(mem_start, loc, length);`,
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createDynamicArrayCopyFunction(
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(type);
    const memoryElementType = CairoType.fromSol(elementT, this.ast);
    const funcName = `ws_to_memory${this.generatedFunctionsDef.size}`;

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_new'),
      this.requireImport('warplib.memory', 'wm_index_dyn'),
    );

    const elemMappingDef = this.dynArrayGen.getOrCreateFuncDef(elementT);
    funcsCalled.push(elemMappingDef);
    const elemMappingName = elemMappingDef.name;
    const lengthMappingName = elemMappingDef.name + '_LENGTH';
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    // This is the code to copy a single element
    // Complex types require calls to another function generated here
    // Simple types take one or two WARP_STORAGE-dict_write pairs
    const copyCode: string = this.getRecursiveCopyCode(
      elementT,
      memoryElementType.width,
      'element_storage_loc',
      'mem_loc',
    );

    // Now generate two functions: the setup function funcName, and the elementwise copy function: funcName_elem
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storage_name: felt, mem_start: felt, length: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == 0 and length.high == 0){`,
        `        return ();`,
        `    }`,
        `    let (index) = uint256_sub(length, Uint256(1,0));`,
        `    let (mem_loc) = wm_index_dyn(mem_start, index, ${uint256(memoryElementType.width)});`,
        `    let (element_storage_loc) = ${elemMappingName}.read(storage_name, index);`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_start, index);`,
        `}`,

        `func ${funcName}${implicits}(loc : felt) -> (mem_loc : felt){`,
        `    alloc_locals;`,
        `    let (length: Uint256) = ${lengthMappingName}.read(loc);`,
        `    let (mem_start) = wm_new(length, ${uint256(memoryElementType.width)});`,
        `    ${funcName}_elem(loc, mem_start, length);`,
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };

    return funcInfo;
  }

  // Copy code generation for iterative copy instructions (small static arrays and structs)
  private getIterCopyCode(
    copyType: TypeNode | undefined,
    index: number,
    storageOffset: number,
  ): string {
    if (copyType === undefined) {
      return `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)});`;
    }

    const funcName = this.getOrCreate(copyType).name;
    return isDynamicArray(copyType)
      ? [
          `let (dyn_loc) = WARP_STORAGE.read(${add('loc', storageOffset)});`,
          `let (copy${index}) = ${funcName}(dyn_loc);`,
        ].join('\n')
      : `let (copy${index}) = ${funcName}(${add('loc', storageOffset)});`;
  }

  // Copy code generation for recursive copy instructions (large static arrays and dynamic arrays)
  private getRecursiveCopyCode(
    elementT: TypeNode,
    elementMemoryWidth: number,
    storageLoc: string,
    memoryLoc: string,
  ) {
    if (isStaticArrayOrStruct(elementT)) {
      return [
        `   let (copy) = ${this.getOrCreate(elementT).name}(${storageLoc});`,
        `   dict_write{dict_ptr=warp_memory}(${memoryLoc}, copy);`,
      ].join('\n');
    } else if (isDynamicArray(elementT)) {
      return [
        `   let (dyn_loc) = readId(${storageLoc});`,
        `   let (copy) = ${this.getOrCreate(elementT).name}(dyn_loc);`,
        `   dict_write{dict_ptr=warp_memory}(${memoryLoc}, copy);`,
      ].join('\n');
    } else {
      return mapRange(elementMemoryWidth, (n) =>
        [
          `   let (copy) = WARP_STORAGE.read(${add(`${storageLoc}`, n)});`,
          `   dict_write{dict_ptr=warp_memory}(${add(`${memoryLoc}`, n)}, copy);`,
        ].join('\n'),
      ).join('\n');
    }
  }
}

type CopyInstruction = {
  // The offset into the storage object to copy
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
    throw new NotSupportedYetError(
      `Copying ${printTypeNode(type)} from storage to memory not implemented yet`,
    );
  }

  let storageOffset = 0;
  return members.flatMap((memberType) => {
    if (isStaticArrayOrStruct(memberType)) {
      const offset = storageOffset;
      storageOffset += CairoType.fromSol(
        memberType,
        ast,
        TypeConversionContext.StorageAllocation,
      ).width;
      return [{ storageOffset: offset, copyType: memberType }];
    } else if (isDynamicArray(memberType)) {
      return [{ storageOffset: storageOffset++, copyType: memberType }];
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

function isStaticArrayOrStruct(type: TypeNode) {
  return (
    (type instanceof ArrayType && type.size !== undefined) ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition)
  );
}

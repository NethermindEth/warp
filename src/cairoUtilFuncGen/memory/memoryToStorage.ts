import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';

/*
  Generates functions to copy data from warp_memory to WARP_STORAGE
  Specifically this has to deal with structs, static arrays, and dynamic arrays
  These require extra care because the representations are different in storage and memory
  In storage nested structures are stored in place, whereas in memory 'pointers' are used
*/

export class MemoryToStorageGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }
  gen(
    storageLocation: Expression,
    memoryLocation: Expression,
    nodeInSourceUnit?: ASTNode,
  ): Expression {
    console.log(`Generating m->s for ${printNode(storageLocation)} = ${printNode(memoryLocation)}`);
    const type = generalizeType(getNodeType(storageLocation, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage],
        ['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory],
      ],
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [storageLocation, memoryLocation], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      return this.createStructCopyFunction(key, type);
    } else if (type instanceof ArrayType) {
      if (type.size === undefined) {
        return this.createDynamicArrayCopyFunction(key, type);
      } else {
        return this.createStaticArrayCopyFunction(key, type);
      }
    } else {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from memory to storage not implemented yet`,
      );
    }
  }

  // This can also be used for arrays, in which case they are treated like structs with <length> members
  private createStructCopyFunction(key: string, type: TypeNode): string {
    const funcName = `wm_to_storage${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc : felt, mem_loc: felt) -> (loc: felt):`,
        `    alloc_locals`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => {
            const readMemFelt = `let (memFelt${index}) = dict_read{dict_ptr=warp_memory}(${add(
              'mem_loc',
              index,
            )})`;
            if (copyType === undefined) {
              return [
                readMemFelt,
                `WARP_STORAGE.write(${add('loc', storageOffset)}, memFelt${index})`,
              ];
            } else {
              const funcName = this.getOrCreate(copyType);
              return [readMemFelt, `${funcName}(${add('loc', storageOffset)}, memFelt${index})`];
            }
          },
        ),
        `    return (loc)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');

    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, type: ArrayType): string {
    assert(type.size !== undefined, 'Expected static array with known size');
    return type.size <= 5
      ? this.createStructCopyFunction(key, type)
      : this.createLargeStaticArrayCopyFunction(key, type);
  }

  private createLargeStaticArrayCopyFunction(key: string, type: ArrayType) {
    assert(type.size !== undefined, 'Expected static array with known size');
    const length = narrowBigIntSafe(
      type.size,
      `Failed to narrow size of ${printTypeNode(type)} in memory->storage copy generation`,
    );
    const funcName = `wm_to_storage${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const elementStorageWidth = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(type.elementT, this.ast).width;
    let copyCode: string;
    if (isStaticArrayOrStruct(type.elementT)) {
      copyCode = [`    ${this.getOrCreate(type.elementT)}(loc, mem_loc)`].join('\n');
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)})`,
          `    WARP_STORAGE.write(${add('loc', n)}, copy)`,
        ].join('\n'),
      ).join('\n');
    }

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(loc: felt, mem_loc : felt, length: felt) -> ():`,
        `    alloc_locals`,
        `    if length == 0:`,
        `        return ()`,
        `    end`,
        `    let index = length - 1`,
        copyCode,
        `    return ${funcName}_elem(${add('loc', elementStorageWidth)}, ${add(
          'mem_loc',
          elementMemoryWidth,
        )}, index)`,
        `end`,

        `func ${funcName}${implicits}(loc : felt, mem_loc : felt) -> (loc : felt):`,
        `    alloc_locals`,
        `    ${funcName}_elem(loc, mem_loc, ${length})`,
        `    return (loc)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return funcName;
  }

  private createDynamicArrayCopyFunction(key: string, type: ArrayType): string {
    const funcName = `wm_to_storage${this.generatedFunctions.size}`;

    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const [elemMapping, lengthMapping] = this.dynArrayGen.gen(
      CairoType.fromSol(type.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const elementStorageWidth = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const elementMemoryWidth = CairoType.fromSol(type.elementT, this.ast).width;
    let copyCode: string;
    if (isStaticArrayOrStruct(type.elementT)) {
      copyCode = [`    ${this.getOrCreate(type.elementT)}(storage_loc, mem_loc)`].join('\n');
    } else {
      copyCode = mapRange(elementStorageWidth, (n) =>
        [
          `    let (copy) = dict_read{dict_ptr=warp_memory}(${add('mem_loc', n)})`,
          `    WARP_STORAGE.write(${add('storage_loc', n)}, copy)`,
        ].join('\n'),
      ).join('\n');
    }

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storage_name: felt, mem_loc : felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (storage_loc) = ${elemMapping}.read(storage_name, index)`,
        `    let mem_loc = mem_loc - ${elementMemoryWidth}`,
        `    if storage_loc == 0:`,
        `        let (storage_loc) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(storage_loc + ${elementStorageWidth})`,
        `        ${elemMapping}.write(storage_name, index, storage_loc)`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_loc, index)`,
        `    else:`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_loc, index)`,
        `    end`,
        `end`,

        `func ${funcName}${implicits}(loc : felt, mem_loc : felt) -> (loc : felt):`,
        `    alloc_locals`,
        `    let (name) = readId(loc)`,
        `    let (length) = wm_dyn_array_length(mem_loc)`,
        `    ${lengthMapping}.write(name, length)`,
        `    let (narrowedLength) = narrow_safe(length)`,
        `    ${funcName}_elem(name, mem_loc + 2 + ${elementMemoryWidth} * narrowedLength, length)`,
        `    return (loc)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_dyn_array_length');
    this.requireImport('warplib.maths.utils', 'narrow_safe');

    return funcName;
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
    members = type.definition.vMembers.map((decl) => getNodeType(decl, ast.compilerVersion));
  } else if (type instanceof ArrayType && type.size !== undefined) {
    const narrowedWidth = narrowBigIntSafe(type.size, `Array size ${type.size} not supported`);
    members = mapRange(narrowedWidth, () => type.elementT);
  } else {
    throw new NotSupportedYetError(
      `Copying ${printTypeNode(type)} from memory to storage not implemented yet`,
    );
  }

  let storageOffset = 0;
  return members.flatMap((memberType) => {
    if (memberType instanceof ArrayType && memberType.size === undefined) {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(memberType)} from memory to storage not implemented yet`,
      );
    }

    if (isStaticArrayOrStruct(memberType)) {
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

function isStaticArrayOrStruct(type: TypeNode) {
  return (
    (type instanceof ArrayType && type.size !== undefined) ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition)
  );
}

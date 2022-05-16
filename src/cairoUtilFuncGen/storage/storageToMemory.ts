import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  getNodeType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError, WillNotSupportError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { dereferenceType, mapRange, narrowBigInt, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

/*
  Generates functions to copy data from WARP_STORAGE to warp_memory
  Specifically this has to deal with structs, static arrays, and dynamic arrays
  These require extra care because the representations are different in storage and memory
  In storage nested structures are stored in place, whereas in memory 'pointers' are used
*/

export class StorageToMemoryGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }
  gen(node: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? node,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [node], this.ast);
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
        `Copying ${printTypeNode(type)} from storage to memory not implemented yet`,
      );
    }
  }

  private createStructCopyFunction(key: string, type: UserDefinedType): string {
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const funcBody = [
      `    alloc_locals`,
      `    let (mem_start) = wm_alloc(${uint256(memoryType.width)})`,
      ...generateCopyInstructions(type, this.ast).flatMap(({ storageOffset, copyType }, index) => {
        if (copyType === undefined) {
          return [
            `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index})`,
          ];
        } else {
          const funcName = this.getOrCreate(copyType);
          return [
            `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index})`,
          ];
        }
      }),
      `    return (mem_start)`,
      `end`,
    ].join('\n');

    const funcName = `ws_to_memory${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const funcHeader = `func ${funcName}${implicits}(loc : felt) -> (mem_loc: felt):`;

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [funcHeader, funcBody].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');

    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, type: ArrayType): string {
    assert(type.size !== undefined, 'Expected static array with known size');
    return type.size <= 5
      ? this.createSmallStaticArrayCopyFunction(key, type)
      : this.createLargeStaticArrayCopyFunction(key, type);
  }

  private createSmallStaticArrayCopyFunction(key: string, type: ArrayType) {
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const funcBody = [
      `    alloc_locals`,
      `    let length = ${uint256(memoryType.width)}`,
      `    let (mem_start) = wm_alloc(length)`,
      ...generateCopyInstructions(type, this.ast).flatMap(({ storageOffset, copyType }, index) => {
        if (copyType === undefined) {
          return [
            `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index})`,
          ];
        } else {
          const funcName = this.getOrCreate(copyType);
          return [
            `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', index)}, copy${index})`,
          ];
        }
      }),
      `    return (mem_start)`,
      `end`,
    ].join('\n');

    const funcName = `ws_to_memory${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const funcHeader = `func ${funcName}${implicits}(loc : felt) -> (mem_loc : felt):`;

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [funcHeader, funcBody].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');

    return funcName;
  }

  private createLargeStaticArrayCopyFunction(key: string, type: ArrayType) {
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const funcName = `ws_to_memory${this.generatedFunctions.size}`;

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const elemW = CairoType.fromSol(type.elementT, this.ast).width;
    let copyCode: string;
    if (isStaticArrayOrStruct(type.elementT)) {
      copyCode = [
        `   let (copy) = ${this.getOrCreate(type.elementT)}('loc')`,
        `   dict_write{dict_ptr=warp_memory}(mem_start)`,
      ].join('\n');
    } else {
      copyCode = mapRange(elemW, (n) =>
        [
          `   let (copy) = WARP_STORAGE.read(${add('loc', n)})`,
          `   dict_write{dict_ptr=warp_memory}(${add('mem_start', n)}, copy)`,
        ].join('\n'),
      ).join('\n');
    }

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(mem_start: felt, loc : felt, length: Uint256) -> ():`,
        `   alloc_locals`,
        `   if length.low == 0:`,
        `       if length.high == 0:`,
        `           return ()`,
        `       end`,
        `   end`,
        `   let (index) = uint256_sub(length, Uint256(1, 0))`,
        copyCode,
        `   return ${funcName}_elem(${add('mem_start', elemW)}, ${add('loc', elemW)}, index)`,
        `end`,

        `func ${funcName}${implicits}(loc : felt) -> (mem_loc : felt):`,
        `    alloc_locals`,
        `    let length = ${uint256(memoryType.width)}`,
        `    let (mem_start) = wm_alloc(length)`,
        `    ${funcName}_elem(mem_start, loc, length)`,
        `    return (mem_start)`,
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
    const memoryElementType = CairoType.fromSol(type.elementT, this.ast);
    const funcName = `ws_to_memory${this.generatedFunctions.size}`;

    const [elemMapping, lengthMapping] = this.dynArrayGen.gen(
      CairoType.fromSol(type.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    // This is the code to copy a single element
    // Complex types require calls to another function generated here
    // Simple types take one or two WARP_STORAGE-dict_write pairs
    let copyCode: string;
    if (
      type.elementT instanceof ArrayType ||
      (type.elementT instanceof UserDefinedType &&
        type.elementT.definition instanceof StructDefinition)
    ) {
      copyCode = `let (copy) = ${this.getOrCreate(type.elementT)}`;
    } else {
      copyCode = mapRange(CairoType.fromSol(type.elementT, this.ast).width, (n) =>
        [
          `    let (copy) = WARP_STORAGE.read(${add('element_storage_loc', n)})`,
          `    dict_write{dict_ptr=warp_memory}(${add('mem_loc', n)}, copy)`,
        ].join('\n'),
      ).join('\n');
    }

    // Now generate two functions: the setup function funcName, and the elementwise copy function: funcName_elem
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storage_name: felt, mem_start: felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (mem_loc) = wm_index_dyn(mem_start, index, ${uint256(memoryElementType.width)})`,
        `    let (element_storage_loc) = ${elemMapping}.read(storage_name, index)`,
        copyCode,
        `    return ${funcName}_elem(storage_name, mem_start, index)`,
        `end`,

        `func ${funcName}${implicits}(name : felt) -> (mem_loc : felt):`,
        `    alloc_locals`,
        `    let (length: Uint256) = ${lengthMapping}.read(name)`,
        `    let (mem_start) = wm_new(length, ${uint256(memoryElementType.width)})`,
        `    ${funcName}_elem(name, mem_start, length)`,
        `    return (mem_start)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.memory', 'wm_index_dyn');

    return funcName;
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
    members = type.definition.vMembers.map((decl) => getNodeType(decl, ast.compilerVersion));
  } else if (type instanceof ArrayType && type.size !== undefined) {
    // TODO separate array copy function that recurses, potentially only if the array is large
    const narrowedWidth = narrowBigInt(type.size);
    if (narrowedWidth === null) {
      throw new WillNotSupportError(`Array size ${type.size} not supported`);
    }
    members = mapRange(narrowedWidth, () => type.elementT);
  } else {
    throw new NotSupportedYetError(
      `Copying ${printTypeNode(type)} from storage to memory not implemented yet`,
    );
  }

  let storageOffset = 0;
  return members.flatMap((memberType) => {
    if (memberType instanceof ArrayType && memberType.size === undefined) {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(memberType)} from storage to memory not implemented yet`,
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

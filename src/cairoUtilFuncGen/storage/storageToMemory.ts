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
  UNFINISHED
  Generates functions to copy data from WARP_STORAGE to warp_memory
  For simple cases, reads can be used and are handled by their own FuncGen,
  this exists to handle complex cases such as structs and dynamic arrays

  Progress - Currently handles only addresses, bools, ints, and enums
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
      [['memLoc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
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
    const funcName = `ws_to_memory${this.generatedFunctions.size}`;

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (memLoc : felt):`,
        `    alloc_locals`,
        `    let (memStart) = wm_alloc(${uint256(memoryType.width)})`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => {
            if (copyType === undefined) {
              return [
                `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
                `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
              ];
            } else {
              const funcName = this.getOrCreate(copyType);
              return [
                `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
                `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
              ];
            }
          },
        ),
        `    return (memStart)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');

    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, type: ArrayType): string {
    // TEMP
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const funcName = `ws_to_memory${this.generatedFunctions.size}`;

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (memLoc : felt):`,
        `    alloc_locals`,
        `    let (memStart) = wm_alloc(${uint256(memoryType.width)})`,
        ...generateCopyInstructions(type, this.ast).flatMap(
          ({ storageOffset, copyType }, index) => {
            if (copyType === undefined) {
              return [
                `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
                `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
              ];
            } else {
              const funcName = this.getOrCreate(copyType);
              return [
                `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
                `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
              ];
            }
          },
        ),
        `    return (memStart)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');

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
          `    let (copy) = WARP_STORAGE.read(${add('elementStorageLoc', n)})`,
          `    dict_write{dict_ptr=warp_memory}(${add('memLoc', n)}, copy)`,
        ].join('\n'),
      ).join('\n');
    }

    // Now generate two functions: the setup function funcName, and the elementwise copy function: funcName_elem
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(storageName: felt, memStart: felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (memLoc) = wm_index_dyn(memStart, index, ${uint256(memoryElementType.width)})`,
        `    let (elementStorageLoc) = ${elemMapping}.read(storageName, index)`,
        copyCode,
        `    return ${funcName}_elem(storageName, memStart, index)`,
        `end`,

        `func ${funcName}${implicits}(name : felt) -> (memLoc : felt):`,
        `    alloc_locals`,
        `    let (length: Uint256) = ${lengthMapping}.read(name)`,
        `    let (memStart) = wm_new(length, ${uint256(memoryElementType.width)})`,
        `    ${funcName}_elem(name, memStart, length)`,
        `    return (memStart)`,
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

    if (
      (memberType instanceof ArrayType && memberType.size !== undefined) ||
      (memberType instanceof UserDefinedType && memberType.definition instanceof StructDefinition)
    ) {
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

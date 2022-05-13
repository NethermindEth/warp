import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  FunctionTypeName,
  getNodeType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoType } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { dereferenceType, typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';

// I know this feels wrong, but just go with it.
export class MemoryToCallData extends StringIndexedFuncGen {
  gen(node: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      [['val', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      node,
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
    assert(type instanceof ArrayType);
    return this.createDynamicArrayReadFunction(key, type);
  }

  //private createDynamicArrayReadersFunction

  // `func wm_reader_felt{range_check_ptr, warp_memory : DictAccess*}(len: felt, ptr: felt*, loc:felt) -> (res0 : felt*):`,
  // `    alloc_locals`,
  // `    if len == 0:`,
  // `       return (ptr)`,
  // `    end`,
  // `    let(val) = dict_read{dict_ptr=warp_memory}(loc)`,
  // `    assert ptr[0] = val`,
  // `    wm_reader_felt(len=len-1, ptr=ptr + 1, loc=loc + 1)`,
  // `    return (ptr)`,
  // `end`,
  private createDynamicArrayReadFunction(key: string, type: ArrayType): string {
    const memoryElementType = CairoType.fromSol(type.elementT, this.ast);
    const funcName = `wm_to_calldata_${memoryElementType}`; //wm_to_calldata_felt

    const dynArrayReader = this.generateDynamicReaderType(memoryElementType);

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc : felt) -> (val : dynarray_struct_felt):`,
        `    alloc_locals`,
        `    let (read0) = wm_read_256(loc)`,
        `    let (len0) = narrow_safe(read0)`,
        `    let (ptr0) = alloc()`,
        `    let (ptr0) = ${dynArrayReader}(len0, ptr0, loc + 2)`,
        `    return (dynarray_struct_felt(len=len0, ptr=ptr0))`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('warplib.memory', 'wm_read_256');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.maths.utils', 'narrow_safe');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');

    return funcName;
  }

  private generateDynamicReaderType(cairoType: CairoType): string {
    const funcName = `wm_dynarry_reader_${cairoType.toString()}`;
    this.generatedFunctions.set(cairoType.toString(), {
      name: funcName,
      code: [
        `func wm_reader_felt{range_check_ptr, warp_memory : DictAccess*}(len: felt, ptr: felt*, loc:felt) -> (res0 : felt*):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `       return (ptr)`,
        `    end`,
        `    let(val) = dict_read{dict_ptr=warp_memory}(loc)`,
        `    assert ptr[0] = val`,
        `    wm_reader_felt(len=len-1, ptr=ptr + 1, loc=loc + 1)`,
        `    return (ptr)`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }
}
//   private createStructCopyFunction(key: string, type: UserDefinedType): string {
//     const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
//     const funcName = `ws_to_memory${this.generatedFunctions.size}`;

//     this.generatedFunctions.set(key, {
//       name: funcName,
//       code: [
//         `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (memLoc : felt):`,
//         `    alloc_locals`,
//         `    let (memStart) = wm_alloc(${uint256(memoryType.width)})`,
//         ...generateCopyInstructions(type, this.ast).flatMap(
//           ({ storageOffset, copyType }, index) => {
//             if (copyType === undefined) {
//               return [
//                 `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
//                 `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
//               ];
//             } else {
//               const funcName = this.getOrCreate(copyType);
//               return [
//                 `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
//                 `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
//               ];
//             }
//           },
//         ),
//         `    return (memStart)`,
//         `end`,
//       ].join('\n'),
//     });

//     this.requireImport('starkware.cairo.common.dict', 'dict_write');
//     this.requireImport('warplib.memory', 'wm_alloc');

//     return funcName;
//   }

//   private createStaticArrayCopyFunction(key: string, type: ArrayType): string {
//     // TEMP
//     const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
//     const funcName = `ws_to_memory${this.generatedFunctions.size}`;

//     this.generatedFunctions.set(key, {
//       name: funcName,
//       code: [
//         `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (memLoc : felt):`,
//         `    alloc_locals`,
//         `    let (memStart) = wm_alloc(${uint256(memoryType.width)})`,
//         ...generateCopyInstructions(type, this.ast).flatMap(
//           ({ storageOffset, copyType }, index) => {
//             if (copyType === undefined) {
//               return [
//                 `let (copy${index}) = WARP_STORAGE.read(${add('loc', storageOffset)})`,
//                 `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
//               ];
//             } else {
//               const funcName = this.getOrCreate(copyType);
//               return [
//                 `let (copy${index}) = ${funcName}(${add('loc', storageOffset)})`,
//                 `dict_write{dict_ptr=warp_memory}(${add('memStart', index)}, copy${index})`,
//               ];
//             }
//           },
//         ),
//         `    return (memStart)`,
//         `end`,
//       ].join('\n'),
//     });

//     this.requireImport('starkware.cairo.common.dict', 'dict_write');
//     this.requireImport('warplib.memory', 'wm_alloc');

//     return funcName;
//   }

// type CopyInstruction = {
//   // The offset into the storage object to copy
//   storageOffset: number;
//   // If the copy requires a recursive call, this is the type to copy
//   copyType?: TypeNode;
// };

// function generateCopyInstructions(type: TypeNode, ast: AST): CopyInstruction[] {
//   let members: TypeNode[];

//   if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
//     members = type.definition.vMembers.map((decl) => getNodeType(decl, ast.compilerVersion));
//   } else if (type instanceof ArrayType && type.size !== undefined) {
//     // TODO separate array copy function that recurses, potentially only if the array is large
//     const narrowedWidth = narrowBigInt(type.size);
//     if (narrowedWidth === null) {
//       throw new WillNotSupportError(`Array size ${type.size} not supported`);
//     }
//     members = mapRange(narrowedWidth, () => type.elementT);
//   } else {
//     throw new NotSupportedYetError(
//       `Copying ${printTypeNode(type)} from storage to memory not implemented yet`,
//     );
//   }

//   let storageOffset = 0;
//   return members.flatMap((memberType) => {
//     if (memberType instanceof ArrayType && memberType.size === undefined) {
//       throw new NotSupportedYetError(
//         `Copying ${printTypeNode(memberType)} from storage to memory not implemented yet`,
//       );
//     }

//     if (
//       (memberType instanceof ArrayType && memberType.size !== undefined) ||
//       (memberType instanceof UserDefinedType && memberType.definition instanceof StructDefinition)
//     ) {
//       const offset = storageOffset;
//       storageOffset += CairoType.fromSol(
//         memberType,
//         ast,
//         TypeConversionContext.StorageAllocation,
//       ).width;
//       return [{ storageOffset: offset, copyType: memberType }];
//     } else {
//       const width = CairoType.fromSol(
//         memberType,
//         ast,
//         TypeConversionContext.StorageAllocation,
//       ).width;
//       return mapRange(width, () => ({ storageOffset: storageOffset++ }));
//     }
//   });
//

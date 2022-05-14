import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  // FunctionTypeName,
  getNodeType,
  PointerType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoFelt,
  CairoType,
  CairoUint256,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { dereferenceType, typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';
import { counterGenerator } from '../../utils/utils';
// import { serialiseReads } from '../serialisation';

// I know this feels wrong, but just go with it.
export class MemoryToCallData extends StringIndexedFuncGen {
  gen(node: Expression, _: ASTNode): Expression {
    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));

    const name = this.getOrCreateDyn(type);
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

  private getOrCreateDyn(type: TypeNode): string {
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
    const dereferenceMemeberType = dereferenceType(type.elementT);
    const dynArrayReader = this.generateDynamicReaderType(dereferenceMemeberType, memoryElementType);

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc : felt) -> (val : dynarray_struct_${memoryElementType.toString()}):`,
        `    alloc_locals`,
        `    let (len_256) = wm_read_256(loc)`,
        `    let (len_felt) = narrow_safe(len_256)`,
        `    let (ptr : ${memoryElementType.toString()}*) = alloc()`,
        `    let (ptr) = ${dynArrayReader}(len_felt, ptr, loc + 2)`,
        `    return (dynarray_struct_${memoryElementType.toString()}(len=len_felt, ptr=ptr))`,
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

  private generateDynamicReaderType(typeNode: TypeNode, memoryReadType: CairoType): string {
    const funcName = `wm_dynarry_reader_${memoryReadType.toString()}`;
    const readCounter = counterGenerator();
    const locCounter = counterGenerator(-1);
    const pointerRead = undefined;
    if (typeNode instanceof PointerType) {
      const [varDecl, read, funcCall] = this.generateMemoryReadFunctionCall(typeNode, readCounter, locCounter);
      const pointerRead = read;
    }
    const [l, a, funcCall] = this.generateMemoryReadFunctionCall(typeNode, readCounter, locCounter);
    this.generatedFunctions.set(memoryReadType.toString(), {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(len: felt, ptr: ${memoryReadType.toString()}*, loc:felt) -> (res0 : ${memoryReadType.toString()}*):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `       return (ptr)`,
        `    end`,
        // If the type is a Pointer then add a read
        pointerRead !== undefined ? pointerRead : '',
        `    assert ptr[0] =  ${funcCall}(${add('loc', locCounter.next().value)}`,
        // This memoryType.width is more for the memory system than actual cairo itself so we might need to check that it is constant with NestedStructs.
        // There could also be a ternary condition that just checks if it is a felt or struct and we can the stick a .SIZE in there.
        `    ${funcName}(len=len-1, ptr=ptr + ${memoryReadType.width}, loc=loc + ${memoryReadType.width})`,
        `    return (ptr)`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }

  generateMemoryReadFunctionCall(
    typeNode: TypeNode,
    readCounter: Generator,
    locCounter: Generator,
  ): [varDecl: string, read: string, functionCall: string] {
    const typeToRead = CairoType.fromSol(
      typeNode,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const readOffset = readCounter.next().value;
    const locOffset = locCounter.next().value;
    //  Add a generator there that adds an int to the name. There should be a new one for each ne function.
    if (typeToRead instanceof CairoFelt) {
      this.requireImport('warplib.memory', 'wm_read_felt');
      return [
        `read${readOffset}`,
        `let (read${readOffset}) = wm_read_felt(${add('loc', locOffset)})`,
        'wm_read_felt',
      ];
    } else if (typeToRead.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      this.requireImport('warplib.memory', 'wm_read_256');
      const varDecl = `read${readOffset}`;
      const read = `let (read${readOffset}) = wm_read_256(${add('loc', locOffset)})`;
      locCounter.next();
      return [varDecl, read, 'wm_read_256'];
    } else if (
      typeNode instanceof UserDefinedType &&
      typeNode.definition instanceof StructDefinition
    ) {
      const structName = this.getOrCreateStructRead(typeNode);
      return [
        `read${readOffset}`,
        `let(read${readOffset}) = ${structName}(read${readOffset})`,
        structName,
      ];
    } else {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(typeNode)} from memory to calldata not implemented yet`,
      );
    }
  }

  getOrCreateStructRead(typeNode: UserDefinedType): string {
    const cairoType = CairoType.fromSol(typeNode, this.ast, TypeConversionContext.MemoryAllocation);
    const funcName = `wm_read_struct${cairoType.toString()}`;
    const existing = this.generatedFunctions.get(funcName);
    if (existing !== undefined) {
      return funcName;
    }
    //dereferenceType(getNodeType(node, this.ast.compilerVersion))
    assert(typeNode.definition instanceof StructDefinition);
    const structMembers = typeNode.definition.vMembers.map((member) =>
      getNodeType(member, this.ast.compilerVersion),
    );
    const readGenerator = counterGenerator();
    const locGenerator = counterGenerator();
    const GeneratedReads = structMembers.map((typeNodeMember) =>
      this.generateMemoryReadFunctionCall(typeNodeMember, readGenerator, locGenerator),
    );
    const reads: string[] = [];
    const varDecls: string[] = [];
    const funcNames: string[] = [];

    GeneratedReads.forEach((x) => {
      varDecls.push(x[0]);
      reads.push(x[1]);
      funcNames.push(x[2]);
    });

    this.generatedFunctions.set(funcName, {
      name: funcName,
      code: [
        `func ${funcName}{implicits}(loc:felt) -> (res: ${cairoType})`,
        reads.join('\n'),
        `return ${cairoType}(${varDecls.join(',')})`,
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

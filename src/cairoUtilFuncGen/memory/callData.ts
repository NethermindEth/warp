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
import { read } from 'fs-extra';
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
    const funcName = `wm_to_calldata_dyn_${memoryElementType}`; //wm_to_calldata_felt
    //const dereferenceMemeberType = dereferenceType(type.elementT);
    const dynArrayReader = this.generateDynamicReaderType(type.elementT, memoryElementType);

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

  private generateDynMemberLoader(cairoType: CairoType): string | undefined {
    if (cairoType instanceof CairoFelt) {
      return 'wm_read_felt';
    } else if (cairoType.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      return 'wm_read_256';
    } else if (
      cairoType instanceof UserDefinedType &&
      cairoType.definition instanceof StructDefinition
    ) {
      return `wm_read_struct_${cairoType.toString()}`;
    }
  }

  private generateDynamicReaderType(typeNode: TypeNode, memoryReadType: CairoType): string {
    const funcName = `wm_dynarry_reader_${memoryReadType.toString()}`;
    const readTracker = new ReadTracker();
    //const funcCall = this.generateDynMemberLoader(memoryReadType);
    const reads: string[] = [];
    const varDecls: string[] = [];
    // const readCounter = counterGenerator();
    // const locCounter = counterGenerator(-1);
    //let readCounter = 0;
    //let locCounter = 0;
    const [varDecls_, reads_, readTracker_] = this.generateMemoryReadFunctionCall(
      typeNode,
      varDecls,
      reads,
      readTracker,
    );

    this.generatedFunctions.set(memoryReadType.toString(), {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(len: felt, ptr: ${memoryReadType.toString()}*, loc:felt) -> (res0 : ${memoryReadType.toString()}*):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `       return (ptr)`,
        `    end`,
        // you would want the dereference in here since the function above provides this with a pointer to pointer;
        ...reads,
        `    assert ptr[0] = read${readTracker.readOffset - 1}`,
        // This memoryType.width is more for the memory system than actual cairo itself so we might need to check that it is constant with NestedStructs.
        // There could also be a ternary condition that just checks if it is a felt or struct and we can the stick a .SIZE in there.
        `    ${funcName}(len=len-1, ptr=ptr + ${memoryReadType.width}, loc=loc + ${memoryReadType.width})`,
        `    return (ptr)`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }
  // split the returned function call out into another function. We don't need it here.
  // Then change the reads to be reads[]. Then at the beginning of each loop
  // add a read[] then push to it. Also add a Vardecl [] and push to that each loop aswell.
  // if there is pointer type then do a recursive loop and push the read and vardecl, but not if it is a pointer. Increase the
  // read counter but dont increase the loc counter. Then after this is finished perform a flat map
  // on the reads[] and insert them into the function and then do the join of the vardecls in the struct constructor.
  // Return the reach
  generateMemoryReadFunctionCall(
    typeNode: TypeNode,
    varDecls: string[],
    reads: string[],
    readTracker: ReadTracker,
  ): [varDecl: string[], read: string[], readTracker: ReadTracker] {
    const typeToRead = CairoType.fromSol(
      typeNode,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    // const readOffset = readCounter.next().value;
    // const locOffset = locCounter.next().value;
    //  Add a generator there that adds an int to the name. There should be a new one for each ne function.
    if (typeNode instanceof PointerType) {
      //varDecls.push(`read${readCounter}`);

      reads.push(
        `    let (read${readTracker.readOffset}) = wm_read_felt(${add(
          'loc',
          readTracker.locOffset,
        )})`,
      );
      readTracker.incrementReadOffset();
      readTracker.increamentLocOffset();
      this.generateMemoryReadFunctionCall(dereferenceType(typeNode), varDecls, reads, readTracker);
      return [varDecls, reads, readTracker];
    } else if (typeToRead instanceof CairoFelt) {
      //const locOffset = locCounter.next().value;
      //const readOffset = readCounter.next().value;
      this.requireImport('warplib.memory', 'wm_read_felt');
      varDecls.push(`read${readTracker.readOffset}`);
      reads.push(
        `    let (read${readTracker.readOffset}) = wm_read_felt(${add(
          'loc',
          readTracker.locOffset,
        )})`,
      );
      readTracker.incrementReadOffset();
      readTracker.increamentLocOffset();
      return [varDecls, reads, readTracker];
    } else if (typeToRead.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      this.requireImport('warplib.memory', 'wm_read_256');
      varDecls.push(`read${readTracker.readOffset}`);
      reads.push(
        `    let (read${readTracker.readOffset}) = wm_read_256(${add(
          'loc',
          readTracker.locOffset,
        )})`,
      );
      readTracker.incrementReadOffset();
      readTracker.increamentLocOffset();
      readTracker.increamentLocOffset();
      return [varDecls, reads, readTracker];
    } else if (
      typeNode instanceof UserDefinedType &&
      typeNode.definition instanceof StructDefinition
    ) {
      const structName = this.getOrCreateStructRead(typeNode);
      varDecls.push(`read${readTracker.readOffset}`);
      reads.push(
        `    let(read${readTracker.readOffset}) = ${structName}(read${readTracker.readOffset - 1})`,
      );
      readTracker.incrementReadOffset();
      return [varDecls, reads, readTracker];
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
    const readTracker = new ReadTracker();
    // const readCounter = 0;
    // const locCounter = 0;
    const reads: string[] = [];
    const varDecls: string[] = [];
    //const readGenerator = counterGenerator();
    //const locGenerator = counterGenerator();
    structMembers.forEach((typeNodeMember) =>
      this.generateMemoryReadFunctionCall(typeNodeMember, varDecls, reads, readTracker),
    );

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

class ReadTracker {
  private _readOffset: number;
  private _locOffset: number;

  private readCounter: Generator;
  private locCounter: Generator;

  constructor() {
    this._readOffset = 0;
    this._locOffset = 0;
    this.readCounter = this._counterGenerator(1);
    this.locCounter = this._counterGenerator(1);
  }

  private *_counterGenerator(start = 0): Generator<number, number, unknown> {
    let count = start;
    while (true) {
      yield count;
      count++;
    }
  }

  public get readOffset() {
    return this._readOffset;
  }

  public get locOffset() {
    return this._locOffset;
  }

  incrementReadOffset() {
    this._readOffset = this.readCounter.next().value;
  }

  increamentLocOffset() {
    this._locOffset = this.locCounter.next().value;
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

import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  // FunctionTypeName,
  getNodeType,
  // PointerType,
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
    const elemType = dereferenceType(type.elementT);
    const cairoElemType = CairoType.fromSol(
      elemType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const cairoElemName = cairoElemType.toString();
    const funcName = `wm_to_cd_dyn_${cairoElemType.toString()}`; //wm_to_cd_StructDef
    const dynArrayReaderCall = this.generateDynamicReaderType(type.elementT, cairoElemType);

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc : felt) -> (val : dynarray_struct_${cairoElemName}):`,
        `    alloc_locals`,
        `    let (len_256) = wm_read_256(loc)`,
        `    let (len_felt) = narrow_safe(len_256)`,
        `    let (ptr : ${cairoElemName}*) = alloc()`,
        `    let (ptr) = ${dynArrayReaderCall}(len_felt, ptr, loc + 2)`,
        `    return (dynarray_struct_${cairoElemName}(len=len_felt, ptr=ptr))`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('warplib.memory', 'wm_read_256');
    this.requireImport('warplib.memory', 'wm_read_felt');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.maths.utils', 'narrow_safe');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');

    return funcName;
  }

  // private generateDynMemberLoader(cairoType: CairoType): string | undefined {
  //   if (cairoType instanceof CairoFelt) {
  //     return 'wm_read_felt';
  //   } else if (cairoType.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
  //     return 'wm_read_256';
  //   } else if (
  //     cairoType instanceof UserDefinedType &&
  //     cairoType.definition instanceof StructDefinition
  //   ) {
  //     return `wm_read_struct_${cairoType.toString()}`;
  //   }
  // }

  private generateDynamicReaderType(typeNode: TypeNode, memoryReadType: CairoType): string {
    const funcName = `wm_dynarry_reader_${memoryReadType.toString()}`;
    // ReadTracker to see how many reads and locations have occured.
    const readTracker = new ReadTracker();
    const reads: string[] = [];
    const varDecls: string[] = [];
    this.generateMemoryReadFunctionCall(typeNode, varDecls, reads, readTracker);

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
    const derefTypeNode = dereferenceType(typeNode);
    const typeToRead = CairoType.fromSol(
      derefTypeNode,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    // const readOffset = readCounter.next().value;
    // const locOffset = locCounter.next().value;
    //  Add a generator there that adds an int to the name. There should be a new one for each ne function.
    // This used to dereference the pointer until we realised the the members in of a struct do not contain pointers if they contain a reference type
    // if (typeNode instanceof PointerType) {
    //   //varDecls.push(`read${readCounter}`);

    //   reads.push(
    //     `    let (read${readTracker.readOffset}) = wm_read_felt(${add(
    //       'loc',
    //       readTracker.locOffset,
    //     )})`,
    //   );
    //   readTracker.incrementReadOffset();
    //   readTracker.increamentLocOffset();
    //   this.generateMemoryReadFunctionCall(dereferenceType(typeNode), varDecls, reads, readTracker);
    //   return [varDecls, reads, readTracker];
    // } else

    if (typeToRead instanceof CairoFelt) {
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
      derefTypeNode instanceof UserDefinedType &&
      derefTypeNode.definition instanceof StructDefinition
    ) {
      // This is dereferencing the pointer. This is needed since every reference type in the dynArray will
      // need to be dereferenced
      reads.push(
        `    let (read${readTracker.readOffset}) = wm_read_felt(${add(
          'loc',
          readTracker.locOffset,
        )})`,
      );
      readTracker.incrementReadOffset();
      readTracker.increamentLocOffset();

      const structName = this.getOrCreateStructRead(derefTypeNode);
      varDecls.push(`read${readTracker.readOffset}`);
      reads.push(
        `    let(read${readTracker.readOffset}) = ${structName}(read${readTracker.readOffset - 1})`,
      );
      readTracker.incrementReadOffset();
      return [varDecls, reads, readTracker];
    } else {
      // This is needed to make sure that if there another type in a struct that we are not going to reutrn it.
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
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc:felt) -> (res: ${cairoType}):`,
        reads.join('\n'),
        `return (${cairoType}(${varDecls.join(',')}))`,
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

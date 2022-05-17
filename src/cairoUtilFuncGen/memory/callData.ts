import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
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

/*
There are always 2 functions that are generated and an optional 3rd.
*/
export class MemoryToCallData extends StringIndexedFuncGen {
  gen(node: Expression, _: ASTNode): Expression {
    const typeNode = dereferenceType(getNodeType(node, this.ast.compilerVersion));
    assert(typeNode instanceof ArrayType);
    const name = this.genDynArrayReadFunctions(typeNode);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(typeNode, this.ast), DataLocation.Memory]],
      [['val', typeNameFromTypeNode(typeNode, this.ast), DataLocation.CallData]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      node,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [node], this.ast);
  }

  /* 
  Creates the ptr that the members of the wm dynArray are written to.
  The ptr and the len will then be returned in the form of a struct.
  */
  private genDynArrayReadFunctions(type: ArrayType): string {
    const key = type.pp();
    const elemType = dereferenceType(type.elementT);
    const cairoElemType = CairoType.fromSol(
      elemType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const cairoElemName = cairoElemType.toString();
    const funcName = `wm_to_cd_dyn_${cairoElemType.toString()}`;
    // This is creating the function that will be looped over that will populate the ptr that this function creates.
    const dynArrayReaderCall = this.genDynArrayLoader(type.elementT, cairoElemType);

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

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

  private genDynArrayLoader(typeNode: TypeNode, memoryReadType: CairoType): string {
    const funcName = `wm_dynarry_reader_${memoryReadType.toString()}`;
    const key = typeNode.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }
    // ReadTracker to see how many reads and locations have occured.
    const readTracker = new ReadTracker();
    const reads: string[] = [];
    const varDecls: string[] = [];
    this.genReadStatements(typeNode, varDecls, reads, readTracker);

    this.generatedFunctions.set(memoryReadType.toString(), {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(len: felt, ptr: ${memoryReadType.toString()}*, loc:felt) -> (res0 : ${memoryReadType.toString()}*):`,
        `    alloc_locals`,
        `    if len == 0:`,
        `       return (ptr)`,
        `    end`,
        ...reads,
        `    assert ptr[0] = read${readTracker.readOffset - 1}`,
        `    ${funcName}(len=len-1, ptr=ptr + ${
          memoryReadType instanceof CairoFelt ? 1 : memoryReadType.toString() + '.SIZE'
        }, loc=loc + ${this.isReferenceType(typeNode) ? 1 : memoryReadType.width})`,
        `    return (ptr)`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }

  isReferenceType(typeNode: TypeNode): boolean {
    if (
      typeNode instanceof ArrayType ||
      (typeNode instanceof UserDefinedType && typeNode.definition instanceof StructDefinition) ||
      typeNode instanceof PointerType
    ) {
      return true;
    }
    return false;
  }

  // This inspects the members of the elements and generates the read statements.
  genReadStatements(
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

    if (typeToRead instanceof CairoFelt) {
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
    assert(typeNode.definition instanceof StructDefinition);
    const structMembers = typeNode.definition.vMembers.map((member) =>
      getNodeType(member, this.ast.compilerVersion),
    );
    const readTracker = new ReadTracker();
    const reads: string[] = [];
    const varDecls: string[] = [];
    structMembers.forEach((typeNodeMember) =>
      this.genReadStatements(typeNodeMember, varDecls, reads, readTracker),
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

import {
  Expression,
  TypeName,
  ASTNode,
  FunctionCall,
  getNodeType,
  DataLocation,
  FunctionStateMutability,
} from 'solc-typed-ast';
import {
  CairoFelt,
  // CairoPointer,
  CairoType,
  CairoUint256,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { add, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

/*
  Produces functions that when given a start location in warp_memory, deserialise all necessary
  felts to produce a full value. For example, a function to read a Uint256 reads the given location
  and the next one, and combines them into a Uint256 struct
*/

export class MemoryReadGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression, type: TypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = getNodeType(memoryRef, this.ast.compilerVersion);
    const resultCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const name = this.getOrCreate(resultCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', cloneASTNode(type, this.ast), DataLocation.Memory]],
      [['val', cloneASTNode(type, this.ast), DataLocation.Default]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? memoryRef,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [memoryRef], this.ast);
  }

  private getOrCreate(typeToRead: CairoType): string {
    if (typeToRead instanceof CairoFelt) {
      this.requireImport('warplib.memory', 'wm_read_felt');
      return 'wm_read_felt';
    } else if (typeToRead.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      this.requireImport('warplib.memory', 'wm_read_256');
      return 'wm_read_256';
    }

    const key = typeToRead.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WM${this.generatedFunctions.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack, containsDynArray] = serialiseReads(
      typeToRead,
      readFelt,
      readFelt,
      createDynLenStatement,
      createDynPtrStatement,
    );
    // We can have another util function gen that generates the dynamic array reading.
    const dynArrayReader = containsDynArray ? readOutDynArray() : '';

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        dynArrayReader,
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc: felt) ->(val: ${resultCairoType}):`,
        `    alloc_locals`,
        ...reads.map((s) => `    ${s}`),
        `    return (${pack})`,
        'end',
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    return funcName;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = dict_read{dict_ptr=warp_memory}(${add('loc', offset)})`;
}

function createDynLenStatement(offset: number): string {
  return `let (len${offset - 1}) = narrow_safe(read${offset - 2}, read${offset - 1})`;
}
function createDynPtrStatement(offset: number): string {
  return [
    `let (ptr${offset - 1}) = alloc()`,
    `let (ptr${offset - 1}) = wm_reader_felt(len${offset - 1}, ptr${offset - 1}, loc})`,
  ].join('\n');
}

function readOutDynArray(): string[] {
  /*
  This is is needed since we do not know what the DynArray points to
  */
  return [
    `func wm_reader_felt{range_check_ptr, warp_memory : DictAccess*}(len, ptr, loc)`,
    `alloc_locals`,
    `if len == 0:`,
    `return ()`,
    `let(val) = dict_read{warp_memory}(loc)`,
    `assert ptr[0] = val`,
    `wm_reader_felt(len=len-1, ptr = ptr + 1, loc + 1)`,
    `return (ptr)`,
  ];
}

// Address this after we have felts working.
// function readOutDynArray(dynArray: CairoType): string[] {
//   /*
//   This is is needed since we do not know what the DynArray points to
//   */
//   return [
//     `func wm_reader{implicits}(len, ptr, loc)`,
//     `alloc_locals`,
//     `if len == 0:`,
//     `return ()`,
//     // These reads get generated and that works.
//     `let(a) = dict_read{warp_memory}(loc)`,
//     `let(b) = dict_read{warp_memory}(loc + offset)`,
//     // Because we can jump to what the pointer is pointing to and then pass that into the
//     // Serialize read. //And these functions can be generated dynamically
//     `assert ptr[0] = MyStruct(a=1, b=2)` // This is going to come from serialize reads
//     `wm_reader(len=len-1, ptr = ptr + ${ptr.name}.SIZE, loc)`,
//     `return (ptr)`,
//

// function AllocDynArray(offset: number, ptr: CairoPointer): string {
//   `func wm_allocator{implicits}(dyn_loc:felt, width: len):`,
//   `alloc_locals`,
//   `let ptr: ${ptr.to.string}= alloc()`,
//   ``,
//   ``,
//   `let (read${offset}) = dict_read{dict_ptr=warp_memory}(${add('loc')})`
//   return `let (read${offset}) = dict_read{dict_ptr=warp_memory}(${add('loc')})`
// }

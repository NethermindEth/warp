import {
  FunctionCall,
  DataLocation,
  ArrayType,
  Expression,
  generalizeType,
  FunctionStateMutability,
  TypeNode,
  UserDefinedType,
  StructDefinition,
  BytesType,
  StringType,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { NotSupportedYetError } from '../../utils/errors';
import { printTypeNode } from '../../utils/astPrinter';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import {
  getElementType,
  getSize,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { CairoFunctionDefinition } from '../../export';
import {
  DICT_WRITE,
  FELT_TO_UINT256,
  U128_FROM_FELT,
  WM_ALLOC,
  WM_NEW,
  WM_UNSAFE_WRITE,
} from '../../utils/importPaths';
import endent from 'endent';

export class CallDataToMemoryGen extends StringIndexedFuncGen {
  public gen(node: Expression): FunctionCall {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(type);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = type.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['calldata', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.Pure },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to memory not implemented yet`,
      );
    };

    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(type),
      (type) => this.createStaticArrayCopyFunction(type),
      (type, def) => this.createStructCopyFunction(type, def),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
    return funcInfo;
  }

  private createDynamicArrayCopyFunction(
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(type);
    const size = getSize(type);

    assert(size === undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(callDataType instanceof CairoDynArray);
    const memoryElementWidth = CairoType.fromSol(elementT, this.ast).width;

    let copyCode: string;
    let auxFunc: CairoFunctionDefinition;
    if (isReferenceType(elementT)) {
      const recursiveFunc = this.getOrCreateFuncDef(elementT);
      copyCode = endent`
        let calldata_elem = calldata[index];
        let memory_elem = ${recursiveFunc.name}(calldata_elem);
        warp_memory.unsafe_write(calldata_elem, memory_elem)
      `;
      auxFunc = recursiveFunc;
    } else if (memoryElementWidth === 2) {
      copyCode = endent`
        warp_memory.unsafe_write(mem_ptr, calldata[index].low)
        warp_memory.unsafe_write(mem_ptr + 1, calldata[index].high)
      `;
      auxFunc = this.requireImport(...WM_UNSAFE_WRITE);
    } else {
      copyCode = `warp_memory.unsafe_write(mem_start, calldata[index]);`;
      auxFunc = this.requireImport(...WM_UNSAFE_WRITE);
    }

    const funcName = `cd_to_memory_dynamic_array${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}_elem(calldata: ${callDataType}, mem_ptr: felt252, length: felt252) {
            if index == length {
                return ();
            }
            ${copyCode}
            ${funcName}_elem(calldata, mem_ptr + ${memoryElementWidth}, index + 1, length)
        }

        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(calldata : ${callDataType}) -> felt252 {
            let mem_start = warp_memory.new_dynamic_array(calldata.len, ${memoryElementWidth});
            ${funcName}_elem(calldata, mem_start + 1, calldata.len);
            mem_start
        }
      `,
      functionsCalled: [
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...WM_NEW),
        this.requireImport(...FELT_TO_UINT256),
        auxFunc,
      ],
    };
  }

  private createStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const memoryElementWidth = CairoType.fromSol(type.elementT, this.ast).width;
    const memoryOffsetMultiplier = memoryElementWidth === 1 ? '' : `* ${memoryElementWidth}`;

    const loc = (index: number) =>
      index === 0 ? `mem_start` : `mem_start  + ${index}${memoryOffsetMultiplier}`;

    let copyCode: (index: number) => string;
    let funcCalls: CairoFunctionDefinition[] = [];
    if (isReferenceType(type.elementT)) {
      const recursiveFunc = this.getOrCreateFuncDef(type.elementT);
      copyCode = (index) =>
        endent`
          let calldata_elem = calldata[${index}];
          let memory_elem = ${recursiveFunc.name}(calldata_elem);
          warp_memory.unsafe_write(${loc(index)}, memory_elem);
        `;
      funcCalls = [recursiveFunc];
    } else if (memoryElementWidth === 2) {
      copyCode = (index) =>
        endent`
            warp_memory.unsafe_write(${loc(index)}, calldata[${index}].low);
            warp_memory.unsafe_write(${loc(index)} + 1, calldata[${index}].high);
        `;
    } else {
      copyCode = (index) => `warp_memory.unsafe_write(${loc(index)}, calldata[${index}]);`;
    }

    const funcName = `cd_to_memory_static_array${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(calldata : ${callDataType}) -> felt252{
            let mem_start = warp_memory.alloc(${memoryType.width});
            ${mapRange(narrowBigIntSafe(type.size), (n) => copyCode(n)).join('\n')}
            mem_start
        }
      `,
      functionsCalled: [
        this.requireImport(...WM_ALLOC),
        this.requireImport(...U128_FROM_FELT),
        ...funcCalls,
      ],
    };
  }

  private createStructCopyFunction(
    type: UserDefinedType,
    structDef: StructDefinition,
  ): GeneratedFunctionInfo {
    const calldataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);

    const [copyCode, funcCalls] = structDef.vMembers.reduce(
      ([copyCode, funcCalls, offset], decl) => {
        const type = safeGetNodeType(decl, this.ast.inference);

        if (isReferenceType(type)) {
          const recursiveFunc = this.getOrCreateFuncDef(type);
          const code = [
            `let member_${decl.name} = ${recursiveFunc.name}(calldata.${decl.name});`,
            `warp_memory.unsafe_write(${add('mem_start', offset)}, member_${decl.name});`,
          ].join('\n');
          return [[...copyCode, code], [...funcCalls, recursiveFunc], offset + 1];
        }

        const memberWidth = CairoType.fromSol(type, this.ast).width;
        const code =
          memberWidth === 2
            ? [
                `warp_memory.unsafe_write(${add('mem_start', offset)}, calldata.${decl.name}.low);`,
                `warp_memory.unsafe_write(${add('mem_start', offset + 1)}, calldata.${
                  decl.name
                }.high);`,
              ].join('\n')
            : `warp_memory.unsafe_write(${add('mem_start', offset)}, calldata.${decl.name});`;
        return [[...copyCode, code], funcCalls, offset + memberWidth];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
    );

    const funcName = `cd_to_memory_struct_${structDef.name}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(calldata : ${calldataType}) -> felt252 {
            let mem_start = warp_memory.alloc(${memoryType.width});
            ${copyCode.join('\n')}
            mem_start
        }
      `,
      functionsCalled: [
        this.requireImport(...DICT_WRITE),
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...WM_ALLOC),
        ...funcCalls,
      ],
    };
  }
}

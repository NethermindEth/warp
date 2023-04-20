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
import { uint256 } from '../../warplib/utils';
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
        let cdElem = calldata[0];
        let (mElem) = ${recursiveFunc.name}(cdElem);
        dict_write{dict_ptr=warp_memory}(mem_start, mElem);
      `;
      auxFunc = recursiveFunc;
    } else if (memoryElementWidth === 2) {
      copyCode = endent`
        dict_write{dict_ptr=warp_memory}(mem_start, calldata[0].low);
        dict_write{dict_ptr=warp_memory}(mem_start+1, calldata[0].high);
      `;
      auxFunc = this.requireImport(...DICT_WRITE);
    } else {
      copyCode = `dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);`;
      auxFunc = this.requireImport(...DICT_WRITE);
    }

    const funcName = `cd_to_memory_dynamic_array${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory)]
        func ${funcName}_elem(calldata: ${callDataType.vPtr}, mem_start: felt, length: felt){
            alloc_locals;
            if (length == 0){
                return ();
            }
            ${copyCode}
            return ${funcName}_elem(calldata + ${
        callDataType.vPtr.to.width
      }, mem_start + ${memoryElementWidth}, length - 1);
        }
        #[implicit(warp_memory)]
        func ${funcName}(calldata : ${callDataType}) -> (mem_loc: felt){
            alloc_locals;
            let (len256) = felt_to_uint256(calldata.len);
            let (mem_start) = wm_new(len256, ${uint256(memoryElementWidth)});
            ${funcName}_elem(calldata.ptr, mem_start + 2, calldata.len);
            return (mem_start,);
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
          let cdElem = calldata[${index}];
          let (mElem) = ${recursiveFunc.name}(cdElem);
          dict_write{dict_ptr=warp_memory}(${loc(index)}, mElem);
        `;
      funcCalls = [recursiveFunc];
    } else if (memoryElementWidth === 2) {
      copyCode = (index) =>
        endent`
          dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}].low);
          dict_write{dict_ptr=warp_memory}(${loc(index)} + 1, calldata[${index}].high);
        `;
    } else {
      copyCode = (index) => `dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}]);`;
    }

    const funcName = `cd_to_memory_static_array${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory)]
        func ${funcName}(calldata : ${callDataType}) -> (mem_loc: felt){
            alloc_locals;
            let (mem_start) = wm_alloc(${uint256(memoryType.width)});
            ${mapRange(narrowBigIntSafe(type.size), (n) => copyCode(n)).join('\n')}
            return (mem_start,);
        }
      `,
      functionsCalled: [
        this.requireImport(...WM_ALLOC),
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...DICT_WRITE),
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
            `let (member_${decl.name}) = ${recursiveFunc.name}(calldata.${decl.name});`,
            `dict_write{dict_ptr=warp_memory}(${add('mem_start', offset)}, member_${decl.name});`,
          ].join('\n');
          return [[...copyCode, code], [...funcCalls, recursiveFunc], offset + 1];
        }

        const memberWidth = CairoType.fromSol(type, this.ast).width;
        const code =
          memberWidth === 2
            ? [
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', offset)}, calldata.${
                  decl.name
                }.low);`,
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', offset + 1)}, calldata.${
                  decl.name
                }.high);`,
              ].join('\n')
            : `dict_write{dict_ptr=warp_memory}(${add('mem_start', offset)}, calldata.${
                decl.name
              });`;
        return [[...copyCode, code], funcCalls, offset + memberWidth];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
    );

    const funcName = `cd_to_memory_struct_${structDef.name}`;
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory)]
        func ${funcName}(calldata : ${calldataType}) -> (mem_loc: felt){
            alloc_locals;
            let (mem_start) = wm_alloc(${uint256(memoryType.width)});
            ${copyCode.join('\n')}
            return (mem_start,
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

import {
  FunctionCall,
  getNodeType,
  DataLocation,
  ArrayType,
  Expression,
  ASTNode,
  generalizeType,
  FunctionStateMutability,
  TypeNode,
  UserDefinedType,
  StructDefinition,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { uint256 } from '../../warplib/utils';
import { NotSupportedYetError } from '../../utils/errors';
import { printTypeNode } from '../../utils/astPrinter';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';

export class CallDataToMemoryGen extends StringIndexedFuncGen {
  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [['calldata', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? node,
      FunctionStateMutability.Pure,
    );
    return createCallToFunction(functionStub, [node], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `cd_to_memory${this.generatedFunctions.size}`;
    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    let code: CairoFunction;
    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      code = this.createStructCopyFunction(funcName, type);
    } else if (type instanceof ArrayType) {
      if (type.size === undefined) {
        code = this.createDynamicArrayCopyFunction(funcName, type);
      } else {
        code = this.createStaticArrayCopyFunction(funcName, type);
      }
    } else {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to memory not implemented yet`,
      );
    }

    this.generatedFunctions.set(key, code);
    return code.name;
  }
  createDynamicArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    assert(type.size === undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(callDataType instanceof CairoDynArray);
    const isElementComplex =
      type.elementT instanceof ArrayType ||
      (type.elementT instanceof UserDefinedType &&
        type.elementT.definition instanceof StructDefinition);
    const memoryElementWidth = CairoType.fromSol(type.elementT, this.ast).width;

    let copyCode: string;

    if (isElementComplex) {
      const recursiveFunc = this.getOrCreate(type.elementT);
      copyCode = [
        `let cdElem = calldata[0]`,
        `let (mElem) = ${recursiveFunc}(cdElem)`,
        `dict_write{dict_ptr=warp_memory}(mem_start, mElem)`,
      ].join('\n');
    } else if (memoryElementWidth === 2) {
      copyCode = [
        `dict_write{dict_ptr=warp_memory}(mem_start, calldata[0].low)`,
        `dict_write{dict_ptr=warp_memory}(mem_start+1, calldata[0].high)`,
      ].join('\n');
    } else {
      copyCode = `dict_write{dict_ptr=warp_memory}(mem_start, calldata[0])`;
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(calldata: ${callDataType.vPtr}, mem_start: felt, length: felt):`,
        `    alloc_locals`,
        `    if length == 0:`,
        `        return ()`,
        `    end`,
        copyCode,
        `    return ${funcName}_elem(calldata + ${callDataType.vPtr.to}.SIZE, mem_start + ${memoryElementWidth}, length - 1)`,
        `end`,
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt):`,
        `    alloc_locals`,
        `    let (len256) = felt_to_uint256(calldata.len)`,
        `    let (mem_start) = wm_new(len256, ${uint256(memoryElementWidth)})`,
        `    ${funcName}_elem(calldata.ptr, mem_start + 2, calldata.len)`,
        `    return (mem_start)`,
        `end`,
      ].join('\n'),
    };
  }
  createStaticArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');

    assert(type.size !== undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const isElementComplex =
      type.elementT instanceof ArrayType ||
      (type.elementT instanceof UserDefinedType &&
        type.elementT.definition instanceof StructDefinition);
    const memoryElementWidth = CairoType.fromSol(type.elementT, this.ast).width;
    const memoryOffsetMultiplier = memoryElementWidth === 1 ? '' : `* ${memoryElementWidth}`;

    let copyCode: (index: number) => string;

    const loc = (index: number) =>
      index === 0 ? `mem_start` : `mem_start  + ${index}${memoryOffsetMultiplier}`;
    if (isElementComplex) {
      const recursiveFunc = this.getOrCreate(type.elementT);
      copyCode = (index) =>
        [
          `let cdElem = calldata[${index}]`,
          `let (mElem) = ${recursiveFunc}(cdElem)`,
          `dict_write{dict_ptr=warp_memory}(${loc(index)}, mElem)`,
        ].join('\n');
    } else if (memoryElementWidth === 2) {
      copyCode = (index) =>
        [
          `dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}].low)`,
          `dict_write{dict_ptr=warp_memory}(${loc(index)} + 1, calldata[${index}].high)`,
        ].join('\n');
    } else {
      copyCode = (index) => `dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}])`;
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt):`,
        `    alloc_locals`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)})`,
        ...mapRange(narrowBigIntSafe(type.size), (n) => copyCode(n)),
        `    return (mem_start)`,
        `end`,
      ].join('\n'),
    };
  }
  createStructCopyFunction(funcName: string, type: UserDefinedType): CairoFunction {
    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('warplib.memory', 'wm_alloc');
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);

    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);

    let memOffset = 0;
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt):`,
        `    alloc_locals`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)})`,
        ...structDef.vMembers.map((decl): string => {
          const memberType = getNodeType(decl, this.ast.compilerVersion);
          if (
            memberType instanceof ArrayType ||
            (memberType instanceof UserDefinedType &&
              memberType.definition instanceof StructDefinition)
          ) {
            const recursiveFunc = this.getOrCreate(memberType);
            const code = [
              `let (m${memOffset}) = ${recursiveFunc}(calldata.${decl.name})`,
              `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset)}, m${memOffset})`,
            ].join('\n');
            memOffset++;
            return code;
          } else {
            const memberWidth = CairoType.fromSol(memberType, this.ast).width;
            if (memberWidth === 2) {
              return [
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                  decl.name
                }.low)`,
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                  decl.name
                }.high)`,
              ].join('\n');
            } else {
              return `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                decl.name
              })`;
            }
          }
        }),
        `    return (mem_start)`,
        `end`,
      ].join('\n'),
    };
  }
}

const implicits =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

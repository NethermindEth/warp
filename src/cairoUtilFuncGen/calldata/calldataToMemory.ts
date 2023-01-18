import {
  FunctionCall,
  DataLocation,
  ArrayType,
  Expression,
  ASTNode,
  generalizeType,
  FunctionStateMutability,
  TypeNode,
  UserDefinedType,
  StructDefinition,
  BytesType,
  StringType,
  FunctionDefinition,
} from 'solc-typed-ast';
import assert from 'assert';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  add,
  CairoFunction,
  delegateBasedOnType,
  GeneratedFunctionInfo,
  StringIndexedFuncGen,
} from '../base';
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

export class CallDataToMemoryGen extends StringIndexedFuncGen {
  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const type = generalizeType(safeGetNodeType(node, this.ast.compilerVersion))[0];

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['calldata', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? node,
      { mutability: FunctionStateMutability.Pure },
    );
    return createCallToFunction(funcDef, [node], this.ast);
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcName = `cd_to_memory${this.generatedFunctions.size}`;
    // Set an empty entry so recursive function generation doesn't clash
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to memory not implemented yet`,
      );
    };

    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(funcName, type),
      (type) => this.createStaticArrayCopyFunction(funcName, type),
      (type) => this.createStructCopyFunction(funcName, type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );

    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }

  createDynamicArrayCopyFunction(
    funcName: string,
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_new'),
      this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
    );
    const elementT = getElementType(type);
    const size = getSize(type);

    assert(size === undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(callDataType instanceof CairoDynArray);
    const memoryElementWidth = CairoType.fromSol(elementT, this.ast).width;

    let copyCode: string;

    if (isReferenceType(elementT)) {
      const recursiveFuncInfo = this.getOrCreate(elementT);
      funcsCalled.push(...recursiveFuncInfo.functionsCalled);
      copyCode = [
        `let cdElem = calldata[0];`,
        `let (mElem) = ${recursiveFuncInfo.name}(cdElem);`,
        `dict_write{dict_ptr=warp_memory}(mem_start, mElem);`,
      ].join('\n');
    } else if (memoryElementWidth === 2) {
      copyCode = [
        `dict_write{dict_ptr=warp_memory}(mem_start, calldata[0].low);`,
        `dict_write{dict_ptr=warp_memory}(mem_start+1, calldata[0].high);`,
      ].join('\n');
    } else {
      copyCode = `dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);`;
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(calldata: ${callDataType.vPtr}, mem_start: felt, length: felt){`,
        `    alloc_locals;`,
        `    if (length == 0){`,
        `        return ();`,
        `    }`,
        copyCode,
        `    return ${funcName}_elem(calldata + ${callDataType.vPtr.to.width}, mem_start + ${memoryElementWidth}, length - 1);`,
        `}`,
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt){`,
        `    alloc_locals;`,
        `    let (len256) = felt_to_uint256(calldata.len);`,
        `    let (mem_start) = wm_new(len256, ${uint256(memoryElementWidth)});`,
        `    ${funcName}_elem(calldata.ptr, mem_start + 2, calldata.len);`,
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }
  createStaticArrayCopyFunction(funcName: string, type: ArrayType): GeneratedFunctionInfo {
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_alloc'),
    );

    assert(type.size !== undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const memoryElementWidth = CairoType.fromSol(type.elementT, this.ast).width;
    const memoryOffsetMultiplier = memoryElementWidth === 1 ? '' : `* ${memoryElementWidth}`;

    let copyCode: (index: number) => string;

    const loc = (index: number) =>
      index === 0 ? `mem_start` : `mem_start  + ${index}${memoryOffsetMultiplier}`;
    if (isReferenceType(type.elementT)) {
      const recursiveFuncInfo = this.getOrCreate(type.elementT);
      funcsCalled.push(...recursiveFuncInfo.functionsCalled);
      copyCode = (index) =>
        [
          `let cdElem = calldata[${index}];`,
          `let (mElem) = ${recursiveFuncInfo.name}(cdElem);`,
          `dict_write{dict_ptr=warp_memory}(${loc(index)}, mElem);`,
        ].join('\n');
    } else if (memoryElementWidth === 2) {
      copyCode = (index) =>
        [
          `dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}].low);`,
          `dict_write{dict_ptr=warp_memory}(${loc(index)} + 1, calldata[${index}].high);`,
        ].join('\n');
    } else {
      copyCode = (index) => `dict_write{dict_ptr=warp_memory}(${loc(index)}, calldata[${index}]);`;
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt){`,
        `    alloc_locals;`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)});`,
        ...mapRange(narrowBigIntSafe(type.size), (n) => copyCode(n)),
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }
  createStructCopyFunction(funcName: string, type: UserDefinedType): GeneratedFunctionInfo {
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_alloc'),
    );
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);

    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);

    let memOffset = 0;
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt){`,
        `    alloc_locals;`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)});`,
        ...structDef.vMembers.map((decl): string => {
          const memberType = safeGetNodeType(decl, this.ast.compilerVersion);
          if (isReferenceType(memberType)) {
            const recursiveFuncInfo = this.getOrCreate(memberType);
            funcsCalled.push(...recursiveFuncInfo.functionsCalled);
            const code = [
              `let (m${memOffset}) = ${recursiveFuncInfo.name}(calldata.${decl.name});`,
              `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset)}, m${memOffset});`,
            ].join('\n');
            memOffset++;
            return code;
          } else {
            const memberWidth = CairoType.fromSol(memberType, this.ast).width;
            if (memberWidth === 2) {
              return [
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                  decl.name
                }.low);`,
                `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                  decl.name
                }.high);`,
              ].join('\n');
            } else {
              return `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset++)}, calldata.${
                decl.name
              });`;
            }
          }
        }),
        `    return (mem_start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }
}

const implicits =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

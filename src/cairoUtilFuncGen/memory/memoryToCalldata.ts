import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  getElementType,
  getSize,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { ExternalDynArrayStructConstructor } from '../calldata/externalDynArray/externalDynArrayStructConstructor';
import { MemoryReadGen } from './memoryRead';

const IMPLICITS =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
export class MemoryToCallDataGen extends StringIndexedFuncGen {
  public constructor(
    private dynamicArrayStructGen: ExternalDynArrayStructConstructor,
    private memoryReadGen: MemoryReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  public gen(node: Expression): FunctionCall {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    const funcDef = this.getOrCreateFuncDef(type);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = type.pp();
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(type);

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      [['retData', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
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
        `Copying ${printTypeNode(type)} from memory to calldata not implemented yet`,
      );
    };
    const generalizedType = generalizeType(type)[0];

    return delegateBasedOnType<GeneratedFunctionInfo>(
      generalizedType,
      (generalizedType) => this.createDynamicArrayCopyFunction(generalizedType),
      (generalizedType) => this.createStaticArrayCopyFunction(generalizedType),
      (generalizedType) => this.createStructCopyFunction(generalizedType),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(type: TypeNode): GeneratedFunctionInfo {
    assert(type instanceof UserDefinedType && type.definition instanceof StructDefinition);
    const structDef = type.definition;
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const [code, funcCalls] = structDef.vMembers
      .map((decl) => safeGetNodeType(decl, this.ast.inference))
      .reduce(
        ([code, funcCalls, offset], type, index) => {
          const [copyCode, copyFuncCalls, newOffset] = this.generateElementCopyCode(
            type,
            offset,
            index,
          );
          return [[...code, ...copyCode], [...funcCalls, ...copyFuncCalls], newOffset];
        },
        [new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
      );

    const funcName = `wm_to_calldata${this.generatedFunctionsDef.size}_struct_${structDef.name}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(mem_loc : felt) -> (ret_data: ${outputType.toString()}){`,
        `    alloc_locals;`,
        ...code,
        `    return (${outputType.toString()}(${mapRange(
          structDef.vMembers.length,
          (n) => `member${n}`,
        )}),);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcCalls,
    };
  }

  // TODO: With big static arrays, this functions gets huge. Can that be fixed?!
  private createStaticArrayCopyFunction(type: ArrayType): GeneratedFunctionInfo {
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);
    const elementT = type.elementT;

    const memberFeltSize = CairoType.fromSol(elementT, this.ast).width;
    const [copyCode, funcCalls] = mapRange(length, (n): [string[], CairoFunctionDefinition[]] => {
      const [memberCopyCode, memberCalls] = this.generateElementCopyCode(
        elementT,
        n * memberFeltSize,
        n,
      );
      return [memberCopyCode, memberCalls];
    }).reduce(([copyCode, funcCalls], [memberCode, memberCalls]) => [
      [...copyCode, ...memberCode],
      [...funcCalls, ...memberCalls],
    ]);

    const funcName = `wm_to_calldata_static_array${this.generatedFunctionsDef.size}`;
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(mem_loc : felt) -> (ret_data: ${outputType.toString()}){`,
        `    alloc_locals;`,
        ...copyCode,
        `    return ((${mapRange(length, (n) => `member${n}`)}),);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcCalls,
    };
  }

  private createDynamicArrayCopyFunction(type: TypeNode): GeneratedFunctionInfo {
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(outputType instanceof CairoDynArray);

    assert(type instanceof ArrayType || type instanceof BytesType || type instanceof StringType);
    assert(getSize(type) === undefined);

    const elementT = getElementType(type);
    if (isDynamicArray(elementT)) {
      throw new NotSupportedYetError(
        `Copying dynamic arrays with element type ${printTypeNode(
          elementT,
        )} from memory to calldata is not supported yet`,
      );
    }

    const dynArrayReaderInfo = this.createDynArrayReader(elementT);
    const calldataDynArrayStruct = this.dynamicArrayStructGen.getOrCreateFuncDef(type);

    const funcName = `wm_to_calldata_dynamic_array${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        dynArrayReaderInfo.code,
        `func ${funcName}${IMPLICITS}(mem_loc: felt) -> (retData: ${outputType.toString()}){`,
        `    alloc_locals;`,
        `    let (len_256) = wm_read_256(mem_loc);`,
        `    let (ptr : ${outputType.vPtr.toString()}) = alloc();`,
        `    let (len_felt) = narrow_safe(len_256);`,
        `    ${dynArrayReaderInfo.name}(len_felt, ptr, mem_loc + 2);`,
        `    return (${calldataDynArrayStruct.name}(len=len_felt, ptr=ptr),);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport('starkware.cairo.common.alloc', 'alloc'),
        this.requireImport('warplib.maths.utils', 'narrow_safe'),
        this.requireImport('warplib.memory', 'wm_read_256'),
        calldataDynArrayStruct,
        ...dynArrayReaderInfo.functionsCalled,
      ],
    };
    return funcInfo;
  }

  private createDynArrayReader(elementT: TypeNode): GeneratedFunctionInfo {
    const funcName = `wm_to_calldata_dynamic_array_reader${this.generatedFunctionsDef.size}`;

    const cairoType = CairoType.fromSol(elementT, this.ast, TypeConversionContext.CallDataRef);
    const memWidth = CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;
    const ptrString = `${cairoType.toString()}`;

    const readFunc = this.memoryReadGen.getOrCreateFuncDef(elementT);
    let code: string[];
    let funcCalls: CairoFunctionDefinition[];
    if (isReferenceType(elementT)) {
      const allocSize = isDynamicArray(elementT)
        ? 2
        : CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;

      const auxFunc = this.getOrCreateFuncDef(elementT);
      code = [
        `let (mem_read0) = ${readFunc.name}(mem_loc, ${uint256(allocSize)});`,
        `let (mem_read1) = ${auxFunc.name}(mem_read0);`,
        `assert ptr[0] = mem_read1;`,
      ];
      funcCalls = [
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        auxFunc,
        readFunc,
      ];
    } else {
      code = [`let (mem_read0) = ${readFunc.name}(mem_loc);`, 'assert ptr[0] = mem_read0;'];
      funcCalls = [readFunc];
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(len: felt, ptr: ${ptrString}*, mem_loc: felt) -> (){`,
        `    alloc_locals;`,
        `    if (len == 0){`,
        `         return ();`,
        `    }`,
        ...code,
        `    ${funcName}(len=len - 1, ptr=ptr + ${cairoType.width}, mem_loc=mem_loc + ${memWidth});`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcCalls,
    };
  }

  private generateElementCopyCode(
    type: TypeNode,
    offset: number,
    index: number,
  ): [string[], CairoFunctionDefinition[], number] {
    const readFunc = this.memoryReadGen.getOrCreateFuncDef(type);
    if (isReferenceType(type)) {
      const memberGetterFunc = this.getOrCreateFuncDef(type);
      const allocSize = isDynamicArray(type)
        ? 2
        : CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).width;
      return [
        [
          `let (read_${index}) = ${readFunc.name}(${add('mem_loc', offset)}, ${uint256(
            allocSize,
          )});`,
          `let (member${index})= ${memberGetterFunc.name}(read_${index});`,
        ],
        [
          this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
          memberGetterFunc,
          readFunc,
        ],
        offset + 1,
      ];
    }

    const memberFeltSize = CairoType.fromSol(type, this.ast).width;
    return [
      [`let (member${index}) = ${readFunc.name}(${add('mem_loc', offset)});`],
      [readFunc],
      offset + memberFeltSize,
    ];
  }
}

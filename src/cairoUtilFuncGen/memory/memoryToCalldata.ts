import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionStateMutability,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoDynArray,
  CairoType,
  generateCallDataDynArrayStructName,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
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

export class MemoryToCallDataGen extends StringIndexedFuncGen {
  constructor(
    private dynamicArrayStructGen: ExternalDynArrayStructConstructor,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }
  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    if (isDynamicArray(type)) {
      this.dynamicArrayStructGen.gen(node, nodeInSourceUnit);
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      [['retData', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
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

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from memory to calldata not implemented yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(key, type),
      (type) => this.createStaticArrayCopyFunction(key, type),
      (type) => this.createStructCopyFunction(key, type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(key: string, type: TypeNode): GeneratedFunctionInfo {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    assert(type instanceof UserDefinedType);
    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);

    // Set an empty entry so recursive function generation doesn't clash
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(this.requireImport('starkware.cairo.common.dict', 'dict_read'));

    let offset = 0;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc : felt) -> (retData: ${outputType.toString()}){`,
        `    alloc_locals;`,
        ...structDef.vMembers.map((decl, index) => {
          const memberType = safeGetNodeType(decl, this.ast.inference);
          if (isReferenceType(memberType)) {
            funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_id'));
            const allocSize = isDynamicArray(memberType)
              ? 2
              : CairoType.fromSol(memberType, this.ast, TypeConversionContext.Ref).width;
            const memberGetterInfo = this.getOrCreate(memberType);
            funcsCalled.push(...memberGetterInfo.functionsCalled);
            return [
              `let (read_${index}) = wm_read_id(${add('mem_loc', offset++)}, ${uint256(
                allocSize,
              )});`,
              `let (member${index}) = ${memberGetterInfo.name}(read_${index});`,
            ].join('\n');
          } else {
            const memberCairoType = CairoType.fromSol(memberType, this.ast);
            if (memberCairoType.width === 1) {
              funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_felt'));
              const code = `let (member${index}) = wm_read_felt(${add('mem_loc', offset++)});`;
              return code;
            } else if (memberCairoType.width === 2) {
              funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_256'));
              const code = `let (member${index}) = wm_read_256(${add('mem_loc', offset)});`;
              offset += 2;
              return code;
            }
          }
        }),
        `    return (${outputType.toString()}(${mapRange(
          structDef.vMembers.length,
          (n) => `member${n}`,
        )}),);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }

  private createStaticArrayCopyFunction(key: string, type: ArrayType): GeneratedFunctionInfo {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);
    const elementT = type.elementT;

    // Set an empty entry so recursive function generation doesn't clash
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.dict', 'dict_read'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );

    let offset = 0;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc : felt) -> (retData: ${outputType.toString()}){`,
        `    alloc_locals;`,
        ...mapRange(length, (index) => {
          if (isReferenceType(elementT)) {
            funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_id'));
            const memberGetterInfo = this.getOrCreate(elementT);
            funcsCalled.push(...memberGetterInfo.functionsCalled);
            const allocSize = isDynamicArray(elementT)
              ? 2
              : CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;
            return [
              `let (read${index}) = wm_read_id(${add('mem_loc', offset++)}, ${uint256(
                allocSize,
              )});`,
              `let (member${index}) = ${memberGetterInfo.name}(read${index});`,
            ].join('\n');
          } else {
            const memberCairoType = CairoType.fromSol(elementT, this.ast);
            if (memberCairoType.width === 1) {
              funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_felt'));
              const code = `let (member${index}) = wm_read_felt(${add('mem_loc', offset++)});`;
              return code;
            } else if (memberCairoType.width === 2) {
              funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_256'));
              const code = `let (member${index}) = wm_read_256(${add('mem_loc', offset)});`;
              offset += 2;
              return code;
            }
          }
        }),
        `    return ((${mapRange(length, (n) => `member${n}`)}),);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }

  private createDynamicArrayCopyFunction(key: string, type: TypeNode): GeneratedFunctionInfo {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    // Set an empty entry so recursive function generation doesn't clash.
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

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

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.alloc', 'alloc'),
      this.requireImport('warplib.maths.utils', 'narrow_safe'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
      this.requireImport('warplib.memory', 'wm_read_256'),
    );

    const dynArrayReaderInfo = this.createDynArrayReader(elementT);
    funcsCalled.push(...dynArrayReaderInfo.functionsCalled);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc: felt) -> (retData: ${outputType.toString()}){`,
        `    alloc_locals;`,
        `    let (len_256) = wm_read_256(mem_loc);`,
        `    let (ptr : ${outputType.vPtr.toString()}) = alloc();`,
        `    let (len_felt) = narrow_safe(len_256);`,
        `    ${dynArrayReaderInfo.name}(len_felt, ptr, mem_loc + 2);`,
        `    return (${generateCallDataDynArrayStructName(
          elementT,
          this.ast,
        )}(len=len_felt, ptr=ptr),);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }

  private createDynArrayReader(elementT: TypeNode): GeneratedFunctionInfo {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const key = elementT.pp() + 'dynReader';
    // Set an empty entry so recursive function generation doesn't clash
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const cairoType = CairoType.fromSol(elementT, this.ast, TypeConversionContext.CallDataRef);
    const memWidth = CairoType.fromSol(elementT, this.ast).width;
    const ptrString = `${cairoType.toString()}`;

    const funcsCalled: FunctionDefinition[] = [];

    let code = [''];
    if (isReferenceType(elementT)) {
      const allocSize = isDynamicArray(elementT)
        ? 2
        : CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;
      const calledFuncInfo = this.getOrCreate(elementT);
      funcsCalled.push(
        ...calledFuncInfo.functionsCalled,
        this.requireImport('warplib.memory', 'wm_read_id'),
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      );
      code = [
        `let (mem_read0) = wm_read_id(mem_loc, ${uint256(allocSize)});`,
        `let (mem_read1) = ${calledFuncInfo.name}(mem_read0);`,
        `assert ptr[0] = mem_read1;`,
      ];
    } else if (cairoType.width === 1) {
      funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_felt'));
      code = ['let (mem_read0) = wm_read_felt(mem_loc);', 'assert ptr[0] = mem_read0;'];
    } else if (cairoType.width === 2) {
      funcsCalled.push(this.requireImport('warplib.memory', 'wm_read_256'));
      code = ['let (mem_read0) = wm_read_256(mem_loc);', 'assert ptr[0] = mem_read0;'];
    } else {
      throw new NotSupportedYetError(
        `Element type ${cairoType.toString()} not supported yet in m->c`,
      );
    }

    funcsCalled.push(this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'));
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(len: felt, ptr: ${ptrString}*, mem_loc: felt) -> (){`,
        `    alloc_locals;`,
        `    if (len == 0){`,
        `         return ();`,
        `    }`,
        ...code,
        `    ${funcName}(len=len - 1, ptr=ptr + ${cairoType.width}, mem_loc=mem_loc + ${memWidth});`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(funcName, funcInfo);

    return funcInfo;
  }
}

import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  SourceUnit,
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
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, StringIndexedFuncGen } from '../base';
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
    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];

    if (type instanceof ArrayType && type.size === undefined) {
      this.dynamicArrayStructGen.gen(node, nodeInSourceUnit);
    }

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [['mem_loc', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      [['retData', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
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

    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      return this.createStructCopyFunction(key, type);
    } else if (type instanceof ArrayType) {
      if (type.size === undefined) {
        return this.createDynamicArrayCopyFunction(key, type);
      } else {
        return this.createStaticArrayCopyFunction(key, type);
      }
    } else {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from memory to calldata not implemented yet`,
      );
    }
  }

  private createStructCopyFunction(key: string, type: TypeNode): string {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    assert(type instanceof UserDefinedType);
    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    let offset = 0;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc : felt) -> (retData: ${outputType.toString()}):`,
        `    alloc_locals`,
        ...structDef.vMembers.map((decl, index) => {
          const memberType = getNodeType(decl, this.ast.compilerVersion);
          const allocSize =
            memberType instanceof ArrayType && memberType === undefined
              ? 2
              : CairoType.fromSol(memberType, this.ast, TypeConversionContext.Ref).width;
          if (isComplexType(memberType)) {
            const memberGetter = this.getOrCreate(memberType);
            return [
              `let (read_${index}) = wm_read_id(${add('mem_loc', offset++)}, ${uint256(
                allocSize,
              )})`,
              `let (member${index}) = ${memberGetter}(read_${index})`,
            ].join('\n');
          } else {
            const memberCairoType = CairoType.fromSol(memberType, this.ast);
            if (memberCairoType.width === 1) {
              const code = `let (member${index}) = wm_read_felt(${add('mem_loc', offset++)})`;
              this.requireImport('warplib.memory', 'wm_read_felt');
              return code;
            } else if (memberCairoType.width === 2) {
              const code = `let (member${index}) = wm_read_256(${add('mem_loc', offset)})`;
              this.requireImport('warplib.memory', 'wm_read_256');
              offset += 2;
              return code;
            }
          }
        }),
        `    return (${structDef.name}(${mapRange(
          structDef.vMembers.length,
          (n) => `member${n}`,
        )}))`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');

    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, type: TypeNode): string {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';
    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    assert(type instanceof ArrayType);
    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);
    const elementT = type.elementT;

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    let offset = 0;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc : felt) -> (retData: ${outputType.toString()}):`,
        `    alloc_locals`,
        ...mapRange(length, (index) => {
          if (isComplexType(elementT)) {
            this.requireImport('warplib.memory', 'wm_read_id');
            const memberGetter = this.getOrCreate(elementT);
            const allocSize =
              elementT instanceof ArrayType && elementT.size === undefined
                ? 2
                : CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;
            return [
              `let (read${index}) = wm_read_id(${add('mem_loc', offset++)}, ${uint256(allocSize)})`,
              `let (member${index}) = ${memberGetter}(read${index})`,
            ].join('\n');
          } else {
            const memberCairoType = CairoType.fromSol(elementT, this.ast);
            if (memberCairoType.width === 1) {
              const code = `let (member${index}) = wm_read_felt(${add('mem_loc', offset++)})`;
              this.requireImport('warplib.memory', 'wm_read_felt');
              return code;
            } else if (memberCairoType.width === 2) {
              const code = `let (member${index}) = wm_read_256(${add('mem_loc', offset)})`;
              this.requireImport('warplib.memory', 'wm_read_256');
              offset += 2;
              return code;
            }
          }
        }),
        `    return ((${mapRange(length, (n) => `member${n}`)}))`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return funcName;
  }

  private createDynamicArrayCopyFunction(key: string, type: TypeNode): string {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    // Set an empty entry so recursive function generation doesn't clash.
    this.generatedFunctions.set(key, { name: funcName, code: '' });
    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const outputType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(outputType instanceof CairoDynArray);

    assert(type instanceof ArrayType);
    assert(type.size === undefined);

    const elementT = type.elementT;
    if (elementT instanceof ArrayType && elementT.size === undefined) {
      throw new NotSupportedYetError(
        `Copying dynamic arrays with element type ${printTypeNode(
          elementT,
        )} from memory to calldata is not supported yet`,
      );
    }

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(mem_loc: felt) -> (retData: ${outputType.toString()}):`,
        `    alloc_locals`,
        `    let (len_256) = wm_read_256(mem_loc)`,
        `    let (ptr : ${outputType.vPtr.toString()}) = alloc()`,
        `    let (len_felt) = narrow_safe(len_256)`,
        `    ${this.createDynArrayReader(elementT)}(len_felt, ptr, mem_loc + 2)`,
        `    return (${generateCallDataDynArrayStructName(
          elementT,
          this.ast,
        )}(len=len_felt, ptr=ptr))`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('warplib.maths.utils', 'narrow_safe');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('warplib.memory', 'wm_read_256');
    return funcName;
  }

  private createDynArrayReader(elementT: TypeNode): string {
    const funcName = `wm_to_calldata${this.generatedFunctions.size}`;
    const key = elementT.pp() + 'dynReader';
    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const implicits =
      '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

    const cairoType = CairoType.fromSol(elementT, this.ast, TypeConversionContext.CallDataRef);
    const memWidth = CairoType.fromSol(elementT, this.ast).width;
    const ptrString = `${cairoType.toString()}`;

    let code = [''];
    if (isComplexType(elementT)) {
      const allocSize =
        elementT instanceof ArrayType && elementT.size === undefined
          ? 2
          : CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;
      code = [
        `let (mem_read0) = wm_read_id(mem_loc, ${uint256(allocSize)})`,
        `let (mem_read1) = ${this.getOrCreate(elementT)}(mem_read0)`,
        `assert ptr[0] = mem_read1`,
      ];
      this.requireImport('warplib.memory', 'wm_read_id');
      this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    } else if (cairoType.width === 1) {
      code = ['let (mem_read0) = wm_read_felt(mem_loc)', 'assert ptr[0] = mem_read0'];
      this.requireImport('warplib.memory', 'wm_read_felt');
    } else if (cairoType.width === 2) {
      code = ['let (mem_read0) = wm_read_256(mem_loc)', 'assert ptr[0] = mem_read0'];
      this.requireImport('warplib.memory', 'wm_read_256');
    } else {
      throw new NotSupportedYetError(
        `Element type ${cairoType.toString()} not supported yet in m->c`,
      );
    }

    this.generatedFunctions.set(funcName, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(len: felt, ptr: ${ptrString}*, mem_loc: felt) -> ():`,
        `    alloc_locals`,
        `    if len == 0:`,
        `         return ()`,
        `    end`,
        ...code,
        `    ${funcName}(len=len - 1, ptr=ptr + ${cairoType.width}, mem_loc=mem_loc + ${memWidth})`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');

    return funcName;
  }
}

function isComplexType(type: TypeNode) {
  return (
    type instanceof ArrayType ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition)
  );
}

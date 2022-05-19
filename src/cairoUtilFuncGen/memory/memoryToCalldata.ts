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
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';

export class MemoryToCallDataGen extends StringIndexedFuncGen {
  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];

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
        // return this.createDynamicArrayCopyFunction(key, type);
        throw new NotSupportedYetError(
          `Copying ${printTypeNode(type)} from memory to calldata not implemented yet`,
        );
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
          if (
            (memberType instanceof UserDefinedType &&
              memberType.definition instanceof StructDefinition) ||
            memberType instanceof ArrayType
          ) {
            const memberGetter = this.getOrCreate(memberType);
            return `let (member${index}) = ${memberGetter}(${add('mem_loc', offset++)})`;
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
          if (
            (elementT instanceof UserDefinedType &&
              elementT.definition instanceof StructDefinition) ||
            elementT instanceof ArrayType
          ) {
            const memberGetter = this.getOrCreate(elementT);
            return `let (member${index}) = ${memberGetter}(${add('mem_loc', offset++)})`;
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

    return funcName;
  }
}

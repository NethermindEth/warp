import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  getNodeType,
  DataLocation,
  Identifier,
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
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { uint256 } from '../../warplib/utils';
import { createIdentifier } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { NotSupportedYetError } from '../../utils/errors';
import { printTypeNode } from '../../utils/astPrinter';
import { typeNameFromTypeNode } from '../../utils/utils';

const INDENT = ' '.repeat(4);

export class DynArrayLoader extends StringIndexedFuncGen {
  gen(
    node: FunctionDefinition,
    varDecl: VariableDeclaration,
    structDef: CairoFunctionDefinition,
  ): FunctionCall {
    assert(varDecl.vType !== undefined);
    const type = getNodeType(varDecl, this.ast.compilerVersion);
    if (type instanceof ArrayType && type.size === undefined) {
      const functionInputs: Identifier[] = [createIdentifier(varDecl, this.ast)];
      const name = this.getOrCreate(varDecl, structDef);
      const functionStub = createCairoFunctionStub(
        name,
        [['dynarray', cloneASTNode(varDecl.vType, this.ast), DataLocation.CallData]],
        [['dynarray_loc', cloneASTNode(varDecl.vType, this.ast), DataLocation.Memory]],
        ['syscall_ptr', 'range_check_ptr', 'warp_memory'],
        this.ast,
        node,
      );
      return createCallToFunction(functionStub, [...functionInputs], this.ast);
    } else {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(
          getNodeType(varDecl, this.ast.compilerVersion),
        )} from calldata to memory not implemented with this
        UtilGen yet.`,
      );
    }
  }

  private getOrCreate(varDecl: VariableDeclaration, structDef: CairoFunctionDefinition): string {
    const type = getNodeType(varDecl, this.ast.compilerVersion);

    assert(type instanceof ArrayType && type.size === undefined);

    const elementCairoType = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );

    const cairoElm = elementCairoType.toString();

    const allocFuncName = `wm_dynarry_alloc_${cairoElm}`;
    const existing = this.generatedFunctions.get(allocFuncName);
    if (existing != undefined) {
      return existing.name;
    }

    const writerFuncName = `wm_dynarray_write_${cairoElm}`;

    this.generatedFunctions.set(allocFuncName, {
      name: allocFuncName,
      code: [
        `func ${writerFuncName}{warp_memory : DictAccess*}(`,
        `${INDENT}dynarray_loc : felt, array_len : felt, pointer: ${elementCairoType.toString()}*, width : felt):`,
        `${INDENT}if array_len == 0:`,
        `${INDENT.repeat(2)}return()`,
        `${INDENT}end`,
        `${INDENT}wm_write_${cairoElm === 'Uint256' ? '256' : cairoElm}(dynarray_loc, pointer[0])`,
        `${INDENT}return ${writerFuncName}(dynarray_loc=dynarray_loc + width,`,
        `${INDENT}array_len=array_len-1,`,
        `${INDENT}pointer=&pointer[1],`,
        `${INDENT}width=width)`,
        `${INDENT}`,
        `end`,

        `func ${allocFuncName}{`,
        `${INDENT}syscall_ptr: felt*, range_check_ptr : felt, warp_memory : DictAccess*}(`,
        `${INDENT}dyn_array_struct : ${structDef.name}) -> (dynarry_loc : felt):`,
        `${INDENT}alloc_locals`,
        `${INDENT}let (array_len_uint256) = warp_uint256(dyn_array_struct.len)`,
        `${INDENT}let (dynarray_loc) = wm_new(array_len_uint256, ${uint256(
          BigInt(elementCairoType.width),
        )})`,
        `${INDENT}${writerFuncName}(dynarray_loc+2, dyn_array_struct.len, dyn_array_struct.ptr, ${elementCairoType.width})`,
        `${INDENT}return (dynarray_loc)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.memory', cairoElm === 'felt' ? 'wm_write_felt' : 'wm_write_256');
    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');

    return allocFuncName;
  }
}

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
        `Copying ${printTypeNode(type)} from memory to calldata not implemented yet`,
      );
    }

    this.generatedFunctions.set(key, code);
    return code.name;
  }
  createDynamicArrayCopyFunction(_funcName: string, _type: ArrayType): CairoFunction {
    throw new Error('Method not implemented.');
  }
  createStaticArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    assert(type.size !== undefined);
    const callDataType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const memoryType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
    const isElementComplex =
      type.elementT instanceof ArrayType ||
      (type.elementT instanceof UserDefinedType &&
        type.elementT.definition instanceof StructDefinition);
    const memoryElementWidth = CairoType.fromSol(type.elementT, this.ast).width;
    const memoryOffsetMultiplier = memoryElementWidth === 1 ? '' : `* ${memoryElementWidth}`;

    let copyCode: string;

    if (isElementComplex) {
      const recursiveFunc = this.getOrCreate(type.elementT);
      copyCode = [
        `let cdElem = calldata[index]`,
        `let (mElem) = ${recursiveFunc}(cdElem)`,
        `dict_write{dict_ptr=warp_memory}(mem_loc, mElem)`,
      ].join('\n');
    } else if (memoryElementWidth === 2) {
      copyCode = [
        `dict_write{dict_ptr=warp_memory}(mem_loc, calldata[index].low)`,
        `dict_write{dict_ptr=warp_memory}(mem_loc+1, calldata[index].high)`,
      ].join('\n');
    } else {
      copyCode = `dict_write{dict_ptr=warp_memory}(mem_loc, calldata[index])`;
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(calldata: ${callDataType}, mem_start: felt, length: felt):`,
        `    alloc_locals`,
        `    if length == 0:`,
        `        return ()`,
        `    end`,
        `    let index = length - 1`,
        `    let mem_loc = mem_start + index${memoryOffsetMultiplier}`,
        copyCode,
        `    return ${funcName}_elem(calldata, index)`,
        `end`,
        `func ${funcName}${implicits}(calldata : ${callDataType}) -> (mem_loc: felt):`,
        `    alloc_locals`,
        `    let (mem_start) = wm_alloc(${uint256(memoryType.width)})`,
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
              `dict_write{dict_ptr=warp_memory}(${add('mem_start', memOffset)}m${memOffset})`,
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

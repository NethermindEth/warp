import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  ArrayTypeName,
  typeNameToTypeNode,
  DataLocation,
  Identifier,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionStubbing';

import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from './base';
import { uint256 } from '../warplib/utils';
import { createIdentifier } from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayAllocator extends StringIndexedFuncGen {
  gen(
    node: FunctionDefinition,
    originalVarDecl: VariableDeclaration,
    arrayLen: VariableDeclaration,
    arrayPointer: VariableDeclaration,
  ): FunctionCall {
    assert(arrayLen.vType !== undefined && arrayPointer.vType !== undefined);
    assert(originalVarDecl.vType !== undefined);
    const functionInputs: Identifier[] = [
      createIdentifier(arrayLen, this.ast),
      createIdentifier(arrayPointer, this.ast, DataLocation.CallData),
    ];
    const name = this.getOrCreate(arrayPointer);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['array_len', cloneASTNode(arrayLen.vType, this.ast)],
        ['array_pointer', cloneASTNode(arrayPointer.vType, this.ast), DataLocation.CallData],
      ],
      [['dynarray_loc', cloneASTNode(originalVarDecl.vType, this.ast), DataLocation.Memory]],
      ['syscall_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );
    return createCallToFunction(functionStub, [...functionInputs], this.ast);
  }

  private getOrCreate(varDecl: VariableDeclaration): string {
    assert(varDecl.vType instanceof ArrayTypeName);
    const key = varDecl.name;
    const existing = this.generatedFunctions.get(key);
    if (existing != undefined) {
      return existing.name;
    }
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(varDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const name = `wm_dynarry_write_${elementCairoType.toString()}`;

    this.generatedFunctions.set(name, {
      name: name,
      code: [
        `func wm_write_values{warp_memory : DictAccess*}(dynarray_loc : felt, array_len : felt, pointer: felt*, width : felt):`,
        `${INDENT}if array_len == 0:`,
        `${INDENT.repeat(2)}return()`,
        `${INDENT}end`,
        `${INDENT}wm_write_felt(dynarray_loc, pointer[0])`,
        `${INDENT}return wm_write_values(dynarray_loc = dynarray_loc + width, array_len = array_len-1, pointer = &pointer[1], width = width)`,
        `${INDENT}`,
        `end`,

        `func ${name}{syscall_ptr: felt*, range_check_ptr : felt, warp_memory : DictAccess*}(array_len : felt, array_pointer : felt*) -> (dynarry_loc : felt):`,
        `${INDENT}alloc_locals`,
        `${INDENT}let (array_len_uint256) = warp_uint256(array_len)`,
        `${INDENT}let (dynarray_loc) = wm_new(array_len_uint256, ${uint256(
          BigInt(elementCairoType.width),
        )})`,
        `${INDENT}wm_write_values(dynarray_loc+2, array_len, array_pointer, ${elementCairoType.width})`,
        `${INDENT}return (dynarray_loc)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.memory', 'wm_write_felt');
    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');
    return name;
  }
}

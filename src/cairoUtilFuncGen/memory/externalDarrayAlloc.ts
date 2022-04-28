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
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';

import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../base';
import { uint256 } from '../../warplib/utils';
import { createIdentifier } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';

const INDENT = ' '.repeat(4);

export class ExternalDarrayAllocator extends StringIndexedFuncGen {
  gen(
    node: FunctionDefinition,
    originalVarDecl: VariableDeclaration,
    //arrayLen: VariableDeclaration,
    //arrayPointer: VariableDeclaration,
  ): FunctionCall {
    //assert(arrayLen.vType !== undefined && arrayPointer.vType !== undefined);
    assert(originalVarDecl.vType !== undefined);
    const functionInputs: Identifier[] = [
      createIdentifier(originalVarDecl, this.ast),
      //createIdentifier(arrayPointer, this.ast, DataLocation.CallData),
    ];
    const name = this.getOrCreate(originalVarDecl);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['darray', cloneASTNode(originalVarDecl.vType, this.ast), DataLocation.Memory],
        //['array_pointer', cloneASTNode(arrayPointer.vType, this.ast), DataLocation.CallData],
      ],
      [['dynarray_loc', cloneASTNode(originalVarDecl.vType, this.ast), DataLocation.Memory]],
      ['syscall_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      node,
      true,
    );
    return createCallToFunction(functionStub, [...functionInputs], this.ast);
  }

  private getOrCreate(varDecl: VariableDeclaration): string {
    assert(varDecl.vType instanceof ArrayTypeName);
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(varDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();
    const existing = this.generatedFunctions.get(key);
    if (existing != undefined) {
      return existing.name;
    }

    const name = `wm_dynarry_alloc_${key}`;

    this.generatedFunctions.set(key, {
      name: name,
      code: [
        `func ${name}{`,
        `${INDENT}syscall_ptr: felt*, range_check_ptr : felt, warp_memory : DictAccess*}(`,
        `${INDENT}array_len : felt, array_pointer : ${elementCairoType.toString()}*) -> (dynarry_loc : felt):`,
        `${INDENT}alloc_locals`,
        `${INDENT}let (array_len_uint256) = warp_uint256(array_len)`,
        `${INDENT}let (dynarray_loc) = wm_new(array_len_uint256, ${uint256(
          BigInt(elementCairoType.width),
        )})`,
        `${INDENT}wm_darray_write_${key}(dynarray_loc+2, array_len, array_pointer, ${elementCairoType.width})`,
        `${INDENT}return (dynarray_loc)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');
    return name;
  }
}

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

const INDENT = ' '.repeat(4);

export class ExternalDynArrayAllocator extends StringIndexedFuncGen {
  gen(
    node: FunctionDefinition,
    arrayLen: VariableDeclaration,
    arrayPointer: VariableDeclaration,
  ): FunctionCall {
    assert(arrayLen.vType !== undefined && arrayPointer.vType !== undefined);

    const functionInputs: Identifier[] = [
      createIdentifier(arrayLen, this.ast),
      createIdentifier(arrayPointer, this.ast, DataLocation.CallData),
    ];
    const name = this.getOrCreate(arrayPointer);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['array_len', arrayLen.vType],
        ['array_pointer', arrayPointer.vType, DataLocation.CallData],
      ],
      [],
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
    const name = `dynarray_write_${varDecl.name}`;

    this.generatedFunctions.set(name, {
      name: name,
      code: [
        `func wm_write_values{warp_memory : DictAccess*}(dynarry_loc : felt, array_len : felt, pointer: felt*) -> ():`,
        `${INDENT}if array_len == 0:`,
        `${INDENT.repeat(2)}return()`,
        `${INDENT}end`,
        `${INDENT}wm_write_felt(loc, pointer[0])`,
        `${INDENT}wm_write_list_values(dynarray_loc+pointer.SIZE, array_len-1, pointer-pointer.SIZE)`,
        `${INDENT}return()`,
        `end`,

        `func ${name}{syscall_ptr: felt*, range_check_ptr : felt, warp_memory : DictAccess*}(array_len : felt, array_pointer : felt*) -> (dynarry_loc : felt*):`,
        // you can really just use wm_new here.
        `${INDENT}alloc_locals`,
        // We can have the inputs already be uint256 since you can have struct constructors in function calls
        `${INDENT}let (array_len_uint256) = warp_uint256(array_len)`,
        `${INDENT}let (dynarray_loc) = wm_new(array_len_uint256, ${uint256(
          BigInt(elementCairoType.width),
        )})`,
        `${INDENT}wm_write_values(dynarray_loc, array_len, pointer)`,
        `${INDENT}return (dynarray_loc)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'wm_new');
    return name;
  }
}
/*
func wm_write_values(dynarry_loc, array_len, pointer) -> ():
    if array_len == 0:
        return()
    end

    wm_write(loc, pointer[0])
    wm_write_values(dynarray_loc+pointer.SIZE, array_len-1, pointer-pointer.SIZE)

    return()
end
*/
// export class ExternalDynArrayLoader extends StringIndexedFuncGen {
//   gen(varDecl: VariableDeclaration, functionInput: Expression): FunctionCall {
//     // assert(enumVarDec.vType instanceof UserDefinedTypeName);
//     // const enumType = cloneASTNode(enumVarDec.vType, this.ast);
//     // const enumDef = enumType.vReferencedDeclaration;

//     // assert(enumDef instanceof EnumDefinition);
//     const name = this.getOrCreate(varDecl);

//     const functionStub = createCairoFunctionStub(
//       name,
//       [['', enumType]],
//       [],
//       ['syscall_ptr', 'range_check_ptr'],
//       this.ast,
//       enumVarDec,
//     );
//     return createCallToFunction(functionStub, [functionInput], this.ast);
//   }

//   private getOrCreate(varDecl: VariableDeclaration): string {
//     const key = enumDef.name;
//     const existing = this.generatedFunctions.get(key);
//     if (existing != undefined) {
//       return existing.name;
//     }

//     const name = `dynarray_write_${enumDef.name}`;

//     this.generatedFunctions.set(name, {
//       name: name,
//       code: [
//         `func ${name}{syscall_ptr: felt*, range_check_ptr : felt}(array_len : felt, pointer: felt*):`,
//         // you can really just use wm_new here.
//         `${INDENT}alloc locals`,
//         `let (uint256_len_array) = Uint256(array_len)`;
//         `let (object_length) = //Find out how the object length is calculated`
//         `${INDENT}wm_new(uint256_len_array, object_length)`
//         `${INDENT}let loc = wm_allocn == 0:`,
//         `${INDENT.repeat(2)}return ()`,
//         `${INDENT}return ()`,
//         `end`,
//       ].join('\n'),
//     });
//     this.requireImport('warplib.memory', 'wm_new');
//     return name;
//   }

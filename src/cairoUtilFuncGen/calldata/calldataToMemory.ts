import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  getNodeType,
  DataLocation,
  Identifier,
  ArrayType,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../base';
import { uint256 } from '../../warplib/utils';
import { createIdentifier } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { NotSupportedYetError } from '../../utils/errors';
import { printTypeNode } from '../../utils/astPrinter';

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
    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.memory', cairoElm === 'felt' ? 'wm_write_felt' : 'wm_write_256');
    // TODO import uint256 struct when needed

    return allocFuncName;
  }
}

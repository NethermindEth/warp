import { VariableDeclaration, ArrayTypeName, typeNameToTypeNode } from 'solc-typed-ast';
import assert from 'assert';

import { CairoType, TypeConversionContext } from '../../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../../base';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayWriter extends StringIndexedFuncGen {
  gen(arrayPointer: VariableDeclaration): void {
    this.getOrCreate(arrayPointer);
  }

  private getOrCreate(varDecl: VariableDeclaration): void {
    assert(varDecl.vType instanceof ArrayTypeName);
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(varDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();
    const existing = this.generatedFunctions.get(key);
    if (existing != undefined) {
      return;
    }
    const name = `wm_dynarray_write_${key}`;
    this.generatedFunctions.set(key, {
      name: name,
      code: [
        `func ${name}{warp_memory : DictAccess*}(`,
        `${INDENT}dynarray_loc : felt, array_len : felt, pointer: ${elementCairoType.toString()}*, width : felt):`,
        `${INDENT}if array_len == 0:`,
        `${INDENT.repeat(2)}return()`,
        `${INDENT}end`,
        `${INDENT}wm_write_${key === 'Uint256' ? '256' : key}(dynarray_loc, pointer[0])`,
        `${INDENT}return ${name}(dynarray_loc=dynarray_loc + width,`,
        `${INDENT}array_len=array_len-1,`,
        `${INDENT}pointer=&pointer[1],`,
        `${INDENT}width=width)`,
        `${INDENT}`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');
    this.createWriterFunctions(key);
  }

  createWriterFunctions(writeObject: string): void {
    if (writeObject === 'felt') {
      this.requireImport('warplib.memory', 'wm_write_felt');
    } else {
      this.requireImport('warplib.memory', 'wm_write_256');
    }
  }
}

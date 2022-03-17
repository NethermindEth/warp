import { CairoUtilFuncGenBase } from './base';
import {
  Expression,
  VariableDeclaration,
  FunctionCall,
  IntType,
  ElementaryTypeName,
} from 'solc-typed-ast';
import assert = require('assert');
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { typeNameFromTypeNode } from '../utils/utils';

export class BoolBoundCheckGen extends CairoUtilFuncGenBase {
  //Enum -> Assert Code
  private generatedBoolCheck = false;

  getGeneratedCode(): string {
    return '';
  }

  gen(enumVarDec: VariableDeclaration, functionInput: Expression): FunctionCall {
    assert(enumVarDec.vType instanceof ElementaryTypeName);

    const name = this.getOrCreate('warp');
    const intType = new IntType(8, false);
    const functionStub = createCairoFunctionStub(
      name,
      [['boolValue', typeNameFromTypeNode(intType, this.ast)]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      this.ast,
      enumVarDec,
    );
    return createCallToStub(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(name: string): string {
    if (this.generatedBoolCheck === true) {
      return name;
    } else {
      this.requireImport(
        'warplib.maths.external_input_check_bool',
        'warp_external_input_check_bool',
      );
      return name;
    }
  }
}

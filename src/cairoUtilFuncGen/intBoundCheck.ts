import { CairoUtilFuncGenBase } from './base';
import { CairoFunction } from './base';
import { VariableDeclaration, FunctionCall, Identifier } from 'solc-typed-ast';
import assert = require('assert');
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';

export class IntBoundCheckGen extends CairoUtilFuncGenBase {
  private generatedBoolCheck: Map<string, CairoFunction> = new Map();

  getGeneratedCode(): string {
    return '';
  }

  gen(parameter: VariableDeclaration): FunctionCall {
    const functionInput = new Identifier(
      this.ast.reserveId(),
      '',
      'Identifier',
      parameter.typeString,
      parameter.name,
      parameter.id,
    );
    const int_width = parameter.typeString.replace('u', '');
    const name = this.getOrCreate(`warp_external_input_check_${int_width}`);
    const intType = parameter.vType;
    assert(intType != undefined);
    const functionStub = createCairoFunctionStub(
      name,
      [['boolValue', intType]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      this.ast,
      parameter,
    );
    return createCallToStub(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(name: string): string {
    const existing = this.generatedBoolCheck.get(name);
    if (existing != undefined) {
      return existing.name;
    }

    this.requireImport('warplib.external_input_checks_ints', name);
    return name;
  }
}

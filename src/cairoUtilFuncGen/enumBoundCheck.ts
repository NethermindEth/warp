import { CairoUtilFuncGenBase } from './base';
import { CairoFunction } from './base';
import {
  EnumDefinition,
  Expression,
  VariableDeclaration,
  UserDefinedTypeName,
  FunctionCall,
} from 'solc-typed-ast';
import assert = require('assert');
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionStubbing';
import { cloneASTNode } from '../utils/cloning';

const INDENT = ' '.repeat(4);

export class EnumBoundCheckGen extends CairoUtilFuncGenBase {
  //Enum -> Assert Code
  private generatedEnumBoundChecks: Map<string, CairoFunction> = new Map();

  getGeneratedCode(): string {
    return [...this.generatedEnumBoundChecks.values()].map((func) => func.code).join('\n\n');
  }

  gen(enumVarDec: VariableDeclaration, functionInput: Expression): FunctionCall {
    assert(enumVarDec.vType instanceof UserDefinedTypeName);
    const enumType = cloneASTNode(enumVarDec.vType, this.ast);
    const enumDef = enumType.vReferencedDeclaration;

    assert(enumDef instanceof EnumDefinition);
    const name = this.getOrCreate(enumDef);

    const enumTypeCloned = cloneASTNode(enumType, this.ast);
    const functionStub = createCairoFunctionStub(
      name,
      [['enumValue', enumTypeCloned]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      this.ast,
      enumVarDec,
    );
    return createCallToFunction(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(enumDef: EnumDefinition): string {
    const key = enumDef.name;
    const existing = this.generatedEnumBoundChecks.get(key);
    if (existing != undefined) {
      return existing.name;
    }

    const name = `ENUM_ASSERT_${enumDef.name}`;
    const numMembers = enumDef.vMembers.length;

    this.generatedEnumBoundChecks.set(name, {
      name: name,
      code: [
        `func ${name}{syscall_ptr: felt*, range_check_ptr : felt}(x : felt):`,
        `${INDENT}let (inRange : felt) = is_le_felt(x, ${numMembers - 1})`,
        `${INDENT}with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          numMembers - 1
        }]."):`,
        `${INDENT.repeat(2)}assert 1 = inRange`,
        `${INDENT}end`,
        `${INDENT}return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt');
    return name;
  }
}

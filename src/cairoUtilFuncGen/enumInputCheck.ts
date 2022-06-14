import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  EnumDefinition,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  getNodeType,
  IntType,
  TypeNode,
} from 'solc-typed-ast';
import { FunctionStubKind } from '../ast/cairoNodes';
import { cloneASTNode } from '../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import { typeNameFromTypeNode } from '../utils/utils';
import { StringIndexedFuncGen } from './base';

export class EnumInputCheck extends StringIndexedFuncGen {
  gen(
    node: Expression,
    nodeInput: Expression,
    enumDef: EnumDefinition,
    nodeInSourceUnit: ASTNode,
  ): FunctionCall {
    const nodeType = getNodeType(node, this.ast.compilerVersion);
    const inputType = getNodeType(nodeInput, this.ast.compilerVersion);

    this.sourceUnit = this.ast.getContainingRoot(nodeInSourceUnit);
    const name = this.getOrCreate(inputType, enumDef);
    const functionStub = createCairoFunctionStub(
      name,
      [['arg', typeNameFromTypeNode(inputType, this.ast), DataLocation.Default]],
      [['ret', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Storage]],
      ['range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? nodeInput,
      FunctionStateMutability.Pure,
      FunctionStubKind.FunctionDefStub,
    );
    const functionInput = cloneASTNode(nodeInput, this.ast);

    this.ast.setContextRecursive(functionInput);
    return createCallToFunction(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(type: TypeNode, enumDef: EnumDefinition): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    assert(type instanceof IntType);
    const funcName = `enum_bound_check${this.generatedFunctions.size}`;
    const implicits = '{range_check_ptr : felt}';
    const nMembers = enumDef.vMembers.length;
    const input256Bits = type.nBits === 256;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(${
          input256Bits ? 'arg_Uint256 : Uint256' : 'arg : felt'
        }) -> (arg: felt):`,
        '    alloc_locals',
        input256Bits ? ['    let (arg) = narrow_safe(arg_Uint256)'].join('\n') : ``,
        `    let (inRange : felt) = is_le_felt(arg, ${nMembers - 1})`,
        `    with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          nMembers - 1
        }]."):`,
        `        assert 1 = inRange`,
        `    end`,
        `    return (arg)`,
        `end`,
      ].join('\n'),
    });
    if (input256Bits) {
      this.requireImport('warplib.maths.utils', 'narrow_safe');
      this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    }
    this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt');
    return funcName;
  }
}

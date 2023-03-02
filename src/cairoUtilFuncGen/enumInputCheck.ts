import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  EnumDefinition,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  IntType,
  TypeNode,
} from 'solc-typed-ast';
import { FunctionStubKind } from '../ast/cairoNodes';
import { createCairoGeneratedFunction, createCallToFunction } from '../utils/functionGeneration';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from './base';

// TODO: Does this enum input check overrides the input check from the general method?!
// It looks like it does
export class EnumInputCheck extends StringIndexedFuncGen {
  // TODO: When is nodeInSourceUnit different thant the current sourceUnit??
  public gen(
    node: Expression,
    nodeInput: Expression,
    enumDef: EnumDefinition,
    nodeInSourceUnit: ASTNode,
  ): FunctionCall {
    const nodeType = safeGetNodeType(node, this.ast.inference);
    const inputType = safeGetNodeType(nodeInput, this.ast.inference);

    this.sourceUnit = this.ast.getContainingRoot(nodeInSourceUnit);
    const funcDef = this.getOrCreateFuncDef(inputType, nodeType, enumDef);
    return createCallToFunction(funcDef, [nodeInput], this.ast);
  }

  public getOrCreateFuncDef(inputType: TypeNode, nodeType: TypeNode, enumDef: EnumDefinition) {
    assert(inputType instanceof IntType);

    const key = enumDef.name + (inputType.nBits === 256 ? '256' : '');
    const exisiting = this.generatedFunctionsDef.get(key);
    if (exisiting !== undefined) {
      return exisiting;
    }

    const funcInfo = this.getOrCreate(inputType, enumDef);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['arg', typeNameFromTypeNode(inputType, this.ast), DataLocation.Default]],
      [['ret', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Default]],
      this.ast,
      this.sourceUnit,
      {
        mutability: FunctionStateMutability.Pure,
        stubKind: FunctionStubKind.FunctionDefStub,
      },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: IntType, enumDef: EnumDefinition) {
    const input256Bits = type.nBits === 256;
    const funcName = `enum_bound_check_${enumDef.name}` + (input256Bits ? '_256' : '');

    const imports = [this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt')];
    if (input256Bits) {
      imports.push(
        this.requireImport('warplib.maths.utils', 'narrow_safe'),
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      );
    }

    const implicits = '{range_check_ptr : felt}';
    const nMembers = enumDef.vMembers.length;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(${
          input256Bits ? 'arg_Uint256 : Uint256' : 'arg : felt'
        }) -> (arg: felt){`,
        '    alloc_locals;',
        input256Bits ? ['    let (arg) = narrow_safe(arg_Uint256);'].join('\n') : ``,
        `    let inRange : felt = is_le_felt(arg, ${nMembers - 1});`,
        `    with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          nMembers - 1
        }]."){`,
        `        assert 1 = inRange;`,
        `    }`,
        `    return (arg,);`,
        `}`,
      ].join('\n'),
      functionsCalled: imports,
    };
    return funcInfo;
  }
}

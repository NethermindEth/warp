import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  FunctionCall,
  FunctionDefinition,
  MemberAccess,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayPushWithoutArgGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = safeGetNodeType(push.vExpression.vExpression, this.ast.inference);
    const elementType = safeGetNodeType(push, this.ast.inference);

    const name = this.getOrCreate(
      CairoType.fromSol(elementType, this.ast, TypeConversionContext.StorageAllocation),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['newElemLoc', typeNameFromTypeNode(elementType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(functionStub, [push.vExpression.vExpression], this.ast);
  }

  private getOrCreate(elementType: CairoType): string {
    const key = elementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
    );

    const arrayInfo = this.dynArrayGen.gen(elementType);
    const lengthName = arrayInfo.name + '_LENGTH';
    const funcName = `${arrayInfo.name}_PUSH`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (newElemLoc: felt){`,
        `    alloc_locals;`,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    ${lengthName}.write(loc, newLen);`,
        `    let (existing) = ${arrayInfo.name}.read(loc, len);`,
        `    if ((existing) == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(used + ${elementType.width});`,
        `        ${arrayInfo.name}.write(loc, len, used);`,
        `        return (used,);`,
        `    }else{`,
        `        return (existing,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcName;
  }
}
